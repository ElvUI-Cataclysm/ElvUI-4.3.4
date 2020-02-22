local E, L, V, P, G = unpack(select(2, ...))
local AB = E:GetModule("ActionBars")
local LSM = E.Libs.LSM

local _G = _G
local unpack, ipairs, pairs = unpack, ipairs, pairs
local gsub, match = string.gsub, string.match

local RegisterStateDriver = RegisterStateDriver

if E.myclass ~= "SHAMAN" then return end

local bar = CreateFrame("Frame", "ElvUI_BarTotem", E.UIParent, "SecureHandlerStateTemplate")

local SLOT_BORDER_COLORS = {
	[EARTH_TOTEM_SLOT]	= {r = 0.23, g = 0.45, b = 0.13},
	[FIRE_TOTEM_SLOT]	= {r = 0.58, g = 0.23, b = 0.10},
	[WATER_TOTEM_SLOT]	= {r = 0.19, g = 0.48, b = 0.60},
	[AIR_TOTEM_SLOT]	= {r = 0.42, g = 0.18, b = 0.74}
}

local SLOT_EMPTY_TCOORDS = {
	[EARTH_TOTEM_SLOT]	= {left = 66/128, right = 96/128, top = 3/256,   bottom = 33/256},
	[FIRE_TOTEM_SLOT]	= {left = 67/128, right = 97/128, top = 100/256, bottom = 130/256},
	[WATER_TOTEM_SLOT]	= {left = 39/128, right = 69/128, top = 209/256, bottom = 239/256},
	[AIR_TOTEM_SLOT]	= {left = 66/128, right = 96/128, top = 36/256,  bottom = 66/256}
}

local oldMultiCastRecallSpellButton_Update = MultiCastRecallSpellButton_Update
function MultiCastRecallSpellButton_Update(self)
	if InCombatLockdown() then AB.NeedRecallButtonUpdate = true AB:RegisterEvent("PLAYER_REGEN_ENABLED") return end

	oldMultiCastRecallSpellButton_Update(self)
end

function AB:MultiCastFlyoutFrameOpenButton_Show(button, type, parent)
	if type == "page" then
		button.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
	else
		local color = SLOT_BORDER_COLORS[parent:GetID()]
		button.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
	end

	button:ClearAllPoints()
	if AB.db.barTotem.flyoutDirection == "UP" then
		button:Point("BOTTOM", parent, "TOP")
		button.icon:SetRotation(0)
	elseif AB.db.barTotem.flyoutDirection == "DOWN" then
		button:Point("TOP", parent, "BOTTOM")
		button.icon:SetRotation(3.14)
	end
end

function AB:MultiCastActionButton_Update(button, _, _, slot)
	local color = SLOT_BORDER_COLORS[slot]
	if color then
		button:SetBackdropBorderColor(color.r, color.g, color.b)
	end

	if InCombatLockdown() then bar.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED") return end
	button:ClearAllPoints()
	button:SetAllPoints(button.slotButton)
end

function AB:StyleTotemSlotButton(button, slot)
	local color = SLOT_BORDER_COLORS[slot]
	if color then
		button:SetBackdropBorderColor(color.r, color.g, color.b)
	end
end

function AB:MultiCastFlyoutFrame_ToggleFlyout(frame, type, parent)
	frame.top:SetTexture(nil)
	frame.middle:SetTexture(nil)

	local size = AB.db.barTotem.buttonsize
	local flyoutDirection = AB.db.barTotem.flyoutDirection
	local flyoutSpacing = AB.db.barTotem.flyoutSpacing
	local color = SLOT_BORDER_COLORS[parent:GetID()]
	local numButtons = 0

	for i, button in ipairs(frame.buttons) do
		if not button.isSkinned then
			button:SetTemplate("Default")
			button:StyleButton()

			AB:HookScript(button, "OnEnter", "TotemOnEnter")
			AB:HookScript(button, "OnLeave", "TotemOnLeave")

			button.icon:SetDrawLayer("ARTWORK")
			button.icon:SetInside(button)

			bar.buttons[button] = true

			button.isSkinned = true
		end

		if button:IsShown() then
			numButtons = numButtons + 1

			button:Size(size)
			button:ClearAllPoints()

			if flyoutDirection == "UP" then
				if i == 1 then
					button:Point("BOTTOM", parent, "TOP", 0, flyoutSpacing)
				else
					button:Point("BOTTOM", frame.buttons[i - 1], "TOP", 0, flyoutSpacing)
				end
			elseif flyoutDirection == "DOWN" then
				if i == 1 then
					button:Point("TOP", parent, "BOTTOM", 0, -flyoutSpacing)
				else
					button:Point("TOP", frame.buttons[i - 1], "BOTTOM", 0, -flyoutSpacing)
				end
			end

			if type == "page" then
				button:SetBackdropBorderColor(unpack(E.media.bordercolor))
			else
				button:SetBackdropBorderColor(color.r, color.g, color.b)
			end

			button.icon:SetTexCoord(unpack(E.TexCoords))
		end
	end

	if type == "slot" then
		local tCoords = SLOT_EMPTY_TCOORDS[parent:GetID()]
		frame.buttons[1].icon:SetTexCoord(tCoords.left, tCoords.right, tCoords.top, tCoords.bottom)
		frame.buttons[1]:SetBackdropBorderColor(color.r, color.g, color.b)

		MultiCastFlyoutFrameCloseButton.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
	else
		frame.buttons[1]:SetBackdropBorderColor(unpack(E.media.bordercolor))

		MultiCastFlyoutFrameCloseButton.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
	end

	frame:ClearAllPoints()
	MultiCastFlyoutFrameCloseButton:ClearAllPoints()
	if flyoutDirection == "UP" then
		frame:Point("BOTTOM", parent, "TOP")

		MultiCastFlyoutFrameCloseButton:Point("TOP", frame, "TOP")
		MultiCastFlyoutFrameCloseButton.icon:SetRotation(3.14)
	elseif flyoutDirection == "DOWN" then
		frame:Point("TOP", parent, "BOTTOM")

		MultiCastFlyoutFrameCloseButton:Point("BOTTOM", frame, "BOTTOM")
		MultiCastFlyoutFrameCloseButton.icon:SetRotation(0)
	end

	frame:Height(((size + flyoutSpacing) * numButtons) + MultiCastFlyoutFrameCloseButton:GetHeight())
end

function AB:TotemOnEnter()
	if bar.mouseover then
		E:UIFrameFadeIn(bar, 0.2, bar:GetAlpha(), AB.db.barTotem.alpha)
	end
end

function AB:TotemOnLeave()
	if bar.mouseover then
		E:UIFrameFadeOut(bar, 0.2, bar:GetAlpha(), 0)
	end
end

function AB:ShowMultiCastActionBar()
	self:PositionAndSizeBarTotem()
end

function AB:PositionAndSizeBarTotem()
	if InCombatLockdown() then
		AB.NeedsPositionAndSizeBarTotem = true
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	bar.db = self.db.barTotem
	bar.mouseover = bar.db.mouseover

	local buttonSpacing = E:Scale(bar.db.buttonspacing)
	local size = E:Scale(bar.db.buttonsize)
	local numActiveSlots = MultiCastActionBarFrame.numActiveSlots
	local width, height = (size * (2 + numActiveSlots)) + (buttonSpacing * (2 + numActiveSlots - 1)), size + 2

	bar:Width(width)
	bar:Height(height)

	MultiCastActionBarFrame:Width(width)
	MultiCastActionBarFrame:Height(height)

	if bar.mouseover then
		bar:SetAlpha(0)
	else
		bar:SetAlpha(bar.db.alpha)
	end

	local visibility = bar.db.visibility
	if visibility and match(visibility, "[\n\r]") then
		visibility = gsub(visibility, "[\n\r]","")
	end

	RegisterStateDriver(bar, "visibility", visibility)

	MultiCastSummonSpellButton:ClearAllPoints()
	MultiCastSummonSpellButton:Size(size)
	MultiCastSummonSpellButton:Point("BOTTOMLEFT", E.Border*2, E.Border*2)

	for i = 1, numActiveSlots do
		local button = _G["MultiCastSlotButton"..i]
		local lastButton = _G["MultiCastSlotButton"..i - 1]

		button:ClearAllPoints()
		button:Size(size)

		if i == 1 then
			button:Point("LEFT", MultiCastSummonSpellButton, "RIGHT", buttonSpacing, 0)
		else
			button:Point("LEFT", lastButton, "RIGHT", buttonSpacing, 0)
		end
	end

	MultiCastRecallSpellButton:Size(size)
	MultiCastRecallSpellButton_Update(MultiCastRecallSpellButton)

	MultiCastFlyoutFrameCloseButton:Width(size)
	MultiCastFlyoutFrameOpenButton:Width(size)
end

function AB:UpdateTotemBindings()
	MultiCastSummonSpellButtonHotKey:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, self.db.fontOutline)
	self:FixKeybindText(MultiCastSummonSpellButton)

	MultiCastRecallSpellButtonHotKey:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, self.db.fontOutline)
	self:FixKeybindText(MultiCastRecallSpellButton)

	for i = 1, 12 do
		local button = _G["MultiCastActionButton"..i]
		local hotKey = _G["MultiCastActionButton"..i.."HotKey"]

		hotKey:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, self.db.fontOutline)
		self:FixKeybindText(button)
	end
end

function AB:CreateTotemBar()
	bar:Point("BOTTOM", E.UIParent, "BOTTOM", 0, 250)
	bar.buttons = {}

	bar.eventFrame = CreateFrame("Frame")
	bar.eventFrame:Hide()
	bar.eventFrame:SetScript("OnEvent", function(self)
		AB:PositionAndSizeBarTotem()
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end)

	MultiCastActionBarFrame:SetParent(bar)
	MultiCastActionBarFrame:ClearAllPoints()
	MultiCastActionBarFrame:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", -E.Border, -E.Border)
	MultiCastActionBarFrame:SetScript("OnUpdate", nil)
	MultiCastActionBarFrame:SetScript("OnShow", nil)
	MultiCastActionBarFrame:SetScript("OnHide", nil)
	MultiCastActionBarFrame.SetParent = E.noop
	MultiCastActionBarFrame.SetPoint = E.noop

	self:HookScript(MultiCastActionBarFrame, "OnEnter", "TotemOnEnter")
	self:HookScript(MultiCastActionBarFrame, "OnLeave", "TotemOnLeave")

	self:HookScript(MultiCastFlyoutFrame, "OnEnter", "TotemOnEnter")
	self:HookScript(MultiCastFlyoutFrame, "OnLeave", "TotemOnLeave")

	for _, frame in pairs({"MultiCastSummonSpellButton", "MultiCastRecallSpellButton"}) do
		local button = _G[frame]
		local icon = _G[frame.."Icon"]
		local highlight = _G[frame.."Highlight"]
		local normal = _G[frame.."NormalTexture"]

		button:SetTemplate()
		button:StyleButton()

		icon:SetInside(button)
		icon:SetDrawLayer("ARTWORK")
		icon:SetTexCoord(unpack(E.TexCoords))

		normal:SetTexture(nil)
		highlight:SetTexture(nil)

		bar.buttons[button] = true
	end

	hooksecurefunc(MultiCastRecallSpellButton, "SetPoint", function(self, point, attachTo, anchorPoint, xOffset, yOffset)
		if xOffset ~= AB.db.barTotem.buttonspacing then
			if InCombatLockdown() then AB.NeedRecallButtonUpdate = true AB:RegisterEvent("PLAYER_REGEN_ENABLED") return end

			self:SetPoint(point, attachTo, anchorPoint, AB.db.barTotem.buttonspacing, yOffset)
		end
	end)

	for _, frame in pairs({"MultiCastFlyoutFrameOpenButton", "MultiCastFlyoutFrameCloseButton"}) do
		local button = _G[frame]

		button:CreateBackdrop("Default", true, true)
		button.backdrop:Point("TOPLEFT", 0, -(E.Border + E.Spacing))
		button.backdrop:Point("BOTTOMRIGHT", 0, E.Border + E.Spacing)

		button.icon = button:CreateTexture(nil, "ARTWORK")
		button.icon:Size(16)
		button.icon:SetPoint("CENTER")
		button.icon:SetTexture(E.Media.Textures.ArrowUp)

		button.normalTexture:SetTexture("")
		button:StyleButton()
		button.hover:SetInside(button.backdrop)
		button.pushed:SetInside(button.backdrop)

		bar.buttons[button] = true
	end

	for i = 1, 4 do
		local button = _G["MultiCastSlotButton"..i]

		button:StyleButton()
		button:SetTemplate("Default")
		button.ignoreUpdates = true

		button.background:SetTexCoord(unpack(E.TexCoords))
		button.background:SetDrawLayer("ARTWORK")
		button.background:SetInside(button)

		button.overlayTex:SetTexture(nil)

		bar.buttons[button] = true
	end

	for i = 1, 12 do
		local button = _G["MultiCastActionButton"..i]
		local normal = _G["MultiCastActionButton"..i.."NormalTexture"]

		button:StyleButton()

		button.icon:SetTexCoord(unpack(E.TexCoords))
		button.icon:SetDrawLayer("ARTWORK")
		button.icon:SetInside()

		button.overlayTex:SetTexture(nil)
		normal:SetTexture(nil)

		--E:RegisterCooldown(button.cooldown)

		bar.buttons[button] = true
	end

	for button in pairs(bar.buttons) do
		button:HookScript("OnEnter", AB.TotemOnEnter)
		button:HookScript("OnLeave", AB.TotemOnLeave)
	end

	AB:UpdateTotemBindings()

	self:SecureHook("MultiCastFlyoutFrameOpenButton_Show")
	self:SecureHook("MultiCastActionButton_Update")
	self:SecureHook("MultiCastSlotButton_Update", "StyleTotemSlotButton")
	self:SecureHook("MultiCastFlyoutFrame_ToggleFlyout")
	self:SecureHook("ShowMultiCastActionBar")

	E:CreateMover(bar, "ElvBar_Totem", TUTORIAL_TITLE47, nil, nil, nil, "ALL,ACTIONBARS", nil, "actionbar,barTotem")
end