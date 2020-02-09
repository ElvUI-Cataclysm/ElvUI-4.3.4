local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local unpack = unpack

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.macro then return end

	local MacroFrame = _G["MacroFrame"]
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
			Tab:Point("TOPLEFT", MacroFrame, "TOPLEFT", 22, -50)
			Tab:Width(125)
		elseif i == 2 then
			Tab:Point("TOPRIGHT", MacroFrame, "TOPRIGHT", -66, -50)
			Tab:Width(168)
		end
		Tab.SetWidth = E.noop
	end

	S:HandleButton(MacroDeleteButton)
	MacroDeleteButton:Point("BOTTOMLEFT", 17, 69)

	S:HandleButton(MacroExitButton)
	MacroExitButton:Point("CENTER", MacroFrame, "TOPLEFT", 303, -432)

	S:HandleButton(MacroNewButton)
	MacroNewButton:Point("CENTER", MacroFrame, "TOPLEFT", 220, -432)

	S:HandleButton(MacroSaveButton)

	S:HandleButton(MacroCancelButton)
	MacroCancelButton:Point("BOTTOMRIGHT", MacroFrameScrollFrame, "TOPRIGHT", 26, 10)

	MacroFrameCharLimitText:Point("BOTTOM", -15, 100)

	S:HandleCloseButton(MacroFrameCloseButton)
	MacroFrameCloseButton:Point("TOPRIGHT", -29, -7)

	MacroFrameTextBackground:StripTextures()
	MacroFrameTextBackground:CreateBackdrop("Default")
	MacroFrameTextBackground.backdrop:Point("TOPLEFT", 5, -3)
	MacroFrameTextBackground.backdrop:Point("BOTTOMRIGHT", -22, 4)

	MacroButtonScrollFrame:StripTextures()
	MacroButtonScrollFrame:CreateBackdrop("Transparent")

	S:HandleButton(MacroEditButton)
	MacroEditButton:ClearAllPoints()
	MacroEditButton:Point("BOTTOMLEFT", MacroFrameSelectedMacroButton, "BOTTOMRIGHT", 10, 0)

	S:HandleScrollBar(MacroButtonScrollFrameScrollBar)
	MacroButtonScrollFrameScrollBar:ClearAllPoints()
	MacroButtonScrollFrameScrollBar:Point("TOPRIGHT", MacroButtonScrollFrame, "TOPRIGHT", 21, -17)
	MacroButtonScrollFrameScrollBar:Point("BOTTOMRIGHT", MacroButtonScrollFrame, "BOTTOMRIGHT", 0, 17)

	S:HandleScrollBar(MacroFrameScrollFrameScrollBar)
	MacroFrameScrollFrameScrollBar:ClearAllPoints()
	MacroFrameScrollFrameScrollBar:Point("TOPRIGHT", MacroFrameScrollFrame, "TOPRIGHT", 25, -16)
	MacroFrameScrollFrameScrollBar:Point("BOTTOMRIGHT", MacroFrameScrollFrame, "BOTTOMRIGHT", 0, 17)

	S:HandleScrollBar(MacroPopupScrollFrameScrollBar)
	MacroPopupScrollFrameScrollBar:ClearAllPoints()
	MacroPopupScrollFrameScrollBar:Point("TOPRIGHT", MacroPopupScrollFrame, "TOPRIGHT", 23, -16)
	MacroPopupScrollFrameScrollBar:Point("BOTTOMRIGHT", MacroPopupScrollFrame, "BOTTOMRIGHT", 0, 22)

	MacroFrameSelectedMacroButton:StripTextures()
	MacroFrameSelectedMacroButton:StyleButton(nil, true)
	MacroFrameSelectedMacroButton:GetNormalTexture():SetTexture(nil)
	MacroFrameSelectedMacroButton:SetTemplate("Default")

	MacroFrameSelectedMacroButtonIcon:SetTexCoord(unpack(E.TexCoords))
	MacroFrameSelectedMacroButtonIcon:SetInside()

	for i = 1, MAX_ACCOUNT_MACROS do
		local button = _G["MacroButton"..i]
		local buttonIcon = _G["MacroButton"..i.."Icon"]

		if button then
			button:StripTextures()
			button:SetTemplate("Default", true)
			button:StyleButton(nil, true)
		end

		if buttonIcon then
			buttonIcon:SetTexCoord(unpack(E.TexCoords))
			buttonIcon:SetInside()
		end
	end

	S:HandleIconSelectionFrame(MacroPopupFrame, NUM_MACRO_ICONS_SHOWN, "MacroPopupButton", "MacroPopup")

	MacroPopupScrollFrame:CreateBackdrop("Transparent")
	MacroPopupScrollFrame.backdrop:Point("TOPLEFT", 51, 2)
	MacroPopupScrollFrame.backdrop:Point("BOTTOMRIGHT", 0, 4)

	MacroPopupFrame:Point("TOPLEFT", MacroFrame, "TOPRIGHT", -30, -11)
end

S:AddCallbackForAddon("Blizzard_MacroUI", "Macro", LoadSkin)