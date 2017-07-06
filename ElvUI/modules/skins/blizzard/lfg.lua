local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule("Skins")

local _G = _G;
local pairs, unpack, select = pairs, unpack, select;
local find = string.find;

local function LoadSkin()
	if(E.private.skins.blizzard.enable ~= true) or (E.private.skins.blizzard.lfg ~= true) then return; end

	-- LFD Frames
	local buttons = {
		"LFDQueueFrameFindGroupButton",
		"LFDQueueFrameCancelButton",
		"LFDQueueFramePartyBackfillBackfillButton",
		"LFDQueueFramePartyBackfillNoBackfillButton",
		"LFDQueueFrameNoLFDWhileLFRLeaveQueueButton"
	};

	for i = 1, #buttons do
		_G[buttons[i]]:StripTextures();
		S:HandleButton(_G[buttons[i]]);
	end

	LFDQueueFrame:StripTextures();
	LFDQueueFrameRandom:StripTextures();
	LFDQueueFrameRandomScrollFrame:StripTextures();

	LFDParentFrame:StripTextures();
	LFDParentFrame:SetTemplate("Transparent");

	S:HandleCloseButton(LFDParentFrameCloseButton, LFDParentFrame);

	LFDQueueFrameBackground:Kill();
	LFDParentFrameInset:Kill();
	LFDParentFrameEyeFrame:Kill();

	S:HandleDropDownBox(LFDQueueFrameTypeDropDown, 300);
	LFDQueueFrameTypeDropDown:Point("RIGHT", -10, 0);

	-- LFD Cap Bar
	LFDQueueFrameCapBar.label:Point("CENTER", 12, 0);
	LFDQueueFrameCapBar:Point("LEFT", 40, 0);

	LFDQueueFrameCapBar:StripTextures();
	LFDQueueFrameCapBar:CreateBackdrop("Default");
	LFDQueueFrameCapBar.backdrop:Point("TOPLEFT", LFDQueueFrameCapBar, "TOPLEFT", -1, -2);
	LFDQueueFrameCapBar.backdrop:Point("BOTTOMRIGHT", LFDQueueFrameCapBar, "BOTTOMRIGHT", 1, 2);

	LFDQueueFrameCapBarProgress:SetTexture(E["media"].normTex);

	for i = 1, 2 do
		_G["LFDQueueFrameCapBarCap"..i.."Marker"]:Kill();
		_G["LFDQueueFrameCapBarCap"..i]:SetTexture(E["media"].normTex);
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

		_G[lfdRoleIcons[i]].icon = _G[lfdRoleIcons[i]]:CreateTexture(nil, "ARTWORK")
		_G[lfdRoleIcons[i]].icon:SetTexCoord(unpack(E.TexCoords))
		_G[lfdRoleIcons[i]].icon:SetInside(_G[lfdRoleIcons[i]].backdrop)
	end

	LFDQueueFrameRoleButtonTank:Point("BOTTOMLEFT", LFDQueueFrame, "BOTTOMLEFT", 25, 334)
	LFDQueueFrameRoleButtonHealer:Point("LEFT", LFDQueueFrameRoleButtonTank,"RIGHT", 23, 0)
	LFDQueueFrameRoleButtonLeader:Point("LEFT", LFDQueueFrameRoleButtonDPS, "RIGHT", 50, 0)

	LFDQueueFrameRoleButtonTank.icon:SetTexture("Interface\\Icons\\Ability_Defend")
	LFDQueueFrameRoleButtonHealer.icon:SetTexture("Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH")
	LFDQueueFrameRoleButtonDPS.icon:SetTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01")
	LFDQueueFrameRoleButtonLeader.icon:SetTexture("Interface\\Icons\\Ability_Vehicle_LaunchPlayer")

	-- LFD Rewards
	hooksecurefunc("LFDQueueFrameRandom_UpdateFrame", function()
		local dungeonID = LFDQueueFrame.type
		if type(dungeonID) == "string" then return end
		local _, _, _, _, _, numRewards = GetLFGDungeonRewards(dungeonID)

		for i = 1, LFD_MAX_REWARDS do
			local button = _G["LFDQueueFrameRandomScrollFrameChildFrameItem" .. i];
			local icon = _G["LFDQueueFrameRandomScrollFrameChildFrameItem" .. i .. "IconTexture"];
			local count = _G["LFDQueueFrameRandomScrollFrameChildFrameItem" .. i .. "Count"];
			local name  = _G["LFDQueueFrameRandomScrollFrameChildFrameItem" .. i .. "Name"];
			local role1 = _G["LFDQueueFrameRandomScrollFrameChildFrameItem" .. i .. "RoleIcon1"];
			local role2 = _G["LFDQueueFrameRandomScrollFrameChildFrameItem" .. i .. "RoleIcon2"];
			local role3 = _G["LFDQueueFrameRandomScrollFrameChildFrameItem" .. i .. "RoleIcon3"];

			if(button and not button.reskinned) then
				local __texture = _G[button:GetName().."IconTexture"]:GetTexture()

				button:StripTextures();
				button:CreateBackdrop();
				button.backdrop:SetOutside(icon);

				icon:SetTexture(__texture)
				icon:SetTexCoord(unpack(E.TexCoords));
				icon:SetParent(button.backdrop);
				icon.SetPoint = E.noop;

				icon:SetDrawLayer("OVERLAY");
				count:SetDrawLayer("OVERLAY");

				if(count) then count:SetParent(button.backdrop); end
				if(role1) then role1:SetParent(button.backdrop); end
				if(role2) then role2:SetParent(button.backdrop); end
				if(role3) then role3:SetParent(button.backdrop); end

				button:HookScript("OnUpdate", function(self)
					button.backdrop:SetBackdropBorderColor(0, 0, 0);
					name:SetTextColor(1, 1, 1);
					if(button.dungeonID) then
						local Link = GetLFGDungeonRewardLink(button.dungeonID, i);
						if(Link) then
							local quality = select(3, GetItemInfo(Link));
							if(quality and quality > 1) then
								button.backdrop:SetBackdropBorderColor(GetItemQualityColor(quality));
								name:SetTextColor(GetItemQualityColor(quality));
							end
						end
					end
				end)

				button.reskinned = true;
			end
		end
	end)

	-- LFD Specific List
	LFDQueueFrameSpecific:StripTextures()

	LFDQueueFrameSpecificListScrollFrame:StripTextures()
	LFDQueueFrameSpecificListScrollFrame:Height(LFDQueueFrameSpecificListScrollFrame:GetHeight() - 8)

	S:HandleScrollBar(LFDQueueFrameSpecificListScrollFrameScrollBar)

	for i = 1, NUM_LFD_CHOICE_BUTTONS do
		local button = _G["LFDQueueFrameSpecificListButton" .. i];
		button.enableButton:StripTextures();
		button.enableButton:CreateBackdrop("Default");
		button.enableButton.backdrop:SetInside(nil, 4, 4);

		button.expandOrCollapseButton:SetNormalTexture("Interface\\Buttons\\UI-PlusMinus-Buttons");
		button.expandOrCollapseButton.SetNormalTexture = E.noop;
		button.expandOrCollapseButton:SetHighlightTexture(nil);
		button.expandOrCollapseButton:GetNormalTexture():Size(12);
		button.expandOrCollapseButton:GetNormalTexture():Point("CENTER", 4, 0);

		hooksecurefunc(button.expandOrCollapseButton, "SetNormalTexture", function(self, texture)
			if(find(texture, "MinusButton")) then
				self:GetNormalTexture():SetTexCoord(0.5625, 1, 0, 0.4375);
			else
				self:GetNormalTexture():SetTexCoord(0, 0.4375, 0, 0.4375);
			end
		end);
 	end

	--LFD Role Picker PopUp Frame
	LFDRoleCheckPopup:StripTextures();
	LFDRoleCheckPopup:SetTemplate("Transparent");

	S:HandleButton(LFDRoleCheckPopupAcceptButton);
	S:HandleButton(LFDRoleCheckPopupDeclineButton);

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

		_G[roleCheckPopUp[i]].icon = _G[roleCheckPopUp[i]]:CreateTexture(nil, "ARTWORK")
		_G[roleCheckPopUp[i]].icon:SetTexCoord(unpack(E.TexCoords))
		_G[roleCheckPopUp[i]].icon:SetInside(_G[roleCheckPopUp[i]].backdrop)
	end

	LFDRoleCheckPopupRoleButtonTank.icon:SetTexture("Interface\\Icons\\Ability_Defend")
	LFDRoleCheckPopupRoleButtonHealer.icon:SetTexture("Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH")
	LFDRoleCheckPopupRoleButtonDPS.icon:SetTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01")

	--LFG Search Status
	LFGSearchStatus:SetTemplate("Transparent");

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

		_G[lfgSearchStatusIcons[i]].icon = _G[lfgSearchStatusIcons[i]]:CreateTexture(nil, "ARTWORK")
		_G[lfgSearchStatusIcons[i]].icon:SetTexCoord(unpack(E.TexCoords))
		_G[lfgSearchStatusIcons[i]].icon:SetInside(_G[lfgSearchStatusIcons[i]].backdrop)
	end

	LFGSearchStatusIndividualRoleDisplayTank1.icon:SetTexture("Interface\\Icons\\Ability_Defend")
	LFGSearchStatusIndividualRoleDisplayHealer1.icon:SetTexture("Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH")
	LFGSearchStatusIndividualRoleDisplayDamage1.icon:SetTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01")
	LFGSearchStatusIndividualRoleDisplayDamage2.icon:SetTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01")
	LFGSearchStatusIndividualRoleDisplayDamage3.icon:SetTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01")

	hooksecurefunc("LFGSearchStatusPlayer_SetFound", function(button, isFound)
		if(button.icon) then
			if(isFound) then
				button.icon:SetDesaturated(false);
			else
				button.icon:SetDesaturated(true);
			end
		end
	end)

	hooksecurefunc("LFGSearchStatus_UpdateRoles", function()
		local _, tank, healer, damage = GetLFGRoles();
		local currentIcon = 1;
		if(tank) then
			local icon = _G["LFGSearchStatusRoleIcon"..currentIcon]
			icon:SetTexture("Interface\\AddOns\\ElvUI\\media\\textures\\tank.tga")
			icon:SetTexCoord(unpack(E.TexCoords));
			icon:Size(22)
			currentIcon = currentIcon + 1;
		end
		if(healer) then
			local icon = _G["LFGSearchStatusRoleIcon"..currentIcon]
			icon:SetTexture("Interface\\AddOns\\ElvUI\\media\\textures\\healer.tga")
			icon:SetTexCoord(unpack(E.TexCoords));
			icon:Size(20)
			currentIcon = currentIcon + 1;
		end
		if(damage) then
			local icon = _G["LFGSearchStatusRoleIcon"..currentIcon]
			icon:SetTexture("Interface\\AddOns\\ElvUI\\media\\textures\\dps.tga")
			icon:SetTexCoord(unpack(E.TexCoords));
			icon:Size(17)
			currentIcon = currentIcon + 1;
		end
	end)

	--LFG Ready Dialog
	LFGDungeonReadyDialogBackground:Kill();
	LFGDungeonReadyDialog:SetTemplate("Transparent");
	LFGDungeonReadyDialog.SetBackdrop = E.noop;
	LFGDungeonReadyDialog.filigree:SetAlpha(0);
	LFGDungeonReadyDialog.bottomArt:SetAlpha(0);

	S:HandleButton(LFGDungeonReadyDialogLeaveQueueButton);
	S:HandleButton(LFGDungeonReadyDialogEnterDungeonButton);

	S:HandleCloseButton(LFGDungeonReadyDialogCloseButton);
	LFGDungeonReadyDialogCloseButton.text:SetText("-");
	LFGDungeonReadyDialogCloseButton.text:FontTemplate(nil, 22);

	hooksecurefunc("LFGDungeonReadyDialog_UpdateRewards", function()
		for i = 1, LFG_ROLE_NUM_SHORTAGE_TYPES do
			local reward = _G["LFGDungeonReadyDialogRewardsFrameReward" .. i];
			local texture = _G["LFGDungeonReadyDialogRewardsFrameReward" .. i .. "Texture"];
			local border = _G["LFGDungeonReadyDialogRewardsFrameReward" .. i .. "Border"];

			if(reward and not reward.IsDone) then
				border:Kill()
				reward:CreateBackdrop();
				reward.backdrop:Point("TOPLEFT", 7, -7);
				reward.backdrop:Point("BOTTOMRIGHT", -7, 7);

				texture:SetTexCoord(unpack(E.TexCoords));
				texture:SetInside(reward.backdrop);

				reward.IsDone = true;
			end
		end
	end)

	LFGDungeonReadyDialogRoleIcon:StripTextures();
	LFGDungeonReadyDialogRoleIcon:CreateBackdrop();
	LFGDungeonReadyDialogRoleIcon.backdrop:Point("TOPLEFT", 7, -7);
	LFGDungeonReadyDialogRoleIcon.backdrop:Point("BOTTOMRIGHT", -7, 7);
	LFGDungeonReadyDialogRoleIcon.icon = LFGDungeonReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY");

	hooksecurefunc("LFGDungeonReadyPopup_Update", function()
		local _, _, _, _, _, _, role = GetLFGProposal();

		if(role == "DAMAGER") then
			LFGDungeonReadyDialogRoleIcon.icon:SetTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01");
		elseif(role == "TANK") then
			LFGDungeonReadyDialogRoleIcon.icon:SetTexture("Interface\\Icons\\Ability_Defend");
		elseif(role == "HEALER") then
			LFGDungeonReadyDialogRoleIcon.icon:SetTexture("Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH");
		end

		LFGDungeonReadyDialogRoleIcon.icon:SetTexCoord(unpack(E.TexCoords));
		LFGDungeonReadyDialogRoleIcon.icon:SetInside(LFGDungeonReadyDialogRoleIcon.backdrop);
	end)

	-- LFG Ready Status
	LFGDungeonReadyStatus:StripTextures();
	LFGDungeonReadyStatus:SetTemplate("Transparent");

	S:HandleCloseButton(LFGDungeonReadyStatusCloseButton);

	do
		local roleButtons = {LFGDungeonReadyStatusGroupedTank, LFGDungeonReadyStatusGroupedHealer, LFGDungeonReadyStatusGroupedDamager};
		for i = 1, 5 do
			tinsert(roleButtons, _G["LFGDungeonReadyStatusIndividualPlayer"..i]);
		end
		for _, roleButton in pairs (roleButtons) do
			roleButton:CreateBackdrop("Default", true);
			roleButton.texture:SetTexture("Interface\\AddOns\\ElvUI\\media\\textures\\lfgRoleIcons");
			roleButton.statusIcon:SetDrawLayer("OVERLAY", 2);
		end
	end

	-- Raid Finder
	RaidParentFrame:StripTextures();
	RaidParentFrame:SetTemplate("Transparent");

	RaidParentFrameInset:StripTextures();

	S:HandleCloseButton(RaidParentFrameCloseButton);

	for i = 1, 2 do
		local tab = _G["LFRParentFrameSideTab"..i];
		tab:GetRegions():Hide();
		tab:SetTemplate("Default");
		tab:StyleButton(nil, true);
		tab:GetNormalTexture():SetInside();
		tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords));
	end

	for i = 1, 3 do 
		S:HandleTab(_G["RaidParentFrameTab"..i]);
	end

	LFRParentFrameSideTab1:Point("TOPLEFT", LFRParentFrame, "TOPRIGHT", E.PixelMode and -1 or 1, -35)

	RaidFinderQueueFrame:StripTextures(true);
	RaidFinderFrame:StripTextures();
	RaidFinderFrameRoleInset:StripTextures();

	S:HandleDropDownBox(RaidFinderQueueFrameSelectionDropDown);
	RaidFinderQueueFrameSelectionDropDown:Width(225);
	RaidFinderQueueFrameSelectionDropDown.SetWidth = E.noop;

	S:HandleButton(RaidFinderFrameFindRaidButton, true);
	S:HandleButton(RaidFinderFrameCancelButton, true);
	S:HandleButton(RaidFinderQueueFrameIneligibleFrameLeaveQueueButton);

	for i = 1, 1 do
		local button = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i];
		local icon = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."IconTexture"];
		local count = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."Count"];

		if(button) then
			button:StripTextures();
			button:CreateBackdrop();
			button.backdrop:SetOutside(icon);

			icon:SetTexCoord(unpack(E.TexCoords));
			icon:SetParent(button.backdrop);

			icon:SetDrawLayer("OVERLAY");
			count:SetDrawLayer("OVERLAY");

			if(count) then count:SetParent(button.backdrop) end
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

		_G[raidFinderQueueRoles[i]].icon = _G[raidFinderQueueRoles[i]]:CreateTexture(nil, "ARTWORK")
		_G[raidFinderQueueRoles[i]].icon:SetTexCoord(unpack(E.TexCoords))
		_G[raidFinderQueueRoles[i]].icon:SetInside(_G[raidFinderQueueRoles[i]].backdrop)
	end

	RaidFinderQueueFrameRoleButtonTank.icon:SetTexture("Interface\\Icons\\Ability_Defend")
	RaidFinderQueueFrameRoleButtonHealer.icon:SetTexture("Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH")
	RaidFinderQueueFrameRoleButtonDPS.icon:SetTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01")
	RaidFinderQueueFrameRoleButtonLeader.icon:SetTexture("Interface\\Icons\\Ability_Vehicle_LaunchPlayer")

	RaidFinderQueueFrameRoleButtonTank:Point("BOTTOMLEFT", RaidFinderQueueFrame, "BOTTOMLEFT", 25, 334)
	RaidFinderQueueFrameRoleButtonHealer:Point("LEFT", RaidFinderQueueFrameRoleButtonTank, "RIGHT", 23, 0)
	RaidFinderQueueFrameRoleButtonLeader:Point("LEFT", RaidFinderQueueFrameRoleButtonDPS, "RIGHT", 50, 0)

	-- LFR Queue Frame
	LFRParentFrame:StripTextures();
	LFRQueueFrame:StripTextures();
	LFRQueueFrameListInset:StripTextures();
	LFRQueueFrameRoleInset:StripTextures();
	LFRQueueFrameCommentInset:StripTextures();

	S:HandleScrollBar(LFRQueueFrameCommentScrollFrameScrollBar);

	S:HandleButton(LFRQueueFrameFindGroupButton);
	S:HandleButton(LFRQueueFrameAcceptCommentButton);

	LFRQueueFrameCommentTextButton:CreateBackdrop("Default");
	LFRQueueFrameCommentTextButton:Height(35);

	LFRQueueFrameSpecificListScrollFrame:StripTextures();
	LFRQueueFrameSpecificListScrollFrame:ClearAllPoints()
	LFRQueueFrameSpecificListScrollFrame:Point("TOPLEFT", LFRQueueFrameSpecificListButton1, "TOPLEFT", 0, 0)
	LFRQueueFrameSpecificListScrollFrame:Point("BOTTOMRIGHT", LFRQueueFrameSpecificListButton14, "BOTTOMRIGHT", 0, -2)

	S:HandleScrollBar(LFRQueueFrameSpecificListScrollFrameScrollBar)

	S:HandleButton(LFRQueueFrameNoLFRWhileLFDLeaveQueueButton);

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

		_G[lfrQueueRoles[i]].icon = _G[lfrQueueRoles[i]]:CreateTexture(nil, "ARTWORK")
		_G[lfrQueueRoles[i]].icon:SetTexCoord(unpack(E.TexCoords))
		_G[lfrQueueRoles[i]].icon:SetInside(_G[lfrQueueRoles[i]].backdrop)
	end

	LFRQueueFrameRoleButtonTank.icon:SetTexture("Interface\\Icons\\Ability_Defend")
	LFRQueueFrameRoleButtonHealer.icon:SetTexture("Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH")
	LFRQueueFrameRoleButtonDPS.icon:SetTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01")

	LFRQueueFrameRoleButtonTank:Point("TOPLEFT", LFRQueueFrame, "TOPLEFT", 50, -45)
	LFRQueueFrameRoleButtonHealer:Point("LEFT", LFRQueueFrameRoleButtonTank, "RIGHT", 43, 0)

	for i = 1, NUM_LFR_CHOICE_BUTTONS do
		local button = _G["LFRQueueFrameSpecificListButton" .. i];
		S:HandleCheckBox(button.enableButton);

		button.expandOrCollapseButton:SetNormalTexture("Interface\\Buttons\\UI-PlusMinus-Buttons");
		button.expandOrCollapseButton.SetNormalTexture = E.noop;
		button.expandOrCollapseButton:SetHighlightTexture(nil);
		button.expandOrCollapseButton:GetNormalTexture():Size(12);
		button.expandOrCollapseButton:GetNormalTexture():Point("CENTER", 4, 0);

		hooksecurefunc(button.expandOrCollapseButton, "SetNormalTexture", function(self, texture)
			if(find(texture, "MinusButton")) then
				self:GetNormalTexture():SetTexCoord(0.5625, 1, 0, 0.4375);
			else
				self:GetNormalTexture():SetTexCoord(0, 0.4375, 0, 0.4375);
			end
		end);
 	end

	-- LFR Browse Frame
	LFRBrowseFrame:StripTextures();
	LFRBrowseFrame:HookScript("OnShow", function()
		if(not LFRBrowseFrameListScrollFrameScrollBar.skinned) then
			S:HandleScrollBar(LFRBrowseFrameListScrollFrameScrollBar);
			LFRBrowseFrameListScrollFrameScrollBar.skinned = true;
		end
	end)

	--[[
	hooksecurefunc("LFRBrowseFrameListButton_SetData", function(button, index)
		local name, level, _, _, _, _, _, class = SearchLFGGetResults(index)

		local classTextColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class];
		local levelTextColor = GetQuestDifficultyColor(level);

		if(index and class and name and level and (name ~= myName)) then
			button.name:SetTextColor(classTextColor.r, classTextColor.g, classTextColor.b);
			button.class:SetTextColor(classTextColor.r, classTextColor.g, classTextColor.b);
			button.level:SetTextColor(levelTextColor.r, levelTextColor.g, levelTextColor.b);
		end
	end)
	]]

	LFRBrowseFrameListScrollFrame:ClearAllPoints()
	LFRBrowseFrameListScrollFrame:Point("TOPLEFT", LFRBrowseFrameListButton1, "TOPLEFT", 0, 0)
	LFRBrowseFrameListScrollFrame:Point("BOTTOMRIGHT", LFRBrowseFrameListButton19, "BOTTOMRIGHT", 5, -2)

	S:HandleDropDownBox(LFRBrowseFrameRaidDropDown);

	S:HandleButton(LFRBrowseFrameSendMessageButton);
	S:HandleButton(LFRBrowseFrameInviteButton);
	S:HandleButton(LFRBrowseFrameRefreshButton);

	for i = 1, 7 do
		local button = "LFRBrowseFrameColumnHeader"..i;
		_G[button.."Left"]:Kill();
		_G[button.."Middle"]:Kill();
		_G[button.."Right"]:Kill();
		_G[button]:StyleButton();
	end

	-- Desaturate/Incentive Scripts (Role Icons)
	hooksecurefunc("LFG_SetRoleIconIncentive", function(roleButton, incentiveIndex)
		if(incentiveIndex) then
			roleButton.backdrop:SetBackdropBorderColor(1, 0.80, 0.10);
		else
			roleButton.backdrop:SetBackdropBorderColor(unpack(E["media"].bordercolor));
		end
	end)

	hooksecurefunc("LFG_PermanentlyDisableRoleButton", function(button)
		if(button.icon) then
			button.icon:SetDesaturated(true);
		end
	end)

	hooksecurefunc("LFG_DisableRoleButton", function(button)
		if(button.icon) then
			button.icon:SetDesaturated(true);
		end
	end)

	hooksecurefunc("LFG_EnableRoleButton", function(button)
		if(button.icon) then
			button.icon:SetDesaturated(false);
		end
	end)
end

S:AddCallback("LFG", LoadSkin);