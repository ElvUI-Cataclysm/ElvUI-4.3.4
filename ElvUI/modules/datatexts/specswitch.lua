local E, L, V, P, G = unpack(select(2, ...));
local DT = E:GetModule("DataTexts")

local select = select;
local format, join = string.format, string.join;

local GetNumTalentTabs = GetNumTalentTabs;
local GetTalentTabInfo = GetTalentTabInfo;
local GetNumTalentGroups = GetNumTalentGroups;
local GetPrimaryTalentTree = GetPrimaryTalentTree;

local lastPanel, active
local displayString = "";
local talent = {}
local activeString = join("", "|cff00FF00" , ACTIVE_PETS, "|r")
local inactiveString = join("", "|cffFF0000", FACTION_INACTIVE, "|r")

local function LoadTalentTrees()
	for i = 1, GetNumTalentGroups(false, false) do
		talent[i] = {}
		for j = 1, GetNumTalentTabs(false, false) do
			talent[i][j] = select(5, GetTalentTabInfo(j, false, false, i))
		end
	end
end

local function OnEvent(self)
	lastPanel = self
	if not GetTalentTabInfo(1) then
		return
	end

	LoadTalentTrees()

	active = GetActiveTalentGroup(false, false)
	if GetPrimaryTalentTree(false, false, active) then
		self.text:SetFormattedText(displayString, select(2, GetTalentTabInfo(GetPrimaryTalentTree(false, false, active))), talent[active][1], talent[active][2], talent[active][3])
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	for i = 1, GetNumTalentGroups() do
		if GetPrimaryTalentTree(false, false, i) then
			DT.tooltip:AddLine(join(" ", format(displayString, select(2, GetTalentTabInfo(GetPrimaryTalentTree(false, false, i))), talent[i][1], talent[i][2], talent[i][3]), (i == active and activeString or inactiveString)),1,1,1)
		end
	end

	DT.tooltip:Show()
end

local function OnClick(self)
	SetActiveTalentGroup(active == 1 and 2 or 1)
end

local function ValueColorUpdate(hex)
	displayString = join("", "|cffFFFFFF%s:|r ", hex, "%d|r / ", hex, "%d|r / ", hex, "%d|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end

E["valueColorUpdateFuncs"][ValueColorUpdate] = true

DT:RegisterDatatext("Spec Switch", {"PLAYER_ENTERING_WORLD", "CHARACTER_POINTS_CHANGED", "PLAYER_TALENT_UPDATE", "ACTIVE_TALENT_GROUP_CHANGED"}, OnEvent, nil, OnClick, OnEnter)