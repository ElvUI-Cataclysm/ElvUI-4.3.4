local E, L, V, P, G = unpack(select(2, ...));
local DT = E:GetModule("DataTexts")

local format, join = string.format, string.join;

local GetCombatRating = GetCombatRating;
local GetPrimaryTalentTree = GetPrimaryTalentTree;
local GetTalentTreeMasterySpells = GetTalentTreeMasterySpells;
local STAT_MASTERY = STAT_MASTERY;

local lastPanel;
local displayString = "";

local function OnEvent(self)
	lastPanel = self;

	if(GetCombatRating(CR_MASTERY) ~= 0 and GetPrimaryTalentTree()) then
		self.text:SetFormattedText(displayString, STAT_MASTERY, GetMastery());
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self);
	DT.tooltip:ClearLines();

	local masteryKnown = IsSpellKnown(CLASS_MASTERY_SPELLS[E.myclass]);
	local primaryTalentTree = GetPrimaryTalentTree();

	if(masteryKnown and primaryTalentTree) then
		local masterySpell = GetTalentTreeMasterySpells(primaryTalentTree);
		if(masterySpell) then
			DT.tooltip:AddSpellByID(masterySpell);
		end
	end

	DT.tooltip:Show();
end

local function ValueColorUpdate(hex)
	displayString = join("", "%s: ", hex, "%.2f|r");

	if(lastPanel ~= nil) then
		OnEvent(lastPanel);
	end
end

E["valueColorUpdateFuncs"][ValueColorUpdate] = true

DT:RegisterDatatext("Mastery", {"MASTERY_UPDATE"}, OnEvent, nil, nil, OnEnter)