local E, L, V, P, G = unpack(select(2, ...)); 
local DT = E:GetModule("DataTexts")

local select, unpack = select, unpack
local sort, wipe = table.sort, wipe
local ceil = math.ceil
local format, find, join = string.format, string.find, string.join

local GetNumGuildMembers = GetNumGuildMembers
local GetGuildRosterInfo = GetGuildRosterInfo
local GetGuildRosterMOTD = GetGuildRosterMOTD
local IsInGuild = IsInGuild
local LoadAddOn = LoadAddOn
local GuildRoster = GuildRoster
local InviteUnit = InviteUnit
local GetQuestDifficultyColor = GetQuestDifficultyColor
local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid
local EasyMenu = EasyMenu
local IsShiftKeyDown = IsShiftKeyDown
local GetGuildInfo = GetGuildInfo
local ToggleGuildFrame = ToggleGuildFrame
local GetGuildFactionInfo = GetGuildFactionInfo
local CUSTOM_CLASS_COLORS = CUSTOM_CLASS_COLORS
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local GUILD_MOTD = GUILD_MOTD
local COMBAT_FACTION_CHANGE = COMBAT_FACTION_CHANGE
local GUILD = GUILD

local tthead, ttsubh, ttoff = {r=0.4, g=0.78, b=1}, {r=0.75, g=0.9, b=1}, {r=.3,g=1,b=.3}
local activezone, inactivezone = {r=0.3, g=1.0, b=0.3}, {r=0.65, g=0.65, b=0.65}
local displayString = ""
local noGuildString = ""
local guildInfoString = "%s [%d]"
local guildInfoString2 = join("", GUILD, ": %d/%d")
local guildMotDString = "%s |cffaaaaaa- |cffffffff%s"
local levelNameString = "|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r %s"
local levelNameStatusString = "|cff%02x%02x%02x%d|r %s %s"
local nameRankString = "%s |cff999999-|cffffffff %s"
local guildXpCurrentString = gsub(join("", E:RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b), GUILD_EXPERIENCE_CURRENT), ": ", ":|r |cffffffff", 1)
local guildXpDailyString = gsub(join("", E:RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b), GUILD_EXPERIENCE_DAILY), ": ", ":|r |cffffffff", 1)
local standingString = join("", E:RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b), "%s:|r |cFFFFFFFF%s/%s (%s%%)")
local moreMembersOnlineString = join("", "+ %d ", FRIENDS_LIST_ONLINE, "...")
local noteString = join("", "|cff999999   ", LABEL_NOTE, ":|r %s")
local officerNoteString = join("", "|cff999999   ", GUILD_RANK1_DESC, ":|r %s")
local friendOnline, friendOffline = gsub(ERR_FRIEND_ONLINE_SS,"\124Hplayer:%%s\124h%[%%s%]\124h",""), gsub(ERR_FRIEND_OFFLINE_S,"%%s","")
local guildTable, guildXP, guildMotD = {}, {}, ""
local lastPanel

local function SortGuildTable(shift)
	sort(guildTable, function(a, b)
		if a and b then
			if shift then
				return a[10] < b[10]
			else
				return a[1] < b[1]
			end
		end
	end)
end

local function BuildGuildTable()
	wipe(guildTable)
	local name, rank, level, zone, note, officernote, connected, status, class
	local count = 0
	for i = 1, GetNumGuildMembers() do
		name, rank, rankIndex, level, _, zone, note, officernote, connected, status, class = GetGuildRosterInfo(i)
		if status == 1 then
			status = "|cffFFFFFF[|r|cffFF0000"..L["AFK"].."|r|cffFFFFFF]|r"
		elseif status == 2 then
			status = "|cffFFFFFF[|r|cffFF0000"..L["DND"].."|r|cffFFFFFF]|r"
		else 
			status = "";
		end

		if connected then
			count = count + 1
			guildTable[count] = { name, rank, level, zone, note, officernote, connected, status, class, rankIndex }
		end
	end
	SortGuildTable(IsShiftKeyDown())
end

local function UpdateGuildXP()
	local currentXP, remainingXP, dailyXP, maxDailyXP = UnitGetGuildXP("player")
	local nextLevelXP = currentXP + remainingXP
	local percentTotal
	if currentXP > 0 then
		percentTotal = ceil((currentXP / nextLevelXP) * 100)
	else
		percentTotal = 0
	end

	local percentDaily = 0
	if maxDailyXP > 0 then
		percentDaily = ceil((dailyXP / maxDailyXP) * 100)
	end

	guildXP[0] = { currentXP, nextLevelXP, percentTotal }
	guildXP[1] = { dailyXP, maxDailyXP, percentDaily }
end

local function UpdateGuildMessage()
	guildMotD = GetGuildRosterMOTD()
end

local function OnEvent(self, event, ...)
	lastPanel = self

	if IsInGuild() then
		if event == "CHAT_MSG_SYSTEM" then
			local message = select(1, ...)
			if find(message, friendOnline) or find(message, friendOffline) then GuildRoster() end
		end

		if event == "GUILD_XP_UPDATE" then UpdateGuildXP() return end
		if event == "GUILD_MOTD" then UpdateGuildMessage() return end

		if event == "PLAYER_ENTERING_WORLD" then
			if not GuildFrame and IsInGuild() then LoadAddOn("Blizzard_GuildUI") UpdateGuildMessage() UpdateGuildXP() end
		end

		if (event ~= "GUILD_ROSTER_UPDATE" and event~="PLAYER_GUILD_UPDATE") or event == "ELVUI_FORCE_RUN" then GuildRoster()  if event ~= "ELVUI_FORCE_RUN" then return end end

		local _, online = GetNumGuildMembers()
		self.text:SetFormattedText(displayString, online)
	else
		self.text:SetText(noGuildString)
	end
end

local menuFrame = CreateFrame("Frame", "GuildDatatTextRightClickMenu", E.UIParent, "UIDropDownMenuTemplate")
local menuList = {
	{ text = OPTIONS_MENU, isTitle = true, notCheckable=true},
	{ text = INVITE, hasArrow = true, notCheckable=true,},
	{ text = CHAT_MSG_WHISPER_INFORM, hasArrow = true, notCheckable=true,}
}

local function inviteClick(_, arg1, arg2, checked)
	menuFrame:Hide()
	InviteUnit(arg1)
end

local function whisperClick(_, arg1, arg2, checked)
	menuFrame:Hide()
	SetItemRef( "player:"..arg1, ("|Hplayer:%1$s|h[%1$s]|h"):format(arg1), "LeftButton" )
end

local function ToggleGuildFrame()
	if IsInGuild() then
		if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end
		GuildFrame_Toggle()
		GuildFrame_TabClicked(GuildFrameTab2)
	else
		if not LookingForGuildFrame then LoadAddOn("Blizzard_LookingForGuildUI") end
		if LookingForGuildFrame then LookingForGuildFrame_Toggle() end
	end
end

local function OnClick(_, btn)
	if btn == "RightButton" and IsInGuild() then
		DT.tooltip:Hide()

		local classc, levelc, grouped, info
		local menuCountWhispers = 0
		local menuCountInvites = 0

		menuList[2].menuList = {}
		menuList[3].menuList = {}

		for i = 1, #guildTable do
			info = guildTable[i]
			if info[7] and info[1] ~= E.myname then
				classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[9]], GetQuestDifficultyColor(info[3])
				if UnitInParty(info[1]) or UnitInRaid(info[1]) then
					grouped = "|cffaaaaaa*|r"
				elseif not info[11] then
					menuCountInvites = menuCountInvites + 1
					grouped = ""
					menuList[2].menuList[menuCountInvites] = {text = format(levelNameString, levelc.r*255,levelc.g*255,levelc.b*255, info[3], classc.r*255,classc.g*255,classc.b*255, info[1], ""), arg1 = info[1],notCheckable=true, func = inviteClick}
				end
				menuCountWhispers = menuCountWhispers + 1
				if not grouped then grouped = "" end
				menuList[3].menuList[menuCountWhispers] = {text = format(levelNameString, levelc.r*255,levelc.g*255,levelc.b*255, info[3], classc.r*255,classc.g*255,classc.b*255, info[1], grouped), arg1 = info[1],notCheckable=true, func = whisperClick}
			end
		end

		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	else
		ToggleGuildFrame()
	end
end

local function OnEnter(self)
	if not IsInGuild() then return end

	DT:SetupTooltip(self)

	local total, online = GetNumGuildMembers()
	GuildRoster()
	BuildGuildTable()

	local guildName, guildRank = GetGuildInfo("player")
	local guildLevel = GetGuildLevel()

	if guildName and guildRank and guildLevel then
		DT.tooltip:AddDoubleLine(format(guildInfoString, guildName, guildLevel), format(guildInfoString2, online, total),tthead.r,tthead.g,tthead.b,tthead.r,tthead.g,tthead.b)
		DT.tooltip:AddLine(guildRank, unpack(tthead))
	end

	if guildMotD ~= "" then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(format(guildMotDString, GUILD_MOTD, guildMotD), ttsubh.r, ttsubh.g, ttsubh.b, 1)
	end

	local col = E:RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b)
	if GetGuildLevel() ~= 25 then
		if guildXP[0] and guildXP[1] then
			local currentXP, nextLevelXP, percentTotal = unpack(guildXP[0])
			local dailyXP, maxDailyXP, percentDaily = unpack(guildXP[1])

			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(format(guildXpCurrentString, E:ShortValue(currentXP), E:ShortValue(nextLevelXP), percentTotal))
			DT.tooltip:AddLine(format(guildXpDailyString, E:ShortValue(dailyXP), E:ShortValue(maxDailyXP), percentDaily))
		end
	end

	local _, _, standingID, barMin, barMax, barValue = GetGuildFactionInfo()
	if standingID ~= 8 then
		barMax = barMax - barMin
		barValue = barValue - barMin
		barMin = 0
		DT.tooltip:AddLine(format(standingString, COMBAT_FACTION_CHANGE, E:ShortValue(barValue), E:ShortValue(barMax), ceil((barValue / barMax) * 100)))
	end

	local zonec, classc, levelc, info
	local shown = 0

	DT.tooltip:AddLine(" ")
	for i = 1, #guildTable do
		if 30 - shown <= 1 then
			if online - 30 > 1 then DT.tooltip:AddLine(format(moreMembersOnlineString, online - 30), ttsubh.r, ttsubh.g, ttsubh.b) end
			break
		end

		info = guildTable[i]
		if GetRealZoneText() == info[4] then zonec = activezone else zonec = inactivezone end
		classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[9]], GetQuestDifficultyColor(info[3])

		if IsShiftKeyDown() then
			DT.tooltip:AddDoubleLine(format(nameRankString, info[1], info[2]), info[4], classc.r, classc.g, classc.b, zonec.r, zonec.g, zonec.b)
			if info[5] ~= "" then DT.tooltip:AddLine(format(noteString, info[5]), ttsubh.r, ttsubh.g, ttsubh.b, 1) end
			if info[6] ~= "" then DT.tooltip:AddLine(format(officerNoteString, info[6]), ttoff.r, ttoff.g, ttoff.b, 1) end
		else
			DT.tooltip:AddDoubleLine(format(levelNameStatusString, levelc.r*255, levelc.g*255, levelc.b*255, info[3], info[1], info[8]), info[4], classc.r,classc.g,classc.b, zonec.r,zonec.g,zonec.b)
		end
		shown = shown + 1
	end	

	DT.tooltip:Show()
end

local function ValueColorUpdate(hex)
	displayString = join("", GUILD, ": ", hex, "%d|r")
	noGuildString = join("", hex, NO.." "..GUILD)

	if lastPanel ~= nil then
		OnEvent(lastPanel, "ELVUI_COLOR_UPDATE")
	end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true

DT:RegisterDatatext("Guild", {"PLAYER_ENTERING_WORLD", "GUILD_ROSTER_SHOW", "GUILD_ROSTER_UPDATE", "GUILD_XP_UPDATE", "PLAYER_GUILD_UPDATE", "GUILD_MOTD", "CHAT_MSG_SYSTEM"}, OnEvent, nil, OnClick, OnEnter)