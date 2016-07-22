local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins')

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.bgscore ~= true then return end
	for i=19, MAX_WORLDSTATE_SCORE_BUTTONS do
		_G['WorldStateScoreButton'..i]:StripTextures()
	end
	MAX_WORLDSTATE_SCORE_BUTTONS = 18; WorldStateScoreFrame_Resize()
	
	WorldStateScoreScrollFrame:StripTextures()
	WorldStateScoreFrame:StripTextures()
	WorldStateScoreFrame:SetTemplate("Transparent")
	S:HandleCloseButton(WorldStateScoreFrameCloseButton)
	S:HandleScrollBar(WorldStateScoreScrollFrameScrollBar)
	WorldStateScoreFrameInset:Kill()
	S:HandleButton(WorldStateScoreFrameLeaveButton)
	
	for i = 1, WorldStateScoreScrollFrameScrollChildFrame:GetNumChildren() do
		local b = _G["WorldStateScoreButton"..i]
		b:StripTextures()
		b:StyleButton(false)
		b:SetTemplate("Default", true)
	end
	
	for i = 1, 3 do 
		S:HandleTab(_G["WorldStateScoreFrameTab"..i])
	end
	
	WorldStateScoreFrameTab1:Point("TOPLEFT", WorldStateScoreFrame, "BOTTOMLEFT", 5, 2)
	
	WorldStateScoreFrameKB:StyleButton()
	WorldStateScoreFrameDeaths:StyleButton()
	WorldStateScoreFrameHK:StyleButton()
	WorldStateScoreFrameDamageDone:StyleButton()
	WorldStateScoreFrameHealingDone:StyleButton()
	WorldStateScoreFrameHonorGained:StyleButton()
	WorldStateScoreFrameName:StyleButton()
	WorldStateScoreFrameClass:StyleButton()
	WorldStateScoreFrameTeam:StyleButton()
	WorldStateScoreFrameRatingChange:StyleButton()
	
	for i = 1, 5 do 
		_G["WorldStateScoreColumn"..i]:StyleButton()
	end
	
end

S:RegisterSkin('ElvUI', LoadSkin)