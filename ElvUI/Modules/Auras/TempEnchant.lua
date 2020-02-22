local E, L, V, P, G = unpack(select(2, ...))
local A = E:GetModule("Auras")
local LSM = E.Libs.LSM

local _G = _G
local unpack = unpack

local GetInventoryItemQuality = GetInventoryItemQuality
local GetItemQualityColor = GetItemQualityColor
local GetWeaponEnchantInfo = GetWeaponEnchantInfo
local RegisterStateDriver = RegisterStateDriver

function A:UpdateTempEnchantTime(button, timeLeft)
	if not (button == TempEnchant1 or button == TempEnchant2 or button == TempEnchant3) then return end

	if not A.db.weapons.showDuration then
		button.duration:SetText("")
	else
		local threshold = A.db.cooldown.override and A.db.cooldown.threshold or E.db.cooldown.threshold
		if not threshold then threshold = E.TimeThreshold end

		local hhmmThreshold, mmssThreshold
		if A.db.cooldown.checkSeconds then
			hhmmThreshold = A.db.cooldown.hhmmThreshold
			mmssThreshold = A.db.cooldown.mmssThreshold
		else
			hhmmThreshold = E.db.cooldown.checkSeconds and E.db.cooldown.hhmmThreshold or nil
			mmssThreshold = E.db.cooldown.checkSeconds and E.db.cooldown.mmssThreshold or nil
		end

		local textColors
		if A.db.cooldown.override then
			if A.db.cooldown.useIndicatorColor then
				textColors = E.TimeIndicatorColors.auras
			elseif E.db.cooldown.useIndicatorColor then
				textColors = E.TimeIndicatorColors
			end
		else
			textColors = E.db.cooldown.useIndicatorColor and E.TimeIndicatorColors or nil
		end

		local value, id, _, remainder = E:GetTimeInfo(timeLeft, threshold, hhmmThreshold, mmssThreshold)
		local style = E.TimeFormats[id]

		if style then
			local which = textColors and 2 or 1

			if textColors then
				button.duration:SetFormattedText(style[which], value, textColors[id], remainder)
			else
				button.duration:SetFormattedText(style[which], value, remainder)
			end
		end

		local color = A.db.cooldown.override and E.TimeColors.auras[id] or E.TimeColors[id]
		if color then
			button.duration:SetTextColor(color.r, color.g, color.b)
		end

		local fadeThreshold = E.db.auras.fadeThreshold
		if fadeThreshold == -1 then
			return
		elseif timeLeft > fadeThreshold then
			E:StopFlash(button)
		else
			E:Flash(button, 1)
		end
	end
end

function A:UpdateTempEnchantHeader()
	local db = A.db.weapons
	if InCombatLockdown() then return end

	local mainHand, _, _, offHand, _, _, thrown = GetWeaponEnchantInfo()
	local weaponIndex

	if mainHand or offHand or thrown then
		weaponIndex = (mainHand and 1 or 0) + (offHand and 1 or 0) + (thrown and 1 or 0)
	else
		weaponIndex = 1
	end

	if db.growthDirection == "RIGHT_LEFT" or db.growthDirection == "LEFT_RIGHT" then
		A.EnchantHeader:Size((db.size * weaponIndex) + (db.spacing * (weaponIndex - 1)), db.size + E.Border * 2)
	else
		A.EnchantHeader:Size(db.size + E.Border * 2, (db.size * weaponIndex) + (db.spacing * (weaponIndex - 1)))
	end
end

function A:UpdateTempEnchant()
	local db = A.db.weapons
	local font = LSM:Fetch("font", db.font)

	for i = 1, 3 do
		local button = _G["TempEnchant"..i]
		local lastButton = _G["TempEnchant"..i - 1]
		local duration = _G["TempEnchant"..i.."Duration"]

		button:Size(db.size)
		button:ClearAllPoints()
		if not db.quality then
			button:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end

		duration:ClearAllPoints()
		duration:Point("TOP", button, "BOTTOM", 1 + db.timeXOffset, 0 + db.timeYOffset)
		duration:FontTemplate(font, db.fontSize, db.fontOutline)

		if db.growthDirection == "RIGHT_LEFT" then
			if i == 1 then
				button:Point("RIGHT", A.EnchantHeader, "RIGHT", 0, 0)
			else
				button:Point("RIGHT", lastButton, "LEFT", -db.spacing, 0)
			end
		elseif db.growthDirection == "LEFT_RIGHT" then
			if i == 1 then
				button:Point("LEFT", A.EnchantHeader, "LEFT", 0, 0)
			else
				button:Point("LEFT", lastButton, "RIGHT", db.spacing, 0)
			end
		elseif db.growthDirection == "DOWN_UP" then
			if i == 1 then
				button:Point("BOTTOM", A.EnchantHeader, "BOTTOM", 0, 0)
			else
				button:Point("BOTTOM", lastButton, "TOP", 0, db.spacing)
			end
		elseif db.growthDirection == "UP_DOWN" then
			if i == 1 then
				button:Point("TOP", A.EnchantHeader, "TOP", 0, 0)
			else
				button:Point("TOP", lastButton, "BOTTOM", 0, -db.spacing)
			end
		end

		local pos, spacing, iconSize = db.barPosition, db.barSpacing, db.size - (E.Border * 2)
		local isOnTop = pos == "TOP" and true or false
		local isOnBottom = pos == "BOTTOM" and true or false
		local isOnLeft = pos == "LEFT" and true or false
		local isOnRight = pos == "RIGHT" and true or false

		button.statusBar:Width((isOnTop or isOnBottom) and iconSize or (db.barWidth + (E.PixelMode and 0 or 2)))
		button.statusBar:Height((isOnLeft or isOnRight) and iconSize or (db.barHeight + (E.PixelMode and 0 or 2)))
		button.statusBar:ClearAllPoints()
		button.statusBar:Point(E.InversePoints[pos], button, pos, (isOnTop or isOnBottom) and 0 or ((isOnLeft and -((E.PixelMode and 1 or 3) + spacing)) or ((E.PixelMode and 1 or 3) + spacing)), (isOnLeft or isOnRight) and 0 or ((isOnTop and ((E.PixelMode and 1 or 3) + spacing) or -((E.PixelMode and 1 or 3) + spacing))))
		button.statusBar:SetStatusBarTexture(LSM:Fetch("statusbar", db.barTexture))

		if isOnLeft or isOnRight then
			button.statusBar:SetOrientation("VERTICAL")
		else
			button.statusBar:SetOrientation("HORIZONTAL")
		end

		if db.barShow then
			button.statusBar:Show()
		else
			button.statusBar:Hide()
		end

		if db.colorType == "CUSTOM" then
			button.statusBar:SetStatusBarColor(db.barColor.r, db.barColor.g, db.barColor.b)
		end
	end
end

function A:UpdateTempEnchantStatusBar(...)
	local enchantIndex = 0

	for itemIndex = select("#", ...) / 3, 1, -1 do
		local hasEnchant, expiration = select(3 * (itemIndex - 1) + 1, ...)

		if hasEnchant then
			enchantIndex = enchantIndex + 1

			if expiration then
				expiration = expiration / 1000
			end

			local duration = 600
			if expiration <= 3600 and expiration > 1800 then
				duration = 3600
			elseif expiration <= 1800 and expiration > 600 then
				duration = 1800
			end

			local enchantButton = _G["TempEnchant"..enchantIndex]
			enchantButton.statusBar:SetMinMaxValues(0, duration)
			enchantButton.statusBar:SetValue(expiration)

			if A.db.weapons.colorType == "VALUE" then
				enchantButton.statusBar:SetStatusBarColor(E.oUF:ColorGradient(expiration, duration or 0, 0.8, 0, 0, 0.8, 0.8, 0, 0, 0.8, 0))
			end
		end
	end
end

function A:UpdateTempEnchantQuality()
	local db = A.db.weapons

	if not db.quality and not db.colorType == "QUALITY" then return end

	local mainHand, _, _, offHand, _, _, thrown = GetWeaponEnchantInfo()
	local mainHandQuality = GetInventoryItemQuality("player", 16)
	local offHandQuality = GetInventoryItemQuality("player", 17)
	local thrownQuality = GetInventoryItemQuality("player", 18)
	local r1, g1, b1, r2, g2, b2, r3, g3, b3

	if mainHand and mainHandQuality then r1, g1, b1 = GetItemQualityColor(mainHandQuality) end
	if offHand and offHandQuality then r2, g2, b2 = GetItemQualityColor(offHandQuality) end
	if thrown and thrownQuality then r3, g3, b3 = GetItemQualityColor(thrownQuality) end

	if mainHand and offHand and thrown then
		if db.quality then
			TempEnchant1:SetBackdropBorderColor(r3, g3, b3)
			TempEnchant2:SetBackdropBorderColor(r2, g2, b2)
			TempEnchant3:SetBackdropBorderColor(r1, g1, b1)
		end

		if db.colorType == "QUALITY" then
			TempEnchant1.statusBar:SetStatusBarColor(r3, g3, b3)
			TempEnchant2.statusBar:SetStatusBarColor(r2, g2, b2)
			TempEnchant3.statusBar:SetStatusBarColor(r1, g1, b1)
		end
	elseif mainHand and offHand and not thrown then
		if db.quality then
			TempEnchant1:SetBackdropBorderColor(r2, g2, b2)
			TempEnchant2:SetBackdropBorderColor(r1, g1, b1)
		end

		if db.colorType == "QUALITY" then
			TempEnchant1.statusBar:SetStatusBarColor(r2, g2, b2)
			TempEnchant2.statusBar:SetStatusBarColor(r1, g1, b1)
		end
	elseif mainHand and not offHand and thrown then
		if db.quality then
			TempEnchant1:SetBackdropBorderColor(r3, g3, b3)
			TempEnchant2:SetBackdropBorderColor(r1, g1, b1)
		end

		if db.colorType == "QUALITY" then
			TempEnchant1.statusBar:SetStatusBarColor(r3, g3, b3)
			TempEnchant2.statusBar:SetStatusBarColor(r1, g1, b1)
		end
	elseif not mainHand and offHand and thrown then
		if db.quality then
			TempEnchant1:SetBackdropBorderColor(r3, g3, b3)
			TempEnchant2:SetBackdropBorderColor(r2, g2, b2)
		end

		if db.colorType == "QUALITY" then
			TempEnchant1.statusBar:SetStatusBarColor(r3, g3, b3)
			TempEnchant2.statusBar:SetStatusBarColor(r2, g2, b2)
		end
	elseif mainHand and not offHand and not thrown then
		if db.quality then
			TempEnchant1:SetBackdropBorderColor(r1, g1, b1)
		end

		if db.colorType == "QUALITY" then
			TempEnchant1.statusBar:SetStatusBarColor(r1, g1, b1)
		end
	elseif not mainHand and offHand and not thrown then
		if db.quality then
			TempEnchant1:SetBackdropBorderColor(r2, g2, b2)
		end

		if db.colorType == "QUALITY" then
			TempEnchant1.statusBar:SetStatusBarColor(r2, g2, b2)
		end
	elseif not mainHand and not offHand and thrown then
		if db.quality then
			TempEnchant1:SetBackdropBorderColor(r3, g3, b3)
		end

		if db.colorType == "QUALITY" then
			TempEnchant1.statusBar:SetStatusBarColor(r3, g3, b3)
		end
	end
end

function A:InitializeTempEnchant()
	A.EnchantHeader = CreateFrame("Frame", "ElvUITemporaryEnchantFrame", E.UIParent, "SecureHandlerStateTemplate")
	A.EnchantHeader:Point("TOPRIGHT", MMHolder, "BOTTOMRIGHT", 0, -E.Border - E.Spacing)
	A.EnchantHeader:SetAttribute("_onstate-show", [[
		if newstate == "hide" then
			self:Hide()
		else
			self:Show()
		end
	]])
	RegisterStateDriver(A.EnchantHeader, "show", "[vehicleui] hide;show")

	for i = 1, 3 do
		local button = _G["TempEnchant"..i]
		local icon = _G["TempEnchant"..i.."Icon"]
		local border = _G["TempEnchant"..i.."Border"]

		button:SetTemplate()
		button:SetBackdropColor(0, 0, 0, 0)
		button.backdropTexture:SetAlpha(0)
		button:StyleButton(nil, true)
		button:SetParent(A.EnchantHeader)
		button:SetFrameLevel(4)

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside()

		border:Hide()

		button.statusBar = CreateFrame("StatusBar", "$parentStatusBar", button)
		button.statusBar:CreateBackdrop()
		button.statusBar:SetStatusBarTexture(LSM:Fetch("statusbar", self.db.barTexture))
		button.statusBar:Hide()

		E:SetSmoothing(button.statusBar)
		E:SetUpAnimGroup(button)
	end

	A:SecureHook("TemporaryEnchantFrame_Update", "UpdateTempEnchantStatusBar")
	A:SecureHook("AuraButton_UpdateDuration", "UpdateTempEnchantTime")

	A:UpdateTempEnchant()

	A.EnchantHeader:SetScript("OnEvent", function()
		A:UpdateTempEnchantHeader()
		A:UpdateTempEnchantQuality()
	end)

	A.EnchantHeader:RegisterEvent("PLAYER_REGEN_ENABLED")
	A.EnchantHeader:RegisterEvent("UNIT_INVENTORY_CHANGED")
	A.EnchantHeader:RegisterEvent("PLAYER_ENTERING_WORLD")

	E:CreateMover(A.EnchantHeader, "TempEnchantMover", L["Weapons"], nil, nil, nil, nil, nil, "auras,weapons")
end