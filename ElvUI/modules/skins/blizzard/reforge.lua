local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local unpack = unpack

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.inspect ~= true then return end

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

	ReforgingFrameItemButton.missingText:SetTextColor(1, 0.80, 0.10)
	ReforgingFrame.missingDescription:SetTextColor(1, 1, 1)

	hooksecurefunc("ReforgingFrame_Update", function(self)
		local _, icon, _, quality = GetReforgeItemInfo()
		if icon then
			ReforgingFrameItemButtonIconTexture:SetTexCoord(unpack(E.TexCoords))
		else
			ReforgingFrameItemButtonIconTexture:SetTexture(nil)
		end
		if quality then
			ReforgingFrameItemButton:SetBackdropBorderColor(GetItemQualityColor(quality))
		else
			ReforgingFrameItemButton:SetBackdropBorderColor(unpack(E["media"].bordercolor))
		end
	end)

	S:HandleCloseButton(ReforgingFrameCloseButton)
end

S:AddCallbackForAddon("Blizzard_ReforgingUI", "ReforgingUI", LoadSkin)