local E, L, V, P, G = unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local function OnEvent(self, event, ...)
	if event == "PLAYER_REGEN_ENABLED" then
		self.text:SetText("Out of Combat")
		return;
	elseif event == "PLAYER_REGEN_DISABLED" then
		self.text:SetText("|cffd50202In Combat|r")
		return;
	end
	self.text:SetText("Out of Combat")
end

DT:RegisterDatatext('Combat Indicator', {'PLAYER_ENTERING_WORLD', 'PLAYER_REGEN_ENABLED', 'PLAYER_REGEN_DISABLED'}, OnEvent)