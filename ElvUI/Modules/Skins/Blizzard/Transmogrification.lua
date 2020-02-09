local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local pairs, unpack, select = pairs, unpack, select

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.transmogrify then return end

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
		"HeadSlot", "ShoulderSlot", "ChestSlot", "WaistSlot",
		"LegsSlot", "FeetSlot", "WristSlot", "HandsSlot", "BackSlot",
		"MainHandSlot", "SecondaryHandSlot", "RangedSlot"
	}

	for _, slot in pairs(slots) do
		local item = _G["TransmogrifyFrame"..slot]
		local icon = _G["TransmogrifyFrame"..slot.."IconTexture"]

		if item then
			item:StripTextures()
			item:StyleButton(false)
			item:SetFrameLevel(item:GetFrameLevel() + 2)
			item:CreateBackdrop("Default")
			item.backdrop:SetAllPoints()

			icon:SetTexCoord(unpack(E.TexCoords))
			icon:SetInside()
		end
	end

	-- Control Frame
	S:HandleModelControlFrame(TransmogrifyModelFrameControlFrame)
end

S:AddCallbackForAddon("Blizzard_ItemAlterationUI", "ItemAlterationUI", LoadSkin)