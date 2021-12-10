local _, ns = ...
local oUF = ns.oUF or oUF

local select, pairs, type = select, pairs, type
local abs = math.abs
local format = string.format
local wipe = table.wipe

local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local UnitAura = UnitAura
local UnitCanAttack = UnitCanAttack
local UnitIsCharmed = UnitIsCharmed

local addon = {}
ns.oUF_RaidDebuffs = addon
oUF_RaidDebuffs = ns.oUF_RaidDebuffs
if not oUF_RaidDebuffs then
	oUF_RaidDebuffs = addon
end

local debuff_data = {}
addon.DebuffData = debuff_data

addon.ShowDispellableDebuff = true
addon.FilterDispellableDebuff = true
addon.MatchBySpellName = false

addon.priority = 10

local function add(spell, priority, stackThreshold)
	if addon.MatchBySpellName and type(spell) == "number" then
		spell = GetSpellInfo(spell)
	end

	if spell then
		debuff_data[spell] = {
			priority = (addon.priority + priority),
			stackThreshold = (stackThreshold or 0)
		}
	end
end

function addon:RegisterDebuffs(t)
	for spell, value in pairs(t) do
		if type(t[spell]) == "boolean" then
			local oldValue = t[spell]
			t[spell] = {enable = oldValue, priority = 0, stackThreshold = 0}
		else
			if t[spell].enable then
				add(spell, t[spell].priority or 0, t[spell].stackThreshold or 0)
			end
		end
	end
end

function addon:ResetDebuffData()
	wipe(debuff_data)
end

local playerClass = select(2, UnitClass("player"))

local DispelColor = {
	Magic = {0.2, 0.6, 1},
	Curse = {0.6, 0, 1},
	Disease = {0.6, 0.4, 0},
	Poison = {0, 0.6, 0}
}

local DispelPriority = {
	Magic = 4,
	Curse = 3,
	Disease = 2,
	Poison = 1
}

local DispelFilter
do
	local dispelClasses = {
		PRIEST = {Magic = true, Disease = true},
		SHAMAN = {Magic = false, Curse = true},
		PALADIN = {Poison = true, Magic = false, Disease = true},
		MAGE = {Curse = true},
		DRUID = {Magic = false, Curse = true, Poison = true}
	}

	DispelFilter = dispelClasses[playerClass] or {}
end

local function CheckSpec(self, event, levels)
	if event == "CHARACTER_POINTS_CHANGED" and levels > 0 then return end

	if playerClass == "PALADIN" then
		DispelFilter.Magic = ElvUI[1]:CheckTalent(53551) -- Sacred Cleansing
	elseif playerClass == "SHAMAN" then
		DispelFilter.Magic = ElvUI[1]:CheckTalent(77130) -- Improved Cleanse Spirit
	elseif playerClass == "DRUID" then
		DispelFilter.Magic = ElvUI[1]:CheckTalent(88423) -- Nature's Cure
	end
end

local function formatTime(s)
	if s > 60 then
		return format("%dm", s / 60), s % 60
	elseif s < 1 then
		return format("%.1f", s), s - floor(s)
	else
		return format("%d", s), s - floor(s)
	end
end

local function OnUpdate(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed

	if self.elapsed >= 0.1 then
		local timeLeft = self.endTime - GetTime()

		if self.reverse then
			timeLeft = abs((self.endTime - GetTime()) - self.duration)
		end

		if timeLeft > 0 then
			local text = formatTime(timeLeft)
			self.time:SetText(text)
		else
			self:SetScript("OnUpdate", nil)
			self.time:Hide()
		end

		self.elapsed = 0
	end
end

local function UpdateDebuff(self, name, icon, count, debuffType, duration, endTime, spellId, stackThreshold)
	local element = self.RaidDebuffs

	if name and (count >= stackThreshold) then
		element.icon:SetTexture(icon)
		element.icon:Show()
		element.duration = duration

		if element.count then
			if count and (count > 1) then
				element.count:SetText(count)
				element.count:Show()
			else
				element.count:SetText("")
				element.count:Hide()
			end
		end

		if spellId and ElvUI[1].ReverseTimer[spellId] then
			element.reverse = true
		else
			element.reverse = nil
		end

		if element.time then
			if duration and (duration > 0) then
				element.endTime = endTime
				element.nextUpdate = 0
				element:SetScript("OnUpdate", OnUpdate)
				element.time:Show()
			else
				element:SetScript("OnUpdate", nil)
				element.time:Hide()
			end
		end

		if element.cd then
			if duration and (duration > 0) then
				element.cd:SetCooldown(endTime - duration, duration)
				element.cd:Show()
			else
				element.cd:Hide()
			end
		end

		local c = DispelColor[debuffType] or ElvUI[1].media.bordercolor
		element:SetBackdropBorderColor(c[1], c[2], c[3])

		element:Show()
	else
		element:Hide()
	end
end

local blackList = {
	[9007] = true,		-- Pounce Bleed
	[33876] = true,		-- Mangle (Cat)
	[33878] = true,		-- Mangle (Bear)
	[58567] = true,		-- Sunder Armor
	[77661] = true,		-- Searing Flames
	[94009] = true,		-- Rend
	[105171] = true,	-- Deep Corruption (Dragon Soul: Yor'sahj the Unsleeping)
	[106368] = true,	-- Twilight Shift
	[108220] = true		-- Deep Corruption (Dragon Soul: Shadowed Globule)
}

local function Update(self, event, unit)
	if unit ~= self.unit then return end

	local element = self.RaidDebuffs

	local _name, _icon, _count, _dtype, _duration, _endTime, _spellID, _
	local _stackThreshold, _priority, priority = 0, 0, 0

	--store if the unit its charmed, mind controlled units (Imperial Vizier Zor'lok: Convert)
	local isCharmed = UnitIsCharmed(unit)

	--store if we cand attack that unit, if its so the unit its hostile (Amber-Shaper Un'sok: Reshape Life)
	local canAttack = UnitCanAttack("player", unit)

	for i = 1, 40 do
		local name, _, icon, count, debuffType, duration, expirationTime, _, _, _, spellId = UnitAura(unit, i, "HARMFUL")
		if not name then break end

		--we couldn't dispel if the unit its charmed, or its not friendly
		if addon.ShowDispellableDebuff and (element.showDispellableDebuff ~= false) and debuffType and (not isCharmed) and (not canAttack) then
			if addon.FilterDispellableDebuff then
				DispelPriority[debuffType] = (DispelPriority[debuffType] or 0) + addon.priority --Make Dispel buffs on top of Boss Debuffs

				priority = DispelFilter[debuffType] and DispelPriority[debuffType] or 0
				if priority == 0 then
					debuffType = nil
				end
			else
				priority = DispelPriority[debuffType] or 0
			end

			if priority > _priority then
				_priority, _name, _icon, _count, _dtype, _duration, _endTime, _spellID = priority, name, icon, count, debuffType, duration, expirationTime, spellID
			end
		end

		local debuff
		if element.onlyMatchSpellID then
			debuff = debuff_data[spellID]
		else
			if debuff_data[spellID] then
				debuff = debuff_data[spellID]
			else
				debuff = debuff_data[name]
			end
		end

		priority = debuff and debuff.priority

		if priority and not blackList[spellID] and (priority > _priority) then
			_priority, _name, _icon, _count, _dtype, _duration, _endTime, _spellID = priority, name, icon, count, debuffType, duration, expirationTime, spellID
		end
	end

	if self.RaidDebuffs.forceShow then
		_spellID = 47540
		_name, _, _icon = GetSpellInfo(_spellID)
		_count, _dtype, _duration, _endTime, _stackThreshold = 5, "Magic", 0, 60, 0
	end

	if _name then
		_stackThreshold = debuff_data[addon.MatchBySpellName and _name or _spellID] and debuff_data[addon.MatchBySpellName and _name or _spellID].stackThreshold or _stackThreshold
	end

	UpdateDebuff(self, _name, _icon, _count, _dtype, _duration, _endTime, _spellID, _stackThreshold)

	--Reset the DispelPriority
	DispelPriority.Magic = 4
	DispelPriority.Curse = 3
	DispelPriority.Disease = 2
	DispelPriority.Poison = 1
end

local function Enable(self)
	if playerClass == "DRUID" or playerClass == "PALADIN" or playerClass == "SHAMAN" then
		self:RegisterEvent("PLAYER_TALENT_UPDATE", CheckSpec, true)
		self:RegisterEvent("CHARACTER_POINTS_CHANGED", CheckSpec, true)
	end

	if self.RaidDebuffs then
		self:RegisterEvent("UNIT_AURA", Update)

		return true
	end
end

local function Disable(self)
	if self.RaidDebuffs then
		self:UnregisterEvent("UNIT_AURA", Update)

		self.RaidDebuffs:Hide()
	end

	if playerClass == "DRUID" or playerClass == "PALADIN" or playerClass == "SHAMAN" then
		self:UnregisterEvent("PLAYER_TALENT_UPDATE", CheckSpec)
		self:UnregisterEvent("CHARACTER_POINTS_CHANGED", CheckSpec)
	end
end

oUF:AddElement("RaidDebuffs", Update, Enable, Disable)