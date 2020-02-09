local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G

local SetDressUpBackground = SetDressUpBackground

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.dressingroom then return end

	-- Dressing Room
	local DressUpFrame = _G["DressUpFrame"]
	DressUpFrame:StripTextures()
	DressUpFrame:CreateBackdrop("Transparent")
	DressUpFrame.backdrop:Point("TOPLEFT", 10, -12)
	DressUpFrame.backdrop:Point("BOTTOMRIGHT", -33, 73)

	DressUpFramePortrait:Kill()

	S:HandleCloseButton(DressUpFrameCloseButton, DressUpFrame.backdrop)

	S:HandleButton(DressUpFrameResetButton)
	DressUpFrameResetButton:Point("RIGHT", DressUpFrameCancelButton, "LEFT", -3, 0)

	S:HandleButton(DressUpFrameCancelButton)
	DressUpFrameCancelButton:Point("CENTER", DressUpFrame, "TOPLEFT", 306, -423)

	DressUpFrameDescriptionText:Point("CENTER", DressUpFrameTitleText, "BOTTOM", -7, -22)

	DressUpModel:CreateBackdrop("Default")
	DressUpModel.backdrop:SetOutside(DressUpBackgroundTopLeft, nil, nil, DressUpModel)

	-- Side Dressing Room
	SideDressUpFrame:StripTextures()
	SideDressUpFrame:CreateBackdrop("Transparent")
	SideDressUpFrame.backdrop:Point("TOPLEFT", 1, 9)
	SideDressUpFrame.backdrop:Point("BOTTOMRIGHT", -6, 5)

	SideDressUpModel:CreateBackdrop()
	SideDressUpModel.backdrop:Point("BOTTOMRIGHT", 1, -2)

	S:HandleButton(SideDressUpModelResetButton)
	SideDressUpModelResetButton:Point("BOTTOM", 0, 2)

	S:HandleCloseButton(SideDressUpModelCloseButton)
	SideDressUpModelCloseButton:Point("CENTER", SideDressUpFrame, "TOPRIGHT", -18, -2)

	--Model Backgrounds
	SetDressUpBackground()

	DressUpBackgroundTopLeft:SetDesaturated(true)
	DressUpBackgroundTopRight:SetDesaturated(true)
	DressUpBackgroundBotLeft:SetDesaturated(true)
	DressUpBackgroundBotRight:SetDesaturated(true)

	SideDressUpFrameBackgroundTop:SetDesaturated(true)
	SideDressUpFrameBackgroundBot:SetDesaturated(true)

	-- Control Frame
	S:HandleModelControlFrame(DressUpModelControlFrame)
	S:HandleModelControlFrame(SideDressUpModelControlFrame)
end

S:AddCallback("DressingRoom", LoadSkin)