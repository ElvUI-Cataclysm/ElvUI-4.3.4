local E, L, DF = unpack(select(2, ...))
local B = E:GetModule('Blizzard');
local S = E:GetModule('Skins')

function B:PositionGMFrames()
	TicketStatusFrame:ClearAllPoints()
	TicketStatusFrame:SetPoint("TOPLEFT", E.UIParent, 'TOPLEFT', 250, -5)

	E:CreateMover(TicketStatusFrame, "GMMover", L["GM Ticket Frame"])

	--Active Ticket Button
	
	--HelpOpenTicketButton:SetParent(Minimap)
	--HelpOpenTicketButton:ClearAllPoints()
	--HelpOpenTicketButton:Point("BOTTOM", Minimap, "BOTTOM", 8, -4)
	
	local button = HelpOpenTicketButton
	local buttonIcon = button:GetNormalTexture()
	local buttonPushed = button:GetPushedTexture()

	button:SetParent(ElvUIParent)
	button:ClearAllPoints()
	button:SetPoint("TOP", E.UIParent, "TOP", 260, -4)

	HelpOpenTicketButtonTutorial:Kill()
	HelpOpenTicketButtonTutorialCloseButton:Kill()
	PlayerTalentFrameLearnButtonTutorialArrow:Kill()

	button:StripTextures()
	S:HandleButton(button)
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

	E:CreateMover(HelpOpenTicketButton, "GMHelp", L["GM Help"])

end