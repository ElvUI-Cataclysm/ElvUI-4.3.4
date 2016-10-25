local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule("Skins")

local _G = _G;
local unpack, pairs = unpack, pairs;
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
	S:HandleCheckBox(LFDQueueFrameRoleButtonTank:GetChildren());
	S:HandleCheckBox(LFDQueueFrameRoleButtonHealer:GetChildren());
	S:HandleCheckBox(LFDQueueFrameRoleButtonDPS:GetChildren());
	S:HandleCheckBox(LFDQueueFrameRoleButtonLeader:GetChildren());

	LFDQueueFrameRoleButtonTank:GetChildren():SetFrameLevel(LFDQueueFrameRoleButtonTank:GetChildren():GetFrameLevel() + 2);
	LFDQueueFrameRoleButtonHealer:GetChildren():SetFrameLevel(LFDQueueFrameRoleButtonHealer:GetChildren():GetFrameLevel() + 2);
	LFDQueueFrameRoleButtonDPS:GetChildren():SetFrameLevel(LFDQueueFrameRoleButtonDPS:GetChildren():GetFrameLevel() + 2);
	LFDQueueFrameRoleButtonLeader:GetChildren():SetFrameLevel(LFDQueueFrameRoleButtonLeader:GetChildren():GetFrameLevel() + 2);

	LFDQueueFrameRoleButtonTank:Point("BOTTOMLEFT", LFDQueueFrame, "BOTTOMLEFT", 25, 334);
	LFDQueueFrameRoleButtonHealer:Point("LEFT", LFDQueueFrameRoleButtonTank,"RIGHT", 23, 0);
	LFDQueueFrameRoleButtonLeader:Point("LEFT", LFDQueueFrameRoleButtonDPS, "RIGHT", 50, 0);

	LFDQueueFrameRoleButtonTank:StripTextures();
	LFDQueueFrameRoleButtonTank:CreateBackdrop();
	LFDQueueFrameRoleButtonTank.backdrop:Point("TOPLEFT", 3, -3);
	LFDQueueFrameRoleButtonTank.backdrop:Point("BOTTOMRIGHT", -3, 3);
	LFDQueueFrameRoleButtonTank.icon = LFDQueueFrameRoleButtonTank:CreateTexture(nil, "OVERLAY");
	LFDQueueFrameRoleButtonTank.icon:SetTexCoord(unpack(E.TexCoords));
	LFDQueueFrameRoleButtonTank.icon:SetTexture("Interface\\Icons\\Ability_Defend");
	LFDQueueFrameRoleButtonTank.icon:SetInside(LFDQueueFrameRoleButtonTank.backdrop);

	LFDQueueFrameRoleButtonHealer:StripTextures();
	LFDQueueFrameRoleButtonHealer:CreateBackdrop();
	LFDQueueFrameRoleButtonHealer.backdrop:Point("TOPLEFT", 3, -3);
	LFDQueueFrameRoleButtonHealer.backdrop:Point("BOTTOMRIGHT", -3, 3);
	LFDQueueFrameRoleButtonHealer.icon = LFDQueueFrameRoleButtonHealer:CreateTexture(nil, "OVERLAY");
	LFDQueueFrameRoleButtonHealer.icon:SetTexCoord(unpack(E.TexCoords));
	LFDQueueFrameRoleButtonHealer.icon:SetTexture("Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH");
	LFDQueueFrameRoleButtonHealer.icon:SetInside(LFDQueueFrameRoleButtonHealer.backdrop);

	LFDQueueFrameRoleButtonDPS:StripTextures();
	LFDQueueFrameRoleButtonDPS:CreateBackdrop();
	LFDQueueFrameRoleButtonDPS.backdrop:Point("TOPLEFT", 3, -3);
	LFDQueueFrameRoleButtonDPS.backdrop:Point("BOTTOMRIGHT", -3, 3);
	LFDQueueFrameRoleButtonDPS.icon = LFDQueueFrameRoleButtonDPS:CreateTexture(nil, "OVERLAY");
	LFDQueueFrameRoleButtonDPS.icon:SetTexCoord(unpack(E.TexCoords));
	LFDQueueFrameRoleButtonDPS.icon:SetTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01");
	LFDQueueFrameRoleButtonDPS.icon:SetInside(LFDQueueFrameRoleButtonDPS.backdrop);

	LFDQueueFrameRoleButtonLeader:StripTextures();
	LFDQueueFrameRoleButtonLeader:CreateBackdrop();
	LFDQueueFrameRoleButtonLeader.backdrop:Point("TOPLEFT", 3, -3);
	LFDQueueFrameRoleButtonLeader.backdrop:Point("BOTTOMRIGHT", -3, 3);
	LFDQueueFrameRoleButtonLeader.icon = LFDQueueFrameRoleButtonLeader:CreateTexture(nil, "OVERLAY");
	LFDQueueFrameRoleButtonLeader.icon:SetTexCoord(unpack(E.TexCoords));
	LFDQueueFrameRoleButtonLeader.icon:SetTexture("Interface\\Icons\\Ability_Vehicle_LaunchPlayer");
	LFDQueueFrameRoleButtonLeader.icon:SetInside(LFDQueueFrameRoleButtonLeader.backdrop);

	-- LFD Rewards
	for i = 1, LFD_MAX_REWARDS do
		local button = _G["LFDQueueFrameRandomScrollFrameChildFrameItem" .. i];
		local icon = _G["LFDQueueFrameRandomScrollFrameChildFrameItem" ..  i .. "IconTexture"];
		local count = _G["LFDQueueFrameRandomScrollFrameChildFrameItem" .. i .. "Count"];
		local name  = _G["LFDQueueFrameRandomScrollFrameChildFrameItem" .. i .. "Name"];
		local role1 = _G["LFDQueueFrameRandomScrollFrameChildFrameItem" .. i .. "RoleIcon1"];
		local role2 = _G["LFDQueueFrameRandomScrollFrameChildFrameItem" .. i .. "RoleIcon2"];
		local role3 = _G["LFDQueueFrameRandomScrollFrameChildFrameItem" .. i .. "RoleIcon3"];

		if(button and not button.reskinned) then
			button:StripTextures();
			button:CreateBackdrop();
			button.backdrop:SetOutside(icon);

			icon:SetTexCoord(unpack(E.TexCoords));
			icon:SetParent(button.backdrop);

			icon:SetDrawLayer("OVERLAY");
			count:SetDrawLayer("OVERLAY");

			if(count) then count:SetParent(button.backdrop); end
			if(role1) then role1:SetParent(button.backdrop); end
			if(role2) then role2:SetParent(button.backdrop); end
			if(role3) then role3:SetParent(button.backdrop); end

			button:HookScript("OnUpdate", function(self)
				button.backdrop:SetBackdropBorderColor(unpack(E["media"].bordercolor));
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
	S:HandleCheckBox(LFDRoleCheckPopupRoleButtonTank:GetChildren());
	S:HandleCheckBox(LFDRoleCheckPopupRoleButtonDPS:GetChildren());
	S:HandleCheckBox(LFDRoleCheckPopupRoleButtonHealer:GetChildren());

	LFDRoleCheckPopupRoleButtonTank:GetChildren():SetFrameLevel(LFDRoleCheckPopupRoleButtonTank:GetChildren():GetFrameLevel() + 1);
	LFDRoleCheckPopupRoleButtonDPS:GetChildren():SetFrameLevel(LFDRoleCheckPopupRoleButtonDPS:GetChildren():GetFrameLevel() + 1);
	LFDRoleCheckPopupRoleButtonHealer:GetChildren():SetFrameLevel(LFDRoleCheckPopupRoleButtonHealer:GetChildren():GetFrameLevel() + 1);

	LFDRoleCheckPopupRoleButtonTank:StripTextures();
	LFDRoleCheckPopupRoleButtonTank:CreateBackdrop();
	LFDRoleCheckPopupRoleButtonTank.backdrop:Point("TOPLEFT", 7, -7);
	LFDRoleCheckPopupRoleButtonTank.backdrop:Point("BOTTOMRIGHT", -7, 7);
	LFDRoleCheckPopupRoleButtonTank.icon = LFDRoleCheckPopupRoleButtonTank:CreateTexture(nil, "OVERLAY");
	LFDRoleCheckPopupRoleButtonTank.icon:SetTexCoord(unpack(E.TexCoords));
	LFDRoleCheckPopupRoleButtonTank.icon:SetTexture("Interface\\Icons\\Ability_Defend");
	LFDRoleCheckPopupRoleButtonTank.icon:SetInside(LFDRoleCheckPopupRoleButtonTank.backdrop);

	LFDRoleCheckPopupRoleButtonHealer:StripTextures();
	LFDRoleCheckPopupRoleButtonHealer:CreateBackdrop();
	LFDRoleCheckPopupRoleButtonHealer.backdrop:Point("TOPLEFT", 7, -7);
	LFDRoleCheckPopupRoleButtonHealer.backdrop:Point("BOTTOMRIGHT", -7, 7);
	LFDRoleCheckPopupRoleButtonHealer.icon = LFDRoleCheckPopupRoleButtonHealer:CreateTexture(nil, "OVERLAY");
	LFDRoleCheckPopupRoleButtonHealer.icon:SetTexCoord(unpack(E.TexCoords));
	LFDRoleCheckPopupRoleButtonHealer.icon:SetTexture("Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH");
	LFDRoleCheckPopupRoleButtonHealer.icon:SetInside(LFDRoleCheckPopupRoleButtonHealer.backdrop);

	LFDRoleCheckPopupRoleButtonDPS:StripTextures();
	LFDRoleCheckPopupRoleButtonDPS:CreateBackdrop();
	LFDRoleCheckPopupRoleButtonDPS.backdrop:Point("TOPLEFT", 7, -7);
	LFDRoleCheckPopupRoleButtonDPS.backdrop:Point("BOTTOMRIGHT", -7, 7);
	LFDRoleCheckPopupRoleButtonDPS.icon = LFDRoleCheckPopupRoleButtonDPS:CreateTexture(nil, "OVERLAY");
	LFDRoleCheckPopupRoleButtonDPS.icon:SetTexCoord(unpack(E.TexCoords));
	LFDRoleCheckPopupRoleButtonDPS.icon:SetTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01");
	LFDRoleCheckPopupRoleButtonDPS.icon:SetInside(LFDRoleCheckPopupRoleButtonDPS.backdrop);

	--LFG Search Status
	LFGSearchStatus:SetTemplate("Transparent");

	LFGSearchStatusIndividualRoleDisplayTank1:StripTextures();
	LFGSearchStatusIndividualRoleDisplayTank1:CreateBackdrop();
	LFGSearchStatusIndividualRoleDisplayTank1.backdrop:Point("TOPLEFT", 5, -5);
	LFGSearchStatusIndividualRoleDisplayTank1.backdrop:Point("BOTTOMRIGHT", -5, 5);
	LFGSearchStatusIndividualRoleDisplayTank1.icon = LFGSearchStatusIndividualRoleDisplayTank1:CreateTexture(nil, "OVERLAY");
	LFGSearchStatusIndividualRoleDisplayTank1.icon:SetTexCoord(unpack(E.TexCoords));
	LFGSearchStatusIndividualRoleDisplayTank1.icon:SetTexture("Interface\\Icons\\Ability_Defend");
	LFGSearchStatusIndividualRoleDisplayTank1.icon:SetInside(LFGSearchStatusIndividualRoleDisplayTank1.backdrop);

	LFGSearchStatusIndividualRoleDisplayHealer1:StripTextures();
	LFGSearchStatusIndividualRoleDisplayHealer1:CreateBackdrop();
	LFGSearchStatusIndividualRoleDisplayHealer1.backdrop:Point("TOPLEFT", 5, -5);
	LFGSearchStatusIndividualRoleDisplayHealer1.backdrop:Point("BOTTOMRIGHT", -5, 5);
	LFGSearchStatusIndividualRoleDisplayHealer1.icon = LFGSearchStatusIndividualRoleDisplayHealer1:CreateTexture(nil, "OVERLAY");
	LFGSearchStatusIndividualRoleDisplayHealer1.icon:SetTexCoord(unpack(E.TexCoords));
	LFGSearchStatusIndividualRoleDisplayHealer1.icon:SetTexture("Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH");
	LFGSearchStatusIndividualRoleDisplayHealer1.icon:SetInside(LFGSearchStatusIndividualRoleDisplayHealer1.backdrop);

	for i = 1, 3 do
		local LFGSearchDPS = _G["LFGSearchStatusIndividualRoleDisplayDamage"..i];
		LFGSearchDPS:StripTextures();
		LFGSearchDPS:CreateBackdrop();
		LFGSearchDPS.backdrop:Point("TOPLEFT", 5, -5);
		LFGSearchDPS.backdrop:Point("BOTTOMRIGHT", -5, 5);
		LFGSearchDPS.icon = LFGSearchDPS:CreateTexture(nil, "OVERLAY");
		LFGSearchDPS.icon:SetTexCoord(unpack(E.TexCoords));
		LFGSearchDPS.icon:SetTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01");
		LFGSearchDPS.icon:SetInside(LFGSearchDPS.backdrop);
	end

	hooksecurefunc("LFGSearchStatusPlayer_SetFound", function(button, isFound)
		if(button.icon) then
			if(isFound) then
				button.icon:SetDesaturated(false);
			else
				button.icon:SetDesaturated(true);
			end
		end
	end)

	--LFG Ready Dialog
	LFGDungeonReadyDialogBackground:Kill();
	--LFGDungeonReadyDialog:StripTextures();
	LFGDungeonReadyDialog:SetTemplate("Transparent");
	LFGDungeonReadyDialog.SetBackdrop = E.noop;
	LFGDungeonReadyDialog.filigree:SetAlpha(0);
	LFGDungeonReadyDialog.bottomArt:SetAlpha(0);

	S:HandleButton(LFGDungeonReadyDialogLeaveQueueButton);
	S:HandleButton(LFGDungeonReadyDialogEnterDungeonButton);

	S:HandleCloseButton(LFGDungeonReadyDialogCloseButton);
	LFGDungeonReadyDialogCloseButton.text:SetText("-");
	LFGDungeonReadyDialogCloseButton.text:FontTemplate(nil, 22);

	for i = 1, LFG_ROLE_NUM_SHORTAGE_TYPES do
		local reward = _G["LFGDungeonReadyDialogRewardsFrameReward" .. i];
		local texture = _G["LFGDungeonReadyDialogRewardsFrameReward" .. i .. "Texture"];
		local border = _G["LFGDungeonReadyDialogRewardsFrameReward" .. i .. "Border"];

		if(reward and not reward.IsDone) then
			border:Kill();

			reward:CreateBackdrop();
			reward.backdrop:Point("TOPLEFT", 7, -7);
			reward.backdrop:Point("BOTTOMRIGHT", -7, 7);

			texture:SetTexCoord(unpack(E.TexCoords));
			texture:SetInside(reward.backdrop);

			reward.IsDone = true;
		end
	end

	hooksecurefunc("LFGDungeonReadyPopup_Update", function()
		local _, _, _, _, _, _, role = GetLFGProposal();
		if(LFGDungeonReadyDialogRoleIcon:IsShown()) then
			LFGDungeonReadyDialogRoleIcon:StripTextures();
			LFGDungeonReadyDialogRoleIcon:CreateBackdrop();
			LFGDungeonReadyDialogRoleIcon.backdrop:Point("TOPLEFT", 7, -7);
			LFGDungeonReadyDialogRoleIcon.backdrop:Point("BOTTOMRIGHT", -7, 7);

			LFGDungeonReadyDialogRoleIcon.icon = LFGDungeonReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY");
			LFGDungeonReadyDialogRoleIcon.icon:SetTexCoord(unpack(E.TexCoords));

			if(role == "DAMAGER") then
				LFGDungeonReadyDialogRoleIcon.icon:SetTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01");
			elseif(role == "TANK") then
				LFGDungeonReadyDialogRoleIcon.icon:SetTexture("Interface\\Icons\\Ability_Defend");
			elseif(role == "HEALER") then
				LFGDungeonReadyDialogRoleIcon.icon:SetTexture("Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH");
			end

			LFGDungeonReadyDialogRoleIcon.icon:SetInside(LFGDungeonReadyDialogRoleIcon.backdrop);
		end
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

	-- LFR Frames
	S:HandleButton(LFRQueueFrameFindGroupButton);
	S:HandleButton(LFRQueueFrameAcceptCommentButton);
	S:HandleButton(LFRBrowseFrameSendMessageButton);
	S:HandleButton(LFRBrowseFrameInviteButton);
	S:HandleButton(LFRBrowseFrameRefreshButton);

	S:HandleDropDownBox(LFRBrowseFrameRaidDropDown);

	for i = 1, 7 do
		local button = "LFRBrowseFrameColumnHeader"..i;
		_G[button.."Left"]:Kill();
		_G[button.."Middle"]:Kill();
		_G[button.."Right"]:Kill();
		_G[button]:StyleButton();
	end

	LFRQueueFrameSpecificListScrollFrame:StripTextures();

	for i = 1, 2 do
		local tab = _G["LFRParentFrameSideTab"..i];
		tab:GetRegions():Hide();
		tab:SetTemplate("Default");
		tab:StyleButton(nil, true);
		tab:GetNormalTexture():SetInside();
		tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords));
	end

	LFRParentFrameSideTab1:Point("TOPLEFT", LFRParentFrame, "TOPRIGHT", -1, -35);

	RaidParentFrame:StripTextures();
	RaidParentFrame:SetTemplate("Transparent");

	for i = 1, 3 do 
		S:HandleTab(_G['RaidParentFrameTab'..i]);
	end

	S:HandleButton(RaidFinderFrameFindRaidButton, true);
	S:HandleButton(RaidFinderFrameCancelButton, true);
	S:HandleDropDownBox(RaidFinderQueueFrameSelectionDropDown);

	RaidFinderQueueFrame:StripTextures();
	RaidParentFrameInset:StripTextures();
	RaidFinderQueueFrame:StripTextures(true);
	RaidFinderFrameRoleInset:StripTextures();

	RaidFinderFrame:StripTextures();
	LFRParentFrame:StripTextures();
	LFRQueueFrame:StripTextures();
	LFRQueueFrameListInset:StripTextures();
	LFRQueueFrameRoleInset:StripTextures();
	LFRQueueFrameCommentInset:StripTextures();
	LFRBrowseFrame:StripTextures();

	S:HandleScrollBar(LFRQueueFrameCommentScrollFrameScrollBar);

	RaidFinderQueueFrameSelectionDropDown:Width(225);
	RaidFinderQueueFrameSelectionDropDown.SetWidth = E.noop;

	LFRQueueFrameCommentTextButton:CreateBackdrop("Default");
	LFRQueueFrameCommentTextButton:Height(35);

	LFRBrowseFrame:HookScript("OnShow", function()
		if(not LFRBrowseFrameListScrollFrameScrollBar.skinned) then
			S:HandleScrollBar(LFRBrowseFrameListScrollFrameScrollBar);
			LFRBrowseFrameListScrollFrameScrollBar.skinned = true;
		end
	end)

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

	S:HandleButton(RaidFinderQueueFrameIneligibleFrameLeaveQueueButton);
	S:HandleButton(LFRQueueFrameNoLFRWhileLFDLeaveQueueButton);
	S:HandleCloseButton(RaidParentFrameCloseButton);

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

	-- Raid Finder Roles
	RaidFinderQueueFrameRoleButtonTank:Point("BOTTOMLEFT", RaidFinderQueueFrame, "BOTTOMLEFT", 25, 334);
	RaidFinderQueueFrameRoleButtonHealer:Point("LEFT", RaidFinderQueueFrameRoleButtonTank, "RIGHT", 23, 0);
	RaidFinderQueueFrameRoleButtonLeader:Point("LEFT", RaidFinderQueueFrameRoleButtonDPS, "RIGHT", 50, 0);

	local checkButtons = {
		"RaidFinderQueueFrameRoleButtonTank",
		"RaidFinderQueueFrameRoleButtonHealer",
		"RaidFinderQueueFrameRoleButtonDPS",
		"RaidFinderQueueFrameRoleButtonLeader"
	};

	for _, object in pairs(checkButtons) do
		_G[object].checkButton:SetFrameLevel(_G[object].checkButton:GetFrameLevel() + 2);
		S:HandleCheckBox(_G[object].checkButton);
	end

	RaidFinderQueueFrameRoleButtonTank:StripTextures();
	RaidFinderQueueFrameRoleButtonTank:CreateBackdrop();
	RaidFinderQueueFrameRoleButtonTank.backdrop:Point("TOPLEFT", 3, -3);
	RaidFinderQueueFrameRoleButtonTank.backdrop:Point("BOTTOMRIGHT", -3, 3);
	RaidFinderQueueFrameRoleButtonTank.icon = RaidFinderQueueFrameRoleButtonTank:CreateTexture(nil, "OVERLAY");
	RaidFinderQueueFrameRoleButtonTank.icon:SetTexCoord(unpack(E.TexCoords));
	RaidFinderQueueFrameRoleButtonTank.icon:SetTexture("Interface\\Icons\\Ability_Defend");
	RaidFinderQueueFrameRoleButtonTank.icon:SetInside(RaidFinderQueueFrameRoleButtonTank.backdrop);

	RaidFinderQueueFrameRoleButtonHealer:StripTextures();
	RaidFinderQueueFrameRoleButtonHealer:CreateBackdrop();
	RaidFinderQueueFrameRoleButtonHealer.backdrop:Point("TOPLEFT", 3, -3);
	RaidFinderQueueFrameRoleButtonHealer.backdrop:Point("BOTTOMRIGHT", -3, 3);
	RaidFinderQueueFrameRoleButtonHealer.icon = RaidFinderQueueFrameRoleButtonHealer:CreateTexture(nil, "OVERLAY");
	RaidFinderQueueFrameRoleButtonHealer.icon:SetTexCoord(unpack(E.TexCoords));
	RaidFinderQueueFrameRoleButtonHealer.icon:SetTexture('Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH');
	RaidFinderQueueFrameRoleButtonHealer.icon:SetInside(RaidFinderQueueFrameRoleButtonHealer.backdrop);

	RaidFinderQueueFrameRoleButtonDPS:StripTextures();
	RaidFinderQueueFrameRoleButtonDPS:CreateBackdrop();
	RaidFinderQueueFrameRoleButtonDPS.backdrop:Point("TOPLEFT", 3, -3);
	RaidFinderQueueFrameRoleButtonDPS.backdrop:Point("BOTTOMRIGHT", -3, 3);
	RaidFinderQueueFrameRoleButtonDPS.icon = RaidFinderQueueFrameRoleButtonDPS:CreateTexture(nil, "OVERLAY");
	RaidFinderQueueFrameRoleButtonDPS.icon:SetTexCoord(unpack(E.TexCoords));
	RaidFinderQueueFrameRoleButtonDPS.icon:SetTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01");
	RaidFinderQueueFrameRoleButtonDPS.icon:SetInside(RaidFinderQueueFrameRoleButtonDPS.backdrop);

	RaidFinderQueueFrameRoleButtonLeader:StripTextures();
	RaidFinderQueueFrameRoleButtonLeader:CreateBackdrop("Default");
	RaidFinderQueueFrameRoleButtonLeader.backdrop:Point("TOPLEFT", 3, -3);
	RaidFinderQueueFrameRoleButtonLeader.backdrop:Point("BOTTOMRIGHT", -3, 3);
	RaidFinderQueueFrameRoleButtonLeader.icon = RaidFinderQueueFrameRoleButtonLeader:CreateTexture(nil, "OVERLAY");
	RaidFinderQueueFrameRoleButtonLeader.icon:SetTexCoord(unpack(E.TexCoords));
	RaidFinderQueueFrameRoleButtonLeader.icon:SetTexture("Interface\\Icons\\Ability_Vehicle_LaunchPlayer");
	RaidFinderQueueFrameRoleButtonLeader.icon:SetInside(RaidFinderQueueFrameRoleButtonLeader.backdrop);

	-- Raid Finder Other Raids Roles
	LFRQueueFrameRoleButtonTank:Point("TOPLEFT", LFRQueueFrame, "TOPLEFT", 50, -45);
	LFRQueueFrameRoleButtonHealer:Point("LEFT", LFRQueueFrameRoleButtonTank, "RIGHT", 43, 0);

	S:HandleCheckBox(LFRQueueFrameRoleButtonTank:GetChildren())
	LFRQueueFrameRoleButtonTank:GetChildren():SetFrameLevel(LFRQueueFrameRoleButtonTank:GetChildren():GetFrameLevel() + 2)

	S:HandleCheckBox(LFRQueueFrameRoleButtonHealer:GetChildren())
	LFRQueueFrameRoleButtonHealer:GetChildren():SetFrameLevel(LFRQueueFrameRoleButtonHealer:GetChildren():GetFrameLevel() + 2)

	S:HandleCheckBox(LFRQueueFrameRoleButtonDPS:GetChildren())
	LFRQueueFrameRoleButtonDPS:GetChildren():SetFrameLevel(LFRQueueFrameRoleButtonDPS:GetChildren():GetFrameLevel() + 2)

	LFRQueueFrameRoleButtonTank:StripTextures();
	LFRQueueFrameRoleButtonTank:CreateBackdrop();
	LFRQueueFrameRoleButtonTank.backdrop:Point("TOPLEFT", 3, -3);
	LFRQueueFrameRoleButtonTank.backdrop:Point("BOTTOMRIGHT", -3, 3);
	LFRQueueFrameRoleButtonTank.icon = LFRQueueFrameRoleButtonTank:CreateTexture(nil, "OVERLAY");
	LFRQueueFrameRoleButtonTank.icon:SetTexCoord(unpack(E.TexCoords));
	LFRQueueFrameRoleButtonTank.icon:SetTexture("Interface\\Icons\\Ability_Defend");
	LFRQueueFrameRoleButtonTank.icon:SetInside(LFRQueueFrameRoleButtonTank.backdrop);

	LFRQueueFrameRoleButtonHealer:StripTextures();
	LFRQueueFrameRoleButtonHealer:CreateBackdrop();
	LFRQueueFrameRoleButtonHealer.backdrop:Point("TOPLEFT", 3, -3);
	LFRQueueFrameRoleButtonHealer.backdrop:Point("BOTTOMRIGHT", -3, 3);
	LFRQueueFrameRoleButtonHealer.icon = LFRQueueFrameRoleButtonHealer:CreateTexture(nil, "OVERLAY");
	LFRQueueFrameRoleButtonHealer.icon:SetTexCoord(unpack(E.TexCoords));
	LFRQueueFrameRoleButtonHealer.icon:SetTexture("Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH");
	LFRQueueFrameRoleButtonHealer.icon:SetInside(LFRQueueFrameRoleButtonHealer.backdrop);

	LFRQueueFrameRoleButtonDPS:StripTextures();
	LFRQueueFrameRoleButtonDPS:CreateBackdrop();
	LFRQueueFrameRoleButtonDPS.backdrop:Point("TOPLEFT", 3, -3);
	LFRQueueFrameRoleButtonDPS.backdrop:Point("BOTTOMRIGHT", -3, 3);
	LFRQueueFrameRoleButtonDPS.icon = LFRQueueFrameRoleButtonDPS:CreateTexture(nil, "OVERLAY");
	LFRQueueFrameRoleButtonDPS.icon:SetTexCoord(unpack(E.TexCoords));
	LFRQueueFrameRoleButtonDPS.icon:SetTexture("Interface\\Icons\\INV_Knife_1H_Common_B_01");
	LFRQueueFrameRoleButtonDPS.icon:SetInside(LFRQueueFrameRoleButtonDPS.backdrop);

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