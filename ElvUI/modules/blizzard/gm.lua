local E, L, DF = unpack(select(2, ...))
local B = E:GetModule('Blizzard');
local S = E:GetModule('Skins')

function B:PositionGMFrames()
	TicketStatusFrame:ClearAllPoints()
	TicketStatusFrame:SetPoint("TOPLEFT", E.UIParent, 'TOPLEFT', 250, -5)

	E:CreateMover(TicketStatusFrame, "GMMover", L["GM Ticket Frame"])

	HelpOpenTicketButton:SetParent(Minimap)
	HelpOpenTicketButton:ClearAllPoints()
	HelpOpenTicketButton:Point("BOTTOM", Minimap, "BOTTOM", 8, -4)

	HelpOpenTicketButtonTutorial:StripTextures()
	HelpOpenTicketButtonTutorial:SetTemplate("Transparent")
	S:HandleCloseButton(HelpOpenTicketButtonTutorialCloseButton)

	PlayerTalentFrameLearnButtonTutorialArrow:Kill()
end