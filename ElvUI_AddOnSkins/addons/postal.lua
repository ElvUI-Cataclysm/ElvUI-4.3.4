local E, L, V, P, G, _ = unpack(ElvUI);
local addon = E:GetModule("AddOnSkins");

if(not addon:CheckAddOn("Postal")) then return; end

function addon:Postal(event)
	local S = E:GetModule("Skins");

	InboxPrevPageButton:Point('CENTER', InboxFrame, 'BOTTOMLEFT', 45, 112)
	InboxNextPageButton:Point('CENTER', InboxFrame, 'BOTTOMLEFT', 295, 112)

	for i = 1, INBOXITEMS_TO_DISPLAY do
		local item = _G['MailItem'..i..'ExpireTime']
		if item then
			item:SetPoint('TOPRIGHT', 'MailItem'..i, 'TOPRIGHT', -5, -10);
			if item.returnicon then
				item.returnicon:SetPoint('TOPRIGHT', item, 'TOPRIGHT', 20, 0);
			end
		end
		if _G['PostalInboxCB'..i] then
			S:HandleCheckBox(_G['PostalInboxCB'..i]);
		end
	end

	if PostalSelectOpenButton then
		S:HandleButton(PostalSelectOpenButton, true);
		PostalSelectOpenButton:Point('RIGHT', InboxFrame, 'TOP', -41, -48)
	end

	if Postal_OpenAllMenuButton then
		S:HandleNextPrevButton(Postal_OpenAllMenuButton, true);
		Postal_OpenAllMenuButton:SetPoint('LEFT', PostalOpenAllButton, 'RIGHT', 5, 0)
	end

	if PostalOpenAllButton then
		S:HandleButton(PostalOpenAllButton, true);
		PostalOpenAllButton:Point('CENTER', InboxFrame, 'TOP', -34, -400)
	end

	if PostalSelectReturnButton then
		S:HandleButton(PostalSelectReturnButton, true);
		PostalSelectReturnButton:Point('LEFT', InboxFrame, 'TOP', -5, -48)
	end

	if Postal_ModuleMenuButton then
		S:HandleNextPrevButton(Postal_ModuleMenuButton, true);
		Postal_ModuleMenuButton:SetPoint('TOPRIGHT', MailFrame, -30, -4)
	end

	if Postal_BlackBookButton then
		S:HandleNextPrevButton(Postal_BlackBookButton, true);
		Postal_BlackBookButton:SetPoint('LEFT', SendMailNameEditBox, 'RIGHT', 5, 2)
	end

	addon:SecureHook(Postal, "CreateAboutFrame", function()
		if PostalAboutFrame then
			PostalAboutFrame:StripTextures();
			PostalAboutFrame:SetTemplate("Transparent");
			if PostalAboutScroll then
				S:HandleScrollBar(PostalAboutScrollScrollBar);
			end
			local closeButton = select(2, PostalAboutFrame:GetChildren());
			if closeButton then
				S:HandleCloseButton(closeButton);
			end
		end
	end);
end

addon:RegisterSkin("Postal", addon.Postal);