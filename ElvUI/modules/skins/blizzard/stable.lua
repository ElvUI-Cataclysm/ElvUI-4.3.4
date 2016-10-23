local E, L, V, P, G, _ = unpack(select(2, ...));
local S = E:GetModule("Skins");

local _G = _G;

local function LoadSkin()
	if(E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.stable ~= true) then return; end

	PetStableFrame:StripTextures()
	PetStableFrameInset:StripTextures()
	PetStableLeftInset:StripTextures()
	PetStableBottomInset:StripTextures()

	PetStableFrame:SetTemplate("Transparent")
	PetStableFrameInset:CreateBackdrop("Default")

	S:HandleCloseButton(PetStableFrameCloseButton)
	S:HandleButton(PetStablePrevPageButton)
	S:HandleButton(PetStableNextPageButton)
	S:HandleRotateButton(PetStableModelRotateRightButton)
	S:HandleRotateButton(PetStableModelRotateLeftButton)

	PetStableDiet:StripTextures()
	PetStableDiet:CreateBackdrop()
	PetStableDiet.icon = PetStableDiet:CreateTexture(nil, "OVERLAY");
	PetStableDiet.icon:SetTexCoord(unpack(E.TexCoords))
	PetStableDiet.icon:SetAllPoints()
	PetStableDiet.icon:SetTexture("Interface\\Icons\\Ability_Hunter_BeastTraining")
	PetStableDiet:SetPoint("TOPRIGHT", PetStablePetInfo, "TOPRIGHT", -2, -2)

	for i = 1, NUM_PET_ACTIVE_SLOTS do
	   S:HandleItemButton(_G['PetStableActivePet' .. i], true)
	end

	for i = 1, NUM_PET_STABLE_SLOTS do
	   S:HandleItemButton(_G['PetStableStabledPet' .. i], true)
	end

	PetStableSelectedPetIcon:SetTexCoord(unpack(E.TexCoords))
end

S:AddCallback("Stable", LoadSkin);