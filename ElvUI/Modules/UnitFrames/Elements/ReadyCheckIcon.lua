local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")

function UF:Construct_ReadyCheckIcon(frame)
	local tex = frame.RaisedElementParent.TextureParent:CreateTexture(nil, "OVERLAY", nil, 7)
	tex:Size(12)
	tex:Point("BOTTOM", frame.Health, "BOTTOM", 0, 2)

	return tex
end

function UF:Configure_ReadyCheckIcon(frame)
	local db = frame.db.readycheckIcon

	if db.enable then
		if not frame:IsElementEnabled("ReadyCheckIndicator") then
			frame:EnableElement("ReadyCheckIndicator")
		end

		local attachPoint = self:GetObjectAnchorPoint(frame, db.attachTo)
		frame.ReadyCheckIndicator:ClearAllPoints()
		frame.ReadyCheckIndicator:Point(db.position, attachPoint, db.position, db.xOffset, db.yOffset)
		frame.ReadyCheckIndicator:Size(db.size)
	else
		frame:DisableElement("ReadyCheckIndicator")
	end
end