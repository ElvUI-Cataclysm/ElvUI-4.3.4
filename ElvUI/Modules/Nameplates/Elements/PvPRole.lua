local E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule("NamePlates")

function NP:Update_PvPRole(frame)
	if not frame.UnitType == "ENEMY_PLAYER" or not frame.UnitType == "FRIENDLY_PLAYER" then return end

	local db = NP.db.units[frame.UnitType].pvpRole
	if not db or (db and not db.enable) then return end

	if db.markHealers and NP.Healers[frame.UnitName] then
		frame.PvPRole:ClearAllPoints()
		if frame.Health:IsShown() then
			frame.PvPRole:SetPoint("RIGHT", frame.Health, "LEFT", -6, 0)
		else
			frame.PvPRole:SetPoint("BOTTOM", frame.Name, "TOP", 0, 3)
		end
		frame.PvPRole:Show()
	else
		frame.PvPRole:Hide()
	end
end

function NP:Construct_PvPRole(frame)
	local texture = frame:CreateTexture(nil, "OVERLAY")
	texture:SetPoint("RIGHT", frame.Health, "LEFT", -6, 0)
	texture:SetSize(40, 40)
	texture:SetTexture(E.Media.Textures.Healer)
	texture:Hide()

	return texture
end