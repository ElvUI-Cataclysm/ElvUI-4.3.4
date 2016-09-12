local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins')

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.voidstorage ~= true then return end

	local StripAllTextures = {
		"VoidStorageBorderFrame",
		"VoidStorageDepositFrame",
		"VoidStorageWithdrawFrame",
		"VoidStorageCostFrame",
		"VoidStorageStorageFrame",
		"VoidStoragePurchaseFrame",
		"VoidItemSearchBox",
	}

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end

	VoidStorageFrame:SetTemplate("Transparent")
	VoidStorageFrame:SetHeight(410)
	VoidStorageFrame:SetWidth(675)
	VoidStoragePurchaseFrame:SetTemplate("Default")
	VoidStorageFrameMarbleBg:Kill()
	VoidStorageFrameLines:Kill()
	select(2, VoidStorageFrame:GetRegions()):Kill()

	VoidStorageDepositFrame:CreateBackdrop("Default")
	VoidStorageWithdrawFrame:CreateBackdrop("Default")

	VoidStorageStorageFrame:CreateBackdrop("Default")
	VoidStorageStorageFrame.backdrop:Point("TOPLEFT", 0, -1)
	VoidStorageStorageFrame.backdrop:Point("BOTTOMRIGHT", -27, 1)

	S:HandleButton(VoidStoragePurchaseButton)
	S:HandleButton(VoidStorageHelpBoxButton)
	S:HandleButton(VoidStorageTransferButton)

	S:HandleCloseButton(VoidStorageBorderFrameCloseButton)
	VoidItemSearchBox:CreateBackdrop("Overlay")
	VoidItemSearchBox.backdrop:Point("TOPLEFT", 10, -1)
	VoidItemSearchBox.backdrop:Point("BOTTOMRIGHT", 4, 1)

	VoidStorageStorageButton17:Point("LEFT", VoidStorageStorageButton9, "RIGHT", 7, 0)
	VoidStorageStorageButton33:Point("LEFT", VoidStorageStorageButton25, "RIGHT", 7, 0)
	VoidStorageStorageButton49:Point("LEFT", VoidStorageStorageButton41, "RIGHT", 7, 0)
	VoidStorageStorageButton65:Point("LEFT", VoidStorageStorageButton57, "RIGHT", 7, 0)

	for i = 1, 9 do
		local button_d = _G["VoidStorageDepositButton"..i]
		local button_w = _G["VoidStorageWithdrawButton"..i]
		local icon_d = _G["VoidStorageDepositButton"..i.."IconTexture"]
		local icon_w = _G["VoidStorageWithdrawButton"..i.."IconTexture"]

		_G["VoidStorageDepositButton"..i.."Bg"]:Hide()
		_G["VoidStorageWithdrawButton"..i.."Bg"]:Hide()

		button_d:StyleButton()
		button_d:SetTemplate("Default", true)

		button_w:StyleButton()
		button_w:SetTemplate("Default", true)

		icon_d:SetTexCoord(unpack(E.TexCoords))
		icon_d:ClearAllPoints()
		icon_d:Point("TOPLEFT", 2, -2)
		icon_d:Point("BOTTOMRIGHT", -2, 2)

		icon_w:SetTexCoord(unpack(E.TexCoords))
		icon_w:ClearAllPoints()
		icon_w:Point("TOPLEFT", 2, -2)
		icon_w:Point("BOTTOMRIGHT", -2, 2)
	end

	for i = 1, 80 do
		local button = _G["VoidStorageStorageButton"..i]
		local icon = _G["VoidStorageStorageButton"..i.."IconTexture"]

		_G["VoidStorageStorageButton"..i.."Bg"]:Hide()

		button:StyleButton()
		button:SetTemplate("Default", true)

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:ClearAllPoints()
		icon:Point("TOPLEFT", 2, -2)
		icon:Point("BOTTOMRIGHT", -2, 2)
	end

	hooksecurefunc("VoidStorage_ItemsUpdate", function(doDeposit, doContents)
		local self = VoidStorageFrame;
		if ( doDeposit ) then
			for i=1, 9 do
				local button = _G["VoidStorageDepositButton"..i]
				local Link = GetVoidTransferDepositInfo(i);
				if Link then
					local quality = select(3, GetItemInfo(Link))
					if (quality and quality > 1) then
						button:SetBackdropBorderColor(GetItemQualityColor(quality));
					end
				else
					button:SetTemplate("Default", true)
				end
			end
		end

		if ( doContents ) then
			for i=1, 9 do
				local button = _G["VoidStorageWithdrawButton"..i]
				local Link = GetVoidTransferWithdrawalInfo(i);
				if Link then
					local quality = select(3, GetItemInfo(Link))
					if (quality and quality > 1) then
						button:SetBackdropBorderColor(GetItemQualityColor(quality));
					end
				else
					button:SetTemplate("Default", true)
				end
			end

			for i = 1, 80 do
				local button = _G["VoidStorageStorageButton"..i]
				local Link = GetVoidItemInfo(i);
				if Link then
					local quality = select(3, GetItemInfo(Link))
					if (quality and quality > 1) then
						button:SetBackdropBorderColor(GetItemQualityColor(quality));
					end
				else
					button:SetTemplate("Default", true)
				end
			end
		end
	end)

	--DressUp Frame
	S:HandleCloseButton(SideDressUpModelCloseButton)
	S:HandleButton(SideDressUpModelResetButton)
	SideDressUpModelResetButton:Point("BOTTOM", SideDressUpModel, "BOTTOM", 0, 10)

	SideDressUpFrame:StripTextures()
	SideDressUpFrame:SetTemplate("Transparent")

	SideDressUpModelControlFrame:StripTextures()

	local controlbuttons = {
		"SideDressUpModelControlFrameZoomInButton",
		"SideDressUpModelControlFrameZoomOutButton",
		"SideDressUpModelControlFramePanButton",
		"SideDressUpModelControlFrameRotateRightButton",
		"SideDressUpModelControlFrameRotateLeftButton",
		"SideDressUpModelControlFrameRotateResetButton",
	}

	for i = 1, getn(controlbuttons) do
		S:HandleButton(_G[controlbuttons[i]]);
		_G[controlbuttons[i]]:StyleButton()
		_G[controlbuttons[i].."Bg"]:Hide()
	end

	VoidStorageHelpBox:StripTextures()
	VoidStorageHelpBox:SetTemplate()

end

S:RegisterSkin("Blizzard_VoidStorageUI", LoadSkin)