local E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule("NamePlates")

function NP:Update_IconFrame(frame)
	local db = NP.db.units[frame.UnitType].iconFrame
	if not db then return end

	if db.enable or (frame.IconOnlyChanged or frame.IconChanged) then
		local totem, unit, icon = NP.Totems[frame.UnitName], NP.UniqueUnits[frame.UnitName]

		if totem then
			icon = NP.TriggerConditions.totems[totem][3]
		elseif unit then
			icon = NP.TriggerConditions.uniqueUnits[unit][3]
		end

		if icon then
			frame.IconFrame.texture:SetTexture(icon)
			frame.IconFrame:Show()

			NP:StyleFrameColor(frame.IconFrame, frame.oldHealthBar:GetStatusBarColor())
		else
			frame.IconFrame:Hide()
		end
	else
		frame.IconFrame:Hide()
	end
end

function NP:Configure_IconFrame(frame, triggered)
	local db = NP.db.units[frame.UnitType].iconFrame
	if not db then return end

	if db.enable or (frame.IconOnlyChanged or frame.IconChanged) then
		frame.IconFrame:SetSize(db.size, db.size)
		frame.IconFrame:ClearAllPoints()

		if triggered then
			frame.IconFrame:SetPoint("TOP", frame)
		else
			frame.IconFrame:SetPoint(E.InversePoints[db.position], db.parent == "Nameplate" and frame or frame[db.parent], db.position, db.xOffset, db.yOffset)
		end
	else
		frame.IconFrame:Hide()
	end
end

function NP:Construct_IconFrame(frame)
	local iconFrame = CreateFrame("Frame", nil, frame)
	iconFrame:Hide()
	iconFrame:SetSize(24, 24)
	iconFrame:SetPoint("CENTER")
	NP:StyleFrame(iconFrame, true)

	iconFrame.texture = iconFrame:CreateTexture()
	iconFrame.texture:SetAllPoints()
	iconFrame.texture:SetTexCoord(unpack(E.TexCoords))

	return iconFrame
end