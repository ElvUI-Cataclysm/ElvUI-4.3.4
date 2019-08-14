local E, L, V, P, G = unpack(select(2, ...))
local B = E:GetModule("Blizzard")

function B:KillBlizzard()
	HelpOpenTicketButtonTutorial:Kill()

	Advanced_UIScaleSlider:Kill()
	Advanced_UseUIScale:Kill()
end