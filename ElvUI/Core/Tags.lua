local E, L, V, P, G = unpack(select(2, ...))
local ElvUF = E.oUF

local Translit = E.Libs.Translit
local translitMark = "!"

local _G = _G
local pairs = pairs
local floor = math.floor
local gmatch, gsub, format = gmatch, gsub, format
local strfind, strmatch, strlower, utf8lower, utf8sub = strfind, strmatch, strlower, string.utf8lower, string.utf8sub

local GetEclipseDirection = GetEclipseDirection
local GetNumPartyMembers = GetNumPartyMembers
local GetPVPTimer = GetPVPTimer
local GetQuestGreenRange = GetQuestGreenRange
local GetShapeshiftFormID = GetShapeshiftFormID
local GetThreatStatusColor = GetThreatStatusColor
local GetTime = GetTime
local GetUnitSpeed = GetUnitSpeed
local UnitAlternatePowerTextureInfo = UnitAlternatePowerTextureInfo
local UnitClass = UnitClass
local UnitClassification = UnitClassification
local UnitDetailedThreatSituation = UnitDetailedThreatSituation
local UnitExists = UnitExists
local UnitGetIncomingHeals = UnitGetIncomingHeals
local UnitGUID = UnitGUID
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsAFK = UnitIsAFK
local UnitIsConnected = UnitIsConnected
local UnitIsDead = UnitIsDead
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsDND = UnitIsDND
local UnitIsGhost = UnitIsGhost
local UnitIsPlayer = UnitIsPlayer
local UnitIsPVP = UnitIsPVP
local UnitIsPVPFreeForAll = UnitIsPVPFreeForAll
local UnitLevel = UnitLevel
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitPowerType = UnitPowerType
local UnitReaction = UnitReaction

local ALTERNATE_POWER_INDEX = ALTERNATE_POWER_INDEX
local DEFAULT_AFK_MESSAGE = DEFAULT_AFK_MESSAGE
local LEVEL = LEVEL
local MOONKIN_FORM = MOONKIN_FORM
local PVP = PVP
local SPELL_POWER_ECLIPSE = SPELL_POWER_ECLIPSE
local SPELL_POWER_HOLY_POWER = SPELL_POWER_HOLY_POWER
local SPELL_POWER_SOUL_SHARDS = SPELL_POWER_SOUL_SHARDS

------------------------------------------------------------------------
--	Tag Extra Events
------------------------------------------------------------------------

ElvUF.Tags.SharedEvents.QUEST_LOG_UPDATE = true

------------------------------------------------------------------------
--	Tags
------------------------------------------------------------------------

local function abbrev(name)
	local letters, lastWord = "", strmatch(name, ".+%s(.+)$")

	if lastWord then
		for word in gmatch(name, ".-%s") do
			local firstLetter = utf8sub(gsub(word, "^[%s%p]*", ""), 1, 1)
			if firstLetter ~= utf8lower(firstLetter) then
				letters = format("%s%s. ", letters, firstLetter)
			end
		end
		name = format("%s%s", letters, lastWord)
	end

	return name
end

local function GetClassPower(class)
	local min, max, r, g, b = 0, 0, 0, 0, 0

	if class == "PALADIN" then
		min = UnitPower("player", SPELL_POWER_HOLY_POWER)
		max = UnitPowerMax("player", SPELL_POWER_HOLY_POWER)
		r, g, b = 0.89, 1, 0.06
	elseif class == "DRUID" and GetShapeshiftFormID() == MOONKIN_FORM then
		min = UnitPower("player", SPELL_POWER_ECLIPSE)
		max = UnitPowerMax("player", SPELL_POWER_ECLIPSE)
		if GetEclipseDirection() == "moon" then
			r, g, b = 0.80, 0.82, 0.60
		else
			r, g, b = 0.30, 0.52, 0.90
		end
	elseif class == "WARLOCK" then
		min = UnitPower("player", SPELL_POWER_SOUL_SHARDS)
		max = UnitPowerMax("player", SPELL_POWER_SOUL_SHARDS)
		r, g, b = 0.58, 0.51, 0.79
	end

	return min, max, r, g, b
end

ElvUF.Tags.Events["altpowercolor"] = "UNIT_POWER UNIT_MAXPOWER"
ElvUF.Tags.Methods["altpowercolor"] = function(u)
	local cur = UnitPower(u, ALTERNATE_POWER_INDEX)

	if cur > 0 then
		local _, r, g, b = UnitAlternatePowerTextureInfo(u, 2)

		if not r then
			r, g, b = 1, 1, 1
		end

		return Hex(r, g, b)
	else
		return nil
	end
end

ElvUF.Tags.Events["afk"] = "PLAYER_FLAGS_CHANGED"
ElvUF.Tags.Methods["afk"] = function(unit)
	local isAFK = UnitIsAFK(unit)

	if isAFK then
		return format("|cffFFFFFF[|r|cffFF0000%s|r|cFFFFFFFF]|r", DEFAULT_AFK_MESSAGE)
	else
		return nil
	end
end

ElvUF.Tags.Events["healthcolor"] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED"
ElvUF.Tags.Methods["healthcolor"] = function(unit)
	if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
		return Hex(0.84, 0.75, 0.65)
	else
		local r, g, b = ElvUF:ColorGradient(UnitHealth(unit), UnitHealthMax(unit), 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)

		return Hex(r, g, b)
	end
end

ElvUF.Tags.Events["name:abbrev"] = "UNIT_NAME_UPDATE"
ElvUF.Tags.Methods["name:abbrev"] = function(unit)
	local name = UnitName(unit)

	if name and strfind(name, "%s") then
		name = abbrev(name)
	end

	return name ~= nil and name or ""
end

for textFormat in pairs(E.GetFormattedTextStyles) do
	local tagTextFormat = strlower(gsub(textFormat, "_", "-"))

	ElvUF.Tags.Events[format("health:%s", tagTextFormat)] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED"
	ElvUF.Tags.Methods[format("health:%s", tagTextFormat)] = function(unit)
		local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]

		if status then
			return status
		else
			return E:GetFormattedText(textFormat, UnitHealth(unit), UnitHealthMax(unit))
		end
	end

	ElvUF.Tags.Events[format("health:%s-nostatus", tagTextFormat)] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH"
	ElvUF.Tags.Methods[format("health:%s-nostatus", tagTextFormat)] = function(unit)
		return E:GetFormattedText(textFormat, UnitHealth(unit), UnitHealthMax(unit))
	end

	ElvUF.Tags.Events[format("power:%s", tagTextFormat)] = "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER"
	ElvUF.Tags.Methods[format("power:%s", tagTextFormat)] = function(unit)
		local pType = UnitPowerType(unit)
		local min = UnitPower(unit, pType)

		if min == 0 and tagTextFormat ~= "deficit" then
			return ""
		else
			return E:GetFormattedText(textFormat, UnitPower(unit, pType), UnitPowerMax(unit, pType))
		end
	end

	ElvUF.Tags.Events[format("mana:%s", tagTextFormat)] = "UNIT_POWER_FREQUENT UNIT_MAXPOWER"
	ElvUF.Tags.Methods[format("mana:%s", tagTextFormat)] = function(unit)
		local min = UnitPower(unit, SPELL_POWER_MANA)

		if min == 0 and tagTextFormat ~= "deficit" then
			return ""
		else
			return E:GetFormattedText(textFormat, UnitPower(unit, SPELL_POWER_MANA), UnitPowerMax(unit, SPELL_POWER_MANA))
		end
	end

	ElvUF.Tags.Events[format("classpower:%s", tagTextFormat)] = "UNIT_POWER_FREQUENT PLAYER_TALENT_UPDATE UPDATE_SHAPESHIFT_FORM"
	ElvUF.Tags.Methods[format("classpower:%s", tagTextFormat)] = function()
		local min, max = GetClassPower(E.myclass)

		if min == 0 then
			return nil
		else
			return E:GetFormattedText(textFormat, min, max)
		end
	end

	ElvUF.Tags.Events[format("altpower:%s", tagTextFormat)] = "UNIT_POWER UNIT_MAXPOWER"
	ElvUF.Tags.Methods[format("altpower:%s", tagTextFormat)] = function(u)
		local cur = UnitPower(u, ALTERNATE_POWER_INDEX)

		if cur > 0 then
			local max = UnitPowerMax(u, ALTERNATE_POWER_INDEX)

			return E:GetFormattedText(textFormat, cur, max)
		else
			return nil
		end
	end
end

for textFormat, length in pairs({veryshort = 5, short = 10, medium = 15, long = 20}) do
	ElvUF.Tags.Events[format("health:deficit-percent:name-%s", textFormat)] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_NAME_UPDATE"
	ElvUF.Tags.Methods[format("health:deficit-percent:name-%s", textFormat)] = function(unit)
		local cur, max = E:UnitHealthValues(unit)
		local deficit = max - cur

		if deficit > 0 and cur > 0 then
			return _TAGS["health:percent-nostatus"](unit)
		else
			return _TAGS[format("name:%s", textFormat)](unit)
		end
	end

	ElvUF.Tags.Events[format("name:abbrev:%s", textFormat)] = "UNIT_NAME_UPDATE"
	ElvUF.Tags.Methods[format("name:abbrev:%s", textFormat)] = function(unit)
		local name = UnitName(unit)

		if name and strfind(name, "%s") then
			name = abbrev(name)
		end

		return name ~= nil and E:ShortenString(name, length) or ""
	end

	ElvUF.Tags.Events[format("name:%s", textFormat)] = "UNIT_NAME_UPDATE"
	ElvUF.Tags.Methods[format("name:%s", textFormat)] = function(unit)
		local name = UnitName(unit)

		return name ~= nil and E:ShortenString(name, length) or nil
	end

	ElvUF.Tags.Events[format("name:%s:status", textFormat)] = "UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH_FREQUENT"
	ElvUF.Tags.Methods[format("name:%s:status", textFormat)] = function(unit)
		local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
		local name = UnitName(unit)

		if status then
			return status
		else
			return name ~= nil and E:ShortenString(name, length) or nil
		end
	end

	ElvUF.Tags.Events[format("name:%s:translit", textFormat)] = "UNIT_NAME_UPDATE"
	ElvUF.Tags.Methods[format("name:%s:translit", textFormat)] = function(unit)
		local name = Translit:Transliterate(UnitName(unit), translitMark)

		return name ~= nil and E:ShortenString(name, length) or nil
	end

	ElvUF.Tags.Events[format("target:%s", textFormat)] = "UNIT_TARGET"
	ElvUF.Tags.Methods[format("target:%s", textFormat)] = function(unit)
		local targetName = UnitName(unit.."target")

		return targetName ~= nil and E:ShortenString(targetName, length) or nil
	end

	ElvUF.Tags.Events[format("target:%s:translit", textFormat)] = "UNIT_TARGET"
	ElvUF.Tags.Methods[format("target:%s:translit", textFormat)] = function(unit)
		local targetName = Translit:Transliterate(UnitName(unit.."target"), translitMark)

		return targetName ~= nil and E:ShortenString(targetName, length) or nil
	end
end

ElvUF.Tags.Events["health:max"] = "UNIT_MAXHEALTH"
ElvUF.Tags.Methods["health:max"] = function(unit)
	local max = UnitHealthMax(unit)

	return E:GetFormattedText("CURRENT", max, max)
end

ElvUF.Tags.Events["health:deficit-percent:name"] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_NAME_UPDATE"
ElvUF.Tags.Methods["health:deficit-percent:name"] = function(unit)
	local currentHealth = UnitHealth(unit)
	local deficit = UnitHealthMax(unit) - currentHealth

	if deficit > 0 and currentHealth > 0 then
		return _TAGS["health:percent-nostatus"](unit)
	else
		return _TAGS.name(unit)
	end
end

ElvUF.Tags.Events["power:max"] = "UNIT_DISPLAYPOWER UNIT_MAXPOWER"
ElvUF.Tags.Methods["power:max"] = function(unit)
	local pType = UnitPowerType(unit)
	local max = UnitPowerMax(unit, pType)

	return E:GetFormattedText("CURRENT", max, max)
end

ElvUF.Tags.Methods["manacolor"] = function()
	local mana = PowerBarColor.MANA
	local altR, altG, altB = mana.r, mana.g, mana.b
	local color = ElvUF.colors.power.MANA

	if color then
		return Hex(color[1], color[2], color[3])
	else
		return Hex(altR, altG, altB)
	end
end

ElvUF.Tags.Events["mana:max"] = "UNIT_MAXPOWER"
ElvUF.Tags.Methods["mana:max"] = function(unit)
	local max = UnitPowerMax(unit, SPELL_POWER_MANA)

	return E:GetFormattedText("CURRENT", max, max)
end

ElvUF.Tags.Events["difficultycolor"] = "UNIT_LEVEL PLAYER_LEVEL_UP"
ElvUF.Tags.Methods["difficultycolor"] = function(unit)
	local r, g, b
	local DiffColor = UnitLevel(unit) - E.mylevel

	if DiffColor >= 5 then
		r, g, b = 0.69, 0.31, 0.31
	elseif DiffColor >= 3 then
		r, g, b = 0.71, 0.43, 0.27
	elseif DiffColor >= -2 then
		r, g, b = 0.84, 0.75, 0.65
	elseif -DiffColor <= GetQuestGreenRange() then
		r, g, b = 0.33, 0.59, 0.33
	else
		r, g, b = 0.55, 0.57, 0.61
	end

	return Hex(r, g, b)
end

ElvUF.Tags.Events["namecolor"] = "UNIT_NAME_UPDATE UNIT_FACTION"
ElvUF.Tags.Methods["namecolor"] = function(unit)
	local unitReaction = UnitReaction(unit, "player")
	local unitPlayer = UnitIsPlayer(unit)

	if unitPlayer then
		local _, unitClass = UnitClass(unit)
		local class = ElvUF.colors.class[unitClass]
		if not class then return "" end

		return Hex(class[1], class[2], class[3])
	elseif unitReaction then
		local reaction = ElvUF.colors.reaction[unitReaction]

		return Hex(reaction[1], reaction[2], reaction[3])
	else
		return "|cFFC2C2C2"
	end
end

ElvUF.Tags.Events["smartlevel"] = "UNIT_LEVEL PLAYER_LEVEL_UP"
ElvUF.Tags.Methods["smartlevel"] = function(unit)
	local level = UnitLevel(unit)

	if level == E.mylevel then
		return nil
	elseif level > 0 then
		return level
	else
		return "??"
	end
end

ElvUF.Tags.Events["realm"] = "UNIT_NAME_UPDATE"
ElvUF.Tags.Methods["realm"] = function(unit)
	local _, realm = UnitName(unit)

	if realm and realm ~= "" then
		return realm
	else
		return nil
	end
end

ElvUF.Tags.Events["realm:dash"] = "UNIT_NAME_UPDATE"
ElvUF.Tags.Methods["realm:dash"] = function(unit)
	local _, realm = UnitName(unit)

	if realm and (realm ~= "" and realm ~= E.myrealm) then
		realm = format("-%s", realm)
	elseif realm == "" then
		realm = nil
	end

	return realm
end

ElvUF.Tags.Events["realm:translit"] = "UNIT_NAME_UPDATE"
ElvUF.Tags.Methods["realm:translit"] = function(unit)
	local _, realm = Translit:Transliterate(UnitName(unit), translitMark)

	if realm and realm ~= "" then
		return realm
	else
		return nil
	end
end

ElvUF.Tags.Events["realm:dash:translit"] = "UNIT_NAME_UPDATE"
ElvUF.Tags.Methods["realm:dash:translit"] = function(unit)
	local _, realm = Translit:Transliterate(UnitName(unit), translitMark)

	if realm and (realm ~= "" and realm ~= E.myrealm) then
		realm = format("-%s", realm)
	elseif realm == "" then
		realm = nil
	end

	return realm
end

ElvUF.Tags.Events["threat:percent"] = "UNIT_THREAT_SITUATION_UPDATE UNIT_THREAT_LIST_UPDATE RAID_ROSTER_UPDATE PARTY_MEMBERS_CHANGED"
ElvUF.Tags.Methods["threat:percent"] = function(unit)
	local _, _, percent = UnitDetailedThreatSituation("player", unit)

	if (percent and percent > 0) and (GetNumPartyMembers() or UnitExists("pet")) then
		return format("%.0f%%", percent)
	else
		return nil
	end
end

ElvUF.Tags.Events["threat:current"] = "UNIT_THREAT_SITUATION_UPDATE UNIT_THREAT_LIST_UPDATE RAID_ROSTER_UPDATE PARTY_MEMBERS_CHANGED"
ElvUF.Tags.Methods["threat:current"] = function(unit)
	local _, _, percent, _, threatvalue = UnitDetailedThreatSituation("player", unit)

	if (percent and percent > 0) and (GetNumPartyMembers() or UnitExists("pet")) then
		return E:ShortValue(threatvalue)
	else
		return nil
	end
end

ElvUF.Tags.Events["threatcolor"] = "UNIT_THREAT_SITUATION_UPDATE UNIT_THREAT_LIST_UPDATE RAID_ROSTER_UPDATE PARTY_MEMBERS_CHANGED"
ElvUF.Tags.Methods["threatcolor"] = function(unit)
	local _, status = UnitDetailedThreatSituation("player", unit)

	if (status) and (GetNumPartyMembers() > 0 or UnitExists("pet")) then
		return Hex(GetThreatStatusColor(status))
	else
		return nil
	end
end

local unitStatus = {}
ElvUF.Tags.OnUpdateThrottle["statustimer"] = 1
ElvUF.Tags.Methods["statustimer"] = function(unit)
	if not UnitIsPlayer(unit) then return end

	local guid = UnitGUID(unit)

	if UnitIsAFK(unit) then
		if not unitStatus[guid] or unitStatus[guid] and unitStatus[guid][1] ~= "AFK" then
			unitStatus[guid] = {"AFK", GetTime()}
		end
	elseif UnitIsDND(unit) then
		if not unitStatus[guid] or unitStatus[guid] and unitStatus[guid][1] ~= "DND" then
			unitStatus[guid] = {"DND", GetTime()}
		end
	elseif UnitIsDead(unit) or UnitIsGhost(unit) then
		if not unitStatus[guid] or unitStatus[guid] and unitStatus[guid][1] ~= "Dead" then
			unitStatus[guid] = {"Dead", GetTime()}
		end
	elseif not UnitIsConnected(unit) then
		if not unitStatus[guid] or unitStatus[guid] and unitStatus[guid][1] ~= "Offline" then
			unitStatus[guid] = {"Offline", GetTime()}
		end
	else
		unitStatus[guid] = nil
	end

	if unitStatus[guid] ~= nil then
		local status = unitStatus[guid][1]
		local timer = GetTime() - unitStatus[guid][2]
		local mins = floor(timer / 60)
		local secs = floor(timer - (mins * 60))

		return format("%s (%01.f:%02.f)", status, mins, secs)
	else
		return nil
	end
end

ElvUF.Tags.OnUpdateThrottle["pvptimer"] = 1
ElvUF.Tags.Methods["pvptimer"] = function(unit)
	if UnitIsPVPFreeForAll(unit) or UnitIsPVP(unit) then
		local timer = GetPVPTimer()

		if timer ~= 301000 and timer ~= -1 then
			local mins = floor((timer / 1000) / 60)
			local secs = floor((timer / 1000) - (mins * 60))

			return format("%s (%01.f:%02.f)", PVP, mins, secs)
		else
			return PVP
		end
	else
		return nil
	end
end

ElvUF.Tags.Events["classpowercolor"] = "UNIT_POWER_FREQUENT PLAYER_TALENT_UPDATE UPDATE_SHAPESHIFT_FORM"
ElvUF.Tags.Methods["classpowercolor"] = function()
	local _, _, r, g, b = GetClassPower(E.myclass)

	return Hex(r, g, b)
end

ElvUF.Tags.Events["incomingheals:personal"] = "UNIT_HEAL_PREDICTION"
ElvUF.Tags.Methods["incomingheals:personal"] = function(unit)
	local heal = UnitGetIncomingHeals(unit, "player") or 0

	if heal == 0 then
		return nil
	else
		return E:ShortValue(heal)
	end
end

ElvUF.Tags.Events["incomingheals:others"] = "UNIT_HEAL_PREDICTION"
ElvUF.Tags.Methods["incomingheals:others"] = function(unit)
	local personal = UnitGetIncomingHeals(unit, "player") or 0
	local heal = UnitGetIncomingHeals(unit) or 0
	local others = heal - personal

	if others == 0 then
		return nil
	else
		return E:ShortValue(others)
	end
end

ElvUF.Tags.Events["incomingheals"] = "UNIT_HEAL_PREDICTION"
ElvUF.Tags.Methods["incomingheals"] = function(unit)
	local heal = UnitGetIncomingHeals(unit) or 0

	if heal == 0 then
		return nil
	else
		return E:ShortValue(heal)
	end
end

local baseSpeed = BASE_MOVEMENT_SPEED
local speedText = SPEED

ElvUF.Tags.OnUpdateThrottle["speed:percent"] = 0.1
ElvUF.Tags.Methods["speed:percent"] = function(unit)
	local currentSpeedInYards = GetUnitSpeed(unit)
	local currentSpeedInPercent = (currentSpeedInYards / baseSpeed) * 100

	return format("%s: %d%%", speedText, currentSpeedInPercent)
end

ElvUF.Tags.OnUpdateThrottle["speed:percent-moving"] = 0.1
ElvUF.Tags.Methods["speed:percent-moving"] = function(unit)
	local currentSpeedInYards = GetUnitSpeed(unit)
	local currentSpeedInPercent = currentSpeedInYards > 0 and ((currentSpeedInYards / baseSpeed) * 100)

	if currentSpeedInPercent then
		currentSpeedInPercent = format("%s: %d%%", speedText, currentSpeedInPercent)
	end

	return currentSpeedInPercent or nil
end

ElvUF.Tags.OnUpdateThrottle["speed:percent-raw"] = 0.1
ElvUF.Tags.Methods["speed:percent-raw"] = function(unit)
	local currentSpeedInYards = GetUnitSpeed(unit)
	local currentSpeedInPercent = (currentSpeedInYards / baseSpeed) * 100

	return format("%d%%", currentSpeedInPercent)
end

ElvUF.Tags.OnUpdateThrottle["speed:percent-moving-raw"] = 0.1
ElvUF.Tags.Methods["speed:percent-moving-raw"] = function(unit)
	local currentSpeedInYards = GetUnitSpeed(unit)
	local currentSpeedInPercent = currentSpeedInYards > 0 and ((currentSpeedInYards / baseSpeed) * 100)

	if currentSpeedInPercent then
		currentSpeedInPercent = format("%d%%", currentSpeedInPercent)
	end

	return currentSpeedInPercent or nil
end

ElvUF.Tags.OnUpdateThrottle["speed:yardspersec"] = 0.1
ElvUF.Tags.Methods["speed:yardspersec"] = function(unit)
	local currentSpeedInYards = GetUnitSpeed(unit)

	return format("%s: %.1f", speedText, currentSpeedInYards)
end

ElvUF.Tags.OnUpdateThrottle["speed:yardspersec-moving"] = 0.1
ElvUF.Tags.Methods["speed:yardspersec-moving"] = function(unit)
	local currentSpeedInYards = GetUnitSpeed(unit)

	return currentSpeedInYards > 0 and format("%s: %.1f", speedText, currentSpeedInYards) or nil
end

ElvUF.Tags.OnUpdateThrottle["speed:yardspersec-raw"] = 0.1
ElvUF.Tags.Methods["speed:yardspersec-raw"] = function(unit)
	local currentSpeedInYards = GetUnitSpeed(unit)

	return format("%.1f", currentSpeedInYards)
end

ElvUF.Tags.OnUpdateThrottle["speed:yardspersec-moving-raw"] = 0.1
ElvUF.Tags.Methods["speed:yardspersec-moving-raw"] = function(unit)
	local currentSpeedInYards = GetUnitSpeed(unit)

	return currentSpeedInYards > 0 and format("%.1f", currentSpeedInYards) or nil
end

ElvUF.Tags.Events["classificationcolor"] = "UNIT_CLASSIFICATION_CHANGED"
ElvUF.Tags.Methods["classificationcolor"] = function(unit)
	local c = UnitClassification(unit)

	if c == "rare" or c == "elite" then
		return Hex(1, 0.5, 0.25) --Orange
	elseif c == "rareelite" or c == "worldboss" then
		return Hex(1, 0, 0) --Red
	end
end

ElvUF.Tags.SharedEvents.PLAYER_GUILD_UPDATE = true

ElvUF.Tags.Events["guild"] = "UNIT_NAME_UPDATE PLAYER_GUILD_UPDATE"
ElvUF.Tags.Methods["guild"] = function(unit)
	if UnitIsPlayer(unit) then
		return GetGuildInfo(unit) or nil
	end
end

ElvUF.Tags.Events["guild:brackets"] = "PLAYER_GUILD_UPDATE"
ElvUF.Tags.Methods["guild:brackets"] = function(unit)
	local guildName = GetGuildInfo(unit)

	return guildName and format("<%s>", guildName) or nil
end

ElvUF.Tags.Events["guild:translit"] = "UNIT_NAME_UPDATE PLAYER_GUILD_UPDATE"
ElvUF.Tags.Methods["guild:translit"] = function(unit)
	if UnitIsPlayer(unit) then
		return Translit:Transliterate(GetGuildInfo(unit), translitMark) or nil
	end
end

ElvUF.Tags.Events["guild:brackets:translit"] = "PLAYER_GUILD_UPDATE"
ElvUF.Tags.Methods["guild:brackets:translit"] = function(unit)
	local guildName = Translit:Transliterate(GetGuildInfo(unit), translitMark)

	return guildName and format("<%s>", guildName) or nil
end

ElvUF.Tags.Events["target"] = "UNIT_TARGET"
ElvUF.Tags.Methods["target"] = function(unit)
	local targetName = UnitName(unit.."target")

	return targetName or nil
end

ElvUF.Tags.Events["target:translit"] = "UNIT_TARGET"
ElvUF.Tags.Methods["target:translit"] = function(unit)
	local targetName = Translit:Transliterate(UnitName(unit.."target"), translitMark)

	return targetName or nil
end

ElvUF.Tags.Events["npctitle"] = "UNIT_NAME_UPDATE"
ElvUF.Tags.Methods["npctitle"] = function(unit)
	if UnitIsPlayer(unit) then return end

	E.ScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	E.ScanTooltip:SetUnit(unit)
	E.ScanTooltip:Show()

	local Title = _G[format("ElvUI_ScanTooltipTextLeft%d", GetCVarBool("colorblindmode") and 3 or 2)]:GetText()

	if Title and not Title:find("^"..LEVEL) then
		return Title
	end
end

ElvUF.Tags.Events["guild:rank"] = "UNIT_NAME_UPDATE"
ElvUF.Tags.Methods["guild:rank"] = function(unit)
	if UnitIsPlayer(unit) then
		return select(2, GetGuildInfo(unit)) or ""
	end
end

ElvUF.Tags.Events["arena:number"] = "UNIT_NAME_UPDATE"
ElvUF.Tags.Methods["arena:number"] = function(unit)
	local _, instanceType = GetInstanceInfo()

	if instanceType == "arena" then
		for i = 1, 5 do
			if UnitIsUnit(unit, "arena"..i) then
				return i
			end
		end
	end
end

ElvUF.Tags.Events["class"] = "UNIT_NAME_UPDATE"
ElvUF.Tags.Methods["class"] = function(unit)
	return UnitClass(unit)
end

ElvUF.Tags.Events["name:title"] = "UNIT_NAME_UPDATE"
ElvUF.Tags.Methods["name:title"] = function(unit)
	if UnitIsPlayer(unit) then
		return UnitPVPName(unit)
	end
end

ElvUF.Tags.Events["quest:title"] = "QUEST_LOG_UPDATE"
ElvUF.Tags.Methods["quest:title"] = function(unit)
	if UnitIsPlayer(unit) then return end

	E.ScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	E.ScanTooltip:SetUnit(unit)
	E.ScanTooltip:Show()

	local QuestName

	if E.ScanTooltip:NumLines() >= 3 then
		for i = 3, E.ScanTooltip:NumLines() do
			local QuestLine = _G["ElvUI_ScanTooltipTextLeft"..i]
			local QuestLineText = QuestLine and QuestLine:GetText()
			local PlayerName, ProgressText = strmatch(QuestLineText, "^ ([^ ]-) ?%- (.+)$")

			if not (PlayerName and PlayerName ~= "" and PlayerName ~= UnitName("player")) then
				if ProgressText then
					QuestName = _G["ElvUI_ScanTooltipTextLeft"..i - 1]:GetText()
				end
			end
		end

		for i = 1, GetNumQuestLogEntries() do
			local title, level, _, isHeader = GetQuestLogTitle(i)

			if not isHeader and title == QuestName then
				local colors = GetQuestDifficultyColor(level)

				return Hex(colors.r, colors.g, colors.b)..QuestName.."|r"
			end
		end
	end
end

ElvUF.Tags.Events["quest:info"] = "QUEST_LOG_UPDATE"
ElvUF.Tags.Methods["quest:info"] = function(unit)
	if UnitIsPlayer(unit) then return end

	E.ScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	E.ScanTooltip:SetUnit(unit)
	E.ScanTooltip:Show()

	local ObjectiveCount = 0
	local QuestName

	if E.ScanTooltip:NumLines() >= 3 then
		for i = 3, E.ScanTooltip:NumLines() do
			local QuestLine = _G["ElvUI_ScanTooltipTextLeft"..i]
			local QuestLineText = QuestLine and QuestLine:GetText()
			local PlayerName, ProgressText = strmatch(QuestLineText, "^ ([^ ]-) ?%- (.+)$")

			if (not PlayerName or PlayerName == "" or PlayerName == UnitName("player")) and ProgressText then
				local x, y

				if not QuestName and ProgressText then
					QuestName = _G["ElvUI_ScanTooltipTextLeft"..i - 1]:GetText()
				end

				if ProgressText then
					x, y = strmatch(ProgressText, "(%d+)/(%d+)")
					if x and y then
						local NumLeft = y - x

						if NumLeft > ObjectiveCount then -- track highest number of objectives
							ObjectiveCount = NumLeft
							if ProgressText then
								return ProgressText
							end
						end
					else
						if ProgressText then
							return QuestName..": "..ProgressText
						end
					end
				end
			end
		end
	end
end

local highestVersion = E.version
ElvUF.Tags.OnUpdateThrottle["ElvUI-Users"] = 20
ElvUF.Tags.Methods["ElvUI-Users"] = function(unit)
	if E.UserList and next(E.UserList) then
		local name, realm = UnitName(unit)

		if name then
			local nameRealm = (realm and realm ~= "" and format("%s-%s", name, realm)) or name
			local userVersion = nameRealm and E.UserList[nameRealm]
			if userVersion then
				if highestVersion < userVersion then
					highestVersion = userVersion
				end
				return (userVersion < highestVersion) and "|cffFF3333E|r" or "|cff3366ffE|r"
			end
		end
	end

	return ""
end

E.TagInfo = {
	--Colors
	["namecolor"] = {category = "Colors", description = "Colors Names by Player Class / NPC Reaction"},
	["reactioncolor"] = {category = "Colors", description = "Colors Names NPC Reaction (Bad/Neutral/Good)"},
	["powercolor"] = {category = "Colors", description = "Colors Unit Power based upon its type"},
	["happiness:color"] = {category = "Colors", description = "Colors the following tags based upon pet happiness (e.g. 'Happy = green')"},
	["difficultycolor"] = {category = "Colors", description = "Colors the difficulty, red for impossible, orange for hard, green for easy"},
	["altpowercolor"] = {category = "Colors", description = "Changes text to the current alternative power color (Blizzard defined)"},
	["healthcolor"] = {category = "Colors", description = "Changes color of health, depending on the unit's current health"},
	["threatcolor"] = {category = "Colors", description = "Changes color of health, depending on the unit's threat situation"},
	["classpowercolor"] = {category = "Colors", description = "Changes the color of the special power based upon its type"},
	["classificationcolor"] = {category = "Colors", description = "Changes color of health, depending on the unit's classification"},
	--Classification
	["classification"] = {category = "Classification", description = "Show the Unit Classification (e.g. 'ELITE' and 'RARE')"},
	["shortclassification"] = {category = "Classification", description = "Show the Unit Classification in short form (e.g. '+' for ELITE and 'R' for RARE)"},
	["classification:icon"] = {category = "Classification", description = "Show the Unit Classification in icon form (Gold for 'ELITE' Silver for 'RARE')"},
	["rare"] = {category = "Miscellanous", description = "Shows 'Rare' when the unit is a rare or rare elite"},
	--Guild
	["guild"] = {category = "Guild", description = "Guild Name"},
	["guild:brackets"] = {category = "Guild", description = "Guild name with < > (e.g. <MY GUILD>)"},
	["guild:brackets:translit"] = {category = "Guild", description = "Guild name with < > and transliteration (e.g. <MY GUILD>)"},
	["guild:rank"] = {category = "Guild", description = "Guild Rank"},
	["guild:translit"] = {category = "Guild", description = "Guild Name with transliteration for cyrillic letters"},
	--Health
	["curhp"] = {category = "Health", description = "Display current HP without decimals"},
	["perhp"] = {category = "Health", description = "Display percentage HP without decimals"},
	["maxhp"] = {category = "Health", description = "Display max HP without decimals"},
	["deficit:name"] = {category = "Health", description = "Shows the health as a deficit, and the name at full health"},
	["health:current"] = {category = "Health", description = "Shows the unit's current health"},
	["health:current-max"] = {category = "Health", description = "Shows the unit's current and maximum health, separated by a dash"},
	["health:current-max-nostatus"] = {category = "Health", description = "Shows the unit's current and maximum health, separated by a dash (without dead/offline status)"},
	["health:current-max-nostatus:shortvalue"] = {category = "Health", description = "Shortvalue of the unit's current and max health, without status"},
	["health:current-max-percent"] = {category = "Health", description = "Shows the current and max hp, separated by a dash (% when not full hp)"},
	["health:current-max-percent-nostatus"] = {category = "Health", description = "Shows the current and max hp, separated by a dash (% when not full hp), without status"},
	["health:current-max-percent-nostatus:shortvalue"] = {category = "Health", description = "Shortvalue of current and max hp (% when not full hp, without status)"},
	["health:current-max-percent:shortvalue"] = {category = "Health", description = "Shortvalue of current and max hp (%when not full hp)"},
	["health:current-max:shortvalue"] = {category = "Health", description = "Shortvalue of the unit's current and max hp, separated by a dash"},
	["health:current-nostatus"] = {category = "Health", description = "Shows the unit's current health without dead/offline status"},
	["health:current-nostatus:shortvalue"] = {category = "Health", description = "Shortvalue of the unit's current health without dead/offline status"},
	["health:current-percent"] = {category = "Health", description = "Shows the unit's current hp (% when not full hp)"},
	["health:current-percent-nostatus"] = {category = "Health", description = "Shows the unit's current hp (% when not full hp) without dead/offline status"},
	["health:current-percent-nostatus:shortvalue"] = {category = "Health", description = "Shortvalue of the unit's current hp (% when not full hp) without status"},
	["health:current-percent:shortvalue"] = {category = "Health", description = "Shortvalue of the unit's current hp (% when not full hp)"},
	["health:current:shortvalue"] = {category = "Health", description = "Shortvalue of the unit's current health (e.g. 8k instead of 8041)"},
	["health:deficit"] = {category = "Health", description = "Shows the health as a deficit (Total Health - Current Health = -Deficit)"},
	["health:deficit-nostatus"] = {category = "Health", description = "Shows the health as a deficit without status (dead, offline)"},
	["health:deficit-nostatus:shortvalue"] = {category = "Health", description = "Shortvalue of the health deficit without status (dead, offline)"},
	["health:deficit-percent:name"] = {category = "Health", description = "Health deficit as a percent and the full name"},
	["health:deficit-percent:name-long"] = {category = "Health", description = "Health deficit as a percent and the name (limited to 20 letters)"},
	["health:deficit-percent:name-medium"] = {category = "Health", description = "Health deficit as a percent and the name (limited to 15 letters)"},
	["health:deficit-percent:name-short"] = {category = "Health", description = "Health deficit as a percent and the name (limited to 10 letters)"},
	["health:deficit-percent:name-veryshort"] = {category = "Health", description = "Health deficit as a percent and the name (limited to 5 letters)"},
	["health:deficit:shortvalue"] = {category = "Health", description = "Shortvalue of the health deficit (e.g. 4k instead of 4035)"},
	["health:max"] = {category = "Health", description = "Shows the unit's maximum health"},
	["health:max:shortvalue"] = {category = "Health", description = "Shortvalue of the unit's maximum health"},
	["health:percent"] = {category = "Health", description = "Always shows the unit's current health as a percent"},
	["health:percent-nostatus"] = {category = "Health", description = "Unit's current health as a percent without status (dead, offline)"},
	["health:percent-with-absorbs"] = {category = "Health", description = "Unit's current health as a percent with absorb values"},
	["missinghp"] = {category = "Health", description = "Shows the missing health of the unit in whole numbers when not at full health"},
	["incomingheals"] = {category = "Health", description = "Show all incoming heals"},
	["incomingheals:personal"] = {category = "Health", description = "Show only personal incoming heals"},
	["incomingheals:others"] = {category = "Health", description = "Show only incoming heals from other units"},
	--Level
	["smartlevel"] = {category = "Level", description = "Displays the level and adds a '+' for ELITE / a 'BOSS' for Worldboss"},
	["level"] = {category = "Level", description = "Display the level"},
	--Mana
	["mana:current"] = {category = "Mana", description = "Shows the current amount of Mana a unit has"},
	["mana:current:shortvalue"] = {category = "Mana", description = "Shortvalue of the current amount of Mana a unit has (e.g. 4k instead of 4000)"},
	["mana:current-percent"] = {category = "Mana", description = "Shows the current Mana and power as a percent, separated by a dash"},
	["mana:current-percent:shortvalue"] = {category = "Mana", description = "Shortvalue of the current Mana and Mana as a percent, separated by a dash"},
	["mana:current-max"] = {category = "Mana", description = "Shows the current Mana and max Mana, separated by a dash"},
	["mana:current-max:shortvalue"] = {category = "Mana", description = "Shortvalue of the current Mana and max Mana, separated by a dash"},
	["mana:current-max-percent"] = {category = "Mana", description = "Shows the current Mana and max Mana, separated by a dash (% when not full power)"},
	["mana:current-max-percent:shortvalue"] = {category = "Mana", description = "Shortvalue of the current Mana and max Mana, separated by a dash (% when not full power)"},
	["mana:percent"] = {category = "Mana", description = "Displays the Unit Mana as a percentage value"},
	["mana:max"] = {category = "Mana", description = "Shows the unit's maximum Mana"},
	["mana:max:shortvalue"] = {category = "Mana", description = "Shortvalue of the unit's maximum Mana"},
	["mana:deficit"] = {category = "Mana", description = "Shows the power as a deficit (Total Mana - Current Mana = -Deficit)"},
	["mana:deficit:shortvalue"] = {category = "Mana", description = "Shortvalue of the mana as a deficit (Total Mana - Current Mana = -Deficit)"},
	["curmana"] = {category = "Mana", description = "Display current Mana without decimals"},
	["maxmana"] = {category = "Mana", description = "Displays the max amount of mana the unit can have"},
	--Names
	["name"] = {category = "Names", description = "Shows the full Unit Name without any letter limitation"},
	["name:veryshort"] = {category = "Names", description = "Shows the Unit Name (limited to 5 letters)"},
	["name:short"] = {category = "Names", description = "Shows the Unit Name (limited to 10 letters)"},
	["name:medium"] = {category = "Names", description = "Shows the Unit Name (limited to 15 letters)"},
	["name:long"] = {category = "Names", description = "Shows the Unit Name (limited to 20 letters)"},
	["name:veryshort:translit"] = {category = "Names", description = "Shows the Unit Name with transliteration for cyrillic letters (limited to 5 letters)"},
	["name:short:translit"] = {category = "Names", description = "Shows the Unit Name with transliteration for cyrillic letters (limited to 10 letters)"},
	["name:medium:translit"] = {category = "Names", description = "Shows the Unit Name with transliteration for cyrillic letters (limited to 15 letters)"},
	["name:long:translit"] = {category = "Names", description = "Shows the Unit Name with transliteration for cyrillic letters (limited to 20 letters)"},
	["name:abbrev"] = {category = "Names", description = "Shows the Unit Name with Abbreviation (e.g. 'Shadowfury Witch Doctor' becomes 'S. W. Doctor')"},
	["name:abbrev:veryshort"] = {category = "Names", description = "Shows the Unit Name with Abbreviation (limited to 5 letters)"},
	["name:abbrev:short"] = {category = "Names", description = "Shows the Unit Name with Abbreviation (limited to 10 letters)"},
	["name:abbrev:medium"] = {category = "Names", description = "Shows the Unit Name with Abbreviation (limited to 15 letters)"},
	["name:abbrev:long"] = {category = "Names", description = "Shows the Unit Name with Abbreviation (limited to 20 letters)"},
	["name:veryshort:status"] = {category = "Names", description = "Replaces the Unit Name 'DEAD' or 'OFFLINE' (limited to 5 letters)"},
	["name:short:status"] = {category = "Names", description = "Replaces the Unit Name 'DEAD' or 'OFFLINE' (limited to 10 letters)"},
	["name:medium:status"] = {category = "Names", description = "Replaces the Unit Name 'DEAD' or 'OFFLINE' (limited to 15 letters)"},
	["name:long:status"] = {category = "Names", description = "Replaces the Unit Name with 'DEAD' or 'OFFLINE' (limited to 20 letters)"},
	["name:title"] = {category = "Names", description = "Displays Player Name and Title"},
	["npctitle"] = {category = "Names", description = "Displays the NPC title (e.g. <General Goods Vendor>)"},
	--Party and Raid
	["group"] = {category = "Party and Raid", description = "Shows the group number the unit is in ('1' - '8')"},
	["leader"] = {category = "Party and Raid", description = "Shows 'L' if the unit is the group leader"},
	["leaderlong"] = {category = "Party and Raid", description = "Shows 'Leader' if the unit is the group leader"},
	--Power
	["runes"] = {category = "Power", description = "Displays the Runes (Death Knight)"},
	["soulshards"] = {category = "Power", description = "Displays the Soulshards (Warlock)"},
	["holypower"] = {category = "Power", description = "Displays the Holy Power (Paladin)"},
	["power:current"] = {category = "Power", description = "Shows the current amount of power a unit has"},
	["power:current:shortvalue"] = {category = "Power", description = "Shortvalue of the current amount of power a unit has (e.g. 4k instead of 4000)"},
	["power:current-percent"] = {category = "Power", description = "Shows the current power and power as a percent, separated by a dash"},
	["power:current-percent:shortvalue"] = {category = "Power", description = "Shortvalue of the current power and power as a percent, separated by a dash"},
	["power:current-max"] = {category = "Power", description = "Shows the current power and max power, separated by a dash"},
	["power:current-max:shortvalue"] = {category = "Power", description = "Shortvalue of the current power and max power, separated by a dash"},
	["power:current-max-percent"] = {category = "Power", description = "Shows the current power and max power, separated by a dash (% when not full power)"},
	["power:current-max-percent:shortvalue"] = {category = "Power", description = "Shortvalue of the current power and max power, separated by a dash (% when not full power)"},
	["power:percent"] = {category = "Power", description = "Displays the Unit Power as a percentage value"},
	["power:max"] = {category = "Power", description = "Shows the unit's maximum power"},
	["power:max:shortvalue"] = {category = "Power", description = "Shortvalue of the unit's maximum power"},
	["power:deficit"] = {category = "Power", description = "Shows the power as a deficit (Total Power - Current Power = -Deficit)"},
	["power:deficit:shortvalue"] = {category = "Power", description = "Shortvalue of the power as a deficit (Total Power - Current Power = -Deficit)"},
	["curpp"] = {category = "Power", description = "Display current Power without decimals"},
	["perpp"] = {category = "Power", description = "Display percentage Power without decimals "},
	["maxpp"] = {category = "Power", description = "Displays the max amount of power of the unit in whole numbers with no decimals"},
	["cpoints"] = {category = "Power", description = "Displays amount of combo points the player has (only for player, shows nothing on 0)"},
	["missingpp"] = {category = "Power", description = "Shows the missing power of the unit in whole numbers when not at full power"},
	--Classpower
	["classpower:current"] = {category = "Classpower", description = "Shows the current amount of the special power a unit has"},
	["classpower:current-max"] = {category = "Classpower", description = "Shows the current special power and max special power, separated by a dash"},
	["classpower:current-max-percent"] = {category = "Classpower", description = "Shows the current special power and max special power, separated by a dash"},
	["classpower:current-percent"] = {category = "Classpower", description = "Shows the current amount of special power and current special power as a percent, separated by a dash"},
	["classpower:deficit"] = {category = "Classpower", description = "Shows the special power as a deficit (Total Class Power - Current Class Power = -Deficit)"},
	["classpower:percent"] = {category = "Classpower", description = "Shows the current amount of special power as a percent"},
	--Altpower
	["altpower:current"] = {category = "Altpower", description = "Returns altpower text on a unit in current format"},
	["altpower:current-max"] = {category = "Altpower", description = "Returns altpower text on a unit in current-max format"},
	["altpower:current-max-percent"] = {category = "Altpower", description = "Returns altpower text on a unit in current-max-percent format"},
	["altpower:current-percent"] = {category = "Altpower", description = "Returns altpower text on a unit in current-max format"},
	["altpower:deficit"] = {category = "Altpower", description = "Returns altpower text on a unit in deficit format"},
	["altpower:percent"] = {category = "Altpower", description = "Returns altpower text on a unit in percent format"},
	--Quest
	["quest:info"] = {category = "Quest", description = "Shows the Quest Objectives"},
	["quest:title"] = {category = "Quest", description = "Shows the Quest Title"},
	--Realm
	["realm"] = {category = "Realm", description = "Shows the Server Name"},
	["realm:translit"] = {category = "Realm", description = "Shows the Server Name with transliteration for cyrillic letters"},
	["realm:dash"] = {category = "Realm", description = "Shows the Server Name with a dash in front (e.g. -Realm)"},
	["realm:dash:translit"] = {category = "Realm", description = "Shows the Server with transliteration for cyrillic letters and a dash in front"},
	--Status
	["status"] = {category = "Status", description = "Show Zzz(inactive), dead, ghost, offline"},
	["status:icon"] = {category = "Status", description = "Show AFK/DND as an orange(afk) / red(dnd) icon"},
	["status:text"] = {category = "Status", description = "Show <AFK> and <DND>"},
	["statustimer"] = {category = "Status", description = "Show a timer for how long a unit has had that status (e.g 'DEAD - 0:34')"},
	["afk"] = {category = "Status", description = "Show <AFK> if the Unit is afk"},
	["dead"] = {category = "Status", description = "Show <DEAD> if the Unit is dead"},
	["resting"] = {category = "Status", description = "Show zzz if the Unit is dead"},
	["pvp"] = {category = "Status", description = "Show PvP if the Unit is pvp flagged"},
	["offline"] = {category = "Status", description = "Show OFFLINE if the Unit is disconnected"},
	["ElvUI-Users"] = {category = "Status", description = "Displays current ElvUI users."},
	--Target
	["target"] = {category = "Target", description = "Displays the current target of the Unit"},
	["target:veryshort"] = {category = "Target", description = "Displays the current target of the Unit (limited to 5 letters)"},
	["target:short"] = {category = "Target", description = "Displays the current target of the Unit (limited to 10 letters)"},
	["target:medium"] = {category = "Target", description = "Displays the current target of the Unit (limited to 15 letters)"},
	["target:long"] = {category = "Target", description = "Displays the current target of the Unit (limited to 20 letters)"},
	["target:translit"] = {category = "Target", description = "Displays the current target of the Unit with transliteration for cyrillic letters"},
	["target:veryshort:translit"] = {category = "Target", description = "Displays the current target of the Unit with transliteration for cyrillic letters (limited to 5 letters)"},
	["target:short:translit"] = {category = "Target", description = "Displays the current target of the Unit with transliteration for cyrillic letters (limited to 10 letters)"},
	["target:medium:translit"] = {category = "Target", description = "Displays the current target of the Unit with transliteration for cyrillic letters (limited to 15 letters)"},
	["target:long:translit"] = {category = "Target", description = "Displays the current target of the Unit with transliteration for cyrillic letters (limited to 20 letters)"},
	--Threat
	["threat"] = {category = "Threat", description = "Shows the current threat"},
	["threat:percent"] = {category = "Threat", description = "Shows the current threat as a percent"},
	["threat:current"] = {category = "Threat", description = "Shows the current threat as a value"},
	--Miscellanous
	["affix"] = {category = "Miscellanous", description = "Shows low level critter mobs"},
	["smartclass"] = {category = "Miscellanous", description = "Shows the class of a unit, if that unit is a player, or will show what type of creature, if the unit is a NPC"},
	["class"] = {category = "Miscellanous", description = "Shows the class of the unit, if that unit is a player"},
	["difficulty"] = {category = "Miscellanous", description = "Changes color of the next tag based on how difficult the unit is compared to the players level"},
	["faction"] = {category = "Miscellanous", description = "Shows 'Aliance' or 'Horde'"},
	["plus"] = {category = "Miscellanous", description = "Displays the character '+' if the unit is an elite or rare-elite"},
	["arena:number"] = {category = "Miscellanous", description = "Shows the arena number 1-5"},
}

function E:AddTagInfo(tagName, category, description, order)
	if order then order = tonumber(order) + 10 end
	E.TagInfo[tagName] = {category = category or "Miscellanous", description = description or "", order = order or nil}
end