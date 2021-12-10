local E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM

local unpack = unpack
local abs = math.abs

local CreateFrame = CreateFrame
local GetTime = GetTime
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo

local FAILED = FAILED
local INTERRUPTED = INTERRUPTED

local function resetAttributes(self)
	self.casting = nil
	self.channeling = nil
	self.notInterruptible = nil
	self.spellName = nil
end

function NP:Update_CastBarOnUpdate(elapsed)
	if self.casting or self.channeling then
		if self.casting then
			self.value = self.value + elapsed
			if self.value >= self.max then
				resetAttributes(self)
				self:Hide()
				NP:StyleFilterUpdate(self:GetParent(), "FAKE_Casting")
				return
			end
		else
			self.value = self.value - elapsed
			if self.value <= 0 then
				resetAttributes(self)
				self:Hide()
				NP:StyleFilterUpdate(self:GetParent(), "FAKE_Casting")
				return
			end
		end

		if self.delay ~= 0 then
			if self.channeling then
				if self.channelTimeFormat == "CURRENT" then
					self.Time:SetFormattedText("%.1f |cffaf5050%.2f|r", abs(self.value - self.max), self.delay)
				elseif self.channelTimeFormat == "CURRENTMAX" then
					self.Time:SetFormattedText("%.1f / %.2f |cffaf5050%.2f|r", abs(self.value - self.max), self.max, self.delay)
				elseif self.channelTimeFormat == "REMAINING" then
					self.Time:SetFormattedText("%.1f |cffaf5050%.2f|r", self.value, self.delay)
				elseif self.channelTimeFormat == "REMAININGMAX" then
					self.Time:SetFormattedText("%.1f / %.2f |cffaf5050%.2f|r", self.value, self.max, self.max, self.delay)
				end
			else
				if self.castTimeFormat == "CURRENT" then
					self.Time:SetFormattedText("%.1f |cffaf5050%s %.2f|r", self.value, "+", self.delay)
				elseif self.castTimeFormat == "CURRENTMAX" then
					self.Time:SetFormattedText("%.1f / %.2f |cffaf5050%s %.2f|r", self.value, self.max, "+", self.delay)
				elseif self.castTimeFormat == "REMAINING" then
					self.Time:SetFormattedText("%.1f |cffaf5050%s %.2f|r", abs(self.value - self.max), "+", self.delay)
				elseif self.castTimeFormat == "REMAININGMAX" then
					self.Time:SetFormattedText("%.1f / %.2f |cffaf5050%s %.2f|r", abs(self.value - self.max), self.max, "+", self.delay)
				end
			end
		else
			if self.channeling then
				if self.channelTimeFormat == "CURRENT" then
					self.Time:SetFormattedText("%.1f", abs(self.value - self.max))
				elseif self.channelTimeFormat == "CURRENTMAX" then
					self.Time:SetFormattedText("%.1f / %.2f", abs(self.value - self.max), self.max)
				elseif self.channelTimeFormat == "REMAINING" then
					self.Time:SetFormattedText("%.1f", self.value)
				elseif self.channelTimeFormat == "REMAININGMAX" then
					self.Time:SetFormattedText("%.1f / %.2f", self.value, self.max)
				end
			else
				if self.castTimeFormat == "CURRENT" then
					self.Time:SetFormattedText("%.1f", self.value)
				elseif self.castTimeFormat == "CURRENTMAX" then
					self.Time:SetFormattedText("%.1f / %.2f", self.value, self.max)
				elseif self.castTimeFormat == "REMAINING" then
					self.Time:SetFormattedText("%.1f", abs(self.value - self.max))
				elseif self.castTimeFormat == "REMAININGMAX" then
					self.Time:SetFormattedText("%.1f / %.2f", abs(self.value - self.max), self.max)
				end
			end
		end

		self:SetValue(self.value)
	elseif self.holdTime > 0 then
		self.holdTime = self.holdTime - elapsed
	else
		resetAttributes(self)
		self:Hide()
		NP:StyleFilterUpdate(self:GetParent(), "FAKE_Casting")
	end
end

function NP:Update_CastBar(frame, event, unit)
	if unit then
		if not event then
			if UnitChannelInfo(unit) then
				event = "UNIT_SPELLCAST_CHANNEL_START"
			elseif UnitCastingInfo(unit) then
				event = "UNIT_SPELLCAST_START"
			end
		end
	elseif frame.CastBar:IsShown() then
		resetAttributes(frame.CastBar)
		frame.CastBar:Hide()
	end

	if not NP.db.units[frame.UnitType].castbar.enable then return end
	if not frame.Health:IsShown() then return end

	if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" then
		local name, _, _, texture, startTime, endTime, _, _, notInterruptible = UnitCastingInfo(unit)
		event = "UNIT_SPELLCAST_START"
		if not name then
			name, _, _, texture, startTime, endTime, _, notInterruptible = UnitChannelInfo(unit)
			event = "UNIT_SPELLCAST_CHANNEL_START"
		end

		if not name then
			resetAttributes(frame.CastBar)
			frame.CastBar:Hide()
			return
		end

		endTime = endTime / 1000
		startTime = startTime / 1000

		frame.CastBar.max = endTime - startTime
		frame.CastBar.startTime = startTime
		frame.CastBar.delay = 0
		frame.CastBar.casting = event == "UNIT_SPELLCAST_START"
		frame.CastBar.channeling = event == "UNIT_SPELLCAST_CHANNEL_START"
		frame.CastBar.notInterruptible = notInterruptible
		frame.CastBar.holdTime = 0
		frame.CastBar.interrupted = nil
		frame.CastBar.spellName = name

		if frame.CastBar.casting then
			frame.CastBar.value = GetTime() - startTime
		else
			frame.CastBar.value = endTime - GetTime()
		end

		frame.CastBar:SetMinMaxValues(0, frame.CastBar.max)
		frame.CastBar:SetValue(frame.CastBar.value)

		frame.CastBar.Icon.texture:SetTexture(texture)
		frame.CastBar.Name:SetText(name)
		frame.CastBar.Time:SetText()

		if NP.db.units[frame.UnitType].castbar.spark then
			frame.CastBar.Spark:Show()
		end

		frame.CastBar:Show()
	elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP" then
		if frame.CastBar:IsShown() then
			resetAttributes(frame.CastBar)
		end
	elseif event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" then
		if frame.CastBar:IsShown() then
			frame.CastBar.Spark:Hide()

			if not frame.CastBar.sourceInterrupt then
				frame.CastBar.Name:SetText(event == "UNIT_SPELLCAST_FAILED" and FAILED or INTERRUPTED)
			end

			frame.CastBar.holdTime = NP.db.units[frame.UnitType].castbar.timeToHold --How long the castbar should stay visible after being interrupted, in seconds
			frame.CastBar.interrupted = true

			resetAttributes(frame.CastBar)
		end
	elseif event == "UNIT_SPELLCAST_DELAYED" or event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
		if frame:IsShown() then
			local name, startTime, endTime, _
			if event == "UNIT_SPELLCAST_DELAYED" then
				name, _, _, _, startTime, endTime = UnitCastingInfo(unit)
			else
				name, _, _, _, startTime, endTime = UnitChannelInfo(unit)
			end

			if not name then
				resetAttributes(frame.CastBar)
				frame.CastBar:Hide()
				return
			end

			endTime = endTime / 1000
			startTime = startTime / 1000

			local delta
			if frame.CastBar.casting then
				delta = startTime - frame.CastBar.startTime
				frame.CastBar.value = GetTime() - startTime
			else
				delta = frame.CastBar.startTime - startTime
				frame.CastBar.value = endTime - GetTime()
			end

			if delta < 0 then
				delta = 0
			end

			frame.CastBar.Name:SetText(name)
			frame.CastBar.max = endTime - startTime
			frame.CastBar.startTime = startTime
			frame.CastBar.delay = frame.CastBar.delay + delta
			frame.CastBar:SetMinMaxValues(0, frame.CastBar.max)
			frame.CastBar:SetValue(frame.CastBar.value)
		end
	elseif event == "UNIT_SPELLCAST_INTERRUPTIBLE" or event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE" then
		frame.CastBar.notInterruptible = event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE"
	end

	if not frame.CastBar.notInterruptible then
		if frame.CastBar.interrupted then
			frame.CastBar:SetStatusBarColor(NP.db.colors.castInterruptedColor.r, NP.db.colors.castInterruptedColor.g, NP.db.colors.castInterruptedColor.b)
		else
			frame.CastBar:SetStatusBarColor(NP.db.colors.castColor.r, NP.db.colors.castColor.g, NP.db.colors.castColor.b)
		end
		frame.CastBar.Icon.texture:SetDesaturated(false)
	else
		frame.CastBar:SetStatusBarColor(NP.db.colors.castNoInterruptColor.r, NP.db.colors.castNoInterruptColor.g, NP.db.colors.castNoInterruptColor.b)

		if NP.db.colors.castbarDesaturate then
			frame.CastBar.Icon.texture:SetDesaturated(true)
		end
	end

	NP:StyleFilterUpdate(frame, "FAKE_Casting")
end

function NP:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, _, sourceGUID, sourceName, _, _, targetGUID)
	if (event == "SPELL_INTERRUPT" or event == "SPELL_PERIODIC_INTERRUPT") and targetGUID and (sourceName and sourceName ~= "") then
		local frame = NP:SearchNameplateByGUID(targetGUID)

		if frame and frame.CastBar then
			local db = frame.UnitType and NP.db and NP.db.units and NP.db.units[frame.UnitType]

			if db and db.castbar and db.castbar.enable and db.castbar.timeToHold > 0 and db.castbar.sourceInterrupt then
				local sourceNameColored
				if db.castbar.sourceInterruptClassColor then
					local class = select(3, pcall(GetPlayerInfoByGUID, sourceGUID))
					local classColor = class and E:ClassColor(class)
					sourceNameColored = classColor.colorStr and strjoin("", "|c", classColor.colorStr, sourceName)
				end

				frame.CastBar.Name:SetFormattedText("%s > %s", INTERRUPTED, sourceNameColored or sourceName)

				frame.CastBar.sourceInterrupt = true
			else
				frame.CastBar.sourceInterrupt = nil
			end
		end
	end
end

function NP:Configure_CastBarScale(frame, scale, noPlayAnimation)
	if frame.currentScale == scale then return end

	local db = NP.db.units[frame.UnitType].castbar
	if not db or (db and not db.enable) then return end

	if noPlayAnimation then
		frame.CastBar:SetSize(db.width * scale, db.height * scale)
		frame.CastBar.Icon:SetSize(db.iconSize * scale, db.iconSize * scale)
	else
		if frame.CastBar.scale:IsPlaying() or frame.CastBar.Icon.scale:IsPlaying() then
			frame.CastBar.scale:Stop()
			frame.CastBar.Icon.scale:Stop()
		end

		frame.CastBar.scale.width:SetChange(db.width * scale)
		frame.CastBar.scale.height:SetChange(db.height * scale)
		frame.CastBar.scale:Play()

		frame.CastBar.Icon.scale.width:SetChange(db.iconSize * scale)
		frame.CastBar.Icon.scale.height:SetChange(db.iconSize * scale)
		frame.CastBar.Icon.scale:Play()
	end
end

function NP:Configure_CastBar(frame, configuring)
	local db = NP.db.units[frame.UnitType].castbar
	if not db or (db and not db.enable) then return end

	frame.CastBar:SetStatusBarTexture(LSM:Fetch("statusbar", NP.db.statusbar))
	frame.CastBar:SetPoint("TOP", frame.Health, "BOTTOM", db.xOffset, db.yOffset)

	if db.showIcon then
		frame.CastBar.Icon:ClearAllPoints()
		frame.CastBar.Icon:SetPoint(db.iconPosition == "RIGHT" and "BOTTOMLEFT" or "BOTTOMRIGHT", frame.CastBar, db.iconPosition == "RIGHT" and "BOTTOMRIGHT" or "BOTTOMLEFT", db.iconOffsetX, db.iconOffsetY)
		frame.CastBar.Icon:Show()
	else
		frame.CastBar.Icon:Hide()
	end

	frame.CastBar.Spark:SetPoint("CENTER", frame.CastBar:GetStatusBarTexture(), "RIGHT", 0, 0)
	frame.CastBar.Spark:SetHeight(db.height * 2)

	frame.CastBar.Time:ClearAllPoints()
	frame.CastBar.Name:ClearAllPoints()

	if db.textPosition == "BELOW" then
		frame.CastBar.Time:SetPoint("TOPRIGHT", frame.CastBar, "BOTTOMRIGHT", db.timeXOffset, db.timeYOffset)
		frame.CastBar.Name:SetPoint("TOPLEFT", frame.CastBar, "BOTTOMLEFT", db.textXOffset, db.textYOffset)
	elseif db.textPosition == "ABOVE" then
		frame.CastBar.Time:SetPoint("BOTTOMRIGHT", frame.CastBar, "TOPRIGHT", db.timeXOffset, db.timeYOffset)
		frame.CastBar.Name:SetPoint("BOTTOMLEFT", frame.CastBar, "TOPLEFT", db.textXOffset, db.textYOffset)
	else
		frame.CastBar.Time:SetPoint("RIGHT", frame.CastBar, "RIGHT", db.timeXOffset, db.timeYOffset)
		frame.CastBar.Name:SetPoint("LEFT", frame.CastBar, "LEFT", db.textXOffset, db.textYOffset)
	end

	local font = LSM:Fetch("font", db.font)
	frame.CastBar.Name:FontTemplate(font, db.fontSize, db.fontOutline)
	frame.CastBar.Time:FontTemplate(font, db.fontSize, db.fontOutline)

	if db.hideSpellName then
		frame.CastBar.Name:Hide()
	else
		frame.CastBar.Name:Show()
	end
	if db.hideTime then
		frame.CastBar.Time:Hide()
	else
		frame.CastBar.Time:Show()
	end

	frame.CastBar.castTimeFormat = db.castTimeFormat
	frame.CastBar.channelTimeFormat = db.channelTimeFormat

	if configuring then
		NP:Configure_CastBarScale(frame, frame.currentScale or 1, configuring)
	end
end

function NP:Construct_CastBar(parent)
	local frame = CreateFrame("StatusBar", "$parentCastBar", parent)
	NP:StyleFrame(frame)
	frame:SetScript("OnUpdate", NP.Update_CastBarOnUpdate)

	frame.Icon = CreateFrame("Frame", nil, frame)
	frame.Icon.texture = frame.Icon:CreateTexture(nil, "BORDER")
	frame.Icon.texture:SetAllPoints()
	frame.Icon.texture:SetTexCoord(unpack(E.TexCoords))
	NP:StyleFrame(frame.Icon)

	frame.Time = frame:CreateFontString(nil, "OVERLAY")
	frame.Time:SetJustifyH("RIGHT")
	frame.Time:SetWordWrap(false)

	frame.Name = frame:CreateFontString(nil, "OVERLAY")
	frame.Name:SetJustifyH("LEFT")
	frame.Name:SetWordWrap(false)

	frame.Spark = frame:CreateTexture(nil, "OVERLAY")
	frame.Spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
	frame.Spark:SetBlendMode("ADD")
	frame.Spark:SetSize(15, 15)

	frame.holdTime = 0
	frame.interrupted = nil
	frame.sourceInterrupt = nil

	frame.scale = CreateAnimationGroup(frame)
	frame.scale.width = frame.scale:CreateAnimation("Width")
	frame.scale.width:SetDuration(0.2)
	frame.scale.height = frame.scale:CreateAnimation("Height")
	frame.scale.height:SetDuration(0.2)

	frame.Icon.scale = CreateAnimationGroup(frame.Icon)
	frame.Icon.scale.width = frame.Icon.scale:CreateAnimation("Width")
	frame.Icon.scale.width:SetDuration(0.2)
	frame.Icon.scale.height = frame.Icon.scale:CreateAnimation("Height")
	frame.Icon.scale.height:SetDuration(0.2)

	frame:Hide()

	return frame
end