local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")

function UF:Construct_ResurrectionIcon(frame)
	local tex = frame.RaisedElementParent.TextureParent:CreateTexture(nil, "OVERLAY")
	tex:Point("CENTER", frame.Health, "CENTER")
	tex:Size(30)
	tex:SetDrawLayer("OVERLAY", 7)

	return tex
end

function UF:Configure_ResurrectionIcon(frame)
	local db = frame.db.resurrectIcon

	if db.enable then
		frame:EnableElement("ResurrectIndicator")

		local attachPoint = self:GetObjectAnchorPoint(frame, db.attachToObject)
		frame.ResurrectIndicator:ClearAllPoints()
		frame.ResurrectIndicator:Point(db.attachTo, attachPoint, db.attachTo, db.xOffset, db.yOffset)
		frame.ResurrectIndicator:Size(db.size)
		frame.ResurrectIndicator:Show()
	else
		frame:DisableElement("ResurrectIndicator")
		frame.ResurrectIndicator:Hide()
	end
end