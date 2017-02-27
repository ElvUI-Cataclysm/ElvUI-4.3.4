local E, L, V, P, G = unpack(select(2, ...));
local DT = E:GetModule("DataTexts");

local format, join = string.format, string.join;

local GetCombatRatingBonus = GetCombatRatingBonus;
local GetCombatRating = GetCombatRating;
local COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN = COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN;
local STAT_RESILIENCE = STAT_RESILIENCE;
local ToggleCharacter = ToggleCharacter;

local displayNumberString = "";
local lastPanel;

local function OnEvent(self)
	local ratingBonus = GetCombatRatingBonus(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN);

	self.text:SetFormattedText(displayNumberString, STAT_RESILIENCE, ratingBonus);
	lastPanel = self;
end

local function OnClick()
	ToggleCharacter("PaperDollFrame");
end

local function OnEnter(self)
	DT:SetupTooltip(self);

	local resilienceRating = GetCombatRating(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN);

	DT.tooltip:AddDoubleLine(STAT_RESILIENCE, format("%d", resilienceRating), 1, 1, 1);

	DT.tooltip:Show();
end

local function ValueColorUpdate(hex)
	displayNumberString = join("", "%s: ", hex, "%.2f%%|r")

	if(lastPanel ~= nil) then
		OnEvent(lastPanel);
	end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true;

DT:RegisterDatatext("Resilience", {"COMBAT_RATING_UPDATE"}, OnEvent, nil, OnClick, OnEnter)