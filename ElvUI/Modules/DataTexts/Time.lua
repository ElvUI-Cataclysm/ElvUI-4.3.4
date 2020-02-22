local E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule("DataTexts")

local date, time = date, time
local next, unpack, select, tonumber = next, unpack, select, tonumber
local find, format, gsub, join, utf8sub = string.find, string.format, string.gsub, string.join, string.utf8sub
local tsort, tinsert = table.sort, table.insert

local GetGameTime = GetGameTime
local RequestRaidInfo = RequestRaidInfo
local GetNumWorldPVPAreas = GetNumWorldPVPAreas
local GetWorldPVPAreaInfo = GetWorldPVPAreaInfo
local SecondsToTime = SecondsToTime
local GetNumSavedInstances = GetNumSavedInstances
local GetSavedInstanceInfo = GetSavedInstanceInfo

local QUEUE_TIME_UNAVAILABLE = QUEUE_TIME_UNAVAILABLE
local TIMEMANAGER_AM = TIMEMANAGER_AM
local TIMEMANAGER_PM = TIMEMANAGER_PM
local TIMEMANAGER_TOOLTIP_LOCALTIME = TIMEMANAGER_TOOLTIP_LOCALTIME
local TIMEMANAGER_TOOLTIP_REALMTIME = TIMEMANAGER_TOOLTIP_REALMTIME
local VOICE_CHAT_BATTLEGROUND = VOICE_CHAT_BATTLEGROUND
local WINTERGRASP_IN_PROGRESS = WINTERGRASP_IN_PROGRESS

local timeDisplayFormat, dateDisplayFormat = "", ""
local lockoutInfoFormat = "%s%s %s |cffaaaaaa(%s, |cfff04000%s/%s|r|cffaaaaaa)"
local lockoutInfoFormatNoEnc = "%s%s %s |cffaaaaaa(%s)"
local formatBattleGroundInfo = "%s: "
local lockoutColorExtended, lockoutColorNormal = {r = 0.3, g = 1, b = 0.3}, {r = 0.8, g = 0.8, b = 0.8}
local enteredFrame = false
local timeFormat, showAMPM
local realmDiffSeconds
local lastPanel

local locale = GetLocale()
local krcntw = locale == "koKR" or locale == "zhCN" or locale == "zhTW"
local difficultyTag = {
	(krcntw and PLAYER_DIFFICULTY3) or utf8sub(PLAYER_DIFFICULTY3, 1, 1), -- Raid Finder
	(krcntw and PLAYER_DIFFICULTY1) or utf8sub(PLAYER_DIFFICULTY1, 1, 1), -- Normal
	(krcntw and PLAYER_DIFFICULTY2) or utf8sub(PLAYER_DIFFICULTY2, 1, 1), -- Heroic
}

local function getRealmTimeDiff()
	local hours, minutes = GetGameTime()
	local systemTime = date("*t")

	local diffHours = systemTime.hour - hours
	local diffMinutes = systemTime.min - minutes

	return (diffHours * 60 + diffMinutes) * 60
end

local function GetCurrentDate(formatString, isTooltip)
	if timeFormat ~= E.db.datatexts.timeFormat then
		timeFormat = E.db.datatexts.timeFormat
		showAMPM = find(E.db.datatexts.timeFormat, "%%p") ~= nil
	end

	if showAMPM then
		local localizedAMPM = tonumber(date("%H")) >= 12 and TIMEMANAGER_PM or TIMEMANAGER_AM

		formatString = gsub(formatString, "^%%p", localizedAMPM)
		formatString = gsub(formatString, "([^%%])%%p", "%1"..localizedAMPM)
	end

	if (realmDiffSeconds ~= 0 and not E.db.datatexts.localTime) or (realmDiffSeconds ~= 0 and isTooltip) then
		return date(formatString, time() -realmDiffSeconds)
	else
		return date(formatString)
	end
end

local instanceIconByName = {}
local function GetInstanceImages(...)
	local numTextures = select("#", ...) / 4

	local param, title, texture = 1
	for i = 1, numTextures do
		title = select(param, ...)
		param = param + 1
		texture = select(param, ...)
		param = param + 1
		instanceIconByName[title] = texture
		param = param + 2
	end
end

local function OnClick(_, btn)
	if btn == "RightButton" then
		if not IsAddOnLoaded("Blizzard_TimeManager") then LoadAddOn("Blizzard_TimeManager") end
		TimeManagerClockButton_OnClick(TimeManagerClockButton)
	else
		GameTimeFrame:Click()
	end
end

local collectedInstanceImages = false
local function OnEnter(self)
	DT:SetupTooltip(self)

	if not enteredFrame then
		RequestRaidInfo()

		enteredFrame = true
	end

	if not collectedInstanceImages then
		GetInstanceImages(CalendarEventGetTextures(1))
		GetInstanceImages(CalendarEventGetTextures(2))

		collectedInstanceImages = true
	end

	local addedHeader = false
	local localizedName, isActive, startTime, canEnter, _

	for i = 1, GetNumWorldPVPAreas() do
		_, localizedName, isActive, _, startTime, canEnter = GetWorldPVPAreaInfo(i)
		if canEnter then
			if not addedHeader then
				DT.tooltip:AddLine(VOICE_CHAT_BATTLEGROUND)
				addedHeader = true
			end
			if isActive then
				startTime = WINTERGRASP_IN_PROGRESS
			elseif startTime == nil then
				startTime = QUEUE_TIME_UNAVAILABLE
			else
				startTime = SecondsToTime(startTime, false, nil, 3)
			end
			DT.tooltip:AddDoubleLine(format(formatBattleGroundInfo, localizedName), startTime, 1, 1, 1, lockoutColorNormal.r, lockoutColorNormal.g, lockoutColorNormal.b)
		end
	end

	local lockedInstances = {raids = {}, dungeons = {}}
	local name, difficulty, locked, extended, isRaid
	local isLFR, isHeroic, difficultyLetter, buttonImg

	for i = 1, GetNumSavedInstances() do
		name, _, _, difficulty, locked, extended, _, isRaid = GetSavedInstanceInfo(i)
		if (locked or extended) and name then
			isLFR = (difficulty == 7 or difficulty == 17)
			isHeroic = (difficulty == 2 or difficulty == 5 or difficulty == 6 or difficulty == 15)

			difficultyLetter = (isHeroic and difficultyTag[3] or isLFR and difficultyTag[1] or difficultyTag[2])
			buttonImg = instanceIconByName[name] and format("|T%s:16:16:0:0:96:96:0:64:0:64|t ", "Interface\\LFGFrame\\LFGIcon-"..instanceIconByName[name]) or ""

			if isRaid then
				tinsert(lockedInstances.raids, {name, difficultyLetter, buttonImg, {GetSavedInstanceInfo(i)}})
			elseif difficulty == 2 then
				tinsert(lockedInstances.dungeons, {name, difficultyLetter, buttonImg, {GetSavedInstanceInfo(i)}})
			end
		end
	end

	local reset, maxPlayers, numEncounters, encounterProgress, lockoutColor
	if next(lockedInstances.raids) then
		if DT.tooltip:NumLines() > 0 then
			DT.tooltip:AddLine(" ")
		end
		DT.tooltip:AddLine(L["Saved Raid(s)"])

		tsort(lockedInstances.raids, function(a, b) return a[1] < b[1] end)

		for i = 1, #lockedInstances.raids do
			difficultyLetter = lockedInstances.raids[i][2]
			buttonImg = lockedInstances.raids[i][3]
			name, _, reset, _, _, extended, _, _, maxPlayers, _, numEncounters, encounterProgress = unpack(lockedInstances.raids[i][4])

			lockoutColor = extended and lockoutColorExtended or lockoutColorNormal
			if (numEncounters and numEncounters > 0) and (encounterProgress and encounterProgress > 0) then
				DT.tooltip:AddDoubleLine(format(lockoutInfoFormat, buttonImg, maxPlayers, difficultyLetter, name, encounterProgress, numEncounters), SecondsToTime(reset, false, nil, 3), 1, 1, 1, lockoutColor.r, lockoutColor.g, lockoutColor.b)
			else
				DT.tooltip:AddDoubleLine(format(lockoutInfoFormatNoEnc, buttonImg, maxPlayers, difficultyLetter, name), SecondsToTime(reset, false, nil, 3), 1, 1, 1, lockoutColor.r, lockoutColor.g, lockoutColor.b)
			end
		end
	end

	if next(lockedInstances.dungeons) then
		if DT.tooltip:NumLines() > 0 then
			DT.tooltip:AddLine(" ")
		end
		DT.tooltip:AddLine(L["Saved Dungeon(s)"])

		tsort(lockedInstances.dungeons, function(a, b) return a[1] < b[1] end)

		for i = 1, #lockedInstances.dungeons do
			difficultyLetter = lockedInstances.dungeons[i][2]
			buttonImg = lockedInstances.dungeons[i][3]
			name, _, reset, _, _, extended, _, _, maxPlayers, _, numEncounters, encounterProgress = unpack(lockedInstances.dungeons[i][4])

			lockoutColor = extended and lockoutColorExtended or lockoutColorNormal
			if (numEncounters and numEncounters > 0) and (encounterProgress and encounterProgress > 0) then
				DT.tooltip:AddDoubleLine(format(lockoutInfoFormat, buttonImg, maxPlayers, difficultyLetter, name, encounterProgress, numEncounters), SecondsToTime(reset, false, nil, 3), 1, 1, 1, lockoutColor.r, lockoutColor.g, lockoutColor.b)
			else
				DT.tooltip:AddDoubleLine(format(lockoutInfoFormatNoEnc, buttonImg, maxPlayers, difficultyLetter, name), SecondsToTime(reset, false, nil, 3), 1, 1, 1, lockoutColor.r, lockoutColor.g, lockoutColor.b)
			end
		end
	end

	if DT.tooltip:NumLines() > 0 then
		DT.tooltip:AddLine(" ")
	end

	local timeFormat1 = E.db.datatexts.timeFormat ~= "" and E.db.datatexts.timeFormat or "%H:%M"
	local timeType = E.db.datatexts.localTime and TIMEMANAGER_TOOLTIP_REALMTIME or TIMEMANAGER_TOOLTIP_LOCALTIME
	local timeString = E.db.datatexts.localTime and GetCurrentDate(timeFormat1, true) or date(timeFormat1)

	DT.tooltip:AddDoubleLine(timeType, timeString, 1, 1, 1, lockoutColorNormal.r, lockoutColorNormal.g, lockoutColorNormal.b)

	DT.tooltip:Show()
end

local function OnLeave()
	DT.tooltip:Hide()

	enteredFrame = false
end

local function OnEvent(self, event)
	if not realmDiffSeconds then
		realmDiffSeconds = getRealmTimeDiff()
	end

	if event == "UPDATE_INSTANCE_INFO" and enteredFrame then
		OnEnter(self)
	end
end

local int = 5
local function OnUpdate(self, t)
	int = int - t

	if int > 0 then return end

	if enteredFrame then OnEnter(self) end

	if GameTimeFrame.flashInvite then
		E:Flash(self, 0.53, true)
	else
		E:StopFlash(self)
	end

	self.text:SetText(gsub(gsub(GetCurrentDate(E.db.datatexts.timeFormat.." "..E.db.datatexts.dateFormat), ":", timeDisplayFormat), "%s", dateDisplayFormat))

	lastPanel = self

	int = 1
end

local function ValueColorUpdate(hex)
	timeDisplayFormat = join("", hex, ":|r")
	dateDisplayFormat = join("", hex, " ")

	if lastPanel ~= nil then
		OnUpdate(lastPanel, 20000)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext("Time", {"UPDATE_INSTANCE_INFO"}, OnEvent, OnUpdate, OnClick, OnEnter, OnLeave)