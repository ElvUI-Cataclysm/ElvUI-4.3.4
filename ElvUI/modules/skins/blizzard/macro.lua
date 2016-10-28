local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins');

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.macro ~= true then return end

	S:HandleScrollBar(MacroButtonScrollFrameScrollBar, 5)
	S:HandleScrollBar(MacroFrameScrollFrameScrollBar, 5)
	S:HandleScrollBar(MacroPopupScrollFrameScrollBar, 5)

	MacroFrame:Width(360)
	MacroFrame:Height(470)

	local buttons = {
		"MacroSaveButton",
		"MacroCancelButton",
		"MacroDeleteButton",
		"MacroNewButton",
		"MacroExitButton",
		"MacroEditButton",
		"MacroFrameTab1",
		"MacroFrameTab2"
	}

	for i = 1, #buttons do
		_G[buttons[i]]:StripTextures()
		S:HandleButton(_G[buttons[i]])
	end

	for i = 1, 2 do
		local tab = _G[format("MacroFrameTab%s", i)]
		tab:Height(22)
	end

	MacroFrameTab1:Point("TOPLEFT", MacroFrame, "TOPLEFT", 85, -39)
	MacroFrameTab2:Point("LEFT", MacroFrameTab1, "RIGHT", 4, 0)

	MacroDeleteButton:Point("BOTTOMLEFT", MacroFrame, "BOTTOMLEFT", 15, 38)
	
	S:HandleCloseButton(MacroFrameCloseButton)
	MacroFrameCloseButton:Point("TOPRIGHT", MacroFrame, "TOPRIGHT", 1, 1)

	MacroFrame:StripTextures()
	MacroFrame:SetTemplate("Transparent")

	MacroFrameTextBackground:StripTextures()
	MacroFrameTextBackground:SetTemplate("Default")

	MacroButtonScrollFrame:CreateBackdrop("Transparent")

	MacroEditButton:ClearAllPoints()
	MacroEditButton:Point("BOTTOMLEFT", MacroFrameSelectedMacroButton, "BOTTOMRIGHT", 10, 0)

	S:HandleScrollBar(MacroButtonScrollFrame)

	MacroFrameSelectedMacroButton:StripTextures()
	MacroFrameSelectedMacroButton:StyleButton(nil, true)
	MacroFrameSelectedMacroButton:GetNormalTexture():SetTexture(nil)
	MacroFrameSelectedMacroButton:SetTemplate("Default")

	MacroFrameSelectedMacroButtonIcon:SetTexCoord(unpack(E.TexCoords))
	MacroFrameSelectedMacroButtonIcon:ClearAllPoints()
	MacroFrameSelectedMacroButtonIcon:SetInside()

	MacroFrameCharLimitText:ClearAllPoints()
	MacroFrameCharLimitText:Point("BOTTOM", MacroFrameTextBackground, 0, -70)

	for i = 1, MAX_ACCOUNT_MACROS do
		local button = _G["MacroButton"..i]
		local buttonIcon = _G["MacroButton"..i.."Icon"]

		if(button) then
			button:StripTextures()
			button:StyleButton(nil, true)
			button:SetTemplate("Default", true)
		end

		if(buttonIcon) then
			buttonIcon:SetTexCoord(unpack(E.TexCoords))
			buttonIcon:ClearAllPoints()
			buttonIcon:SetInside()
		end
	end

	S:HandleIconSelectionFrame(MacroPopupFrame, NUM_MACRO_ICONS_SHOWN, "MacroPopupButton", "MacroPopup")

	MacroPopupScrollFrame:CreateBackdrop("Transparent")
	MacroPopupScrollFrame.backdrop:Point("TOPLEFT", 51, 2)
	MacroPopupScrollFrame.backdrop:Point("BOTTOMRIGHT", 0, 4)

	MacroPopupFrame:Point("TOPLEFT", MacroFrame, "TOPRIGHT", 1, 0)
end

S:AddCallbackForAddon("Blizzard_MacroUI", "Macro", LoadSkin);