local E, L, V, P, G, _ = unpack(ElvUI);
local addon = E:GetModule("AddOnSkins");

if(not addon:CheckAddOn("Spy")) then return; end

function addon:Spy()
	local S = E:GetModule("Skins");

	Spy_MainWindow:StripTextures();
	Spy_MainWindow:SetTemplate("Transparent");

	Spy_AlertWindow:StripTextures();
	Spy_AlertWindow:SetTemplate("Transparent");
	Spy_AlertWindow:Point('TOP', UIParent, 'TOP', 0, -130)

	S:HandleCloseButton(Spy_MainWindow.CloseButton);

end

addon:RegisterSkin("Spy", addon.Spy);