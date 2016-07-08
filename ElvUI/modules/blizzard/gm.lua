local E, L, DF = unpack(select(2, ...))
local B = E:GetModule('Blizzard');
local S = E:GetModule('Skins')

function B:PositionGMFrames()
	TicketStatusFrame:ClearAllPoints()
	TicketStatusFrame:SetPoint("TOPLEFT", E.UIParent, 'TOPLEFT', 250, -4)

	E:CreateMover(TicketStatusFrame, "GMMover", L["GM Ticket Frame"])

	--Active Ticket Button	
	local button = HelpOpenTicketButton
	local buttonIcon = button:GetNormalTexture()
	local buttonPushed = button:GetPushedTexture()

	button:SetParent(E.UIParent)
	button:ClearAllPoints()
	button:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 210, -4)

	button:StripTextures()
	S:HandleButton(button)
	button:CreateBackdrop("Default")
	button:SetWidth(35)
	button:SetHeight(35)
	
	buttonIcon:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-Blizz")
	buttonIcon:ClearAllPoints()
	buttonIcon:SetPoint("CENTER", HelpOpenTicketButton, "CENTER", 0, 0)
	buttonIcon:SetTexCoord(unpack(E.TexCoords))
	
	buttonPushed:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-Blizz")
	buttonPushed:ClearAllPoints()
	buttonPushed:SetTexCoord(unpack(E.TexCoords))
	buttonPushed:SetPoint("CENTER", HelpOpenTicketButton, "CENTER", 0, 0)

	E:CreateMover(HelpOpenTicketButton, "GMHelpMover", L["Ticket"])
	
	--Active Ticket Button Tutorial PopUp
	HelpOpenTicketButtonTutorial:Kill()
	HelpOpenTicketButtonTutorialCloseButton:Kill()
	PlayerTalentFrameLearnButtonTutorialArrow:Kill()

end