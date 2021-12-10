local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")

local CreateFrame = CreateFrame

function UF:Construct_GPS(frame)
	local gps = CreateFrame("Frame", nil, frame)
	gps:SetFrameLevel(frame:GetFrameLevel() + 50)
	gps:Hide()

	gps.Texture = gps:CreateTexture("OVERLAY")
	gps.Texture:SetTexture(E.Media.Textures.Arrow)
	gps.Texture:SetBlendMode("BLEND")
	gps.Texture:SetAllPoints()

	return gps
end

function UF:Configure_GPS(frame)
	local db = frame.db.GPSArrow

	if db.enable then
		if not frame:IsElementEnabled("GPS") then
			frame:EnableElement("GPS")
		end

		frame.GPS:Size(db.size)
		frame.GPS:Point("CENTER", frame, "CENTER", db.xOffset, db.yOffset)
		frame.GPS.Texture:SetVertexColor(db.color.r, db.color.g, db.color.b)

		frame.GPS.onMouseOver = db.onMouseOver
		frame.GPS.outOfRange = db.outOfRange

		frame.GPS.UpdateState(frame)
	else
		if frame:IsElementEnabled("GPS") then
			frame:DisableElement("GPS")
		end
	end
end