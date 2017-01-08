local E, L, V, P, G = unpack(select(2, ...));
local DT = E:GetModule("DataTexts")

local select = select;

local displayNumberString = ""
local lastPanel;
local join = string.join

local function OnEvent(self, event, ...)
	self.text:SetFormattedText(displayNumberString, STRENGTH_COLON, select(2, UnitStat("player", 1)))
	lastPanel = self
end

local function ValueColorUpdate(hex)
	displayNumberString = join("", "%s ", hex, "%.f|r")
	
	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true

DT:RegisterDatatext("Strength", {"UNIT_STATS", "UNIT_AURA", "FORGE_MASTER_ITEM_CHANGED", "ACTIVE_TALENT_GROUP_CHANGED", "PLAYER_TALENT_UPDATE"}, OnEvent)
