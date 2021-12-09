local E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule("NamePlates")
local LAI = E.Libs.LAI

local _G = _G
local pcall = pcall
local select, unpack, pairs, next, tonumber, bit = select, unpack, pairs, next, tonumber, bit
local floor = math.floor
local format, find, gsub, match, split = string.format, string.find, string.gsub, string.match, string.split
local twipe = table.wipe

local CreateFrame = CreateFrame
local GetBattlefieldScore = GetBattlefieldScore
local GetNumBattlefieldScores = GetNumBattlefieldScores
local GetNumPartyMembers, GetNumRaidMembers = GetNumPartyMembers, GetNumRaidMembers
local GetPlayerInfoByGUID = GetPlayerInfoByGUID
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local SetCVar = SetCVar
local UnitClass = UnitClass
local UnitExists = UnitExists
local UnitFactionGroup = UnitFactionGroup
local UnitGUID = UnitGUID
local UnitIsFriend = UnitIsFriend
local UnitIsPlayer = UnitIsPlayer
local UnitIsUnit = UnitIsUnit
local UnitReaction = UnitReaction
local UnitName = UnitName
local WorldFrame = WorldFrame
local WorldGetChildren = WorldFrame.GetChildren
local WorldGetNumChildren = WorldFrame.GetNumChildren
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local COMBATLOG_OBJECT_REACTION_HOSTILE = COMBATLOG_OBJECT_REACTION_HOSTILE
local COMBATLOG_OBJECT_CONTROL_PLAYER = COMBATLOG_OBJECT_CONTROL_PLAYER
local  COMBATLOG_OBJECT_CONTROL_NPC = COMBATLOG_OBJECT_CONTROL_NPC

local lastChildern, numChildren, hasTarget = 0, 0
local OVERLAY = [=[Interface\TargetingFrame\UI-TargetingFrame-Flash]=]
local FSPAT = "%s*"..(gsub(gsub(_G.FOREIGN_SERVER_LABEL, "^%s", ""), "[%*()]", "%%%1")).."$"

local playerGUID = UnitGUID("player")

local RaidIconCoordinate = {
	[0] = {[0] = "STAR", [0.25] = "MOON"},
	[0.25] = {[0] = "CIRCLE", [0.25] = "SQUARE"},
	[0.5] = {[0] = "DIAMOND", [0.25] = "CROSS"},
	[0.75] = {[0] = "TRIANGLE", [0.25] = "SKULL"}
}

local RaidTargetReference = {
	["STAR"] = 0x00000001,
	["CIRCLE"] = 0x00000002,
	["DIAMOND"] = 0x00000004,
	["TRIANGLE"] = 0x00000008,
	["MOON"] = 0x00000010,
	["SQUARE"] = 0x00000020,
	["CROSS"] = 0x00000040,
	["SKULL"] = 0x00000080,
}

NP.CreatedPlates = {}
NP.VisiblePlates = {}
NP.Healers = {}

NP.GUIDList = {}
NP.UnitByName = {}
NP.NameByUnit = {}

NP.ENEMY_PLAYER = {}
NP.FRIENDLY_PLAYER = {}
NP.ENEMY_NPC = {}
NP.FRIENDLY_NPC = {}

NP.ResizeQueue = {}

NP.Totems = {}
NP.UniqueUnits = {}

NP.HealerSpecs = {
	[L["Restoration"]] = true,
	[L["Holy"]] = true,
	[L["Discipline"]] = true
}

function NP:CheckBGHealers()
	local _, name, talentSpec

	for i = 1, GetNumBattlefieldScores() do
		name, _, _, _, _, _, _, _, _, _, _, _, _, _, _, talentSpec = GetBattlefieldScore(i)
		if name then
			name = match(name, "([^%-]+).*")

			if name and self.HealerSpecs[talentSpec] then
				self.Healers[name] = talentSpec
			elseif name and self.Healers[name] then
				self.Healers[name] = nil
			end
		end
	end
end

function NP:SetFrameScale(frame, scale, noPlayAnimation)
	if frame.currentScale ~= scale then
		self:Configure_HealthBarScale(frame, scale, noPlayAnimation)
		self:Configure_CastBarScale(frame, scale, noPlayAnimation)
		self:Configure_CPointsScale(frame, scale, noPlayAnimation)
		frame.currentScale = scale
	end
end

function NP:GetPlateFrameLevel(frame)
	local plateLevel
	if frame.plateID then
		plateLevel = 10 + frame.plateID * NP.levelStep
	end

	return plateLevel
end

function NP:SetPlateFrameLevel(frame, level, isTarget)
	if frame and level then
		if isTarget then
			level = 890 --10 higher than the max calculated level of 880
		elseif frame.FrameLevelChanged then
			--calculate Style Filter FrameLevelChanged leveling
			--level method: (10*(40*2)) max 800 + max 80 (40*2) = max 880
			--highest possible should be level 880 and we add 1 to all so 881
			local leveledCount = NP.CollectedFrameLevelCount or 1
			level = (frame.FrameLevelChanged * (40 * NP.levelStep)) + (leveledCount * NP.levelStep)
		end

		frame:SetFrameLevel(level + 1)
		frame.Shadow:SetFrameLevel(frame:GetFrameLevel() - 1)
		frame.Buffs:SetFrameLevel(level + 1)
		frame.Debuffs:SetFrameLevel(level + 1)
	end
end

function NP:ResetNameplateFrameLevel(frame)
	local isTarget = frame.isTarget --frame.isTarget is not the same here so keep this.
	local plateLevel = NP:GetPlateFrameLevel(frame)

	if plateLevel then
		if frame.FrameLevelChanged then --keep how many plates we change, this is reset to 1 post-ResetNameplateFrameLevel
			NP.CollectedFrameLevelCount = (NP.CollectedFrameLevelCount and NP.CollectedFrameLevelCount + 1) or 1
		end

		self:SetPlateFrameLevel(frame, plateLevel, isTarget)
	end
end

function NP:StyleFrame(parent, noBackdrop, point)
	point = point or parent
	local noscalemult = E.mult * UIParent:GetScale()

	if point.bordertop then return end

	if not noBackdrop then
		point.backdrop = parent:CreateTexture(nil, "BACKGROUND")
		point.backdrop:SetAllPoints(point)
		point.backdrop:SetTexture(unpack(E.media.backdropfadecolor))
	end

	if NP.thinBorders then
		point.bordertop = parent:CreateTexture()
		point.bordertop:SetPoint("TOPLEFT", point, "TOPLEFT", -noscalemult, noscalemult)
		point.bordertop:SetPoint("TOPRIGHT", point, "TOPRIGHT", noscalemult, noscalemult)
		point.bordertop:SetHeight(noscalemult)
		point.bordertop:SetTexture(unpack(E.media.bordercolor))

		point.borderbottom = parent:CreateTexture()
		point.borderbottom:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", -noscalemult, -noscalemult)
		point.borderbottom:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", noscalemult, -noscalemult)
		point.borderbottom:SetHeight(noscalemult)
		point.borderbottom:SetTexture(unpack(E.media.bordercolor))

		point.borderleft = parent:CreateTexture()
		point.borderleft:SetPoint("TOPLEFT", point, "TOPLEFT", -noscalemult, noscalemult)
		point.borderleft:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", noscalemult, -noscalemult)
		point.borderleft:SetWidth(noscalemult)
		point.borderleft:SetTexture(unpack(E.media.bordercolor))

		point.borderright = parent:CreateTexture()
		point.borderright:SetPoint("TOPRIGHT", point, "TOPRIGHT", noscalemult, noscalemult)
		point.borderright:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", -noscalemult, -noscalemult)
		point.borderright:SetWidth(noscalemult)
		point.borderright:SetTexture(unpack(E.media.bordercolor))
	else
		point.bordertop = parent:CreateTexture(nil, "OVERLAY")
		point.bordertop:SetPoint("TOPLEFT", point, "TOPLEFT", -noscalemult, noscalemult*2)
		point.bordertop:SetPoint("TOPRIGHT", point, "TOPRIGHT", noscalemult, noscalemult*2)
		point.bordertop:SetHeight(noscalemult)
		point.bordertop:SetTexture(unpack(E.media.bordercolor))

		point.bordertop.backdrop = parent:CreateTexture()
		point.bordertop.backdrop:SetPoint("TOPLEFT", point.bordertop, "TOPLEFT", noscalemult, noscalemult)
		point.bordertop.backdrop:SetPoint("TOPRIGHT", point.bordertop, "TOPRIGHT", -noscalemult, noscalemult)
		point.bordertop.backdrop:SetHeight(noscalemult * 3)
		point.bordertop.backdrop:SetTexture(0, 0, 0)

		point.borderbottom = parent:CreateTexture(nil, "OVERLAY")
		point.borderbottom:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", -noscalemult, -noscalemult*2)
		point.borderbottom:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", noscalemult, -noscalemult*2)
		point.borderbottom:SetHeight(noscalemult)
		point.borderbottom:SetTexture(unpack(E.media.bordercolor))

		point.borderbottom.backdrop = parent:CreateTexture()
		point.borderbottom.backdrop:SetPoint("BOTTOMLEFT", point.borderbottom, "BOTTOMLEFT", noscalemult, -noscalemult)
		point.borderbottom.backdrop:SetPoint("BOTTOMRIGHT", point.borderbottom, "BOTTOMRIGHT", -noscalemult, -noscalemult)
		point.borderbottom.backdrop:SetHeight(noscalemult * 3)
		point.borderbottom.backdrop:SetTexture(0, 0, 0)

		point.borderleft = parent:CreateTexture(nil, "OVERLAY")
		point.borderleft:SetPoint("TOPLEFT", point, "TOPLEFT", -noscalemult*2, noscalemult*2)
		point.borderleft:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", noscalemult*2, -noscalemult*2)
		point.borderleft:SetWidth(noscalemult)
		point.borderleft:SetTexture(unpack(E.media.bordercolor))

		point.borderleft.backdrop = parent:CreateTexture()
		point.borderleft.backdrop:SetPoint("TOPLEFT", point.borderleft, "TOPLEFT", -noscalemult, noscalemult)
		point.borderleft.backdrop:SetPoint("BOTTOMLEFT", point.borderleft, "BOTTOMLEFT", -noscalemult, -noscalemult)
		point.borderleft.backdrop:SetWidth(noscalemult * 3)
		point.borderleft.backdrop:SetTexture(0, 0, 0)

		point.borderright = parent:CreateTexture(nil, "OVERLAY")
		point.borderright:SetPoint("TOPRIGHT", point, "TOPRIGHT", noscalemult*2, noscalemult*2)
		point.borderright:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", -noscalemult*2, -noscalemult*2)
		point.borderright:SetWidth(noscalemult)
		point.borderright:SetTexture(unpack(E.media.bordercolor))

		point.borderright.backdrop = parent:CreateTexture()
		point.borderright.backdrop:SetPoint("TOPRIGHT", point.borderright, "TOPRIGHT", noscalemult, noscalemult)
		point.borderright.backdrop:SetPoint("BOTTOMRIGHT", point.borderright, "BOTTOMRIGHT", noscalemult, -noscalemult)
		point.borderright.backdrop:SetWidth(noscalemult * 3)
		point.borderright.backdrop:SetTexture(0, 0, 0)
	end
end

function NP:StyleFrameColor(frame, r, g, b)
	frame.bordertop:SetTexture(r, g, b)
	frame.borderbottom:SetTexture(r, g, b)
	frame.borderleft:SetTexture(r, g, b)
	frame.borderright:SetTexture(r, g, b)
end

function NP:GetUnitByName(frame, unitType)
	local unit = self.UnitByName[frame.UnitName] or self[unitType][frame.UnitName]

	if unit then
		return unit
	end
end

function NP:GetUnitClassByGUID(frame, guid)
	if not guid then
		guid = self:GetGUIDByName(frame.UnitName, frame.UnitType)
	end

	if guid then
		local _, _, class = pcall(GetPlayerInfoByGUID, guid)

		return class
	end
end

local grenColorToClass = {}
for class, color in pairs(RAID_CLASS_COLORS) do
	grenColorToClass[color.g] = class
end

function NP:UnitClass(frame, unitType)
	if unitType == "FRIENDLY_PLAYER" then
		if frame.unit then
			local _, class = UnitClass(frame.unit)
			if class then
				return class
			end
		else
			return NP:GetUnitClassByGUID(frame, frame.guid)
		end
	elseif unitType == "ENEMY_PLAYER" then
		local _, g = frame.oldHealthBar:GetStatusBarColor()
		return grenColorToClass[floor(g*100 + 0.5) / 100]
	end
end

function NP:UnitDetailedThreatSituation(frame)
	if not frame.Threat:IsShown() then
		if frame.UnitType == "ENEMY_NPC" then
			local r, g = frame.oldName:GetTextColor()
			return (r > 0.5 and g < 0.5) and 0 or nil
		end
	else
		local r, g, b = frame.Threat:GetVertexColor()
		if r > 0 then
			if g > 0 then
				if b > 0 then return 1 end
				return 2
			end
			return 3
		end
	end
end

function NP:UnitLevel(frame)
	local level, boss = frame.oldLevel:GetObjectType() == "FontString" and tonumber(frame.oldLevel:GetText()) or false, frame.BossIcon:IsShown()

	if boss or not level then
		return "??", 0.9, 0, 0
	else
		return level, frame.oldLevel:GetTextColor()
	end
end

function NP:GetUnitInfo(frame)
	local r, g, b = frame.oldHealthBar:GetStatusBarColor()

	if r < 0.01 then
		if b < 0.01 and g > 0.99 then
			return 5, "FRIENDLY_NPC"
		elseif b > 0.99 and g < 0.01 then
			return 5, "FRIENDLY_PLAYER"
		end
	elseif r > 0.99 then
		if b < 0.01 and g > 0.99 then
			return 4, "ENEMY_NPC"
		elseif b < 0.01 and g < 0.01 then
			return 2, "ENEMY_NPC"
		end
	elseif r > 0.5 and r < 0.6 then
		if g > 0.5 and g < 0.6 and b > 0.5 and b < 0.6 then
			return 1, "ENEMY_NPC"
		end
	end

	return 3, "ENEMY_PLAYER"
end

function NP:GetUnitTypeFromUnit(unit)
	local reaction = UnitReaction("player", unit)
	local isPlayer = UnitIsPlayer(unit)

	if isPlayer and UnitIsFriend("player", unit) and reaction and reaction >= 5 then
		return "FRIENDLY_PLAYER"
	elseif not isPlayer and (reaction and reaction >= 5) or UnitFactionGroup(unit) == "Neutral" then
		return "FRIENDLY_NPC"
	elseif not isPlayer and (reaction and reaction <= 4) then
		return "ENEMY_NPC"
	else
		return "ENEMY_PLAYER"
	end
end

function NP:GetGUIDByName(name, unitType)
	for guid, info in pairs(self.GUIDList) do
		if info.name == name and info.unitType == unitType then
			return guid
		end
	end
end

function NP:OnShow(isConfig, dontHideHighlight)
	local frame = self.UnitFrame

	NP:CheckRaidIcon(frame)

	if self:IsShown() then
		NP.VisiblePlates[frame] = 1
	end

	local reaction, unitType = NP:GetUnitInfo(frame)
	local unit = NP:GetUnitByName(frame, unitType)
	local oldUnitType = frame.UnitType

	frame.UnitType = unitType
	frame.UnitName = gsub(frame.oldName:GetText() or "", FSPAT, "")
	frame.UnitReaction = reaction
	frame.UnitClass = NP:UnitClass(frame, unitType)

	if unit then
		frame.unit = unit
		frame.isGroupUnit = true
		frame.guid = UnitGUID(unit)
	else
		frame.guid = NP:GetGUIDByName(frame.UnitName, unitType)
	end

	if unitType ~= oldUnitType or isConfig then
		NP:Update_HealthBar(frame)

		NP:Configure_CPoints(frame, true)
		NP:Configure_Level(frame)
		NP:Configure_Name(frame)
		NP:Configure_Auras(frame, "Buffs")
		NP:Configure_Auras(frame, "Debuffs")

		if NP.db.units[unitType].health.enable or NP.db.alwaysShowTargetHealth then
			NP:Configure_Health(frame, true)
			NP:Configure_CastBar(frame, true)
		end

		NP:Configure_Glow(frame)
		NP:Configure_Elite(frame)
		NP:Configure_Highlight(frame)
		NP:Configure_IconFrame(frame)
	end

	frame.CutawayHealth:Hide()

	NP:RegisterEvents(frame)
	NP:UpdateElement_All(frame, nil, true)

	NP:SetSize(self)

	if not frame.isAlphaChanged then
		if not dontHideHighlight then
			NP:PlateFade(frame, NP.db.fadeIn and 1 or 0, 0, 1)
		end
	end

	frame:Show()

	NP:StyleFilterUpdate(frame, "NAME_PLATE_UNIT_ADDED")
	NP:ForEachVisiblePlate("ResetNameplateFrameLevel") --keep this after `StyleFilterUpdate`
end

function NP:OnHide(isConfig, dontHideHighlight)
	local frame = self.UnitFrame

	NP.VisiblePlates[frame] = nil
	frame.unit = nil
	frame.isGroupUnit = nil

	for i = 1, #frame.Buffs do
		frame.Buffs[i]:SetScript("OnUpdate", nil)
		frame.Buffs[i].timeLeft = nil
		frame.Buffs[i]:Hide()
	end

	for i = 1, #frame.Debuffs do
		frame.Debuffs[i]:SetScript("OnUpdate", nil)
		frame.Debuffs[i].timeLeft = nil
		frame.Debuffs[i]:Hide()
	end

	if isConfig then
		frame.Buffs.anchoredIcons = 0
		frame.Debuffs.anchoredIcons = 0
	end

	NP:StyleFilterClear(frame)

	if frame.currentScale and frame.currentScale ~= 1 then
		NP:SetFrameScale(frame, 1, true)
	end

	if frame.isEventsRegistered then
		NP:UnregisterAllEvents(frame)
	end

	frame.TopIndicator:Hide()
	frame.LeftIndicator:Hide()
	frame.RightIndicator:Hide()
	frame.Shadow:Hide()
	frame.Spark:Hide()
	frame.Health.r, frame.Health.g, frame.Health.b = nil, nil, nil
	frame.Health:Hide()
	frame.CastBar:Hide()
	frame.CastBar.casting = nil
	frame.CastBar.channeling = nil
	frame.CastBar.notInterruptible = nil
	frame.CastBar.spellName = nil
	frame.Level:SetText()
	frame.Name.r, frame.Name.g, frame.Name.b = nil, nil, nil
	frame.Name:SetText()
	frame.Name.NameOnlyGlow:Hide()
	frame.Elite:Hide()
	frame.CPoints:Hide()
	frame.IconFrame:Hide()
	frame:Hide()
	frame.isTarget = nil
	frame.isTargetChanged = false
	frame.isMouseover = nil
	frame.currentScale = nil
	frame.UnitName = nil
	frame.UnitClass = nil
	frame.UnitReaction = nil
	frame.TopLevelFrame = nil
	frame.TopOffset = nil
	frame.ThreatReaction = nil
	frame.guid = nil
	frame.alpha = nil
	frame.isAlphaChanged = nil
	frame.RaidIconType = nil
	frame.ThreatScale = nil
	frame.ThreatStatus = nil

	if not dontHideHighlight then
		frame.oldHighlight:Hide()
	end

	NP:StyleFilterClearVariables(self)
end

function NP:UpdateAllFrame(frame, isConfig, dontHideHighlight)
	frame = frame:GetParent()

	self.OnHide(frame, isConfig, dontHideHighlight)
	self.OnShow(frame, isConfig, dontHideHighlight)
end

function NP:ConfigureAll()
	if not E.private.nameplates.enable then return end

	NP:StyleFilterConfigure()
	NP:ForEachPlate("UpdateAllFrame", true, true)
	NP:UpdateCVars()
end

function NP:ForEachPlate(functionToRun, ...)
	for frame in pairs(self.CreatedPlates) do
		if frame and frame.UnitFrame then
			self[functionToRun](self, frame.UnitFrame, ...)
		end
	end

	if functionToRun == "ResetNameplateFrameLevel" then
		NP.CollectedFrameLevelCount = 1
	end
end

function NP:ForEachVisiblePlate(functionToRun, ...)
	for frame in pairs(self.VisiblePlates) do
		self[functionToRun](self, frame, ...)
	end
end

function NP:UpdateElement_All(frame, noTargetFrame, filterIgnore)
	local healthShown = self.db.units[frame.UnitType].health.enable or (frame.isTarget and self.db.alwaysShowTargetHealth)

	self:Update_HealthBar(frame)

	if healthShown then
		self:Update_Health(frame)
		self:Update_HealthColor(frame)
		self:Update_CastBar(frame, nil, frame.unit)
		self:Update_Auras(frame)
	end

	frame.Name:ClearAllPoints()
	frame.Level:ClearAllPoints()

	self:Update_RaidIcon(frame)
	self:Update_HealerIcon(frame)
	self:Update_Level(frame)
	self:Update_Name(frame)

	if not noTargetFrame then
		self:Update_Elite(frame)
		self:Update_Highlight(frame)
		self:Update_Glow(frame)

		self:SetTargetFrame(frame)
	end

	self:Update_IconFrame(frame)

	if not filterIgnore then
		self:StyleFilterUpdate(frame, "UpdateElement_All")
	end
end

function NP:SetSize(frame)
	if InCombatLockdown() then
		NP.ResizeQueue[frame] = true
	else
		local unitType = frame.UnitFrame.UnitType
		unitType = (unitType == "FRIENDLY_PLAYER" or unitType == "FRIENDLY_NPC") and "friendly" or "enemy"

		if NP.db.clickThrough[unitType] then
			frame:SetSize(0.001, 0.001)
		else
			if unitType == "friendly" then
				frame:SetSize(NP.db.plateSize.friendlyWidth, NP.db.plateSize.friendlyHeight)
			else
				frame:SetSize(NP.db.plateSize.enemyWidth, NP.db.plateSize.enemyHeight)
			end
		end

		NP.ResizeQueue[frame] = nil
	end
end

local plateID = 0
function NP:OnCreated(frame)
	local isDirty = frame.UnitFrame ~= nil
	if isDirty then
		twipe(frame.UnitFrame)
		frame.UnitFrame = nil
	end

	plateID = plateID + 1

	local Health, CastBar = frame:GetChildren()
	local Threat, Border, Highlight, Name, Level, BossIcon, RaidIcon, EliteIcon = frame:GetRegions()
	local _, CastBarBorder, CastBarShield, CastBarIcon = CastBar:GetRegions()

	local unitFrame = CreateFrame("Frame", format("ElvUI_NamePlate%d", plateID), frame)
	frame.UnitFrame = unitFrame

	unitFrame:Hide()
	unitFrame:SetAllPoints()
	unitFrame:SetScript("OnEvent", self.OnEvent)
	unitFrame.plateID = plateID

	unitFrame.Health = self:Construct_Health(unitFrame)
	unitFrame.Health.Highlight = self:Construct_Highlight(unitFrame)
	unitFrame.CutawayHealth = self:Construct_CutawayHealth(unitFrame)
	unitFrame.Level = self:Construct_Level(unitFrame)
	unitFrame.Name = self:Construct_Name(unitFrame)
	unitFrame.CastBar = self:Construct_CastBar(unitFrame)
	unitFrame.Elite = self:Construct_Elite(unitFrame)
	unitFrame.Buffs = self:Construct_Auras(unitFrame, "Buffs")
	unitFrame.Debuffs = self:Construct_Auras(unitFrame, "Debuffs")
	unitFrame.HealerIcon = self:Construct_HealerIcon(unitFrame)
	unitFrame.CPoints = self:Construct_CPoints(unitFrame)
	unitFrame.IconFrame = self:Construct_IconFrame(unitFrame)
	self:Construct_Glow(unitFrame)

	self:QueueObject(Health)
	self:QueueObject(CastBar)
	self:QueueObject(Level)
	self:QueueObject(Name)
	self:QueueObject(Threat)
	self:QueueObject(Border)
	self:QueueObject(CastBarBorder)
	self:QueueObject(CastBarShield)
	self:QueueObject(Highlight)

	CastBarIcon:SetParent(E.HiddenFrame)
	BossIcon:SetAlpha(0)
	EliteIcon:SetAlpha(0)

	unitFrame.oldHealthBar = Health
	unitFrame.oldCastBar = CastBar
	unitFrame.oldCastBar.Shield = CastBarShield
	unitFrame.oldCastBar.Icon = CastBarIcon
	unitFrame.oldName = Name
	unitFrame.oldHighlight = Highlight
	unitFrame.oldLevel = Level

	unitFrame.Threat = Threat
	RaidIcon:SetParent(unitFrame)
	unitFrame.RaidIcon = RaidIcon

	unitFrame.BossIcon = BossIcon
	unitFrame.EliteIcon = EliteIcon

	self.OnShow(frame, true)
	self:SetSize(frame)

	if not isDirty then
		frame:HookScript("OnShow", self.OnShow)
		frame:HookScript("OnHide", self.OnHide)
	end

	Health:HookScript("OnValueChanged", self.Update_HealthOnValueChanged)

	self.CreatedPlates[frame] = true
	self.VisiblePlates[unitFrame] = 1
end

function NP:OnEvent(event, unit, ...)
	if not unit and not self.unit then return end
	if self.unit ~= unit then return end

	NP:Update_CastBar(self, event, unit, ...)
end

function NP:RegisterEvents(frame)
	if not frame.unit then return end

	if self.db.units[frame.UnitType].health.enable or (frame.isTarget and self.db.alwaysShowTargetHealth) then
		if self.db.units[frame.UnitType].castbar.enable then
			frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
			frame:RegisterEvent("UNIT_SPELLCAST_DELAYED")
			frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
			frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
			frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
			frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
			frame:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
			frame:RegisterEvent("UNIT_SPELLCAST_START")
			frame:RegisterEvent("UNIT_SPELLCAST_STOP")
			frame:RegisterEvent("UNIT_SPELLCAST_FAILED")
			frame.isEventsRegistered = true
		end

		NP.OnEvent(frame, nil, frame.unit)
	end
end

function NP:UnregisterAllEvents(frame)
	frame:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	frame:UnregisterEvent("UNIT_SPELLCAST_DELAYED")
	frame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	frame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
	frame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	frame:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
	frame:UnregisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
	frame:UnregisterEvent("UNIT_SPELLCAST_START")
	frame:UnregisterEvent("UNIT_SPELLCAST_STOP")
	frame:UnregisterEvent("UNIT_SPELLCAST_FAILED")
	frame.isEventsRegistered = nil
end

function NP:QueueObject(object)
	local objectType = object:GetObjectType()

	if objectType == "Texture" then
		object:SetTexture("")
		object:SetTexCoord(0, 0, 0, 0)
	elseif objectType == "FontString" then
		object:SetWidth(0.001)
	elseif objectType == "StatusBar" then
		object:SetStatusBarTexture("")
	end

	object:Hide()
end

function NP:PlateFade(nameplate, timeToFade, startAlpha, endAlpha)
	-- we need our own function because we want a smooth transition and dont want it to force update every pass.
	-- its controlled by fadeTimer which is reset when UIFrameFadeOut or UIFrameFadeIn code runs.

	if not nameplate.FadeObject then
		nameplate.FadeObject = {}
	end

	nameplate.FadeObject.timeToFade = (nameplate.isTarget and 0) or timeToFade
	nameplate.FadeObject.startAlpha = startAlpha
	nameplate.FadeObject.endAlpha = endAlpha
	nameplate.FadeObject.diffAlpha = endAlpha - startAlpha

	if nameplate.FadeObject.fadeTimer then
		nameplate.FadeObject.fadeTimer = 0
	else
		E:UIFrameFade(nameplate, nameplate.FadeObject)
	end
end

function NP:SetTargetFrame(frame)
	if hasTarget and frame.alpha == 1 then
		if not frame.isTarget then
			frame.isTarget = true

			self:SetPlateFrameLevel(frame, self:GetPlateFrameLevel(frame), true)

			if self.db.useTargetScale then
				self:SetFrameScale(frame, (frame.ThreatScale or 1) * self.db.targetScale)
			end

			if not frame.isGroupUnit then
				frame.unit = "target"
				frame.guid = UnitGUID("target")

				self:RegisterEvents(frame)
			end

			self:Update_Auras(frame)

			if not self.db.units[frame.UnitType].health.enable and self.db.alwaysShowTargetHealth then
				frame.Health.r, frame.Health.g, frame.Health.b = nil, nil, nil

				self:Configure_Health(frame)
				self:Configure_CastBar(frame)
				self:Configure_Elite(frame)
				self:Configure_CPoints(frame)
				self:RegisterEvents(frame)

				self:UpdateElement_All(frame, true)
			end

			NP:PlateFade(frame, NP.db.fadeIn and 1 or 0, frame:GetAlpha(), 1)

			self:Update_Highlight(frame)
			self:Update_CPoints(frame)
			self:StyleFilterUpdate(frame, "PLAYER_TARGET_CHANGED")

			self:ForEachVisiblePlate("ResetNameplateFrameLevel") --keep this after `StyleFilterUpdate`
		end
	elseif frame.isTarget then
		frame.isTarget = nil

		self:SetPlateFrameLevel(frame, self:GetPlateFrameLevel(frame))

		if self.db.useTargetScale then
			self:SetFrameScale(frame, (frame.ThreatScale or 1))
		end

		if not frame.isGroupUnit then
			frame.unit = nil
			if frame.isEventsRegistered then
				self:UnregisterAllEvents(frame)
				self:Update_CastBar(frame)
			end
		end

		if not self.db.units[frame.UnitType].health.enable then
			self:UpdateAllFrame(frame, nil, true)
		end

		self:Update_CPoints(frame)

		if not frame.AlphaChanged then
			NP:PlateFade(frame, NP.db.fadeIn and 1 or 0, frame:GetAlpha(), hasTarget and NP.db.nonTargetTransparency or 1)
		end

		self:StyleFilterUpdate(frame, "PLAYER_TARGET_CHANGED")

		self:ForEachVisiblePlate("ResetNameplateFrameLevel") --keep this after `StyleFilterUpdate`
	else
		if hasTarget and not frame.isAlphaChanged then
			frame.isAlphaChanged = true

			if not frame.AlphaChanged then
				NP:PlateFade(frame, NP.db.fadeIn and 1 or 0, frame:GetAlpha(), self.db.nonTargetTransparency)
			end

			self:StyleFilterUpdate(frame, "PLAYER_TARGET_CHANGED")
		elseif not hasTarget and frame.isAlphaChanged then
			frame.isAlphaChanged = nil

			if not frame.AlphaChanged then
				NP:PlateFade(frame, NP.db.fadeIn and 1 or 0, frame:GetAlpha(), 1)
			end

			self:StyleFilterUpdate(frame, "PLAYER_TARGET_CHANGED")
		end
	end

	self:Configure_Glow(frame)
	self:Update_Glow(frame)
end

function NP:SetMouseoverFrame(frame)
	if frame.oldHighlight:IsShown() then
		if not frame.isMouseover then
			frame.isMouseover = true

			self:Update_Highlight(frame)

			if not frame.isGroupUnit then
				frame.unit = "mouseover"
				frame.guid = UnitGUID("mouseover")

				self:Update_CastBar(frame, nil, frame.unit)
			end

			self:Update_Auras(frame)
		end
	elseif frame.isMouseover then
		frame.isMouseover = nil

		self:Update_Highlight(frame)

		if not frame.isGroupUnit then
			frame.unit = nil
		end
	end

	self:StyleFilterUpdate(frame, "UNIT_AURA")
end

local function findNewPlate(...)
	for i = lastChildern + 1, numChildren do
		local frame = select(i, ...)
		local region, name = frame:GetRegions(), frame:GetName()
		if (name and find(name, "NamePlate%d")) and (region and region:GetObjectType() == "Texture" and region:GetTexture() == OVERLAY) and not NP.CreatedPlates[frame] then
			NP:OnCreated(frame)
		end
	end
end

function NP:OnUpdate()
	numChildren = WorldGetNumChildren(WorldFrame)
	if lastChildern ~= numChildren then
		findNewPlate(WorldGetChildren(WorldFrame))
		lastChildern = numChildren
	end

	for frame in pairs(NP.VisiblePlates) do
		if hasTarget then
			frame.alpha = frame:GetParent():GetAlpha()
			frame:GetParent():SetAlpha(1)
		else
			frame.alpha = 1
		end

		NP:SetMouseoverFrame(frame)
		NP:SetTargetFrame(frame)

		if frame.UnitReaction ~= NP:GetUnitInfo(frame) then
			NP:UpdateAllFrame(frame, nil, true)
		end

		local status = NP:UnitDetailedThreatSituation(frame)
		if frame.ThreatStatus ~= status then
			frame.ThreatStatus = status

			NP:Update_HealthColor(frame)
		end
	end
end

function NP:CheckRaidIcon(frame)
	if frame.RaidIcon:IsShown() then
		local ux, uy = frame.RaidIcon:GetTexCoord()
		frame.RaidIconType = RaidIconCoordinate[ux][uy]
	else
		frame.RaidIconType = nil
	end
end

function NP:SearchNameplateByGUID(guid)
	for frame in pairs(self.VisiblePlates) do
		if frame.guid == guid then
			return frame
		end
	end
end

function NP:SearchNameplateByName(sourceName)
	if not sourceName then return end
	local SearchFor = split("-", sourceName)
	for frame in pairs(self.VisiblePlates) do
		if frame.UnitName == SearchFor and RAID_CLASS_COLORS[frame.UnitClass] then
			return frame
		end
	end
end

function NP:SearchNameplateByIconName(raidIcon)
	for frame in pairs(self.VisiblePlates) do
		self:CheckRaidIcon(frame)
		if frame.RaidIcon:IsShown() and (frame.RaidIconType == raidIcon) then
			return frame
		end
	end
end

function NP:SearchForFrame(guid, raidIcon, name)
	local frame
	if guid then frame = self:SearchNameplateByGUID(guid) end
	if (not frame) and name then frame = self:SearchNameplateByName(name) end
	if (not frame) and raidIcon then frame = self:SearchNameplateByIconName(raidIcon) end

	return frame
end

function NP:SearchForFrameByFlags(flags, guid, raidFlags, name)
	local frame

	if bit.band(flags, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 then
		if bit.band(flags, COMBATLOG_OBJECT_CONTROL_PLAYER) > 0 then
			frame = self:SearchNameplateByName(name)
		elseif bit.band(flags, COMBATLOG_OBJECT_CONTROL_NPC) > 0 then
			frame = self:SearchNameplateByGUID(guid)
			if not frame then
				local UnitIcon;
				for iconname, bitmask in pairs(RaidTargetReference) do
					if bit.band(raidFlags, bitmask) > 0  then
						UnitIcon = iconname
						break
					end
				end
				frame = self:SearchNameplateByIconName(UnitIcon)
			end
		else
			return
		end
	else
		return
	end

	return frame
end

function NP:UpdateCVars()
	SetCVar("ShowClassColorInNameplate", "1")
	SetCVar("showVKeyCastbar", "1")

	if self.db.motionType == "OVERLAP" then
		SetCVar("nameplateMotion", "0")
	elseif self.db.motionType == "STACKED" then
		SetCVar("nameplateMotion", "1")
	elseif self.db.motionType == "SPREADING" then
		SetCVar("nameplateMotion", "2")
	end
end

local Blacklist = {
	ENEMY_PLAYER = {},
	FRIENDLY_PLAYER = {},
	ENEMY_NPC = {},
	FRIENDLY_NPC = {}
}

function NP:ResetSettings(unit)
	E:CopyTable(NP.db.units[unit], P.nameplates.units[unit])
end

function NP:CopySettings(from, to)
	if from == to then
		E:Print(L["You cannot copy settings from the same unit."])
		return
	end

	E:CopyTable(NP.db.units[to], E:FilterTableFromBlacklist(NP.db.units[from], Blacklist[to]))
end

function NP:PLAYER_ENTERING_WORLD()
	twipe(self.Healers)

	local inInstance, instanceType = IsInInstance()
	if inInstance and (instanceType == "pvp") and self.db.units.ENEMY_PLAYER.markHealers then
		self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE", "CheckBGHealers")
		self.CheckHealerTimer = self:ScheduleRepeatingTimer("CheckBGHealers", 3)
	else
		self:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE")

		if self.CheckHealerTimer then
			self:CancelTimer(self.CheckHealerTimer)
			self.CheckHealerTimer = nil
		end
	end
end

function NP:PLAYER_TARGET_CHANGED()
	hasTarget = UnitExists("target") == 1
end

function NP:UPDATE_MOUSEOVER_UNIT()
	if not UnitIsUnit("mouseover", "player") and UnitIsPlayer("mouseover") then
		local name = UnitName("mouseover")

		local guid = UnitGUID("mouseover")
		local unitType = self:GetUnitTypeFromUnit("mouseover")

		for frame in pairs(self.VisiblePlates) do
			if frame.UnitName == name and frame.UnitType == unitType then
				if not self.GUIDList[guid] then
					self.GUIDList[guid] = {name = name, unitType = frame.UnitType}
					self.OnShow(frame:GetParent(), nil, true)
					break
				end
			end
		end
	end
end

function NP:COMBAT_LOG_EVENT_UNFILTERED(
	_,
	_,
	subevent,
	_,
	sourceGUID,
	sourceName,
	sourceFlags,
	sourceRaidFlags,
	destGUID,
	destName,
	destFlags,
	destRaidFlags,
	...)
	if sourceGUID == playerGUID and destGUID ~= playerGUID then
		if subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH" then
			local frame = self:SearchForFrameByFlags(destFlags, destGUID, destRaidFlags,  destName)

			if frame then
				frame.unit = destGUID
				self:Update_Auras(frame)
			end
		end
	end

	if sourceGUID ~= playerGUID then
		if "UNIT_SPELLCAST_CHANNEL_START" or "UNIT_SPELLCAST_START" then
			local frame = self:SearchForFrameByFlags(sourceFlags, sourceGUID, sourceRaidFlags, sourceName)

			if frame then
				frame.unit = sourceGUID
				self:Update_CastBar(frame, nil, frame.unit)
			end
		end
	end
end

function NP:PLAYER_FOCUS_CHANGED()
	local unitName

	if UnitIsPlayer("focus") and not UnitIsUnit("focus", "player") then
		local name = UnitName("focus")
		local guid = UnitGUID("focus")

		self.UnitByName[name] = "focus"
		self.NameByUnit.focus = name

		if not self.GUIDList[guid] then
			self.GUIDList[guid] = {name = name, unitType = self:GetUnitTypeFromUnit("focus")}
		end

		unitName = name
	elseif self.NameByUnit.focus then
		self.UnitByName[self.NameByUnit.focus] = nil
		unitName = self.NameByUnit.focus
		self.NameByUnit.focus = nil
	end

	if not unitName then return end

	for frame in pairs(self.VisiblePlates) do
		if frame.UnitName == unitName then
			self:UpdateAllFrame(frame, nil, true)
		end
	end
end

function NP:UNIT_COMBO_POINTS(_, unit)
	if unit == "player" or unit == "vehicle" then
		self:ForEachVisiblePlate("Update_CPoints")
	end
end

function NP:PLAYER_REGEN_DISABLED()
	if self.db.showFriendlyCombat == "TOGGLE_ON" then
		SetCVar("nameplateShowFriends", 1)
	elseif self.db.showFriendlyCombat == "TOGGLE_OFF" then
		SetCVar("nameplateShowFriends", 0)
	end

	if self.db.showEnemyCombat == "TOGGLE_ON" then
		SetCVar("nameplateShowEnemies", 1)
	elseif self.db.showEnemyCombat == "TOGGLE_OFF" then
		SetCVar("nameplateShowEnemies", 0)
	end

	NP:ForEachVisiblePlate("StyleFilterUpdate", "PLAYER_REGEN_DISABLED")
end

function NP:PLAYER_REGEN_ENABLED()
	if next(self.ResizeQueue) then
		for frame in pairs(self.ResizeQueue) do
			self:SetSize(frame)
		end
	end

	if self.db.showFriendlyCombat == "TOGGLE_ON" then
		SetCVar("nameplateShowFriends", 0)
	elseif self.db.showFriendlyCombat == "TOGGLE_OFF" then
		SetCVar("nameplateShowFriends", 1)
	end

	if self.db.showEnemyCombat == "TOGGLE_ON" then
		SetCVar("nameplateShowEnemies", 0)
	elseif self.db.showEnemyCombat == "TOGGLE_OFF" then
		SetCVar("nameplateShowEnemies", 1)
	end

	NP:ForEachVisiblePlate("StyleFilterUpdate", "PLAYER_REGEN_ENABLED")
end

function NP:SPELL_UPDATE_COOLDOWN(...)
	NP:ForEachVisiblePlate("StyleFilterUpdate", "SPELL_UPDATE_COOLDOWN")
end

function NP:UNIT_HEALTH(_, unit)
	if unit ~= "player" then return end
	NP:ForEachVisiblePlate("StyleFilterUpdate", "UNIT_HEALTH")
end

function NP:UNIT_POWER(_, unit)
	if unit ~= "player" then return end
	NP:ForEachVisiblePlate("StyleFilterUpdate", "UNIT_POWER")
end

function NP:PLAYER_UPDATE_RESTING()
	NP:ForEachVisiblePlate("StyleFilterUpdate", "PLAYER_UPDATE_RESTING")
end

function NP:LOADING_SCREEN_DISABLED()
	NP:ForEachVisiblePlate("StyleFilterUpdate", "LOADING_SCREEN_DISABLED")
end

function NP:ZONE_CHANGED_NEW_AREA()
	NP:ForEachVisiblePlate("StyleFilterUpdate", "ZONE_CHANGED_NEW_AREA")
end

function NP:ZONE_CHANGED_INDOORS()
	NP:ForEachVisiblePlate("StyleFilterUpdate", "ZONE_CHANGED_INDOORS")
end

function NP:ZONE_CHANGED()
	NP:ForEachVisiblePlate("StyleFilterUpdate", "ZONE_CHANGED")
end

function NP:RAID_TARGET_UPDATE()
	for frame in pairs(self.VisiblePlates) do
		NP:CheckRaidIcon(frame)
		NP:StyleFilterUpdate(frame, "RAID_TARGET_UPDATE")
	end
end

function NP:CacheArenaUnits()
	twipe(self.ENEMY_PLAYER)
	twipe(self.ENEMY_NPC)

	for i = 1, 5 do
		if UnitExists("arena"..i) then
			local unit = format("arena%d", i)
			self.ENEMY_PLAYER[UnitName(unit)] = unit
		end
		if UnitExists("arenapet"..i) then
			local unit = format("arenapet%d", i)
			self.ENEMY_NPC[UnitName(unit)] = unit
		end
	end
end

function NP:CacheGroupUnits()
	twipe(self.FRIENDLY_PLAYER)

	if GetNumRaidMembers() > 0 then
		for i = 1, 40 do
			if UnitExists("raid"..i) then
				local unit = format("raid%d", i)
				self.FRIENDLY_PLAYER[UnitName(unit)] = unit
			end
		end
	elseif GetNumPartyMembers() > 0 then
		for i = 1, 5 do
			if UnitExists("party"..i) then
				local unit = format("party%d", i)
				self.FRIENDLY_PLAYER[UnitName(unit)] = unit
			end
		end
	end
end

function NP:CacheGroupPetUnits()
	twipe(self.FRIENDLY_NPC)
	twipe(self.ENEMY_NPC)

	for i = 1, 5 do
		if UnitExists("arenapet"..i) then
			local unit = format("arenapet%d", i)
			self.ENEMY_NPC[UnitName(unit)] = unit
		end
	end

	if GetNumRaidMembers() > 0 then
		for i = 1, 40 do
			if UnitExists("raidpet"..i) then
				local unit = format("raidpet%d", i)
				self.FRIENDLY_NPC[UnitName(unit)] = unit
			end
		end
	elseif GetNumPartyMembers() > 0 then
		for i = 1, 5 do
			if UnitExists("partypet"..i) then
				local unit = format("partypet%d", i)
				self.FRIENDLY_NPC[UnitName(unit)] = unit
			end
		end
	end
end

function NP:Initialize()
	self.db = E.db.nameplates

	if not E.private.nameplates.enable then return end
	self.Initialized = true

	self.thinBorders = NP.db.thinBorders

	--Add metatable to all our StyleFilters so they can grab default values if missing
	self:StyleFilterInitialize()

	--Populate `NP.StyleFilterEvents` with events Style Filters will be using and sort the filters based on priority.
	self:StyleFilterConfigure()

	self.levelStep = 2

	self:UpdateCVars()

	self.Frame = CreateFrame("Frame"):SetScript("OnUpdate", self.OnUpdate)

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_LOGOUT")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED")
	self:RegisterEvent("PLAYER_UPDATE_RESTING")
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("UNIT_POWER")
	self:RegisterEvent("UNIT_COMBO_POINTS")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	self:RegisterEvent("RAID_TARGET_UPDATE")
	self:RegisterEvent("LOADING_SCREEN_DISABLED")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("ZONE_CHANGED_INDOORS")
	self:RegisterEvent("ZONE_CHANGED")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	-- Arena & Arena Pets
	self:CacheArenaUnits()
	self:RegisterEvent("ARENA_OPPONENT_UPDATE", "CacheArenaUnits")
	-- Group
	self:CacheGroupUnits()
	self:RegisterEvent("PARTY_MEMBERS_CHANGED", "CacheGroupUnits")
	self:RegisterEvent("RAID_ROSTER_UPDATE", "CacheGroupUnits")
	-- Group Pets
	self:CacheGroupPetUnits()
	self:RegisterEvent("UNIT_NAME_UPDATE", "CacheGroupPetUnits")

	LAI.UnregisterAllCallbacks(self)
	LAI.RegisterCallback(self, "LibAuraInfo_AURA_APPLIED")
	LAI.RegisterCallback(self, "LibAuraInfo_AURA_REMOVED")
	LAI.RegisterCallback(self, "LibAuraInfo_AURA_REFRESH")
	LAI.RegisterCallback(self, "LibAuraInfo_AURA_APPLIED_DOSE")
	LAI.RegisterCallback(self, "LibAuraInfo_AURA_CLEAR")
	LAI.RegisterCallback(self, "LibAuraInfo_UNIT_AURA")
end

local function InitializeCallback()
	NP:Initialize()
end

E:RegisterModule(NP:GetName(), InitializeCallback)