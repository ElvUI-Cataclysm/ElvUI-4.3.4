local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local unpack = unpack
local strfind = strfind

local NUM_GLYPH_SLOTS = NUM_GLYPH_SLOTS

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.talent then return end

	GlyphFrame:StripTextures()
	GlyphFrame:CreateBackdrop("Transparent")

	GlyphFrame.levelOverlayText1:SetTextColor(1, 1, 1)
	GlyphFrame.levelOverlayText2:SetTextColor(1, 1, 1)

	GlyphFrameSideInset:StripTextures()
	GlyphFrameScrollFrame:StripTextures()
	GlyphFrameScrollFrameScrollChild:StripTextures()

	S:HandleEditBox(GlyphFrameSearchBox)

	S:HandleDropDownBox(GlyphFrameFilterDropDown, 206)
	GlyphFrameFilterDropDown:Point("TOPLEFT", GlyphFrameSearchBox, "BOTTOMLEFT", -13, -3)

	for i = 1, NUM_GLYPH_SLOTS do
		local frame = _G["GlyphFrameGlyph"..i]

		frame:SetTemplate("Default", true)
		frame:SetFrameLevel(frame:GetFrameLevel() + 5)
		frame:StyleButton(nil, true)

		if i == 1 or i == 4 or i == 6 then
			frame:Size(64)
		elseif i == 2 or i == 3 or i == 5 then
			frame:Size(44)
		else
			frame:Size(84)
		end

		frame.highlight:SetTexture(nil)
		frame.ring:Hide()
		frame.glyph:Hide()
		frame.glyph.Show = E.noop

		frame.icon = frame:CreateTexture(nil, "OVERLAY")
		frame.icon:SetInside()
		frame.icon:SetTexCoord(unpack(E.TexCoords))

		frame.onUpdate = CreateFrame("Frame", nil, frame)
		frame.onUpdate:SetScript("OnUpdate", function()
			if strfind(frame.icon:GetTexture(), "Interface\\Spellbook\\UI%-Glyph%-Rune") then
				local alpha = frame.highlight:GetAlpha()

				if alpha == 0 then
					frame:SetBackdropBorderColor(unpack(E.media.bordercolor))
					frame:SetAlpha(1)

					frame.icon:SetVertexColor(1, 1, 1, 1)
				else
					frame:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
					frame:SetAlpha(alpha)

					frame.icon:SetVertexColor(unpack(E.media.rgbvaluecolor))
					frame.icon:SetAlpha(alpha)
				end
			end
		end)
	end

	hooksecurefunc("GlyphFrame_Update", function(self)
		local isActiveTalentGroup = PlayerTalentFrame and not PlayerTalentFrame.pet and PlayerTalentFrame.talentGroup == GetActiveTalentGroup(PlayerTalentFrame.pet)

		for i = 1, NUM_GLYPH_SLOTS do
			local GlyphSocket = _G["GlyphFrameGlyph"..i]
			local _, _, _, _, iconFilename = GetGlyphSocketInfo(i, PlayerTalentFrame.talentGroup)

			if iconFilename then
				GlyphSocket.icon:SetTexture(iconFilename)
			else
				GlyphSocket.icon:SetTexture("Interface\\Spellbook\\UI-Glyph-Rune-"..i)
			end

			GlyphFrameGlyph_UpdateSlot(GlyphSocket)
			SetDesaturation(GlyphSocket.icon, not isActiveTalentGroup)
		end
	end)

	for i = 1, 3 do
		local header = _G["GlyphFrameHeader"..i]

		header:StripTextures()
		header:StyleButton()
	end

	for i = 1, 10 do
		local button = _G["GlyphFrameScrollFrameButton"..i]
		local icon = _G["GlyphFrameScrollFrameButton"..i.."Icon"]

		button:StripTextures()
		S:HandleButton(button)

		icon:SetTexCoord(unpack(E.TexCoords))
	end

	GlyphFrameClearInfoFrameIcon:SetTexCoord(unpack(E.TexCoords))
	GlyphFrameClearInfoFrameIcon:ClearAllPoints()
	GlyphFrameClearInfoFrameIcon:SetInside()

	GlyphFrameClearInfoFrame:CreateBackdrop("Default", true)
	GlyphFrameClearInfoFrame.backdrop:SetAllPoints()
	GlyphFrameClearInfoFrame:StyleButton()
	GlyphFrameClearInfoFrame:Size(25)
	GlyphFrameClearInfoFrame:Point("BOTTOMLEFT", GlyphFrame, "BOTTOMRIGHT", 10, -2)

	S:HandleScrollBar(GlyphFrameScrollFrameScrollBar, 5)
end

S:AddCallbackForAddon("Blizzard_GlyphUI", "Glyph", LoadSkin)