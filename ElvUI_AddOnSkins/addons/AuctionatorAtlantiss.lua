local E, L, V, P, G, _ = unpack(ElvUI);
local addon = E:GetModule("AddOnSkins");

if(not addon:CheckAddOn("AuctionatorAtlantiss")) then return; end

function addon:AuctionatorAtlantiss(event)
	local S = E:GetModule("Skins");	

	if event == 'PLAYER_ENTERING_WORLD' then
		return
	end
	
	if event == 'AUCTION_HOUSE_SHOW' then
		AuctionatorScrollFrame:StripTextures()
		Atr_Main_Panel.bg = CreateFrame("Frame", nil, Atr_Main_Panel)
		Atr_Main_Panel.bg:SetTemplate("Default")
		Atr_Main_Panel.bg:Point("TOPLEFT", 5, -212)
		Atr_Main_Panel.bg:Point("BOTTOMRIGHT", 45, 38)
		Atr_Main_Panel.bg:SetFrameLevel(Atr_Main_Panel.bg:GetFrameLevel() - 2)
		
		Atr_Hlist:StripTextures();
		Atr_Hlist:CreateBackdrop("Default");
		Atr_Hlist.backdrop:SetFrameLevel(Atr_Hlist.backdrop:GetFrameLevel() - 1)
		Atr_Hlist:SetWidth(194);
		Atr_Hlist:ClearAllPoints()
		Atr_Hlist:Point("TOPLEFT", -195, -75);
	
		S:HandleButton(Atr_AddToSListButton)
		S:HandleButton(Atr_RemFromSListButton)
		S:HandleButton(Atr_SrchSListButton)
		Atr_SrchSListButton:Width(196)
	
		S:HandleButton(Atr_MngSListsButton)
		Atr_MngSListsButton:Width(196)
	
		S:HandleButton(Atr_NewSListButton)
		Atr_NewSListButton:Width(196)
	
		S:HandleButton(Atr_Buy1_Button)
		Atr_Buy1_Button:Point("RIGHT", AuctionatorCloseButton, "LEFT", -5, 0)
	
		S:HandleButton(Atr_CancelSelectionButton)
		Atr_CancelSelectionButton:Point("RIGHT", Atr_Buy1_Button, "LEFT", -5, 0)
	
		S:HandleButton(AuctionatorCloseButton)
		S:HandleButton(Auctionator1Button)
		S:HandleButton(Atr_Search_Button)
		S:HandleButton(Atr_Adv_Search_Button)
	
		S:HandleTab(AuctionFrameTab4)
		S:HandleTab(AuctionFrameTab5)
		S:HandleTab(AuctionFrameTab6)
	
		Atr_HeadingsBar:StripTextures();
		Atr_HeadingsBar:SetHeight(20);
		Atr_HeadingsBar:ClearAllPoints()
		Atr_HeadingsBar:SetPoint("TOP", AuctionatorScrollFrame, "TOP", 10, 19)
	
		Atr_ListTabs:SetPoint("BOTTOMRIGHT", Atr_HeadingsBar, "TOPRIGHT", -10, 10)
		
		for i = 1, 3 do
			local tab = _G["Atr_ListTabsTab"..i];
			tab:StripTextures();
			S:HandleButton(tab);
		end

		S:HandleDropDownBox(Atr_DropDownSL)
		S:HandleButton(Atr_DropDownSLButton)
	
		S:HandleEditBox(Atr_Search_Box)

		S:HandleScrollBar(AuctionatorScrollFrameScrollBar)
	
		for i=1, 12 do
			_G["AuctionatorEntry"..i]:StyleButton()
		end
	
		for i=1, 20 do
			_G["AuctionatorHEntry"..i]:StyleButton()
		end
	
		S:HandleScrollBar(Atr_Hlist_ScrollFrameScrollBar)
	
		Atr_Hilite1:StripTextures()
	
		Atr_Col1_Heading_Button:StyleButton()
		Atr_Col1_Heading_Button:SetPoint("TOPLEFT", Atr_HeadingsBar, "TOPLEFT", 25, 3)
	
		Atr_Col3_Heading_Button:StyleButton()
		Atr_Col3_Heading_Button:SetPoint("TOPLEFT", Atr_HeadingsBar, "TOPLEFT", 190, 3)

		Atr_SellControls:CreateBackdrop("Default")
		Atr_SellControls.backdrop:SetPoint("TOPLEFT", -2, 0)
		Atr_SellControls.backdrop:SetPoint("BOTTOMRIGHT", 23, 0)
		Atr_SellControls.backdrop:SetFrameLevel(Atr_SellControls.backdrop:GetFrameLevel() - 2)
	
		Atr_Main_Panel:CreateBackdrop("Default")
		Atr_Main_Panel.backdrop:SetPoint("TOPLEFT", 5, -75)
		Atr_Main_Panel.backdrop:SetPoint("BOTTOMRIGHT", 45, 260)
	
		S:HandleButton(Atr_Back_Button)
		Atr_Back_Button:SetPoint("TOPLEFT", Atr_HeadingsBar, "TOPLEFT", 10, 30)
	
		S:HandleButton(Atr_CreateAuctionButton)
	
		S:HandleEditBox(Atr_StackPriceGold);
		S:HandleEditBox(Atr_StackPriceSilver);
		S:HandleEditBox(Atr_StackPriceCopper);
		S:HandleEditBox(Atr_ItemPriceGold);
		S:HandleEditBox(Atr_ItemPriceSilver);
		S:HandleEditBox(Atr_ItemPriceCopper);
		S:HandleEditBox(Atr_Batch_NumAuctions);
		S:HandleEditBox(Atr_Batch_Stacksize);
	
		S:HandleDropDownBox(Atr_Duration)
	
		Atr_SellControls_Tex:SetTemplate('Default', true)
		Atr_SellControls_Tex:StyleButton()
	
		Atr_SellControls_Tex:SetScript("OnUpdate", function()
			if Atr_SellControls_Tex:GetNormalTexture() then
				Atr_SellControls_Tex:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
				Atr_SellControls_Tex:GetNormalTexture():ClearAllPoints()
				Atr_SellControls_Tex:GetNormalTexture():Point("TOPLEFT", 2, -2)
				Atr_SellControls_Tex:GetNormalTexture():Point("BOTTOMRIGHT", -2, 2)
			end
		end)
	
		Atr_RecommendItem_Tex:SetTemplate('Default', true)
		Atr_RecommendItem_Tex:StyleButton()
	
		Atr_RecommendItem_Tex:SetScript("OnUpdate", function()
			if Atr_RecommendItem_Tex:GetNormalTexture() then
				Atr_RecommendItem_Tex:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
				Atr_RecommendItem_Tex:GetNormalTexture():ClearAllPoints()
				Atr_RecommendItem_Tex:GetNormalTexture():Point("TOPLEFT", 2, -2)
				Atr_RecommendItem_Tex:GetNormalTexture():Point("BOTTOMRIGHT", -2, 2)
			end
		end)

		S:HandleButton(Atr_CheckActiveButton)
		Atr_CheckActiveButton:SetWidth(196);

		Atr_Buy_Confirm_Frame:StripTextures()
		Atr_Buy_Confirm_Frame:SetTemplate("Transparent")
	
		S:HandleButton(Atr_Buy_Confirm_OKBut)
		S:HandleButton(Atr_Buy_Confirm_CancelBut)
		
		S:HandleButton(Atr_SaveThisList_Button)
		Atr_SaveThisList_Button:Width(120)
		Atr_SaveThisList_Button:SetPoint("TOPLEFT", Atr_HeadingsBar, "TOPLEFT", 80, 30)

		E:UnregisterEvent('AuctionatorAtlantiss', 'AUCTION_HOUSE_SHOW')
	end
end

addon:RegisterSkin("AuctionatorAtlantiss", addon.AuctionatorAtlantiss, "AUCTION_HOUSE_SHOW");
