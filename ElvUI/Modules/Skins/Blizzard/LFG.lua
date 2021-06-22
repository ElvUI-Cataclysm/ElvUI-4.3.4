local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local pairs, type, unpack, select = pairs, type, unpack, select
local find = string.find

local GetLFGProposal = GetLFGProposal
local hooksecurefunc = hooksecurefunc

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

local function SkinReadyDialogRewards(button, dungeonID)
	if not button.isSkinned then
		button:DisableDrawLayer("OVERLAY")
		button:SetTemplate()
		button:Size(26)
		S:HandleFrameHighlight(button)

		button.texture:SetInside()
		button.texture:SetTexCoord(unpack(E.TexCoords))

		button.isSkinned = true
	end

	local texturePath
	if button.rewardType == "misc" then
		texturePath = [[Interface\Icons\inv_misc_coin_02]]
		button:SetBackdropBorderColor(unpack(E.media.bordercolor))
	elseif dungeonID and button.rewardType == "shortage" then
		texturePath = select(2, GetLFGDungeonShortageRewardInfo(dungeonID, button.rewardArg, button.rewardID))
		local color = ITEM_QUALITY_COLORS[7]
		button:SetBackdropBorderColor(color.r, color.g, color.b)
	elseif dungeonID and button.rewardType == "reward" then
		texturePath = select(2, GetLFGDungeonRewardInfo(dungeonID, button.rewardID))
		local link = getLFGDungeonRewardLinkFix(dungeonID, button.rewardID)
		if link then
			button:SetBackdropBorderColor(GetItemQualityColor(select(3, GetItemInfo(link))))
		else
			button:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
	end

	if texturePath then
		SetPortraitToTexture(button.texture, nil)
		button.texture:SetTexture(texturePath)
	end
end

local function SkinLFGRewards(button, dungeonID, index)
	if not button then return end

	local buttonName = button:GetName()
	local icon = _G[buttonName.."IconTexture"]
	local name = _G[buttonName.."Name"]
	local count = _G[buttonName.."Count"]
	local texture = icon:GetTexture()

	if not button.isSkinned then
		button:StripTextures()
		button:SetTemplate("Transparent")
		button:StyleButton(nil, true)
		button:CreateBackdrop()
		button.backdrop:SetOutside(icon)

		icon:Point("TOPLEFT", 1, -1)
		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetParent(button.backdrop)
		icon:SetDrawLayer("OVERLAY")

		count:SetParent(button.backdrop)
		count:SetDrawLayer("OVERLAY")

		for i = 1, 2 do
			local role = _G[buttonName.."RoleIcon"..i]

			if role then
				role:SetParent(button.backdrop)
			end
		end

		local parentName = button:GetParent():GetName()
		if index == 1 then
			button:Point("TOPLEFT", _G[parentName.."RewardsDescription"], "BOTTOMLEFT", -5, -10)
		else
			button:Point("LEFT", _G[parentName.."Item1"], "RIGHT", 4, 0)
		end

		button.isSkinned = true
	end

	icon:SetTexture(texture)

	if button.shortageIndex then
		local color = ITEM_QUALITY_COLORS[7]
		button:SetBackdropBorderColor(color.r, color.g, color.b)
		button.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
		name:SetTextColor(color.r, color.g, color.b)
	else
		local link = getLFGDungeonRewardLinkFix(dungeonID, index)
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

local function SkinSpecificList(button)
	if not button or (button and button.isSkinned) then return end

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
	button.expandOrCollapseButton:SetHighlightTexture("")
	button.expandOrCollapseButton.SetHighlightTexture = E.noop

	local normal = button.expandOrCollapseButton:GetNormalTexture()
	normal:Size(18)
	normal:Point("CENTER", 3, 4)

	hooksecurefunc(button.expandOrCollapseButton, "SetNormalTexture", function(_, texture)
		if find(texture, "MinusButton") then
			normal:SetTexture(E.Media.Textures.Minus)
		else
			normal:SetTexture(E.Media.Textures.Plus)
		end
	end)

	button.isSkinned = true
end

local function SkinDungeonFinder()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.lfg then return end

	-- LFD Cap Bar
	LFDQueueFrameCapBar.label:Point("CENTER", 12, 0)
	LFDQueueFrameCapBar:Point("LEFT", 40, 0)

	LFDQueueFrameCapBar:StripTextures()
	LFDQueueFrameCapBar:CreateBackdrop()
	LFDQueueFrameCapBar.backdrop:Point("TOPLEFT", LFDQueueFrameCapBar, -1, -2)
	LFDQueueFrameCapBar.backdrop:Point("BOTTOMRIGHT", LFDQueueFrameCapBar, 1, 2)

	LFDQueueFrameCapBarProgress:SetTexture(E.media.normTex)

	for i = 1, 2 do
		_G["LFDQueueFrameCapBarCap"..i]:SetTexture(E.media.normTex)
		_G["LFDQueueFrameCapBarCap"..i.."Marker"]:Size(4, E.PixelMode and 14 or 12)
		_G["LFDQueueFrameCapBarCap"..i.."MarkerTexture"]:SetTexture(1, 1, 1, 0.40)
	end

	S:HandleCloseButton(LFDParentFrameCloseButton, LFDParentFrame)

	LFDParentFrame:StripTextures()
	LFDParentFrame:SetTemplate("Transparent")
	LFDParentFrameInset:StripTextures()
	LFDParentFrameEyeFrame:Kill()

	LFDQueueFrameBackground:Kill()

	LFDQueueFrameRoleButtonTank:Point("BOTTOMLEFT", LFDQueueFrame, 25, 334)
	LFDQueueFrameRoleButtonLeader:Point("LEFT", LFDQueueFrameRoleButtonDPS, "RIGHT", 50, 0)

	S:HandleButton(LFDQueueFrameFindGroupButton)
	LFDQueueFrameFindGroupButton:Point("BOTTOMLEFT", 5, 4)

	S:HandleButton(LFDQueueFrameCancelButton)
	LFDQueueFrameCancelButton:Point("BOTTOMRIGHT", -5, 4)

	S:HandleButton(LFDQueueFramePartyBackfillBackfillButton)
	S:HandleButton(LFDQueueFramePartyBackfillNoBackfillButton)
	S:HandleButton(LFDQueueFrameNoLFDWhileLFRLeaveQueueButton)

	S:HandleDropDownBox(LFDQueueFrameTypeDropDown)
	LFDQueueFrameTypeDropDown:Point("RIGHT", -16, 0)

	S:HandleScrollBar(LFDQueueFrameRandomScrollFrameScrollBar)
	LFDQueueFrameRandomScrollFrameScrollBar:ClearAllPoints()
	LFDQueueFrameRandomScrollFrameScrollBar:Point("TOPRIGHT", LFDQueueFrameRandomScrollFrame, 20, -17)
	LFDQueueFrameRandomScrollFrameScrollBar:Point("BOTTOMRIGHT", LFDQueueFrameRandomScrollFrame, 0, 12)

	LFDQueueFrameSpecificListScrollFrame:StripTextures()
	LFDQueueFrameSpecificListScrollFrame:CreateBackdrop("Transparent")
	LFDQueueFrameSpecificListScrollFrame.backdrop:Point("TOPLEFT", -5, -4)
	LFDQueueFrameSpecificListScrollFrame.backdrop:Point("BOTTOMRIGHT", 4, 4)

	S:HandleScrollBar(LFDQueueFrameSpecificListScrollFrameScrollBar)
	LFDQueueFrameSpecificListScrollFrameScrollBar:ClearAllPoints()
	LFDQueueFrameSpecificListScrollFrameScrollBar:Point("TOPRIGHT", LFDQueueFrameSpecificListScrollFrame, 25, -22)
	LFDQueueFrameSpecificListScrollFrameScrollBar:Point("BOTTOMRIGHT", LFDQueueFrameSpecificListScrollFrame, 0, 22)

	hooksecurefunc("LFDQueueFrameRandom_UpdateFrame", function()
		local dungeonID = LFDQueueFrame.type
		if type(dungeonID) ~= "number" then return end

		for i = 1, LFD_MAX_REWARDS do
			SkinLFGRewards(_G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i], dungeonID, i)
		end
	end)

	for i = 1, NUM_LFD_CHOICE_BUTTONS do
		SkinSpecificList(_G["LFDQueueFrameSpecificListButton"..i])
	end

	-- LFG Ready Dialog
	LFGDungeonReadyDialog:StripTextures()
	LFGDungeonReadyDialog:SetTemplate("Transparent")
	LFGDungeonReadyDialog.SetBackdrop = E.noop
	LFGDungeonReadyDialog.filigree:SetAlpha(0)
	LFGDungeonReadyDialog.bottomArt:SetAlpha(0)

	LFGDungeonReadyDialogBackground:Kill()

	S:HandleButton(LFGDungeonReadyDialogLeaveQueueButton)
	S:HandleButton(LFGDungeonReadyDialogEnterDungeonButton)

	S:HandleCloseButton(LFGDungeonReadyDialogCloseButton)

	hooksecurefunc("LFGDungeonReadyDialogReward_SetMisc", function(button)
		SkinReadyDialogRewards(button)
	end)

	hooksecurefunc("LFGDungeonReadyDialogReward_SetReward", function(button, dungeonID)
		SkinReadyDialogRewards(button, dungeonID)
	end)

	hooksecurefunc("LFGDungeonReadyDialog_UpdateRewards", function()
		for i = 1, LFG_ROLE_NUM_SHORTAGE_TYPES do
			local button = _G["LFGDungeonReadyDialogRewardsFrameReward"..i]
			if button and i ~= 1 then
				button:Point("LEFT", _G["LFGDungeonReadyDialogRewardsFrameReward"..i - 1], "RIGHT", 4, 0)
			end
		end
	end)

	LFGDungeonReadyDialogRoleIcon:StripTextures()
	LFGDungeonReadyDialogRoleIcon:CreateBackdrop()
	LFGDungeonReadyDialogRoleIcon.backdrop:Point("TOPLEFT", 7, -7)
	LFGDungeonReadyDialogRoleIcon.backdrop:Point("BOTTOMRIGHT", -7, 7)

	LFGDungeonReadyDialogRoleIconTexture:SetTexCoord(unpack(E.TexCoords))
	LFGDungeonReadyDialogRoleIconTexture.SetTexCoord = E.noop
	LFGDungeonReadyDialogRoleIconTexture:SetInside(LFGDungeonReadyDialogRoleIcon.backdrop)
	LFGDungeonReadyDialogRoleIconTexture:SetParent(LFGDungeonReadyDialogRoleIcon.backdrop)

	hooksecurefunc("LFGDungeonReadyPopup_Update", function()
		if LFGDungeonReadyDialogRoleIcon:IsShown() then
			local _, _, _, _, _, _, role = GetLFGProposal()

			if role == "DAMAGER" then
				LFGDungeonReadyDialogRoleIconTexture:SetTexture([[Interface\Icons\INV_Knife_1H_Common_B_01]])
			elseif role == "TANK" then
				LFGDungeonReadyDialogRoleIconTexture:SetTexture([[Interface\Icons\Ability_Defend]])
			elseif role == "HEALER" then
				LFGDungeonReadyDialogRoleIconTexture:SetTexture([[Interface\Icons\SPELL_NATURE_HEALINGTOUCH]])
			end
		end
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
			roleButton.texture:Point("TOPLEFT", roleButton.backdrop, -8, 6)
			roleButton.texture:Point("BOTTOMRIGHT", roleButton.backdrop, 8, -9)

			roleButton.statusIcon:SetDrawLayer("OVERLAY", 2)
		end
	end

	-- LFD Role Check PopUp
	LFDRoleCheckPopup:StripTextures()
	LFDRoleCheckPopup:SetTemplate("Transparent")

	S:HandleButton(LFDRoleCheckPopupAcceptButton)
	S:HandleButton(LFDRoleCheckPopupDeclineButton)

	-- LFG Invite PopUp
	LFGInvitePopup:StripTextures()
	LFGInvitePopup:SetTemplate("Transparent")

	S:HandleButton(LFGInvitePopupAcceptButton)
	S:HandleButton(LFGInvitePopupDeclineButton)

	-- Role Buttons
	local roleButtons = {
		-- Dungeon FInder
		LFDQueueFrameRoleButtonTank,
		LFDQueueFrameRoleButtonDPS,
		LFDQueueFrameRoleButtonHealer,
		LFDQueueFrameRoleButtonLeader,
		-- LFG Role Check
		LFDRoleCheckPopupRoleButtonTank,
		LFDRoleCheckPopupRoleButtonDPS,
		LFDRoleCheckPopupRoleButtonHealer,
		-- LFG Invite
		LFGInvitePopupRoleButtonTank,
		LFGInvitePopupRoleButtonDPS,
		LFGInvitePopupRoleButtonHealer
	}

	for _, btn in pairs(roleButtons) do
		S:HandleRoleButton(btn)
	end

	hooksecurefunc("LFG_SetRoleIconIncentive", function(roleButton, incentiveIndex)
		if incentiveIndex then
			local tex, r, g, b
			if incentiveIndex == LFG_ROLE_SHORTAGE_PLENTIFUL then
				tex = [[Interface\Icons\INV_Misc_Coin_19]]
				r, g, b = 0.82, 0.45, 0.25
			elseif incentiveIndex == LFG_ROLE_SHORTAGE_UNCOMMON then
				tex = [[Interface\Icons\INV_Misc_Coin_18]]
				r, g, b = 0.8, 0.8, 0.8
			elseif incentiveIndex == LFG_ROLE_SHORTAGE_RARE then
				tex = [[Interface\Icons\INV_Misc_Coin_17]]
				r, g, b = 1, 0.82, 0.2
			end

			SetPortraitToTexture(roleButton.incentiveIcon.texture, nil)
			roleButton.incentiveIcon.texture:SetTexture(tex)

			roleButton.backdrop:SetBackdropBorderColor(r, g, b)
			roleButton.incentiveIcon:SetBackdropBorderColor(r, g, b)
		else
			roleButton.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
	end)
end

local function SkinRaidFinder()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.lfg then return end

	RaidParentFrame:StripTextures()
	RaidParentFrame:SetTemplate("Transparent")

	RaidParentFrameInset:StripTextures()

	S:HandleCloseButton(RaidParentFrameCloseButton)

	for i = 1, 3 do
		S:HandleTab(_G["RaidParentFrameTab"..i])
	end

	RaidFinderQueueFrame:StripTextures(true)
	RaidFinderFrame:StripTextures()
	RaidFinderFrameRoleInset:StripTextures()

	S:HandleDropDownBox(RaidFinderQueueFrameSelectionDropDown)
	RaidFinderQueueFrameSelectionDropDown:Width(225)
	RaidFinderQueueFrameSelectionDropDown.SetWidth = E.noop

	S:HandleButton(RaidFinderFrameFindRaidButton, true)
	S:HandleButton(RaidFinderFrameCancelButton, true)
	S:HandleButton(RaidFinderQueueFrameIneligibleFrameLeaveQueueButton)

	RaidFinderQueueFrameScrollFrameChildFrameItem1:StripTextures()
	RaidFinderQueueFrameScrollFrameChildFrameItem1:SetTemplate("Transparent")
	RaidFinderQueueFrameScrollFrameChildFrameItem1:StyleButton(nil, true)
	RaidFinderQueueFrameScrollFrameChildFrameItem1:CreateBackdrop()
	RaidFinderQueueFrameScrollFrameChildFrameItem1.backdrop:SetOutside(RaidFinderQueueFrameScrollFrameChildFrameItem1IconTexture)

	RaidFinderQueueFrameScrollFrameChildFrameItem1IconTexture:Point("TOPLEFT", 1, -1)
	RaidFinderQueueFrameScrollFrameChildFrameItem1IconTexture:SetTexCoord(unpack(E.TexCoords))
	RaidFinderQueueFrameScrollFrameChildFrameItem1IconTexture:SetParent(RaidFinderQueueFrameScrollFrameChildFrameItem1.backdrop)
	RaidFinderQueueFrameScrollFrameChildFrameItem1IconTexture:SetDrawLayer("OVERLAY")

	RaidFinderQueueFrameScrollFrameChildFrameItem1Count:SetParent(RaidFinderQueueFrameScrollFrameChildFrameItem1.backdrop)
	RaidFinderQueueFrameScrollFrameChildFrameItem1Count:SetDrawLayer("OVERLAY")

	-- Role Buttons
	local roleButtons = {
		-- Raid FInder
		RaidFinderQueueFrameRoleButtonTank,
		RaidFinderQueueFrameRoleButtonDPS,
		RaidFinderQueueFrameRoleButtonHealer,
		RaidFinderQueueFrameRoleButtonLeader,
		-- LFG Queue
		LFRQueueFrameRoleButtonTank,
		LFRQueueFrameRoleButtonDPS,
		LFRQueueFrameRoleButtonHealer,
	}

	for _, btn in pairs(roleButtons) do
		S:HandleRoleButton(btn)
	end

	RaidFinderQueueFrameRoleButtonTank:Point("BOTTOMLEFT", RaidFinderQueueFrame, 25, 334)
	RaidFinderQueueFrameRoleButtonHealer:Point("LEFT", RaidFinderQueueFrameRoleButtonTank, "RIGHT", 23, 0)
	RaidFinderQueueFrameRoleButtonLeader:Point("LEFT", RaidFinderQueueFrameRoleButtonDPS, "RIGHT", 50, 0)

	LFRQueueFrameRoleButtonTank:Point("TOPLEFT", 58, -40)

	-- Side Tabs
	for i = 1, 2 do
		local tab = _G["LFRParentFrameSideTab"..i]
		local icon = tab:GetNormalTexture()

		tab:GetRegions():Hide()
		tab:SetTemplate()
		tab:StyleButton(nil, true)

		if i == 1 then
			tab:Point("TOPLEFT", LFRParentFrame, "TOPRIGHT", E.PixelMode and -1 or 1, -35)
		end

		icon:SetInside()
		icon:SetTexCoord(unpack(E.TexCoords))
	end

	-- Choose Frame
	LFRParentFrame:StripTextures()
	LFRQueueFrameListInset:StripTextures()
	LFRQueueFrameRoleInset:StripTextures()
	LFRQueueFrameCommentInset:StripTextures()

	S:HandleButton(LFRQueueFrameFindGroupButton)
	LFRQueueFrameFindGroupButton:Point("BOTTOMLEFT", 5, 3)

	S:HandleButton(LFRQueueFrameAcceptCommentButton)
	LFRQueueFrameAcceptCommentButton:Point("BOTTOMRIGHT", -6, 3)

	LFRQueueFrameCommentScrollFrame:CreateBackdrop()
	LFRQueueFrameCommentScrollFrame:Size(325, 40)
	LFRQueueFrameCommentScrollFrame:Point("TOPLEFT", LFRQueueFrame, "BOTTOMLEFT", 6, 70)

	S:HandleScrollBar(LFRQueueFrameCommentScrollFrameScrollBar)

	LFRQueueFrameSpecificListScrollFrame:StripTextures()
	LFRQueueFrameSpecificListScrollFrame:CreateBackdrop("Transparent")
	LFRQueueFrameSpecificListScrollFrame:ClearAllPoints()
	LFRQueueFrameSpecificListScrollFrame:Point("TOPLEFT", LFRQueueFrameSpecificListButton1)
	LFRQueueFrameSpecificListScrollFrame:Point("BOTTOMRIGHT", LFRQueueFrameSpecificListButton14, 0, -2)

	S:HandleScrollBar(LFRQueueFrameSpecificListScrollFrameScrollBar)
	LFRQueueFrameSpecificListScrollFrameScrollBar:ClearAllPoints()
	LFRQueueFrameSpecificListScrollFrameScrollBar:Point("TOPRIGHT", LFRQueueFrameSpecificListScrollFrame, 24, -17)
	LFRQueueFrameSpecificListScrollFrameScrollBar:Point("BOTTOMRIGHT", LFRQueueFrameSpecificListScrollFrame, 0, 17)

	for i = 1, NUM_LFR_CHOICE_BUTTONS do
		SkinSpecificList(_G["LFRQueueFrameSpecificListButton"..i])
	end

	S:HandleButton(LFRQueueFrameNoLFRWhileLFDLeaveQueueButton)

	-- Browse Frame
	LFRBrowseFrame:StripTextures()

	for i = 1, 7 do
		local button = "LFRBrowseFrameColumnHeader"..i

		_G[button.."Left"]:Kill()
		_G[button.."Middle"]:Kill()
		_G[button.."Right"]:Kill()

		_G[button]:StyleButton()

		if i == 1 then
			_G[button]:Width(88)
		end
	end

	S:HandleButton(LFRBrowseFrameSendMessageButton)
	LFRBrowseFrameSendMessageButton:Point("BOTTOMLEFT", 5, 4)

	S:HandleButton(LFRBrowseFrameInviteButton)
	LFRBrowseFrameInviteButton:Point("LEFT", LFRBrowseFrameSendMessageButton, "RIGHT", 5, 0)

	S:HandleButton(LFRBrowseFrameRefreshButton)
	LFRBrowseFrameRefreshButton:Point("LEFT", LFRBrowseFrameInviteButton, "RIGHT", 5, 0)

	S:HandleDropDownBox(LFRBrowseFrameRaidDropDown)

	LFRBrowseFrameListScrollFrame:StripTextures()
	LFRBrowseFrameListScrollFrame:CreateBackdrop("Transparent")
	LFRBrowseFrameListScrollFrame:ClearAllPoints()
	LFRBrowseFrameListScrollFrame:Point("TOPLEFT", LFRBrowseFrameListButton1)
	LFRBrowseFrameListScrollFrame:Point("BOTTOMRIGHT", LFRBrowseFrameListButton19, 5, -2)

	S:HandleScrollBar(LFRBrowseFrameListScrollFrameScrollBar)
	LFRBrowseFrameListScrollFrameScrollBar:ClearAllPoints()
	LFRBrowseFrameListScrollFrameScrollBar:Point("TOPRIGHT", LFRBrowseFrameListScrollFrame, 24, -17)
	LFRBrowseFrameListScrollFrameScrollBar:Point("BOTTOMRIGHT", LFRBrowseFrameListScrollFrame, 0, 17)

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
end

local function SkinSearchStatus()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.lfg then return end

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

	LFGSearchStatusIndividualRoleDisplayTank1Texture:SetTexture([[Interface\Icons\Ability_Defend]])
	LFGSearchStatusIndividualRoleDisplayHealer1Texture:SetTexture([[Interface\Icons\SPELL_NATURE_HEALINGTOUCH]])
	LFGSearchStatusIndividualRoleDisplayDamage1Texture:SetTexture([[Interface\Icons\INV_Knife_1H_Common_B_01]])
	LFGSearchStatusIndividualRoleDisplayDamage2Texture:SetTexture([[Interface\Icons\INV_Knife_1H_Common_B_01]])
	LFGSearchStatusIndividualRoleDisplayDamage3Texture:SetTexture([[Interface\Icons\INV_Knife_1H_Common_B_01]])

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

	LFGSearchStatusGroupedRoleDisplayTankTexture:SetTexture([[Interface\Icons\Ability_Defend]])
	LFGSearchStatusGroupedRoleDisplayHealerTexture:SetTexture([[Interface\Icons\SPELL_NATURE_HEALINGTOUCH]])
	LFGSearchStatusGroupedRoleDisplayDamageTexture:SetTexture([[Interface\Icons\INV_Knife_1H_Common_B_01]])

	hooksecurefunc("LFGSearchStatus_UpdateRoles", function()
		local _, tank, healer, damage = GetLFGRoles()
		local currentIcon = 1

		if tank then
			local icon = _G["LFGSearchStatusRoleIcon"..currentIcon]
			icon:SetTexture(E.Media.Textures.Tank)
			icon:SetTexCoord(0, 1, 0, 1)
			icon:Size(20)
			currentIcon = currentIcon + 1
		end
		if healer then
			local icon = _G["LFGSearchStatusRoleIcon"..currentIcon]
			icon:SetTexture(E.Media.Textures.Healer)
			icon:SetTexCoord(0, 1, 0, 1)
			icon:Size(20)
			currentIcon = currentIcon + 1
		end
		if damage then
			local icon = _G["LFGSearchStatusRoleIcon"..currentIcon]
			icon:SetTexture(E.Media.Textures.DPS)
			icon:SetTexCoord(0, 1, 0, 1)
			icon:Size(20)
		end
	end)
end

S:AddCallback("DungeonFinder", SkinDungeonFinder)
S:AddCallback("RaidFinder", SkinRaidFinder)
S:AddCallback("SearchStatus", SkinSearchStatus)