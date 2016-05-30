local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local S = E:GetModule('Skins')

local ceil = math.ceil

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.misc ~= true then return end

	-- Blizzard frame we want to reskin
	local skins = {
		"StaticPopup1",
		"StaticPopup2",
		"StaticPopup3",
		"BNToastFrame",
		"TicketStatusFrameButton",
		"DropDownList1MenuBackdrop",
		"DropDownList2MenuBackdrop",
		"DropDownList1Backdrop",
		"DropDownList2Backdrop",
		"AutoCompleteBox",
		"ConsolidatedBuffsTooltip",
		"ReadyCheckFrame",
		"StackSplitFrame",
	}
	
	for i = 1, getn(skins) do
		_G[skins[i]]:SetTemplate("Transparent")
	end

	
	local ChatMenus = {
		"ChatMenu",
		"EmoteMenu",
		"LanguageMenu",
		"VoiceMacroMenu",		
	}
	--
	for i = 1, getn(ChatMenus) do
		if _G[ChatMenus[i]] == _G["ChatMenu"] then
			_G[ChatMenus[i]]:HookScript("OnShow", function(self) self:SetTemplate("Default", true) self:SetBackdropColor(unpack(E['media'].backdropfadecolor)) self:ClearAllPoints() self:Point("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 0, 30) end)
		else
			_G[ChatMenus[i]]:HookScript("OnShow", function(self) self:SetTemplate("Default", true) self:SetBackdropColor(unpack(E['media'].backdropfadecolor)) end)
		end
	end

	-- reskin popup buttons
	for i = 1, 3 do
		for j = 1, 3 do
			S:HandleButton(_G["StaticPopup"..i.."Button"..j])
			S:HandleEditBox(_G["StaticPopup"..i.."EditBox"])
			S:HandleEditBox(_G["StaticPopup"..i.."MoneyInputFrameGold"])
			S:HandleEditBox(_G["StaticPopup"..i.."MoneyInputFrameSilver"])
			S:HandleEditBox(_G["StaticPopup"..i.."MoneyInputFrameCopper"])
			_G["StaticPopup"..i.."EditBox"].backdrop:Point("TOPLEFT", -2, -4)
			_G["StaticPopup"..i.."EditBox"].backdrop:Point("BOTTOMRIGHT", 2, 4)
			_G["StaticPopup"..i.."ItemFrameNameFrame"]:Kill()
			_G["StaticPopup"..i.."ItemFrame"]:GetNormalTexture():Kill()
			_G["StaticPopup"..i.."ItemFrame"]:SetTemplate("Default")
			_G["StaticPopup"..i.."ItemFrame"]:StyleButton()
			_G["StaticPopup"..i.."ItemFrameIconTexture"]:SetTexCoord(unpack(E.TexCoords))
			_G["StaticPopup"..i.."ItemFrameIconTexture"]:ClearAllPoints()
			_G["StaticPopup"..i.."ItemFrameIconTexture"]:Point("TOPLEFT", 2, -2)
			_G["StaticPopup"..i.."ItemFrameIconTexture"]:Point("BOTTOMRIGHT", -2, 2)
		end
	end
	
	S:HandleCloseButton(StaticPopup1CloseButton)

	-- Return to Graveyard Button
	do
		S:HandleButton(GhostFrame)
		GhostFrame:SetBackdropColor(0,0,0,0)
		GhostFrame:SetBackdropBorderColor(0,0,0,0)

		local function forceBackdropColor(self, r, g, b, a)
			if r ~= 0 or g ~= 0 or b ~= 0 or a ~= 0 then
				GhostFrame:SetBackdropColor(0,0,0,0)
				GhostFrame:SetBackdropBorderColor(0,0,0,0)
			end
		end

		hooksecurefunc(GhostFrame, "SetBackdropColor", forceBackdropColor)
		hooksecurefunc(GhostFrame, "SetBackdropBorderColor", forceBackdropColor)

		GhostFrame:ClearAllPoints()
		GhostFrame:Point("TOP", E.UIParent, "TOP", 0, -150)
		S:HandleButton(GhostFrameContentsFrame)
		GhostFrameContentsFrameIcon:SetTexture(nil)
		local x = CreateFrame("Frame", nil, GhostFrame)
		x:SetFrameStrata("MEDIUM")
		x:SetTemplate("Default")
		x:SetOutside(GhostFrameContentsFrameIcon)
		local tex = x:CreateTexture(nil, "OVERLAY")
		tex:SetTexture("Interface\\Icons\\spell_holy_guardianspirit")
		tex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		tex:SetInside()
	end

	-- here we reskin all "normal" buttons
	local BlizzardButtons = {
		"VideoOptionsFrameOkay", 
		"VideoOptionsFrameCancel", 
		"VideoOptionsFrameDefaults", 
		"VideoOptionsFrameApply", 
		"InterfaceOptionsFrameDefaults", 
		"InterfaceOptionsFrameOkay", 
		"InterfaceOptionsFrameCancel",
		"StackSplitOkayButton",
		"StackSplitCancelButton",
		"RolePollPopupAcceptButton"
	}
	
	for i = 1, getn(BlizzardButtons) do
		local ElvuiButtons = _G[BlizzardButtons[i]]
		if ElvuiButtons then
			S:HandleButton(ElvuiButtons)
		end
	end

	-- BNToast Frame
	BNToastFrameCloseButton:Size(32);
	BNToastFrameCloseButton:Point("TOPRIGHT", "BNToastFrame", 4, 4);
	S:HandleCloseButton(BNToastFrameCloseButton);

	-- ReadyCheck Buttons
	S:HandleButton(ReadyCheckFrameYesButton)
	S:HandleButton(ReadyCheckFrameNoButton)
	ReadyCheckFrameYesButton:SetParent(ReadyCheckFrame)
	ReadyCheckFrameNoButton:SetParent(ReadyCheckFrame)
	ReadyCheckFrameYesButton:ClearAllPoints()
	ReadyCheckFrameNoButton:ClearAllPoints()
	ReadyCheckFrameYesButton:SetPoint("LEFT", ReadyCheckFrame, 15, -15)
	ReadyCheckFrameNoButton:SetPoint("RIGHT", ReadyCheckFrame, -15, -15)
	ReadyCheckFrameText:SetParent(ReadyCheckFrame)	
	ReadyCheckFrameText:ClearAllPoints()
	ReadyCheckFrameText:SetPoint("TOP", 0, 0)
	ReadyCheckFrame:SetWidth(290)
	ReadyCheckFrame:SetHeight(80)

	-- others
	ReadyCheckListenerFrame:SetAlpha(0)
	ReadyCheckFrame:HookScript("OnShow", function(self) if UnitIsUnit("player", self.initiator) then self:Hide() end end) -- bug fix, don't show it if initiator
	StackSplitFrame:GetRegions():Hide()

	RolePollPopup:SetTemplate("Transparent")
	S:HandleCloseButton(RolePollPopupCloseButton)

	-- ESC/Menu Buttons
	local BlizzardMenuButtons = {
		"Options",
		"UIOptions",
		"Keybindings",
		"Macros",
		"AddOns",
		"Logout",
		"Quit",
		"Continue",
		"Help"
	}
	
	for i = 1, getn(BlizzardMenuButtons) do
		local ElvuiMenuButtons = _G["GameMenuButton"..BlizzardMenuButtons[i]]
		if ElvuiMenuButtons then
			S:HandleButton(ElvuiMenuButtons)
		end
	end
	
	if IsAddOnLoaded("OptionHouse") then
		S:HandleButton(GameMenuButtonOptionHouse)
	end

	-- Options/Interface Buttons Position
	VideoOptionsFrameCancel:ClearAllPoints()
	VideoOptionsFrameCancel:SetPoint("RIGHT",VideoOptionsFrameApply,"LEFT",-4,0)		 
	VideoOptionsFrameOkay:ClearAllPoints()
	VideoOptionsFrameOkay:SetPoint("RIGHT",VideoOptionsFrameCancel,"LEFT",-4,0)
	InterfaceOptionsFrameOkay:ClearAllPoints()
	InterfaceOptionsFrameOkay:SetPoint("RIGHT",InterfaceOptionsFrameCancel,"LEFT", -4,0)

	-- Game Menu Options/Frames
	GameMenuFrame:StripTextures()
	GameMenuFrame:CreateBackdrop("Transparent")

	InterfaceOptionsFrame:StripTextures()
	InterfaceOptionsFrame:CreateBackdrop("Transparent")

	VideoOptionsFrame:StripTextures()
	VideoOptionsFrame:CreateBackdrop("Transparent")

	VideoOptionsFrameCategoryFrame:StripTextures()
	VideoOptionsFrameCategoryFrame:CreateBackdrop("Transparent")

	VideoOptionsFramePanelContainer:StripTextures()
	VideoOptionsFramePanelContainer:CreateBackdrop("Transparent")

	-- Game Menu Options/Graphics
	Graphics_RightQuality:StripTextures()
	S:HandleSliderFrame(Graphics_Quality)

	S:HandleDropDownBox(Graphics_DisplayModeDropDown
)
	S:HandleDropDownBox(Graphics_ResolutionDropDown
)
	S:HandleDropDownBox(Graphics_RefreshDropDown
)
	S:HandleDropDownBox(Graphics_PrimaryMonitorDropDown)
	S:HandleDropDownBox(Graphics_MultiSampleDropDown)
	S:HandleDropDownBox(Graphics_VerticalSyncDropDown)
	S:HandleDropDownBox(Graphics_TextureResolutionDropDown
)
	S:HandleDropDownBox(Graphics_FilteringDropDown
)
	S:HandleDropDownBox(Graphics_ProjectedTexturesDropDown
)
	S:HandleDropDownBox(Graphics_ViewDistanceDropDown
)
	S:HandleDropDownBox(Graphics_EnvironmentalDetailDropDown
)
	S:HandleDropDownBox(Graphics_GroundClutterDropDown
)
	S:HandleDropDownBox(Graphics_ShadowsDropDown
)
	S:HandleDropDownBox(Graphics_LiquidDetailDropDown
)
	S:HandleDropDownBox(Graphics_SunshaftsDropDown
)
	S:HandleDropDownBox(Graphics_ParticleDensityDropDown)

	-- Game Menu Options/Advanced
	S:HandleDropDownBox(Advanced_BufferingDropDown
)
	S:HandleDropDownBox(Advanced_LagDropDown
)
	S:HandleDropDownBox(Advanced_HardwareCursorDropDown
)
	S:HandleDropDownBox(Advanced_GraphicsAPIDropDown)

	S:HandleCheckBox(Advanced_MaxFPSCheckBox
)
	S:HandleCheckBox(Advanced_MaxFPSBKCheckBox
)
	S:HandleCheckBox(Advanced_UseUIScale)
	S:HandleCheckBox(Advanced_DesktopGamma)

	S:HandleSliderFrame(Advanced_MaxFPSSlider
)
	S:HandleSliderFrame(Advanced_UIScaleSlider
)
	S:HandleSliderFrame(Advanced_MaxFPSBKSlider)
	S:HandleSliderFrame(Advanced_GammaSlider
)

	-- Game Menu Options/Network
	S:HandleCheckBox(NetworkOptionsPanelOptimizeSpeed
)
	S:HandleCheckBox(NetworkOptionsPanelUseIPv6
)

	-- Game Menu Options/Languages
	S:HandleDropDownBox(InterfaceOptionsLanguagesPanelLocaleDropDown)

	-- Game Menu Options/Sound
	S:HandleCheckBox(AudioOptionsSoundPanelEnableSound)
	S:HandleCheckBox(AudioOptionsSoundPanelSoundEffects)
	S:HandleCheckBox(AudioOptionsSoundPanelErrorSpeech)
	S:HandleCheckBox(AudioOptionsSoundPanelEmoteSounds)
	S:HandleCheckBox(AudioOptionsSoundPanelPetSounds)
	S:HandleCheckBox(AudioOptionsSoundPanelMusic)
	S:HandleCheckBox(AudioOptionsSoundPanelLoopMusic)
	S:HandleCheckBox(AudioOptionsSoundPanelAmbientSounds)
	S:HandleCheckBox(AudioOptionsSoundPanelSoundInBG)
	S:HandleCheckBox(AudioOptionsSoundPanelReverb)
	S:HandleCheckBox(AudioOptionsSoundPanelHRTF)
	S:HandleCheckBox(AudioOptionsSoundPanelEnableDSPs)
	S:HandleCheckBox(AudioOptionsSoundPanelUseHardware)

	S:HandleSliderFrame(AudioOptionsSoundPanelSoundQuality)
	S:HandleSliderFrame(AudioOptionsSoundPanelAmbienceVolume)
	S:HandleSliderFrame(AudioOptionsSoundPanelMusicVolume)
	S:HandleSliderFrame(AudioOptionsSoundPanelSoundVolume)
	S:HandleSliderFrame(AudioOptionsSoundPanelMasterVolume)

	S:HandleDropDownBox(AudioOptionsSoundPanelHardwareDropDown)
	S:HandleDropDownBox(AudioOptionsSoundPanelSoundChannelsDropDown)

	AudioOptionsSoundPanelVolume:StripTextures()
	AudioOptionsSoundPanelVolume:CreateBackdrop("Transparent")

	AudioOptionsSoundPanelHardware:StripTextures()
	AudioOptionsSoundPanelHardware:CreateBackdrop("Transparent")

	AudioOptionsSoundPanelPlayback:StripTextures()
	AudioOptionsSoundPanelPlayback:CreateBackdrop("Transparent")

	-- Game Menu Interface
	InterfaceOptionsFrameCategories:StripTextures()
	InterfaceOptionsFrameCategories:CreateBackdrop("Transparent")

	InterfaceOptionsFramePanelContainer:StripTextures()
	InterfaceOptionsFramePanelContainer:CreateBackdrop("Transparent")

	InterfaceOptionsFrameAddOns:StripTextures()
	InterfaceOptionsFrameAddOns:CreateBackdrop("Transparent")


	-- Game Menu Interface/Tabs
	for i = 1, 2 do
 	   S:HandleTab(_G["InterfaceOptionsFrameTab" .. i]);
	   (_G["InterfaceOptionsFrameTab" .. i]):StripTextures()
	end

	-- Game Menu Interface/Controls
	S:HandleCheckBox(InterfaceOptionsControlsPanelStickyTargeting)
	S:HandleCheckBox(InterfaceOptionsControlsPanelAutoDismount)
	S:HandleCheckBox(InterfaceOptionsControlsPanelAutoClearAFK)
	S:HandleCheckBox(InterfaceOptionsControlsPanelBlockTrades)
	S:HandleCheckBox(InterfaceOptionsControlsPanelBlockGuildInvites)
	S:HandleCheckBox(InterfaceOptionsControlsPanelLootAtMouse)
	S:HandleCheckBox(InterfaceOptionsControlsPanelAutoLootCorpse)
	S:HandleCheckBox(InterfaceOptionsControlsPanelInteractOnLeftClick)

	S:HandleDropDownBox(InterfaceOptionsControlsPanelAutoLootKeyDropDown)

	-- Game Menu Interface/Combat
	S:HandleCheckBox(InterfaceOptionsCombatPanelAttackOnAssist)
	S:HandleCheckBox(InterfaceOptionsCombatPanelStopAutoAttack)
	S:HandleCheckBox(InterfaceOptionsCombatPanelNameplateClassColors)
	S:HandleCheckBox(InterfaceOptionsCombatPanelTargetOfTarget)
	S:HandleCheckBox(InterfaceOptionsCombatPanelShowSpellAlerts)
	S:HandleCheckBox(InterfaceOptionsCombatPanelReducedLagTolerance)
	S:HandleCheckBox(InterfaceOptionsCombatPanelActionButtonUseKeyDown)
	S:HandleCheckBox(InterfaceOptionsCombatPanelEnemyCastBarsOnPortrait)
	S:HandleCheckBox(InterfaceOptionsCombatPanelEnemyCastBarsOnNameplates)
	S:HandleCheckBox(InterfaceOptionsCombatPanelAutoSelfCast)

	S:HandleDropDownBox(InterfaceOptionsCombatPanelTOTDropDown)
	S:HandleDropDownBox(InterfaceOptionsCombatPanelFocusCastKeyDropDown)
	S:HandleDropDownBox(InterfaceOptionsCombatPanelSelfCastKeyDropDown)

	S:HandleSliderFrame(InterfaceOptionsCombatPanelSpellAlertOpacitySlider)
	S:HandleSliderFrame(InterfaceOptionsCombatPanelMaxSpellStartRecoveryOffset)

	-- Game Menu Interface/Display
	S:HandleCheckBox(InterfaceOptionsDisplayPanelShowCloak)
	S:HandleCheckBox(InterfaceOptionsDisplayPanelShowHelm)
	S:HandleCheckBox(InterfaceOptionsDisplayPanelShowAggroPercentage)
	S:HandleCheckBox(InterfaceOptionsDisplayPanelPlayAggroSounds)
	S:HandleCheckBox(InterfaceOptionsDisplayPanelDetailedLootInfo)
	S:HandleCheckBox(InterfaceOptionsDisplayPanelShowSpellPointsAvg)
	S:HandleCheckBox(InterfaceOptionsDisplayPanelScreenEdgeFlash)
	S:HandleCheckBox(InterfaceOptionsDisplayPanelRotateMinimap)
	S:HandleCheckBox(InterfaceOptionsDisplayPanelCinematicSubtitles)
	S:HandleCheckBox(InterfaceOptionsDisplayPanelShowFreeBagSpace)
	S:HandleCheckBox(InterfaceOptionsDisplayPanelemphasizeMySpellEffects)

	S:HandleDropDownBox(InterfaceOptionsDisplayPanelAggroWarningDisplay)
	S:HandleDropDownBox(InterfaceOptionsDisplayPanelWorldPVPObjectiveDisplay)

	-- Game Menu Interface/Objectives
	S:HandleCheckBox(InterfaceOptionsObjectivesPanelAutoQuestTracking)
	S:HandleCheckBox(InterfaceOptionsObjectivesPanelAutoQuestProgress)
	S:HandleCheckBox(InterfaceOptionsObjectivesPanelMapQuestDifficulty)
	S:HandleCheckBox(InterfaceOptionsObjectivesPanelWatchFrameWidth)

	-- Game Menu Interface/Social
	S:HandleCheckBox(InterfaceOptionsSocialPanelProfanityFilter)
	S:HandleCheckBox(InterfaceOptionsSocialPanelSpamFilter)
	S:HandleCheckBox(InterfaceOptionsSocialPanelChatBubbles)
	S:HandleCheckBox(InterfaceOptionsSocialPanelPartyChat)
	S:HandleCheckBox(InterfaceOptionsSocialPanelChatHoverDelay)
	S:HandleCheckBox(InterfaceOptionsSocialPanelGuildMemberAlert)
	S:HandleCheckBox(InterfaceOptionsSocialPanelChatMouseScroll)

	S:HandleDropDownBox(InterfaceOptionsSocialPanelWhisperMode)

	-- Game Menu Interface/Action Bars
	S:HandleCheckBox(InterfaceOptionsActionBarsPanelBottomLeft)
	S:HandleCheckBox(InterfaceOptionsActionBarsPanelBottomRight)
	S:HandleCheckBox(InterfaceOptionsActionBarsPanelRight)
	S:HandleCheckBox(InterfaceOptionsActionBarsPanelRightTwo)
	S:HandleCheckBox(InterfaceOptionsActionBarsPanelLockActionBars)
	S:HandleCheckBox(InterfaceOptionsActionBarsPanelAlwaysShowActionBars)
	S:HandleCheckBox(InterfaceOptionsActionBarsPanelSecureAbilityToggle)

	S:HandleDropDownBox(InterfaceOptionsActionBarsPanelPickupActionKeyDropDown)

	-- Game Menu Interface/Names
	S:HandleCheckBox(InterfaceOptionsNamesPanelGuilds)
	S:HandleCheckBox(InterfaceOptionsNamesPanelGuildTitles)
	S:HandleCheckBox(InterfaceOptionsNamesPanelTitles)
	S:HandleCheckBox(InterfaceOptionsNamesPanelNonCombatCreature)
	S:HandleCheckBox(InterfaceOptionsNamesPanelEnemyPlayerNames)
	S:HandleCheckBox(InterfaceOptionsNamesPanelEnemyPets)
	S:HandleCheckBox(InterfaceOptionsNamesPanelEnemyGuardians)
	S:HandleCheckBox(InterfaceOptionsNamesPanelEnemyTotems)
	S:HandleCheckBox(InterfaceOptionsNamesPanelUnitNameplatesEnemies)
	S:HandleCheckBox(InterfaceOptionsNamesPanelUnitNameplatesEnemyPets)
	S:HandleCheckBox(InterfaceOptionsNamesPanelUnitNameplatesEnemyGuardians)
	S:HandleCheckBox(InterfaceOptionsNamesPanelUnitNameplatesEnemyTotems)
	S:HandleCheckBox(InterfaceOptionsNamesPanelUnitNameplatesFriendlyTotems)
	S:HandleCheckBox(InterfaceOptionsNamesPanelUnitNameplatesFriendlyGuardians)
	S:HandleCheckBox(InterfaceOptionsNamesPanelUnitNameplatesFriendlyPets)
	S:HandleCheckBox(InterfaceOptionsNamesPanelUnitNameplatesFriends)
	S:HandleCheckBox(InterfaceOptionsNamesPanelFriendlyTotems)
	S:HandleCheckBox(InterfaceOptionsNamesPanelFriendlyGuardians)
	S:HandleCheckBox(InterfaceOptionsNamesPanelFriendlyPets)
	S:HandleCheckBox(InterfaceOptionsNamesPanelFriendlyPlayerNames)
	S:HandleCheckBox(InterfaceOptionsNamesPanelMyName)

	S:HandleDropDownBox(InterfaceOptionsNamesPanelNPCNamesDropDown)
	S:HandleDropDownBox(InterfaceOptionsNamesPanelUnitNameplatesMotionDropDown)

	-- Game Menu Interface/Floating Combat Text
	S:HandleCheckBox(InterfaceOptionsCombatTextPanelTargetDamage)
	S:HandleCheckBox(InterfaceOptionsCombatTextPanelPeriodicDamage)
	S:HandleCheckBox(InterfaceOptionsCombatTextPanelPetDamage)
	S:HandleCheckBox(InterfaceOptionsCombatTextPanelHealing)
	S:HandleCheckBox(InterfaceOptionsCombatTextPanelEnableFCT)
	S:HandleCheckBox(InterfaceOptionsCombatTextPanelDodgeParryMiss)
	S:HandleCheckBox(InterfaceOptionsCombatTextPanelDamageReduction)
	S:HandleCheckBox(InterfaceOptionsCombatTextPanelRepChanges)
	S:HandleCheckBox(InterfaceOptionsCombatTextPanelReactiveAbilities)
	S:HandleCheckBox(InterfaceOptionsCombatTextPanelFriendlyHealerNames)
	S:HandleCheckBox(InterfaceOptionsCombatTextPanelCombatState)
	S:HandleCheckBox(InterfaceOptionsCombatTextPanelAuras)
	S:HandleCheckBox(InterfaceOptionsCombatTextPanelHonorGains)
	S:HandleCheckBox(InterfaceOptionsCombatTextPanelPeriodicEnergyGains)
	S:HandleCheckBox(InterfaceOptionsCombatTextPanelEnergyGains)
	S:HandleCheckBox(InterfaceOptionsCombatTextPanelLowManaHealth)
	S:HandleCheckBox(InterfaceOptionsCombatTextPanelComboPoints)
	S:HandleCheckBox(InterfaceOptionsCombatTextPanelOtherTargetEffects)
	S:HandleCheckBox(InterfaceOptionsCombatTextPanelTargetEffects)

	S:HandleDropDownBox(InterfaceOptionsCombatTextPanelFCTDropDown)

	-- Game Menu Interface/Status Text
	S:HandleCheckBox(InterfaceOptionsStatusTextPanelPlayer)
	S:HandleCheckBox(InterfaceOptionsStatusTextPanelPet)
	S:HandleCheckBox(InterfaceOptionsStatusTextPanelParty)
	S:HandleCheckBox(InterfaceOptionsStatusTextPanelTarget)
	S:HandleCheckBox(InterfaceOptionsStatusTextPanelAlternateResource)
	S:HandleCheckBox(InterfaceOptionsStatusTextPanelPercentages)
	S:HandleCheckBox(InterfaceOptionsStatusTextPanelXP)

	-- Game Menu Interface/Unit Frames
	S:HandleCheckBox(InterfaceOptionsUnitFramePanelPartyBackground)
	S:HandleCheckBox(InterfaceOptionsUnitFramePanelPartyPets)
	S:HandleCheckBox(InterfaceOptionsUnitFramePanelArenaEnemyFrames)
	S:HandleCheckBox(InterfaceOptionsUnitFramePanelArenaEnemyCastBar)
	S:HandleCheckBox(InterfaceOptionsUnitFramePanelArenaEnemyPets)
	S:HandleCheckBox(InterfaceOptionsUnitFramePanelFullSizeFocusFrame)

	-- Game Menu Interface/Raid Profiles
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameKeepGroupsTogether)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameDisplayIncomingHeals)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameDisplayPowerBar)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameDisplayAggroHighlight)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameUseClassColors)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameDisplayPets)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameDisplayMainTankAndAssist)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameDisplayBorder)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameShowDebuffs)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameDisplayOnlyDispellableDebuffs)
	S:HandleCheckBox(CompactUnitFrameProfilesRaidStylePartyFrames)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate2Players)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate3Players)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate5Players)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate10Players)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate15Players)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate25Players)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate40Players)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec1)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec2)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvP)
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvE)

	S:HandleButton(CompactUnitFrameProfilesSaveButton)
	S:HandleButton(CompactUnitFrameProfilesDeleteButton)
	S:HandleButton(CompactUnitFrameProfilesGeneralOptionsFrameResetPositionButton)

	S:HandleSliderFrame(CompactUnitFrameProfilesGeneralOptionsFrameHeightSlider)
	S:HandleSliderFrame(CompactUnitFrameProfilesGeneralOptionsFrameWidthSlider)

	S:HandleDropDownBox(CompactUnitFrameProfilesGeneralOptionsFrameSortByDropdown
)
	S:HandleDropDownBox(CompactUnitFrameProfilesProfileSelector
)
	S:HandleDropDownBox(CompactUnitFrameProfilesGeneralOptionsFrameHealthTextDropdown)

	-- Game Menu Interface/Buffs and Debuffs
	S:HandleCheckBox(InterfaceOptionsBuffsPanelBuffDurations)
	S:HandleCheckBox(InterfaceOptionsBuffsPanelDispellableDebuffs)
	S:HandleCheckBox(InterfaceOptionsBuffsPanelCastableBuffs)
	S:HandleCheckBox(InterfaceOptionsBuffsPanelConsolidateBuffs)
	S:HandleCheckBox(InterfaceOptionsBuffsPanelShowAllEnemyDebuffs)

	-- Game Menu Interface/Camera
	S:HandleCheckBox(InterfaceOptionsCameraPanelFollowTerrain)
	S:HandleCheckBox(InterfaceOptionsCameraPanelHeadBob)
	S:HandleCheckBox(InterfaceOptionsCameraPanelWaterCollision)
	S:HandleCheckBox(InterfaceOptionsCameraPanelSmartPivot)

	S:HandleSliderFrame(InterfaceOptionsCameraPanelMaxDistanceSlider)
	S:HandleSliderFrame(InterfaceOptionsCameraPanelFollowSpeedSlider)

	S:HandleDropDownBox(InterfaceOptionsCameraPanelStyleDropDown)

	-- Game Menu Interface/Mouse
	S:HandleCheckBox(InterfaceOptionsMousePanelInvertMouse)
	S:HandleCheckBox(InterfaceOptionsMousePanelClickToMove)
	S:HandleCheckBox(InterfaceOptionsMousePanelWoWMouse)

	S:HandleSliderFrame(InterfaceOptionsMousePanelMouseSensitivitySlider)
	S:HandleSliderFrame(InterfaceOptionsMousePanelMouseLookSpeedSlider)

	S:HandleDropDownBox(InterfaceOptionsMousePanelClickMoveStyleDropDown)

	-- Game Menu Interface/Help
	S:HandleCheckBox(InterfaceOptionsHelpPanelShowTutorials)
	S:HandleCheckBox(InterfaceOptionsHelpPanelLoadingScreenTips)
	S:HandleCheckBox(InterfaceOptionsHelpPanelEnhancedTooltips)
	S:HandleCheckBox(InterfaceOptionsHelpPanelBeginnerTooltips)
	S:HandleCheckBox(InterfaceOptionsHelpPanelShowLuaErrors)
	S:HandleCheckBox(InterfaceOptionsHelpPanelColorblindMode)
	S:HandleCheckBox(InterfaceOptionsHelpPanelMovePad)

	S:HandleButton(InterfaceOptionsHelpPanelResetTutorials)

	-- Interface Enable Mouse Move
	InterfaceOptionsFrame:SetClampedToScreen(true)
	InterfaceOptionsFrame:SetMovable(true)
	InterfaceOptionsFrame:EnableMouse(true)
	InterfaceOptionsFrame:RegisterForDrag("LeftButton", "RightButton")
	InterfaceOptionsFrame:SetScript("OnDragStart", function(self) 
		if InCombatLockdown() then return end
		
		if IsShiftKeyDown() then
			self:StartMoving() 
		end
	end)
	InterfaceOptionsFrame:SetScript("OnDragStop", function(self) 
		self:StopMovingOrSizing()
	end)

	--Watch Frame
	WatchFrameCollapseExpandButton:StripTextures()
	S:HandleCloseButton(WatchFrameCollapseExpandButton)
	WatchFrameCollapseExpandButton.backdrop:SetAllPoints()
	WatchFrameCollapseExpandButton.text:SetText('-')
	WatchFrameCollapseExpandButton:SetFrameStrata('MEDIUM')
	
	hooksecurefunc('WatchFrame_Expand', function()
		WatchFrameCollapseExpandButton.text:SetText('-')
	end)
	
	hooksecurefunc('WatchFrame_Collapse', function()
		WatchFrameCollapseExpandButton.text:SetText('+')
	end)	
	
	local function SkinWatchFrameItems()
		for i=1, WATCHFRAME_NUM_ITEMS do
			local button = _G["WatchFrameItem"..i]
			if not button.skinned then
				button:CreateBackdrop('Default')
				button.backdrop:SetAllPoints()
				button:StyleButton()
				_G["WatchFrameItem"..i.."NormalTexture"]:SetAlpha(0)
				_G["WatchFrameItem"..i.."IconTexture"]:SetInside()
				_G["WatchFrameItem"..i.."IconTexture"]:SetTexCoord(unpack(E.TexCoords))
				E:RegisterCooldown(_G["WatchFrameItem"..i.."Cooldown"])
				button.skinned = true
			end
		end
	end
	
	WatchFrame:HookScript("OnEvent", SkinWatchFrameItems)

	--Chat Config
	ChatConfigFrame:StripTextures();
	ChatConfigFrame:SetTemplate("Transparent");
	ChatConfigCategoryFrame:SetTemplate("Transparent");
	ChatConfigBackgroundFrame:SetTemplate("Transparent");
	
	ChatConfigChatSettingsClassColorLegend:SetTemplate("Transparent");
	ChatConfigChannelSettingsClassColorLegend:SetTemplate("Transparent");
	
	ChatConfigCombatSettingsFilters:SetTemplate("Transparent");
	
	ChatConfigCombatSettingsFiltersScrollFrame:StripTextures();
	S:HandleScrollBar(ChatConfigCombatSettingsFiltersScrollFrameScrollBar);
	
	S:HandleButton(ChatConfigCombatSettingsFiltersDeleteButton);
	S:HandleButton(ChatConfigCombatSettingsFiltersAddFilterButton);
	ChatConfigCombatSettingsFiltersAddFilterButton:Point("RIGHT", ChatConfigCombatSettingsFiltersDeleteButton, "LEFT", -1, 0);
	S:HandleButton(ChatConfigCombatSettingsFiltersCopyFilterButton);
	ChatConfigCombatSettingsFiltersCopyFilterButton:Point("RIGHT", ChatConfigCombatSettingsFiltersAddFilterButton, "LEFT", -1, 0);
	
	S:HandleNextPrevButton(ChatConfigMoveFilterUpButton, true);
	S:SquareButton_SetIcon(ChatConfigMoveFilterUpButton, "UP");
	ChatConfigMoveFilterUpButton:Size(26);
	ChatConfigMoveFilterUpButton:Point("TOPLEFT", ChatConfigCombatSettingsFilters, "BOTTOMLEFT", 3, -1);
	S:HandleNextPrevButton(ChatConfigMoveFilterDownButton, true);
	ChatConfigMoveFilterDownButton:Size(26);
	ChatConfigMoveFilterDownButton:Point("LEFT", ChatConfigMoveFilterUpButton, "RIGHT", 1, 0);
	
	CombatConfigColorsHighlighting:StripTextures();
	CombatConfigColorsColorizeUnitName:StripTextures();
	CombatConfigColorsColorizeSpellNames:StripTextures();
	
	CombatConfigColorsColorizeDamageNumber:StripTextures();
	CombatConfigColorsColorizeDamageSchool:StripTextures();
	CombatConfigColorsColorizeEntireLine:StripTextures();
	
	S:HandleEditBox(CombatConfigSettingsNameEditBox);
	
	S:HandleButton(CombatConfigSettingsSaveButton);
	
	local combatConfigCheck = {
		"CombatConfigColorsHighlightingLine",
		"CombatConfigColorsHighlightingAbility",
		"CombatConfigColorsHighlightingDamage",
		"CombatConfigColorsHighlightingSchool",
		"CombatConfigColorsColorizeUnitNameCheck",
		"CombatConfigColorsColorizeSpellNamesCheck",
		"CombatConfigColorsColorizeSpellNamesSchoolColoring",
		"CombatConfigColorsColorizeDamageNumberCheck",
		"CombatConfigColorsColorizeDamageNumberSchoolColoring",
		"CombatConfigColorsColorizeDamageSchoolCheck",
		"CombatConfigColorsColorizeEntireLineCheck",
		"CombatConfigFormattingShowTimeStamp",
		"CombatConfigFormattingShowBraces",
		"CombatConfigFormattingUnitNames",
		"CombatConfigFormattingSpellNames",
		"CombatConfigFormattingItemNames",
		"CombatConfigFormattingFullText",
		"CombatConfigSettingsShowQuickButton",
		"CombatConfigSettingsSolo",
		"CombatConfigSettingsParty",
		"CombatConfigSettingsRaid"
	};
	
	for i = 1, getn(combatConfigCheck) do
		S:HandleCheckBox(_G[combatConfigCheck[i]]);
	end
	
	for i = 1, 5 do
		local tab = _G["CombatConfigTab"..i];
		tab:StripTextures();
		
		tab:CreateBackdrop("Default", true);
		tab.backdrop:Point("TOPLEFT", 1, -10);
		tab.backdrop:Point("BOTTOMRIGHT", -1, 2);
		
		tab:HookScript("OnEnter", S.SetModifiedBackdrop);
		tab:HookScript("OnLeave", S.SetOriginalBackdrop);
	end
	
	S:HandleButton(ChatConfigFrameDefaultButton);
	S:HandleButton(CombatLogDefaultButton);
	S:HandleButton(ChatConfigFrameCancelButton);
	S:HandleButton(ChatConfigFrameOkayButton);
	
	S:SecureHook("ChatConfig_CreateCheckboxes", function(frame, checkBoxTable, checkBoxTemplate)
		local checkBoxNameString = frame:GetName().."CheckBox";
		if(checkBoxTemplate == "ChatConfigCheckBoxTemplate") then
			frame:SetTemplate("Transparent");
			for index, value in ipairs(checkBoxTable) do
				local checkBoxName = checkBoxNameString..index;
				local checkbox = _G[checkBoxName];
				if(not checkbox.backdrop) then
					checkbox:StripTextures();
					checkbox:CreateBackdrop();
					checkbox.backdrop:Point("TOPLEFT", 3, -1);
					checkbox.backdrop:Point("BOTTOMRIGHT", -3, 1);
					checkbox.backdrop:SetFrameLevel(checkbox:GetParent():GetFrameLevel() + 1);
					
					S:HandleCheckBox(_G[checkBoxName.."Check"]);
				end
			end
		elseif(checkBoxTemplate == "ChatConfigCheckBoxWithSwatchTemplate") or (checkBoxTemplate == "ChatConfigCheckBoxWithSwatchAndClassColorTemplate") then
			frame:SetTemplate("Transparent");
			for index, value in ipairs(checkBoxTable) do
				local checkBoxName = checkBoxNameString..index;
				local checkbox = _G[checkBoxName];
				if(not checkbox.backdrop) then
					checkbox:StripTextures();
					
					checkbox:CreateBackdrop();
					checkbox.backdrop:Point("TOPLEFT", 3, -1);
					checkbox.backdrop:Point("BOTTOMRIGHT", -3, 1);
					checkbox.backdrop:SetFrameLevel(checkbox:GetParent():GetFrameLevel() + 1);
					
					S:HandleCheckBox(_G[checkBoxName.."Check"]);
					
					if(checkBoxTemplate == "ChatConfigCheckBoxWithSwatchAndClassColorTemplate") then
						S:HandleCheckBox(_G[checkBoxName.."ColorClasses"]);
					end
				end
			end
		end
	end);
	
	S:SecureHook("ChatConfig_CreateTieredCheckboxes", function(frame, checkBoxTable, checkBoxTemplate, subCheckBoxTemplate)
		local checkBoxNameString = frame:GetName().."CheckBox";
		for index, value in ipairs(checkBoxTable) do
			local checkBoxName = checkBoxNameString..index;
			if(_G[checkBoxName]) then
				S:HandleCheckBox(_G[checkBoxName]);
				if(value.subTypes) then
					local subCheckBoxNameString = checkBoxName.."_";
					for k, v in ipairs(value.subTypes) do
						local subCheckBoxName = subCheckBoxNameString..k;
						if(_G[subCheckBoxName]) then
							S:HandleCheckBox(_G[subCheckBoxNameString..k]);
						end
					end
				end
			end
		end
	end);
	
	S:SecureHook("ChatConfig_CreateColorSwatches", function(frame, swatchTable, swatchTemplate)
		frame:SetTemplate("Transparent");
		local nameString = frame:GetName().."Swatch";
		for index, value in ipairs(swatchTable) do
			local swatchName = nameString..index;
			local swatch = _G[swatchName];
			if(not swatch.backdrop) then
				swatch:StripTextures();
				
				swatch:CreateBackdrop();
				swatch.backdrop:Point("TOPLEFT", 3, -1);
				swatch.backdrop:Point("BOTTOMRIGHT", -3, 1);
				swatch.backdrop:SetFrameLevel(swatch:GetParent():GetFrameLevel() + 1);
			end
		end
	end);

	--DROPDOWN MENU
	hooksecurefunc("UIDropDownMenu_InitializeHelper", function(frame)
		for i = 1, UIDROPDOWNMENU_MAXLEVELS do
			_G["DropDownList"..i.."Backdrop"]:SetTemplate("Default", true)
			_G["DropDownList"..i.."MenuBackdrop"]:SetTemplate("Default", true)
		end
	end)


	--LFD Role Picker PopUp Frame
	LFDRoleCheckPopup:StripTextures()
	LFDRoleCheckPopup:SetTemplate("Transparent")
	S:HandleButton(LFDRoleCheckPopupAcceptButton)
	S:HandleButton(LFDRoleCheckPopupDeclineButton)
	S:HandleCheckBox(LFDRoleCheckPopupRoleButtonTank:GetChildren())
	S:HandleCheckBox(LFDRoleCheckPopupRoleButtonDPS:GetChildren())
	S:HandleCheckBox(LFDRoleCheckPopupRoleButtonHealer:GetChildren())
	LFDRoleCheckPopupRoleButtonTank:GetChildren():SetFrameLevel(LFDRoleCheckPopupRoleButtonTank:GetChildren():GetFrameLevel() + 1)
	LFDRoleCheckPopupRoleButtonDPS:GetChildren():SetFrameLevel(LFDRoleCheckPopupRoleButtonDPS:GetChildren():GetFrameLevel() + 1)
	LFDRoleCheckPopupRoleButtonHealer:GetChildren():SetFrameLevel(LFDRoleCheckPopupRoleButtonHealer:GetChildren():GetFrameLevel() + 1)

	--Compact Raid Frame Manager (Not Finished)
	CompactRaidFrameManager:StripTextures()
	CompactRaidFrameManager:SetTemplate("Transparent")
	CompactRaidFrameManagerDisplayFrame:StripTextures()
	CompactRaidFrameManagerDisplayFrameFilterOptions:StripTextures()

	S:HandleButton(CompactRaidFrameManagerDisplayFrameHiddenModeToggle)
	S:HandleButton(CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll)
	S:HandleButton(CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck)
	S:HandleButton(CompactRaidFrameManagerDisplayFrameLockedModeToggle)
	S:HandleButton(CompactRaidFrameManagerDisplayFrameConvertToRaid)
	S:HandleButton(CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup1)
	S:HandleButton(CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup2)
	S:HandleButton(CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup3)
	S:HandleButton(CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup4)
	S:HandleButton(CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup5)
	S:HandleButton(CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup6)
	S:HandleButton(CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup7)
	S:HandleButton(CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup8)
	S:HandleButton(CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleDamager)
	S:HandleButton(CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleHealer)
	S:HandleButton(CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleTank)

	S:HandleButton(CompactRaidFrameManagerToggleButton)
	CompactRaidFrameManagerToggleButton:SetHeight(40)
	CompactRaidFrameManagerToggleButton:SetWidth(15)
	CompactRaidFrameManagerToggleButton:Point("RIGHT", CompactRaidFrameManager, "RIGHT", -3, -15);

	S:HandleCheckBox(CompactRaidFrameManagerDisplayFrameEveryoneIsAssistButton)

	S:HandleDropDownBox(CompactRaidFrameManagerDisplayFrameProfileSelector)

	--NavBar Buttons (Used in WorldMapFrame, EncounterJournal and HelpFrame)
	local function SkinNavBarButtons(self)
		if (self:GetParent():GetName() == "EncounterJournal" and not E.private.skins.blizzard.encounterjournal) or (self:GetParent():GetName() == "HelpFrameKnowledgebase" and not E.private.skins.blizzard.help) then
			return
		end
		local navButton = self.navList[#self.navList]
		if navButton and not navButton.isSkinned then
			S:HandleButton(navButton, true)
			if navButton.MenuArrowButton then
				S:HandleNextPrevButton(navButton.MenuArrowButton, true)
			end

			navButton.xoffset = 1 --Make a 1px gap between each navbutton
			navButton.isSkinned = true
		end
	end
	hooksecurefunc("NavBar_AddButton", SkinNavBarButtons)
	
	--This is necessary to fix position of button right next to homebutton.
	local function SetHomeButtonOffsetX(self)
		local homeButton = self.homeButton
		if homeButton then
			homeButton.xoffset = 1
		end
	end
	hooksecurefunc("NavBar_Initialize", SetHomeButtonOffsetX)

	--Guild Invitation PopUp Frame
	GuildInviteFrame:StripTextures()
	GuildInviteFrame:SetTemplate("Transparent")

	S:HandleButton(GuildInviteFrameJoinButton)
	S:HandleButton(GuildInviteFrameDeclineButton)

	--Move Pad Frame
	MovePadFrame:StripTextures()
	MovePadFrame:SetTemplate("Transparent")

	S:HandleButton(MovePadStrafeLeft)
	S:HandleButton(MovePadStrafeRight)
	S:HandleButton(MovePadForward)
	S:HandleButton(MovePadBackward)
	S:HandleButton(MovePadJump)

	S:HandleButton(MovePadLock) --Require to fix Text
	MovePadLock:StripTextures()
	MovePadLock:SetScale(0.70)
	MovePadLock:Point("BOTTOMRIGHT", MovePadFrame, "BOTTOMRIGHT", -4, 4);
end

S:RegisterSkin('ElvUI', LoadSkin)