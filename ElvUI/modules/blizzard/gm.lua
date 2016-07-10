local E, L, DF = unpack(select(2, ...))
local B = E:GetModule('Blizzard');

function B:PositionGMFrames()
	TicketStatusFrame:ClearAllPoints()
	TicketStatusFrame:SetPoint("TOPLEFT", E.UIParent, 'TOPLEFT', 250, -4)

	E:CreateMover(TicketStatusFrame, "GMMover", L["GM Ticket Frame"])

	HelpOpenTicketButton:SetParent(E.UIParent)
	HelpOpenTicketButton:ClearAllPoints()
	HelpOpenTicketButton:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 210, -4)
	HelpOpenTicketButton:SetFrameStrata("HIGH")

	E:CreateMover(HelpOpenTicketButton, "GMHelpMover", L["Ticket"])
end