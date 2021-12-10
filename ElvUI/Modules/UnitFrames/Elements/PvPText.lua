local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")

function UF:Construct_PvPText(frame)
	local pvp = frame.RaisedElementParent:CreateFontString(nil, "OVERLAY")
	UF:Configure_FontString(pvp)

	return pvp
end

function UF:Configure_PvPText(frame)
	local x, y = self:GetPositionOffset(frame.db.pvp.position)
	frame.PvPText:ClearAllPoints()
	frame.PvPText:Point(frame.db.pvp.position, frame.Health, frame.db.pvp.position, x, y)

	frame:Tag(frame.PvPText, frame.db.pvp.text_format)
end