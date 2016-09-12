local E, L, V, P, G = unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local displayNumberString = ''
local lastPanel;
local join = string.join

local function OnEvent(self, event, ...)

	local stat  = UnitStat("player", 4)
	self.text:SetFormattedText(displayNumberString, L['Intellect: '], stat)

	lastPanel = self
end

local function ValueColorUpdate(hex)
	displayNumberString = string.join("", "%s", hex, "%.f|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

local events = {
	"UNIT_STATS",
	"UNIT_AURA",
	"FORGE_MASTER_ITEM_CHANGED",
	"ACTIVE_TALENT_GROUP_CHANGED",
	"PLAYER_TALENT_UPDATE",
}

DT:RegisterDatatext('Intellect', events, OnEvent)