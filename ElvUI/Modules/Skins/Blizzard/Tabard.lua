local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G

local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.tabard then return end

	TabardFrame:StripTextures()
	TabardFrame:CreateBackdrop("Transparent")
	TabardFrame.backdrop:Point("TOPLEFT", 10, -12)
	TabardFrame.backdrop:Point("BOTTOMRIGHT", -32, 74)

	S:SetUIPanelWindowInfo(TabardFrame, "width")
	S:SetBackdropHitRect(TabardFrame)

	TabardFramePortrait:Kill()

	TabardFrameCostFrame:StripTextures()
	TabardFrameCustomizationFrame:StripTextures()

	TabardModel:CreateBackdrop("Transparent")

	S:HandleButton(TabardFrameCancelButton)
	S:HandleButton(TabardFrameAcceptButton)

	S:HandleCloseButton(TabardFrameCloseButton)

	for i = 1, 5 do
		local custom = _G["TabardFrameCustomization"..i]

		custom:StripTextures()

		if i > 1 then
			custom:ClearAllPoints()
			custom:Point("TOP", _G["TabardFrameCustomization"..i - 1], "BOTTOM", 0, -6)
		else
			local point, anchor, point2, x, y = custom:GetPoint()
			custom:Point(point, anchor, point2, x, y + 4)
		end

		S:HandleNextPrevButton(_G["TabardFrameCustomization"..i.."LeftButton"])
		S:HandleNextPrevButton(_G["TabardFrameCustomization"..i.."RightButton"])
	end

	S:HandleRotateButton(TabardCharacterModelRotateLeftButton)
	TabardCharacterModelRotateLeftButton:Point("BOTTOMLEFT", 4, 4)

	hooksecurefunc(TabardCharacterModelRotateLeftButton, "SetPoint", function(self, point, _, _, xOffset, yOffset)
		if point ~= "BOTTOMLEFT" or xOffset ~= 4 or yOffset ~= 4 then
			self:Point("BOTTOMLEFT", 4, 4)
		end
	end)

	S:HandleRotateButton(TabardCharacterModelRotateRightButton)
	TabardCharacterModelRotateRightButton:Point("TOPLEFT", TabardCharacterModelRotateLeftButton, "TOPRIGHT", 4, 0)

	hooksecurefunc(TabardCharacterModelRotateRightButton, "SetPoint", function(self, point, _, _, xOffset, yOffset)
		if point ~= "TOPLEFT" or xOffset ~= 4 or yOffset ~= 0 then
			self:Point("TOPLEFT", TabardCharacterModelRotateLeftButton, "TOPRIGHT", 4, 0)
		end
	end)
end

S:AddCallback("Tabard", LoadSkin)