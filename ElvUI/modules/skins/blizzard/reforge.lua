local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins')

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.inspect ~= true then return end

	ReforgingFrame:StripTextures()
	ReforgingFrame:SetTemplate("Transparent")

	ReforgingFrameButtonFrame:StripTextures()
	ReforgingFrameReforgeButton:ClearAllPoints()
	ReforgingFrameReforgeButton:Point("LEFT", ReforgingFrameRestoreButton, "RIGHT", 2, 0)
	ReforgingFrameReforgeButton:Point("BOTTOMRIGHT", -3, 3)
	ReforgingFrameRestoreMessage:SetTextColor(1, 1, 1);

	S:HandleButton(ReforgingFrameRestoreButton, true)
	S:HandleButton(ReforgingFrameReforgeButton, true)

	ReforgingFrameItemButton:StripTextures()
	ReforgingFrameItemButton:SetTemplate("Default", true)
	ReforgingFrameItemButton:StyleButton()
	ReforgingFrameItemButtonIconTexture:ClearAllPoints()
	ReforgingFrameItemButtonIconTexture:Point("TOPLEFT", 2, -2)
	ReforgingFrameItemButtonIconTexture:Point("BOTTOMRIGHT", -2, 2)

	hooksecurefunc("ReforgingFrame_Update", function(self)
		local _, icon, _, quality = GetReforgeItemInfo()
		if(icon) then
			ReforgingFrameItemButtonIconTexture:SetTexCoord(unpack(E.TexCoords))
		else
			ReforgingFrameItemButtonIconTexture:SetTexture(nil)
		end
		if(quality and quality > 1) then
			ReforgingFrameItemButton:SetBackdropBorderColor(GetItemQualityColor(quality));
		else
			ReforgingFrameItemButton:SetTemplate("Default", true)
		end
	end)

	S:HandleCloseButton(ReforgingFrameCloseButton)
end

S:AddCallbackForAddon("Blizzard_ReforgingUI", "ReforgingUI", LoadSkin);