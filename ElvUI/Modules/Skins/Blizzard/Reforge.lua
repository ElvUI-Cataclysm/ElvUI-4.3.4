local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local unpack = unpack

local GetReforgeItemInfo = GetReforgeItemInfo

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.reforge then return end

	ReforgingFrame:StripTextures()
	ReforgingFrame:SetTemplate("Transparent")

	ReforgingFrameFinishedGlow:Kill()

	ReforgingFrameButtonFrame:StripTextures()

	ReforgingFrameRestoreMessage:SetTextColor(1, 1, 1)

	S:HandleButton(ReforgingFrameRestoreButton, true)

	S:HandleButton(ReforgingFrameReforgeButton, true)
	ReforgingFrameReforgeButton:Point("BOTTOMRIGHT", -3, 3)

	ReforgingFrameItemButton:StripTextures()
	ReforgingFrameItemButton:SetTemplate("Default", true)
	ReforgingFrameItemButton:StyleButton()

	ReforgingFrameItemButtonIconTexture:SetInside()
	ReforgingFrameItemButtonIconTexture:SetTexCoord(unpack(E.TexCoords))
	ReforgingFrameItemButtonIconTexture.SetTexCoord = E.noop

	ReforgingFrameItemButton.missingText:SetTextColor(1, 0.80, 0.10)
	ReforgingFrame.missingDescription:SetTextColor(1, 1, 1)

	hooksecurefunc("ReforgingFrame_Update", function(self)
		local _, icon, _, quality = GetReforgeItemInfo()

		if not icon then
			ReforgingFrameItemButtonIconTexture:SetTexture()
		end

		if quality then
			ReforgingFrameItemButton:SetBackdropBorderColor(GetItemQualityColor(quality))
		else
			ReforgingFrameItemButton:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
	end)

	S:HandleCloseButton(ReforgingFrameCloseButton)
end

S:AddCallbackForAddon("Blizzard_ReforgingUI", "ReforgingUI", LoadSkin)