local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local unpack, select = unpack, select
local ceil = math.ceil

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.gbank then return end

	GuildBankFrame:StripTextures()
	GuildBankFrame:SetTemplate("Transparent")
	GuildBankFrame:Width(654)

	GuildBankEmblemFrame:StripTextures(true)

	for i = 1, GuildBankFrame:GetNumChildren() do
		local child = select(i, GuildBankFrame:GetChildren())

		if child.GetPushedTexture and child:GetPushedTexture() and not child:GetName() then
			S:HandleCloseButton(child)
			child:Point("TOPRIGHT", 2, 2)
		end
	end

	S:HandleButton(GuildBankFrameDepositButton, true)
	GuildBankFrameDepositButton:Width(85)

	S:HandleButton(GuildBankFrameWithdrawButton, true)
	GuildBankFrameWithdrawButton:Width(85)
	GuildBankFrameWithdrawButton:Point("RIGHT", GuildBankFrameDepositButton, "LEFT", -2, 0)

	S:HandleButton(GuildBankInfoSaveButton, true)
	S:HandleButton(GuildBankFramePurchaseButton, true)

	GuildBankInfoScrollFrame:StripTextures()
	GuildBankInfoScrollFrame:Width(572)

	S:HandleScrollBar(GuildBankInfoScrollFrameScrollBar)
	GuildBankInfoScrollFrameScrollBar:ClearAllPoints()
	GuildBankInfoScrollFrameScrollBar:Point("TOPRIGHT", GuildBankInfoScrollFrame, "TOPRIGHT", 21, -12)
	GuildBankInfoScrollFrameScrollBar:Point("BOTTOMRIGHT", GuildBankInfoScrollFrame, "BOTTOMRIGHT", 0, 20)

	GuildBankTabInfoEditBox:Width(565)

	GuildBankTransactionsScrollFrame:StripTextures()

	S:HandleScrollBar(GuildBankTransactionsScrollFrameScrollBar)
	GuildBankTransactionsScrollFrameScrollBar:ClearAllPoints()
	GuildBankTransactionsScrollFrameScrollBar:Point("TOPRIGHT", GuildBankTransactionsScrollFrame, "TOPRIGHT", 21, -11)
	GuildBankTransactionsScrollFrameScrollBar:Point("BOTTOMRIGHT", GuildBankTransactionsScrollFrame, "BOTTOMRIGHT", 0, 19)

	GuildBankFrame.inset = CreateFrame("Frame", nil, GuildBankFrame)
	GuildBankFrame.inset:SetTemplate("Default")
	GuildBankFrame.inset:Point("TOPLEFT", 25, -65)
	GuildBankFrame.inset:Point("BOTTOMRIGHT", -25, 63)

	GuildItemSearchBoxLeft:Kill()
	GuildItemSearchBoxRight:Kill()
	GuildItemSearchBoxMiddle:Kill()

	GuildItemSearchBox:CreateBackdrop()
	GuildItemSearchBox.backdrop:Point("TOPLEFT", 13, -1)
	GuildItemSearchBox.backdrop:Point("BOTTOMRIGHT", 4, 1)
	GuildItemSearchBox:Point("TOPRIGHT", -30, -42)
	GuildItemSearchBox:Size(150, 22)

	GuildBankLimitLabel:Point("CENTER", GuildBankTabLimitBackground, "CENTER", -20, 1)

	GuildBankCashFlowLabel:Point("LEFT", GuildBankTabLimitBackground, "LEFT", -30, 0)
	GuildBankCashFlowMoneyFrame:Point("RIGHT", GuildBankTabLimitBackground, "RIGHT", -30, 0)

	for i = 1, NUM_GUILDBANK_COLUMNS do
		local column = _G["GuildBankColumn"..i]

		column:StripTextures()

		if i == 1 then
			column:Point("TOPLEFT", GuildBankFrame, "TOPLEFT", 25, -70)
		else
			column:Point("TOPLEFT", _G["GuildBankColumn"..i - 1], "TOPRIGHT", -15, 0)
		end

		for x = 1, NUM_SLOTS_PER_GUILDBANK_GROUP do
			local button = _G["GuildBankColumn"..i.."Button"..x]
			local icon = _G["GuildBankColumn"..i.."Button"..x.."IconTexture"]
			local texture = _G["GuildBankColumn"..i.."Button"..x.."NormalTexture"]
			local count = _G["GuildBankColumn"..i.."Button"..x.."Count"]

			if x == 8 then
				button:Point("TOPLEFT", _G["GuildBankColumn"..i.."Button1"], "TOPRIGHT", 5, 0)
			end

			if texture then
				texture:SetTexture(nil)
			end

			button:StyleButton()
			button:SetTemplate("Default", true)

			icon:SetInside()
			icon:SetTexCoord(unpack(E.TexCoords))
			icon:SetDrawLayer("OVERLAY")

			count:SetDrawLayer("OVERLAY")
		end
	end

	hooksecurefunc("GuildBankFrame_Update", function()
		if GuildBankFrame.mode ~= "bank" then return end

		local tab = GetCurrentGuildBankTab()
		local index, column, button, link, quality

		for i = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
			index = mod(i, NUM_SLOTS_PER_GUILDBANK_GROUP)

			if index == 0 then
				index = NUM_SLOTS_PER_GUILDBANK_GROUP
			end

			column = ceil((i - 0.5) / NUM_SLOTS_PER_GUILDBANK_GROUP)
			button = _G["GuildBankColumn"..column.."Button"..index]
			link = GetGuildBankItemLink(tab, i)

			if link then
				quality = select(3, GetItemInfo(link))

				if quality then
					button:SetBackdropBorderColor(GetItemQualityColor(quality))
				else
					button:SetBackdropBorderColor(unpack(E.media.bordercolor))
				end
			else
				button:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end
		end
	end)

	-- Side Tabs
	for i = 1, 8 do
		local tab = _G["GuildBankTab"..i]
		local button = _G["GuildBankTab"..i.."Button"]
		local texture = _G["GuildBankTab"..i.."ButtonIconTexture"]

		tab:StripTextures(true)

		if i == 1 then
			tab:Point("TOPLEFT", GuildBankFrame, "TOPRIGHT", E.PixelMode and -3 or -1, -36)
		else
			tab:Point("TOPLEFT", _G["GuildBankTab"..i - 1], "BOTTOMLEFT", 0, 7)
		end

		button:StripTextures()
		button:SetTemplate()
		button:StyleButton()

		button:GetCheckedTexture():SetTexture(1, 1, 1, 0.3)
		button:GetCheckedTexture():SetInside()

		texture:SetInside()
		texture:SetTexCoord(unpack(E.TexCoords))
		texture:SetDrawLayer("ARTWORK")
	end

	-- Bottom Tabs
	for i = 1, 4 do
		local tab = _G["GuildBankFrameTab"..i]

		S:HandleTab(tab)

		if i == 1 then
			tab:ClearAllPoints()
			tab:Point("BOTTOMLEFT", GuildBankFrame, "BOTTOMLEFT", 0, -30)
		end
	end

	-- Popup
	S:HandleIconSelectionFrame(GuildBankPopupFrame, NUM_GUILDBANK_ICONS_SHOWN, "GuildBankPopupButton", "GuildBankPopup")

	S:HandleScrollBar(GuildBankPopupScrollFrameScrollBar)

	GuildBankPopupScrollFrame:CreateBackdrop("Transparent")
	GuildBankPopupScrollFrame.backdrop:Point("TOPLEFT", 92, 2)
	GuildBankPopupScrollFrame.backdrop:Point("BOTTOMRIGHT", -5, 2)
	GuildBankPopupScrollFrame:Point("TOPRIGHT", GuildBankPopupFrame, "TOPRIGHT", -30, -66)

	GuildBankPopupButton1:Point("TOPLEFT", GuildBankPopupFrame, "TOPLEFT", 30, -86)
	GuildBankPopupFrame:Point("TOPLEFT", GuildBankFrame, "TOPRIGHT", 36, 0)
end

S:AddCallbackForAddon("Blizzard_GuildBankUI", "GuildBank", LoadSkin)