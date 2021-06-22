local E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule("DataTexts")

local select = select
local join = string.join

local UnitStat = UnitStat
local STRENGTH_COLON = STRENGTH_COLON
local ITEM_MOD_STRENGTH_SHORT = ITEM_MOD_STRENGTH_SHORT

local displayString = ""
local lastPanel

local function OnEvent(self)
	self.text:SetFormattedText(displayString, STRENGTH_COLON, select(2, UnitStat("player", 1)))

	lastPanel = self
end

local function ValueColorUpdate(hex)
	displayString = join("", "%s ", hex, "%.f|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext("Strength", {"UNIT_STATS", "UNIT_AURA", "FORGE_MASTER_ITEM_CHANGED", "ACTIVE_TALENT_GROUP_CHANGED", "PLAYER_TALENT_UPDATE"}, OnEvent, nil, nil, nil, nil, ITEM_MOD_STRENGTH_SHORT)