﻿local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local type, ipairs, tonumber = type, ipairs, tonumber
local floor = math.floor

local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
local InCombatLockdown = InCombatLockdown
local RESET = RESET

local grid

E.ConfigModeLayouts = {
	"ALL",
	"GENERAL",
	"SOLO",
	"PARTY",
	"ARENA",
	"RAID",
	"ACTIONBARS"
}

E.ConfigModeLocalizedStrings = {
	ALL = ALL,
	GENERAL = GENERAL,
	SOLO = SOLO,
	PARTY = PARTY,
	ARENA = ARENA,
	RAID = RAID,
	ACTIONBARS = ACTIONBARS_LABEL
}

function E:Grid_Show()
	if not grid then
		E:Grid_Create()
	elseif grid.boxSize ~= E.db.gridSize then
		grid:Hide()
		E:Grid_Create()
	else
		grid:Show()
	end
end

function E:Grid_Hide()
	if grid then
		grid:Hide()
	end
end

function E:ToggleMoveMode(which)
	if InCombatLockdown() then return end
	local mode = not E.ConfigurationMode

	if not which or which == "" then
		E.ConfigurationMode = mode
		which = "ALL"
	else
		mode = true
		which = strupper(which)
	end

	self:ToggleMovers(mode, which)
	if mode then
		E:Grid_Show()
		ElvUIGrid:SetAlpha(0.4)

		if not ElvUIMoverPopupWindow then
			E:CreateMoverPopup()
		end

		ElvUIMoverPopupWindow:Show()
		UIDropDownMenu_SetSelectedValue(ElvUIMoverPopupWindowDropDown, which)

		if IsAddOnLoaded("ElvUI_OptionsUI") then
			E:Config_CloseWindow()
		end
	else
		E:Grid_Hide()
		ElvUIGrid:SetAlpha(1)

		if ElvUIMoverPopupWindow then
			ElvUIMoverPopupWindow:Hide()
		end
	end
end

function E:Grid_GetRegion()
	if grid then
		if grid.regionCount and grid.regionCount > 0 then
			local line = select(grid.regionCount, grid:GetRegions())

			grid.regionCount = grid.regionCount - 1
			line:SetAlpha(1)

			return line
		else
			return grid:CreateTexture()
		end
	end
end

function E:Grid_Create()
	if not grid then
		grid = CreateFrame("Frame", "ElvUIGrid", E.UIParent)
		grid:SetFrameStrata("BACKGROUND")
	else
		grid.regionCount = 0
		local numRegions = grid:GetNumRegions()
		for i = 1, numRegions do
			local region = select(i, grid:GetRegions())
			if region and region.IsObjectType and region:IsObjectType("Texture") then
				grid.regionCount = grid.regionCount + 1
				region:SetAlpha(0)
			end
		end
	end

	local size = E.mult
	local width, height = E.UIParent:GetSize()

	local ratio = width / height
	local hStepheight = height * ratio
	local wStep = width / E.db.gridSize
	local hStep = hStepheight / E.db.gridSize

	grid.boxSize = E.db.gridSize
	grid:Point("CENTER", E.UIParent)
	grid:Size(width, height)
	grid:Show()

	for i = 0, E.db.gridSize do
		local tx = E:Grid_GetRegion()
		if i == E.db.gridSize / 2 then
			tx:SetTexture(1, 0, 0)
			tx:SetDrawLayer("BACKGROUND", 1)
		else
			tx:SetTexture(0, 0, 0)
			tx:SetDrawLayer("BACKGROUND", 0)
		end
		tx:ClearAllPoints()
		tx:Point("TOPLEFT", grid, "TOPLEFT", i * wStep - (size / 2), 0)
		tx:Point("BOTTOMRIGHT", grid, "BOTTOMLEFT", i * wStep + (size / 2), 0)
	end

	do
		local tx = E:Grid_GetRegion()
		tx:SetTexture(1, 0, 0)
		tx:SetDrawLayer("BACKGROUND", 1)
		tx:ClearAllPoints()
		tx:Point("TOPLEFT", grid, "TOPLEFT", 0, -(height / 2) + (size / 2))
		tx:Point("BOTTOMRIGHT", grid, "TOPRIGHT", 0, -(height / 2 + size / 2))
	end

	for i = 1, floor((height / 2) / hStep) do
		local tx = E:Grid_GetRegion()
		tx:SetTexture(0, 0, 0)
		tx:SetDrawLayer("BACKGROUND", 0)
		tx:ClearAllPoints()
		tx:Point("TOPLEFT", grid, "TOPLEFT", 0, -(height / 2 + i * hStep) + (size / 2))
		tx:Point("BOTTOMRIGHT", grid, "TOPRIGHT", 0, -(height / 2 + i * hStep + size / 2))

		tx = E:Grid_GetRegion()
		tx:SetTexture(0, 0, 0)
		tx:SetDrawLayer("BACKGROUND", 0)
		tx:ClearAllPoints()
		tx:Point("TOPLEFT", grid, "TOPLEFT", 0, -(height/ 2 - i * hStep) + (size / 2))
		tx:Point("BOTTOMRIGHT", grid, "TOPRIGHT", 0, -(height / 2 - i * hStep + size / 2))
	end
end

local function ConfigMode_OnClick(self)
	E:ToggleMoveMode(self.value)
end

local function ConfigMode_Initialize()
	local info = UIDropDownMenu_CreateInfo()
	info.func = ConfigMode_OnClick

	for _, configMode in ipairs(E.ConfigModeLayouts) do
		info.text = E.ConfigModeLocalizedStrings[configMode]
		info.value = configMode
		UIDropDownMenu_AddButton(info)
	end

	local dd = ElvUIMoverPopupWindowDropDown
	UIDropDownMenu_SetSelectedValue(dd, dd.selectedValue or "ALL")
end

function E:MoverNudgeOnShow()
	self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
end

function E:NudgeMover(nudgeX, nudgeY)
	local mover = ElvUIMoverNudgeWindow.child
	if not mover then return end

	local x, y, point = E:CalculateMoverPoints(mover, nudgeX, nudgeY)

	mover:ClearAllPoints()
	mover:Point(point, E.UIParent, point, x, y)
	E:SaveMoverPosition(mover.name)

	--Update coordinates in Nudge Window
	E:UpdateNudgeFrame(mover, x, y)
end

function E:UpdateNudgeFrame(mover, x, y)
	if not (x and y) then
		x, y = E:CalculateMoverPoints(mover)
	end

	x = E:Round(x)
	y = E:Round(y)

	local ElvUIMoverNudgeWindow = ElvUIMoverNudgeWindow
	ElvUIMoverNudgeWindow.xOffset:SetText(x)
	ElvUIMoverNudgeWindow.yOffset:SetText(y)
	ElvUIMoverNudgeWindow.xOffset.currentValue = x
	ElvUIMoverNudgeWindow.yOffset.currentValue = y
	ElvUIMoverNudgeWindow.title:SetText(mover.textString)
end

function E:AssignFrameToNudge()
	ElvUIMoverNudgeWindow.child = self
	E:UpdateNudgeFrame(self)
end

function E:CreateMoverPopup()
	local f = CreateFrame("Frame", "ElvUIMoverPopupWindow", UIParent)
	f:SetFrameStrata("DIALOG")
	f:SetToplevel(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:SetFrameLevel(99)
	f:SetClampedToScreen(true)
	f:Size(360, 195)
	f:SetTemplate("Transparent")
	f:Point("BOTTOM", UIParent, "CENTER", 0, 100)
	f:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
	f:SetScript("OnShow", E.MoverNudgeOnShow)
	f:CreateShadow(5)
	f:Hide()

	local header = CreateFrame("Button", nil, f)
	header:SetTemplate(nil, true)
	header:Size(100, 25)
	header:Point("CENTER", f, "TOP")
	header:SetFrameLevel(header:GetFrameLevel() + 2)
	header:EnableMouse(true)
	header:RegisterForClicks("AnyUp", "AnyDown")
	header:SetScript("OnMouseDown", function() f:StartMoving() end)
	header:SetScript("OnMouseUp", function() f:StopMovingOrSizing() end)
	header:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
	header:SetScript("OnShow", E.MoverNudgeOnShow)

	local title = header:CreateFontString("OVERLAY")
	title:FontTemplate()
	title:Point("CENTER", header, "CENTER")
	title:SetText("ElvUI")

	local desc = f:CreateFontString("ARTWORK")
	desc:SetFontObject("GameFontHighlight")
	desc:SetJustifyV("TOP")
	desc:SetJustifyH("LEFT")
	desc:Point("TOPLEFT", 18, -32)
	desc:Point("BOTTOMRIGHT", -18, 48)
	desc:SetText(L["DESC_MOVERCONFIG"])

	local snapping = CreateFrame("CheckButton", f:GetName().."CheckButton", f, "OptionsCheckButtonTemplate")
	_G[snapping:GetName().."Text"]:SetText(L["Sticky Frames"])

	snapping:SetScript("OnShow", function(cb) cb:SetChecked(E.db.general.stickyFrames) end)
	snapping:SetScript("OnClick", function(cb) E.db.general.stickyFrames = cb:GetChecked() end)

	local lock = CreateFrame("Button", f:GetName().."CloseButton", f, "OptionsButtonTemplate")
	_G[lock:GetName().."Text"]:SetText(L["Lock"])

	lock:SetScript("OnClick", function()
		E:ToggleMoveMode()

		if E.ConfigurationToggled then
			E.ConfigurationToggled = nil

			if IsAddOnLoaded("ElvUI_OptionsUI") then
				E:Config_OpenWindow()
			end
		end
	end)

	local align = CreateFrame("EditBox", f:GetName().."EditBox", f, "InputBoxTemplate")
	align:Size(24, 17)
	align:SetAutoFocus(false)
	align:SetScript("OnEscapePressed", function(eb)
		eb:SetText(E.db.gridSize)
		EditBox_ClearFocus(eb)
	end)
	align:SetScript("OnEnterPressed", function(eb)
		local text = eb:GetText()
		if tonumber(text) then
			if tonumber(text) <= 256 and tonumber(text) >= 4 then
				E.db.gridSize = tonumber(text)
			else
				eb:SetText(E.db.gridSize)
			end
		else
			eb:SetText(E.db.gridSize)
		end
		E:Grid_Show()
		EditBox_ClearFocus(eb)
	end)
	align:SetScript("OnEditFocusLost", function(eb)
		eb:SetText(E.db.gridSize)
	end)
	align:SetScript("OnEditFocusGained", align.HighlightText)
	align:SetScript("OnShow", function(eb)
		EditBox_ClearFocus(eb)
		eb:SetText(E.db.gridSize)
	end)

	align.text = align:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	align.text:Point("RIGHT", align, "LEFT", -4, 0)
	align.text:SetText(L["Grid Size:"])

	--position buttons
	snapping:Point("BOTTOMLEFT", 14, 10)
	lock:Point("BOTTOMRIGHT", -14, 14)
	align:Point("TOPRIGHT", lock, "TOPLEFT", -4, -2)

	S:HandleCheckBox(snapping)
	S:HandleButton(lock)
	S:HandleEditBox(align)

	f:RegisterEvent("PLAYER_REGEN_DISABLED")
	f:SetScript("OnEvent", function(mover)
		if mover:IsShown() then
			mover:Hide()
			E:Grid_Hide()
			E:ToggleMoveMode()
		end
	end)

	local configMode = CreateFrame("Frame", f:GetName().."DropDown", f, "UIDropDownMenuTemplate")
	configMode:Point("BOTTOMRIGHT", lock, "TOPRIGHT", 8, -5)
	S:HandleDropDownBox(configMode, 148)
	configMode.text = configMode:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	configMode.text:Point("RIGHT", configMode.backdrop, "LEFT", -2, 0)
	configMode.text:SetText(L["Config Mode:"])

	UIDropDownMenu_Initialize(configMode, ConfigMode_Initialize)

	local nudgeFrame = CreateFrame("Frame", "ElvUIMoverNudgeWindow", E.UIParent)
	nudgeFrame:SetFrameStrata("DIALOG")
	nudgeFrame:Size(200, 110)
	nudgeFrame:SetTemplate("Transparent")
	nudgeFrame:CreateShadow(5)
	nudgeFrame:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
	nudgeFrame:SetFrameLevel(100)
	nudgeFrame:EnableMouse(true)
	nudgeFrame:SetClampedToScreen(true)
	nudgeFrame:SetScript("OnShow", E.MoverNudgeOnShow)
	nudgeFrame:SetScript("OnKeyDown", function(_, btn)
		local Mod = IsAltKeyDown() or IsControlKeyDown()
		if btn == "NUMPAD4" then
			E:NudgeMover(-1 * (Mod and 10 or 1))
		elseif btn == "NUMPAD6" then
			E:NudgeMover(1 * (Mod and 10 or 1))
		elseif btn == "NUMPAD8" then
			E:NudgeMover(nil, 1 * (Mod and 10 or 1))
		elseif btn == "NUMPAD2" then
			E:NudgeMover(nil, -1 * (Mod and 10 or 1))
		end
	end)

	ElvUIMoverPopupWindow:HookScript("OnHide", function() ElvUIMoverNudgeWindow:Hide() end)

	desc = nudgeFrame:CreateFontString("ARTWORK")
	desc:SetFontObject("GameFontHighlight")
	desc:SetJustifyV("TOP")
	desc:SetJustifyH("LEFT")
	desc:Point("TOPLEFT", 18, -15)
	desc:Point("BOTTOMRIGHT", -18, 28)
	desc:SetJustifyH("CENTER")
	nudgeFrame.title = desc

	header = CreateFrame("Button", nil, nudgeFrame)
	header:SetTemplate(nil, true)
	header:Size(100, 25)
	header:Point("CENTER", nudgeFrame, "TOP")
	header:SetFrameLevel(header:GetFrameLevel() + 2)
	header:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
	header:SetScript("OnShow", E.MoverNudgeOnShow)

	title = header:CreateFontString("OVERLAY")
	title:FontTemplate()
	title:Point("CENTER", header, "CENTER")
	title:SetText(L["Nudge"])

	local xOffset = CreateFrame("EditBox", nudgeFrame:GetName().."XEditBox", nudgeFrame, "InputBoxTemplate")
	xOffset:Size(50, 17)
	xOffset:SetAutoFocus(false)
	xOffset.currentValue = 0
	xOffset:SetScript("OnEscapePressed", function(eb)
		eb:SetText(E:Round(xOffset.currentValue))
		EditBox_ClearFocus(eb)
	end)
	xOffset:SetScript("OnEnterPressed", function(eb)
		local num = eb:GetText()
		if tonumber(num) then
			local diff = num - xOffset.currentValue
			xOffset.currentValue = num
			E:NudgeMover(diff)
		end

		eb:SetText(E:Round(xOffset.currentValue))
		EditBox_ClearFocus(eb)
	end)
	xOffset:SetScript("OnEditFocusLost", function(eb)
		eb:SetText(E:Round(xOffset.currentValue))
	end)
	xOffset:SetScript("OnEditFocusGained", xOffset.HighlightText)
	xOffset:SetScript("OnShow", function(eb)
		EditBox_ClearFocus(eb)
		eb:SetText(E:Round(xOffset.currentValue))
	end)

	xOffset.text = xOffset:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	xOffset.text:Point("RIGHT", xOffset, "LEFT", -4, 0)
	xOffset.text:SetText("X:")
	xOffset:Point("BOTTOMRIGHT", nudgeFrame, "CENTER", -6, 8)
	nudgeFrame.xOffset = xOffset
	S:HandleEditBox(xOffset)

	local yOffset = CreateFrame("EditBox", nudgeFrame:GetName().."YEditBox", nudgeFrame, "InputBoxTemplate")
	yOffset:Size(50, 17)
	yOffset:SetAutoFocus(false)
	yOffset.currentValue = 0
	yOffset:SetScript("OnEscapePressed", function(eb)
		eb:SetText(E:Round(yOffset.currentValue))
		EditBox_ClearFocus(eb)
	end)
	yOffset:SetScript("OnEnterPressed", function(eb)
		local num = eb:GetText()
		if tonumber(num) then
			local diff = num - yOffset.currentValue
			yOffset.currentValue = num
			E:NudgeMover(nil, diff)
		end

		eb:SetText(E:Round(yOffset.currentValue))
		EditBox_ClearFocus(eb)
	end)
	yOffset:SetScript("OnEditFocusLost", function(eb)
		eb:SetText(E:Round(yOffset.currentValue))
	end)
	yOffset:SetScript("OnEditFocusGained", yOffset.HighlightText)
	yOffset:SetScript("OnShow", function(eb)
		EditBox_ClearFocus(eb)
		eb:SetText(E:Round(yOffset.currentValue))
	end)

	yOffset.text = yOffset:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	yOffset.text:Point("RIGHT", yOffset, "LEFT", -4, 0)
	yOffset.text:SetText("Y:")
	yOffset:Point("BOTTOMLEFT", nudgeFrame, "CENTER", 16, 8)
	nudgeFrame.yOffset = yOffset
	S:HandleEditBox(yOffset)

	local resetButton = CreateFrame("Button", nudgeFrame:GetName().."ResetButton", nudgeFrame, "UIPanelButtonTemplate")
	resetButton:SetText(RESET)
	resetButton:Point("TOP", nudgeFrame, "CENTER", 0, 2)
	resetButton:Size(100, 25)
	resetButton:SetScript("OnClick", function()
		if ElvUIMoverNudgeWindow.child and ElvUIMoverNudgeWindow.child.textString then
			E:ResetMovers(ElvUIMoverNudgeWindow.child.textString)
		end
	end)
	S:HandleButton(resetButton)

	local upButton = CreateFrame("Button", nudgeFrame:GetName().."UpButton", nudgeFrame)
	upButton:Point("BOTTOMRIGHT", nudgeFrame, "BOTTOM", -6, 4)
	upButton:SetScript("OnClick", function() E:NudgeMover(nil, 1) end)
	S:HandleNextPrevButton(upButton)
	upButton:Size(22)

	local downButton = CreateFrame("Button", nudgeFrame:GetName().."DownButton", nudgeFrame)
	downButton:Point("BOTTOMLEFT", nudgeFrame, "BOTTOM", 6, 4)
	downButton:SetScript("OnClick", function() E:NudgeMover(nil, -1) end)
	S:HandleNextPrevButton(downButton)
	downButton:Size(22)

	local leftButton = CreateFrame("Button", nudgeFrame:GetName().."LeftButton", nudgeFrame)
	leftButton:Point("RIGHT", upButton, "LEFT", -6, 0)
	leftButton:SetScript("OnClick", function() E:NudgeMover(-1) end)
	S:HandleNextPrevButton(leftButton)
	leftButton:Size(22)

	local rightButton = CreateFrame("Button", nudgeFrame:GetName().."RightButton", nudgeFrame)
	rightButton:Point("LEFT", downButton, "RIGHT", 6, 0)
	rightButton:SetScript("OnClick", function() E:NudgeMover(1) end)
	S:HandleNextPrevButton(rightButton)
	rightButton:Size(22)
end

function E:Config_ResetSettings()
	E.configSavedPositionTop, E.configSavedPositionLeft = nil, nil
	E.global.general.AceGUI = E:CopyTable({}, E.DF.global.general.AceGUI)
end

function E:Config_GetPosition()
	return E.configSavedPositionTop, E.configSavedPositionLeft
end

function E:Config_GetSize()
	return E.global.general.AceGUI.width, E.global.general.AceGUI.height
end

function E:Config_UpdateSize(reset)
	local frame = E:Config_GetWindow()
	if not frame then return end

	local maxWidth, maxHeight = self.UIParent:GetSize()
	frame:SetMinResize(850, 653)
	frame:SetMaxResize(maxWidth - 50, maxHeight - 50)

	self.Libs.AceConfigDialog:SetDefaultSize(E.name, E:Config_GetDefaultSize())

	local status = frame.obj and frame.obj.status
	if status then
		if reset then
			E:Config_ResetSettings()

			status.top, status.left = E:Config_GetPosition()
			status.width, status.height = E:Config_GetDefaultSize()

			frame.obj:ApplyStatus()
		else
			local top, left = E:Config_GetPosition()
			if top and left then
				status.top, status.left = top, left

				frame.obj:ApplyStatus()
			end
		end

		E:Config_UpdateLeftScroller(frame)
	end
end

function E:Config_GetDefaultSize()
	local width, height = E:Config_GetSize()
	local maxWidth, maxHeight = E.UIParent:GetSize()

	width, height = min(maxWidth - 50, width), min(maxHeight - 50, height)

	return width, height
end

function E:Config_StopMoving()
	local frame = self and self.GetParent and self:GetParent()

	if frame and frame.obj and frame.obj.status then
		E.configSavedPositionTop, E.configSavedPositionLeft = E:Round(frame:GetTop(), 2), E:Round(frame:GetLeft(), 2)
		E.global.general.AceGUI.width, E.global.general.AceGUI.height = E:Round(frame:GetWidth(), 2), E:Round(frame:GetHeight(), 2)
		E:Config_UpdateLeftScroller(frame)
	end
end

local function Config_ButtonOnEnter(self)
	if not self.desc then return end

	GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 2)
	GameTooltip:AddLine(self.desc, 1, 1, 1, true)
	GameTooltip:Show()
end

local function Config_ButtonOnLeave()
	GameTooltip:Hide()
end

local function Config_StripNameColor(name)
	if type(name) == "function" then name = name() end

	return E:StripString(name)
end

local function Config_SortButtons(a,b)
	local A1, B1 = a[1], b[1]

	if A1 and B1 then
		if A1 == B1 then
			local A3, B3 = a[3], b[3]
			if A3 and B3 and (A3.name and B3.name) then
				return Config_StripNameColor(A3.name) < Config_StripNameColor(B3.name)
			end
		end

		return A1 < B1
	end
end

local function ConfigSliderOnMouseWheel(self, offset)
	local _, maxValue = self:GetMinMaxValues()
	if maxValue == 0 then return end

	local newValue = self:GetValue() - offset
	if newValue < 0 then newValue = 0 end
	if newValue > maxValue then return end

	self:SetValue(newValue)
	self.buttons:Point("TOPLEFT", 0, newValue * 36)
end

local function ConfigSliderOnValueChanged(self, value)
	self:SetValue(value)
	self.buttons:Point("TOPLEFT", 0, value * 36)
end

function E:Config_SetButtonText(btn, noColor)
	local name = btn.info.name
	if type(name) == "function" then name = name() end

	if noColor then
		btn:SetText(name:gsub("|c[fF][fF]%x%x%x%x%x%x",""):gsub("|r",""))
	else
		btn:SetText(name)
	end
end

function E:Config_CreateSeparatorLine(frame, lastButton)
	local line = frame.leftHolder.buttons:CreateTexture()
	line:SetTexture(E.Media.Textures.White8x8)
	line:SetVertexColor(1, 0.82, 0, 0.4)
	line:Size(179, 2)
	line:Point("TOP", lastButton, "BOTTOM", 0, -6)
	line.separator = true

	return line
end

function E:Config_SetButtonColor(btn, disabled)
	if disabled then
		btn:Disable()
		btn:SetBackdropBorderColor(1, 0.82, 0)
		if btn.backdropTexture then
			btn.backdropTexture:SetVertexColor(1, 0.82, 0, 0.4)
		end
		btn:GetFontString():SetTextColor(1, 1, 1)
		E:Config_SetButtonText(btn, true)
	else
		btn:Enable()
		local r, g, b = unpack(E.media.bordercolor)
		btn:SetBackdropBorderColor(r, g, b)
		r, g, b = unpack(E.media.backdropcolor)
		if btn.backdropTexture then
			btn.backdropTexture:SetVertexColor(r, g, b, 1)
		end
		btn:GetFontString():SetTextColor(1, 0.82, 0)
		E:Config_SetButtonText(btn)
	end
end

function E:Config_UpdateSliderPosition(btn)
	local left = btn and btn.frame and btn.frame.leftHolder

	if left and left.slider then
		ConfigSliderOnValueChanged(left.slider, btn.sliderValue or 0)
	end
end

function E:Config_CreateButton(info, frame, unskinned, ...)
	local btn = CreateFrame(...)
	btn.frame = frame
	btn.desc = info.desc
	btn.info = info

	if not unskinned then
		E.Skins:HandleButton(btn)
	end

	E:Config_SetButtonText(btn)
	E:Config_SetButtonColor(btn, btn.info.key == "general")
	btn:HookScript("OnEnter", Config_ButtonOnEnter)
	btn:HookScript("OnLeave", Config_ButtonOnLeave)
	btn:SetScript("OnClick", info.func)

	return btn
end

function E:Config_UpdateLeftButtons()
	local frame = E:Config_GetWindow()
	if not (frame and frame.leftHolder) then return end

	local status = frame.obj.status
	local selected = status and status.groups.selected
	for _, btn in ipairs(frame.leftHolder.buttons) do
		if type(btn) == "table" and btn.IsObjectType and btn:IsObjectType("Button") then
			local enabled = btn.info.key == selected
			E:Config_SetButtonColor(btn, enabled)

			if enabled then
				E:Config_UpdateSliderPosition(btn)
			end
		end
	end
end

function E:Config_UpdateLeftScroller(frame)
	local left = frame and frame.leftHolder
	if not left then return end

	local btns = left.buttons
	local bottom = btns:GetBottom()
	if not bottom then return end

	btns:Point("TOPLEFT", 0, 0)

	local max = 0
	for _, btn in ipairs(btns) do
		local button = type(btn) == "table" and btn.IsObjectType and btn:IsObjectType("Button")
		if button then
			btn.sliderValue = nil

			local btm = btn:GetBottom()
			if btm then
				if bottom > btm then
					max = max + 1
					btn.sliderValue = max
				end
			end
		end
	end

	local slider = left.slider
	slider:SetMinMaxValues(0, max)
	slider:SetValue(0)

	if max == 0 then
		slider.thumb:Hide()
	else
		slider.thumb:Show()
	end
end

function E:Config_SaveOldPosition(frame)
	if frame.GetNumPoints and not frame.oldPosition then
		frame.oldPosition = {}
		for i = 1, frame:GetNumPoints() do
			tinsert(frame.oldPosition, {frame:GetPoint(i)})
		end
	end
end

function E:Config_RestoreOldPosition(frame)
	local position = frame.oldPosition

	if position then
		frame:ClearAllPoints()
		for i = 1, #position do
			frame:Point(unpack(position[i]))
		end
	end
end

function E:Config_CreateLeftButtons(frame, unskinned, options)
	local opts = {}
	for key, info in pairs(options) do
		if (not info.order or info.order < 6) and not tContains(E.OriginalOptions, key) then
			info.order = 6
		end
		if key == "profiles" then
			info.desc = nil
		end
		tinsert(opts, {info.order, key, info})
	end
	sort(opts, Config_SortButtons)

	local buttons, last, order = frame.leftHolder.buttons
	for index, opt in ipairs(opts) do
		local info = opt[3]
		local key = opt[2]

		if (order == 2 or order == 5) and order < opt[1] then
			last = E:Config_CreateSeparatorLine(frame, last)
		end

		order = opt[1]
		info.key = key
		info.func = function()
			local ACD = E.Libs.AceConfigDialog
			if ACD then ACD:SelectGroup("ElvUI", key) end
		end

		local btn = E:Config_CreateButton(info, frame, unskinned, "Button", nil, buttons, "UIPanelButtonTemplate")
		btn:Size(170, 22)

		if not last then
			btn:Point("TOP", buttons, "TOP", 0, 0)
		else
			btn:Point("TOP", last, "BOTTOM", 0, (last.separator and -6) or -4)
		end

		buttons[index] = btn
		last = btn
	end
end

function E:Config_CloseClicked()
	if self.originalClose then
		self.originalClose:Click()
	end
end

function E:Config_CloseWindow()
	local ACD = E.Libs.AceConfigDialog

	if ACD then
		ACD:Close("ElvUI")
	end

	GameTooltip:Hide()
end

function E:Config_OpenWindow()
	local ACD = E.Libs.AceConfigDialog

	if ACD then
		ACD:Open("ElvUI")

		local frame = E:Config_GetWindow()
		if frame then
			E:Config_WindowOpened(frame)
		end
	end

	GameTooltip:Hide()
end

function E:Config_GetWindow()
	local ACD = E.Libs.AceConfigDialog
	local ConfigOpen = ACD and ACD.OpenFrames and ACD.OpenFrames[E.name]

	return ConfigOpen and ConfigOpen.frame
end

function E:Config_WindowClosed()
	if not self.bottomHolder then return end

	local frame = E:Config_GetWindow()
	if not frame or frame ~= self then
		self.bottomHolder:Hide()
		self.leftHolder:Hide()
		self.topHolder:Hide()
		self.leftHolder.slider:Hide()
		self.closeButton:Hide()
		self.originalClose:Show()

		E:StopElasticize(self.leftHolder.logo)

		E:Config_RestoreOldPosition(self.topHolder.version)
		E:Config_RestoreOldPosition(self.obj.content)
		E:Config_RestoreOldPosition(self.obj.titlebg)
	end
end

function E:Config_WindowOpened(frame)
	if frame and frame.bottomHolder then
		frame.bottomHolder:Show()
		frame.leftHolder:Show()
		frame.topHolder:Show()
		frame.leftHolder.slider:Show()
		frame.closeButton:Show()
		frame.originalClose:Hide()

		E:Elasticize(frame.leftHolder.logo, 128, 64)

		local unskinned = not E.private.skins.ace3.enable
		local offset = unskinned and 14 or 8
		local version = frame.topHolder.version
		E:Config_SaveOldPosition(version)
		version:ClearAllPoints()
		version:Point("LEFT", frame.topHolder, "LEFT", unskinned and 8 or 6, unskinned and -4 or 0)

		local holderHeight = frame.bottomHolder:GetHeight()
		local content = frame.obj.content
		E:Config_SaveOldPosition(content)
		content:ClearAllPoints()
		content:Point("TOPLEFT", frame, "TOPLEFT", offset, -(unskinned and 50 or 40))
		content:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -offset, holderHeight + 3)

		local titlebg = frame.obj.titlebg
		E:Config_SaveOldPosition(titlebg)
		titlebg:ClearAllPoints()
		titlebg:SetPoint("TOPLEFT", frame, unskinned and 22 or 0, 0)
		titlebg:SetPoint("TOPRIGHT", frame, unskinned and -26 or 0, 0)
	end
end

function E:Config_CreateBottomButtons(frame, unskinned)
	local Loc = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale or "enUS")
	local last

	for _, info in ipairs({
		{
			var = "ToggleAnchors",
			name = Loc["Toggle Anchors"],
			desc = Loc["Unlock various elements of the UI to be repositioned."],
			func = function()
				E:ToggleMoveMode()
				E.ConfigurationToggled = true
			end
		},
		{
			var = "ResetAnchors",
			name = Loc["Reset Anchors"],
			desc = Loc["Reset all frames to their original positions."],
			func = function() E:ResetUI() end
		},
		{
			var = "RepositionWindow",
			name = Loc["Reposition Window"],
			desc = Loc["Reset the size and position of this frame."],
			func = function() E:Config_UpdateSize(true) end
		},
		{
			var = "Install",
			name = Loc["Install"],
			desc = Loc["Run the installation process."],
			func = function()
				E:Install()
				E:ToggleOptionsUI()
			end
		},
		{
			var = "ToggleTutorials",
			name = Loc["Toggle Tutorials"],
			func = function()
				E:Tutorials(true)
				E:ToggleOptionsUI()
			end
		},
		{
			var = "ShowStatusReport",
			name = Loc["ElvUI Status"],
			desc = Loc["Shows a frame with needed info for support."],
			func = function()
				E:ShowStatusReport()
				E:ToggleOptionsUI()
				E.StatusReportToggled = true
			end
		}
	}) do
		local btn = E:Config_CreateButton(info, frame, unskinned, "Button", nil, frame.bottomHolder, "UIPanelButtonTemplate")
		local offset = unskinned and 14 or 8

		btn:Size(btn:GetTextWidth() + 60, 22)

		if not last then
			btn:Point("BOTTOMLEFT", frame.bottomHolder, "BOTTOMLEFT", unskinned and 24 or offset, offset)
			last = btn
		else
			btn:Point("LEFT", last, "RIGHT", 4, 0)
			last = btn
		end

		frame.bottomHolder[info.var] = btn
	end
end

local pageNodes = {}
function E:Config_GetToggleMode(frame, msg)
	local pages, msgStr
	if msg and msg ~= "" then
		pages = {strsplit(",", msg)}
		msgStr = gsub(msg, ",", "\001")
	end

	local empty = pages ~= nil
	if not frame or empty then
		if empty then
			local ACD = E.Libs.AceConfigDialog
			local pageCount, index, mainSel = #pages
			if pageCount > 1 then
				wipe(pageNodes)
				index = 0

				local main, mainNode, mainSelStr, sub, subNode, subSel
				for i = 1, pageCount do
					if i == 1 then
						main = pages[i] and ACD and ACD.Status and ACD.Status.ElvUI
						mainSel = main and main.status and main.status.groups and main.status.groups.selected
						mainSelStr = mainSel and ("^"..E:EscapeString(mainSel).."\001")
						mainNode = main and main.children and main.children[pages[i]]
						pageNodes[index + 1], pageNodes[index + 2] = main, mainNode
					else
						sub = pages[i] and pageNodes[i] and ((i == pageCount and pageNodes[i]) or pageNodes[i].children[pages[i]])
						subSel = sub and sub.status and sub.status.groups and sub.status.groups.selected
						subNode = (mainSelStr and msgStr:match(mainSelStr..E:EscapeString(pages[i]).."$") and (subSel and subSel == pages[i])) or ((i == pageCount and not subSel) and mainSel and mainSel == msgStr)
						pageNodes[index + 1], pageNodes[index + 2] = sub, subNode
					end
					index = index + 2
				end
			else
				local main = pages[1] and ACD and ACD.Status and ACD.Status.ElvUI
				mainSel = main and main.status and main.status.groups and main.status.groups.selected
			end

			if frame and ((not index and mainSel and mainSel == msg) or (index and pageNodes and pageNodes[index])) then
				return "Close"
			else
				return "Open", pages
			end
		else
			return "Open"
		end
	else
		return "Close"
	end
end

function E:ToggleOptionsUI(msg)
	if InCombatLockdown() then
		self:Print(ERR_NOT_IN_COMBAT)
		self.ShowOptionsUI = true
		return
	end

	if not IsAddOnLoaded("ElvUI_OptionsUI") then
		local noConfig
		local _, _, _, _, reason = GetAddOnInfo("ElvUI_OptionsUI")

		if reason ~= "MISSING" then
			EnableAddOn("ElvUI_OptionsUI")
			LoadAddOn("ElvUI_OptionsUI")

			-- version check elvui options if it's actually enabled
			if GetAddOnMetadata("ElvUI_OptionsUI", "Version") ~= "1.07" then
				self:StaticPopup_Show("CLIENT_UPDATE_REQUEST")
			end
		else
			noConfig = true
		end

		if noConfig then
			self:Print("|cffff0000Error -- Addon 'ElvUI_OptionsUI' not found.|r")
			return
		end
	end

	local ACD = E.Libs.AceConfigDialog
	local frame = E:Config_GetWindow()
	local mode, pages = E:Config_GetToggleMode(frame, msg)
	if ACD then ACD[mode](ACD, E.name) end

	if not frame then
		frame = E:Config_GetWindow()
	end

	if mode == "Open" and frame then
		local ACR = E.Libs.AceConfigRegistry
		if ACR and not ACR.NotifyHookedElvUI then
			hooksecurefunc(E.Libs.AceConfigRegistry, "NotifyChange", E.Config_UpdateLeftButtons)
			ACR.NotifyHookedElvUI = true
			E:Config_UpdateSize()
		end

		if frame.bottomHolder then
			E:Config_WindowOpened(frame)
		else -- window was released or never opened
			frame:HookScript("OnHide", E.Config_WindowClosed)

			for i = 1, frame:GetNumChildren() do
				local child = select(i, frame:GetChildren())
				if child:IsObjectType("Button") and child:GetText() == CLOSE then
					frame.originalClose = child
					child:Hide()
				elseif child:IsObjectType("Frame") or child:IsObjectType("Button") then
					if child:HasScript("OnMouseUp") then
						child:HookScript("OnMouseUp", E.Config_StopMoving)
					end
				end
			end

			local bottom = CreateFrame("Frame", nil, frame)
			bottom:Point("BOTTOMLEFT", 2, 2)
			bottom:Point("BOTTOMRIGHT", -2, 2)
			bottom:Height(37)
			frame.bottomHolder = bottom

			local unskinned = not E.private.skins.ace3.enable

			local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
			close:SetScript("OnClick", E.Config_CloseClicked)
			close:SetFrameLevel(1000)
			close:Point("TOPRIGHT", unskinned and -8 or 1, unskinned and -4 or 2)
			close:Size(32)
			close.originalClose = frame.originalClose
			frame.closeButton = close

			local left = CreateFrame("Frame", nil, frame)
			left:Point("BOTTOMRIGHT", bottom, "BOTTOMLEFT", 181, 0)
			left:Point("BOTTOMLEFT", bottom, "TOPLEFT", 0, 1)
			left:Point("TOPLEFT", unskinned and 10 or 2, unskinned and -6 or -2)
			frame.leftHolder = left

			local top = CreateFrame("Frame", nil, frame)
			top.version = frame.obj.titletext
			top:Point("TOPRIGHT", frame, -2, 0)
			top:Point("TOPLEFT", left, "TOPRIGHT", 1, 0)
			top:Height(24)
			frame.topHolder = top

			local logo = left:CreateTexture()
			logo:SetTexture(E.Media.Textures.LogoSmall)
			logo:Point("CENTER", left, "TOP", unskinned and 10 or 0, unskinned and -40 or -36)
			logo:Size(128, 64)
			left.logo = logo

			local buttonsHolder = CreateFrame("Frame", nil, left)
			buttonsHolder:Point("BOTTOMLEFT", bottom, "TOPLEFT", 0, 1)
			buttonsHolder:Point("TOPLEFT", left, "TOPLEFT", 0, -70)
			buttonsHolder:Point("BOTTOMRIGHT")
			buttonsHolder:SetFrameLevel(5)
			left.buttonsHolder = buttonsHolder

			local buttons = CreateFrame("Frame", nil, buttonsHolder)
			buttons:Point("BOTTOMLEFT", bottom, "TOPLEFT", 0, 1)
			buttons:Point("BOTTOMRIGHT")
			buttons:Point("TOPLEFT", 0, 0)
			left.buttons = buttons

			local slider = CreateFrame("Slider", nil, frame)
			slider:SetThumbTexture(E.Media.Textures.White8x8)
			slider:SetScript("OnMouseWheel", ConfigSliderOnMouseWheel)
			slider:SetScript("OnValueChanged", ConfigSliderOnValueChanged)
			slider:SetOrientation("VERTICAL")
			slider:SetFrameLevel(4)
			slider:SetValueStep(1)
			slider:SetValue(0)
			slider:Width(192)
			slider:Point("BOTTOMLEFT", bottom, "TOPLEFT", 0, 1)
			slider:Point("TOPLEFT", buttons, "TOPLEFT", 0, 0)
			slider.buttons = buttons
			left.slider = slider

			local thumb = slider:GetThumbTexture()
			thumb:Point("LEFT", left, "RIGHT", 2, 0)
			thumb:SetVertexColor(1, 1, 1, 0.5)
			thumb:SetSize(8, 12)
			left.slider.thumb = thumb

			if not unskinned then
				bottom:SetTemplate("Transparent")
				left:SetTemplate("Transparent")
				top:SetTemplate("Transparent")
				E.Skins:HandleCloseButton(close)
			end

			E:Config_CreateLeftButtons(frame, unskinned, E.Options.args)
			E:Config_CreateBottomButtons(frame, unskinned)
			E:Config_UpdateLeftScroller(frame)
			E:Config_WindowOpened(frame)
		end

		if ACD and pages then
			ACD:SelectGroup(E.name, unpack(pages))
		end
	end
end