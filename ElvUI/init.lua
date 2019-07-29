local _G = _G
local pairs, unpack = pairs, unpack
local min = min
local tcopy, wipe = table.copy, wipe
local format, strsplit = string.format, string.split

local CreateFrame = CreateFrame
local GetAddOnInfo = GetAddOnInfo
local GetAddOnMetadata = GetAddOnMetadata
local HideUIPanel = HideUIPanel
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local LoadAddOn = LoadAddOn
local ReloadUI = ReloadUI
local GameMenuFrame = GameMenuFrame
local GameMenuButtonLogout = GameMenuButtonLogout
local GameMenuButtonAddons = GameMenuButtonAddons
local ERR_NOT_IN_COMBAT = ERR_NOT_IN_COMBAT

BINDING_HEADER_ELVUI = GetAddOnMetadata(..., "Title")

local AceAddon, AceAddonMinor = _G.LibStub("AceAddon-3.0")
local CallbackHandler = _G.LibStub("CallbackHandler-1.0")

local AddOnName, Engine = ...
local AddOn = AceAddon:NewAddon(AddOnName, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")

AddOn.callbacks = AddOn.callbacks or CallbackHandler:New(AddOn)

-- Defaults
AddOn.DF = {profile = {}, global = {}}
AddOn.privateVars = {profile = {}}

AddOn.Options = {
	type = "group",
	name = AddOnName,
	args = {}
}

Engine[1] = AddOn
Engine[2] = {}
Engine[3] = AddOn.privateVars.profile
Engine[4] = AddOn.DF.profile
Engine[5] = AddOn.DF.global
_G[AddOnName] = Engine

do
	AddOn.Libs = {}
	AddOn.LibsMinor = {}
	function AddOn:AddLib(name, major, minor)
		if not name then return end

		-- in this case: `major` is the lib table and `minor` is the minor version
		if type(major) == "table" and type(minor) == "number" then
			self.Libs[name], self.LibsMinor[name] = major, minor
		else -- in this case: `major` is the lib name and `minor` is the silent switch
			self.Libs[name], self.LibsMinor[name] = _G.LibStub(major, minor)
		end
	end

	AddOn:AddLib("AceAddon", AceAddon, AceAddonMinor)
	AddOn:AddLib("AceDB", "AceDB-3.0")
	AddOn:AddLib("EP", "LibElvUIPlugin-1.0")
	AddOn:AddLib("LSM", "LibSharedMedia-3.0")
	AddOn:AddLib("ACL", "AceLocale-3.0")
	AddOn:AddLib("LAB", "LibActionButton-1.0")
	AddOn:AddLib("LDB", "LibDataBroker-1.1")
	AddOn:AddLib("DualSpec", "LibDualSpec-1.0")
	AddOn:AddLib("SimpleSticky", "LibSimpleSticky-1.0")
	AddOn:AddLib("SpellRange", "SpellRange-1.0")
	AddOn:AddLib("ItemSearch", "LibItemSearch-1.2")
	AddOn:AddLib("Compress", "LibCompress")
	AddOn:AddLib("Base64", "LibBase64-1.0-ElvUI")
	AddOn:AddLib("Masque", "Masque", true)
	-- added on ElvUI_OptionsUI load: AceGUI, AceConfig, AceConfigDialog, AceConfigRegistry, AceDBOptions

	-- backwards compatible for plugins
	AddOn.LSM = AddOn.Libs.LSM
	AddOn.Masque = AddOn.Libs.Masque
end

AddOn.oUF = Engine.oUF
AddOn.ActionBars = AddOn:NewModule("ActionBars", "AceHook-3.0", "AceEvent-3.0")
AddOn.AFK = AddOn:NewModule("AFK", "AceEvent-3.0", "AceTimer-3.0")
AddOn.Auras = AddOn:NewModule("Auras", "AceHook-3.0", "AceEvent-3.0")
AddOn.Bags = AddOn:NewModule("Bags", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
AddOn.Blizzard = AddOn:NewModule("Blizzard", "AceEvent-3.0", "AceHook-3.0")
AddOn.Chat = AddOn:NewModule("Chat", "AceTimer-3.0", "AceHook-3.0", "AceEvent-3.0")
AddOn.DataBars = AddOn:NewModule("DataBars", "AceEvent-3.0")
AddOn.DataTexts = AddOn:NewModule("DataTexts", "AceTimer-3.0", "AceHook-3.0", "AceEvent-3.0")
AddOn.DebugTools = AddOn:NewModule("DebugTools", "AceEvent-3.0", "AceHook-3.0")
AddOn.Distributor = AddOn:NewModule("Distributor", "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0")
AddOn.Layout = AddOn:NewModule("Layout", "AceEvent-3.0")
AddOn.Minimap = AddOn:NewModule("Minimap", "AceEvent-3.0")
AddOn.Misc = AddOn:NewModule("Misc", "AceEvent-3.0", "AceTimer-3.0")
AddOn.ModuleCopy = AddOn:NewModule("ModuleCopy", "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0")
AddOn.NamePlates = AddOn:NewModule("NamePlates", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
AddOn.PluginInstaller = AddOn:NewModule("PluginInstaller")
AddOn.RaidUtility = AddOn:NewModule("RaidUtility", "AceEvent-3.0")
AddOn.Reminder = AddOn:NewModule("ReminderBuffs", "AceEvent-3.0")
AddOn.Skins = AddOn:NewModule("Skins", "AceHook-3.0", "AceEvent-3.0")
AddOn.Threat = AddOn:NewModule("Threat", "AceEvent-3.0")
AddOn.Tooltip = AddOn:NewModule("Tooltip", "AceHook-3.0", "AceEvent-3.0")
AddOn.TotemBar = AddOn:NewModule("Totems", "AceEvent-3.0")
AddOn.UnitFrames = AddOn:NewModule("UnitFrames", "AceTimer-3.0", "AceEvent-3.0", "AceHook-3.0")
AddOn.WorldMap = AddOn:NewModule("WorldMap", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")

function AddOn:ScanTooltipTextures(clean, grabTextures)
	local textures
	for i = 1, 10 do
		local tex = _G["ElvUI_ScanTooltipTexture"..i]
		local texture = tex and tex:GetTexture()
		if texture then
			if grabTextures then
				if not textures then textures = {} end
				textures[i] = texture
			end
			if clean then
				tex:SetTexture()
			end
		end
	end

	return textures
end

function AddOn:OnInitialize()
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

	self.ScanTooltip = CreateFrame("GameTooltip", "ElvUI_ScanTooltip", UIParent, "GameTooltipTemplate")
	self.PixelMode = self.private.general.pixelPerfect -- keep this over `UIScale`
	self:UIScale(true)
	self:UpdateMedia()
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:Contruct_StaticPopups()
	self:InitializeInitialModules()

	if IsAddOnLoaded("Tukui") then
		self:StaticPopup_Show("TUKUI_ELVUI_INCOMPATIBLE")
	end

	local GameMenuButton = CreateFrame("Button", "ElvUI", GameMenuFrame, "GameMenuButtonTemplate")
	GameMenuButton:SetText(self.title)
	GameMenuButton:SetScript("OnClick", function()
		AddOn:ToggleOptionsUI()
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

	if AddOn.private.skins.blizzard.enable ~= true or AddOn.private.skins.blizzard.misc ~= true then return end

	local S = AddOn:GetModule("Skins")
	S:HandleButton(GameMenuButton)
end

local LoadUI = CreateFrame("Frame")
LoadUI:RegisterEvent("PLAYER_LOGIN")
LoadUI:SetScript("OnEvent", function()
	AddOn:Initialize()
end)

function AddOn:PLAYER_REGEN_ENABLED()
	self:ToggleOptionsUI()
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
end

function AddOn:PLAYER_REGEN_DISABLED()
	local err = false

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
			if _G[name] and _G[name]:IsShown() then
				err = true
				_G[name]:Hide()
			end
		end
	end

	if err == true then
		self:Print(ERR_NOT_IN_COMBAT)
	end
end

function AddOn:ResetProfile()
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

function AddOn:OnProfileReset()
	self:StaticPopup_Show("RESET_PROFILE_PROMPT")
end

function AddOn:ResetConfigSettings()
	AddOn.configSavedPositionTop, AddOn.configSavedPositionLeft = nil, nil
	AddOn.global.general.AceGUI = AddOn:CopyTable({}, AddOn.DF.global.general.AceGUI)
end

function AddOn:GetConfigPosition()
	return AddOn.configSavedPositionTop, AddOn.configSavedPositionLeft
end

function AddOn:GetConfigSize()
	return AddOn.global.general.AceGUI.width, AddOn.global.general.AceGUI.height
end

function AddOn:GetConfigDefaultSize()
	local width, height = AddOn:GetConfigSize()
	local maxWidth, maxHeight = AddOn.UIParent:GetSize()
	width, height = min(maxWidth - 50, width), min(maxHeight - 50, height)
	return width, height
end

function AddOn:ConfigStopMovingOrSizing()
	if self.obj and self.obj.status then
		AddOn.configSavedPositionTop, AddOn.configSavedPositionLeft = AddOn:Round(self:GetTop(), 2), AddOn:Round(self:GetLeft(), 2)
		AddOn.global.general.AceGUI.width, AddOn.global.general.AceGUI.height = AddOn:Round(self:GetWidth(), 2), AddOn:Round(self:GetHeight(), 2)
	end
end

local pageNodes = {}
function AddOn:ToggleOptionsUI(msg)
	if InCombatLockdown() then
		self:Print(ERR_NOT_IN_COMBAT)
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	if not IsAddOnLoaded("ElvUI_OptionsUI") then
		local noConfig
		local _, _, _, _, _, reason = GetAddOnInfo("ElvUI_OptionsUI")
		if reason ~= "MISSING" and reason ~= "DISABLED" then
			self.GUIFrame = false
			LoadAddOn("ElvUI_OptionsUI")

			--For some reason, GetAddOnInfo reason is "DEMAND_LOADED" even if the addon is disabled.
			--Workaround: Try to load addon and check if it is loaded right after.
			if not IsAddOnLoaded("ElvUI_OptionsUI") then noConfig = true end

			-- version check elvui config if it's actually enabled
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
		msgStr = msg:gsub(",","\001")
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
						mainSelStr = mainSel and ("^"..mainSel:gsub("([%(%)%.%%%+%-%*%?%[%^%$])","%%%1").."\001")
						mainNode = main and main.children and main.children[pages[i]]
						pageNodes[index + 1], pageNodes[index + 2] = main, mainNode
					else
						sub = pages[i] and pageNodes[i] and ((i == pageCount and pageNodes[i]) or pageNodes[i].children[pages[i]])
						subSel = sub and sub.status and sub.status.groups and sub.status.groups.selected
						subNode = (mainSelStr and msgStr:match(mainSelStr..pages[i]:gsub("([%(%)%.%%%+%-%*%?%[%^%$])","%%%1").."$") and (subSel and subSel == pages[i])) or ((i == pageCount and not subSel) and mainSel and mainSel == msgStr)
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

				local maxWidth, maxHeight = self.UIParent:GetSize()
				frame:SetMinResize(600, 500)
				frame:SetMaxResize(maxWidth - 50, maxHeight - 50)

				local status = frame.obj and frame.obj.status
				if status then
					local top, left = self:GetConfigPosition()
					if top and left then
						status.top, status.left = top, left

						ConfigOpen:ApplyStatus()
					end
				end

				hooksecurefunc(frame, "StopMovingOrSizing", AddOn.ConfigStopMovingOrSizing)
			end
		end

		if ACD and pages then
			ACD:SelectGroup(AddOnName, unpack(pages))
		end
	end

	GameTooltip:Hide() --Just in case you're mouseovered something and it closes.
end