local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local select = select
local find, gsub = string.find, string.gsub

local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.itemText then return end

	ItemTextFrame:StripTextures(true)
	ItemTextFrame:CreateBackdrop("Transparent")
	ItemTextFrame.backdrop:Point("TOPLEFT", 46, -13)
	ItemTextFrame.backdrop:Point("BOTTOMRIGHT", -24, 70)

	S:SetUIPanelWindowInfo(ItemTextFrame, "width")
	S:SetBackdropHitRect(ItemTextFrame)

	ItemTextPageText:SetTextColor(1, 1, 1)
	ItemTextPageText.SetTextColor = E.noop

	ItemTextCurrentPage:Point("TOP", 5, -54)

	ItemTextScrollFrame:StripTextures()
	ItemTextScrollFrame:Point("TOPRIGHT", -41, -80)
	ItemTextScrollFrame:CreateBackdrop("Transparent")
	ItemTextScrollFrame.backdrop:Point("TOPLEFT", -10, 0)
	ItemTextScrollFrame.backdrop:Point("BOTTOMRIGHT", 10, 0)

	S:HandleScrollBar(ItemTextScrollFrameScrollBar)
	ItemTextScrollFrameScrollBar:ClearAllPoints()
	ItemTextScrollFrameScrollBar:Point("TOPRIGHT", ItemTextScrollFrame, 33, -18)
	ItemTextScrollFrameScrollBar:Point("BOTTOMRIGHT", ItemTextScrollFrame, 0, 18)

	S:HandleNextPrevButton(ItemTextPrevPageButton, nil, nil, true)
	ItemTextPrevPageButton:Point("CENTER", ItemTextFrame, "TOPLEFT", 66, -60)
	ItemTextPrevPageButton:Size(28)

	S:HandleNextPrevButton(ItemTextNextPageButton, nil, nil, true)
	ItemTextNextPageButton:Point("CENTER", ItemTextFrame, "TOPRIGHT", -50, -60)
	ItemTextNextPageButton:Size(28)

	S:HandleCloseButton(ItemTextCloseButton, ItemTextFrame.backdrop)
end

S:AddCallback("ItemText", LoadSkin)