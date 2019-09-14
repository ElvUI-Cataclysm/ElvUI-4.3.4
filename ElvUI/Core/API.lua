local E, L, V, P, G = unpack(select(2, ...))

local _G = _G
local wipe, date = wipe, date
local format, select, type, ipairs, pairs = format, select, type, ipairs, pairs
local strmatch, strfind, tonumber, tostring = strmatch, strfind, tonumber, tostring

local GetCVarBool = GetCVarBool
local GetCombatRatingBonus = GetCombatRatingBonus
local GetFunctionCPUUsage = GetFunctionCPUUsage
local GetPrimaryTalentTree, GetActiveTalentGroup = GetPrimaryTalentTree, GetActiveTalentGroup
local GetSpellInfo = GetSpellInfo
local RequestBattlefieldScoreData = RequestBattlefieldScoreData
local UnitAttackPower = UnitAttackPower
local UnitFactionGroup = UnitFactionGroup
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitHasVehicleUI = UnitHasVehicleUI
local UnitStat = UnitStat
local IsInInstance = IsInInstance
local IsRatedBattleground = IsRatedBattleground
local IsWargame = IsWargame
local GetBattlefieldArenaFaction = GetBattlefieldArenaFaction
local PLAYER_FACTION_GROUP = PLAYER_FACTION_GROUP
local FACTION_HORDE = FACTION_HORDE
local FACTION_ALLIANCE = FACTION_ALLIANCE

do -- other non-english locales require this
	E.UnlocalizedClasses = {}
	for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_MALE) do E.UnlocalizedClasses[v] = k end
	for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_FEMALE) do E.UnlocalizedClasses[v] = k end

	function E:UnlocalizedClassName(className)
		return (className and className ~= "") and E.UnlocalizedClasses[className]
	end
end

function E:IsFoolsDay()
	return strfind(date(), "04/01/") and not E.global.aprilFools
end

function E:ScanTooltipTextures(clean, grabTextures)
	local textures
	for i = 1, 10 do
		local tex = _G["ElvUI_ScanTooltipTexture"..i]
		local texture = tex and tex:GetTexture()
		if texture then
			if grabTextures then
				if not textures then textures = {} end
				textures[i] = texture
			end
			if clean then
				tex:SetTexture()
			end
		end
	end

	return textures
end

function E:CheckTalentTree(tree)
	local activeGroup = GetActiveTalentGroup(false, false)
	if type(tree) == "number" then
		if activeGroup and GetPrimaryTalentTree(activeGroup - 1) then
			return tree == GetPrimaryTalentTree(activeGroup - 1)
		end
	elseif type(tree) == "table" then
		local activeGroup = GetActiveTalentGroup(false, false)
		for _, index in pairs(tree) do
			if activeGroup and GetPrimaryTalentTree(activeGroup - 1) then
				return index == GetPrimaryTalentTree(activeGroup - 1)
			end
		end
	end
end

function E:GetPlayerRole()
	local assignedRole = UnitGroupRolesAssigned("player")

	if assignedRole == "NONE" then
		if self.HealingClasses[self.myclass] ~= nil and self:CheckTalentTree(self.HealingClasses[E.myclass]) then
			return "HEALER"
		elseif E.Role == "Tank" then
			return "TANK"
		else
			return "DAMAGER"
		end
	else
		return assignedRole
	end
end

function E:CheckTalent(spellID)
	local spellName = GetSpellInfo(spellID)
	if not spellName then return nil end

	for i = 1, GetNumTalentTabs() do
		for j = 1, GetNumTalents(i) do
			local name, _, _, _, rank = GetTalentInfo(i, j)
			if name and (name == spellName) then
				if rank and (rank > 0) then
					return true
				else
					return false
				end
			end
		end
	end

	return false
end

function E:CheckRole()
	local talentTree = GetPrimaryTalentTree()
	local resilperc = GetCombatRatingBonus(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN)
	local resilience, role

	if resilperc > GetDodgeChance() and resilperc > GetParryChance() and E.mylevel == MAX_PLAYER_LEVEL then
		resilience = true
	else
		resilience = false
	end

	if type(self.ClassRole[self.myclass]) == "string" then
		role = self.ClassRole[self.myclass]
	elseif talentTree then
		local DeathKnight = (self.myclass == "DEATHKNIGHT" and talentTree == 1) and resilience == false
		local Druid = (E.myclass == "DRUID" and talentTree == 2 and GetBonusBarOffset() == 3)

		if DeathKnight or Druid then
			role = "Tank"
		else
			role = self.ClassRole[self.myclass][talentTree]
		end
	end

	if not role then
		local playerint = select(2, UnitStat("player", 4))
		local playeragi = select(2, UnitStat("player", 2))
		local base, posBuff, negBuff = UnitAttackPower("player")
		local playerap = base + posBuff + negBuff

		if (playerap > playerint) or (playeragi > playerint) then
			role = "Melee"
		else
			role = "Caster"
		end
	end

	if self.Role ~= role then
		self.Role = role
		self.TalentTree = talentTree
		self.callbacks:Fire("RoleChanged")
	end

	if E.myclass == "SHAMAN" and talentTree == 3 then
		if self:CheckTalent(77130) then -- Improved Cleanse Spirit
			self.DispelClasses[self.myclass].Magic = true
		else
			self.DispelClasses[self.myclass].Magic = false
		end
	elseif E.myclass == "DRUID" and talentTree == 3 then
		if self:CheckTalent(88423) then -- Nature's Cure
			self.DispelClasses[self.myclass].Magic = true
		else
			self.DispelClasses[self.myclass].Magic = false
		end
	elseif E.myclass == "PALADIN" and talentTree == 1 then
		if self:CheckTalent(53551) then -- Sacred Cleansing
			self.DispelClasses[self.myclass].Magic = true
		else
			self.DispelClasses[self.myclass].Magic = false
		end
	end
end

function E:IsDispellableByMe(debuffType)
	if not self.DispelClasses[self.myclass] then return end

	if self.DispelClasses[self.myclass][debuffType] then return true end
end

do
	local Masque = E.Libs.Masque
	local MasqueGroupState = {}
	local MasqueGroupToTableElement = {
		["ActionBars"] = {"actionbar", "actionbars"},
		["Pet Bar"] = {"actionbar", "petBar"},
		["Stance Bar"] = {"actionbar", "stanceBar"},
		["Buffs"] = {"auras", "buffs"},
		["Debuffs"] = {"auras", "debuffs"},
		["Reminder"] = {"auras", "reminder"}
	}

	function E:MasqueCallback(Group, _, _, _, _, Disabled)
		if not E.private then return end

		local element = MasqueGroupToTableElement[Group]
		if element then
			if Disabled then
				if E.private[element[1]].masque[element[2]] and MasqueGroupState[Group] == "enabled" then
					E.private[element[1]].masque[element[2]] = false
					E:StaticPopup_Show("CONFIG_RL")
				end
				MasqueGroupState[Group] = "disabled"
			else
				MasqueGroupState[Group] = "enabled"
			end
		end
	end

	if Masque then
		Masque:Register("ElvUI", E.MasqueCallback)
	end
end

do
	local CPU_USAGE = {}
	local function CompareCPUDiff(showall, minCalls)
		local greatestUsage, greatestCalls, greatestName, newName, newFunc
		local greatestDiff, lastModule, mod, usage, calls, diff = 0

		for name, oldUsage in pairs(CPU_USAGE) do
			newName, newFunc = strmatch(name, "^([^:]+):(.+)$")
			if not newFunc then
				E:Print("CPU_USAGE:", name, newFunc)
			else
				if newName ~= lastModule then
					mod = E:GetModule(newName, true) or E
					lastModule = newName
				end
				usage, calls = GetFunctionCPUUsage(mod[newFunc], true)
				diff = usage - oldUsage
				if showall and (calls > minCalls) then
					E:Print("Name("..name..")  Calls("..calls..") Diff("..(diff > 0 and format("%.3f", diff) or 0)..")")
				end
				if (diff > greatestDiff) and calls > minCalls then
					greatestName, greatestUsage, greatestCalls, greatestDiff = name, usage, calls, diff
				end
			end
		end

		if greatestName then
			E:Print(greatestName.." had the CPU usage of: "..(greatestUsage > 0 and format("%.3f", greatestUsage) or 0).."ms. And has been called "..greatestCalls.." times.")
		else
			E:Print("CPU Usage: No CPU Usage differences found.")
		end

		wipe(CPU_USAGE)
	end

	function E:GetTopCPUFunc(msg)
		if not GetCVarBool("scriptProfile") then
			E:Print("For `/cpuusage` to work, you need to enable script profiling via: `/console scriptProfile 1` then reload. Disable after testing by setting it back to 0.")
			return
		end

		local module, showall, delay, minCalls = strmatch(msg, "^(%S+)%s*(%S*)%s*(%S*)%s*(.*)$")
		local checkCore, mod = (not module or module == "") and "E"

		showall = (showall == "true" and true) or false
		delay = (delay == "nil" and nil) or tonumber(delay) or 5
		minCalls = (minCalls == "nil" and nil) or tonumber(minCalls) or 15

		wipe(CPU_USAGE)
		if module == "all" then
			for moduName, modu in pairs(self.modules) do
				for funcName, func in pairs(modu) do
					if (funcName ~= "GetModule") and (type(func) == "function") then
						CPU_USAGE[moduName..":"..funcName] = GetFunctionCPUUsage(func, true)
					end
				end
			end
		else
			if not checkCore then
				mod = self:GetModule(module, true)
				if not mod then
					self:Print(module.." not found, falling back to checking core.")
					mod, checkCore = self, "E"
				end
			else
				mod = self
			end
			for name, func in pairs(mod) do
				if (name ~= "GetModule") and type(func) == "function" then
					CPU_USAGE[(checkCore or module)..":"..name] = GetFunctionCPUUsage(func, true)
				end
			end
		end

		self:Delay(delay, CompareCPUDiff, showall, minCalls)
		self:Print("Calculating CPU Usage differences (module: "..(checkCore or module)..", showall: "..tostring(showall)..", minCalls: "..tostring(minCalls)..", delay: "..tostring(delay)..")")
	end
end

function E:RegisterObjectForVehicleLock(object, originalParent)
	if not object or not originalParent then
		E:Print("Error. Usage: RegisterObjectForVehicleLock(object, originalParent)")
		return
	end

	object = _G[object] or object
	--Entering/Exiting vehicles will often happen in combat.
	--For this reason we cannot allow protected objects.
	if object.IsProtected and object:IsProtected() then
		E:Print("Error. Object is protected and cannot be changed in combat.")
		return
	end

	--Check if we are already in a vehicles
	if UnitHasVehicleUI("player") then
		object:SetParent(E.HiddenFrame)
	end

	--Add object to table
	E.VehicleLocks[object] = originalParent
end

function E:UnregisterObjectForVehicleLock(object)
	if not object then
		E:Print("Error. Usage: UnregisterObjectForVehicleLock(object)")
		return
	end

	object = _G[object] or object
	--Check if object was registered to begin with
	if not E.VehicleLocks[object] then return end

	--Change parent of object back to original parent
	local originalParent = E.VehicleLocks[object]
	if originalParent then
		object:SetParent(originalParent)
	end

	--Remove object from table
	E.VehicleLocks[object] = nil
end

function E:EnterVehicleHideFrames(_, unit)
	if unit ~= "player" then return end

	for object in pairs(E.VehicleLocks) do
		object:SetParent(E.HiddenFrame)
	end
end

function E:ExitVehicleShowFrames(_, unit)
	if unit ~= "player" then return end

	for object, originalParent in pairs(E.VehicleLocks) do
		object:SetParent(originalParent)
	end
end

function E:RequestBGInfo()
	RequestBattlefieldScoreData()
end

function E:PLAYER_ENTERING_WORLD()
	if not self.MediaUpdated then
		self:UpdateMedia()
		self.MediaUpdated = true
	else
		self:ScheduleTimer("CheckRole", 0.01)
	end

	local _, instanceType = IsInInstance()
	if instanceType == "pvp" then
		self.BGTimer = self:ScheduleRepeatingTimer("RequestBGInfo", 5)
		self:RequestBGInfo()
	elseif self.BGTimer then
		self:CancelTimer(self.BGTimer)
		self.BGTimer = nil
	end
end

function E:GetUnitBattlefieldFaction(unit)
	local englishFaction, localizedFaction = UnitFactionGroup(unit)

	-- this might be a rated BG or wargame and if so the player's faction might be altered
	if unit == "player" then
		if IsRatedBattleground() or IsWargame() then
			englishFaction = PLAYER_FACTION_GROUP[GetBattlefieldArenaFaction()]
			localizedFaction = (englishFaction == "Alliance" and FACTION_ALLIANCE) or FACTION_HORDE
		end
	end

	return englishFaction, localizedFaction
end

function E:PLAYER_LEVEL_UP(_, level)
	E.mylevel = level
end

function E:LoadAPI()
	self:ScheduleTimer("CheckRole", 0.01)

	self:RegisterEvent("PLAYER_LEVEL_UP")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "CheckRole")
	self:RegisterEvent("PLAYER_TALENT_UPDATE", "CheckRole")
	self:RegisterEvent("CHARACTER_POINTS_CHANGED", "CheckRole")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED", "CheckRole")
	self:RegisterEvent("UPDATE_BONUS_ACTIONBAR", "CheckRole")
	self:RegisterEvent("UNIT_ENTERED_VEHICLE", "EnterVehicleHideFrames")
	self:RegisterEvent("UNIT_EXITED_VEHICLE", "ExitVehicleShowFrames")
	self:RegisterEvent("UI_SCALE_CHANGED", "PixelScaleChanged")

	if not strfind(date(), "04/01/") then
		E.global.aprilFools = nil
	end

	do -- setup cropIcon texCoords
		local opt = E.db.general.cropIcon
		local modifier = 0.04 * opt
		for i, v in ipairs(E.TexCoords) do
			if i % 2 == 0 then
				E.TexCoords[i] = v - modifier
			else
				E.TexCoords[i] = v + modifier
			end
		end
	end
end