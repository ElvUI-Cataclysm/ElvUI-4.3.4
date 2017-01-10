local E, L, V, P, G = unpack(ElvUI);
local DT = E:GetModule("DataTexts")

local function OnEvent(self, event, ...)
	if event == "PLAYER_REGEN_ENABLED" then
		self.text:SetText(L["Out of Combat"])
		self.text:SetTextColor(1, 1, 1);
		return;
	elseif event == "PLAYER_REGEN_DISABLED" then
		self.text:SetText(L["In Combat"])
		self.text:SetTextColor(1, 0, 0);
		return;
	end
	self.text:SetText(L["Out of Combat"])
	self.text:SetTextColor(1, 1, 1);
end

DT:RegisterDatatext("Combat Indicator", {"PLAYER_ENTERING_WORLD", "PLAYER_REGEN_ENABLED", "PLAYER_REGEN_DISABLED"}, OnEvent)