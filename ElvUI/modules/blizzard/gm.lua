local E, L, DF = unpack(select(2, ...))
local B = E:GetModule('Blizzard');

function B:PositionGMFrames()
	TicketStatusFrame:ClearAllPoints()
	TicketStatusFrame:SetPoint("TOPLEFT", E.UIParent, 'TOPLEFT', 390, -4)

	E:CreateMover(TicketStatusFrame, "GMMover", L["GM Ticket Frame"])

	HelpOpenTicketButton:SetParent(E.UIParent)
	HelpOpenTicketButton:ClearAllPoints()
	HelpOpenTicketButton:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 352, -4)
	HelpOpenTicketButton:SetFrameStrata("HIGH")

	E:CreateMover(HelpOpenTicketButton, "GMHelpMover", L["Ticket"])
end