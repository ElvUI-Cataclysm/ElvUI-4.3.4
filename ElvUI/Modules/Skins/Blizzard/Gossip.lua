local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local select = select
local find, gsub = string.find, string.gsub

local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.gossip then return end

	-- Item Text Frame
	ItemTextFrame:StripTextures(true)
	ItemTextFrame:CreateBackdrop("Transparent")
	ItemTextFrame.backdrop:Point("TOPLEFT", 46, -13)
	ItemTextFrame.backdrop:Point("BOTTOMRIGHT", -24, 70)

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

	-- Gossip Frame
	GossipFrameGreetingPanel:StripTextures()

	GossipFramePortrait:Kill()

	GossipFrame:CreateBackdrop("Transparent")
	GossipFrame.backdrop:Point("TOPLEFT", 15, -11)
	GossipFrame.backdrop:Point("BOTTOMRIGHT", -30, 0)

	GossipFrameNpcNameText:ClearAllPoints()
	GossipFrameNpcNameText:Point("TOP", GossipFrame, -5, -19)

	GossipGreetingText:SetTextColor(1, 1, 1)

	GossipGreetingScrollFrame:Height(403)

	S:HandleScrollBar(GossipGreetingScrollFrameScrollBar)
	GossipGreetingScrollFrameScrollBar:ClearAllPoints()
	GossipGreetingScrollFrameScrollBar:Point("TOPRIGHT", GossipGreetingScrollFrame, 25, -18)
	GossipGreetingScrollFrameScrollBar:Point("BOTTOMRIGHT", GossipGreetingScrollFrame, 0, 21)

	S:HandleButton(GossipFrameGreetingGoodbyeButton)
	GossipFrameGreetingGoodbyeButton:Point("BOTTOMRIGHT", -35, 4)

	S:HandleCloseButton(GossipFrameCloseButton, GossipFrame.backdrop)

	for i = 1, NUMGOSSIPBUTTONS do
		local button = _G["GossipTitleButton"..i]
		local text = select(3, button:GetRegions())

		S:HandleButtonHighlight(button)

		text:SetTextColor(1, 1, 1)
	end

	hooksecurefunc("GossipFrameUpdate", function()
		for i = 1, NUMGOSSIPBUTTONS do
			local button = _G["GossipTitleButton"..i]

			if button:GetFontString() then
				local text = button:GetText()

				if text and find(text, "|cff000000") then
					button:SetText(gsub(text, "|cff000000", "|cffFFFF00"))
				end
			end
		end
	end)
end

S:AddCallback("Gossip", LoadSkin)