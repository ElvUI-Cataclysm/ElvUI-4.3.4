local E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule("NamePlates")

function NP:Update_Elite(frame)
	local db = NP.db.units[frame.UnitType].eliteIcon
	if not db then return end

	if db.enable then
		if frame.BossIcon:IsShown() then
			frame.Elite:SetTexCoord(0, 0.15, 0.65, 0.94)
			frame.Elite:Show()
		elseif frame.EliteIcon:IsShown() then
			frame.Elite:SetTexCoord(0, 0.15, 0.35, 0.63)
			frame.Elite:Show()
		else
			frame.Elite:Hide()
		end
	else
		frame.Elite:Hide()
	end
end

function NP:Configure_Elite(frame)
	local db = NP.db.units[frame.UnitType].eliteIcon
	if not db or (db and not db.enable) then return end

	frame.Elite:Size(db.size)
	frame.Elite:ClearAllPoints()
	frame.Elite:Point(db.position, db.xOffset, db.yOffset)
	frame.Elite:SetParent(frame.Health:IsShown() and frame.Health or frame)
end

function NP:Construct_Elite(frame)
	local icon = frame.Health:CreateTexture(nil, "OVERLAY")
	icon:SetTexture(E.Media.Textures.Nameplates)
	icon:Hide()

	return icon
end