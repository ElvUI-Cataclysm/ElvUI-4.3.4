local E, L, V, P, G = unpack(select(2, ...));
local DT = E:GetModule("DataTexts")

local format, join = string.format, string.join;
local lastPanel
local displayString = "";

local function OnEvent(self)
	lastPanel = self
	local masteryspell, masteryTag
	if GetCombatRating(CR_MASTERY) ~= 0 and GetPrimaryTalentTree() then
		masteryTag = STAT_MASTERY..": "
		self.text:SetFormattedText(displayString, masteryTag, GetMastery())
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self)
	DT.tooltip:ClearLines()

	local mastery = GetMastery();
	local masteryBonus = GetCombatRatingBonus(CR_MASTERY);
	mastery = format("%.2f", mastery);

	local masteryKnown = IsSpellKnown(CLASS_MASTERY_SPELLS[E.myclass]);
	local primaryTalentTree = GetPrimaryTalentTree();
	if (masteryKnown and primaryTalentTree) then
		local masterySpell, masterySpell2 = GetTalentTreeMasterySpells(primaryTalentTree);
		if (masterySpell) then
			DT.tooltip:AddSpellByID(masterySpell);
		end
	end
	DT.tooltip:Show()
end

local function ValueColorUpdate(hex)
	displayString = join("", "%s", hex, "%.2f|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end

E["valueColorUpdateFuncs"][ValueColorUpdate] = true

DT:RegisterDatatext("Mastery", {"MASTERY_UPDATE"}, OnEvent, nil, nil, OnEnter)