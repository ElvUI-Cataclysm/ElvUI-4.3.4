local E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule("DataTexts")

local select = select
local join = string.join

local UnitStat = UnitStat
local SPIRIT_COLON = SPIRIT_COLON
local ITEM_MOD_SPIRIT_SHORT = ITEM_MOD_SPIRIT_SHORT

local displayString = ""
local lastPanel

local function OnEvent(self)
	self.text:SetFormattedText(displayString, SPIRIT_COLON, select(2, UnitStat("player", 5)))

	lastPanel = self
end

local function ValueColorUpdate(hex)
	displayString = join("", "%s ", hex, "%.f|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext("Spirit", {"UNIT_STATS", "UNIT_AURA", "FORGE_MASTER_ITEM_CHANGED", "ACTIVE_TALENT_GROUP_CHANGED", "PLAYER_TALENT_UPDATE"}, OnEvent, nil, nil, nil, nil, ITEM_MOD_SPIRIT_SHORT)