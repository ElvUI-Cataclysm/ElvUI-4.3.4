local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")

local CombatTextures = {
	COMBAT = E.Media.Textures.Combat,
	DEFAULT = [[Interface\CharacterFrame\UI-StateIcon]],
	PLATINUM = [[Interface\Challenges\ChallengeMode_Medal_Platinum]],
	ATTACK = [[Interface\CURSOR\Attack]],
	ALERT = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
	ALERT2 = [[Interface\OptionsFrame\UI-OptionsFrame-NewFeatureIcon]],
	ARTHAS = [[Interface\LFGFRAME\UI-LFR-PORTRAIT]],
	SKULL = [[Interface\LootFrame\LootPanel-Icon]]
}

function UF:Construct_CombatIndicator(frame)
	return frame.RaisedElementParent.TextureParent:CreateTexture(nil, "OVERLAY")
end

function UF:Configure_CombatIndicator(frame)
	local db = frame.db.CombatIcon

	frame.CombatIndicator:ClearAllPoints()
	frame.CombatIndicator:Point("CENTER", frame.Health, db.anchorPoint, db.xOffset, db.yOffset)
	frame.CombatIndicator:Size(db.size)

	if db.defaultColor then
		frame.CombatIndicator:SetVertexColor(1, 1, 1, 1)
		frame.CombatIndicator:SetDesaturated(false)
	else
		frame.CombatIndicator:SetVertexColor(db.color.r, db.color.g, db.color.b, db.color.a)
		frame.CombatIndicator:SetDesaturated(true)
	end

	if db.texture == "CUSTOM" and db.customTexture then
		frame.CombatIndicator:SetTexture(db.customTexture)
		frame.CombatIndicator:SetTexCoord(0, 1, 0, 1)
	elseif db.texture ~= "DEFAULT" and CombatTextures[db.texture] then
		frame.CombatIndicator:SetTexture(CombatTextures[db.texture])
		frame.CombatIndicator:SetTexCoord(0, 1, 0, 1)
	else
		frame.CombatIndicator:SetTexture(CombatTextures.DEFAULT)
		frame.CombatIndicator:SetTexCoord(.5, 1, 0, .49)
	end

	if db.enable and not frame:IsElementEnabled("CombatIndicator") then
		frame:EnableElement("CombatIndicator")
	elseif not db.enable and frame:IsElementEnabled("CombatIndicator") then
		frame:DisableElement("CombatIndicator")
	end
end