local E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM

function NP:Update_Level(frame)
	local db = NP.db.units[frame.UnitType].level
	if not db.enable then return end

	local levelText, r, g, b = NP:UnitLevel(frame)

	frame.Level:ClearAllPoints()

	if frame.Health:IsShown() then
		frame.Level:SetJustifyH("RIGHT")
		frame.Level:SetPoint(E.InversePoints[db.position], db.parent == "Nameplate" and frame or frame[db.parent], db.position, db.xOffset, db.yOffset)
		frame.Level:SetParent(frame.Health)
		frame.Level:SetText(levelText)
	else
		if NP.db.units[frame.UnitType].name.enable then
			frame.Level:SetPoint("LEFT", frame.Name, "RIGHT")
		else
			frame.Level:SetPoint("TOPLEFT", frame, "TOPRIGHT", -38, 0)
		end

		frame.Level:SetParent(frame)
		frame.Level:SetJustifyH("LEFT")
		frame.Level:SetFormattedText(" [%s]", levelText)
	end

	frame.Level:SetTextColor(r, g, b)
end

function NP:Configure_Level(frame)
	local db = NP.db.units[frame.UnitType].level
	frame.Level:FontTemplate(LSM:Fetch("font", db.font), db.fontSize, db.fontOutline)
end

function NP:Construct_Level(frame)
	return frame:CreateFontString(nil, "OVERLAY")
end