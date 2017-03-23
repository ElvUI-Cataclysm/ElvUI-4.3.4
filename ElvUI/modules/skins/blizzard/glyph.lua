local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule("Skins")

local _G = _G;
local unpack = unpack;

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.talent ~= true then return end

	GlyphFrame:StripTextures()
	GlyphFrame:CreateBackdrop("Transparent")

	GlyphFrameScrollFrame:StripTextures()
	GlyphFrameSideInset:StripTextures()
	GlyphFrameScrollFrameScrollChild:StripTextures()

	S:HandleEditBox(GlyphFrameSearchBox)
	S:HandleDropDownBox(GlyphFrameFilterDropDown, 212)

	GlyphFrame.levelOverlayText1:SetTextColor(1, 1, 1)
	GlyphFrame.levelOverlayText2:SetTextColor(1, 1, 1)

	if(not GlyphFrame.isSkinned) then
		for i = 1, 9 do
			local Glyph = _G["GlyphFrameGlyph"..i]
			Glyph:SetTemplate("Default", true)
			Glyph:SetFrameLevel(Glyph:GetFrameLevel() + 5)
			Glyph:StyleButton(nil, true)

			Glyph.ring:Hide()
			Glyph.glyph:Hide()
			Glyph.highlight:SetTexture(nil)
			Glyph.glyph:Hide()

			Glyph.icon = Glyph:CreateTexture(nil, "OVERLAY")
			Glyph.icon:SetInside()
			Glyph.icon:SetTexCoord(unpack(E.TexCoords))

			Glyph:CreateBackdrop()
			Glyph.backdrop:SetAllPoints()
			Glyph.backdrop:SetFrameLevel(Glyph:GetFrameLevel() + 1)
			Glyph.backdrop:SetBackdropColor(0, 0, 0, 0)
			Glyph.backdrop:SetBackdropBorderColor(1, 0.80, 0.10)

			Glyph.backdrop:SetScript("OnUpdate", function(self)
				local Alpha = Glyph.highlight:GetAlpha()
				self:SetAlpha(Alpha)

				if(strfind(Glyph.icon:GetTexture(), "Interface\\Spellbook\\UI%-Glyph%-Rune")) then
					if(Alpha == 0) then
						Glyph.icon:SetVertexColor(1, 1, 1)
						Glyph.icon:SetAlpha(1)
					else
						Glyph.icon:SetVertexColor(1, 0.80, 0.10)
						Glyph.icon:SetAlpha(Alpha)
					end
				end
			end)

			hooksecurefunc(Glyph.highlight, "Show", function()
				Glyph.backdrop:Show()
			end)

			Glyph.glyph:Hide()
			hooksecurefunc(Glyph.glyph, "Show", function(self) self:Hide() end)

			if(i == 1 or i == 4 or i == 6) then
				Glyph:Size(Glyph:GetWidth() * .8, Glyph:GetHeight() * .8)
			elseif(i == 2 or i == 3 or i == 5) then
				Glyph:Size(Glyph:GetWidth() * .6, Glyph:GetHeight() * .6)
			end
		end

		hooksecurefunc("GlyphFrame_Update", function(self)
			local isActiveTalentGroup = PlayerTalentFrame and not PlayerTalentFrame.pet and PlayerTalentFrame.talentGroup == GetActiveTalentGroup(PlayerTalentFrame.pet);

			for i = 1, NUM_GLYPH_SLOTS do
				local GlyphSocket = _G["GlyphFrameGlyph"..i]
				local _, _, _, _, iconFilename = GetGlyphSocketInfo(i, PlayerTalentFrame.talentGroup)
				if(iconFilename) then
					GlyphSocket.icon:SetTexture(iconFilename)
				else
					GlyphSocket.icon:SetTexture("Interface\\Spellbook\\UI-Glyph-Rune-"..i)
				end
				GlyphFrameGlyph_UpdateSlot(GlyphSocket);
				SetDesaturation(GlyphSocket.icon, not isActiveTalentGroup);
			end
		end)

		GlyphFrame.isSkinned = true
	end

	for i = 1, 3 do
		_G["GlyphFrameHeader"..i]:StripTextures()
		_G["GlyphFrameHeader"..i]:StyleButton()
	end

	local function Glyphs(self, first, i)
		local button = _G["GlyphFrameScrollFrameButton"..i]
		local icon = _G["GlyphFrameScrollFrameButton"..i.."Icon"]

		if(first) then
			button:StripTextures()
		end

		if(icon) then
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
	GlyphFrameClearInfoFrame:Point("BOTTOMLEFT", GlyphFrame, "BOTTOMRIGHT", 28, -2)
	GlyphFrameClearInfoFrame.count:Point("TOPRIGHT", -26, -5)

	S:HandleScrollBar(GlyphFrameScrollFrameScrollBar, 5)
end

S:AddCallbackForAddon("Blizzard_GlyphUI", "Glyph", LoadSkin);