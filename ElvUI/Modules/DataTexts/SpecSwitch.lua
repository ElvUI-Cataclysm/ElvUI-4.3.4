local E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule("DataTexts")

local select = select
local format, join = string.format, string.join

local GetActiveTalentGroup = GetActiveTalentGroup
local GetNumTalentTabs = GetNumTalentTabs
local GetTalentTabInfo = GetTalentTabInfo
local GetNumTalentGroups = GetNumTalentGroups
local GetPrimaryTalentTree = GetPrimaryTalentTree
local HideUIPanel, ShowUIPanel = HideUIPanel, ShowUIPanel
local ACTIVE_PETS = ACTIVE_PETS
local FACTION_INACTIVE = FACTION_INACTIVE

local displayString = ""
local activeString = join("", "|cff00FF00" , ACTIVE_PETS, "|r")
local inactiveString = join("", "|cffFF0000", FACTION_INACTIVE, "|r")
local lastPanel, active
local talent = {}

local function LoadTalentTrees()
	for i = 1, GetNumTalentGroups(false, false) do
		talent[i] = {}
		for j = 1, GetNumTalentTabs(false, false) do
			talent[i][j] = select(5, GetTalentTabInfo(j, false, false, i))
		end
	end
end

local function OnEvent(self)
	if not GetTalentTabInfo(1) then return end

	LoadTalentTrees()

	active = GetActiveTalentGroup(false, false)
	if GetPrimaryTalentTree(false, false, active) then
		self.text:SetFormattedText(displayString, select(2, GetTalentTabInfo(GetPrimaryTalentTree(false, false, active))), talent[active][1], talent[active][2], talent[active][3])
	end

	lastPanel = self
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	for i = 1, GetNumTalentGroups() do
		if GetPrimaryTalentTree(false, false, i) then
			DT.tooltip:AddDoubleLine(join("", format(displayString, select(2, GetTalentTabInfo(GetPrimaryTalentTree(false, false, i))), talent[i][1], talent[i][2], talent[i][3])), (i == active and activeString or inactiveString), 1, 1, 1)
		end
	end

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddDoubleLine(join("", L["Left Click:"]), L["Change Talent Specialization"], 1, 1, 1)
	DT.tooltip:AddDoubleLine(join("", L["Right Click:"]), L["Show Talent Specialization UI"], 1, 1, 1)

	DT.tooltip:Show()
end

local function OnClick(_, btn)
	if not PlayerTalentFrame then LoadAddOn("Blizzard_TalentUI") end

	if btn == "LeftButton" then
		DT.tooltip:Hide()

		SetActiveTalentGroup(active == 1 and 2 or 1)
	elseif btn == "RightButton" then
		DT.tooltip:Hide()

		if not PlayerTalentFrame:IsShown() then
			ShowUIPanel(PlayerTalentFrame)
		else
			HideUIPanel(PlayerTalentFrame)
		end
	end
end

local function ValueColorUpdate(hex)
	displayString = join("", "|cffFFFFFF%s:|r ", hex, "%d/|r", hex, "%d/|r", hex, "%d|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext("Spec Switch", {"PLAYER_ENTERING_WORLD", "CHARACTER_POINTS_CHANGED", "PLAYER_TALENT_UPDATE", "ACTIVE_TALENT_GROUP_CHANGED"}, OnEvent, nil, OnClick, OnEnter, nil, L["Talent Specialization"])