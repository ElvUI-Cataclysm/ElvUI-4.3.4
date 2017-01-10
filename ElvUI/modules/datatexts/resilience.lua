local E, L, V, P, G = unpack(select(2, ...));
local DT = E:GetModule("DataTexts");

local join = string.join;

local GetCombatRatingBonus = GetCombatRatingBonus;
local COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN = COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN;
local STAT_RESILIENCE = STAT_RESILIENCE;

local displayNumberString = "";
local resilTag = STAT_RESILIENCE..": ";
local lastPanel;

local function OnEvent(self)
	local ratingBonus = GetCombatRatingBonus(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN);

	self.text:SetFormattedText(displayNumberString, resilTag, ratingBonus);
	lastPanel = self;
end

local function ValueColorUpdate(hex)
	displayNumberString = join("", "%s", hex, "%.2f%%|r")

	if(lastPanel ~= nil) then
		OnEvent(lastPanel);
	end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true;

DT:RegisterDatatext("Resilience", {"COMBAT_RATING_UPDATE"}, OnEvent);