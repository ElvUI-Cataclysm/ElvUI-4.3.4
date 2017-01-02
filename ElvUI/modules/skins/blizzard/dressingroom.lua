local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule("Skins")

local _G = _G;

local SetDressUpBackground = SetDressUpBackground;

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.dressingroom ~= true then return end

	-- Dressing Room
	DressUpFrame:CreateBackdrop("Transparent");
	DressUpFrame.backdrop:Point("TOPLEFT", 10, -12);
	DressUpFrame.backdrop:Point("BOTTOMRIGHT", -33, 73);

	DressUpFrame:StripTextures();
	DressUpFramePortrait:Kill();

	S:HandleCloseButton(DressUpFrameCloseButton, DressUpFrame.backdrop);

	S:HandleButton(DressUpFrameResetButton);
	DressUpFrameResetButton:Point("RIGHT", DressUpFrameCancelButton, "LEFT", -3, 0);

	S:HandleButton(DressUpFrameCancelButton);
	DressUpFrameCancelButton:Point("CENTER", DressUpFrame, "TOPLEFT", 306, -423);

	DressUpFrameDescriptionText:Point("CENTER", DressUpFrameTitleText, "BOTTOM", -7, -22);

	DressUpModel:CreateBackdrop("Default");
	DressUpModel.backdrop:SetOutside(DressUpBackgroundTopLeft, nil, nil, DressUpModel);

	local DressUpFrameUndressButton = CreateFrame("Button", "DressUpFrameUndressButton", DressUpFrame, "UIPanelButtonTemplate");
	DressUpFrameUndressButton:SetText(L["Undress"]);
	DressUpFrameUndressButton:Size(80, 22);
	DressUpFrameUndressButton:SetParent(DressUpFrame);
	DressUpFrameUndressButton:Point("RIGHT", DressUpFrameResetButton, "LEFT", -3, 0);
	DressUpFrameUndressButton:HookScript("OnClick", function(self)
		self.model:Undress();
		PlaySound("gsTitleOptionOK");
	end)
	DressUpFrameUndressButton.model = DressUpModel;

	S:HandleButton(DressUpFrameUndressButton);

	-- Side Dressing Room
	SideDressUpFrame:StripTextures();
	SideDressUpFrame:CreateBackdrop("Transparent");
	SideDressUpFrame.backdrop:Point("TOPLEFT", 1, 5);
	SideDressUpFrame.backdrop:Point("BOTTOMRIGHT", -4, 3);

	S:HandleButton(SideDressUpModelResetButton);
	SideDressUpModelResetButton:Point("BOTTOM", 43, 0);

	S:HandleCloseButton(SideDressUpModelCloseButton);
	SideDressUpModelCloseButton:Point("CENTER", SideDressUpFrame, "TOPRIGHT", -14, -6);

	local SideDressUpFrameUndressButton = CreateFrame("Button", "SideDressUpFrameUndressButton", SideDressUpFrame, "UIPanelButtonTemplate");
	SideDressUpFrameUndressButton:SetText(L["Undress"]);
	SideDressUpFrameUndressButton:Size(80, 22);
	SideDressUpFrameUndressButton:SetParent(SideDressUpModel);
	SideDressUpFrameUndressButton:Point("RIGHT", SideDressUpModelResetButton, "LEFT", -3, 0);
	SideDressUpFrameUndressButton:HookScript("OnClick", function(self)
		self.model:Undress();
		PlaySound("gsTitleOptionOK");
	end)
	SideDressUpFrameUndressButton.model = SideDressUpModel;

	S:HandleButton(SideDressUpFrameUndressButton);

	--Model Backgrounds
	SetDressUpBackground();

	DressUpBackgroundTopLeft:SetDesaturated(true);
	DressUpBackgroundTopRight:SetDesaturated(true);
	DressUpBackgroundBotLeft:SetDesaturated(true);
	DressUpBackgroundBotRight:SetDesaturated(true);

	SideDressUpFrameBackgroundTop:SetDesaturated(true);
	SideDressUpFrameBackgroundBot:SetDesaturated(true);

	--Control buttons
	DressUpModelControlFrame:StripTextures();
	SideDressUpModelControlFrame:StripTextures();

	local controlbuttons = {
		"DressUpModelControlFrameZoomInButton",
		"DressUpModelControlFrameZoomOutButton",
		"DressUpModelControlFramePanButton",
		"DressUpModelControlFrameRotateLeftButton",
		"DressUpModelControlFrameRotateRightButton",
		"DressUpModelControlFrameRotateResetButton",
		"SideDressUpModelControlFrameZoomInButton",
		"SideDressUpModelControlFrameZoomOutButton",
		"SideDressUpModelControlFramePanButton",
		"SideDressUpModelControlFrameRotateRightButton",
		"SideDressUpModelControlFrameRotateLeftButton",
		"SideDressUpModelControlFrameRotateResetButton"
	};

	for i = 1, getn(controlbuttons) do
		S:HandleButton(_G[controlbuttons[i]]);
		_G[controlbuttons[i]]:StyleButton();
		_G[controlbuttons[i].."Bg"]:Hide();
	end
end

S:AddCallback("DressingRoom", LoadSkin);