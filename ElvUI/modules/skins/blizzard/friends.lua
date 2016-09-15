local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins')

local _G = _G;
local unpack = unpack;

local MAX_DISPLAY_CHANNEL_BUTTONS = MAX_DISPLAY_CHANNEL_BUTTONS

--Tab Regions
local tabs = {
	"LeftDisabled",
	"MiddleDisabled",
	"RightDisabled",
	"Left",
	"Middle",
	"Right",
}

--Social Frame
local function SkinSocialHeaderTab(tab)
	if not tab then return end
	for _, object in pairs(tabs) do
		local tex = _G[tab:GetName()..object]
		tex:SetTexture(nil)
	end
	tab:GetHighlightTexture():SetTexture(nil)
	tab.backdrop = CreateFrame("Frame", nil, tab)
	tab.backdrop:SetTemplate("Default", true)
	tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
	tab.backdrop:Point("TOPLEFT", 3, -7)
	tab.backdrop:Point("BOTTOMRIGHT", -2, -1)
end

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.friends ~= true then return end

	S:HandleScrollBar(FriendsFrameFriendsScrollFrameScrollBar, 5)
	S:HandleScrollBar(WhoListScrollFrameScrollBar, 5)
	S:HandleScrollBar(ChannelRosterScrollFrameScrollBar, 5)
	S:HandleScrollBar(FriendsFriendsScrollFrameScrollBar)

	local StripAllTextures = {
		"ScrollOfResurrectionSelectionFrame",
		"ScrollOfResurrectionSelectionFrameList",
		"FriendsListFrame",
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
	}

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

	FriendsFrameInset:StripTextures()
	WhoFrameListInset:StripTextures()
	WhoFrameEditBoxInset:StripTextures()
	ChannelFrameRightInset:StripTextures()
	ChannelFrameLeftInset:StripTextures()
	LFRQueueFrameListInset:StripTextures()
	LFRQueueFrameRoleInset:StripTextures()
	LFRQueueFrameCommentInset:StripTextures()

	local buttons = {
		"FriendsFrameAddFriendButton",
		"FriendsFrameSendMessageButton",
		"WhoFrameWhoButton",
		"WhoFrameAddFriendButton",
		"WhoFrameGroupInviteButton",
		"ChannelFrameNewButton",
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

	for _, texture in pairs(KillTextures) do
		_G[texture]:Kill()
	end

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end

	ChannelFrameNewButton:Point("BOTTOMRIGHT", ChannelFrame, "BOTTOMRIGHT", -255, 30)

	for i=1, FriendsFrame:GetNumRegions() do
		local region = select(i, FriendsFrame:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
			region:SetAlpha(0)
		end
	end

	S:HandleEditBox(AddFriendNameEditBox)
	AddFriendFrame:SetTemplate("Transparent")
	ScrollOfResurrectionSelectionFrame:SetTemplate('Transparent')
	ScrollOfResurrectionSelectionFrameList:SetTemplate('Default')
	S:HandleScrollBar(ScrollOfResurrectionSelectionFrameListScrollFrameScrollBar, 4)
	S:HandleEditBox(ScrollOfResurrectionSelectionFrameTargetEditBox)

	for i=1, 11 do
		_G["FriendsFrameFriendsScrollFrameButton"..i.."SummonButtonIcon"]:SetTexCoord(unpack(E.TexCoords))
		_G["FriendsFrameFriendsScrollFrameButton"..i.."SummonButtonNormalTexture"]:SetAlpha(0)
		_G["FriendsFrameFriendsScrollFrameButton"..i.."SummonButton"]:StyleButton()
		_G["FriendsFrameFriendsScrollFrameButton"..i]:StyleButton()
	end

	--Who Frame
	local function UpdateWhoSkins()
		WhoListScrollFrame:StripTextures()
	end

	for i=1, 17 do
		_G["WhoFrameButton"..i]:StyleButton()
	end

	for i=1, 4 do
		_G["WhoFrameColumnHeader"..i]:StyleButton()
	end

	--Channel Frame
	local function UpdateChannel()
		ChannelRosterScrollFrame:StripTextures()
	end

	for i=1, 22 do
		_G["ChannelMemberButton"..i]:StyleButton()
	end

	local function Channel()
		for i=1, MAX_DISPLAY_CHANNEL_BUTTONS do
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

	--BNet Frame
	FriendsFrameBroadcastInput:CreateBackdrop("Default")
	ChannelFrameDaughterFrameChannelName:CreateBackdrop("Default")
	ChannelFrameDaughterFrameChannelPassword:CreateBackdrop("Default")

	ChannelFrame:HookScript("OnShow", UpdateChannel)
	hooksecurefunc("FriendsFrame_OnEvent", UpdateChannel)

	WhoFrame:HookScript("OnShow", UpdateWhoSkins)
	hooksecurefunc("FriendsFrame_OnEvent", UpdateWhoSkins)

	ChannelFrameDaughterFrame:CreateBackdrop("Transparent")

	FriendsFrame:SetTemplate('Transparent')

	S:HandleCloseButton(ChannelFrameDaughterFrameDetailCloseButton,ChannelFrameDaughterFrame)
	S:HandleCloseButton(FriendsFrameCloseButton,FriendsFrame.backdrop)

	S:HandleDropDownBox(WhoFrameDropDown, 150)
	S:HandleDropDownBox(FriendsFrameStatusDropDown, 70)
	FriendsFrameStatusDropDown:Point("TOPLEFT", FreindsListFrame, "TOPLEFT", 5, -25);

	--Bottom Tabs
	for i=1, 4 do
		S:HandleTab(_G["FriendsFrameTab"..i])
	end

	for i=1, 3 do
		SkinSocialHeaderTab(_G["FriendsTabHeaderTab"..i])
	end

	--View Friends BN Frame
	FriendsFriendsFrame:CreateBackdrop("Transparent")

	local StripAllTextures = {
		"FriendsFriendsFrame",
		"FriendsFriendsList",
		"FriendsFriendsNoteFrame",
	}

	local buttons = {
		"FriendsFriendsSendRequestButton",
		"FriendsFriendsCloseButton",
	}

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end

	for _, button in pairs(buttons) do
		S:HandleButton(_G[button])
	end

	S:HandleEditBox(FriendsFriendsList)
	S:HandleEditBox(FriendsFriendsNoteFrame)
	S:HandleDropDownBox(FriendsFriendsFrameDropDown, 150)

	BNConversationInviteDialog:StripTextures()
	BNConversationInviteDialog:CreateBackdrop('Transparent')
	BNConversationInviteDialogList:StripTextures()
	BNConversationInviteDialogList:SetTemplate('Default')
	S:HandleButton(BNConversationInviteDialogInviteButton)
	S:HandleButton(BNConversationInviteDialogCancelButton)

	for i=1, BN_CONVERSATION_INVITE_NUM_DISPLAYED do
		S:HandleCheckBox(_G["BNConversationInviteDialogListFriend"..i].checkButton)
	end

	FriendsTabHeaderSoRButton:SetTemplate('Default')
	FriendsTabHeaderSoRButton:StyleButton()
	FriendsTabHeaderSoRButtonIcon:SetDrawLayer('OVERLAY')
	FriendsTabHeaderSoRButtonIcon:SetTexCoord(unpack(E.TexCoords))
	FriendsTabHeaderSoRButtonIcon:ClearAllPoints()
	FriendsTabHeaderSoRButtonIcon:Point('TOPLEFT', 2, -2)
	FriendsTabHeaderSoRButtonIcon:Point('BOTTOMRIGHT', -2, 2)
	FriendsTabHeaderSoRButton:Point('TOPRIGHT', FriendsTabHeader, 'TOPRIGHT', -8, -56)

	S:HandleScrollBar(FriendsFrameIgnoreScrollFrameScrollBar)
	FriendsFrameIgnoreScrollFrameScrollBar:Point("RIGHT", 88, 0)
	S:HandleScrollBar(FriendsFramePendingScrollFrameScrollBar, 4)

	FriendsFrameUnsquelchButton:Point("RIGHT", -30, 0)

	IgnoreListFrame:StripTextures()
	PendingListFrame:StripTextures()

	for i=1, 19 do
		_G["FriendsFrameIgnoreButton"..i]:StyleButton()
	end

	ScrollOfResurrectionFrame:StripTextures()
	S:HandleButton(ScrollOfResurrectionFrameAcceptButton)
	S:HandleButton(ScrollOfResurrectionFrameCancelButton)

	ScrollOfResurrectionFrameTargetEditBoxLeft:SetTexture(nil)
	ScrollOfResurrectionFrameTargetEditBoxMiddle:SetTexture(nil)
	ScrollOfResurrectionFrameTargetEditBoxRight:SetTexture(nil)
	ScrollOfResurrectionFrameNoteFrame:StripTextures()
	ScrollOfResurrectionFrameNoteFrame:SetTemplate()
	ScrollOfResurrectionFrameTargetEditBox:SetTemplate()
	ScrollOfResurrectionFrame:SetTemplate('Transparent')

	S:HandleButton(RaidFrameConvertToRaidButton);
	S:HandleButton(RaidFrameRaidInfoButton);

	 -- Raid Info Frame
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

	for i=1, 7 do
		_G["RaidInfoScrollFrameButton"..i]:StyleButton()
	end

	S:HandleButton(RaidInfoExtendButton);
	S:HandleButton(RaidInfoCancelButton);

	--Friend List Class Colors
	local cfg = {
		USE_SHORT_LEVEL = 0, -- 1 = true, 0 = false
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
	for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE)do locclasses[v] = k end
	for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE)do locclasses[v] = k end

	cfg = type(cfg) ~= "table" and {} or cfg
	cfg.USE_SHORT_LEVEL = cfg.USE_SHORT_LEVEL and (cfg.USE_SHORT_LEVEL == 1 or cfg.USE_SHORT_LEVEL == "1" or cfg.USE_SHORT_LEVEL == true) and 1

	local updFunc = function()
	if GetNumFriends() < 1 then return end
		local off, name, level, class, zone, connected, status, note, tmp, tmpcol, tmpcol2 = FauxScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame)
		for i = 1, GetNumFriends() do
			name, level, class, zone, connected, status, note = GetFriendInfo(i)
			if connected then
				local friend = _G["FriendsFrameFriendsScrollFrameButton"..(i-off)]
				if friend and friend.buttonType == FRIENDS_BUTTON_TYPE_WOW then
					tmpcol = cc[(locclasses[class] or ""):gsub(" ",""):upper()]
					if (tmpcol or ""):len() > 0 then
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