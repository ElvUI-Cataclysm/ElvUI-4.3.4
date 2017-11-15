local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule("Skins")

local _G = _G;
local pairs, unpack, select = pairs, unpack, select;

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.transmogrify ~= true then return end

	TransmogrifyFrame:StripTextures()
	TransmogrifyFrame:SetTemplate("Transparent")

	TransmogrifyArtFrame:StripTextures()

	TransmogrifyFrameButtonFrame:StripTextures()

	select(2, TransmogrifyModelFrame:GetRegions()):Kill()
	TransmogrifyModelFrame:SetFrameLevel(TransmogrifyFrame:GetFrameLevel() + 2)
	TransmogrifyModelFrame:CreateBackdrop()

	TransmogrifyModelFrameLines:SetInside(TransmogrifyModelFrame.backdrop)
	TransmogrifyModelFrameMarbleBg:SetInside(TransmogrifyModelFrame.backdrop)

	S:HandleButton(TransmogrifyApplyButton, true)
	TransmogrifyApplyButton:Point("BOTTOMRIGHT", -4, 4)

	S:HandleCloseButton(TransmogrifyArtFrameCloseButton)

	local slots = {
		"Head",
		"Shoulder",
		"Chest",
		"Waist",
		"Legs",
		"Feet",
		"Wrist",
		"Hands",
		"Back",
		"MainHand",
		"SecondaryHand",
		"Ranged"
	}

	for _, slot in pairs(slots) do
		local icon = _G["TransmogrifyFrame"..slot.."SlotIconTexture"]
		local slot = _G["TransmogrifyFrame"..slot.."Slot"]

		if(slot) then
			slot:StripTextures()
			slot:StyleButton(false)
			slot:SetFrameLevel(slot:GetFrameLevel() + 2)
			slot:CreateBackdrop("Default")
			slot.backdrop:SetAllPoints()

			icon:SetTexCoord(unpack(E.TexCoords))
			icon:SetInside()
		end
	end

	-- Control Frame
	TransmogrifyModelFrameControlFrame:StripTextures()
	TransmogrifyModelFrameControlFrame:Size(123, 23)

	local controlbuttons = {
		"TransmogrifyModelFrameControlFrameZoomInButton",
		"TransmogrifyModelFrameControlFrameZoomOutButton",
		"TransmogrifyModelFrameControlFramePanButton",
		"TransmogrifyModelFrameControlFrameRotateRightButton",
		"TransmogrifyModelFrameControlFrameRotateLeftButton",
		"TransmogrifyModelFrameControlFrameRotateResetButton"
	}

	for i = 1, #controlbuttons do
		S:HandleButton(_G[controlbuttons[i]])
		_G[controlbuttons[i].."Bg"]:Hide()
	end

	TransmogrifyModelFrameControlFrameZoomOutButton:Point("LEFT", "TransmogrifyModelFrameControlFrameZoomInButton", "RIGHT", 2, 0)
	TransmogrifyModelFrameControlFramePanButton:Point("LEFT", "TransmogrifyModelFrameControlFrameZoomOutButton", "RIGHT", 2, 0)
	TransmogrifyModelFrameControlFrameRotateRightButton:Point("LEFT", "TransmogrifyModelFrameControlFramePanButton", "RIGHT", 2, 0)
	TransmogrifyModelFrameControlFrameRotateLeftButton:Point("LEFT", "TransmogrifyModelFrameControlFrameRotateRightButton", "RIGHT", 2, 0)
	TransmogrifyModelFrameControlFrameRotateResetButton:Point("LEFT", "TransmogrifyModelFrameControlFrameRotateLeftButton", "RIGHT", 2, 0)
end

S:AddCallbackForAddon("Blizzard_ItemAlterationUI", "ItemAlterationUI", LoadSkin);