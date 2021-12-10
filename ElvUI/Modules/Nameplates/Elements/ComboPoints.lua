local E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM

local CreateFrame = CreateFrame
local GetComboPoints = GetComboPoints
local MAX_COMBO_POINTS = MAX_COMBO_POINTS

function NP:Update_CPoints(frame)
	if frame.UnitType == "FRIENDLY_PLAYER" or frame.UnitType == "FRIENDLY_NPC" then return end

	local db = NP.db.units[frame.UnitType].comboPoints
	if not db or (db and not db.enable) then return end

	local numPoints
	if frame.isTarget then
		numPoints = GetComboPoints("player", "target")
	end

	if numPoints and numPoints > 0 then
		frame.CPoints:Show()

		for i = 1, MAX_COMBO_POINTS do
			if db.hideEmpty then
				if i <= numPoints then
					frame.CPoints[i]:Show()
				else
					frame.CPoints[i]:Hide()
				end
			else
				local r, g, b = unpack(E:GetColorTable(NP.db.colors.comboPoints[i]))
				local mult = i <= numPoints and 1 or 0.35

				frame.CPoints[i]:SetStatusBarColor(r * mult, g * mult, b * mult)
				frame.CPoints[i]:Show()
			end
		end
	else
		frame.CPoints:Hide()
	end
end

function NP:Configure_CPointsScale(frame, scale, noPlayAnimation)
	if frame.UnitType == "FRIENDLY_PLAYER" or frame.UnitType == "FRIENDLY_NPC" then return end

	local db = NP.db.units[frame.UnitType].comboPoints
	if not db or (db and not db.enable) then return end

	if noPlayAnimation then
		frame.CPoints:SetWidth(((db.width * 5) + (db.spacing * 4)) * scale)
		frame.CPoints:SetHeight(db.height * scale)
	else
		if frame.CPoints.scale:IsPlaying() then
			frame.CPoints.scale:Stop()
		end

		frame.CPoints.scale.width:SetChange(((db.width * 5) + (db.spacing * 4)) * scale)
		frame.CPoints.scale.height:SetChange(db.height * scale)
		frame.CPoints.scale:Play()
	end
end

function NP:Configure_CPoints(frame, configuring)
	if frame.UnitType == "FRIENDLY_PLAYER" or frame.UnitType == "FRIENDLY_NPC" then return end

	local db = NP.db.units[frame.UnitType].comboPoints
	if not db or (db and not db.enable) then return end

	local healthShown = NP.db.units[frame.UnitType].health.enable or (frame.isTarget and NP.db.alwaysShowTargetHealth)
	local scale = (frame.ThreatScale or 1) * (NP.db.useTargetScale and NP.db.targetScale or 1)

	frame.CPoints:ClearAllPoints()
	frame.CPoints:SetPoint("CENTER", healthShown and frame.Health or frame, healthShown and "BOTTOM" or "TOP", db.xOffset, db.yOffset)
	frame.CPoints.spacing = db.spacing * (MAX_COMBO_POINTS - 1)

	for i = 1, MAX_COMBO_POINTS do
		frame.CPoints[i]:SetWidth(healthShown and db.width * scale or db.width)
		frame.CPoints[i]:SetHeight(healthShown and db.height * scale or db.height)
		frame.CPoints[i]:SetStatusBarTexture(LSM:Fetch("statusbar", NP.db.statusbar))
		frame.CPoints[i]:SetStatusBarColor(unpack(E:GetColorTable(NP.db.colors.comboPoints[i])))

		if i == 3 then
			frame.CPoints[i]:SetPoint("CENTER", frame.CPoints, "CENTER")
		elseif i == 1 or i == 2 then
			frame.CPoints[i]:SetPoint("RIGHT", frame.CPoints[i + 1], "LEFT", -db.spacing, 0)
		else
			frame.CPoints[i]:SetPoint("LEFT", frame.CPoints[i - 1], "RIGHT", db.spacing, 0)
		end
	end

	if configuring then
		NP:Configure_CPointsScale(frame, frame.currentScale or 1, configuring)
	end
end

local function CPoints_OnSizeChanged(self, width)
	width = width - self.spacing

	for i = 1, MAX_COMBO_POINTS do
		self[i]:SetWidth(width * 0.2)
	end
end

function NP:Construct_CPoints(parent)
	local comboBar = CreateFrame("Frame", "$parentComboPoints", parent)
	comboBar:SetSize(68, 1)
	comboBar:Hide()

	comboBar.scale = CreateAnimationGroup(comboBar)
	comboBar.scale.width = comboBar.scale:CreateAnimation("Width")
	comboBar.scale.width:SetDuration(0.2)
	comboBar.scale.height = comboBar.scale:CreateAnimation("Height")
	comboBar.scale.height:SetDuration(0.2)

	comboBar:SetScript("OnSizeChanged", CPoints_OnSizeChanged)

	for i = 1, MAX_COMBO_POINTS do
		comboBar[i] = CreateFrame("StatusBar", "$parentComboPoint"..i, comboBar)

		NP:StyleFrame(comboBar[i])
	end

	return comboBar
end