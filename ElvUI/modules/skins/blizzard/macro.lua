local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins');

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.macro ~= true then return end

	S:HandleCloseButton(MacroFrameCloseButton)

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
		"MacroFrameTab2",
		"MacroPopupOkayButton",
		"MacroPopupCancelButton",
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
	MacroFrameCloseButton:Point("TOPRIGHT", MacroFrame, "TOPRIGHT", 1, 1)

	MacroFrame:StripTextures()
	MacroFrame:SetTemplate("Transparent")

	MacroFrameTextBackground:StripTextures()
	MacroFrameTextBackground:SetTemplate('Default')

	MacroButtonScrollFrame:CreateBackdrop("Transparent")

	MacroPopupFrame:StripTextures()
	MacroPopupFrame:SetTemplate("Transparent")

	MacroPopupScrollFrame:StripTextures()
	MacroPopupScrollFrame:CreateBackdrop()
	MacroPopupScrollFrame.backdrop:Point("TOPLEFT", 51, 2)
	MacroPopupScrollFrame.backdrop:Point("BOTTOMRIGHT", -4, 4)

	MacroPopupEditBox:CreateBackdrop()
	MacroPopupEditBox:StripTextures()

	MacroEditButton:ClearAllPoints()
	MacroEditButton:Point("BOTTOMLEFT", MacroFrameSelectedMacroButton, "BOTTOMRIGHT", 10, 0)

	S:HandleScrollBar(MacroButtonScrollFrame)

	MacroPopupFrame:HookScript("OnShow", function(self)
		self:ClearAllPoints()
		self:Point("TOPLEFT", MacroFrame, "TOPRIGHT", 1, 0)
	end)

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
		local macroButton = _G["MacroPopupButton"..i]
		local macroButtonIcon = _G["MacroPopupButton"..i.."Icon"]

		if button then
			button:StripTextures()
			button:StyleButton(nil, true)
			button:SetTemplate("Default", true)
		end

		if buttonIcon then
			buttonIcon:SetTexCoord(unpack(E.TexCoords))
			buttonIcon:ClearAllPoints()
			buttonIcon:SetInside()
		end

		if macroButton then
			macroButton:StripTextures()
			macroButton:StyleButton(nil, true)
			macroButton:CreateBackdrop("Default", true)
		end

		if macroButtonIcon then
			macroButtonIcon:SetTexCoord(unpack(E.TexCoords))
			macroButtonIcon:ClearAllPoints()
			macroButtonIcon:SetInside()
		end
	end
end

S:AddCallbackForAddon("Blizzard_MacroUI", "Macro", LoadSkin);