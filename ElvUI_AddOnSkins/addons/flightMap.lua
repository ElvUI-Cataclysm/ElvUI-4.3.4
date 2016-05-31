local E, L, V, P, G, _ = unpack(ElvUI);
local addon = E:GetModule("AddOnSkins");

if(not addon:CheckAddOn("FlightMap")) then return; end

function addon:FlightMap()
	FlightMapTimesFrame:StripTextures();
	FlightMapTimesFrame:CreateBackdrop("Default");
	
	FlightMapTimesFrame:SetStatusBarTexture(E.media.glossTex);
	E:RegisterStatusBar(FlightMapTimesFrame);
	
	FlightMapTimesText:ClearAllPoints();
	FlightMapTimesText:SetPoint("CENTER", FlightMapTimesFrame, "CENTER", 0, 0);
	
	local S = E:GetModule("Skins");
	local base = "InterfaceOptionsFlightMapPanel";
	for optid, option in pairs(FLIGHTMAP_OPTIONS) do
		S:HandleCheckBox(_G[base .. "Option" .. optid]);
	end
end

addon:RegisterSkin("FlightMap", addon.FlightMap);