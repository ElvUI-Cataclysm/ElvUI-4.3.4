local E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM

local PRIEST_COLOR = RAID_CLASS_COLORS.PRIEST

function NP:Update_HealthOnValueChanged()
	local frame = self:GetParent().UnitFrame
	if not frame.UnitType then return end

	NP:Update_Health(frame)
	NP:Update_HealthColor(frame)
	NP:Update_Glow(frame)
	NP:StyleFilterUpdate(frame, "UNIT_HEALTH")
end

function NP:Update_HealthColor(frame)
	if not frame.Health:IsShown() then return end

	local r, g, b, classColor, useClassColor
	local scale = 1

	if frame.UnitClass then
		classColor = E:ClassColor(frame.UnitClass) or PRIEST_COLOR
		useClassColor = NP.db.units[frame.UnitType].health.useClassColor
	end

	if classColor and ((frame.UnitType == "FRIENDLY_PLAYER" and useClassColor) or (frame.UnitType == "ENEMY_PLAYER" and useClassColor)) then
		r, g, b = classColor.r, classColor.g, classColor.b
	else
		local db = NP.db.colors
		if frame.ThreatStatus then
			if frame.ThreatStatus == 3 then
				if E:GetPlayerRole() == "TANK" then
					r, g, b = db.threat.goodColor.r, db.threat.goodColor.g, db.threat.goodColor.b
					scale = NP.db.threat.goodScale
				else
					r, g, b = db.threat.badColor.r, db.threat.badColor.g, db.threat.badColor.b
					scale = NP.db.threat.badScale
				end
			elseif frame.ThreatStatus == 2 then
				if E:GetPlayerRole() == "TANK" then
					r, g, b = db.threat.badTransition.r, db.threat.badTransition.g, db.threat.badTransition.b
				else
					r, g, b = db.threat.goodTransition.r, db.threat.goodTransition.g, db.threat.goodTransition.b
				end
				scale = 1
			elseif frame.ThreatStatus == 1 then
				if E:GetPlayerRole() == "TANK" then
					r, g, b = db.threat.goodTransition.r, db.threat.goodTransition.g, db.threat.goodTransition.b
				else
					r, g, b = db.threat.badTransition.r, db.threat.badTransition.g, db.threat.badTransition.b
				end
				scale = 1
			else
				if E:GetPlayerRole() == "TANK" then
					r, g, b = db.threat.badColor.r, db.threat.badColor.g, db.threat.badColor.b
					scale = NP.db.threat.badScale
				else
					r, g, b = db.threat.goodColor.r, db.threat.goodColor.g, db.threat.goodColor.b
					scale = NP.db.threat.goodScale
				end
			end
		end

		if (not frame.ThreatStatus) or (frame.ThreatStatus and not NP.db.threat.useThreatColor) then
			if frame.UnitReaction and frame.UnitReaction == 4 then
				r, g, b = db.reactions.neutral.r, db.reactions.neutral.g, db.reactions.neutral.b
			elseif frame.UnitReaction and frame.UnitReaction > 4 then
				if frame.UnitType == "FRIENDLY_PLAYER" then
					r, g, b = db.reactions.friendlyPlayer.r, db.reactions.friendlyPlayer.g, db.reactions.friendlyPlayer.b
				else
					r, g, b = db.reactions.good.r, db.reactions.good.g, db.reactions.good.b
				end
			else
				r, g, b = db.reactions.bad.r, db.reactions.bad.g, db.reactions.bad.b
			end
		end
	end

	if r ~= frame.Health.r or g ~= frame.Health.g or b ~= frame.Health.b then
		if not frame.HealthColorChanged then
			frame.Health:SetStatusBarColor(r, g, b)
			if frame.HealthColorChangeCallbacks then
				for _, cb in ipairs(frame.HealthColorChangeCallbacks) do
					cb(self, frame, r, g, b)
				end
			end
		end
		frame.Health.r, frame.Health.g, frame.Health.b = r, g, b
	end

	if frame.ThreatScale ~= scale then
		frame.ThreatScale = scale
		if frame.isTarget and NP.db.useTargetScale then
			scale = scale * NP.db.targetScale
		end
		NP:SetFrameScale(frame, scale * (frame.ActionScale or 1))
	end
end

function NP:Update_Health(frame)
	if not frame.Health:IsShown() then return end

	local health = frame.oldHealthBar:GetValue()
	local _, maxHealth = frame.oldHealthBar:GetMinMaxValues()
	frame.Health:SetMinMaxValues(0, maxHealth)

	if frame.HealthValueChangeCallbacks then
		for _, cb in ipairs(frame.HealthValueChangeCallbacks) do
			cb(self, frame, health, maxHealth)
		end
	end

	frame.Health:SetValue(health)
	frame.FlashTexture:Point("TOPRIGHT", frame.Health:GetStatusBarTexture(), "TOPRIGHT") --idk why this fixes this

	if NP.db.units[frame.UnitType].health.text.enable then
		frame.Health.Text:SetText(E:GetFormattedText(NP.db.units[frame.UnitType].health.text.format, health, maxHealth))
	end
end

function NP:RegisterHealthCallbacks(frame, valueChangeCB, colorChangeCB)
	if valueChangeCB then
		frame.HealthValueChangeCallbacks = frame.HealthValueChangeCallbacks or {}
		tinsert(frame.HealthValueChangeCallbacks, valueChangeCB)
	end

	if colorChangeCB then
		frame.HealthColorChangeCallbacks = frame.HealthColorChangeCallbacks or {}
		tinsert(frame.HealthColorChangeCallbacks, colorChangeCB)
	end
end

function NP:Update_HealthBar(frame)
	if NP.db.units[frame.UnitType].health.enable or (frame.isTarget and NP.db.alwaysShowTargetHealth) then
		frame.Health:Show()
	else
		frame.Health:Hide()
	end
end

function NP:Configure_HealthBarScale(frame, scale, noPlayAnimation)
	local db = NP.db.units[frame.UnitType].health
	if not db then return end

	if noPlayAnimation then
		frame.Health:SetWidth(db.width * scale)
		frame.Health:SetHeight(db.height * scale)
	else
		if frame.Health.scale:IsPlaying() then
			frame.Health.scale:Stop()
		end

		frame.Health.scale.width:SetChange(db.width * scale)
		frame.Health.scale.height:SetChange(db.height * scale)
		frame.Health.scale:Play()
	end
end

function NP:Configure_Health(frame, configuring)
	local db = NP.db.units[frame.UnitType].health

	frame.Health:SetPoint("TOP", frame, "TOP", 0, 0)

	if configuring then
		frame.Health:SetStatusBarTexture(LSM:Fetch("statusbar", NP.db.statusbar), "BORDER")

		NP:Configure_HealthBarScale(frame, frame.currentScale or 1, configuring)

		E:SetSmoothing(frame.Health, NP.db.smoothbars)

		if db.text.enable then
			frame.Health.Text:ClearAllPoints()
			frame.Health.Text:Point(E.InversePoints[db.text.position], db.text.parent == "Nameplate" and frame or frame[db.text.parent], db.text.position, db.text.xOffset, db.text.yOffset)
			frame.Health.Text:FontTemplate(LSM:Fetch("font", db.text.font), db.text.fontSize, db.text.fontOutline)
			frame.Health.Text:Show()
		else
			frame.Health.Text:Hide()
		end
	end
end

local function Health_OnSizeChanged(self, width)
	local health = self:GetValue()
	local _, maxHealth = self:GetMinMaxValues()

	self:GetStatusBarTexture():SetPoint("TOPRIGHT", -(width * ((maxHealth - health) / maxHealth)), 0)
end

function NP:Construct_Health(parent)
	local frame = CreateFrame("StatusBar", "$parentHealth", parent)
	frame:SetStatusBarTexture(LSM:Fetch("statusbar", NP.db.statusbar), "BORDER")
	NP:StyleFrame(frame)

	frame:SetScript("OnSizeChanged", Health_OnSizeChanged)

	parent.FlashTexture = frame:CreateTexture(nil, "OVERLAY")
	parent.FlashTexture:SetTexture(LSM:Fetch("background", "ElvUI Blank"))
	parent.FlashTexture:Point("BOTTOMLEFT", frame:GetStatusBarTexture(), "BOTTOMLEFT")
	parent.FlashTexture:Point("TOPRIGHT", frame:GetStatusBarTexture(), "TOPRIGHT")
	parent.FlashTexture:Hide()

	frame.Text = frame:CreateFontString(nil, "OVERLAY")
	frame.Text:SetAllPoints(frame)
	frame.Text:SetWordWrap(false)

	frame.scale = CreateAnimationGroup(frame)
	frame.scale.width = frame.scale:CreateAnimation("Width")
	frame.scale.width:SetDuration(0.2)
	frame.scale.height = frame.scale:CreateAnimation("Height")
	frame.scale.height:SetDuration(0.2)

	frame:Hide()

	return frame
end