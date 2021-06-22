local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local unpack = unpack

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.macro then return end

	MacroFrame:StripTextures()
	MacroFrame:CreateBackdrop("Transparent")
	MacroFrame.backdrop:Point("TOPLEFT", 10, -11)
	MacroFrame.backdrop:Point("BOTTOMRIGHT", -32, 65)

	for i = 1, 2 do
		local Tab = _G["MacroFrameTab"..i]

		Tab:StripTextures()
		S:HandleButton(Tab)

		Tab:Height(22)
		Tab:ClearAllPoints()

		if i == 1 then
			Tab:Point("TOPLEFT", MacroFrame, E.PixelMode and 22 or 21, E.PixelMode and -48 or -47)
			Tab:Width(125)
		elseif i == 2 then
			Tab:Point("TOPRIGHT", MacroFrame, E.PixelMode and -66 or -65, E.PixelMode and -48 or -47)
			Tab:Width(168)
		end
		Tab.SetWidth = E.noop
	end

	S:HandleButton(MacroSaveButton)
	S:HandleButton(MacroCancelButton)

	S:HandleButton(MacroEditButton)
	MacroEditButton:Point("TOPLEFT", MacroFrameSelectedMacroBackground, 55, -28)

	S:HandleButton(MacroDeleteButton)
	MacroDeleteButton:Point("BOTTOMLEFT", 17, 71)

	S:HandleButton(MacroNewButton)
	MacroNewButton:Point("CENTER", MacroFrame, "TOPLEFT", 220, -430)

	S:HandleButton(MacroExitButton)
	MacroExitButton:Point("CENTER", MacroFrame, "TOPLEFT", 305, -430)

	S:HandleCloseButton(MacroFrameCloseButton, MacroFrame.backdrop)

	MacroButtonScrollFrame:StripTextures()
	MacroButtonScrollFrame:CreateBackdrop("Transparent")

	S:HandleScrollBar(MacroButtonScrollFrameScrollBar)
	MacroButtonScrollFrameScrollBar:ClearAllPoints()
	MacroButtonScrollFrameScrollBar:Point("TOPRIGHT", MacroButtonScrollFrame, 24, E.PixelMode and -17 or -16)
	MacroButtonScrollFrameScrollBar:Point("BOTTOMRIGHT", MacroButtonScrollFrame, 0, E.PixelMode and 17 or 16)

	MacroFrameTextBackground:StripTextures()
	MacroFrameTextBackground:CreateBackdrop()
	MacroFrameTextBackground.backdrop:Point("TOPLEFT", E.PixelMode and 4 or 5, -3)
	MacroFrameTextBackground.backdrop:Point("BOTTOMRIGHT", E.PixelMode and -22 or -21, 4)

	S:HandleScrollBar(MacroFrameScrollFrameScrollBar)
	MacroFrameScrollFrameScrollBar:ClearAllPoints()
	MacroFrameScrollFrameScrollBar:Point("TOPRIGHT", MacroFrameScrollFrame, 28, -16)
	MacroFrameScrollFrameScrollBar:Point("BOTTOMRIGHT", MacroFrameScrollFrame, 0, 17)

	MacroFrameSelectedMacroButton:StripTextures()
	MacroFrameSelectedMacroButton:SetTemplate()
	MacroFrameSelectedMacroButton:StyleButton(nil, true)
	MacroFrameSelectedMacroButton:GetNormalTexture():SetTexture(nil)

	MacroFrameSelectedMacroButtonIcon:SetTexCoord(unpack(E.TexCoords))
	MacroFrameSelectedMacroButtonIcon:SetInside()

	MacroFrameCharLimitText:Point("BOTTOM", -15, 102)

	for i = 1, MAX_ACCOUNT_MACROS do
		local button = _G["MacroButton"..i]
		local buttonIcon = _G["MacroButton"..i.."Icon"]

		if button then
			button:StripTextures()
			button:SetTemplate(nil, true)
			button:StyleButton(nil, true)
		end

		if buttonIcon then
			buttonIcon:SetTexCoord(unpack(E.TexCoords))
			buttonIcon:SetInside()
		end
	end

	S:HandleIconSelectionFrame(MacroPopupFrame, NUM_MACRO_ICONS_SHOWN, "MacroPopupButton", "MacroPopup")
	MacroPopupFrame:Point("TOPLEFT", MacroFrame, "TOPRIGHT", E.PixelMode and -30 or -29, -11)
	MacroPopupFrame:Size(282, 290)
end

S:AddCallbackForAddon("Blizzard_MacroUI", "Macro", LoadSkin)