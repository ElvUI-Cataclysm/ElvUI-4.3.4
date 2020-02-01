local _G = _G
local pairs, unpack = pairs, unpack
local min = min
local tcopy, wipe = table.copy, wipe
local format, strsplit = string.format, string.split

local hooksecurefunc = hooksecurefunc
local CreateFrame = CreateFrame
local GetAddOnInfo = GetAddOnInfo
local GetAddOnMetadata = GetAddOnMetadata
local GetLocale = GetLocale
local GetTime = GetTime
local HideUIPanel = HideUIPanel
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local LoadAddOn = LoadAddOn
local ReloadUI = ReloadUI

local ERR_NOT_IN_COMBAT = ERR_NOT_IN_COMBAT
local GameMenuButtonLogout = GameMenuButtonLogout
local GameMenuFrame = GameMenuFrame

BINDING_HEADER_ELVUI = GetAddOnMetadata(..., "Title")

local AceAddon, AceAddonMinor = LibStub("AceAddon-3.0")
local CallbackHandler = LibStub("CallbackHandler-1.0")

local AddOnName, Engine = ...
local E = AceAddon:NewAddon(AddOnName, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")

E.version = GetAddOnMetadata("ElvUI", "Version")
E.callbacks = E.callbacks or CallbackHandler:New(E)

-- Defaults
E.DF = {profile = {}, global = {}}
E.privateVars = {profile = {}}

E.Options = {
	type = "group",
	name = AddOnName,
	args = {}
}

Engine[1] = E
Engine[2] = {}
Engine[3] = E.privateVars.profile
Engine[4] = E.DF.profile
Engine[5] = E.DF.global
_G[AddOnName] = Engine

do
	local locale = GetLocale()
	local convert = {enGB = "enUS", esES = "esMX", itIT = "enUS"}
	local gameLocale = convert[locale] or locale or "enUS"

	function E:GetLocale()
		return gameLocale
	end
end

do
	E.Libs = {}
	E.LibsMinor = {}
	function E:AddLib(name, major, minor)
		if not name then return end

		-- in this case: `major` is the lib table and `minor` is the minor version
		if type(major) == "table" and type(minor) == "number" then
			self.Libs[name], self.LibsMinor[name] = major, minor
		else -- in this case: `major` is the lib name and `minor` is the silent switch
			self.Libs[name], self.LibsMinor[name] = LibStub(major, minor)
		end
	end

	E:AddLib("AceAddon", AceAddon, AceAddonMinor)
	E:AddLib("AceDB", "AceDB-3.0")
	E:AddLib("EP", "LibElvUIPlugin-1.0")
	E:AddLib("LSM", "LibSharedMedia-3.0")
	E:AddLib("ACL", "AceLocale-3.0-ElvUI")
	E:AddLib("LAB", "LibActionButton-1.0-ElvUI")
	E:AddLib("LAI", "LibAuraInfo-1.0-ElvUI", true)
	E:AddLib("LDB", "LibDataBroker-1.1")
	E:AddLib("DualSpec", "LibDualSpec-1.0")
	E:AddLib("SimpleSticky", "LibSimpleSticky-1.0")
	E:AddLib("SpellRange", "SpellRange-1.0")
	E:AddLib("ItemSearch", "LibItemSearch-1.2-ElvUI")
	E:AddLib("Compress", "LibCompress")
	E:AddLib("Base64", "LibBase64-1.0-ElvUI")
	E:AddLib("Masque", "Masque", true)
	E:AddLib("Translit", "LibTranslit-1.0")
	-- added on ElvUI_OptionsUI load: AceGUI, AceConfig, AceConfigDialog, AceConfigRegistry, AceDBOptions

	-- backwards compatible for plugins
	E.LSM = E.Libs.LSM
	E.Masque = E.Libs.Masque
end

E.oUF = Engine.oUF
E.ActionBars = E:NewModule("ActionBars", "AceHook-3.0", "AceEvent-3.0")
E.AFK = E:NewModule("AFK", "AceEvent-3.0", "AceTimer-3.0")
E.Auras = E:NewModule("Auras", "AceHook-3.0", "AceEvent-3.0")
E.Bags = E:NewModule("Bags", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
E.Blizzard = E:NewModule("Blizzard", "AceEvent-3.0", "AceHook-3.0")
E.Chat = E:NewModule("Chat", "AceTimer-3.0", "AceHook-3.0", "AceEvent-3.0")
E.DataBars = E:NewModule("DataBars", "AceEvent-3.0")
E.DataTexts = E:NewModule("DataTexts", "AceTimer-3.0", "AceHook-3.0", "AceEvent-3.0")
E.DebugTools = E:NewModule("DebugTools", "AceEvent-3.0", "AceHook-3.0")
E.Distributor = E:NewModule("Distributor", "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0")
E.Layout = E:NewModule("Layout", "AceEvent-3.0")
E.Minimap = E:NewModule("Minimap", "AceEvent-3.0")
E.Misc = E:NewModule("Misc", "AceEvent-3.0", "AceTimer-3.0")
E.ModuleCopy = E:NewModule("ModuleCopy", "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0")
E.NamePlates = E:NewModule("NamePlates", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
E.PluginInstaller = E:NewModule("PluginInstaller")
E.RaidUtility = E:NewModule("RaidUtility", "AceEvent-3.0")
E.ReminderBuffs = E:NewModule("ReminderBuffs", "AceEvent-3.0")
E.Skins = E:NewModule("Skins", "AceHook-3.0", "AceEvent-3.0")
E.Threat = E:NewModule("Threat", "AceEvent-3.0")
E.Tooltip = E:NewModule("Tooltip", "AceHook-3.0", "AceEvent-3.0")
E.TotemBar = E:NewModule("Totems", "AceEvent-3.0")
E.UnitFrames = E:NewModule("UnitFrames", "AceTimer-3.0", "AceEvent-3.0", "AceHook-3.0")
E.WorldMap = E:NewModule("WorldMap", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")

do
	local arg2, arg3 = "([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1"
	function E:EscapeString(str)
		return gsub(str, arg2, arg3)
	end
end

do
	DisableAddOn("ElvUI_VisualAuraTimers")
	DisableAddOn("ElvUI_ExtraActionBars")
	DisableAddOn("ElvUI_CastBarOverlay")
	DisableAddOn("ElvUI_EverySecondCounts")
	DisableAddOn("ElvUI_AuraBarsMovers")
end

function E:OnInitialize()
	if not ElvCharacterDB then
		ElvCharacterDB = {}
	end

	ElvCharacterData = nil --Depreciated
	ElvPrivateData = nil --Depreciated
	ElvData = nil --Depreciated

	self.db = tcopy(self.DF.profile, true)
	self.global = tcopy(self.DF.global, true)

	local ElvDB = ElvDB
	if ElvDB then
		if ElvDB.global then
			self:CopyTable(self.global, ElvDB.global)
		end

		local profileKey
		if ElvDB.profileKeys then
			profileKey = ElvDB.profileKeys[self.myname.." - "..self.myrealm]
		end

		if profileKey and ElvDB.profiles and ElvDB.profiles[profileKey] then
			self:CopyTable(self.db, ElvDB.profiles[profileKey])
		end
	end

	self.private = tcopy(self.privateVars.profile, true)

	local ElvPrivateDB = ElvPrivateDB
	if ElvPrivateDB then
		local profileKey
		if ElvPrivateDB.profileKeys then
			profileKey = ElvPrivateDB.profileKeys[self.myname.." - "..self.myrealm]
		end

		if profileKey and ElvPrivateDB.profiles and ElvPrivateDB.profiles[profileKey] then
			self:CopyTable(self.private, ElvPrivateDB.profiles[profileKey])
		end
	end

	self.twoPixelsPlease = false
	self.ScanTooltip = CreateFrame("GameTooltip", "ElvUI_ScanTooltip", UIParent, "GameTooltipTemplate")
	self.PixelMode = self.twoPixelsPlease or self.private.general.pixelPerfect -- keep this over `UIScale`
	self:UIScale(true)
	self:UpdateMedia()

	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:Contruct_StaticPopups()
	self:InitializeInitialModules()

	if IsAddOnLoaded("Tukui") then
		self:StaticPopup_Show("TUKUI_ELVUI_INCOMPATIBLE")
	end

	local GameMenuButton = CreateFrame("Button", "GameMenuButtonElvUI", GameMenuFrame, "GameMenuButtonTemplate")
	GameMenuButton:SetText(self.title)
	GameMenuButton:SetScript("OnClick", function()
		E:ToggleOptionsUI()
		HideUIPanel(GameMenuFrame)
	end)
	GameMenuFrame[AddOnName] = GameMenuButton

	GameMenuButton:Size(GameMenuButtonLogout:GetWidth(), GameMenuButtonLogout:GetHeight())
	GameMenuButtonRatings:HookScript("OnShow", function(self)
		GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + self:GetHeight())
	end)
	GameMenuButtonRatings:HookScript("OnHide", function(self)
		GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() - self:GetHeight())
	end)

	GameMenuFrame:HookScript("OnShow", function()
		if not GameMenuFrame.isElvUI then
			GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + GameMenuButtonLogout:GetHeight() + 5)
			GameMenuFrame.isElvUI = true
		end
		local _, relTo = GameMenuButtonLogout:GetPoint()
		if relTo ~= GameMenuFrame[AddOnName] then
			GameMenuFrame[AddOnName]:ClearAllPoints()
			GameMenuFrame[AddOnName]:Point("TOPLEFT", relTo, "BOTTOMLEFT", 0, -1)
			GameMenuButtonLogout:ClearAllPoints()
			GameMenuButtonLogout:Point("TOPLEFT", GameMenuFrame[AddOnName], "BOTTOMLEFT", 0, -16)
		end
	end)

	self.loadedtime = GetTime()
end

local LoadUI = CreateFrame("Frame")
LoadUI:RegisterEvent("PLAYER_LOGIN")
LoadUI:SetScript("OnEvent", function()
	E:Initialize()
end)

function E:PLAYER_REGEN_ENABLED()
	self:ToggleOptionsUI()
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
end

function E:PLAYER_REGEN_DISABLED()
	local err

	if IsAddOnLoaded("ElvUI_OptionsUI") then
		local ACD = self.Libs.AceConfigDialog
		if ACD and ACD.OpenFrames and ACD.OpenFrames[AddOnName] then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
			ACD:Close(AddOnName)
			err = true
		end
	end

	if self.CreatedMovers then
		for name in pairs(self.CreatedMovers) do
			local mover = _G[name]
			if mover and mover:IsShown() then
				mover:Hide()
				err = true
			end
		end
	end

	if err then
		self:Print(ERR_NOT_IN_COMBAT)
	end
end

function E:ResetProfile()
	local profileKey

	local ElvPrivateDB = ElvPrivateDB
	if ElvPrivateDB.profileKeys then
		profileKey = ElvPrivateDB.profileKeys[self.myname.." - "..self.myrealm]
	end

	if profileKey and ElvPrivateDB.profiles and ElvPrivateDB.profiles[profileKey] then
		ElvPrivateDB.profiles[profileKey] = nil
	end

	ElvCharacterDB = nil
	ReloadUI()
end

function E:OnProfileReset()
	self:StaticPopup_Show("RESET_PROFILE_PROMPT")
end

function E:ResetConfigSettings()
	E.configSavedPositionTop, E.configSavedPositionLeft = nil, nil
	E.global.general.AceGUI = E:CopyTable({}, E.DF.global.general.AceGUI)
end

function E:GetConfigPosition()
	return E.configSavedPositionTop, E.configSavedPositionLeft
end

function E:GetConfigSize()
	return E.global.general.AceGUI.width, E.global.general.AceGUI.height
end

function E:UpdateConfigSize(reset)
	local frame = self.GUIFrame
	if not frame then return end

	local maxWidth, maxHeight = self.UIParent:GetSize()
	frame:SetMinResize(800, 600)
	frame:SetMaxResize(maxWidth - 50, maxHeight - 50)

	self.Libs.AceConfigDialog:SetDefaultSize(AddOnName, self:GetConfigDefaultSize())

	local status = frame.obj and frame.obj.status
	if status then
		if reset then
			self:ResetConfigSettings()

			status.top, status.left = self:GetConfigPosition()
			status.width, status.height = self:GetConfigDefaultSize()

			frame.obj:ApplyStatus()
		else
			local top, left = self:GetConfigPosition()
			if top and left then
				status.top, status.left = top, left

				frame.obj:ApplyStatus()
			end
		end
	end
end

function E:GetConfigDefaultSize()
	local width, height = E:GetConfigSize()
	local maxWidth, maxHeight = E.UIParent:GetSize()
	width, height = min(maxWidth - 50, width), min(maxHeight - 50, height)
	return width, height
end

function E:ConfigStopMovingOrSizing()
	if self.obj and self.obj.status then
		E.configSavedPositionTop, E.configSavedPositionLeft = E:Round(self:GetTop(), 2), E:Round(self:GetLeft(), 2)
		E.global.general.AceGUI.width, E.global.general.AceGUI.height = E:Round(self:GetWidth(), 2), E:Round(self:GetHeight(), 2)
	end
end

local pageNodes = {}
function E:ToggleOptionsUI(msg)
	if InCombatLockdown() then
		self:Print(ERR_NOT_IN_COMBAT)
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	if not IsAddOnLoaded("ElvUI_OptionsUI") then
		local noConfig
		local _, _, _, _, reason = GetAddOnInfo("ElvUI_OptionsUI")
		if reason ~= "MISSING" and reason ~= "DISABLED" then
			self.GUIFrame = false
			LoadAddOn("ElvUI_OptionsUI")

			--For some reason, GetAddOnInfo reason is "DEMAND_LOADED" even if the addon is disabled.
			--Workaround: Try to load addon and check if it is loaded right after.
			if not IsAddOnLoaded("ElvUI_OptionsUI") then noConfig = true end

			-- version check elvui options if it's actually enabled
			if (not noConfig) and GetAddOnMetadata("ElvUI_OptionsUI", "Version") ~= "1.06" then
				self:StaticPopup_Show("CLIENT_UPDATE_REQUEST")
			end
		else
			noConfig = true
		end

		if noConfig then
			self:Print("|cffff0000Error -- Addon 'ElvUI_OptionsUI' not found or is disabled.|r")
			return
		end
	end

	local ACD = self.Libs.AceConfigDialog
	local ConfigOpen = ACD and ACD.OpenFrames and ACD.OpenFrames[AddOnName]

	local pages, msgStr
	if msg and msg ~= "" then
		pages = {strsplit(",", msg)}
		msgStr = gsub(msg, ",", "\001")
	end

	local mode = "Close"
	if not ConfigOpen or (pages ~= nil) then
		if pages ~= nil then
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

			if ConfigOpen and ((not index and mainSel and mainSel == msg) or (index and pageNodes and pageNodes[index])) then
				mode = "Close"
			else
				mode = "Open"
			end
		else
			mode = "Open"
		end
	end

	if ACD then
		ACD[mode](ACD, AddOnName)
	end

	if mode == "Open" then
		ConfigOpen = ACD and ACD.OpenFrames and ACD.OpenFrames[AddOnName]
		if ConfigOpen then
			local frame = ConfigOpen.frame
			if frame and not self.GUIFrame then
				self.GUIFrame = frame
				ElvUIGUIFrame = self.GUIFrame

				self:UpdateConfigSize()
				hooksecurefunc(frame, "StopMovingOrSizing", E.ConfigStopMovingOrSizing)
			end
		end

		if ACD and pages then
			ACD:SelectGroup(AddOnName, unpack(pages))
		end
	end

	GameTooltip:Hide() --Just in case you're mouseovered something and it closes.
end