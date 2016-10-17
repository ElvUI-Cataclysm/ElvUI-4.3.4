local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule("Skins");

local _G = _G
local unpack = unpack;

local function LoadSkin()
	if(E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.trainer ~= true) then return; end

	local StripAllTextures = {
		"ClassTrainerFrame",
		"ClassTrainerScrollFrameScrollChild",
		"ClassTrainerFrameSkillStepButton",
		"ClassTrainerFrameBottomInset",
		"ClassTrainerTrainButton",
		"ClassTrainerStatusBar"
	}

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end

	local KillTextures = {
		"ClassTrainerFrameInset",
		"ClassTrainerFramePortrait",
		"ClassTrainerScrollFrameScrollBarBG",
		"ClassTrainerScrollFrameScrollBarTop",
		"ClassTrainerScrollFrameScrollBarBottom",
		"ClassTrainerScrollFrameScrollBarMiddle",
	}

	for _, texture in pairs(KillTextures) do
		_G[texture]:Kill()
	end

	for i = 1, 8 do
		local button = _G["ClassTrainerScrollFrameButton"..i]
		local icon = _G["ClassTrainerScrollFrameButton"..i.."Icon"]
		local money = _G["ClassTrainerScrollFrameButton"..i.."MoneyFrame"]
	
		button:StripTextures()
		button:SetTemplate("Default")
		button:CreateBackdrop()
		button.backdrop:SetOutside(icon)
		button:StyleButton()

		button.selectedTex:SetTexture(1, 1, 1, 0.3)
		button.selectedTex:SetInside()

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:Point("TOPLEFT", 0, -1)
		icon:Size(44)
		icon:SetParent(button.backdrop)

		money:SetScale(0.88)
		money:Point("TOPRIGHT", 10, -3)
	end

	S:HandleButton(ClassTrainerTrainButton)
	S:HandleCloseButton(ClassTrainerFrameCloseButton,ClassTrainerFrame)

	S:HandleScrollBar(ClassTrainerScrollFrameScrollBar, 5)

	S:HandleDropDownBox(ClassTrainerFrameFilterDropDown)
	ClassTrainerFrameFilterDropDown:Point("TOPRIGHT", ClassTrainerFrame, "TOPRIGHT", 0, -37)

	ClassTrainerFrame:SetHeight(ClassTrainerFrame:GetHeight() + 42)
	ClassTrainerFrame:CreateBackdrop("Transparent")
	ClassTrainerFrame.backdrop:Point("TOPLEFT", ClassTrainerFrame, "TOPLEFT")
	ClassTrainerFrame.backdrop:Point("BOTTOMRIGHT", ClassTrainerFrame, "BOTTOMRIGHT")

	ClassTrainerFrameSkillStepButton:StyleButton()
	ClassTrainerFrameSkillStepButton.icon:SetTexCoord(unpack(E.TexCoords))
	ClassTrainerFrameSkillStepButton.icon:Point("TOPLEFT", 1, 0)
	ClassTrainerFrameSkillStepButton.icon:Size(40)
	ClassTrainerFrameSkillStepButton:CreateBackdrop()
	ClassTrainerFrameSkillStepButton.selectedTex:SetTexture(1, 1, 1, 0.3)
	ClassTrainerFrameSkillStepButton.selectedTex:SetInside()
	ClassTrainerFrameSkillStepButtonMoneyFrame:SetScale(0.90)
	ClassTrainerFrameSkillStepButtonMoneyFrame:Point("TOPRIGHT", 10, -3)

	ClassTrainerFrameSkillStepButton.bg = CreateFrame("Frame", nil, ClassTrainerFrameSkillStepButton)
	ClassTrainerFrameSkillStepButton.bg:CreateBackdrop()
	ClassTrainerFrameSkillStepButton.bg:SetInside(ClassTrainerFrameSkillStepButton.icon)
	ClassTrainerFrameSkillStepButton.icon:SetParent(ClassTrainerFrameSkillStepButton.bg)

	ClassTrainerStatusBar:SetStatusBarTexture(E["media"].normTex)
	ClassTrainerStatusBar:CreateBackdrop("Default")
	ClassTrainerStatusBar:Point("TOPLEFT", ClassTrainerFrame, "TOPLEFT", 10, -40)
	ClassTrainerStatusBar:Width(190)
	ClassTrainerStatusBar:Height(20)
	ClassTrainerStatusBar:SetStatusBarColor(0.11, 0.50, 1.00)
	ClassTrainerStatusBar.rankText:Point("CENTER", ClassTrainerStatusBar, "CENTER", 0, 0)
end

S:AddCallbackForAddon("Blizzard_TrainerUI", "Trainer", LoadSkin);