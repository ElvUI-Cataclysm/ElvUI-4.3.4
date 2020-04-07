local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local pairs, type, unpack, select = pairs, type, unpack, select
local find = string.find

local GetLFGProposal = GetLFGProposal
local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.lfg then return end

	-- LFD Frames
	local buttons = {
		"LFDQueueFrameFindGroupButton",
		"LFDQueueFrameCancelButton",
		"LFDQueueFramePartyBackfillBackfillButton",
		"LFDQueueFramePartyBackfillNoBackfillButton",
		"LFDQueueFrameNoLFDWhileLFRLeaveQueueButton"
	}

	for i = 1, #buttons do
		_G[buttons[i]]:StripTextures()
		S:HandleButton(_G[buttons[i]])
	end

	LFDQueueFrame:StripTextures()
	LFDQueueFrameRandom:StripTextures()
	LFDQueueFrameRandomScrollFrame:StripTextures()

	LFDParentFrame:StripTextures()
	LFDParentFrame:SetTemplate("Transparent")

	S:HandleCloseButton(LFDParentFrameCloseButton, LFDParentFrame)

	LFDQueueFrameBackground:Kill()
	LFDParentFrameInset:Kill()
	LFDParentFrameEyeFrame:Kill()

	S:HandleDropDownBox(LFDQueueFrameTypeDropDown, 300)
	LFDQueueFrameTypeDropDown:Point("RIGHT", -10, 0)

	-- LFD Cap Bar
	LFDQueueFrameCapBar.label:Point("CENTER", 12, 0)
	LFDQueueFrameCapBar:Point("LEFT", 40, 0)

	LFDQueueFrameCapBar:StripTextures()
	LFDQueueFrameCapBar:CreateBackdrop()
	LFDQueueFrameCapBar.backdrop:Point("TOPLEFT", LFDQueueFrameCapBar, "TOPLEFT", -1, -2)
	LFDQueueFrameCapBar.backdrop:Point("BOTTOMRIGHT", LFDQueueFrameCapBar, "BOTTOMRIGHT", 1, 2)

	LFDQueueFrameCapBarProgress:SetTexture(E.media.normTex)

	for i = 1, 2 do
		_G["LFDQueueFrameCapBarCap"..i.."Marker"]:Kill()
		_G["LFDQueueFrameCapBarCap"..i]:SetTexture(E.media.normTex)
	end

	-- LFD Role Icons
	local lfdRoleIcons = {
		"LFDQueueFrameRoleButtonTank",
		"LFDQueueFrameRoleButtonHealer",
		"LFDQueueFrameRoleButtonDPS",
		"LFDQueueFrameRoleButtonLeader"
	}

	for i = 1, #lfdRoleIcons do
		S:HandleCheckBox(_G[lfdRoleIcons[i]]:GetChildren())
		_G[lfdRoleIcons[i]]:GetChildren():SetFrameLevel(_G[lfdRoleIcons[i]]:GetChildren():GetFrameLevel() + 2)

		_G[lfdRoleIcons[i]]:StripTextures()
		_G[lfdRoleIcons[i]]:CreateBackdrop()
		_G[lfdRoleIcons[i]].backdrop:Point("TOPLEFT", 3, -3)
		_G[lfdRoleIcons[i]].backdrop:Point("BOTTOMRIGHT", -3, 3)

		_G[lfdRoleIcons[i]]:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
		_G[lfdRoleIcons[i]]:GetNormalTexture():SetInside(_G[lfdRoleIcons[i]].backdrop)
	end

	LFDQueueFrameRoleButtonTank:Point("BOTTOMLEFT", LFDQueueFrame, "BOTTOMLEFT", 25, 334)
	LFDQueueFrameRoleButtonHealer:Point("LEFT", LFDQueueFrameRoleButtonTank,"RIGHT", 23, 0)
	LFDQueueFrameRoleButtonLeader:Point("LEFT", LFDQueueFrameRoleButtonDPS, "RIGHT", 50, 0)

	LFDQueueFrameRoleButtonTank:SetNormalTexture("Interface\\Icons\\Ability_Defend")
	LFDQueueFrameRoleButtonHealer:SetNormalTexture("Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH")
	LFDQueueFrameRoleButtonDPS:SetNormalTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01")
	LFDQueueFrameRoleButtonLeader:SetNormalTexture("Interface\\Icons\\Ability_Vehicle_LaunchPlayer")

	-- LFD Rewards
	local function getLFGDungeonRewardLinkFix(dungeonID, rewardIndex)
		local _, link = GetLFGDungeonRewardLink(dungeonID, rewardIndex)

		if not link then
			E.ScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
			E.ScanTooltip:SetLFGDungeonReward(dungeonID, rewardIndex)
			_, link = E.ScanTooltip:GetItem()
			E.ScanTooltip:Hide()
		end

		return link
	end

	hooksecurefunc("LFDQueueFrameRandom_UpdateFrame", function()
		local dungeonID = LFDQueueFrame.type
		if type(dungeonID) ~= "number" then return end

		local _, _, _, _, _, numRewards = GetLFGDungeonRewards(dungeonID)
		for i = 1, numRewards do
			local button = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i]

			if button then
				if not button.isSkinned then
					local count = _G[button:GetName().."Count"]
					local icon = _G[button:GetName().."IconTexture"]

					button:StripTextures()
					button:SetTemplate("Transparent")
					button:StyleButton(nil, true)
					button:CreateBackdrop()
					button.backdrop:SetOutside(icon)

					icon:Point("TOPLEFT", 1, -1)
					icon:SetTexture(icon:GetTexture())
					icon:SetTexCoord(unpack(E.TexCoords))
					icon:SetParent(button.backdrop)
					icon:SetDrawLayer("ARTWORK")

					count:SetParent(button.backdrop)
					count:SetDrawLayer("OVERLAY")

					for j = 1, 2 do
						_G[button:GetName().."RoleIcon"..j]:SetParent(button.backdrop)
					end

					button.isSkinned = true
				end

				local name = _G[button:GetName().."Name"]
				local link = getLFGDungeonRewardLinkFix(dungeonID, i)

				if link then
					local quality = select(3, GetItemInfo(link))

					if quality then
						local r, g, b = GetItemQualityColor(quality)
						button:SetBackdropBorderColor(r, g, b)
						button.backdrop:SetBackdropBorderColor(r, g, b)
						name:SetTextColor(r, g, b)
					else
						button:SetBackdropBorderColor(unpack(E.media.bordercolor))
						button.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
						name:SetTextColor(1, 1, 1)
					end
				else
					button:SetBackdropBorderColor(unpack(E.media.bordercolor))
					button.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
					name:SetTextColor(1, 1, 1)
				end
			end
		end
	end)

	-- LFD Specific List
	LFDQueueFrameSpecific:StripTextures()

	LFDQueueFrameSpecificListScrollFrame:StripTextures()
	LFDQueueFrameSpecificListScrollFrame:Height(LFDQueueFrameSpecificListScrollFrame:GetHeight() - 8)

	S:HandleScrollBar(LFDQueueFrameSpecificListScrollFrameScrollBar)

	for frame, numItems in pairs({["LFDQueueFrameSpecificListButton"] = NUM_LFD_CHOICE_BUTTONS, ["LFRQueueFrameSpecificListButton"] = NUM_LFR_CHOICE_BUTTONS}) do
		for i = 1, numItems do
			local button = _G[frame..i]

			button.enableButton:CreateBackdrop()
			button.enableButton.backdrop:SetInside(nil, 4, 4)

			button.enableButton:SetNormalTexture("")
			button.enableButton.SetNormalTexture = E.noop

			button.enableButton:SetPushedTexture("")
			button.enableButton.SetPushedTexture = E.noop

			if E.private.skins.checkBoxSkin then
				button.enableButton:SetHighlightTexture(E.Media.Textures.Melli)
				button.enableButton.SetHighlightTexture = E.noop

				button.enableButton:SetCheckedTexture(E.Media.Textures.Melli)
				button.enableButton.SetCheckedTexture = E.noop

				button.enableButton:SetDisabledCheckedTexture(E.Media.Textures.Melli)
				button.enableButton.SetDisabledCheckedTexture = E.noop

				local Checked, Highlight, DisabledChecked = button.enableButton:GetCheckedTexture(), button.enableButton:GetHighlightTexture(), button.enableButton:GetDisabledCheckedTexture()

				Checked:SetInside(button.enableButton.backdrop)
				Checked:SetVertexColor(1, 0.8, 0.1, 0.8)

				Highlight:SetInside(button.enableButton.backdrop)
				Highlight:SetVertexColor(1, 1, 1, 0.35)

				DisabledChecked:SetInside(button.enableButton.backdrop)
				DisabledChecked:SetVertexColor(0.6, 0.6, 0.5, 0.8)
			else
				button.enableButton:SetHighlightTexture("")
				button.enableButton.SetHighlightTexture = E.noop
			end

			button.expandOrCollapseButton:SetNormalTexture(E.Media.Textures.Plus)
			button.expandOrCollapseButton:SetHighlightTexture(nil)
			button.expandOrCollapseButton:GetNormalTexture():Size(16)
			button.expandOrCollapseButton:GetNormalTexture():Point("CENTER", 2, 3)

			hooksecurefunc(button.expandOrCollapseButton, "SetNormalTexture", function(self, texture)
				local normal = self:GetNormalTexture()

				if find(texture, "MinusButton") then
					normal:SetTexture(E.Media.Textures.Minus)
				else
					normal:SetTexture(E.Media.Textures.Plus)
				end
			end)
		end
	end

	--LFD Role Picker PopUp Frame
	LFDRoleCheckPopup:StripTextures()
	LFDRoleCheckPopup:SetTemplate("Transparent")

	S:HandleButton(LFDRoleCheckPopupAcceptButton)
	S:HandleButton(LFDRoleCheckPopupDeclineButton)

	local roleCheckPopUp = {
		"LFDRoleCheckPopupRoleButtonTank",
		"LFDRoleCheckPopupRoleButtonHealer",
		"LFDRoleCheckPopupRoleButtonDPS"
	}

	for i = 1, #roleCheckPopUp do
		S:HandleCheckBox(_G[roleCheckPopUp[i]]:GetChildren())
		_G[roleCheckPopUp[i]]:GetChildren():SetFrameLevel(_G[roleCheckPopUp[i]]:GetChildren():GetFrameLevel() + 2)

		_G[roleCheckPopUp[i]]:StripTextures()
		_G[roleCheckPopUp[i]]:CreateBackdrop()
		_G[roleCheckPopUp[i]].backdrop:Point("TOPLEFT", 7, -7)
		_G[roleCheckPopUp[i]].backdrop:Point("BOTTOMRIGHT", -7, 7)

		_G[roleCheckPopUp[i]]:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
		_G[roleCheckPopUp[i]]:GetNormalTexture():SetInside(_G[roleCheckPopUp[i]].backdrop)
	end

	LFDRoleCheckPopupRoleButtonTank:SetNormalTexture("Interface\\Icons\\Ability_Defend")
	LFDRoleCheckPopupRoleButtonHealer:SetNormalTexture("Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH")
	LFDRoleCheckPopupRoleButtonDPS:SetNormalTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01")

	--LFG Search Status
	LFGSearchStatus:SetTemplate("Transparent")

	local lfgSearchStatusIcons = {
		"LFGSearchStatusIndividualRoleDisplayTank1",
		"LFGSearchStatusIndividualRoleDisplayHealer1",
		"LFGSearchStatusIndividualRoleDisplayDamage1",
		"LFGSearchStatusIndividualRoleDisplayDamage2",
		"LFGSearchStatusIndividualRoleDisplayDamage3"
,	}

	for i = 1, #lfgSearchStatusIcons do
		_G[lfgSearchStatusIcons[i]]:StripTextures()
		_G[lfgSearchStatusIcons[i]]:CreateBackdrop()
		_G[lfgSearchStatusIcons[i]].backdrop:Point("TOPLEFT", 5, -5)
		_G[lfgSearchStatusIcons[i]].backdrop:Point("BOTTOMRIGHT", -5, 5)

		_G[lfgSearchStatusIcons[i]].texture:SetTexCoord(unpack(E.TexCoords))
		_G[lfgSearchStatusIcons[i]].texture:SetInside(_G[lfgSearchStatusIcons[i]].backdrop)
	end

	LFGSearchStatusIndividualRoleDisplayTank1Texture:SetTexture("Interface\\Icons\\Ability_Defend")
	LFGSearchStatusIndividualRoleDisplayHealer1Texture:SetTexture("Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH")
	LFGSearchStatusIndividualRoleDisplayDamage1Texture:SetTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01")
	LFGSearchStatusIndividualRoleDisplayDamage2Texture:SetTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01")
	LFGSearchStatusIndividualRoleDisplayDamage3Texture:SetTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01")

	local lfgSearchStatusGroupedIcons = {
		"LFGSearchStatusGroupedRoleDisplayTank",
		"LFGSearchStatusGroupedRoleDisplayHealer",
		"LFGSearchStatusGroupedRoleDisplayDamage"
,	}

	for i = 1, #lfgSearchStatusGroupedIcons do
		_G[lfgSearchStatusGroupedIcons[i]]:StripTextures()
		_G[lfgSearchStatusGroupedIcons[i]]:CreateBackdrop()
		_G[lfgSearchStatusGroupedIcons[i]].backdrop:Point("TOPLEFT", 5, -5)
		_G[lfgSearchStatusGroupedIcons[i]].backdrop:Point("BOTTOMRIGHT", -5, 5)

		_G[lfgSearchStatusGroupedIcons[i]].texture:SetTexCoord(unpack(E.TexCoords))
		_G[lfgSearchStatusGroupedIcons[i]].texture:SetInside(_G[lfgSearchStatusGroupedIcons[i]].backdrop)
	end

	LFGSearchStatusGroupedRoleDisplayTankTexture:SetTexture("Interface\\Icons\\Ability_Defend")
	LFGSearchStatusGroupedRoleDisplayHealerTexture:SetTexture("Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH")
	LFGSearchStatusGroupedRoleDisplayDamageTexture:SetTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01")

	hooksecurefunc("LFGSearchStatus_UpdateRoles", function()
		local _, tank, healer, damage = GetLFGRoles()
		local currentIcon = 1
		if tank then
			local icon = _G["LFGSearchStatusRoleIcon"..currentIcon]
			icon:SetTexture(E.Media.Textures.Tank)
			icon:SetTexCoord(unpack(E.TexCoords))
			icon:Size(22)
			currentIcon = currentIcon + 1
		end
		if healer then
			local icon = _G["LFGSearchStatusRoleIcon"..currentIcon]
			icon:SetTexture(E.Media.Textures.Healer)
			icon:SetTexCoord(unpack(E.TexCoords))
			icon:Size(20)
			currentIcon = currentIcon + 1
		end
		if damage then
			local icon = _G["LFGSearchStatusRoleIcon"..currentIcon]
			icon:SetTexture(E.Media.Textures.DPS)
			icon:SetTexCoord(unpack(E.TexCoords))
			icon:Size(17)
		end
	end)

	--LFG Ready Dialog
	LFGDungeonReadyDialogBackground:Kill()
	LFGDungeonReadyDialog:SetTemplate("Transparent")
	LFGDungeonReadyDialog.SetBackdrop = E.noop
	LFGDungeonReadyDialog.filigree:SetAlpha(0)
	LFGDungeonReadyDialog.bottomArt:SetAlpha(0)

	S:HandleButton(LFGDungeonReadyDialogLeaveQueueButton)
	S:HandleButton(LFGDungeonReadyDialogEnterDungeonButton)

	S:HandleArrowButton(LFGDungeonReadyDialogCloseButton, true)

	hooksecurefunc("LFGDungeonReadyDialog_UpdateRewards", function()
		for i = 1, LFG_ROLE_NUM_SHORTAGE_TYPES do
			local reward = _G["LFGDungeonReadyDialogRewardsFrameReward"..i]
			local texture = _G["LFGDungeonReadyDialogRewardsFrameReward"..i.."Texture"]
			local border = _G["LFGDungeonReadyDialogRewardsFrameReward"..i.."Border"]

			if reward and not reward.isSkinned then
				border:Kill()
				reward:CreateBackdrop()
				reward.backdrop:Point("TOPLEFT", 7, -7)
				reward.backdrop:Point("BOTTOMRIGHT", -7, 7)

				texture:SetTexCoord(unpack(E.TexCoords))
				texture:SetInside(reward.backdrop)

				reward.isSkinned = true
			end
		end
	end)

	LFGDungeonReadyDialogRoleIcon:StripTextures()
	LFGDungeonReadyDialogRoleIcon:CreateBackdrop()
	LFGDungeonReadyDialogRoleIcon.backdrop:Point("TOPLEFT", 7, -7)
	LFGDungeonReadyDialogRoleIcon.backdrop:Point("BOTTOMRIGHT", -7, 7)
	LFGDungeonReadyDialogRoleIcon.icon = LFGDungeonReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY")

	hooksecurefunc("LFGDungeonReadyPopup_Update", function()
		local _, _, _, _, _, _, role = GetLFGProposal()

		if role == "DAMAGER" then
			LFGDungeonReadyDialogRoleIcon.icon:SetTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01")
		elseif role == "TANK" then
			LFGDungeonReadyDialogRoleIcon.icon:SetTexture("Interface\\Icons\\Ability_Defend")
		elseif role == "HEALER" then
			LFGDungeonReadyDialogRoleIcon.icon:SetTexture("Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH")
		end

		LFGDungeonReadyDialogRoleIcon.icon:SetTexCoord(unpack(E.TexCoords))
		LFGDungeonReadyDialogRoleIcon.icon:SetInside(LFGDungeonReadyDialogRoleIcon.backdrop)
	end)

	-- LFG Ready Status
	LFGDungeonReadyStatus:StripTextures()
	LFGDungeonReadyStatus:SetTemplate("Transparent")

	S:HandleCloseButton(LFGDungeonReadyStatusCloseButton)

	do
		local roleButtons = {LFGDungeonReadyStatusGroupedTank, LFGDungeonReadyStatusGroupedHealer, LFGDungeonReadyStatusGroupedDamager}
		for i = 1, 5 do
			tinsert(roleButtons, _G["LFGDungeonReadyStatusIndividualPlayer"..i])
		end
		for _, roleButton in pairs (roleButtons) do
			roleButton:CreateBackdrop()
			roleButton.backdrop:Point("TOPLEFT", 3, -3)
			roleButton.backdrop:Point("BOTTOMRIGHT", -3, 3)
			roleButton.texture:SetTexture(E.Media.Textures.RoleIcons)
			roleButton.texture:Point("TOPLEFT", roleButton.backdrop, "TOPLEFT", -8, 6)
			roleButton.texture:Point("BOTTOMRIGHT", roleButton.backdrop, "BOTTOMRIGHT", 8, -10)
			roleButton.statusIcon:SetDrawLayer("OVERLAY", 2)
		end
	end

	-- Raid Finder
	RaidParentFrame:StripTextures()
	RaidParentFrame:SetTemplate("Transparent")

	RaidParentFrameInset:StripTextures()

	S:HandleCloseButton(RaidParentFrameCloseButton)

	for i = 1, 2 do
		local tab = _G["LFRParentFrameSideTab"..i]
		tab:GetRegions():Hide()
		tab:SetTemplate()
		tab:StyleButton(nil, true)
		tab:GetNormalTexture():SetInside()
		tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	end

	for i = 1, 3 do
		S:HandleTab(_G["RaidParentFrameTab"..i])
	end

	LFRParentFrameSideTab1:Point("TOPLEFT", LFRParentFrame, "TOPRIGHT", E.PixelMode and -1 or 1, -35)

	RaidFinderQueueFrame:StripTextures(true)
	RaidFinderFrame:StripTextures()
	RaidFinderFrameRoleInset:StripTextures()

	S:HandleDropDownBox(RaidFinderQueueFrameSelectionDropDown)
	RaidFinderQueueFrameSelectionDropDown:Width(225)
	RaidFinderQueueFrameSelectionDropDown.SetWidth = E.noop

	S:HandleButton(RaidFinderFrameFindRaidButton, true)
	S:HandleButton(RaidFinderFrameCancelButton, true)
	S:HandleButton(RaidFinderQueueFrameIneligibleFrameLeaveQueueButton)

	for i = 1, 1 do
		local button = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i]
		local icon = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."IconTexture"]
		local count = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."Count"]

		if button then
			button:StripTextures()
			button:CreateBackdrop()
			button.backdrop:SetOutside(icon)

			icon:SetTexCoord(unpack(E.TexCoords))
			icon:SetParent(button.backdrop)
			icon:SetDrawLayer("OVERLAY")

			if count then
				count:SetParent(button.backdrop)
				count:SetDrawLayer("OVERLAY")
			end
		end
	end

	local raidFinderQueueRoles = {
		"RaidFinderQueueFrameRoleButtonTank",
		"RaidFinderQueueFrameRoleButtonHealer",
		"RaidFinderQueueFrameRoleButtonDPS",
		"RaidFinderQueueFrameRoleButtonLeader"
	}

	for i = 1, #raidFinderQueueRoles do
		S:HandleCheckBox(_G[raidFinderQueueRoles[i]].checkButton)
		_G[raidFinderQueueRoles[i]].checkButton:SetFrameLevel(_G[raidFinderQueueRoles[i]].checkButton:GetFrameLevel() + 2)

		_G[raidFinderQueueRoles[i]]:StripTextures()
		_G[raidFinderQueueRoles[i]]:CreateBackdrop()
		_G[raidFinderQueueRoles[i]].backdrop:Point("TOPLEFT", 3, -3)
		_G[raidFinderQueueRoles[i]].backdrop:Point("BOTTOMRIGHT", -3, 3)

		_G[raidFinderQueueRoles[i]]:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
		_G[raidFinderQueueRoles[i]]:GetNormalTexture():SetInside(_G[raidFinderQueueRoles[i]].backdrop)
	end

	RaidFinderQueueFrameRoleButtonTank:SetNormalTexture("Interface\\Icons\\Ability_Defend")
	RaidFinderQueueFrameRoleButtonHealer:SetNormalTexture("Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH")
	RaidFinderQueueFrameRoleButtonDPS:SetNormalTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01")
	RaidFinderQueueFrameRoleButtonLeader:SetNormalTexture("Interface\\Icons\\Ability_Vehicle_LaunchPlayer")

	RaidFinderQueueFrameRoleButtonTank:Point("BOTTOMLEFT", RaidFinderQueueFrame, "BOTTOMLEFT", 25, 334)
	RaidFinderQueueFrameRoleButtonHealer:Point("LEFT", RaidFinderQueueFrameRoleButtonTank, "RIGHT", 23, 0)
	RaidFinderQueueFrameRoleButtonLeader:Point("LEFT", RaidFinderQueueFrameRoleButtonDPS, "RIGHT", 50, 0)

	-- LFR Queue Frame
	LFRParentFrame:StripTextures()
	LFRQueueFrame:StripTextures()
	LFRQueueFrameListInset:StripTextures()
	LFRQueueFrameRoleInset:StripTextures()
	LFRQueueFrameCommentInset:StripTextures()

	S:HandleScrollBar(LFRQueueFrameCommentScrollFrameScrollBar)

	S:HandleButton(LFRQueueFrameFindGroupButton)
	S:HandleButton(LFRQueueFrameAcceptCommentButton)

	LFRQueueFrameCommentTextButton:CreateBackdrop()
	LFRQueueFrameCommentTextButton:Height(35)

	LFRQueueFrameSpecificListScrollFrame:StripTextures()
	LFRQueueFrameSpecificListScrollFrame:ClearAllPoints()
	LFRQueueFrameSpecificListScrollFrame:Point("TOPLEFT", LFRQueueFrameSpecificListButton1, "TOPLEFT", 0, 0)
	LFRQueueFrameSpecificListScrollFrame:Point("BOTTOMRIGHT", LFRQueueFrameSpecificListButton14, "BOTTOMRIGHT", 0, -2)

	S:HandleScrollBar(LFRQueueFrameSpecificListScrollFrameScrollBar)

	S:HandleButton(LFRQueueFrameNoLFRWhileLFDLeaveQueueButton)

	local lfrQueueRoles = {
		"LFRQueueFrameRoleButtonTank",
		"LFRQueueFrameRoleButtonHealer",
		"LFRQueueFrameRoleButtonDPS"
	}

	for i = 1, #lfrQueueRoles do
		S:HandleCheckBox(_G[lfrQueueRoles[i]]:GetChildren())
		_G[lfrQueueRoles[i]]:GetChildren():SetFrameLevel(_G[lfrQueueRoles[i]]:GetChildren():GetFrameLevel() + 2)

		_G[lfrQueueRoles[i]]:StripTextures()
		_G[lfrQueueRoles[i]]:CreateBackdrop()
		_G[lfrQueueRoles[i]].backdrop:Point("TOPLEFT", 3, -3)
		_G[lfrQueueRoles[i]].backdrop:Point("BOTTOMRIGHT", -3, 3)

		_G[lfrQueueRoles[i]]:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
		_G[lfrQueueRoles[i]]:GetNormalTexture():SetInside(_G[lfrQueueRoles[i]].backdrop)
	end

	LFRQueueFrameRoleButtonTank:SetNormalTexture("Interface\\Icons\\Ability_Defend")
	LFRQueueFrameRoleButtonHealer:SetNormalTexture("Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH")
	LFRQueueFrameRoleButtonDPS:SetNormalTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01")

	LFRQueueFrameRoleButtonTank:Point("TOPLEFT", LFRQueueFrame, "TOPLEFT", 50, -45)
	LFRQueueFrameRoleButtonHealer:Point("LEFT", LFRQueueFrameRoleButtonTank, "RIGHT", 43, 0)

	-- LFR Browse Frame
	LFRBrowseFrame:StripTextures()
	LFRBrowseFrame:HookScript("OnShow", function()
		if not LFRBrowseFrameListScrollFrameScrollBar.isSkinned then
			S:HandleScrollBar(LFRBrowseFrameListScrollFrameScrollBar)

			LFRBrowseFrameListScrollFrameScrollBar.isSkinned = true
		end
	end)

	--[[
	hooksecurefunc("LFRBrowseFrameListButton_SetData", function(button, index)
		local name, level, _, _, _, _, _, class = SearchLFGGetResults(index)

		local classColor = E:ClassColor(class)
		local levelColor = GetQuestDifficultyColor(level)

		if index and class and name and level and (name ~= E.myname) then
			button.name:SetTextColor(classColor.r, classColor.g, classColor.b)
			button.class:SetTextColor(classColor.r, classColor.g, classColor.b)
			button.level:SetTextColor(levelColor.r, levelColor.g, levelColor.b)
		end
	end)
	]]

	LFRBrowseFrameListScrollFrame:ClearAllPoints()
	LFRBrowseFrameListScrollFrame:Point("TOPLEFT", LFRBrowseFrameListButton1, "TOPLEFT", 0, 0)
	LFRBrowseFrameListScrollFrame:Point("BOTTOMRIGHT", LFRBrowseFrameListButton19, "BOTTOMRIGHT", 5, -2)

	S:HandleDropDownBox(LFRBrowseFrameRaidDropDown)

	S:HandleButton(LFRBrowseFrameSendMessageButton)
	S:HandleButton(LFRBrowseFrameInviteButton)
	S:HandleButton(LFRBrowseFrameRefreshButton)

	for i = 1, 7 do
		local button = "LFRBrowseFrameColumnHeader"..i
		_G[button.."Left"]:Kill()
		_G[button.."Middle"]:Kill()
		_G[button.."Right"]:Kill()
		_G[button]:StyleButton()
	end

	-- Incentive
	hooksecurefunc("LFG_SetRoleIconIncentive", function(roleButton, incentiveIndex)
		if incentiveIndex then
			roleButton.backdrop:SetBackdropBorderColor(1, 0.80, 0.10)
		else
			roleButton.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
	end)
end

S:AddCallback("LFG", LoadSkin)