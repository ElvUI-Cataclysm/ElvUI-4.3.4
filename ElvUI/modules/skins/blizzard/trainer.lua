local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule("Skins");

local unpack = unpack;

local function LoadSkin()
	if(E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.trainer ~= true) then return; end

	--Class Trainer Frame
	local StripAllTextures = {
		"ClassTrainerFrame",
		"ClassTrainerScrollFrameScrollChild",
		"ClassTrainerFrameSkillStepButton",
		"ClassTrainerFrameBottomInset",
	}

	local buttons = {
		"ClassTrainerTrainButton",
	}

	local KillTextures = {
		"ClassTrainerFrameInset",
		"ClassTrainerFramePortrait",
		"ClassTrainerScrollFrameScrollBarBG",
		"ClassTrainerScrollFrameScrollBarTop",
		"ClassTrainerScrollFrameScrollBarBottom",
		"ClassTrainerScrollFrameScrollBarMiddle",
	}

	for i=1,8 do
		_G["ClassTrainerScrollFrameButton"..i]:StripTextures()
		_G["ClassTrainerScrollFrameButton"..i]:StyleButton()
		_G["ClassTrainerScrollFrameButton"..i.."Icon"]:SetTexCoord(unpack(E.TexCoords))
		_G["ClassTrainerScrollFrameButton"..i.."Icon"]:Point("TOPLEFT", 0, -1)
		_G["ClassTrainerScrollFrameButton"..i.."Icon"]:Size(44, 44)
		_G["ClassTrainerScrollFrameButton"..i]:CreateBackdrop()
		_G["ClassTrainerScrollFrameButton"..i].backdrop:SetOutside(_G["ClassTrainerScrollFrameButton"..i.."Icon"])
		_G["ClassTrainerScrollFrameButton"..i.."Icon"]:SetParent(_G["ClassTrainerScrollFrameButton"..i].backdrop)
		_G["ClassTrainerScrollFrameButton"..i]:SetTemplate("Default")
		_G["ClassTrainerScrollFrameButton"..i].selectedTex:SetTexture(1, 1, 1, 0.3)
		_G["ClassTrainerScrollFrameButton"..i].selectedTex:SetInside()
		_G["ClassTrainerScrollFrameButton"..i.."MoneyFrame"]:SetScale(0.88)
		_G["ClassTrainerScrollFrameButton"..i.."MoneyFrame"]:Point("TOPRIGHT", 10, -3)
	end

	S:HandleScrollBar(ClassTrainerScrollFrameScrollBar, 5)

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end

	for _, texture in pairs(KillTextures) do
		_G[texture]:Kill()
	end

	for i = 1, #buttons do
		_G[buttons[i]]:StripTextures()
		S:HandleButton(_G[buttons[i]])
	end

	S:HandleDropDownBox(ClassTrainerFrameFilterDropDown)
	ClassTrainerFrameFilterDropDown:ClearAllPoints()
	ClassTrainerFrameFilterDropDown:SetPoint("TOPRIGHT", ClassTrainerFrame, "TOPRIGHT", 0, -37)

	ClassTrainerFrame:SetHeight(ClassTrainerFrame:GetHeight() + 42)
	ClassTrainerFrame:CreateBackdrop("Transparent")
	ClassTrainerFrame.backdrop:Point("TOPLEFT", ClassTrainerFrame, "TOPLEFT")
	ClassTrainerFrame.backdrop:Point("BOTTOMRIGHT", ClassTrainerFrame, "BOTTOMRIGHT")
	S:HandleCloseButton(ClassTrainerFrameCloseButton,ClassTrainerFrame)

	ClassTrainerFrameSkillStepButton:StyleButton()
	ClassTrainerFrameSkillStepButton.icon:SetTexCoord(unpack(E.TexCoords))
	ClassTrainerFrameSkillStepButton.icon:Point("TOPLEFT", 1, -1)
	ClassTrainerFrameSkillStepButton.icon:Size(38, 38)
	ClassTrainerFrameSkillStepButton:CreateBackdrop()
	ClassTrainerFrameSkillStepButton.selectedTex:SetTexture(1,1,1,0.3)
	ClassTrainerFrameSkillStepButton.selectedTex:SetInside()
	ClassTrainerFrameSkillStepButtonMoneyFrame:SetScale(0.90)
	ClassTrainerFrameSkillStepButtonMoneyFrame:Point("TOPRIGHT", 10, -3)

	ClassTrainerStatusBar:StripTextures()
	ClassTrainerStatusBar:SetStatusBarTexture(E["media"].normTex)
	ClassTrainerStatusBar:CreateBackdrop("Default")
	ClassTrainerStatusBar:ClearAllPoints()
	ClassTrainerStatusBar:SetPoint("TOPLEFT", ClassTrainerFrame, "TOPLEFT", 10, -40)
	ClassTrainerStatusBar:Width(190)
	ClassTrainerStatusBar:Height(20)
	ClassTrainerStatusBar:SetStatusBarColor(0.11, 0.50, 1.00)
	ClassTrainerStatusBar.rankText:ClearAllPoints()
	ClassTrainerStatusBar.rankText:SetPoint("CENTER", ClassTrainerStatusBar, "CENTER", 0, 0)
end

S:RegisterSkin("Blizzard_TrainerUI", LoadSkin);