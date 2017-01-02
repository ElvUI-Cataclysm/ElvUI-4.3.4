local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule("Skins")

local _G = _G;
local select = select;
local find, gsub = string.find, string.gsub;

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.gossip ~= true then return end

	ItemTextScrollFrame:StripTextures()
	GossipFrameGreetingPanel:StripTextures()

	ItemTextFrame:StripTextures(true)
	ItemTextFrame:CreateBackdrop("Transparent")
	ItemTextFrame.backdrop:Point("TOPLEFT", 13, -13)
	ItemTextFrame.backdrop:Point("BOTTOMRIGHT", -32, 74)

	ItemTextPageText:SetTextColor(1, 1, 1)
	ItemTextPageText.SetTextColor = E.noop

	GossipFramePortrait:Kill()

	GossipFrameGreetingGoodbyeButton:StripTextures()
	S:HandleButton(GossipFrameGreetingGoodbyeButton)
	GossipFrameGreetingGoodbyeButton:Point("BOTTOMRIGHT", -49, 72)

	GossipGreetingText:SetTextColor(1, 1, 1)

	GossipFrame:CreateBackdrop("Transparent")
	GossipFrame.backdrop:Point("TOPLEFT", 6, -8)
	GossipFrame.backdrop:Point("BOTTOMRIGHT", -30, 65)

	S:HandleNextPrevButton(ItemTextPrevPageButton)
	S:HandleNextPrevButton(ItemTextNextPageButton)

	S:HandleScrollBar(ItemTextScrollFrameScrollBar)
	S:HandleScrollBar(GossipGreetingScrollFrameScrollBar, 5)

	S:HandleCloseButton(GossipFrameCloseButton)
	GossipFrameCloseButton:Point("CENTER", GossipFrame, "TOPRIGHT", -44, -22)
	S:HandleCloseButton(ItemTextCloseButton)

	for i = 1, NUMGOSSIPBUTTONS do
		local obj = select(3,_G["GossipTitleButton"..i]:GetRegions())
		obj:SetTextColor(1, 1, 1)
	end

	hooksecurefunc("GossipFrameUpdate", function()
		for i = 1, NUMGOSSIPBUTTONS do
			local button = _G["GossipTitleButton"..i]

			if(button:GetFontString()) then
				if(button:GetFontString():GetText() and button:GetFontString():GetText():find("|cff000000")) then
					button:GetFontString():SetText(gsub(button:GetFontString():GetText(), "|cff000000", "|cffFFFF00"))
				end
			end
		end
	end)
end

S:AddCallback("Gossip", LoadSkin);