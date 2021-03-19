local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local select = select
local find, gsub = string.find, string.gsub

local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.gossip then return end

	GossipFrame:CreateBackdrop("Transparent")
	GossipFrame.backdrop:Point("TOPLEFT", 13, -11)
	GossipFrame.backdrop:Point("BOTTOMRIGHT", -26, 0)

	S:SetUIPanelWindowInfo(GossipFrame, "width")
	S:SetBackdropHitRect(GossipFrame)

	GossipFramePortrait:Kill()

	GossipFrameGreetingPanel:StripTextures()

	GossipFrameNpcNameText:ClearAllPoints()
	GossipFrameNpcNameText:Point("TOP", GossipFrame, -5, -19)

	GossipGreetingText:SetTextColor(1, 1, 1)

	GossipGreetingScrollFrame:CreateBackdrop("Transparent")
	GossipGreetingScrollFrame.backdrop:Point("TOPLEFT", -3, 2)
	GossipGreetingScrollFrame.backdrop:Point("BOTTOMRIGHT", 4, -2)
	GossipGreetingScrollFrame:Height(403)
	GossipGreetingScrollFrame:Point("TOPLEFT", 23, -74)

	S:HandleScrollBar(GossipGreetingScrollFrameScrollBar)
	GossipGreetingScrollFrameScrollBar:ClearAllPoints()
	GossipGreetingScrollFrameScrollBar:Point("TOPRIGHT", GossipGreetingScrollFrame, 27, -16)
	GossipGreetingScrollFrameScrollBar:Point("BOTTOMRIGHT", GossipGreetingScrollFrame, 0, 16)

	S:HandleButton(GossipFrameGreetingGoodbyeButton)
	GossipFrameGreetingGoodbyeButton:Point("BOTTOMRIGHT", -57, 6)

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