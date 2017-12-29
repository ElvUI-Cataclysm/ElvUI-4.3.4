local E, L, DF = unpack(select(2, ...))
local B = E:GetModule('Blizzard');

function B:KillBlizzard()
	HelpOpenTicketButtonTutorial:Kill()

	if not E.global.general.showMissingTalentAlert then
		TalentMicroButtonAlert:Kill()
	end
end