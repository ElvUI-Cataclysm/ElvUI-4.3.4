local E, L, V, P, G = unpack(select(2, ...))
local DB = E:GetModule("DataBars")
local LSM = E.Libs.LSM

local _G = _G
local max = math.max
local format = string.format

local GetWatchedFactionInfo = GetWatchedFactionInfo
local ToggleCharacter = ToggleCharacter

local FACTION_BAR_COLORS = FACTION_BAR_COLORS
local REPUTATION = REPUTATION
local STANDING = STANDING
local UNKNOWN = UNKNOWN

function DB:ReputationBar_Update(event)
	if not DB.db.reputation.enable then return end

	local name, standingID, minRep, maxRep, value = GetWatchedFactionInfo()

	if not name or (event == "PLAYER_REGEN_DISABLED" and DB.db.reputation.hideInCombat) then
		E:DisableMover(DB.repBar.mover:GetName())
		DB.repBar:Hide()
	elseif name and (not DB.db.reputation.hideInCombat or not DB.inCombatLockdown) then
		E:EnableMover(DB.repBar.mover:GetName())
		DB.repBar:Show()

		if DB.db.reputation.hideInVehicle then
			E:RegisterObjectForVehicleLock(DB.repBar, E.UIParent)
		else
			E:UnregisterObjectForVehicleLock(DB.repBar)
		end

		local textFormat = DB.db.reputation.textFormat
		local standing = _G["FACTION_STANDING_LABEL"..standingID] or UNKNOWN
		local color = (DB.db.reputation.useCustomFactionColors and DB.db.reputation.factionColors[standingID] or FACTION_BAR_COLORS[standingID]) or FACTION_BAR_COLORS[1]
		local maxMinDiff = max(1, maxRep - minRep)

		DB.repBar.statusBar:SetStatusBarColor(color.r, color.g, color.b, DB.db.reputation.reputationAlpha or 1)
		DB.repBar.statusBar:SetMinMaxValues(minRep, maxRep)
		DB.repBar.statusBar:SetValue(value)

		if textFormat == "PERCENT" then
			DB.repBar.text:SetFormattedText("%s: %d%% [%s]", name, ((value - minRep) / maxMinDiff * 100), standing)
		elseif textFormat == "CURMAX" then
			DB.repBar.text:SetFormattedText("%s: %s - %s [%s]", name, E:ShortValue(value - minRep), E:ShortValue(maxRep - minRep), standing)
		elseif textFormat == "CURPERC" then
			DB.repBar.text:SetFormattedText("%s: %s - %d%% [%s]", name, E:ShortValue(value - minRep), ((value - minRep) / maxMinDiff * 100), standing)
		elseif textFormat == "CUR" then
			DB.repBar.text:SetFormattedText("%s: %s [%s]", name, E:ShortValue(value - minRep), standing)
		elseif textFormat == "REM" then
			DB.repBar.text:SetFormattedText("%s: %s [%s]", name, E:ShortValue((maxRep - minRep) - (value - minRep)), standing)
		elseif textFormat == "CURREM" then
			DB.repBar.text:SetFormattedText("%s: %s - %s [%s]", name, E:ShortValue(value - minRep), E:ShortValue((maxRep - minRep) - (value - minRep)), standing)
		elseif textFormat == "CURPERCREM" then
			DB.repBar.text:SetFormattedText("%s: %s - %d%% (%s) [%s]", name, E:ShortValue(value - minRep), ((value - minRep) / maxMinDiff * 100), E:ShortValue((maxRep - minRep) - (value - minRep)), standing)
		elseif textFormat == "NONE" then
			DB.repBar.text:SetFormattedText("")
		end
	end
end

function DB:ReputationBar_OnEnter()
	if DB.db.reputation.mouseover then
		E:UIFrameFadeIn(self, 0.4, self:GetAlpha(), 1)
	end

	local name, reaction, minRep, maxRep, value = GetWatchedFactionInfo()
	if name then
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR", 0, -4)
		GameTooltip:AddLine(name)
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(STANDING..":", _G["FACTION_STANDING_LABEL"..reaction], 1, 1, 1)
		GameTooltip:AddDoubleLine(REPUTATION..":", format("%d / %d (%d%%)", value - minRep, maxRep - minRep, (value - minRep) / ((maxRep - minRep == 0) and maxRep or (maxRep - minRep)) * 100), 1, 1, 1)
		GameTooltip:Show()
	end
end

function DB:ReputationBar_OnClick()
	ToggleCharacter("ReputationFrame")
end

function DB:ReputationBar_UpdateDimensions()
	local db = DB.db.reputation

	DB.repBar:Size(db.width, db.height)
	DB.repBar:SetTemplate(db.transparent and "Transparent")
	DB.repBar:SetAlpha(db.mouseover and 0 or 1)
	DB.repBar:EnableMouse(not db.clickThrough)
	DB.repBar:SetFrameLevel(db.frameLevel)
	DB.repBar:SetFrameStrata(db.frameStrata)

	DB.repBar.text:FontTemplate(LSM:Fetch("font", db.font), db.textSize, db.fontOutline)
	DB.repBar.text:ClearAllPoints()
	DB.repBar.text:Point(db.textAnchorPoint, db.textXOffset, db.textYOffset)

	DB.repBar.statusBar:SetStatusBarTexture(LSM:Fetch("statusbar", db.statusbar))
	DB.repBar.statusBar:SetOrientation(db.orientation)
	DB.repBar.statusBar:SetReverseFill(db.reverseFill)
	DB.repBar.statusBar:SetRotatesTexture(db.orientation ~= "HORIZONTAL")

	if DB.repBar.bubbles then
		DB:UpdateBarBubbles(DB.repBar, DB.db.reputation)
	elseif DB.db.reputation.showBubbles then
		local bubbles = DB:CreateBarBubbles(DB.repBar)
		bubbles:SetFrameLevel(5)
		DB:UpdateBarBubbles(DB.repBar, DB.db.reputation)
	end
end

function DB:ReputationBar_Toggle()
	if DB.db.reputation.enable then
		DB.repBar.eventFrame:RegisterEvent("UPDATE_FACTION")
		DB.repBar.eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
		DB.repBar.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

		DB:ReputationBar_Update()
		E:EnableMover(DB.repBar.mover:GetName())
	else
		DB.repBar.eventFrame:UnregisterEvent("UPDATE_FACTION")
		DB.repBar.eventFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
		DB.repBar.eventFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")

		DB.repBar:Hide()
		E:DisableMover(DB.repBar.mover:GetName())
	end
end

function DB:ReputationBar_Load()
	DB.repBar = DB:CreateBar("ElvUI_ReputationBar", DB.ReputationBar_OnEnter, DB.ReputationBar_OnClick, "RIGHT", RightChatPanel, "LEFT", E.Border - E.Spacing * 3, 0)

	DB.repBar.eventFrame = CreateFrame("Frame")
	DB.repBar.eventFrame:Hide()
	DB.repBar.eventFrame:SetScript("OnEvent", function(_, event)
		if event == "PLAYER_REGEN_DISABLED" then
			DB.inCombatLockdown = true
		elseif event == "PLAYER_REGEN_ENABLED" then
			DB.inCombatLockdown = false
		end

		DB:ReputationBar_Update(event)
	end)

	DB:ReputationBar_UpdateDimensions()

	E:CreateMover(DB.repBar, "ReputationBarMover", L["Reputation Bar"], nil, nil, nil, nil, nil, "databars,reputation")
	DB:ReputationBar_Toggle()
end