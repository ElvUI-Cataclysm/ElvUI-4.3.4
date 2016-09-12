local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins')

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.gbank ~= true then return end

	GuildBankFrame:StripTextures()
	GuildBankFrame:SetTemplate("Transparent")
	GuildBankFrame:SetWidth(654)
	GuildBankEmblemFrame:StripTextures(true)

	--Close button doesn't have a fucking name, extreme hackage
	for i=1, GuildBankFrame:GetNumChildren() do
		local child = select(i, GuildBankFrame:GetChildren())
		if child.GetPushedTexture and child:GetPushedTexture() and not child:GetName() then
			S:HandleCloseButton(child)
		end
	end

	S:HandleButton(GuildBankFrameDepositButton, true)
	GuildBankFrameDepositButton:SetWidth(85)
	S:HandleButton(GuildBankFrameWithdrawButton, true)
	GuildBankFrameWithdrawButton:SetWidth(85)
	S:HandleButton(GuildBankInfoSaveButton, true)
	S:HandleButton(GuildBankFramePurchaseButton, true)

	GuildBankFrameWithdrawButton:Point("RIGHT", GuildBankFrameDepositButton, "LEFT", -2, 0)

	GuildBankInfoScrollFrame:StripTextures()
	GuildBankInfoScrollFrame:SetWidth(572)
	GuildBankTransactionsScrollFrame:StripTextures()
	GuildBankTabInfoEditBox:SetWidth(560)

	GuildBankFrame.inset = CreateFrame("Frame", nil, GuildBankFrame)
	GuildBankFrame.inset:SetTemplate("Default")
	GuildBankFrame.inset:Point("TOPLEFT", 30, -65)
	GuildBankFrame.inset:Point("BOTTOMRIGHT", -20, 63)

	for i=1, NUM_GUILDBANK_COLUMNS do
		_G["GuildBankColumn"..i]:StripTextures()

		for x=1, NUM_SLOTS_PER_GUILDBANK_GROUP do
			local button = _G["GuildBankColumn"..i.."Button"..x]
			local icon = _G["GuildBankColumn"..i.."Button"..x.."IconTexture"]
			local texture = _G["GuildBankColumn"..i.."Button"..x.."NormalTexture"]
			if texture then
				texture:SetTexture(nil)
			end
			button:StyleButton()
			button:SetTemplate("Default", true)

			icon:ClearAllPoints()
			icon:Point("TOPLEFT", 2, -2)
			icon:Point("BOTTOMRIGHT", -2, 2)
			icon:SetTexCoord(unpack(E.TexCoords))
		end
	end

	for i=1, 8 do
		local button = _G["GuildBankTab"..i.."Button"]
		local texture = _G["GuildBankTab"..i.."ButtonIconTexture"]
		_G["GuildBankTab"..i]:StripTextures(true)

		button:StripTextures()
		button:StyleButton(true)
		button:SetTemplate("Default", true)

		texture:ClearAllPoints()
		texture:Point("TOPLEFT", 2, -2)
		texture:Point("BOTTOMRIGHT", -2, 2)
		texture:SetTexCoord(unpack(E.TexCoords))
	end

	for i=1, 4 do
		S:HandleTab(_G["GuildBankFrameTab"..i])
	end

	hooksecurefunc('GuildBankFrame_Update', function()
		if GuildBankFrame.mode ~= "bank" then return; end
		local tab = GetCurrentGuildBankTab();
		local button, index, column, itemLink, itemRarity, r, g, b;
		for i=1, MAX_GUILDBANK_SLOTS_PER_TAB do
			index = mod(i, NUM_SLOTS_PER_GUILDBANK_GROUP);
			if ( index == 0 ) then
				index = NUM_SLOTS_PER_GUILDBANK_GROUP;
			end
			column = ceil((i-0.5)/NUM_SLOTS_PER_GUILDBANK_GROUP);
			button = _G["GuildBankColumn"..column.."Button"..index];

			itemLink = GetGuildBankItemLink(tab, i);
			if itemLink then
				itemRarity = select(3, GetItemInfo(itemLink))
				if itemRarity > 1 then
					r, g, b = GetItemQualityColor(itemRarity)
				else
					r, g, b = unpack(E.media.bordercolor)
				end
			else
				r, g, b = unpack(E.media.bordercolor)
			end
			button:SetBackdropBorderColor(r, g, b)
		end
	end)

	--Reposition tab
	GuildBankFrameTab1:ClearAllPoints()
	GuildBankFrameTab1:SetPoint("BOTTOMLEFT", GuildBankFrame, "BOTTOMLEFT", 0, -30)

	GuildBankTab1:Point("TOPLEFT", GuildBankFrame, "TOPRIGHT", -3, -36)
	GuildBankTab2:Point("TOPLEFT", GuildBankTab1, "BOTTOMLEFT", 0, 7)
	GuildBankTab3:Point("TOPLEFT", GuildBankTab2, "BOTTOMLEFT", 0, 7)
	GuildBankTab4:Point("TOPLEFT", GuildBankTab3, "BOTTOMLEFT", 0, 7)
	GuildBankTab5:Point("TOPLEFT", GuildBankTab4, "BOTTOMLEFT", 0, 7)
	GuildBankTab6:Point("TOPLEFT", GuildBankTab5, "BOTTOMLEFT", 0, 7)
	GuildBankTab7:Point("TOPLEFT", GuildBankTab6, "BOTTOMLEFT", 0, 7)
	GuildBankTab8:Point("TOPLEFT", GuildBankTab7, "BOTTOMLEFT", 0, 7)

	--Popup
	GuildBankPopupFrame:StripTextures()
	GuildBankPopupScrollFrame:StripTextures()
	GuildBankPopupFrame:SetTemplate("Transparent")
	GuildBankPopupFrame:Point("TOPLEFT", GuildBankFrame, "TOPRIGHT", 1, -30)
	S:HandleButton(GuildBankPopupOkayButton)
	S:HandleButton(GuildBankPopupCancelButton)
	S:HandleEditBox(GuildBankPopupEditBox)
	GuildBankPopupNameLeft:Kill()
	GuildBankPopupNameRight:Kill()
	GuildBankPopupNameMiddle:Kill()

	GuildItemSearchBox:StripTextures()
	GuildItemSearchBox:CreateBackdrop("Overlay")
	GuildItemSearchBox.backdrop:Point("TOPLEFT", 10, -1)
	GuildItemSearchBox.backdrop:Point("BOTTOMRIGHT", 4, 1)
	GuildItemSearchBox:Point("TOPRIGHT", GuildBankFrame, "TOPRIGHT", -25, -42)

	for i=1, 16 do
		local button = _G["GuildBankPopupButton"..i]
		local icon = _G[button:GetName().."Icon"]
		button:StripTextures()
		button:SetTemplate("Default")
		button:StyleButton(true)
		icon:ClearAllPoints()
		icon:Point("TOPLEFT", 2, -2)
		icon:Point("BOTTOMRIGHT", -2, 2)
		icon:SetTexCoord(unpack(E.TexCoords))
	end

	S:HandleScrollBar(GuildBankTransactionsScrollFrameScrollBar)
	S:HandleScrollBar(GuildBankInfoScrollFrameScrollBar)

	GuildBankColumn2:Point("TOPLEFT", GuildBankColumn1, "TOPRIGHT", -15, 0)
	GuildBankColumn3:Point("TOPLEFT", GuildBankColumn2, "TOPRIGHT", -15, 0)
	GuildBankColumn4:Point("TOPLEFT", GuildBankColumn3, "TOPRIGHT", -15, 0)
	GuildBankColumn5:Point("TOPLEFT", GuildBankColumn4, "TOPRIGHT", -15, 0)
	GuildBankColumn6:Point("TOPLEFT", GuildBankColumn5, "TOPRIGHT", -15, 0)
	GuildBankColumn7:Point("TOPLEFT", GuildBankColumn6, "TOPRIGHT", -15, 0)

	GuildBankColumn1Button8:Point("TOPLEFT", GuildBankColumn1Button1, "TOPRIGHT", 5, 0)
	GuildBankColumn2Button8:Point("TOPLEFT", GuildBankColumn2Button1, "TOPRIGHT", 5, 0)
	GuildBankColumn3Button8:Point("TOPLEFT", GuildBankColumn3Button1, "TOPRIGHT", 5, 0)
	GuildBankColumn4Button8:Point("TOPLEFT", GuildBankColumn4Button1, "TOPRIGHT", 5, 0)
	GuildBankColumn5Button8:Point("TOPLEFT", GuildBankColumn5Button1, "TOPRIGHT", 5, 0)
	GuildBankColumn6Button8:Point("TOPLEFT", GuildBankColumn6Button1, "TOPRIGHT", 5, 0)
	GuildBankColumn7Button8:Point("TOPLEFT", GuildBankColumn7Button1, "TOPRIGHT", 5, 0)
end

S:RegisterSkin("Blizzard_GuildBankUI", LoadSkin)