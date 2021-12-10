local E, L, V, P, G = unpack(select(2, ...))
local DB = E:GetModule("DataBars")
local LSM = E.Libs.LSM

local max, min = math.max, math.min
local format = string.format

local GetNumQuestLogEntries = GetNumQuestLogEntries
local GetQuestLogRewardXP = GetQuestLogRewardXP
local GetQuestLogSelection = GetQuestLogSelection
local GetQuestLogTitle = GetQuestLogTitle
local GetXPExhaustion = GetXPExhaustion
local GetZoneText = GetZoneText
local IsXPUserDisabled = IsXPUserDisabled
local SelectQuestLogEntry = SelectQuestLogEntry
local UnitXP = UnitXP
local UnitXPMax = UnitXPMax

local function getQuestXP(completedOnly, zoneOnly)
	local lastQuestLogID = GetQuestLogSelection()
	local zoneText = GetZoneText()
	local totalExp = 0
	local locationName

	for questIndex = 1, GetNumQuestLogEntries() do
		SelectQuestLogEntry(questIndex)
		local title, _, _, _, isHeader, _, isComplete, _, questID = GetQuestLogTitle(questIndex)

		if isHeader then
			locationName = title
		elseif (not completedOnly or isComplete) and (not zoneOnly or locationName == zoneText) then
			totalExp = totalExp + GetQuestLogRewardXP(questID)
		end
	end

	SelectQuestLogEntry(lastQuestLogID)

	return totalExp
end

function DB:ExperienceBar_QuestXPUpdate(event)
	if event == "ZONE_CHANGED_NEW_AREA" and not DB.db.experience.questCurrentZoneOnly then return end

	DB.questTotalXP = getQuestXP(DB.db.experience.questCompletedOnly, DB.db.experience.questCurrentZoneOnly)

	if DB.questTotalXP > 0 then
		DB.expBar.questBar:SetMinMaxValues(0, DB.expBar.maxExp)
		DB.expBar.questBar:SetValue(min(DB.expBar.curExp + DB.questTotalXP, DB.expBar.maxExp))
		DB.expBar.questBar:Show()
	else
		DB.expBar.questBar:Hide()
	end
end

function DB:ExperienceBar_Update(event)
	if not DB.db.experience.enable then return end

	local hideBar = (DB.playerLevel == DB.maxExpansionLevel and DB.db.experience.hideAtMaxLevel) or DB.expDisabled

	if hideBar or (event == "PLAYER_REGEN_DISABLED" and DB.db.experience.hideInCombat) then
		E:DisableMover(DB.expBar.mover:GetName())
		DB.expBar:Hide()
	elseif not hideBar and (not DB.db.experience.hideInCombat or not DB.inCombatLockdown) then
		E:EnableMover(DB.expBar.mover:GetName())
		DB.expBar:Show()

		if DB.db.experience.hideInVehicle then
			E:RegisterObjectForVehicleLock(DB.expBar, E.UIParent)
		else
			E:UnregisterObjectForVehicleLock(DB.expBar)
		end

		local textFormat = DB.db.experience.textFormat
		local curExp = UnitXP("player")
		local maxExp = max(1, UnitXPMax("player"))
		local rested = GetXPExhaustion()

		DB.expBar.curExp = curExp
		DB.expBar.maxExp = maxExp

		DB.expBar.statusBar:SetMinMaxValues(min(0, curExp), maxExp)
		DB.expBar.statusBar:SetValue(curExp)

		if rested and rested > 0 then
			DB.expBar.rested:SetMinMaxValues(0, maxExp)
			DB.expBar.rested:SetValue(min(curExp + rested, maxExp))

			if textFormat == "PERCENT" then
				DB.expBar.text:SetFormattedText("%d%% R:%d%%", curExp / maxExp * 100, rested / maxExp * 100)
			elseif textFormat == "CURMAX" then
				DB.expBar.text:SetFormattedText("%s - %s R:%s", E:ShortValue(curExp), E:ShortValue(maxExp), E:ShortValue(rested))
			elseif textFormat == "CURPERC" then
				DB.expBar.text:SetFormattedText("%s - %d%% R:%s [%d%%]", E:ShortValue(curExp), curExp / maxExp * 100, E:ShortValue(rested), rested / maxExp * 100)
			elseif textFormat == "CUR" then
				DB.expBar.text:SetFormattedText("%s R:%s", E:ShortValue(curExp), E:ShortValue(rested))
			elseif textFormat == "REM" then
				DB.expBar.text:SetFormattedText("%s R:%s", E:ShortValue(maxExp - curExp), E:ShortValue(rested))
			elseif textFormat == "CURREM" then
				DB.expBar.text:SetFormattedText("%s - %s R:%s", E:ShortValue(curExp), E:ShortValue(maxExp - curExp), E:ShortValue(rested))
			elseif textFormat == "CURPERCREM" then
				DB.expBar.text:SetFormattedText("%s - %d%% (%s) R:%s", E:ShortValue(curExp), curExp / maxExp * 100, E:ShortValue(maxExp - curExp), E:ShortValue(rested))
			elseif textFormat == "NONE" then
				DB.expBar.text:SetFormattedText("")
			end
		else
			DB.expBar.rested:SetMinMaxValues(0, 1)
			DB.expBar.rested:SetValue(0)

			if textFormat == "PERCENT" then
				DB.expBar.text:SetFormattedText("%d%%", curExp / maxExp * 100)
			elseif textFormat == "CURMAX" then
				DB.expBar.text:SetFormattedText("%s - %s", E:ShortValue(curExp), E:ShortValue(maxExp))
			elseif textFormat == "CURPERC" then
				DB.expBar.text:SetFormattedText("%s - %d%%", E:ShortValue(curExp), curExp / maxExp * 100)
			elseif textFormat == "CUR" then
				DB.expBar.text:SetFormattedText("%s", E:ShortValue(curExp))
			elseif textFormat == "REM" then
				DB.expBar.text:SetFormattedText("%s", E:ShortValue(maxExp - curExp))
			elseif textFormat == "CURREM" then
				DB.expBar.text:SetFormattedText("%s - %s", E:ShortValue(curExp), E:ShortValue(maxExp - curExp))
			elseif textFormat == "CURPERCREM" then
				DB.expBar.text:SetFormattedText("%s - %d%% (%s)", E:ShortValue(curExp), curExp / maxExp * 100, E:ShortValue(maxExp - curExp))
			elseif textFormat == "NONE" then
				DB.expBar.text:SetFormattedText("")
			end
		end
	end
end

function DB:ExperienceBar_OnEnter()
	if DB.db.experience.mouseover then
		E:UIFrameFadeIn(self, 0.4, self:GetAlpha(), 1)
	end

	local curExp = UnitXP("player")
	local maxExp = max(1, UnitXPMax("player"))
	local rested = GetXPExhaustion()

	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR", 0, -4)

	GameTooltip:AddDoubleLine(L["Experience"], format("%s %d", L["Level"], E.mylevel))
	GameTooltip:AddLine(" ")

	GameTooltip:AddDoubleLine(L["XP:"], format("%d / %d (%d%%)", curExp, maxExp, curExp / maxExp * 100), 1, 1, 1)
	GameTooltip:AddDoubleLine(L["Remaining:"], format("%d (%d%% - %d %s)", maxExp - curExp, (maxExp - curExp) / maxExp * 100, 20 * (maxExp - curExp) / maxExp, L["Bars"]), 1, 1, 1)

	if rested then
		GameTooltip:AddDoubleLine(L["Rested:"], format("+%d (%d%%)", rested, rested / maxExp * 100), 1, 1, 1)
	end

	if DB.questXPEnabled and DB.db.experience.questTooltip then
		GameTooltip:AddDoubleLine(L["Quest Log XP:"], DB.questTotalXP, 1, 1, 1)
	end

	GameTooltip:Show()
end

function DB:ExperienceBar_OnClick() end

function DB:ExperienceBar_UpdateDimensions()
	local db = DB.db.experience
	local texture = LSM:Fetch("statusbar", db.statusbar)

	DB.expBar:Size(db.width, db.height)
	DB.expBar:SetTemplate(db.transparent and "Transparent")
	DB.expBar:SetAlpha(db.mouseover and 0 or 1)
	DB.expBar:EnableMouse(not db.clickThrough)
	DB.expBar:SetFrameLevel(db.frameLevel)
	DB.expBar:SetFrameStrata(db.frameStrata)

	DB.expBar.text:FontTemplate(LSM:Fetch("font", db.font), db.textSize, db.fontOutline)
	DB.expBar.text:ClearAllPoints()
	DB.expBar.text:Point(db.textAnchorPoint, db.textXOffset, db.textYOffset)

	DB.expBar.statusBar:SetStatusBarTexture(texture)
	DB.expBar.statusBar:SetOrientation(db.orientation)
	DB.expBar.statusBar:SetReverseFill(db.reverseFill)
	DB.expBar.statusBar:SetRotatesTexture(db.orientation ~= "HORIZONTAL")
	DB.expBar.statusBar:SetStatusBarColor(db.expColor.r, db.expColor.g, db.expColor.b, db.expColor.a)

	DB.expBar.rested:SetStatusBarTexture(texture)
	DB.expBar.rested:SetOrientation(db.orientation)
	DB.expBar.rested:SetReverseFill(db.reverseFill)
	DB.expBar.rested:SetRotatesTexture(db.orientation ~= "HORIZONTAL")
	DB.expBar.rested:SetStatusBarColor(db.restedColor.r, db.restedColor.g, db.restedColor.b, db.restedColor.a)

	DB.expBar.questBar:SetStatusBarTexture(texture)
	DB.expBar.questBar:SetOrientation(db.orientation)
	DB.expBar.questBar:SetReverseFill(db.reverseFill)
	DB.expBar.questBar:SetRotatesTexture(db.orientation ~= "HORIZONTAL")
	DB.expBar.questBar:SetStatusBarColor(db.questColor.r, db.questColor.g, db.questColor.b, db.questColor.a)

	if DB.expBar.bubbles then
		DB:UpdateBarBubbles(DB.expBar, db)
	elseif db.showBubbles then
		local bubbles = DB:CreateBarBubbles(DB.expBar)
		bubbles:SetFrameLevel(5)
		DB:UpdateBarBubbles(DB.expBar, db)
	end
end

function DB:ExperienceBar_Toggle()
	if DB.db.experience.enable and (DB.playerLevel ~= DB.maxExpansionLevel or not DB.db.experience.hideAtMaxLevel) then
		DB.playerLevel = E.mylevel
		DB.expDisabled = IsXPUserDisabled()

		DB.expBar.eventFrame:RegisterEvent("DISABLE_XP_GAIN")
		DB.expBar.eventFrame:RegisterEvent("ENABLE_XP_GAIN")

		if not DB.expDisabled then
			DB.expBar.eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
			DB.expBar.eventFrame:RegisterEvent("PLAYER_XP_UPDATE")
			DB.expBar.eventFrame:RegisterEvent("UPDATE_EXHAUSTION")
			DB.expBar.eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
			DB.expBar.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		end

		DB:ExperienceBar_Update()
		DB:ExperienceBar_QuestXPToggle()
		E:EnableMover(DB.expBar.mover:GetName())
	else
		DB.expBar.eventFrame:UnregisterEvent("DISABLE_XP_GAIN")
		DB.expBar.eventFrame:UnregisterEvent("ENABLE_XP_GAIN")

		if not DB.expDisabled then
			DB.expBar.eventFrame:UnregisterEvent("PLAYER_LEVEL_UP")
			DB.expBar.eventFrame:UnregisterEvent("PLAYER_XP_UPDATE")
			DB.expBar.eventFrame:UnregisterEvent("UPDATE_EXHAUSTION")
			DB.expBar.eventFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
			DB.expBar.eventFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
		end

		DB:ExperienceBar_QuestXPToggle()
		DB.expBar:Hide()
		E:DisableMover(DB.expBar.mover:GetName())
	end
end

function DB:ExperienceBar_QuestXPToggle(event)
	if not DB.questXPEnabled and not DB.expDisabled and DB.db.experience.questXP then
		DB.questXPEnabled = true

		DB.expBar.eventFrame:RegisterEvent("QUEST_LOG_UPDATE")
		DB.expBar.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		DB.expBar.eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

		DB:ExperienceBar_QuestXPUpdate(event)
	elseif DB.questXPEnabled and (DB.expDisabled or not DB.db.experience.questXP) then
		DB.questXPEnabled = false

		DB.expBar.eventFrame:UnregisterEvent("QUEST_LOG_UPDATE")
		DB.expBar.eventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
		DB.expBar.eventFrame:UnregisterEvent("ZONE_CHANGED_NEW_AREA")

		DB.expBar.questBar:Hide()
	end
end

function DB:ExperienceBar_Load()
	DB.expBar = DB:CreateBar("ElvUI_ExperienceBar", DB.ExperienceBar_OnEnter, DB.ExperienceBar_OnClick, "LEFT", LeftChatPanel, "RIGHT", -E.Border + E.Spacing * 3, 0)
	DB.expBar:RegisterForClicks("RightButtonUp")

	DB.expBar.statusBar:SetFrameLevel(4)

	DB.expBar.rested = CreateFrame("StatusBar", "$parent_Rested", DB.expBar)
	DB.expBar.rested:SetFrameLevel(3)
	DB.expBar.rested:SetInside()
	E:RegisterStatusBar(DB.expBar.rested)

	DB.expBar.questBar = CreateFrame("StatusBar", "$parent_Quest", DB.expBar)
	DB.expBar.questBar:SetFrameLevel(2)
	DB.expBar.questBar:SetInside()
	DB.expBar.questBar:Hide()
	E:RegisterStatusBar(DB.expBar.questBar)

	DB.expBar.eventFrame = CreateFrame("Frame")
	DB.expBar.eventFrame:Hide()
	DB.expBar.eventFrame:SetScript("OnEvent", function(self, event, arg1)
		if event == "PLAYER_LEVEL_UP" then
			DB.playerLevel = arg1
			DB.forceUpdateQuestXP = true
		elseif event == "PLAYER_XP_UPDATE" then
			DB:ExperienceBar_Update(event)

			if DB.forceUpdateQuestXP and DB.questXPEnabled and DB.db.experience.questXP then
				DB.forceUpdateQuestXP = nil
				DB:ExperienceBar_QuestXPUpdate(event)
			end
		elseif event == "PLAYER_REGEN_DISABLED" then
			DB.inCombatLockdown = true

			if DB.db.experience.hideInCombat then
				DB:ExperienceBar_Update(event)
			end
		elseif event == "PLAYER_REGEN_ENABLED" then
			DB.inCombatLockdown = false
			if DB.db.experience.hideInCombat then
				DB:ExperienceBar_Update(event)
			end
		elseif event == "ENABLE_XP_GAIN" then
			DB.expDisabled = false

			self:RegisterEvent("PLAYER_LEVEL_UP")
			self:RegisterEvent("PLAYER_XP_UPDATE")
			self:RegisterEvent("UPDATE_EXHAUSTION")
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
			self:RegisterEvent("PLAYER_REGEN_ENABLED")

			DB:ExperienceBar_Update(event)
			DB:ExperienceBar_QuestXPToggle(event)
		elseif event == "DISABLE_XP_GAIN" then
			DB.expDisabled = true

			self:UnregisterEvent("PLAYER_LEVEL_UP")
			self:UnregisterEvent("PLAYER_XP_UPDATE")
			self:UnregisterEvent("UPDATE_EXHAUSTION")
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")

			DB:ExperienceBar_Update(event)
			DB:ExperienceBar_QuestXPToggle(event)
		elseif event == "QUEST_LOG_UPDATE" or event == "ZONE_CHANGED_NEW_AREA" then
			DB:ExperienceBar_QuestXPUpdate(event)
		elseif event == "PLAYER_ENTERING_WORLD" then
			self:UnregisterEvent(event)
			DB:ExperienceBar_QuestXPUpdate(event)
		end
	end)

	DB:ExperienceBar_UpdateDimensions()

	E:CreateMover(DB.expBar, "ExperienceBarMover", L["Experience Bar"], nil, nil, nil, nil, nil, "databars,experience")
	DB:ExperienceBar_Toggle()
end