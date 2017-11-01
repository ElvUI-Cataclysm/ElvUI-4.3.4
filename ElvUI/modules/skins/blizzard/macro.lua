local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule("Skins");

local _G = _G;
local unpack = unpack;

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.macro ~= true then return end

	local MacroFrame = _G["MacroFrame"]
	MacroFrame:StripTextures();
	MacroFrame:CreateBackdrop("Transparent");
	MacroFrame.backdrop:Point("TOPLEFT", 10, -11);
	MacroFrame.backdrop:Point("BOTTOMRIGHT", -32, 65);

	for i = 1, 2 do
		local tab = _G["MacroFrameTab"..i];
		tab:StripTextures();
		tab:Height(22);
		S:HandleButton(tab);
	end

	MacroFrameTab1:Point("TOPLEFT", MacroFrame, "TOPLEFT", 85, -39);
	MacroFrameTab2:Point("LEFT", MacroFrameTab1, "RIGHT", 4, 0);

	S:HandleButton(MacroDeleteButton);
	MacroDeleteButton:Point("BOTTOMLEFT", 17, 69);

	S:HandleButton(MacroExitButton);
	MacroExitButton:Point("CENTER", MacroFrame, "TOPLEFT", 303, -432);

	S:HandleButton(MacroNewButton);
	MacroNewButton:Point("CENTER", MacroFrame, "TOPLEFT", 220, -432);

	S:HandleButton(MacroSaveButton);
	S:HandleButton(MacroCancelButton);

	MacroFrameCharLimitText:Point("BOTTOM", -15, 100);

	S:HandleCloseButton(MacroFrameCloseButton);
	MacroFrameCloseButton:Point("TOPRIGHT", -29, -7);

	MacroFrameTextBackground:StripTextures();
	MacroFrameTextBackground:SetTemplate("Default");

	MacroButtonScrollFrame:CreateBackdrop("Transparent");

	S:HandleButton(MacroEditButton);
	MacroEditButton:ClearAllPoints();
	MacroEditButton:Point("BOTTOMLEFT", MacroFrameSelectedMacroButton, "BOTTOMRIGHT", 10, 0);

	S:HandleScrollBar(MacroButtonScrollFrame);
	S:HandleScrollBar(MacroButtonScrollFrameScrollBar);
	S:HandleScrollBar(MacroFrameScrollFrameScrollBar);
	S:HandleScrollBar(MacroPopupScrollFrameScrollBar);

	MacroFrameSelectedMacroButton:StripTextures();
	MacroFrameSelectedMacroButton:StyleButton(nil, true);
	MacroFrameSelectedMacroButton:GetNormalTexture():SetTexture(nil);
	MacroFrameSelectedMacroButton:SetTemplate("Default");

	MacroFrameSelectedMacroButtonIcon:SetTexCoord(unpack(E.TexCoords));
	MacroFrameSelectedMacroButtonIcon:SetInside();

	for i = 1, MAX_ACCOUNT_MACROS do
		local button = _G["MacroButton"..i];
		local buttonIcon = _G["MacroButton"..i.."Icon"];

		if(button) then
			button:StripTextures();
			button:StyleButton(nil, true);
			button:SetTemplate("Default", true);
		end

		if(buttonIcon) then
			buttonIcon:SetTexCoord(unpack(E.TexCoords));
			buttonIcon:SetInside();
		end
	end

	S:HandleIconSelectionFrame(MacroPopupFrame, NUM_MACRO_ICONS_SHOWN, "MacroPopupButton", "MacroPopup");

	MacroPopupScrollFrame:CreateBackdrop("Transparent");
	MacroPopupScrollFrame.backdrop:Point("TOPLEFT", 51, 2);
	MacroPopupScrollFrame.backdrop:Point("BOTTOMRIGHT", 0, 4);

	MacroPopupFrame:Point("TOPLEFT", MacroFrame, "TOPRIGHT", -30, -11);
end

S:AddCallbackForAddon("Blizzard_MacroUI", "Macro", LoadSkin);