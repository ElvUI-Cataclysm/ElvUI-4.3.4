local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins')

local _G = _G
local unpack, pairs, select = unpack, pairs, select

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.voidstorage ~= true then return end

	VoidStorageFrameMarbleBg:Kill()
	VoidStorageFrameLines:Kill()

	VoidStorageBorderFrame:StripTextures()
	VoidStorageCostFrame:StripTextures()

	select(2, VoidStorageFrame:GetRegions()):Kill()
	VoidStorageFrame:SetTemplate("Transparent")
	VoidStorageFrame:SetHeight(410)
	VoidStorageFrame:SetWidth(675)

	VoidStoragePurchaseFrame:StripTextures()
	VoidStoragePurchaseFrame:SetTemplate("Default")

	VoidStorageDepositFrame:StripTextures()
	VoidStorageDepositFrame:CreateBackdrop("Default")
	VoidStorageDepositFrame.backdrop:Point("TOPLEFT", 3, -3)
	VoidStorageDepositFrame.backdrop:Point("BOTTOMRIGHT", -3, 3)

	VoidStorageWithdrawFrame:StripTextures()
	VoidStorageWithdrawFrame:CreateBackdrop("Default")
	VoidStorageWithdrawFrame.backdrop:Point("TOPLEFT", 3, -3)
	VoidStorageWithdrawFrame.backdrop:Point("BOTTOMRIGHT", -3, 3)

	VoidStorageStorageFrame:StripTextures()
	VoidStorageStorageFrame:CreateBackdrop("Default")
	VoidStorageStorageFrame.backdrop:Point("TOPLEFT", 3, -3)
	VoidStorageStorageFrame.backdrop:Point("BOTTOMRIGHT", -31, 3)

	S:HandleButton(VoidStoragePurchaseButton)
	S:HandleButton(VoidStorageHelpBoxButton)
	S:HandleButton(VoidStorageTransferButton)

	VoidStorageHelpBox:StripTextures()
	VoidStorageHelpBox:SetTemplate()

	VoidItemSearchBox:StripTextures()
	VoidItemSearchBox:CreateBackdrop("Overlay")
	VoidItemSearchBox.backdrop:Point("TOPLEFT", 10, -1)
	VoidItemSearchBox.backdrop:Point("BOTTOMRIGHT", 4, 1)

	S:HandleCloseButton(VoidStorageBorderFrameCloseButton)

	VoidStorageStorageButton17:Point("LEFT", VoidStorageStorageButton9, "RIGHT", 7, 0)
	VoidStorageStorageButton33:Point("LEFT", VoidStorageStorageButton25, "RIGHT", 7, 0)
	VoidStorageStorageButton49:Point("LEFT", VoidStorageStorageButton41, "RIGHT", 7, 0)
	VoidStorageStorageButton65:Point("LEFT", VoidStorageStorageButton57, "RIGHT", 7, 0)

	hooksecurefunc("VoidStorage_ItemsUpdate", function(doDeposit, doContents)
		if(doDeposit) then
			for i = 1, 9 do
				local button = _G["VoidStorageDepositButton"..i]
				local icon =  _G["VoidStorageDepositButton"..i.."IconTexture"]
				local bg = _G["VoidStorageDepositButton"..i.."Bg"]
				local Link = GetVoidTransferDepositInfo(i);

				button:SetTemplate("Default", true)
				button:StyleButton()
				bg:Hide()

				if(Link) then
					local quality = select(3, GetItemInfo(Link))
					if(quality and quality > 1) then
						button:SetBackdropBorderColor(GetItemQualityColor(quality));
					else
						button:SetBackdropBorderColor(unpack(E["media"].bordercolor));
					end
				end

				icon:SetTexCoord(unpack(E.TexCoords))
				icon:SetInside()
			end
		end

		if(doContents) then
			for i = 1, 9 do
				local button = _G["VoidStorageWithdrawButton"..i]
				local icon =  _G["VoidStorageWithdrawButton"..i.."IconTexture"]
				local bg = _G["VoidStorageWithdrawButton"..i.."Bg"]
				local Link = GetVoidTransferWithdrawalInfo(i);

				button:SetTemplate("Default", true)
				button:StyleButton()
				bg:Hide()

				if(Link) then
					local quality = select(3, GetItemInfo(Link))
					if(quality and quality > 1) then
						button:SetBackdropBorderColor(GetItemQualityColor(quality));
					else
						button:SetBackdropBorderColor(unpack(E["media"].bordercolor));
					end
				end

				icon:SetTexCoord(unpack(E.TexCoords))
				icon:SetInside()
			end

			for i = 1, 80 do
				local button = _G["VoidStorageStorageButton"..i]
				local icon = _G["VoidStorageStorageButton"..i.."IconTexture"]
				local bg = _G["VoidStorageStorageButton"..i.."Bg"]
				local Link = GetVoidItemInfo(i);

				button:SetTemplate("Default", true)
				button:StyleButton()
				bg:Hide()

				if(Link) then
					local quality = select(3, GetItemInfo(Link))
					if(quality and quality > 1) then
						button:SetBackdropBorderColor(GetItemQualityColor(quality));
					else
						button:SetBackdropBorderColor(unpack(E["media"].bordercolor));
					end
				end

				icon:SetTexCoord(unpack(E.TexCoords))
				icon:SetInside()
			end
		end
	end)

	--DressUp Frame
	SideDressUpFrame:StripTextures()
	SideDressUpFrame:SetTemplate("Transparent")

	S:HandleCloseButton(SideDressUpModelCloseButton)

	S:HandleButton(SideDressUpModelResetButton)
	SideDressUpModelResetButton:Point("BOTTOM", SideDressUpModel, "BOTTOM", 0, 10)

	SideDressUpModelControlFrame:StripTextures()

	local controlbuttons = {
		"SideDressUpModelControlFrameZoomInButton",
		"SideDressUpModelControlFrameZoomOutButton",
		"SideDressUpModelControlFramePanButton",
		"SideDressUpModelControlFrameRotateRightButton",
		"SideDressUpModelControlFrameRotateLeftButton",
		"SideDressUpModelControlFrameRotateResetButton"
	}

	for i = 1, getn(controlbuttons) do
		S:HandleButton(_G[controlbuttons[i]]);
		_G[controlbuttons[i]]:StyleButton()
		_G[controlbuttons[i].."Bg"]:Hide()
	end
end

S:AddCallbackForAddon("Blizzard_VoidStorageUI", "VoidStorageUI", LoadSkin);