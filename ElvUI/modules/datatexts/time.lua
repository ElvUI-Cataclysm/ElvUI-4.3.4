local E, L, V, P, G = unpack(select(2, ...));
local DT = E:GetModule('DataTexts')

local time = time;
local format, join = string.format, string.join

local GetGameTime = GetGameTime
local RequestRaidInfo = RequestRaidInfo
local GetNumWorldPVPAreas = GetNumWorldPVPAreas
local GetWorldPVPAreaInfo = GetWorldPVPAreaInfo
local SecondsToTime = SecondsToTime
local GetNumSavedInstances = GetNumSavedInstances
local GetSavedInstanceInfo = GetSavedInstanceInfo
local VOICE_CHAT_BATTLEGROUND = VOICE_CHAT_BATTLEGROUND
local WINTERGRASP_IN_PROGRESS = WINTERGRASP_IN_PROGRESS
local QUEUE_TIME_UNAVAILABLE = QUEUE_TIME_UNAVAILABLE
local TIMEMANAGER_TOOLTIP_REALMTIME = TIMEMANAGER_TOOLTIP_REALMTIME

local timeDisplayFormat = "";
local dateDisplayFormat = "";
local europeDisplayFormat_nocolor = join("", "%02d", ":|r%02d")
local timerLongFormat = "%d:%02d:%02d"
local timerShortFormat = "%d:%02d"
local lockoutInfoFormat = "%s%s |cffaaaaaa(%s, %s/%s)"
local lockoutInfoFormatNoEnc = "%s%s |cffaaaaaa(%s)"
local formatBattleGroundInfo = "%s: "
local lockoutColorExtended, lockoutColorNormal = { r=0.3,g=1,b=0.3 }, { r=.8,g=.8,b=.8 }
local lockoutFormatString = { "%dd %02dh %02dm", "%dd %dh %02dm", "%02dh %02dm", "%dh %02dm", "%dh %02dm", "%dm" }
local curHr, curMin, curAmPm
local enteredFrame = false;

local Update, lastPanel; -- UpValue
local localizedName, isActive, canQueue, startTime, canEnter, _
local name, instanceID, reset, difficultyId, locked, extended, isRaid, maxPlayers, difficulty, numEncounters, encounterProgress

local function ValueColorUpdate(hex, r, g, b)
	timeDisplayFormat = join("", hex, ":|r");
	dateDisplayFormat = join("", hex, " ");

	if lastPanel ~= nil then
		Update(lastPanel, 20000)
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

local function Click(_, btn)
	if(btn == "RightButton") then
 		TimeManagerClockButton_OnClick(TimeManagerClockButton);
 	else
 		GameTimeFrame:Click();
 	end
end

local function OnLeave(self)
	DT.tooltip:Hide();
	enteredFrame = false;
end

local function OnEnter(self)
	DT:SetupTooltip(self)
	enteredFrame = true;
	DT.tooltip:AddLine(VOICE_CHAT_BATTLEGROUND);
	local localizedName, isActive, canQueue, startTime, canEnter
	for i = 1, GetNumWorldPVPAreas() do
		_, localizedName, isActive, canQueue, startTime, canEnter = GetWorldPVPAreaInfo(i)
		if canEnter then
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

	local oneraid, lockoutColor
	for i = 1, GetNumSavedInstances() do
		local name, _, reset, difficulty, locked, extended, _, isRaid, maxPlayers, _, numEncounters, encounterProgress  = GetSavedInstanceInfo(i)
		if isRaid and (locked or extended) then
			local tr,tg,tb,diff
			if not oneraid then
				DT.tooltip:AddLine(" ")
				DT.tooltip:AddLine(L["Saved Raid(s)"])
				oneraid = true
			end
			if extended then
				lockoutColor = lockoutColorExtended
			else
				lockoutColor = lockoutColorNormal
			end

			DT.tooltip:AddDoubleLine(format(lockoutInfoFormat, maxPlayers, difficultyInfo[difficulty], name, encounterProgress, numEncounters), SecondsToTime(reset, false, nil, 3), 1, 1, 1, lockoutColor.r, lockoutColor.g, lockoutColor.b)
		end
	end

	DT.tooltip:AddLine(" ")

	DT.tooltip:AddDoubleLine(TIMEMANAGER_TOOLTIP_REALMTIME, format(europeDisplayFormat_nocolor, GetGameTime()), 1, 1, 1, lockoutColorNormal.r, lockoutColorNormal.g, lockoutColorNormal.b);

	DT.tooltip:Show()
end

local function OnEvent(_, event)
	if(event == "UPDATE_INSTANCE_INFO" and enteredFrame) then
		RequestRaidInfo();
	end
end

local int = 5
function Update(self, t)
	int = int - t

	if int > 0 then return end

	if GameTimeFrame.flashInvite then
		E:Flash(self, 0.53, true)
	else
		E:StopFlash(self)
	end

	if enteredFrame then
		OnEnter(self)
	end

	self.text:SetText(BetterDate(E.db.datatexts.timeFormat .. " " .. E.db.datatexts.dateFormat, time()):gsub(":", timeDisplayFormat):gsub("%s", dateDisplayFormat));

	lastPanel = self
	int = 1
end

DT:RegisterDatatext('Time', {"UPDATE_INSTANCE_INFO"}, OnEvent, Update, Click, OnEnter, OnLeave)