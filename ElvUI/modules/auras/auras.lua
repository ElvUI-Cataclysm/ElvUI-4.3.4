local E, L, V, P, G = unpack(select(2, ...))
local A = E:NewModule("Auras", "AceHook-3.0", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")

local _G = _G
local select, unpack = select, unpack
local floor = math.floor
local format, find = string.format, string.find

local GetTime = GetTime
local CreateFrame = CreateFrame
local RegisterStateDriver = RegisterStateDriver
local RegisterAttributeDriver = RegisterAttributeDriver
local GetWeaponEnchantInfo = GetWeaponEnchantInfo
local UnitAura = UnitAura
local GetItemQualityColor = GetItemQualityColor
local GetInventoryItemQuality = GetInventoryItemQuality

local Masque = LibStub("Masque", true)
local MasqueGroupBuffs = Masque and Masque:Group("ElvUI", "Buffs")
local MasqueGroupDebuffs = Masque and Masque:Group("ElvUI", "Debuffs")

local DIRECTION_TO_POINT = {
	DOWN_RIGHT = "TOPLEFT",
	DOWN_LEFT = "TOPRIGHT",
	UP_RIGHT = "BOTTOMLEFT",
	UP_LEFT = "BOTTOMRIGHT",
	RIGHT_DOWN = "TOPLEFT",
	RIGHT_UP = "BOTTOMLEFT",
	LEFT_DOWN = "TOPRIGHT",
	LEFT_UP = "BOTTOMRIGHT"
}

local DIRECTION_TO_HORIZONTAL_SPACING_MULTIPLIER = {
	DOWN_RIGHT = 1,
	DOWN_LEFT = -1,
	UP_RIGHT = 1,
	UP_LEFT = -1,
	RIGHT_DOWN = 1,
	RIGHT_UP = 1,
	LEFT_DOWN = -1,
	LEFT_UP = -1
}

local DIRECTION_TO_VERTICAL_SPACING_MULTIPLIER = {
	DOWN_RIGHT = -1,
	DOWN_LEFT = -1,
	UP_RIGHT = 1,
	UP_LEFT = 1,
	RIGHT_DOWN = -1,
	RIGHT_UP = 1,
	LEFT_DOWN = -1,
	LEFT_UP = 1
}

local IS_HORIZONTAL_GROWTH = {
	RIGHT_DOWN = true,
	RIGHT_UP = true,
	LEFT_DOWN = true,
	LEFT_UP = true
}

function A:UpdateTime(elapsed)
	self.timeLeft = self.timeLeft - elapsed

	if self.nextUpdate > 0 then
		self.nextUpdate = self.nextUpdate - elapsed
		return
	end

	local timeColors, timeThreshold = E.TimeColors, E.db.cooldown.threshold
	if E.db.auras.cooldown.override and E.TimeColors["auras"] then
		timeColors, timeThreshold = E.TimeColors["auras"], E.db.auras.cooldown.threshold
	end
	if not timeThreshold then
		timeThreshold = E.TimeThreshold
	end

	local timerValue, formatID
	timerValue, formatID, self.nextUpdate = E:GetTimeInfo(self.timeLeft, timeThreshold)
	self.time:SetFormattedText(("%s%s|r"):format(timeColors[formatID], E.TimeFormats[formatID][1]), timerValue)

	if self.timeLeft > E.db.auras.fadeThreshold then
		E:StopFlash(self)
	else
		E:Flash(self, 1)
	end
end

function A:CreateIcon(button)
	local font = LSM:Fetch("font", self.db.font)
	local header = button:GetParent()
	local auraType = header:GetAttribute("filter")
	local db = self.db.debuffs
	if auraType == "HELPFUL" then
		db = self.db.buffs
	end

	-- button:SetFrameLevel(4)
	button.texture = button:CreateTexture(nil, "BORDER")
	button.texture:SetInside()
	button.texture:SetTexCoord(unpack(E.TexCoords))

	button.count = button:CreateFontString(nil, "ARTWORK")
	button.count:Point("BOTTOMRIGHT", -1 + self.db.countXOffset, 1 + self.db.countYOffset)
	button.count:FontTemplate(font, db.countFontSize, self.db.fontOutline)

	button.time = button:CreateFontString(nil, "ARTWORK")
	button.time:Point("TOP", button, "BOTTOM", 1 + self.db.timeXOffset, 0 + self.db.timeYOffset)
	button.time:FontTemplate(font, db.durationFontSize, self.db.fontOutline)

	button.highlight = button:CreateTexture(nil, "HIGHLIGHT")
	button.highlight:SetTexture(1, 1, 1, 0.45)
	button.highlight:SetInside()

	E:SetUpAnimGroup(button)

	button:SetScript("OnAttributeChanged", A.OnAttributeChanged)

	local ButtonData = {
		FloatingBG = nil,
		Icon = button.texture,
		Cooldown = nil,
		Flash = nil,
		Pushed = nil,
		Normal = nil,
		Disabled = nil,
		Checked = nil,
		Border = nil,
		AutoCastable = nil,
		Highlight = button.highlight,
		HotKey = nil,
		Count = false,
		Name = nil,
		Duration = false,
		AutoCast = nil,
	}

	if auraType == "HELPFUL" then
		if MasqueGroupBuffs and E.private.auras.masque.buffs then
			MasqueGroupBuffs:AddButton(button, ButtonData)
			if button.__MSQ_BaseFrame then
				button.__MSQ_BaseFrame:SetFrameLevel(2)
			end
			MasqueGroupBuffs:ReSkin()
		else
			button:SetTemplate("Default")
		end
	elseif auraType == "HARMFUL" then
		if MasqueGroupDebuffs and E.private.auras.masque.debuffs then
			MasqueGroupDebuffs:AddButton(button, ButtonData)
			if button.__MSQ_BaseFrame then
				button.__MSQ_BaseFrame:SetFrameLevel(2)
			end
			MasqueGroupDebuffs:ReSkin()
		else
			button:SetTemplate("Default")
		end
	end
end

function A:UpdateAura(button, index)
	local filter = button:GetParent():GetAttribute("filter")
	local unit = button:GetParent():GetAttribute("unit")
	local name, _, texture, count, dtype, duration, expirationTime = UnitAura(unit, index, filter)

	if name then
		if duration > 0 and expirationTime then
			local timeLeft = expirationTime - GetTime()
			if not button.timeLeft then
				button.timeLeft = timeLeft
				button:SetScript("OnUpdate", A.UpdateTime)
			else
				button.timeLeft = timeLeft
			end

			button.nextUpdate = -1
			A.UpdateTime(button, 0)
		else
			button.timeLeft = nil
			button.time:SetText("")
			button:SetScript("OnUpdate", nil)
		end

		if count > 1 then
			button.count:SetText(count)
		else
			button.count:SetText("")
		end

		if filter == "HARMFUL" then
			local color = DebuffTypeColor[dtype or ""]
			button:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			button:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end

		button.texture:SetTexture(texture)
	end
end

function A:OnAttributeChanged(attribute, value)
	if attribute == "index" then
		A:UpdateAura(self, value)
	end
end

function A:UpdateHeader(header)
	if not E.private.auras.enable then return end

	local db = self.db.debuffs
	if header:GetAttribute("filter") == "HELPFUL" then
		db = self.db.buffs
	end

	header:SetAttribute("separateOwn", db.seperateOwn)
	header:SetAttribute("sortMethod", db.sortMethod)
	header:SetAttribute("sortDirection", db.sortDir)
	header:SetAttribute("maxWraps", db.maxWraps)
	header:SetAttribute("wrapAfter", db.wrapAfter)

	header:SetAttribute("point", DIRECTION_TO_POINT[db.growthDirection])

	if IS_HORIZONTAL_GROWTH[db.growthDirection] then
		header:SetAttribute("minWidth", ((db.wrapAfter == 1 and 0 or db.horizontalSpacing) + db.size) * db.wrapAfter)
		header:SetAttribute("minHeight", (db.verticalSpacing + db.size) * db.maxWraps)
		header:SetAttribute("xOffset", DIRECTION_TO_HORIZONTAL_SPACING_MULTIPLIER[db.growthDirection] * (db.horizontalSpacing + db.size))
		header:SetAttribute("yOffset", 0)
		header:SetAttribute("wrapXOffset", 0)
		header:SetAttribute("wrapYOffset", DIRECTION_TO_VERTICAL_SPACING_MULTIPLIER[db.growthDirection] * (db.verticalSpacing + db.size))
	else
		header:SetAttribute("minWidth", (db.horizontalSpacing + db.size) * db.maxWraps)
		header:SetAttribute("minHeight", ((db.wrapAfter == 1 and 0 or db.verticalSpacing) + db.size) * db.wrapAfter)
		header:SetAttribute("xOffset", 0)
		header:SetAttribute("yOffset", DIRECTION_TO_VERTICAL_SPACING_MULTIPLIER[db.growthDirection] * (db.verticalSpacing + db.size))
		header:SetAttribute("wrapXOffset", DIRECTION_TO_HORIZONTAL_SPACING_MULTIPLIER[db.growthDirection] * (db.horizontalSpacing + db.size))
		header:SetAttribute("wrapYOffset", 0)
	end

	header:SetAttribute("template", ("ElvUIAuraTemplate%d"):format(db.size))

	local index = 1
	local child = select(index, header:GetChildren())

	while child do
		if (floor(child:GetWidth() * 100 + 0.5) / 100) ~= db.size then
			child:SetSize(db.size, db.size)
		end

		if child.time then
			local font = LSM:Fetch("font", self.db.font)
			child.time:ClearAllPoints()
			child.time:Point("TOP", child, "BOTTOM", 1 + self.db.timeXOffset, 0 + self.db.timeYOffset)
			child.time:FontTemplate(font, db.durationFontSize, self.db.fontOutline)

			child.count:ClearAllPoints()
			child.count:Point("BOTTOMRIGHT", -1 + self.db.countXOffset, 0 + self.db.countYOffset)
			child.count:FontTemplate(font, db.countFontSize, self.db.fontOutline)
		end

		if index > (db.maxWraps * db.wrapAfter) and child:IsShown() then
			child:Hide()
		end

		index = index + 1
		child = select(index, header:GetChildren())
	end

	if MasqueGroupBuffs and E.private.auras.masque.buffs then MasqueGroupBuffs:ReSkin() end
	if MasqueGroupDebuffs and E.private.auras.masque.debuffs then MasqueGroupDebuffs:ReSkin() end
end

function A:CreateAuraHeader(filter)
	local name = "ElvUIPlayerDebuffs"
	if filter == "HELPFUL" then
		name = "ElvUIPlayerBuffs"
	end

	local header = CreateFrame("Frame", name, E.UIParent, "SecureAuraHeaderTemplate")
	header:SetClampedToScreen(true)
	header:SetAttribute("unit", "player")
	header:SetAttribute("filter", filter)
	RegisterAttributeDriver(header, "unit", "[vehicleui] vehicle; player")

	A:UpdateHeader(header)
	header:Show()

	return header
end

function A:UpdateTempEnchant()
	local font = LSM:Fetch("font", self.db.weapons.font)

	for i = 1, 3 do
		local button = _G["TempEnchant"..i]
		local lastButton = _G["TempEnchant"..i - 1]
		local duration = _G[button:GetName().."Duration"]

		button:Size(self.db.weapons.size)
		button:ClearAllPoints()

		duration:ClearAllPoints()
		duration:Point("TOP", button, "BOTTOM", 1 + self.db.timeXOffset, 0 + self.db.timeYOffset)
		duration:FontTemplate(font, self.db.weapons.fontSize, self.db.weapons.fontOutline)

		if self.db.weapons.growthDirection == "RIGHT_LEFT" then
			if i == 1 then
				button:Point("RIGHT", self.EnchantHeader, "RIGHT", 0, 0)
			else
				button:Point("RIGHT", lastButton, "LEFT", -self.db.weapons.spacing, 0)
			end
		elseif self.db.weapons.growthDirection == "LEFT_RIGHT" then
			if i == 1 then
				button:Point("LEFT", self.EnchantHeader, "LEFT", 0, 0)
			else
				button:Point("LEFT", lastButton, "RIGHT", self.db.weapons.spacing, 0)
			end
		elseif self.db.weapons.growthDirection == "DOWN_UP" then
			if i == 1 then
				button:Point("BOTTOM", self.EnchantHeader, "BOTTOM", 0, 0)
			else
				button:Point("BOTTOM", lastButton, "TOP", 0, self.db.weapons.spacing)
			end
		elseif self.db.weapons.growthDirection == "UP_DOWN" then
			if i == 1 then
				button:Point("TOP", self.EnchantHeader, "TOP", 0, 0)
			else
				button:Point("TOP", lastButton, "BOTTOM", 0, -self.db.weapons.spacing)
			end
		end
	end

	if InCombatLockdown() then return end

	local weaponIndex
	local hasMainHandEnchant, _, _, hasOffHandEnchant, _, _, hasThrownEnchant = GetWeaponEnchantInfo()
	if hasMainHandEnchant and hasOffHandEnchant and hasThrownEnchant then
		weaponIndex = 3
	elseif hasMainHandEnchant and hasOffHandEnchant and not hasThrownEnchant
	or hasMainHandEnchant and not hasOffHandEnchant and hasThrownEnchant
	or not hasMainHandEnchant and hasOffHandEnchant and hasThrownEnchant then
		weaponIndex = 2
	else
		weaponIndex = 1
	end

	if self.db.weapons.growthDirection == "RIGHT_LEFT" or self.db.weapons.growthDirection == "LEFT_RIGHT" then
		self.EnchantHeader:Size((self.db.weapons.size * weaponIndex) + (self.db.weapons.spacing * (weaponIndex - 1)), self.db.weapons.size + 2)
	else
		self.EnchantHeader:Size(self.db.weapons.size + 2, (self.db.weapons.size * weaponIndex) + (self.db.weapons.spacing * (weaponIndex - 1)))
	end
end

function A:UpdateWeaponText(button, timeLeft)
	local duration = _G[button:GetName().."Duration"]

	if timeLeft then
		duration:SetTextColor(1, 1, 1)
		local d, h, m, s = ChatFrame_TimeBreakDown(timeLeft)

		if timeLeft <= 86400.5 and timeLeft > 3600.5 then
			duration:SetFormattedText("%1dh", h)
			E:StopFlash(button)
		elseif timeLeft <= 3600.5 and timeLeft > 60.5 then
			duration:SetFormattedText("%1dm", m)
			E:StopFlash(button)
		elseif timeLeft <= 60.5 and timeLeft > E.db.auras.fadeThreshold then
			duration:SetFormattedText("%1ds", s)
			E:StopFlash(button)
		elseif timeLeft <= E.db.auras.fadeThreshold then
			duration:SetTextColor(1, 0, 0)
			duration:SetFormattedText("%1ds", s)
			E:Flash(button, 1)
		end
	end
end

function A:Initialize()
	if E.private.auras.disableBlizzard then
		BuffFrame:Kill()
		ConsolidatedBuffs:Kill()
		if not E.private.auras.enable then
			TemporaryEnchantFrame:Kill()
		end
	end

	if not E.private.auras.enable then return end

	self.db = E.db.auras

	self.BuffFrame = self:CreateAuraHeader("HELPFUL")
	self.BuffFrame:Point("TOPRIGHT", MMHolder, "TOPLEFT", -(6 + E.Border), -E.Border - E.Spacing)
	E:CreateMover(self.BuffFrame, "BuffsMover", L["Player Buffs"])

	self.DebuffFrame = self:CreateAuraHeader("HARMFUL")
	self.DebuffFrame:Point("BOTTOMRIGHT", MMHolder, "BOTTOMLEFT", -(6 + E.Border), E.Border + E.Spacing)
	E:CreateMover(self.DebuffFrame, "DebuffsMover", L["Player Debuffs"])

	self.EnchantHeader = CreateFrame("Frame", "ElvUITemporaryEnchantFrame", E.UIParent, "SecureHandlerStateTemplate")
	self.EnchantHeader:Point("TOPRIGHT", MMHolder, "BOTTOMRIGHT", 0, -E.Border - E.Spacing)
	self.EnchantHeader:SetAttribute("_onstate-show", [[
		if newstate == "hide" then
			self:Hide()
		else
			self:Show()
		end
	]])
	RegisterStateDriver(self.EnchantHeader, "show", "[vehicleui] hide;show")

	for i = 1, 3 do
		local button = _G["TempEnchant"..i]
		local icon = _G["TempEnchant"..i.."Icon"]
		local border = _G["TempEnchant"..i.."Border"]

		button:SetTemplate("Default", nil, true)
		button:SetBackdropColor(0, 0, 0, 0)
		button.backdropTexture:SetAlpha(0)
		button:StyleButton(nil, true)
		button:SetParent(self.EnchantHeader)

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside()

		border:Hide()
	end

	A:UpdateTempEnchant()

	self:SecureHook("AuraButton_UpdateDuration", "UpdateWeaponText")

	self.EnchantHeader.GetUpdateWeaponEnchant = function(self)
		local hasMainHandEnchant, _, _, hasOffHandEnchant, _, _, hasThrownEnchant = GetWeaponEnchantInfo()
		local mainHand = GetInventoryItemQuality("player", 16)
		local offHand = GetInventoryItemQuality("player", 17)
		local thrown = GetInventoryItemQuality("player", 18)

		if hasMainHandEnchant and hasOffHandEnchant and hasThrownEnchant then
			TempEnchant1:SetBackdropBorderColor(GetItemQualityColor(thrown))
			TempEnchant2:SetBackdropBorderColor(GetItemQualityColor(offHand))
			TempEnchant3:SetBackdropBorderColor(GetItemQualityColor(mainHand))
			return true
		elseif hasMainHandEnchant and hasOffHandEnchant and not hasThrownEnchant then
			TempEnchant1:SetBackdropBorderColor(GetItemQualityColor(offHand))
			TempEnchant2:SetBackdropBorderColor(GetItemQualityColor(mainHand))
			return true
		elseif hasMainHandEnchant and not hasOffHandEnchant and hasThrownEnchant then
			TempEnchant1:SetBackdropBorderColor(GetItemQualityColor(thrown))
			TempEnchant2:SetBackdropBorderColor(GetItemQualityColor(mainHand))
			return true
		elseif not hasMainHandEnchant and hasOffHandEnchant and hasThrownEnchant then
			TempEnchant1:SetBackdropBorderColor(GetItemQualityColor(thrown))
			TempEnchant2:SetBackdropBorderColor(GetItemQualityColor(offHand))
			return true
		elseif hasMainHandEnchant and not hasOffHandEnchant and not hasThrownEnchant then
			TempEnchant1:SetBackdropBorderColor(GetItemQualityColor(mainHand))
			return true
		elseif not hasMainHandEnchant and hasOffHandEnchant and not hasThrownEnchant then
			TempEnchant1:SetBackdropBorderColor(GetItemQualityColor(offHand))
			return true
		elseif not hasMainHandEnchant and not hasOffHandEnchant and hasThrownEnchant then
			TempEnchant1:SetBackdropBorderColor(GetItemQualityColor(thrown))
			return true
		end
	end

	self.EnchantHeader:SetScript("OnUpdate", function(self)
		if self:GetUpdateWeaponEnchant() then A:UpdateTempEnchant() end
	end)

	E:CreateMover(self.EnchantHeader, "TempEnchantMover", L["Weapons"])

	if Masque then
		if MasqueGroupBuffs then A.BuffsMasqueGroup = MasqueGroupBuffs end
		if MasqueGroupDebuffs then A.DebuffsMasqueGroup = MasqueGroupDebuffs end
	end
end

local function InitializeCallback()
	A:Initialize()
end

E:RegisterModule(A:GetName(), InitializeCallback)