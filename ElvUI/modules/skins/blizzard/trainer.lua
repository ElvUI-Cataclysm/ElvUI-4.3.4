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
		_G["ClassTrainerScrollFrameButton"..i.."Icon"]:Point("TOPLEFT", 0, -2)
		_G["ClassTrainerScrollFrameButton"..i.."Icon"]:Size(43, 43)
		_G["ClassTrainerScrollFrameButton"..i]:SetTemplate("Default")

		_G["ClassTrainerScrollFrameButton"..i].selectedTex:SetTexture(1, 1, 1, 0.3)
		_G["ClassTrainerScrollFrameButton"..i].selectedTex:SetInside()
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

	S:HandleDropDownBox(ClassTrainerFrameFilterDropDown, 155)

	ClassTrainerFrame:SetHeight(ClassTrainerFrame:GetHeight() + 42)
	ClassTrainerFrame:CreateBackdrop("Transparent")
	ClassTrainerFrame.backdrop:Point("TOPLEFT", ClassTrainerFrame, "TOPLEFT")
	ClassTrainerFrame.backdrop:Point("BOTTOMRIGHT", ClassTrainerFrame, "BOTTOMRIGHT")
	S:HandleCloseButton(ClassTrainerFrameCloseButton,ClassTrainerFrame)
	ClassTrainerFrameSkillStepButton.icon:SetTexCoord(unpack(E.TexCoords))
	ClassTrainerFrameSkillStepButton.icon:Size(40, 40)
	ClassTrainerFrameSkillStepButton.icon:Point("TOPLEFT", 0, 0)
	ClassTrainerFrameSkillStepButton:CreateBackdrop("Default")
	ClassTrainerFrameSkillStepButtonHighlight:SetTexture(1,1,1,0.3)
	ClassTrainerFrameSkillStepButton.selectedTex:SetTexture(1,1,1,0.3)

	ClassTrainerStatusBar:StripTextures()
	ClassTrainerStatusBar:SetStatusBarTexture(E["media"].normTex)
	ClassTrainerStatusBar:CreateBackdrop("Default")
	ClassTrainerStatusBar.rankText:ClearAllPoints()
	ClassTrainerStatusBar.rankText:SetPoint("CENTER", ClassTrainerStatusBar, "CENTER")
end

S:RegisterSkin("Blizzard_TrainerUI", LoadSkin);