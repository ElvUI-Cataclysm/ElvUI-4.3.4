local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local unpack = unpack
local strfind = strfind

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.talent then return end

	GlyphFrame:StripTextures()
	GlyphFrame:CreateBackdrop("Transparent")

	GlyphFrame.levelOverlayText1:SetTextColor(1, 1, 1)
	GlyphFrame.levelOverlayText2:SetTextColor(1, 1, 1)

	GlyphFrameScrollFrame:StripTextures()
	GlyphFrameSideInset:StripTextures()
	GlyphFrameScrollFrameScrollChild:StripTextures()

	S:HandleEditBox(GlyphFrameSearchBox)

	S:HandleDropDownBox(GlyphFrameFilterDropDown, 206)
	GlyphFrameFilterDropDown:Point("TOPLEFT", GlyphFrameSearchBox, "BOTTOMLEFT", -13, -3)

	for i = 1, 9 do
		local frame = _G["GlyphFrameGlyph"..i]

		frame:SetTemplate("Default", true)
		frame:SetFrameLevel(frame:GetFrameLevel() + 5)
		frame:StyleButton(nil, true)

		frame.ring:Hide()
		frame.highlight:SetTexture(nil)

		frame.icon = frame:CreateTexture(nil, "OVERLAY")
		frame.icon:SetInside()
		frame.icon:SetTexCoord(unpack(E.TexCoords))

		frame.backdrop = CreateFrame("Frame", nil, frame)
		frame.backdrop:SetScript("OnUpdate", function()
			if strfind(frame.icon:GetTexture(), "Interface\\Spellbook\\UI%-Glyph%-Rune") then
				local alpha = frame.highlight:GetAlpha()

				if alpha == 0 then
					frame:SetBackdropBorderColor(unpack(E.media.bordercolor))
					frame.icon:SetVertexColor(1, 1, 1, 1)
				else
					frame:SetBackdropBorderColor(1, 0.80, 0.10, alpha)
					frame.icon:SetVertexColor(1, 0.80, 0.10, alpha)
				end
			end
		end)

		local size = frame:GetSize()
		if i == 1 or i == 4 or i == 6 then
			frame:Size(size * 0.9)
		elseif i == 2 or i == 3 or i == 5 then
			frame:Size(size * 0.6)
		else
			frame:Size(size * 1.2)
		end

		hooksecurefunc(frame.glyph, "Show", function(self) self:Hide() end)
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
		_G["GlyphFrameHeader"..i]:StripTextures()
		_G["GlyphFrameHeader"..i]:StyleButton()
	end

	local function Glyphs(self, first, i)
		local button = _G["GlyphFrameScrollFrameButton"..i]
		local icon = _G["GlyphFrameScrollFrameButton"..i.."Icon"]

		if first then
			button:StripTextures()
		end

		if icon then
			icon:SetTexCoord(unpack(E.TexCoords))
			S:HandleButton(button)
		end
	end

	for i = 1, 10 do
		Glyphs(nil, true, i)
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