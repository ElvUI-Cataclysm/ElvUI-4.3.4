local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins')

local _G = _G
local unpack, pairs, select = unpack, pairs, select

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
	VoidStorageDepositFrame.backdrop:Point("TOPLEFT", 3, -3)
	VoidStorageDepositFrame.backdrop:Point("BOTTOMRIGHT", -3, 3)

	VoidStorageWithdrawFrame:CreateBackdrop("Default")
	VoidStorageWithdrawFrame.backdrop:Point("TOPLEFT", 3, -3)
	VoidStorageWithdrawFrame.backdrop:Point("BOTTOMRIGHT", -3, 3)

	VoidStorageStorageFrame:CreateBackdrop("Default")
	VoidStorageStorageFrame.backdrop:Point("TOPLEFT", 3, -3)
	VoidStorageStorageFrame.backdrop:Point("BOTTOMRIGHT", -31, 3)

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

S:AddCallbackForAddon("Blizzard_VoidStorageUI", "VoidStorageUI", LoadSkin);