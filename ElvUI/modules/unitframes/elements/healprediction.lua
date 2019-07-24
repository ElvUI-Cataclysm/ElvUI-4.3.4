local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")

local CreateFrame = CreateFrame
local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs

function UF:Construct_HealComm(frame)
	local myBar = CreateFrame("StatusBar", nil, frame.Health)
	myBar:SetFrameLevel(11)
	myBar.parent = frame.Health
	UF.statusbars[myBar] = true
	myBar:Hide()

	local otherBar = CreateFrame("StatusBar", nil, frame.Health)
	otherBar:SetFrameLevel(11)
	otherBar.parent = frame.Health
	UF.statusbars[otherBar] = true
	otherBar:Hide()

	local texture = (not frame.Health.isTransparent and frame.Health:GetStatusBarTexture()) or E.media.blankTex
	UF:Update_StatusBar(myBar, texture)
	UF:Update_StatusBar(otherBar, texture)

	return {
		myBar = myBar,
		otherBar = otherBar,
		PostUpdate = UF.UpdateHealComm,
		maxOverflow = 1,
		parent = frame,
	}
end

function UF:Configure_HealComm(frame)
	if frame.db.healPrediction and frame.db.healPrediction.enable then
		local healPrediction = frame.HealthPrediction
		local myBar = healPrediction.myBar
		local otherBar = healPrediction.otherBar
		local c = self.db.colors.healPrediction
		healPrediction.maxOverflow = 1 + (c.maxOverflow or 0)

		if not frame:IsElementEnabled("HealthPrediction") then
			frame:EnableElement("HealthPrediction")
		end

		myBar:SetParent(frame.Health)
		otherBar:SetParent(frame.Health)

		 if frame.db.health then
			local orientation = frame.db.health.orientation or frame.Health:GetOrientation()
			local reverseFill = not not frame.db.health.reverseFill

			myBar:SetOrientation(orientation)
			otherBar:SetOrientation(orientation)

			if orientation == "HORIZONTAL" then
				local width = frame.Health:GetWidth()
				width = width > 0 and width or frame.Health.WIDTH
				local p1 = reverseFill and "RIGHT" or "LEFT"
				local p2 = reverseFill and "LEFT" or "RIGHT"

				myBar:ClearAllPoints()
				myBar:Point("TOP", frame.Health, "TOP")
				myBar:Point("BOTTOM", frame.Health, "BOTTOM")
				myBar:Point(p1, frame.Health:GetStatusBarTexture(), p2)
				myBar:Size(width, 0)

				otherBar:ClearAllPoints()
				otherBar:Point("TOP", frame.Health, "TOP")
				otherBar:Point("BOTTOM", frame.Health, "BOTTOM")
				otherBar:Point(p1, myBar:GetStatusBarTexture(), p2)
				otherBar:Size(width, 0)
			else
				local height = frame.Health:GetHeight()
				height = height > 0 and height or frame.Health.HEIGHT
				local p1 = reverseFill and "TOP" or "BOTTOM"
				local p2 = reverseFill and "BOTTOM" or "TOP"

				myBar:ClearAllPoints()
				myBar:Point("LEFT", frame.Health, "LEFT")
				myBar:Point("RIGHT", frame.Health, "RIGHT")
				myBar:Point(p1, frame.Health:GetStatusBarTexture(), p2)
				myBar:Size(0, height)

				otherBar:ClearAllPoints()
				otherBar:Point("LEFT", frame.Health, "LEFT")
				otherBar:Point("RIGHT", frame.Health, "RIGHT")
				otherBar:Point(p1, myBar:GetStatusBarTexture(), p2)
				otherBar:Size(0, height)
			end

			myBar:SetReverseFill(reverseFill)
			otherBar:SetReverseFill(reverseFill)
		end

		myBar:SetStatusBarColor(c.personal.r, c.personal.g, c.personal.b, c.personal.a)
		otherBar:SetStatusBarColor(c.others.r, c.others.g, c.others.b, c.others.a)
	else
		if frame:IsElementEnabled("HealthPrediction") then
			frame:DisableElement("HealthPrediction")
		end
	end
end