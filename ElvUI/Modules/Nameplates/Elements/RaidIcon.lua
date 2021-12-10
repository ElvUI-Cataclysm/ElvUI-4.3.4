local E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule("NamePlates")

function NP:Update_RaidIcon(frame)
	local db = NP.db.units[frame.UnitType].raidTargetIndicator
	local healthShown = frame.Health:IsShown()

	frame.RaidIcon:SetSize(db.size, db.size)
	frame.RaidIcon:SetParent(healthShown and frame.Health or frame)
	frame.RaidIcon:ClearAllPoints()
	if healthShown then
		frame.RaidIcon:SetPoint(E.InversePoints[db.position], frame.Health, db.position, db.xOffset, db.yOffset)
	else
		frame.RaidIcon:SetPoint("BOTTOM", frame, "TOP", 0, 15)
	end
end