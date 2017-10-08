local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local unpack = unpack

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.stable ~= true then return end

	NUM_PET_STABLE_SLOTS = 20
	NUM_PET_STABLE_PAGES = 1
	PetStableFrame.page = 1

	PetStableFrameInset:StripTextures()
	PetStableLeftInset:StripTextures()

	PetStableNextPageButton:Hide()
	PetStablePrevPageButton:Hide()

	PetStableModelRotateRightButton:Hide()
	PetStableModelRotateLeftButton:Hide()

	PetStableFrame:StripTextures()
	PetStableFrame:CreateBackdrop("Transparent")
	PetStableFrame.backdrop:Point("BOTTOMRIGHT", 0, -12)

	PetStablePetInfo:CreateBackdrop()
	PetStablePetInfo.backdrop:SetOutside(PetStableSelectedPetIcon)

	PetStableSelectedPetIcon:SetTexCoord(unpack(E.TexCoords))
	PetStableSelectedPetIcon:Point("TOPLEFT", PetStablePetInfo, "TOPLEFT", 0, 2)

	PetStableDiet:StripTextures()
	PetStableDiet:CreateBackdrop()
	PetStableDiet:Point("TOPRIGHT", -1, 2)
	PetStableDiet:Size(40)

	PetStableDiet.icon = PetStableDiet:CreateTexture(nil, "OVERLAY")
	PetStableDiet.icon:SetTexture("Interface\\Icons\\Ability_Hunter_BeastTraining")
	PetStableDiet.icon:SetTexCoord(unpack(E.TexCoords))
	PetStableDiet.icon:SetInside(PetStableDiet.backdrop)

	PetStableTypeText:Point("BOTTOMRIGHT", -47, 2)

	PetStableModelShadow:Kill()
	PetStableModel:CreateBackdrop("Transparent")

	PetStableBottomInset:StripTextures()
	PetStableBottomInset:CreateBackdrop("Default")
	PetStableBottomInset.backdrop:Point("TOPLEFT", 4, 0)
	PetStableBottomInset.backdrop:Point("BOTTOMRIGHT", -5, -9)

	S:HandleCloseButton(PetStableFrameCloseButton)

	for i = 1, NUM_PET_ACTIVE_SLOTS do
		S:HandleItemButton(_G["PetStableActivePet"..i], true)
	end

	for i = 11, 20 do 
		if not _G["PetStableStabledPet"..i] then
			CreateFrame("Button", "PetStableStabledPet"..i, PetStableFrame, "PetStableSlotTemplate", i)
		end
	end

	for i = 1, NUM_PET_STABLE_SLOTS do
		local button = _G["PetStableStabledPet"..i]

		S:HandleItemButton(button, true)

		if i > 1 then
			button:ClearAllPoints()
			button:Point("LEFT", _G["PetStableStabledPet"..i - 1], "RIGHT", 7, 0)
		end
	end

	PetStableStabledPet1:ClearAllPoints()
	PetStableStabledPet1:Point("TOPLEFT", PetStableBottomInset, 9, -5)

	PetStableStabledPet8:ClearAllPoints()
	PetStableStabledPet8:Point("TOPLEFT", PetStableStabledPet1, "BOTTOMLEFT", 0, -5)

	PetStableStabledPet15:ClearAllPoints()
	PetStableStabledPet15:Point("TOPLEFT", PetStableStabledPet8, "BOTTOMLEFT", 0, -5)
end

S:AddCallback("Stable", LoadSkin)