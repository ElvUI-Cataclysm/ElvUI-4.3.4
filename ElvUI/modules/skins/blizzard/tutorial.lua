local E, L, V, P, G, _ = unpack(select(2, ...));
local S = E:GetModule('Skins')

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.tutorial ~= true then return end

	local tutorialbutton = TutorialFrameAlertButton
	local tutorialbuttonIcon = TutorialFrameAlertButton:GetNormalTexture()

	tutorialbutton:StripTextures()
	tutorialbutton:CreateBackdrop("Default", true)
	tutorialbutton:SetWidth(50)
	tutorialbutton:SetHeight(50)

	tutorialbuttonIcon:SetTexture("INTERFACE\\ICONS\\INV_Letter_18")
	tutorialbuttonIcon:ClearAllPoints()
	tutorialbuttonIcon:SetPoint("TOPLEFT", TutorialFrameAlertButton, "TOPLEFT", 5, -5)
	tutorialbuttonIcon:SetPoint("BOTTOMRIGHT", TutorialFrameAlertButton, "BOTTOMRIGHT",  -5, 5)
	tutorialbuttonIcon:SetTexCoord(unpack(E.TexCoords))

	TutorialFrame:StripTextures()
	TutorialFrame:SetTemplate("Transparent")

	S:HandleNextPrevButton(TutorialFrameNextButton)
	TutorialFrameNextButton:SetPoint("BOTTOMRIGHT", TutorialFrame, "BOTTOMRIGHT", -132, 7)
	TutorialFrameNextButton:SetWidth(22)
	TutorialFrameNextButton:SetHeight(22)

	S:HandleNextPrevButton(TutorialFramePrevButton)
	TutorialFramePrevButton:SetPoint("BOTTOMLEFT", TutorialFrame, "BOTTOMLEFT", 30, 7)
	TutorialFramePrevButton:SetWidth(22)
	TutorialFramePrevButton:SetHeight(22)

	S:HandleButton(TutorialFrameOkayButton)
	S:HandleCloseButton(TutorialFrameCloseButton)
	TutorialFrameCloseButton:SetPoint("TOPRIGHT", TutorialFrame, "TOPRIGHT", 0, 0)

	TutorialFrameCallOut:Kill()

	TalentMicroButtonAlert:StripTextures()
	TalentMicroButtonAlert:SetTemplate("Transparent")
	TalentMicroButtonAlertArrow:Kill()
	S:HandleCloseButton(TalentMicroButtonAlertCloseButton)

	HelpOpenTicketButtonTutorial:Kill()
	HelpOpenTicketButtonTutorialCloseButton:Kill()
	PlayerTalentFrameLearnButtonTutorialArrow:Kill()
end

S:RegisterSkin('ElvUI', LoadSkin)