local E, L, V, P, G, _ = unpack(ElvUI);
local addon = E:GetModule("AddOnSkins");

if(not addon:CheckAddOn("Omen")) then return; end

function addon:Omen()
	Omen.db.profile.Bar.Spacing = 1;
	Omen.db.profile.Background.EdgeSize = 1;
	Omen.db.profile.Background.BarInset = 2;
	Omen.db.profile.TitleBar.UseSameBG = true;
	Omen.db.profile.TitleBar.Height = 22;

	OmenTitle:SetTemplate("Default", true);
	OmenBarList:SetTemplate("Default");
end

addon:RegisterSkin("Omen", addon.Omen);