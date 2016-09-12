local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins')

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.dressingroom ~= true then return end

	DressUpFrame:StripTextures(true)
	DressUpFrame:CreateBackdrop("Transparent")
	DressUpFrame.backdrop:Point("TOPLEFT", 6, 0)
	DressUpFrame.backdrop:Point("BOTTOMRIGHT", -32, 70)

	S:HandleButton(DressUpFrameResetButton)
	S:HandleButton(DressUpFrameCancelButton)
	S:HandleCloseButton(DressUpFrameCloseButton, DressUpFrame.backdrop)

	DressUpFrameResetButton:Point("RIGHT", DressUpFrameCancelButton, "LEFT", -2, 0)

	local controlbuttons = {
		"DressUpModelControlFrameZoomInButton",
		"DressUpModelControlFrameZoomOutButton",
		"DressUpModelControlFramePanButton",
		"DressUpModelControlFrameRotateLeftButton",
		"DressUpModelControlFrameRotateRightButton",
		"DressUpModelControlFrameRotateResetButton",
	}

	for i = 1, getn(controlbuttons) do
		S:HandleButton(_G[controlbuttons[i]]);
		_G[controlbuttons[i]]:StyleButton()
		_G[controlbuttons[i].."Bg"]:Hide()
	end

	DressUpModelControlFrame:StripTextures()
	DressUpModelControlFrame:Point("TOP", DressUpModel, "TOP", 0, 10)

end

S:RegisterSkin('ElvUI', LoadSkin)