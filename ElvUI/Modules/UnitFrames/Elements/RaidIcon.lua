local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")

function UF:Construct_RaidIcon(frame)
	local tex = frame.RaisedElementParent.TextureParent:CreateTexture(nil, "OVERLAY")
	tex:SetTexture(E.Media.Textures.RaidIcons)
	tex:Size(18)
	tex:Point("CENTER", frame.Health, "TOP", 0, 2)
	tex.SetTexture = E.noop

	return tex
end

function UF:Configure_RaidIcon(frame)
	local db = frame.db.raidicon

	if db.enable then
		frame:EnableElement("RaidTargetIndicator")

		local attachPoint = self:GetObjectAnchorPoint(frame, db.attachToObject)
		frame.RaidTargetIndicator:ClearAllPoints()
		frame.RaidTargetIndicator:Point(db.attachTo, attachPoint, db.attachTo, db.xOffset, db.yOffset)
		frame.RaidTargetIndicator:Size(db.size)
		frame.RaidTargetIndicator:Show()
	else
		frame:DisableElement("RaidTargetIndicator")
		frame.RaidTargetIndicator:Hide()
	end
end