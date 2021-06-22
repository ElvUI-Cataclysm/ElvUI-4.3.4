local E, L, V, P, G = unpack(select(2, ...))
local M = E:GetModule("WorldMap")

local _G = _G
local pairs = pairs
local find, format = string.find, string.format

local CreateFrame = CreateFrame
local GetCursorPosition = GetCursorPosition
local GetPlayerMapPosition = GetPlayerMapPosition
local GetUnitSpeed = GetUnitSpeed
local InCombatLockdown = InCombatLockdown
local SetUIPanelAttribute = SetUIPanelAttribute
local MOUSE_LABEL = MOUSE_LABEL
local PLAYER = PLAYER
local WORLDMAP_FULLMAP_SIZE = WORLDMAP_FULLMAP_SIZE
local WORLDMAP_WINDOWED_SIZE = WORLDMAP_WINDOWED_SIZE
local WORLDMAP_QUESTLIST_SIZE = WORLDMAP_QUESTLIST_SIZE

local INVERTED_POINTS = {
	TOP = "BOTTOM",
	TOPLEFT = "BOTTOMLEFT",
	TOPRIGHT = "BOTTOMRIGHT",
	BOTTOM = "TOP",
	BOTTOMLEFT = "TOPLEFT",
	BOTTOMRIGHT = "TOPRIGHT"
}

local tooltips = {
	WorldMapTooltip,
	WorldMapCompareTooltip1,
	WorldMapCompareTooltip2,
	WorldMapCompareTooltip3
}

function M:SetLargeWorldMap()
	if InCombatLockdown() then return end

	WorldMapFrame:SetParent(E.UIParent)
	WorldMapFrame:EnableKeyboard(false)
	WorldMapFrame:EnableMouse(true)
	if not WorldMapFrame.questMap then
		WorldMapFrame:SetScale(1)
	end

	for _, tt in pairs(tooltips) do
		if _G[tt] then _G[tt]:SetFrameStrata("TOOLTIP") end
	end

	if WorldMapFrame:GetAttribute("UIPanelLayout-area") ~= "center" then
		SetUIPanelAttribute(WorldMapFrame, "area", "center")
	end

	if WorldMapFrame:GetAttribute("UIPanelLayout-allowOtherPanels") ~= true then
		SetUIPanelAttribute(WorldMapFrame, "allowOtherPanels", true)
	end

	WorldMapFrame:ClearAllPoints()
	WorldMapFrame:Point("CENTER", UIParent, "CENTER", 0, 60)
	WorldMapFrame:SetSize(1002, 668)

	WorldMapFrameSizeUpButton:Hide()
	WorldMapFrameSizeDownButton:Show()
end

function M:SetSmallWorldMap()
	if InCombatLockdown() then return end

	WorldMapFrameSizeUpButton:Show()
	WorldMapFrameSizeDownButton:Hide()
end

function M:PLAYER_REGEN_ENABLED()
	WorldMapFrameSizeDownButton:Enable()
	WorldMapFrameSizeUpButton:Enable()
	WorldMapShowDigSites:Enable()
	WorldMapQuestShowObjectives:Enable()
	WorldMapTrackQuest:Enable()

	if WorldMapFrame.questMap then
		WatchFrame.showObjectives = WatchFrame.oldShowObjectives or true
		WorldMapBlobFrame.Show = WorldMapBlobFrame:Show()
		WorldMapPOIFrame.Show = WorldMapPOIFrame:Show()
		WorldMapBlobFrame:Show()
		WorldMapPOIFrame:Show()

		WatchFrame_Update()
	end
end

function M:PLAYER_REGEN_DISABLED()
	WorldMapFrameSizeDownButton:Disable()
	WorldMapFrameSizeUpButton:Disable()
	WorldMapShowDigSites:Disable()
	WorldMapQuestShowObjectives:Disable()
	WorldMapTrackQuest:Disable()

	if WorldMapFrame.questMap then
		if WORLDMAP_SETTINGS.size == WORLDMAP_QUESTLIST_SIZE then
			WorldMapFrame_SetFullMapView()
		end

		WatchFrame.oldShowObjectives = WatchFrame.showObjectives
		WatchFrame.showObjectives = nil
		WorldMapBlobFrame:Hide()
		WorldMapPOIFrame:Hide()

		WorldMapBlobFrame.Show = E.noop
		WorldMapPOIFrame.Show = E.noop

		WatchFrame_Update()
	end
end

local t = 0
local function UpdateCoords(self, elapsed)
	t = t + elapsed
	if t < 0.03333 then return end
	t = 0

	local x, y = GetPlayerMapPosition("player")

	if self.playerCoords.x ~= x or self.playerCoords.y ~= y then
		if x ~= 0 or y ~= 0 then
			self.playerCoords.x = x
			self.playerCoords.y = y
			self.playerCoords:SetFormattedText("%s:   %.2f, %.2f", PLAYER, x * 100, y * 100)
		else
			self.playerCoords.x = nil
			self.playerCoords.y = nil
			self.playerCoords:SetFormattedText("%s:   %s", PLAYER, "N/A")
		end
	end

	if WorldMapDetailFrame:IsMouseOver() then
		local curX, curY = GetCursorPosition()

		if self.mouseCoords.x ~= curX or self.mouseCoords.y ~= curY then
			local scale = WorldMapDetailFrame:GetEffectiveScale()
			local width, height = WorldMapDetailFrame:GetSize()
			local centerX, centerY = WorldMapDetailFrame:GetCenter()
			local adjustedX = (curX / scale - (centerX - (width * 0.5))) / width
			local adjustedY = (centerY + (height * 0.5) - curY / scale) / height

			if adjustedX >= 0 and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1 then
				self.mouseCoords.x = curX
				self.mouseCoords.y = curY
				self.mouseCoords:SetFormattedText("%s:  %.2f, %.2f", MOUSE_LABEL, adjustedX * 100, adjustedY * 100)
			else
				self.mouseCoords.x = nil
				self.mouseCoords.y = nil
				self.mouseCoords:SetText("")
			end
		end
	elseif self.mouseCoords.x then
		self.mouseCoords.x = nil
		self.mouseCoords.y = nil
		self.mouseCoords:SetText("")
	end
end

function M:PositionCoords()
	if not self.coordsHolder then return end

	local db = E.global.general.WorldMapCoordinates
	local position = db.position

	local x = find(position, "RIGHT") and -5 or 5
	local y = find(position, "TOP") and -5 or 5

	self.coordsHolder.playerCoords:ClearAllPoints()
	self.coordsHolder.playerCoords:Point(position, WorldMapDetailFrame, position, x + db.xOffset, y + db.yOffset)

	self.coordsHolder.mouseCoords:ClearAllPoints()
	self.coordsHolder.mouseCoords:Point(position, self.coordsHolder.playerCoords, INVERTED_POINTS[position], 0, y)
end

function M:CheckMovement()
	if not WorldMapFrame:IsShown() then return end

	if GetUnitSpeed("player") ~= 0 and not WorldMapPositioningGuide:IsMouseOver() then
		WorldMapFrame:SetAlpha(E.global.general.mapAlphaWhenMoving)
		WorldMapBlobFrame:SetFillAlpha(128 * E.global.general.mapAlphaWhenMoving)
		WorldMapBlobFrame:SetBorderAlpha(192 * E.global.general.mapAlphaWhenMoving)
		WorldMapArchaeologyDigSites:SetFillAlpha(128 * E.global.general.mapAlphaWhenMoving)
		WorldMapArchaeologyDigSites:SetBorderAlpha(192 * E.global.general.mapAlphaWhenMoving)
	else
		WorldMapFrame:SetAlpha(1)
		WorldMapBlobFrame:SetFillAlpha(128)
		WorldMapBlobFrame:SetBorderAlpha(192)
		WorldMapArchaeologyDigSites:SetFillAlpha(128)
		WorldMapArchaeologyDigSites:SetBorderAlpha(192)
	end
end

function M:UpdateMapAlpha()
	if (not E.global.general.fadeMapWhenMoving or E.global.general.mapAlphaWhenMoving >= 1) and self.MovingTimer then
		self:CancelTimer(self.MovingTimer)
		self.MovingTimer = nil

		WorldMapFrame:SetAlpha(1)
		WorldMapBlobFrame:SetFillAlpha(128)
		WorldMapBlobFrame:SetBorderAlpha(192)
		WorldMapArchaeologyDigSites:SetFillAlpha(128)
		WorldMapArchaeologyDigSites:SetBorderAlpha(192)
	elseif E.global.general.fadeMapWhenMoving and E.global.general.mapAlphaWhenMoving < 1 and not self.MovingTimer then
		self.MovingTimer = self:ScheduleRepeatingTimer("CheckMovement", 0.1)
	end
end

function M:Initialize()
	M:UpdateMapAlpha()

	if E.global.general.WorldMapCoordinates.enable then
		local coordsHolder = CreateFrame("Frame", "ElvUI_CoordsHolder", WorldMapFrame)
		coordsHolder:SetFrameLevel(WORLDMAP_POI_FRAMELEVEL + 100)
		coordsHolder:SetFrameStrata(WorldMapDetailFrame:GetFrameStrata())

		coordsHolder.playerCoords = coordsHolder:CreateFontString(nil, "OVERLAY")
		coordsHolder.playerCoords:SetTextColor(1, 1, 0)
		coordsHolder.playerCoords:SetFontObject(NumberFontNormal)
		coordsHolder.playerCoords:SetPoint("BOTTOMLEFT", WorldMapDetailFrame, "BOTTOMLEFT", 5, 5)
		coordsHolder.playerCoords:SetFormattedText("%s:   0, 0", PLAYER)

		coordsHolder.mouseCoords = coordsHolder:CreateFontString(nil, "OVERLAY")
		coordsHolder.mouseCoords:SetTextColor(1, 1, 0)
		coordsHolder.mouseCoords:SetFontObject(NumberFontNormal)
		coordsHolder.mouseCoords:SetPoint("BOTTOMLEFT", coordsHolder.playerCoords, "TOPLEFT", 0, 5)

		coordsHolder:SetScript("OnUpdate", UpdateCoords)

		self.coordsHolder = coordsHolder
		self:PositionCoords()
	end

	if E.global.general.smallerWorldMap then
		BlackoutWorld:SetTexture(nil)
		self:SecureHook("WorldMap_ToggleSizeDown", "SetSmallWorldMap")
		self:SecureHook("WorldMap_ToggleSizeUp", "SetLargeWorldMap")
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")

		if WORLDMAP_SETTINGS.size == WORLDMAP_FULLMAP_SIZE then
			self:SetLargeWorldMap()
		elseif WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE then
			self:SetSmallWorldMap()
		elseif WORLDMAP_SETTINGS.size == WORLDMAP_QUESTLIST_SIZE then
			self:SetLargeWorldMap()
			WorldMapFrame.questMap = true
		end

		DropDownList1:HookScript("OnShow", function(dropDown)
			local uiParentScale = UIParent:GetScale()

			if dropDown:GetScale() ~= uiParentScale then
				dropDown:SetScale(uiParentScale)
			end
		end)

		self:RawHook("WorldMapQuestPOI_OnLeave", function()
			WorldMapPOIFrame.allowBlobTooltip = true
			WorldMapTooltip:Hide()
		end, true)
	end

	self.Initialized = true
end

local function InitializeCallback()
	M:Initialize()
end

E:RegisterInitialModule(M:GetName(), InitializeCallback)