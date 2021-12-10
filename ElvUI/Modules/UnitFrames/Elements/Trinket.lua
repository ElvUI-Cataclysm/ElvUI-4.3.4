local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")

local CreateFrame = CreateFrame

function UF:Construct_Trinket(frame)
	local trinket = CreateFrame("Frame", nil, frame)
	trinket.bg = CreateFrame("Frame", nil, trinket)
	trinket.bg:SetTemplate("Default", nil, nil, self.thinBorders, true)
	trinket.bg:SetFrameLevel(trinket:GetFrameLevel() - 1)
	trinket:SetInside(trinket.bg)

	return trinket
end

function UF:Configure_Trinket(frame)
	local db = frame.db.pvpTrinket

	frame.Trinket.bg:Size(db.size)
	frame.Trinket.bg:ClearAllPoints()
	frame.Trinket.bg:Point(E.InversePoints[db.position], frame, db.position, db.xOffset, db.yOffset)

	if db.enable and not frame:IsElementEnabled("Trinket") then
		frame:EnableElement("Trinket")
	elseif not db.enable and frame:IsElementEnabled("Trinket") then
		frame:DisableElement("Trinket")
	end
end