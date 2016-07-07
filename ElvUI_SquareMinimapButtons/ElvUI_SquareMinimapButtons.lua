local AddOnName, NS = ...

local strsub, strlen, strfind, ceil = strsub, strlen, strfind, ceil
local tinsert, pairs, unpack = tinsert, pairs, unpack

local SquareMinimapButtonBar = CreateFrame('Frame', 'SquareMinimapButtonBar', UIParent)
SquareMinimapButtonBar:SetPoint('RIGHT', UIParent, 'RIGHT', -45, 0)
SquareMinimapButtonBar:SetFrameStrata('LOW')
SquareMinimapButtonBar:SetClampedToScreen(true)
SquareMinimapButtonBar:SetMovable(true)

SquareMinimapButtonOptions = {
	['BarMouseOver'] = false,
	['BarEnabled'] = false,
	['IconSize'] = 27,
	['ButtonsPerRow'] = 12
}

local BorderColor
local TexCoords = { .1, .9, .1, .9 }

function SquareMinimapButtonBar:OnEnter()
	UIFrameFadeIn(SquareMinimapButtonBar, 0.2, SquareMinimapButtonBar:GetAlpha(), 1)
	if self:GetName() ~= 'SquareMinimapButtonBar' then
		self:SetBackdropBorderColor(.7, 0, .7)
	end
end

function SquareMinimapButtonBar:OnLeave()
	if SquareMinimapButtonOptions['BarMouseOver'] then
		UIFrameFadeOut(SquareMinimapButtonBar, 0.2, SquareMinimapButtonBar:GetAlpha(), 0)
	end
	if self:GetName() ~= 'SquareMinimapButtonBar' then
		self:SetBackdropBorderColor(unpack(BorderColor))
	end
end

local SkinnedMinimapButtons = {}

local ignoreButtons = {
	'FAQButton',		-- AsphyxiaUI
	'VersionButton',	-- AsphyxiaUI
	'ElvConfigToggle',
	'GameTimeFrame',
	'HelpOpenTicketButton',
	'MiniMapVoiceChatFrame',
	'TimeManagerClockButton',
}

local GenericIgnores = {
	'Archy',
	'GatherMatePin',
	'GatherNote',
	'GuildInstance',
	'HandyNotesPin',
	'MinimMap',
	'Spy_MapNoteList_mini',
	'ZGVMarker',
	'poiMinimap',
}

local PartialIgnores = {
	'Node',
	'Note',
	'Pin',
	'POI',
}

local WhiteList = {
	'LibDBIcon',
}

local AcceptedFrames = {
	'BagSync_MinimapButton',
	'VendomaticButtonFrame',
	'MiniMapMailFrame',
	'MiniMapTrackingButton',
}

local AddButtonsToBar = {
	'SmartBuff_MiniMapButton',
	'MiniMapMailFrame',
}

function SquareMinimapButtonBar:SkinMinimapButton(Button)
	if (not Button or Button.isSkinned) then return end

	local Name = Button:GetName()
	if not Name then return end

	if Button:IsObjectType('Button') then
		local ValidIcon = false

		for i = 1, #WhiteList do
			if strsub(Name, 1, strlen(WhiteList[i])) == WhiteList[i] then ValidIcon = true break end
		end

		if not ValidIcon then
			for i = 1, #ignoreButtons do
				if Name == ignoreButtons[i] then return end
			end

			for i = 1, #GenericIgnores do
				if strsub(Name, 1, strlen(GenericIgnores[i])) == GenericIgnores[i] then return end
			end

			for i = 1, #PartialIgnores do
				if strfind(Name, PartialIgnores[i]) ~= nil then return end
			end
		end

		Button:SetPushedTexture(nil)
		Button:SetHighlightTexture(nil)
		Button:SetDisabledTexture(nil)
	end
	for i = 1, Button:GetNumRegions() do
		local Region = select(i, Button:GetRegions())
		if Region:GetObjectType() == 'Texture' then
			local Texture = Region:GetTexture()

			if Texture and (strfind(Texture, 'Border') or strfind(Texture, 'Background') or strfind(Texture, 'AlphaMask')) then
				Region:SetTexture(nil)
				if Name == 'MiniMapTrackingButton' then
					Region:SetTexture('Interface\\Minimap\\Tracking\\None')
					Region:ClearAllPoints()
					Region:SetInside()
				end
			else
				if Name == 'BagSync_MinimapButton' then Region:SetTexture('Interface\\AddOns\\BagSync\\media\\icon') end
				if Name == 'DBMMinimapButton' then Region:SetTexture('Interface\\Icons\\INV_Helmet_87') end
				if Name == 'MiniMapMailFrame' then
					Region:ClearAllPoints()
					Region:SetPoint('CENTER', Button)
				end
				if not (Name == 'MiniMapMailFrame' or Name == 'SmartBuff_MiniMapButton') then
					Region:ClearAllPoints()
					Region:SetInside()
					Region:SetTexCoord(unpack(TexCoords))
					Button:HookScript('OnLeave', function(self) Region:SetTexCoord(unpack(TexCoords)) end)
				end
				Region:SetDrawLayer('ARTWORK')
				Region.SetPoint = function() return end
			end
		end
	end

	Button:SetFrameLevel(Minimap:GetFrameLevel() + 5)
	Button:Size(SquareMinimapButtonOptions['IconSize'])

	if Name == 'SmartBuff_MiniMapButton' then
		Button:SetNormalTexture("Interface\\Icons\\Spell_Nature_Purge")
		Button:GetNormalTexture():SetTexCoord(unpack(TexCoords))
		Button.SetNormalTexture = function() end
		Button:SetDisabledTexture("Interface\\Icons\\Spell_Nature_Purge")
		Button:GetDisabledTexture():SetTexCoord(unpack(TexCoords))
		Button.SetDisabledTexture = function() end
	elseif Name == 'VendomaticButtonFrame' then
		VendomaticButton:StripTextures()
		VendomaticButton:SetInside()
		VendomaticButtonIcon:SetTexture('Interface\\Icons\\INV_Misc_Rabbit_2')
		VendomaticButtonIcon:SetTexCoord(unpack(TexCoords))
	end
	if Name == 'MiniMapMailFrame' then
		local Frame = CreateFrame('Frame', 'MailDummyFrame', self)
		Frame:Size(SquareMinimapButtonOptions['IconSize'])
		Frame:SetTemplate()
		Frame.Icon = Frame:CreateTexture(nil, 'ARTWORK')
		Frame.Icon:SetPoint('CENTER')
		Frame.Icon:Size(18)
		Frame.Icon:SetTexture(MiniMapMailIcon:GetTexture())
		Frame:HookScript('OnEnter', self.OnEnter)
		Frame:HookScript('OnLeave', self.OnLeave)
		Frame:SetScript('OnUpdate', function(self)
			if SquareMinimapButtonOptions['MoveBlizzard'] then
				self:Show()
				self:SetPoint(MiniMapMailFrame:GetPoint())
			else
				self:Hide()
			end
		end)
		MiniMapMailFrame:HookScript('OnShow', function(self) MiniMapMailIcon:SetVertexColor(0, 1, 0) end)
		MiniMapMailFrame:HookScript('OnHide', function(self) MiniMapMailIcon:SetVertexColor(1, 1, 1) end)
	else
		Button:SetTemplate()
		--Button:SetBackdropColor(0, 0, 0, 0)
	end

	Button.isSkinned = true
	tinsert(SkinnedMinimapButtons, Button)
end

function SquareMinimapButtonBar:GetOptions()
	local Options = {
		type = 'group',
		name = "Square Minimap Buttons",
		order = 101,
		args = {
			mbb = {
				order = 1,
				type = 'group',
				name = 'Minimap Buttons / Bar',
				guiInline = true,
				get = function(info) return SquareMinimapButtonOptions[info[#info]] end,
				set = function(info, value) SquareMinimapButtonOptions[info[#info]] = value SquareMinimapButtonBar:Update() end, 
				args = {
					BarEnabled = {
						order = 1,
						type = 'toggle',
						name = 'Enable Bar',
					},
					BarMouseOver = {
						order = 2,
						type = 'toggle',
						name = 'Bar MouseOver',
					},
					MoveBlizzard = {
						order = 3,
						type = 'toggle',
						name = 'Move Blizzard Buttons',
						desc = 'Mail / Dungeon',
					},
					IconSize = {
						order = 4,
						type = 'range',
						width = 'full',
						name = 'Icon Size',
						min = 24, max = 48, step = 1,
					},
					ButtonsPerRow = {
						order = 5,
						type = 'range',
						width = 'full',
						name = 'Buttons Per Row',
						min = 1, max = 12, step = 1,
					},
  				},
			},
		},
	}
	if EP then
		local Ace3OptionsPanel = IsAddOnLoaded("ElvUI") and ElvUI[1] or Enhanced_Config[1]
		Ace3OptionsPanel.Options.args.SquareMinimapButton = Options
	else
		local ACR, ACD = LibStub("AceConfigRegistry-3.0", true), LibStub("AceConfigDialog-3.0", true)
		if not (ACR or ACD) then return end
		ACR:RegisterOptionsTable("SquareMinimapButtons", Options)
		ACD:AddToBlizOptions("SquareMinimapButtons", "SquareMinimapButtons", nil, "mbb")
	end
end

SquareMinimapButtonBar:RegisterEvent('PLAYER_ENTERING_WORLD')
SquareMinimapButtonBar:RegisterEvent('PLAYER_LOGIN')

function SquareMinimapButtonBar:GrabMinimapButtons()
	for i = 1, Minimap:GetNumChildren() do
		local object = select(i, Minimap:GetChildren())
		if object then
			if object:IsObjectType('Button') and object:GetName() then
				self:SkinMinimapButton(object)
			end
			for _, frame in pairs(AcceptedFrames) do
				if object:IsObjectType('Frame') and object:GetName() == frame then
					self:SkinMinimapButton(object)
				end
			end
		end
	end
end

function SquareMinimapButtonBar:Update()
	MiniMapTrackingButton:Hide()
	if not SquareMinimapButtonOptions['BarEnabled'] then return end

	local AnchorX, AnchorY, MaxX = 0, 1, SquareMinimapButtonOptions['ButtonsPerRow']
	local ButtonsPerRow = SquareMinimapButtonOptions['ButtonsPerRow']
	local NumColumns = ceil(#SkinnedMinimapButtons / ButtonsPerRow)
	local Spacing, Mult = 4, 1
	local Size = SquareMinimapButtonOptions['IconSize']
	local ActualButtons, Maxed = 0

	if NumColumns == 1 and ButtonsPerRow > #SkinnedMinimapButtons then
		ButtonsPerRow = #SkinnedMinimapButtons
	end

	for Key, Frame in pairs(SkinnedMinimapButtons) do
		local Name = Frame:GetName()
		local Exception = false
		for _, Button in pairs(AddButtonsToBar) do
			if Name == Button then
				Exception = true
				if Name == 'SmartBuff_MiniMapButton' then
					SMARTBUFF_MinimapButton_CheckPos = function() end
					SMARTBUFF_MinimapButton_OnUpdate = function() end
				end
				if not SquareMinimapButtonOptions['MoveBlizzard'] and (Name == 'MiniMapMailFrame') then
					Exception = false
				end
			end
		end
		if SquareMinimapButtonOptions['MoveBlizzard'] and Name == 'MiniMapTrackingButton' then MiniMapTrackingButton:Show() end
		if Frame:IsVisible() and not (Name == 'MiniMapMailFrame') or Exception then
			AnchorX = AnchorX + 1
			ActualButtons = ActualButtons + 1
			if AnchorX > MaxX then
				AnchorY = AnchorY + 1
				AnchorX = 1
				Maxed = true
			end

			local yOffset = - Spacing - ((Size + Spacing) * (AnchorY - 1))
			local xOffset = Spacing + ((Size + Spacing) * (AnchorX - 1))
			Frame:SetTemplate()
			Frame:SetBackdropColor(0, 0, 0, 0)
			Frame:SetParent(SquareMinimapButtonBar)
			Frame:ClearAllPoints()
			Frame:SetPoint('TOPLEFT', SquareMinimapButtonBar, 'TOPLEFT', xOffset, yOffset)
			Frame:SetSize(SquareMinimapButtonOptions['IconSize'], SquareMinimapButtonOptions['IconSize'])
			Frame:SetFrameStrata('LOW')
			Frame:SetFrameLevel(self:GetFrameLevel() + 2)
			Frame:RegisterForDrag('LeftButton')
			Frame:SetScript('OnDragStart', nil)
			Frame:SetScript('OnDragStop', nil)
			Frame:HookScript('OnEnter', self.OnEnter)
			Frame:HookScript('OnLeave', self.OnLeave)
			if Maxed then ActualButtons = ButtonsPerRow end
			local BarWidth = (Spacing + ((Size * (ActualButtons * Mult)) + ((Spacing * (ActualButtons - 1)) * Mult) + (Spacing * Mult)))
			local BarHeight = (Spacing + ((Size * (AnchorY * Mult)) + ((Spacing * (AnchorY - 1)) * Mult) + (Spacing * Mult)))
			self:SetSize(BarWidth, BarHeight)

			if not self.RegisteredMovers then
				if IsAddOnLoaded("Tukui") then
					Tukui[1]["Movers"]:RegisterFrame(self)
				elseif IsAddOnLoaded("ElvUI") then
					ElvUI[1]:CreateMover(self, "SquareMinimapButtonBarMover", "SquareMinimapButtonBar Anchor", nil, nil, nil, "ALL,GENERAL")
				else
					self:RegisterForDrag('LeftButton')
					self:SetScript('OnDragStart', self.StartMoving)
					self:SetScript('OnDragStop', self.StopMovingOrSizing)
					Frame:SetScript('OnDragStart', function(self) self:GetParent():StartMoving() end)
					Frame:SetScript('OnDragStop', function(self) self:GetParent():StopMovingOrSizing() end)
				end
				self.RegisteredMovers = true
			end
		end
	end
	self:Show()
	self:OnEnter()
	self:OnLeave()
end

SquareMinimapButtonBar:SetScript('OnEvent', function(self, event, addon)
	if event == 'PLAYER_LOGIN' then
		MiniMapTrackingButton:SetParent(Minimap)

		self:SetTemplate('Transparent', true)

		Minimap:SetMaskTexture("Interface\\ChatFrame\\ChatFrameBackground")

		BorderColor = { self:GetBackdropBorderColor() }

		self:SetScript('OnEnter', self.OnEnter)
		self:SetScript('OnLeave', self.OnLeave)

		EP = LibStub('LibElvUIPlugin-1.0', true)
		if EP then
			EP:RegisterPlugin(AddOnName, self.GetOptions)
		else
			self:GetOptions()
		end

		self:RegisterEvent('ADDON_LOADED')
	else
		self:GrabMinimapButtons()
		self:Update()
		self:OnLeave()
	end
end)

local Time = 0
SquareMinimapButtonBar:SetScript('OnUpdate', function(self, elasped)
	Time = Time + elasped
	if Time > 5 then
		self:GrabMinimapButtons()
		self:Update()
		self:OnLeave()
		self:SetScript('OnUpdate', nil)
	end
end)