local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins')

local _G = _G;
local unpack, select = unpack, select;

local GetItemInfo = GetItemInfo;
local GetItemQualityColor = GetItemQualityColor;
local GetTradePlayerItemLink = GetTradePlayerItemLink;
local GetTradeTargetItemLink = GetTradeTargetItemLink;

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.trade ~= true then return end
	TradeFrame:StripTextures(true)
	TradeFrame:CreateBackdrop("Transparent")
	TradeFrame:Height(493)
	TradeFrame.backdrop:Point("TOPLEFT", 10, -4)
	TradeFrame.backdrop:Point("BOTTOMRIGHT", -16, 35)
	S:HandleButton(TradeFrameTradeButton, true)
	S:HandleButton(TradeFrameCancelButton, true)
	S:HandleCloseButton(TradeFrameCloseButton, TradeFrame.backdrop)

	S:HandleEditBox(TradePlayerInputMoneyFrameGold)
	S:HandleEditBox(TradePlayerInputMoneyFrameSilver)
	S:HandleEditBox(TradePlayerInputMoneyFrameCopper)

	TradeFrameTradeButton:ClearAllPoints()
	TradeFrameTradeButton:SetPoint("BOTTOMRIGHT", TradeFrame, "BOTTOMRIGHT", -105, 40)


	for i=1, 7 do
		local player = _G["TradePlayerItem"..i]
		local recipient = _G["TradeRecipientItem"..i]
		local player_button = _G["TradePlayerItem"..i.."ItemButton"]
		local recipient_button = _G["TradeRecipientItem"..i.."ItemButton"]
		local player_button_icon = _G["TradePlayerItem"..i.."ItemButtonIconTexture"]
		local recipient_button_icon = _G["TradeRecipientItem"..i.."ItemButtonIconTexture"]

		if player_button and recipient_button then
			player:StripTextures()
			recipient:StripTextures()
			player_button:StripTextures()
			recipient_button:StripTextures()

			player_button_icon:ClearAllPoints()
			player_button_icon:Point("TOPLEFT", player_button, "TOPLEFT", 2, -2)
			player_button_icon:Point("BOTTOMRIGHT", player_button, "BOTTOMRIGHT", -2, 2)
			player_button_icon:SetTexCoord(unpack(E.TexCoords))
			player_button:SetTemplate("Default", true)
			player_button:StyleButton()
			player_button.bg = CreateFrame("Frame", nil, player_button)
			player_button.bg:SetTemplate("Default")
			player_button.bg:SetPoint("TOPLEFT", player_button, "TOPRIGHT", 4, 0)
			player_button.bg:SetPoint("BOTTOMRIGHT", _G["TradePlayerItem"..i.."NameFrame"], "BOTTOMRIGHT", 0, 14)
			player_button.bg:SetFrameLevel(player_button:GetFrameLevel() - 3)
			player_button:SetFrameLevel(player_button:GetFrameLevel() - 1)

			recipient_button_icon:ClearAllPoints()
			recipient_button_icon:Point("TOPLEFT", recipient_button, "TOPLEFT", 2, -2)
			recipient_button_icon:Point("BOTTOMRIGHT", recipient_button, "BOTTOMRIGHT", -2, 2)
			recipient_button_icon:SetTexCoord(unpack(E.TexCoords))
			recipient_button:SetTemplate("Default", true)
			recipient_button:StyleButton()
			recipient_button.bg = CreateFrame("Frame", nil, recipient_button)
			recipient_button.bg:SetTemplate("Default")
			recipient_button.bg:SetPoint("TOPLEFT", recipient_button, "TOPRIGHT", 4, 0)
			recipient_button.bg:SetPoint("BOTTOMRIGHT", _G["TradeRecipientItem"..i.."NameFrame"], "BOTTOMRIGHT", 0, 14)
			recipient_button.bg:SetFrameLevel(recipient_button:GetFrameLevel() - 3)
			recipient_button:SetFrameLevel(recipient_button:GetFrameLevel() - 1)
			
		end
	end

	TradeHighlightPlayerTop:SetTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerBottom:SetTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerMiddle:SetTexture(0, 1, 0, 0.2)
	TradeHighlightPlayer:SetFrameStrata("HIGH")
	TradeHighlightPlayer:Point("TOPLEFT", TradeFrame, "TOPLEFT", 23, -100)

	TradeHighlightPlayerEnchantTop:SetTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerEnchantBottom:SetTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerEnchantMiddle:SetTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerEnchant:SetFrameStrata("HIGH")

	TradeHighlightRecipientTop:SetTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientBottom:SetTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientMiddle:SetTexture(0, 1, 0, 0.2)
	TradeHighlightRecipient:SetFrameStrata("HIGH")
	TradeHighlightRecipient:Point("TOPLEFT", TradeFrame, "TOPLEFT", 192, -100)

	TradeHighlightRecipientEnchantTop:SetTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientEnchantBottom:SetTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientEnchantMiddle:SetTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientEnchant:SetFrameStrata("HIGH")

	hooksecurefunc("TradeFrame_UpdatePlayerItem", function(id)
		local link = GetTradePlayerItemLink(id);
		local tradeItemButton = _G["TradePlayerItem" .. id .. "ItemButton"];
		if(link) then
			local quality = select(3, GetItemInfo(link));
			if(quality and quality > 1) then
				tradeItemButton:SetBackdropBorderColor(GetItemQualityColor(quality));
 			end
		else
			tradeItemButton:SetBackdropBorderColor(unpack(E["media"].bordercolor));
 		end
	end);

	hooksecurefunc("TradeFrame_UpdateTargetItem", function(id)
		local link = GetTradeTargetItemLink(id);
		local tradeItemButton = _G["TradeRecipientItem" .. id .. "ItemButton"];
		if(link) then
			local quality = select(3, GetItemInfo(link));
			if(quality and quality > 1) then
				tradeItemButton:SetBackdropBorderColor(GetItemQualityColor(quality));
 			end
		else
			tradeItemButton:SetBackdropBorderColor(unpack(E["media"].bordercolor));
 		end
	end);
end

S:AddCallback("Trade", LoadSkin);