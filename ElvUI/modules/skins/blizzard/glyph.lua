local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local unpack = unpack
local strfind = strfind

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.talent ~= true then return end

	GlyphFrame:StripTextures()
	GlyphFrame:CreateBackdrop("Transparent")

	GlyphFrameScrollFrame:StripTextures()
	GlyphFrameSideInset:StripTextures()
	GlyphFrameScrollFrameScrollChild:StripTextures()

	S:HandleEditBox(GlyphFrameSearchBox)
	S:HandleDropDownBox(GlyphFrameFilterDropDown, 206)
	GlyphFrameFilterDropDown:Point("TOPLEFT", GlyphFrameSearchBox, "BOTTOMLEFT", -13, -3)

	GlyphFrame.levelOverlayText1:SetTextColor(1, 1, 1)
	GlyphFrame.levelOverlayText2:SetTextColor(1, 1, 1)

	if not GlyphFrame.isSkinned then
		for i = 1, 9 do
			local frame = _G["GlyphFrameGlyph"..i]

			frame:SetTemplate("Default", true)
			frame:SetFrameLevel(frame:GetFrameLevel() + 5)
			frame:StyleButton(nil, true)

			frame.ring:Hide()
			frame.glyph:Hide()
			frame.highlight:SetTexture(nil)
			frame.glyph:Hide()

			frame.icon = frame:CreateTexture(nil, "OVERLAY")
			frame.icon:SetInside()
			frame.icon:SetTexCoord(unpack(E.TexCoords))

			frame:CreateBackdrop()
			frame.backdrop:SetAllPoints()
			frame.backdrop:SetFrameLevel(frame:GetFrameLevel() + 1)
			frame.backdrop:SetBackdropColor(0, 0, 0, 0)
			frame.backdrop:SetBackdropBorderColor(1, 0.80, 0.10)

			frame.backdrop:SetScript("OnUpdate", function(self)
				local alpha = frame.highlight:GetAlpha()
				self:SetAlpha(alpha)

				if strfind(frame.icon:GetTexture(), "Interface\\Spellbook\\UI%-Glyph%-Rune") then
					if alpha == 0 then
						frame.icon:SetVertexColor(1, 1, 1)
						frame.icon:SetAlpha(1)
					else
						frame.icon:SetVertexColor(1, 0.80, 0.10)
						frame.icon:SetAlpha(alpha)
					end
				end
			end)

			hooksecurefunc(frame.highlight, "Show", function()
				frame.backdrop:Show()
			end)

			frame.glyph:Hide()
			hooksecurefunc(frame.glyph, "Show", function(self) self:Hide() end)

			if i == 1 or i == 4 or i == 6 then
				frame:Size(frame:GetSize() * 0.9)
			elseif i == 2 or i == 3 or i == 5 then
				frame:Size(frame:GetSize() * 0.6)
			else
				frame:Size(frame:GetSize() * 1.2)
			end
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

		GlyphFrame.isSkinned = true
	end

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