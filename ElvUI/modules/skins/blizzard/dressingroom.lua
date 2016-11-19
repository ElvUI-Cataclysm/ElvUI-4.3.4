local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule("Skins")

local SetDressUpBackground = SetDressUpBackground;

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.dressingroom ~= true then return end

	DressUpFrame:CreateBackdrop("Transparent");
	DressUpFrame.backdrop:Point("TOPLEFT", 10, -12);
	DressUpFrame.backdrop:Point("BOTTOMRIGHT", -33, 73);

	DressUpFrame:StripTextures();
	DressUpFramePortrait:Kill();

	SetDressUpBackground();
	DressUpBackgroundTopLeft:SetDesaturated(true);
	DressUpBackgroundTopRight:SetDesaturated(true);
	DressUpBackgroundBotLeft:SetDesaturated(true);
	DressUpBackgroundBotRight:SetDesaturated(true);

	S:HandleCloseButton(DressUpFrameCloseButton, DressUpFrame.backdrop)

	S:HandleButton(DressUpFrameResetButton)
	DressUpFrameResetButton:Point("RIGHT", DressUpFrameCancelButton, "LEFT", -3, 0)

	S:HandleButton(DressUpFrameCancelButton)
	DressUpFrameCancelButton:Point("CENTER", DressUpFrame, "TOPLEFT", 306, -423);

	DressUpFrameDescriptionText:Point("CENTER", DressUpFrameTitleText, "BOTTOM", -7, -22)

	DressUpModel:CreateBackdrop("Default");
	DressUpModel.backdrop:SetOutside(DressUpBackgroundTopLeft, nil, nil, DressUpModel);

	local controlbuttons = {
		"DressUpModelControlFrameZoomInButton",
		"DressUpModelControlFrameZoomOutButton",
		"DressUpModelControlFramePanButton",
		"DressUpModelControlFrameRotateLeftButton",
		"DressUpModelControlFrameRotateRightButton",
		"DressUpModelControlFrameRotateResetButton"
	}

	for i = 1, getn(controlbuttons) do
		S:HandleButton(_G[controlbuttons[i]]);
		_G[controlbuttons[i]]:StyleButton()
		_G[controlbuttons[i].."Bg"]:Hide()
	end

	DressUpModelControlFrame:StripTextures()
end

S:AddCallback("DressingRoom", LoadSkin);