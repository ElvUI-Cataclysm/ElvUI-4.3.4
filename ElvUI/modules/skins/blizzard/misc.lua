local E, L, V, P, G, _ = unpack(select(2, ...));
local S = E:GetModule('Skins')

local find = string.find;

local _G = _G
local unpack = unpack

local UnitIsUnit = UnitIsUnit
local UIDROPDOWNMENU_MAXLEVELS = UIDROPDOWNMENU_MAXLEVELS

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.misc ~= true then return end

	-- Blizzard frame we want to reskin
	local skins = {
		"StaticPopup1",
		"StaticPopup2",
		"StaticPopup3",
		"StaticPopup4",
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

	for i = 1, getn(ChatMenus) do
		if _G[ChatMenus[i]] == _G["ChatMenu"] then
			_G[ChatMenus[i]]:HookScript("OnShow", function(self) self:SetTemplate("Default", true) self:SetBackdropColor(unpack(E['media'].backdropfadecolor)) self:ClearAllPoints() self:Point("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 0, 30) end)
		else
			_G[ChatMenus[i]]:HookScript("OnShow", function(self) self:SetTemplate("Default", true) self:SetBackdropColor(unpack(E['media'].backdropfadecolor)) end)
		end
	end

	-- reskin popup buttons
	for i = 1, 4 do
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
	ReadyCheckFrameText:SetTextColor(1, 1, 1)
	ReadyCheckFrame:SetWidth(290)
	ReadyCheckFrame:SetHeight(80)

	-- others
	CoinPickupFrame:StripTextures();
	CoinPickupFrame:SetTemplate("Transparent");

	S:HandleButton(CoinPickupOkayButton);
	S:HandleButton(CoinPickupCancelButton);

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

	OpacityFrame:StripTextures()
	OpacityFrame:SetTemplate("Transparent")
	S:HandleSliderFrame(OpacityFrameSlider)

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

	S:HandleDropDownBox(Graphics_DisplayModeDropDown)
	S:HandleDropDownBox(Graphics_ResolutionDropDown)
	S:HandleDropDownBox(Graphics_RefreshDropDown)
	S:HandleDropDownBox(Graphics_PrimaryMonitorDropDown)
	S:HandleDropDownBox(Graphics_MultiSampleDropDown)
	S:HandleDropDownBox(Graphics_VerticalSyncDropDown)
	S:HandleDropDownBox(Graphics_TextureResolutionDropDown)
	S:HandleDropDownBox(Graphics_FilteringDropDown)
	S:HandleDropDownBox(Graphics_ProjectedTexturesDropDown)
	S:HandleDropDownBox(Graphics_ViewDistanceDropDown)
	S:HandleDropDownBox(Graphics_EnvironmentalDetailDropDown)
	S:HandleDropDownBox(Graphics_GroundClutterDropDown)
	S:HandleDropDownBox(Graphics_ShadowsDropDown)
	S:HandleDropDownBox(Graphics_LiquidDetailDropDown)
	S:HandleDropDownBox(Graphics_SunshaftsDropDown)
	S:HandleDropDownBox(Graphics_ParticleDensityDropDown)

	-- Game Menu Options/Advanced
	S:HandleDropDownBox(Advanced_BufferingDropDown)
	S:HandleDropDownBox(Advanced_LagDropDown)
	S:HandleDropDownBox(Advanced_HardwareCursorDropDown)
	S:HandleDropDownBox(Advanced_GraphicsAPIDropDown)

	S:HandleCheckBox(Advanced_MaxFPSCheckBox)
	S:HandleCheckBox(Advanced_MaxFPSBKCheckBox)
	S:HandleCheckBox(Advanced_UseUIScale)
	S:HandleCheckBox(Advanced_DesktopGamma)

	S:HandleSliderFrame(Advanced_MaxFPSSlider)
	S:HandleSliderFrame(Advanced_UIScaleSlider)
	S:HandleSliderFrame(Advanced_MaxFPSBKSlider)
	S:HandleSliderFrame(Advanced_GammaSlider)

	-- Game Menu Options/Network
	S:HandleCheckBox(NetworkOptionsPanelOptimizeSpeed)
	S:HandleCheckBox(NetworkOptionsPanelUseIPv6)

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

	InterfaceOptionsFrameCategoriesList:StripTextures();
	S:HandleScrollBar(InterfaceOptionsFrameCategoriesListScrollBar);

	InterfaceOptionsFrameAddOnsList:StripTextures();
	S:HandleScrollBar(InterfaceOptionsFrameAddOnsListScrollBar);

	-- Game Menu Interface/Tabs
	for i = 1, 2 do
 	   S:HandleTab(_G["InterfaceOptionsFrameTab" .. i]);
	   (_G["InterfaceOptionsFrameTab" .. i]):StripTextures()
	end

	local maxButtons = (InterfaceOptionsFrameAddOns:GetHeight() - 8) / InterfaceOptionsFrameAddOns.buttonHeight;
	for i = 1, maxButtons do
		local buttonToggle = _G["InterfaceOptionsFrameAddOnsButton" .. i .. "Toggle"];
		buttonToggle:SetNormalTexture("");
		buttonToggle.SetNormalTexture = E.noop;
		buttonToggle:SetPushedTexture("");
		buttonToggle.SetPushedTexture = E.noop;
		buttonToggle:SetHighlightTexture(nil);

		buttonToggle.Text = buttonToggle:CreateFontString(nil, "OVERLAY");
		buttonToggle.Text:FontTemplate(nil, 22);
		buttonToggle.Text:Point("CENTER");
		buttonToggle.Text:SetText("+");

		hooksecurefunc(buttonToggle, "SetNormalTexture", function(self, texture)
			if(find(texture, "MinusButton")) then
				self.Text:SetText("-");
			else
				self.Text:SetText("+");
			end
		end);
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
	S:HandleCheckBox(CompactUnitFrameProfilesGeneralOptionsFrameHorizontalGroups)
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

	S:HandleDropDownBox(CompactUnitFrameProfilesGeneralOptionsFrameSortByDropdown)
	S:HandleDropDownBox(CompactUnitFrameProfilesProfileSelector)
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

	local function SkinWatchFramePopUp()
		if WatchFrameAutoQuestPopUp1 then
			WatchFrameLines:StripTextures()
			WatchFrameAutoQuestPopUp1ScrollChildBg:Kill()
			WatchFrameAutoQuestPopUp1ScrollChildQuestIconBg:Kill()
			WatchFrameAutoQuestPopUp1ScrollChildFlash:Kill()
			WatchFrameAutoQuestPopUp1ScrollChildShine:Kill()
			WatchFrameAutoQuestPopUp1ScrollChildIconShine:Kill()
			WatchFrameAutoQuestPopUp1ScrollChildFlashIconFlash:Kill()
			WatchFrameAutoQuestPopUp1ScrollChildBorderBotLeft:Kill()
			WatchFrameAutoQuestPopUp1ScrollChildBorderBotRight:Kill()
			WatchFrameAutoQuestPopUp1ScrollChildBorderBottom:Kill()
			WatchFrameAutoQuestPopUp1ScrollChildBorderLeft:Kill()
			WatchFrameAutoQuestPopUp1ScrollChildBorderRight:Kill()
			WatchFrameAutoQuestPopUp1ScrollChildBorderTop:Kill()
			WatchFrameAutoQuestPopUp1ScrollChildBorderTopLeft:Kill()
			WatchFrameAutoQuestPopUp1ScrollChildBorderTopRight:Kill()

			WatchFrameAutoQuestPopUp1:CreateBackdrop("Transparent", true, true)
			WatchFrameAutoQuestPopUp1.backdrop:SetBackdropBorderColor(0, 0.44, .87, 1)
			WatchFrameAutoQuestPopUp1.backdrop:CreateShadow()
		end
	end
	WatchFrame:HookScript("OnEvent", SkinWatchFramePopUp)

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

	S:SecureHook("ChatConfig_CreateTieredCheckboxes", function(frame, checkBoxTable)
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

	S:SecureHook("ChatConfig_CreateColorSwatches", function(frame, swatchTable)
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
	hooksecurefunc("UIDropDownMenu_InitializeHelper", function()
		for i = 1, UIDROPDOWNMENU_MAXLEVELS do
			_G["DropDownList"..i.."Backdrop"]:SetTemplate("Transparent", true)
			_G["DropDownList"..i.."MenuBackdrop"]:SetTemplate("Transparent", true)
			for j = 1, UIDROPDOWNMENU_MAXBUTTONS do
				_G["DropDownList"..i.."Button"..j.."Highlight"]:SetTexture(1, 1, 1, 0.3)
			end
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
	GuildInviteFrame:SetTemplate("Transparent")
	GuildInviteFrameBg:Kill()
	GuildInviteFrameTopLeftCorner:Kill()
	GuildInviteFrameTopRightCorner:Kill()
	GuildInviteFrameBottomLeftCorner:Kill()
	GuildInviteFrameBottomRightCorner:Kill()
	GuildInviteFrameTopBorder:Kill()
	GuildInviteFrameBottomBorder:Kill()
	GuildInviteFrameLeftBorder:Kill()
	GuildInviteFrameRightBorder:Kill()
	GuildInviteFrameBackground:Kill()
	GuildInviteFrameTabardBorder:Kill()
	GuildInviteFrameTabardRing:Kill()

	S:HandleButton(GuildInviteFrameJoinButton)
	S:HandleButton(GuildInviteFrameDeclineButton)

	--Report Player
	ReportCheatingDialog:StripTextures()
	ReportCheatingDialog:SetTemplate("Transparent")
	ReportCheatingDialogCommentFrame:StripTextures()
	S:HandleEditBox(ReportCheatingDialogCommentFrameEditBox)
	S:HandleButton(ReportCheatingDialogReportButton)
	S:HandleButton(ReportCheatingDialogCancelButton)

	ReportPlayerNameDialog:StripTextures()
	ReportPlayerNameDialog:SetTemplate("Transparent")
	ReportPlayerNameDialogCommentFrame:StripTextures()
	S:HandleEditBox(ReportPlayerNameDialogCommentFrameEditBox)
	S:HandleButton(ReportPlayerNameDialogCancelButton)
	S:HandleButton(ReportPlayerNameDialogReportButton)

	-- Cinematic Popup
	CinematicFrameCloseDialog:StripTextures()
	CinematicFrameCloseDialog:SetTemplate("Transparent")
	CinematicFrameCloseDialog:SetScale(UIParent:GetScale())
	S:HandleButton(CinematicFrameCloseDialogConfirmButton)
	S:HandleButton(CinematicFrameCloseDialogResumeButton)

	-- Level Up Popup
	LevelUpDisplay:StripTextures()
	LevelUpDisplayLevelFrame:StripTextures()
	LevelUpDisplaySpellFrame:StripTextures()
	LevelUpDisplaySpellFrameIcon:SetTexCoord(unpack(E.TexCoords))
	LevelUpDisplaySpellFrameSubIcon:SetTexCoord(unpack(E.TexCoords))

	--Minimap GM Ticket Button
	local ticketbutton = HelpOpenTicketButton
	local ticketbuttonIcon = ticketbutton:GetNormalTexture()
	local ticketbuttonPushed = ticketbutton:GetPushedTexture()

	ticketbutton:StripTextures()
	S:HandleButton(ticketbutton)
	ticketbutton:CreateBackdrop("Default")
	ticketbutton:Size(30)

	ticketbuttonIcon:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-Blizz")
	ticketbuttonIcon:ClearAllPoints()
	ticketbuttonIcon:SetPoint("CENTER", HelpOpenTicketButton, "CENTER", 0, 0)
	ticketbuttonIcon:SetTexCoord(unpack(E.TexCoords))

	ticketbuttonPushed:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-Blizz")
	ticketbuttonPushed:ClearAllPoints()
	ticketbuttonPushed:SetTexCoord(unpack(E.TexCoords))
	ticketbuttonPushed:SetPoint("CENTER", HelpOpenTicketButton, "CENTER", 0, 0)

	--Minimap PVP Queue Button
	local battlefieldButton = MiniMapBattlefieldFrame

	battlefieldButton:StripTextures()
	battlefieldButton:CreateBackdrop("Default")
	battlefieldButton:Size(30)

	battlefieldButton.texture = battlefieldButton:CreateTexture(nil, "OVERLAY");
	if UnitFactionGroup("player") == "Horde" then
		battlefieldButton.texture:SetTexture("Interface\\Icons\\PVPCurrency-Honor-Horde")
	elseif UnitFactionGroup("player") == "Alliance" then
		battlefieldButton.texture:SetTexture("Interface\\Icons\\PVPCurrency-Honor-Alliance")
	end
	battlefieldButton.texture:SetTexCoord(unpack(E.TexCoords))
	battlefieldButton.texture:SetInside(battlefieldButton.backdrop)

	--Minimap ZoomIn/ZoomOut Buttons
	S:HandleCloseButton(MinimapZoomIn)
	MinimapZoomIn.text:SetText('+')
	MinimapZoomIn:Size(40)
	MinimapZoomIn:SetFrameStrata('MEDIUM')

	S:HandleCloseButton(MinimapZoomOut)
	MinimapZoomOut.text:SetText('-')
	MinimapZoomOut:Size(40)
	MinimapZoomOut:SetFrameStrata('MEDIUM')

	--Role Icons
	--Dungeon Finder Role Icons
	LFDQueueFrameRoleButtonTank:Point("BOTTOMLEFT", LFDQueueFrame, "BOTTOMLEFT", 25, 334)
	LFDQueueFrameRoleButtonHealer:Point("LEFT", LFDQueueFrameRoleButtonTank,"RIGHT", 23, 0)
	LFDQueueFrameRoleButtonLeader:Point("LEFT", LFDQueueFrameRoleButtonDPS, "RIGHT", 50, 0)

	LFDQueueFrameRoleButtonTank:StripTextures()
	LFDQueueFrameRoleButtonTank:CreateBackdrop("Default", true, true);
	LFDQueueFrameRoleButtonTank.backdrop:SetTemplate("Default", true, true);
	LFDQueueFrameRoleButtonTank.backdrop:Point("TOPLEFT", LFDQueueFrameRoleButtonTank, "TOPLEFT", 3, -3)
	LFDQueueFrameRoleButtonTank.backdrop:Point("BOTTOMRIGHT", LFDQueueFrameRoleButtonTank, "BOTTOMRIGHT", -3, 3)
	LFDQueueFrameRoleButtonTank.icon = LFDQueueFrameRoleButtonTank:CreateTexture(nil, "OVERLAY");
	LFDQueueFrameRoleButtonTank.icon:SetTexCoord(unpack(E.TexCoords))
	LFDQueueFrameRoleButtonTank.icon:SetTexture('Interface\\Icons\\Ability_Defend');
	LFDQueueFrameRoleButtonTank.icon:SetInside(LFDQueueFrameRoleButtonTank.backdrop)

	LFDQueueFrameRoleButtonHealer:StripTextures()
	LFDQueueFrameRoleButtonHealer:CreateBackdrop("Default", true, true);
	LFDQueueFrameRoleButtonHealer.backdrop:SetTemplate("Default", true, true);
	LFDQueueFrameRoleButtonHealer.backdrop:Point("TOPLEFT", LFDQueueFrameRoleButtonHealer, "TOPLEFT", 3, -3)
	LFDQueueFrameRoleButtonHealer.backdrop:Point("BOTTOMRIGHT", LFDQueueFrameRoleButtonHealer, "BOTTOMRIGHT", -3, 3)
	LFDQueueFrameRoleButtonHealer.icon = LFDQueueFrameRoleButtonHealer:CreateTexture(nil, "OVERLAY");
	LFDQueueFrameRoleButtonHealer.icon:SetTexCoord(unpack(E.TexCoords))
	LFDQueueFrameRoleButtonHealer.icon:SetTexture('Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH');
	LFDQueueFrameRoleButtonHealer.icon:SetInside(LFDQueueFrameRoleButtonHealer.backdrop)

	LFDQueueFrameRoleButtonDPS:StripTextures()
	LFDQueueFrameRoleButtonDPS:CreateBackdrop("Default", true, true);
	LFDQueueFrameRoleButtonDPS.backdrop:SetTemplate("Default", true, true);
	LFDQueueFrameRoleButtonDPS.backdrop:Point("TOPLEFT", LFDQueueFrameRoleButtonDPS, "TOPLEFT", 3, -3)
	LFDQueueFrameRoleButtonDPS.backdrop:Point("BOTTOMRIGHT", LFDQueueFrameRoleButtonDPS, "BOTTOMRIGHT", -3, 3)
	LFDQueueFrameRoleButtonDPS.icon = LFDQueueFrameRoleButtonDPS:CreateTexture(nil, "OVERLAY");
	LFDQueueFrameRoleButtonDPS.icon:SetTexCoord(unpack(E.TexCoords))
	LFDQueueFrameRoleButtonDPS.icon:SetTexture('Interface\\Icons\\INV_Knife_1H_Common_B_01');
	LFDQueueFrameRoleButtonDPS.icon:SetInside(LFDQueueFrameRoleButtonDPS.backdrop)

	LFDQueueFrameRoleButtonLeader:StripTextures()
	LFDQueueFrameRoleButtonLeader:CreateBackdrop("Default");
	LFDQueueFrameRoleButtonLeader.backdrop:Point("TOPLEFT", LFDQueueFrameRoleButtonLeader, "TOPLEFT", 3, -3)
	LFDQueueFrameRoleButtonLeader.backdrop:Point("BOTTOMRIGHT", LFDQueueFrameRoleButtonLeader, "BOTTOMRIGHT", -3, 3)
	LFDQueueFrameRoleButtonLeader.icon = LFDQueueFrameRoleButtonLeader:CreateTexture(nil, "OVERLAY");
	LFDQueueFrameRoleButtonLeader.icon:SetTexCoord(unpack(E.TexCoords))
	LFDQueueFrameRoleButtonLeader.icon:SetTexture('Interface\\Icons\\Ability_Vehicle_LaunchPlayer');
	LFDQueueFrameRoleButtonLeader.icon:SetInside(LFDQueueFrameRoleButtonLeader.backdrop)

	--Raid Finder Role Icons
	RaidFinderQueueFrameRoleButtonTank:Point("BOTTOMLEFT", RaidFinderQueueFrame, "BOTTOMLEFT", 25, 334)
	RaidFinderQueueFrameRoleButtonHealer:Point("LEFT", RaidFinderQueueFrameRoleButtonTank, "RIGHT", 23, 0)
	RaidFinderQueueFrameRoleButtonLeader:Point("LEFT", RaidFinderQueueFrameRoleButtonDPS, "RIGHT", 50, 0)

	RaidFinderQueueFrameRoleButtonTank:StripTextures()
	RaidFinderQueueFrameRoleButtonTank:CreateBackdrop("Default", true, true);
	RaidFinderQueueFrameRoleButtonTank.backdrop:SetTemplate("Default", true, true);
	RaidFinderQueueFrameRoleButtonTank.backdrop:Point("TOPLEFT", RaidFinderQueueFrameRoleButtonTank, "TOPLEFT", 3, -3)
	RaidFinderQueueFrameRoleButtonTank.backdrop:Point("BOTTOMRIGHT", RaidFinderQueueFrameRoleButtonTank, "BOTTOMRIGHT", -3, 3)
	RaidFinderQueueFrameRoleButtonTank.icon = RaidFinderQueueFrameRoleButtonTank:CreateTexture(nil, "OVERLAY");
	RaidFinderQueueFrameRoleButtonTank.icon:SetTexCoord(unpack(E.TexCoords))
	RaidFinderQueueFrameRoleButtonTank.icon:SetTexture('Interface\\Icons\\Ability_Defend');
	RaidFinderQueueFrameRoleButtonTank.icon:SetInside(RaidFinderQueueFrameRoleButtonTank.backdrop)

	RaidFinderQueueFrameRoleButtonHealer:StripTextures()
	RaidFinderQueueFrameRoleButtonHealer:CreateBackdrop("Default", true, true);
	RaidFinderQueueFrameRoleButtonHealer.backdrop:SetTemplate("Default", true, true);
	RaidFinderQueueFrameRoleButtonHealer.backdrop:Point("TOPLEFT", RaidFinderQueueFrameRoleButtonHealer, "TOPLEFT", 3, -3)
	RaidFinderQueueFrameRoleButtonHealer.backdrop:Point("BOTTOMRIGHT", RaidFinderQueueFrameRoleButtonHealer, "BOTTOMRIGHT", -3, 3)
	RaidFinderQueueFrameRoleButtonHealer.icon = RaidFinderQueueFrameRoleButtonHealer:CreateTexture(nil, "OVERLAY");
	RaidFinderQueueFrameRoleButtonHealer.icon:SetTexCoord(unpack(E.TexCoords))
	RaidFinderQueueFrameRoleButtonHealer.icon:SetTexture('Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH');
	RaidFinderQueueFrameRoleButtonHealer.icon:SetInside(RaidFinderQueueFrameRoleButtonHealer.backdrop)

	RaidFinderQueueFrameRoleButtonDPS:StripTextures()
	RaidFinderQueueFrameRoleButtonDPS:CreateBackdrop("Default", true, true);
	RaidFinderQueueFrameRoleButtonDPS.backdrop:SetTemplate("Default", true, true);
	RaidFinderQueueFrameRoleButtonDPS.backdrop:Point("TOPLEFT", RaidFinderQueueFrameRoleButtonDPS, "TOPLEFT", 3, -3)
	RaidFinderQueueFrameRoleButtonDPS.backdrop:Point("BOTTOMRIGHT", RaidFinderQueueFrameRoleButtonDPS, "BOTTOMRIGHT", -3, 3)
	RaidFinderQueueFrameRoleButtonDPS.icon = RaidFinderQueueFrameRoleButtonDPS:CreateTexture(nil, "OVERLAY");
	RaidFinderQueueFrameRoleButtonDPS.icon:SetTexCoord(unpack(E.TexCoords))
	RaidFinderQueueFrameRoleButtonDPS.icon:SetTexture('Interface\\Icons\\INV_Knife_1H_Common_B_01');
	RaidFinderQueueFrameRoleButtonDPS.icon:SetInside(RaidFinderQueueFrameRoleButtonDPS.backdrop)

	RaidFinderQueueFrameRoleButtonLeader:StripTextures()
	RaidFinderQueueFrameRoleButtonLeader:CreateBackdrop("Default");
	RaidFinderQueueFrameRoleButtonLeader.backdrop:Point("TOPLEFT", RaidFinderQueueFrameRoleButtonLeader, "TOPLEFT", 3, -3)
	RaidFinderQueueFrameRoleButtonLeader.backdrop:Point("BOTTOMRIGHT", RaidFinderQueueFrameRoleButtonLeader, "BOTTOMRIGHT", -3, 3)
	RaidFinderQueueFrameRoleButtonLeader.icon = RaidFinderQueueFrameRoleButtonLeader:CreateTexture(nil, "OVERLAY");
	RaidFinderQueueFrameRoleButtonLeader.icon:SetTexCoord(unpack(E.TexCoords))
	RaidFinderQueueFrameRoleButtonLeader.icon:SetTexture('Interface\\Icons\\Ability_Vehicle_LaunchPlayer');
	RaidFinderQueueFrameRoleButtonLeader.icon:SetInside(RaidFinderQueueFrameRoleButtonLeader.backdrop)

	LFRQueueFrameRoleButtonTank:Point("TOPLEFT", LFRQueueFrame, "TOPLEFT", 50, -45)
	LFRQueueFrameRoleButtonHealer:Point("LEFT", LFRQueueFrameRoleButtonTank, "RIGHT", 43, 0)

	LFRQueueFrameRoleButtonTank:StripTextures()
	LFRQueueFrameRoleButtonTank:CreateBackdrop("Default", true, true);
	LFRQueueFrameRoleButtonTank.backdrop:SetTemplate("Default", true, true);
	LFRQueueFrameRoleButtonTank.backdrop:Point("TOPLEFT", LFRQueueFrameRoleButtonTank, "TOPLEFT", 3, -3)
	LFRQueueFrameRoleButtonTank.backdrop:Point("BOTTOMRIGHT", LFRQueueFrameRoleButtonTank, "BOTTOMRIGHT", -3, 3)
	LFRQueueFrameRoleButtonTank.icon = LFRQueueFrameRoleButtonTank:CreateTexture(nil, "OVERLAY");
	LFRQueueFrameRoleButtonTank.icon:SetTexCoord(unpack(E.TexCoords))
	LFRQueueFrameRoleButtonTank.icon:SetTexture('Interface\\Icons\\Ability_Defend');
	LFRQueueFrameRoleButtonTank.icon:SetInside(LFRQueueFrameRoleButtonTank.backdrop)

	LFRQueueFrameRoleButtonHealer:StripTextures()
	LFRQueueFrameRoleButtonHealer:CreateBackdrop("Default", true, true);
	LFRQueueFrameRoleButtonHealer.backdrop:SetTemplate("Default", true, true);
	LFRQueueFrameRoleButtonHealer.backdrop:Point("TOPLEFT", LFRQueueFrameRoleButtonHealer, "TOPLEFT", 3, -3)
	LFRQueueFrameRoleButtonHealer.backdrop:Point("BOTTOMRIGHT", LFRQueueFrameRoleButtonHealer, "BOTTOMRIGHT", -3, 3)
	LFRQueueFrameRoleButtonHealer.icon = LFRQueueFrameRoleButtonHealer:CreateTexture(nil, "OVERLAY");
	LFRQueueFrameRoleButtonHealer.icon:SetTexCoord(unpack(E.TexCoords))
	LFRQueueFrameRoleButtonHealer.icon:SetTexture('Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH');
	LFRQueueFrameRoleButtonHealer.icon:SetInside(LFRQueueFrameRoleButtonHealer.backdrop)

	LFRQueueFrameRoleButtonDPS:StripTextures()
	LFRQueueFrameRoleButtonDPS:CreateBackdrop("Default", true, true);
	LFRQueueFrameRoleButtonDPS.backdrop:SetTemplate("Default", true, true);
	LFRQueueFrameRoleButtonDPS.backdrop:Point("TOPLEFT", LFRQueueFrameRoleButtonDPS, "TOPLEFT", 3, -3)
	LFRQueueFrameRoleButtonDPS.backdrop:Point("BOTTOMRIGHT", LFRQueueFrameRoleButtonDPS, "BOTTOMRIGHT", -3, 3)
	LFRQueueFrameRoleButtonDPS.icon = LFRQueueFrameRoleButtonDPS:CreateTexture(nil, "OVERLAY");
	LFRQueueFrameRoleButtonDPS.icon:SetTexCoord(unpack(E.TexCoords))
	LFRQueueFrameRoleButtonDPS.icon:SetTexture('Interface\\Icons\\INV_Knife_1H_Common_B_01');
	LFRQueueFrameRoleButtonDPS.icon:SetInside(LFRQueueFrameRoleButtonDPS.backdrop)

	--LF Dungeon Role Check PopUp
	LFDRoleCheckPopupRoleButtonTank:StripTextures()
	LFDRoleCheckPopupRoleButtonTank:CreateBackdrop("Default", true, true);
	LFDRoleCheckPopupRoleButtonTank.backdrop:SetTemplate("Default", true, true);
	LFDRoleCheckPopupRoleButtonTank.backdrop:Point("TOPLEFT", LFDRoleCheckPopupRoleButtonTank, "TOPLEFT", 7, -7)
	LFDRoleCheckPopupRoleButtonTank.backdrop:Point("BOTTOMRIGHT", LFDRoleCheckPopupRoleButtonTank, "BOTTOMRIGHT", -7, 7)
	LFDRoleCheckPopupRoleButtonTank.icon = LFDRoleCheckPopupRoleButtonTank:CreateTexture(nil, "OVERLAY");
	LFDRoleCheckPopupRoleButtonTank.icon:SetTexCoord(unpack(E.TexCoords))
	LFDRoleCheckPopupRoleButtonTank.icon:SetTexture('Interface\\Icons\\Ability_Defend');
	LFDRoleCheckPopupRoleButtonTank.icon:SetInside(LFDRoleCheckPopupRoleButtonTank.backdrop)

	LFDRoleCheckPopupRoleButtonHealer:StripTextures()
	LFDRoleCheckPopupRoleButtonHealer:CreateBackdrop("Default", true, true);
	LFDRoleCheckPopupRoleButtonHealer.backdrop:SetTemplate("Default", true, true);
	LFDRoleCheckPopupRoleButtonHealer.backdrop:Point("TOPLEFT", LFDRoleCheckPopupRoleButtonHealer, "TOPLEFT", 7, -7)
	LFDRoleCheckPopupRoleButtonHealer.backdrop:Point("BOTTOMRIGHT", LFDRoleCheckPopupRoleButtonHealer, "BOTTOMRIGHT", -7, 7)
	LFDRoleCheckPopupRoleButtonHealer.icon = LFDRoleCheckPopupRoleButtonHealer:CreateTexture(nil, "OVERLAY");
	LFDRoleCheckPopupRoleButtonHealer.icon:SetTexCoord(unpack(E.TexCoords))
	LFDRoleCheckPopupRoleButtonHealer.icon:SetTexture('Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH');
	LFDRoleCheckPopupRoleButtonHealer.icon:SetInside(LFDRoleCheckPopupRoleButtonHealer.backdrop)

	LFDRoleCheckPopupRoleButtonDPS:StripTextures()
	LFDRoleCheckPopupRoleButtonDPS:CreateBackdrop("Default", true, true);
	LFDRoleCheckPopupRoleButtonDPS.backdrop:SetTemplate("Default", true, true);
	LFDRoleCheckPopupRoleButtonDPS.backdrop:Point("TOPLEFT", LFDRoleCheckPopupRoleButtonDPS, "TOPLEFT", 7, -7)
	LFDRoleCheckPopupRoleButtonDPS.backdrop:Point("BOTTOMRIGHT", LFDRoleCheckPopupRoleButtonDPS, "BOTTOMRIGHT", -7, 7)
	LFDRoleCheckPopupRoleButtonDPS.icon = LFDRoleCheckPopupRoleButtonDPS:CreateTexture(nil, "OVERLAY");
	LFDRoleCheckPopupRoleButtonDPS.icon:SetTexCoord(unpack(E.TexCoords))
	LFDRoleCheckPopupRoleButtonDPS.icon:SetTexture('Interface\\Icons\\INV_Knife_1H_Common_B_01');
	LFDRoleCheckPopupRoleButtonDPS.icon:SetInside(LFDRoleCheckPopupRoleButtonDPS.backdrop)

	hooksecurefunc("LFG_SetRoleIconIncentive", function(roleButton, incentiveIndex)
		if incentiveIndex then
			roleButton.backdrop:SetBackdropBorderColor(1, 0.80, 0.10)
		end
	end)

	hooksecurefunc("LFG_PermanentlyDisableRoleButton", function(button)
		if button.icon then
			button.icon:SetDesaturated(true)
		end
	end)

	hooksecurefunc("LFG_DisableRoleButton", function(button)
		if button.icon then
			button.icon:SetDesaturated(true)
		end
	end)

	hooksecurefunc("LFG_EnableRoleButton", function(button)
		if button.icon then
			button.icon:SetDesaturated(false)
		end
	end)

	--Role Check
	RolePollPopupRoleButtonTank:Point("TOPLEFT", RolePollPopup, "TOPLEFT", 32, -35)

	RolePollPopupRoleButtonTank:StripTextures()
	RolePollPopupRoleButtonTank:CreateBackdrop("Default");
	RolePollPopupRoleButtonTank.backdrop:Point("TOPLEFT", RolePollPopupRoleButtonTank, "TOPLEFT", 7, -7)
	RolePollPopupRoleButtonTank.backdrop:Point("BOTTOMRIGHT", RolePollPopupRoleButtonTank, "BOTTOMRIGHT", -7, 7)
	RolePollPopupRoleButtonTank.icon = RolePollPopupRoleButtonTank:CreateTexture(nil, "OVERLAY");
	RolePollPopupRoleButtonTank.icon:SetTexCoord(unpack(E.TexCoords))
	RolePollPopupRoleButtonTank.icon:SetTexture('Interface\\Icons\\Ability_Defend');
	RolePollPopupRoleButtonTank.icon:SetInside(RolePollPopupRoleButtonTank.backdrop)

	RolePollPopupRoleButtonHealer:StripTextures()
	RolePollPopupRoleButtonHealer:CreateBackdrop("Default");
	RolePollPopupRoleButtonHealer.backdrop:Point("TOPLEFT", RolePollPopupRoleButtonHealer, "TOPLEFT", 7, -7)
	RolePollPopupRoleButtonHealer.backdrop:Point("BOTTOMRIGHT", RolePollPopupRoleButtonHealer, "BOTTOMRIGHT", -7, 7)
	RolePollPopupRoleButtonHealer.icon = RolePollPopupRoleButtonHealer:CreateTexture(nil, "OVERLAY");
	RolePollPopupRoleButtonHealer.icon:SetTexCoord(unpack(E.TexCoords))
	RolePollPopupRoleButtonHealer.icon:SetTexture('Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH');
	RolePollPopupRoleButtonHealer.icon:SetInside(RolePollPopupRoleButtonHealer.backdrop)

	RolePollPopupRoleButtonDPS:StripTextures()
	RolePollPopupRoleButtonDPS:CreateBackdrop("Default");
	RolePollPopupRoleButtonDPS.backdrop:Point("TOPLEFT", RolePollPopupRoleButtonDPS, "TOPLEFT", 7, -7)
	RolePollPopupRoleButtonDPS.backdrop:Point("BOTTOMRIGHT", RolePollPopupRoleButtonDPS, "BOTTOMRIGHT", -7, 7)
	RolePollPopupRoleButtonDPS.icon = RolePollPopupRoleButtonDPS:CreateTexture(nil, "OVERLAY");
	RolePollPopupRoleButtonDPS.icon:SetTexCoord(unpack(E.TexCoords))
	RolePollPopupRoleButtonDPS.icon:SetTexture('Interface\\Icons\\INV_Knife_1H_Common_B_01');
	RolePollPopupRoleButtonDPS.icon:SetInside(RolePollPopupRoleButtonDPS.backdrop)

	hooksecurefunc("RolePollPopup_Show", function(self)
	local canBeTank, canBeHealer, canBeDamager = UnitGetAvailableRoles("player");
		if ( canBeTank ) then
			RolePollPopupRoleButtonTank.icon:SetDesaturated(false)
		else
			RolePollPopupRoleButtonTank.icon:SetDesaturated(true)
		end
		if ( canBeHealer ) then
			RolePollPopupRoleButtonHealer.icon:SetDesaturated(false)
		else
			RolePollPopupRoleButtonHealer.icon:SetDesaturated(true)
		end
		if ( canBeDamager ) then
			RolePollPopupRoleButtonDPS.icon:SetDesaturated(false)
		else
			RolePollPopupRoleButtonDPS.icon:SetDesaturated(true)
		end
	end)

	--LFG Search Status
	LFGSearchStatusIndividualRoleDisplayTank1:StripTextures()
	LFGSearchStatusIndividualRoleDisplayTank1:CreateBackdrop("Default");
	LFGSearchStatusIndividualRoleDisplayTank1.backdrop:Point("TOPLEFT", LFGSearchStatusIndividualRoleDisplayTank1, "TOPLEFT", 5, -5)
	LFGSearchStatusIndividualRoleDisplayTank1.backdrop:Point("BOTTOMRIGHT", LFGSearchStatusIndividualRoleDisplayTank1, "BOTTOMRIGHT", -5, 5)
	LFGSearchStatusIndividualRoleDisplayTank1.icon = LFGSearchStatusIndividualRoleDisplayTank1:CreateTexture(nil, "OVERLAY");
	LFGSearchStatusIndividualRoleDisplayTank1.icon:SetTexCoord(unpack(E.TexCoords))
	LFGSearchStatusIndividualRoleDisplayTank1.icon:SetTexture('Interface\\Icons\\Ability_Defend');
	LFGSearchStatusIndividualRoleDisplayTank1.icon:SetInside(LFGSearchStatusIndividualRoleDisplayTank1.backdrop)

	LFGSearchStatusIndividualRoleDisplayHealer1:StripTextures()
	LFGSearchStatusIndividualRoleDisplayHealer1:CreateBackdrop("Default");
	LFGSearchStatusIndividualRoleDisplayHealer1.backdrop:Point("TOPLEFT", LFGSearchStatusIndividualRoleDisplayHealer1, "TOPLEFT", 5, -5)
	LFGSearchStatusIndividualRoleDisplayHealer1.backdrop:Point("BOTTOMRIGHT", LFGSearchStatusIndividualRoleDisplayHealer1, "BOTTOMRIGHT", -5, 5)
	LFGSearchStatusIndividualRoleDisplayHealer1.icon = LFGSearchStatusIndividualRoleDisplayHealer1:CreateTexture(nil, "OVERLAY");
	LFGSearchStatusIndividualRoleDisplayHealer1.icon:SetTexCoord(unpack(E.TexCoords))
	LFGSearchStatusIndividualRoleDisplayHealer1.icon:SetTexture('Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH');
	LFGSearchStatusIndividualRoleDisplayHealer1.icon:SetInside(LFGSearchStatusIndividualRoleDisplayHealer1.backdrop)

	for i=1, 3 do
		_G["LFGSearchStatusIndividualRoleDisplayDamage"..i]:StripTextures()
		_G["LFGSearchStatusIndividualRoleDisplayDamage"..i]:CreateBackdrop("Default");
		_G["LFGSearchStatusIndividualRoleDisplayDamage"..i].backdrop:Point("TOPLEFT", _G["LFGSearchStatusIndividualRoleDisplayDamage"..i], "TOPLEFT", 5, -5)
		_G["LFGSearchStatusIndividualRoleDisplayDamage"..i].backdrop:Point("BOTTOMRIGHT", _G["LFGSearchStatusIndividualRoleDisplayDamage"..i], "BOTTOMRIGHT", -5, 5)
		_G["LFGSearchStatusIndividualRoleDisplayDamage"..i].icon = _G["LFGSearchStatusIndividualRoleDisplayDamage"..i]:CreateTexture(nil, "OVERLAY");
		_G["LFGSearchStatusIndividualRoleDisplayDamage"..i].icon:SetTexCoord(unpack(E.TexCoords))
		_G["LFGSearchStatusIndividualRoleDisplayDamage"..i].icon:SetTexture('Interface\\Icons\\INV_Knife_1H_Common_B_01');
		_G["LFGSearchStatusIndividualRoleDisplayDamage"..i].icon:SetInside(_G["LFGSearchStatusIndividualRoleDisplayDamage"..i].backdrop)
	end

	hooksecurefunc("LFGSearchStatusPlayer_SetFound", function(button, isFound)
		if button.icon then
			if ( isFound ) then
				button.icon:SetDesaturated(false)
			else
				button.icon:SetDesaturated(true)
			end
		end
	end)

	--Dungeon Ready PopUp
	hooksecurefunc("LFGDungeonReadyPopup_Update", function()
	local b, c, d, e, f, g, h, i, j, k, l, m = GetLFGProposal()
		if LFGDungeonReadyDialogRoleIcon:IsShown() then
			LFGDungeonReadyDialogRoleIcon:StripTextures()
			LFGDungeonReadyDialogRoleIcon:CreateBackdrop();
			LFGDungeonReadyDialogRoleIcon.backdrop:Point("TOPLEFT", LFGDungeonReadyDialogRoleIcon, "TOPLEFT", 7, -7)
			LFGDungeonReadyDialogRoleIcon.backdrop:Point("BOTTOMRIGHT", LFGDungeonReadyDialogRoleIcon, "BOTTOMRIGHT", -7, 7)
			LFGDungeonReadyDialogRoleIcon.icon = LFGDungeonReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY");
			LFGDungeonReadyDialogRoleIcon.icon:SetTexCoord(unpack(E.TexCoords))
			if h == "DAMAGER" then
				LFGDungeonReadyDialogRoleIcon.icon:SetTexture('Interface\\Icons\\INV_Knife_1H_Common_B_01');
			elseif h == "TANK" then
				LFGDungeonReadyDialogRoleIcon.icon:SetTexture('Interface\\Icons\\Ability_Defend');
			elseif h == "HEALER" then
				LFGDungeonReadyDialogRoleIcon.icon:SetTexture('Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH');
			end
			LFGDungeonReadyDialogRoleIcon.icon:SetInside(LFGDungeonReadyDialogRoleIcon.backdrop)
		end
	end)

	do
		local roleButtons = {LFGDungeonReadyStatusGroupedTank, LFGDungeonReadyStatusGroupedHealer, LFGDungeonReadyStatusGroupedDamager}
		for i = 1, 5 do
			tinsert(roleButtons, _G["LFGDungeonReadyStatusIndividualPlayer"..i])
		end
		for _, roleButton in pairs (roleButtons) do
			roleButton:CreateBackdrop("Default", true)
			roleButton.texture:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfgRoleIcons')
			roleButton.statusIcon:SetDrawLayer("OVERLAY", 2)
		end
	end
end

S:AddCallback("Misc", LoadSkin);