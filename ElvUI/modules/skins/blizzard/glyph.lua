local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule("Skins")

local _G = _G;
local unpack = unpack;

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.talent ~= true then return end

	GlyphFrameScrollFrame:StripTextures()
	GlyphFrameSideInset:StripTextures()
	GlyphFrameScrollFrameScrollChild:StripTextures()

	GlyphFrameSparkleFrame:CreateBackdrop()
	GlyphFrameSparkleFrame.backdrop:Point("TOPLEFT", 3, -3)
	GlyphFrameSparkleFrame.backdrop:Point("BOTTOMRIGHT", -3, 3)
	GlyphFrameSparkleFrame:SetFrameLevel(GlyphFrameSparkleFrame:GetFrameLevel() + 2)

	S:HandleEditBox(GlyphFrameSearchBox)
	S:HandleDropDownBox(GlyphFrameFilterDropDown, 212)

	GlyphFrameBackground:SetParent(GlyphFrameSparkleFrame)
	GlyphFrameBackground:Point("TOPLEFT", 4, -4)
	GlyphFrameBackground:Point("BOTTOMRIGHT", -4, 4)

	GlyphFrame.levelOverlay1:SetParent(GlyphFrameSparkleFrame)
	GlyphFrame.levelOverlayText1:SetParent(GlyphFrameSparkleFrame)

	GlyphFrame.levelOverlay2:SetParent(GlyphFrameSparkleFrame)
	GlyphFrame.levelOverlayText2:SetParent(GlyphFrameSparkleFrame)

	for i = 1, 9 do
		_G["GlyphFrameGlyph"..i]:SetFrameLevel(_G["GlyphFrameGlyph"..i]:GetFrameLevel() + 5)
	end

	for i = 1, 3 do
		_G["GlyphFrameHeader"..i]:StripTextures()
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