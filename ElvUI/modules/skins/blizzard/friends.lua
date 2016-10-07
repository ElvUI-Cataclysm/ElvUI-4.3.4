local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins')

local _G = _G;
local pairs, unpack = pairs, unpack;
local format, len, upper, gsub = string.format, string.len, string.upper, string.gsub;

local hooksecurefunc = hooksecurefunc;
local GetWhoInfo = GetWhoInfo;
local MAX_DISPLAY_CHANNEL_BUTTONS = MAX_DISPLAY_CHANNEL_BUTTONS
local RAID_CLASS_COLORS = RAID_CLASS_COLORS;
local CUSTOM_CLASS_COLORS = CUSTOM_CLASS_COLORS;

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.friends ~= true then return end

	local StripAllTextures = {
		"ScrollOfResurrectionSelectionFrame",
		"ScrollOfResurrectionSelectionFrameList",
		"ScrollOfResurrectionFrame",
		"ScrollOfResurrectionFrameNoteFrame",
		"FriendsFriendsFrame",
		"FriendsFriendsList",
		"FriendsFriendsNoteFrame",
		"FriendsListFrame",
		"IgnoreListFrame",
		"PendingListFrame",
		"FriendsTabHeader",
		"FriendsFrameFriendsScrollFrame",
		"WhoFrameColumnHeader1",
		"WhoFrameColumnHeader2",
		"WhoFrameColumnHeader3",
		"WhoFrameColumnHeader4",
		"ChannelListScrollFrame",
		"ChannelRoster",
		"FriendsFramePendingButton1",
		"FriendsFramePendingButton2",
		"FriendsFramePendingButton3",
		"FriendsFramePendingButton4",
		"ChannelFrameDaughterFrame",
		"AddFriendFrame",
		"AddFriendNoteFrame",
		"FriendsFrameInset",
		"WhoFrameListInset",
		"WhoFrameEditBoxInset",
		"ChannelFrameRightInset",
		"ChannelFrameLeftInset",
		"LFRQueueFrameListInset",
		"LFRQueueFrameRoleInset",
		"LFRQueueFrameCommentInset",
		"BNConversationInviteDialog",
		"BNConversationInviteDialogList"
	}

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end

	local KillTextures = {
		"FriendsFrameBroadcastInputLeft",
		"FriendsFrameBroadcastInputRight",
		"FriendsFrameBroadcastInputMiddle",
		"ChannelFrameDaughterFrameChannelNameLeft",
		"ChannelFrameDaughterFrameChannelNameRight",
		"ChannelFrameDaughterFrameChannelNameMiddle",
		"ChannelFrameDaughterFrameChannelPasswordLeft",
		"ChannelFrameDaughterFrameChannelPasswordRight",
		"ChannelFrameDaughterFrameChannelPasswordMiddle",
	}

	for _, texture in pairs(KillTextures) do
		_G[texture]:Kill()
	end

	local buttons = {
		"FriendsFrameAddFriendButton",
		"FriendsFrameSendMessageButton",
		"WhoFrameWhoButton",
		"WhoFrameAddFriendButton",
		"WhoFrameGroupInviteButton",
		"ChannelFrameNewButton",
		"FriendsFriendsSendRequestButton",
		"FriendsFriendsCloseButton",
		"FriendsFrameIgnorePlayerButton",
		"FriendsFrameUnsquelchButton",
		"FriendsFramePendingButton1AcceptButton",
		"FriendsFramePendingButton1DeclineButton",
		"FriendsFramePendingButton2AcceptButton",
		"FriendsFramePendingButton2DeclineButton",
		"FriendsFramePendingButton3AcceptButton",
		"FriendsFramePendingButton3DeclineButton",
		"FriendsFramePendingButton4AcceptButton",
		"FriendsFramePendingButton4DeclineButton",
		"ChannelFrameDaughterFrameOkayButton",
		"ChannelFrameDaughterFrameCancelButton",
		"AddFriendEntryFrameAcceptButton",
		"AddFriendEntryFrameCancelButton",
		"AddFriendInfoFrameContinueButton",
		"ScrollOfResurrectionSelectionFrameAcceptButton",
		"ScrollOfResurrectionSelectionFrameCancelButton",
	}

	for _, button in pairs(buttons) do
		S:HandleButton(_G[button])
	end

	for i = 1, FriendsFrame:GetNumRegions() do
		local region = select(i, FriendsFrame:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
			region:SetAlpha(0)
		end
	end

	for i = 1, 3 do
		local headerTab = _G["FriendsTabHeaderTab"..i]
		headerTab:StripTextures()
		headerTab.backdrop = CreateFrame("Frame", nil, headerTab)
		headerTab.backdrop:SetTemplate("Default", true)
		headerTab.backdrop:SetFrameLevel(headerTab:GetFrameLevel() - 1)
		headerTab.backdrop:Point("TOPLEFT", 3, -7)
		headerTab.backdrop:Point("BOTTOMRIGHT", -2, -1)

		headerTab:HookScript("OnEnter", S.SetModifiedBackdrop);
		headerTab:HookScript("OnLeave", S.SetOriginalBackdrop);
	end

	for i = 1, 11 do
		_G["FriendsFrameFriendsScrollFrameButton"..i.."SummonButtonIcon"]:SetTexCoord(unpack(E.TexCoords))
		_G["FriendsFrameFriendsScrollFrameButton"..i.."SummonButtonNormalTexture"]:SetAlpha(0)
		_G["FriendsFrameFriendsScrollFrameButton"..i.."SummonButton"]:StyleButton()
		_G["FriendsFrameFriendsScrollFrameButton"..i]:StyleButton()
	end

	FriendsFrame:SetTemplate('Transparent')
	FriendsFrameBroadcastInput:CreateBackdrop("Default")

	S:HandleEditBox(AddFriendNameEditBox)
	AddFriendFrame:SetTemplate("Transparent")

	FriendsFriendsFrame:CreateBackdrop("Transparent")

	S:HandleEditBox(FriendsFriendsList)
	S:HandleEditBox(FriendsFriendsNoteFrame)
	S:HandleDropDownBox(FriendsFriendsFrameDropDown, 150)

	S:HandleDropDownBox(FriendsFrameStatusDropDown, 70)
	FriendsFrameStatusDropDown:Point("TOPLEFT", FreindsListFrame, "TOPLEFT", 5, -25);

	S:HandleScrollBar(FriendsFrameFriendsScrollFrameScrollBar, 5)
	S:HandleScrollBar(FriendsFriendsScrollFrameScrollBar)

	S:HandleCloseButton(FriendsFrameCloseButton,FriendsFrame.backdrop)

	--Who Frame
	local function UpdateWhoSkins()
		WhoListScrollFrame:StripTextures()
	end
	WhoFrame:HookScript("OnShow", UpdateWhoSkins)
	hooksecurefunc("FriendsFrame_OnEvent", UpdateWhoSkins)

	for i = 1, 4 do
		_G["WhoFrameColumnHeader"..i]:StyleButton()
	end

	WhoFrameColumnHeader3:ClearAllPoints();
	WhoFrameColumnHeader3:SetPoint("TOPLEFT", WhoFrame, "TOPLEFT", 15, -57);

	WhoFrameColumnHeader4:ClearAllPoints();
	WhoFrameColumnHeader4:SetPoint("LEFT", WhoFrameColumnHeader3, "RIGHT", -2, 0);
	WhoFrameColumn_SetWidth(WhoFrameColumnHeader4, 48);

	WhoFrameColumnHeader1:ClearAllPoints();
	WhoFrameColumnHeader1:SetPoint("LEFT", WhoFrameColumnHeader4, "RIGHT", -2, 0);
	WhoFrameColumn_SetWidth(WhoFrameColumnHeader1, 105);

	WhoFrameColumnHeader2:ClearAllPoints();
	WhoFrameColumnHeader2:SetPoint("LEFT", WhoFrameColumnHeader1, "RIGHT", -5, 0);

	WhoFrameButton1:Point("TOPLEFT", WhoFrame, "TOPLEFT", 10, -82)

	S:HandleDropDownBox(WhoFrameDropDown, 150)

	S:HandleScrollBar(WhoListScrollFrameScrollBar, 5)

	WhoFrameEditBox:Point("BOTTOM", WhoFrame, "BOTTOM", -3, 20)

	for i = 1, 17 do
		local button = _G["WhoFrameButton"..i];

		button.icon = button:CreateTexture("$parentIcon", "ARTWORK");
		button.icon:SetPoint("LEFT", 48, 0);
		button.icon:SetSize(18, 18);
		button.icon:SetTexture("Interface\\WorldStateFrame\\Icons-Classes");

		button.stripe = button:CreateTexture(nil, "BACKGROUND");
		button.stripe:SetTexture('Interface\\GuildFrame\\GuildFrame');
		button.stripe:SetTexCoord(0.362, 0.381, 0.958, 0.998);
		button.stripe:SetInside()

		button:StyleButton()

		_G["WhoFrameButton" .. i .. "Level"]:ClearAllPoints();
		_G["WhoFrameButton" .. i .. "Level"]:SetPoint("TOPLEFT", 10, -2);

		_G["WhoFrameButton" .. i .. "Name"]:SetSize(100, 14);
		_G["WhoFrameButton" .. i .. "Name"]:ClearAllPoints();
		_G["WhoFrameButton" .. i .. "Name"]:SetPoint("LEFT", 85, 0);

		_G["WhoFrameButton" .. i .. "Class"]:Hide();
	end

	hooksecurefunc("WhoList_Update", function()
		local _, level;
		local button, buttonText, classTextColor, classFileName, levelTextColor;

		for i = 1, WHOS_TO_DISPLAY, 1 do
			button = _G["WhoFrameButton"..i];
			_, _, level, _, _, _, classFileName = GetWhoInfo(button.whoIndex);

			if(classFileName) then
				classTextColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[classFileName] or RAID_CLASS_COLORS[classFileName];
				button.icon:Show();
				button.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFileName]));
			else
				classTextColor = HIGHLIGHT_FONT_COLOR;
				button.icon:Hide();
			end

			levelTextColor = GetQuestDifficultyColor(level);

			buttonText = _G["WhoFrameButton" .. i .. "Name"];
			buttonText:SetTextColor(classTextColor.r, classTextColor.g, classTextColor.b);
			buttonText = _G["WhoFrameButton" .. i .. "Level"];
			buttonText:SetTextColor(levelTextColor.r, levelTextColor.g, levelTextColor.b);
			buttonText = _G["WhoFrameButton" .. i .. "Class"];
			buttonText:SetTextColor(1.0, 1.0, 1.0);
		end
	end);

	--Channel Frame
	local function UpdateChannel()
		ChannelRosterScrollFrame:StripTextures()
	end
	ChannelFrame:HookScript("OnShow", UpdateChannel)
	hooksecurefunc("FriendsFrame_OnEvent", UpdateChannel)

	for i = 1, 22 do
		_G["ChannelMemberButton"..i]:StyleButton()
	end

	local function Channel()
		for i = 1, MAX_DISPLAY_CHANNEL_BUTTONS do
			local button = _G["ChannelButton"..i]
			if button then
				_G["ChannelButton"..i.."NormalTexture"]:SetAlpha(0)
				_G["ChannelButton"..i.."Text"]:FontTemplate(nil, 12)
				_G["ChannelButton"..i.."Collapsed"]:SetTextColor(1, 1, 1);
				_G["ChannelButton"..i]:StyleButton();
			end
		end
	end
	hooksecurefunc("ChannelList_Update", Channel)

	ChannelFrameDaughterFrame:CreateBackdrop("Transparent")
	ChannelFrameDaughterFrameChannelName:CreateBackdrop("Default")
	ChannelFrameDaughterFrameChannelPassword:CreateBackdrop("Default")
	ChannelFrameNewButton:Point("BOTTOMRIGHT", ChannelFrame, "BOTTOMRIGHT", -255, 30)

	S:HandleScrollBar(ChannelRosterScrollFrameScrollBar, 5)

	S:HandleCloseButton(ChannelFrameDaughterFrameDetailCloseButton,ChannelFrameDaughterFrame)

	--Bottom Tabs
	for i = 1, 4 do
		S:HandleTab(_G["FriendsFrameTab"..i])
	end

	--BN Frame
	BNConversationInviteDialog:CreateBackdrop('Transparent')
	BNConversationInviteDialogList:SetTemplate('Default')

	S:HandleButton(BNConversationInviteDialogInviteButton)
	S:HandleButton(BNConversationInviteDialogCancelButton)

	for i = 1, BN_CONVERSATION_INVITE_NUM_DISPLAYED do
		S:HandleCheckBox(_G["BNConversationInviteDialogListFriend"..i].checkButton)
	end

	--Ignore List
	FriendsFrameIgnoreButton1:Point("TOPLEFT", FriendsFrame, "TOPLEFT", 10, -89)

	FriendsFrameUnsquelchButton:Point("RIGHT", -23, 0)

	S:HandleScrollBar(FriendsFrameIgnoreScrollFrameScrollBar)
	FriendsFrameIgnoreScrollFrameScrollBar:SetPoint("TOPLEFT", FriendsFrameIgnoreScrollFrame, "TOPRIGHT", 45, 0)

	for i = 1, 19 do
		local button = _G["FriendsFrameIgnoreButton"..i]

		button.stripe = button:CreateTexture(nil, "OVERLAY");
		button.stripe:SetTexture('Interface\\GuildFrame\\GuildFrame');
		button.stripe:SetTexCoord(0.51660156, 0.53613281, 0.88281250, 0.92187500);
		button.stripe:SetAllPoints()

		button:StyleButton()
		button:SetWidth(310)
	end

	S:HandleScrollBar(FriendsFramePendingScrollFrameScrollBar, 4)

	--Scroll of Resurrection
	ScrollOfResurrectionFrame:SetTemplate('Transparent')
	ScrollOfResurrectionSelectionFrame:SetTemplate('Transparent')
	ScrollOfResurrectionFrameNoteFrame:SetTemplate('Default')
	ScrollOfResurrectionFrameTargetEditBox:SetTemplate('Default')
	ScrollOfResurrectionSelectionFrameList:SetTemplate('Default')

	ScrollOfResurrectionFrameTargetEditBoxLeft:SetTexture(nil)
	ScrollOfResurrectionFrameTargetEditBoxMiddle:SetTexture(nil)
	ScrollOfResurrectionFrameTargetEditBoxRight:SetTexture(nil)

	S:HandleEditBox(ScrollOfResurrectionSelectionFrameTargetEditBox)

	S:HandleButton(ScrollOfResurrectionFrameAcceptButton)
	S:HandleButton(ScrollOfResurrectionFrameCancelButton)

	S:HandleScrollBar(ScrollOfResurrectionSelectionFrameListScrollFrameScrollBar, 4)

	FriendsTabHeaderSoRButton:SetTemplate('Default')
	FriendsTabHeaderSoRButton:StyleButton()
	FriendsTabHeaderSoRButton:Point('TOPRIGHT', FriendsTabHeader, 'TOPRIGHT', -8, -56)

	FriendsTabHeaderSoRButtonIcon:ClearAllPoints()
	FriendsTabHeaderSoRButtonIcon:Point('TOPLEFT', 2, -2)
	FriendsTabHeaderSoRButtonIcon:Point('BOTTOMRIGHT', -2, 2)
	FriendsTabHeaderSoRButtonIcon:SetTexCoord(unpack(E.TexCoords))
	FriendsTabHeaderSoRButtonIcon:SetDrawLayer('OVERLAY')

	-- Raid Info Frame
	for i = 1, 7 do
		_G["RaidInfoScrollFrameButton"..i]:StyleButton()
	end

	RaidInfoFrame:StripTextures(true);
	RaidInfoFrame:SetTemplate("Transparent");

	RaidInfoFrame:ClearAllPoints()
	RaidInfoFrame:SetPoint("TOPLEFT", RaidFrame, "TOPRIGHT", 1, 0)

	RaidInfoInstanceLabel:StripTextures();
	RaidInfoIDLabel:StripTextures();

	S:HandleCloseButton(RaidInfoCloseButton);
	RaidInfoCloseButton:ClearAllPoints()
	RaidInfoCloseButton:SetPoint("TOPRIGHT", RaidInfoFrame, "TOPRIGHT", 2, 0)

	S:HandleScrollBar(RaidInfoScrollFrameScrollBar);

	S:HandleButton(RaidInfoExtendButton);
	S:HandleButton(RaidInfoCancelButton);
	S:HandleButton(RaidFrameConvertToRaidButton);
	S:HandleButton(RaidFrameRaidInfoButton);

	--Friend List Class Colors
	local cfg = {
		USE_SHORT_LEVEL = false
	}

	local cc = {
		["HUNTER"]="ABD473",
		["WARLOCK"]="9482C9",
		["PRIEST"]="FFFFFF",
		["PALADIN"]="F58CBA",
		["MAGE"]="69CCF0",
		["ROGUE"]="FFF569",
		["DRUID"]="FF7D0A",
		["SHAMAN"]="1783D1",
		["WARRIOR"]="C79C6E",
		["DEATHKNIGHT"]="C41F3B",
	}

	local locclasses = {}
	for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do locclasses[v] = k end
	for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do locclasses[v] = k end

	cfg = type(cfg) ~= "table" and {} or cfg
	cfg.USE_SHORT_LEVEL = cfg.USE_SHORT_LEVEL and cfg.USE_SHORT_LEVEL == true

	local updFunc = function()
	if(GetNumFriends() < 1) then return end
		local off, name, level, class, zone, connected, status, note, tmp, tmpcol, tmpcol2 = FauxScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame)
		for i = 1, GetNumFriends() do
			name, level, class, zone, connected, status, note = GetFriendInfo(i)
			if(connected) then
				local friend = _G["FriendsFrameFriendsScrollFrameButton"..(i-off)]
				if(friend and friend.buttonType == FRIENDS_BUTTON_TYPE_WOW) then
					tmpcol = cc[(locclasses[class] or ""):gsub(" ",""):upper()]
					if((tmpcol or ""):len() > 0) then
						tmp = format("|cff%s%s%s, ", tmpcol, name, FONT_COLOR_CODE_CLOSE) -- Name
						tmp = tmp..format("|cff%s%s%d%s ", tmpcol, cfg.USE_SHORT_LEVEL and "L" or LEVEL.." ", level, FONT_COLOR_CODE_CLOSE) --Level
						tmp = tmp..format("|cff%s%s%s ", tmpcol, class, FONT_COLOR_CODE_CLOSE) --Class
						friend.name:SetText(tmp)
					end
				end
			end
		end
	end

	FriendsFrameFriendsScrollFrameScrollBar:HookScript("OnValueChanged", updFunc)

	for k,v in pairs({"FriendsList_Update", "FriendsFrame_UpdateFriends", "FriendsFramePendingScrollFrame_AdjustScroll"}) do
		hooksecurefunc(v, updFunc)
	end
end

S:AddCallback("Friends", LoadSkin);