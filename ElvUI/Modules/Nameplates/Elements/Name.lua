local E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM

local format, gmatch, gsub, match = string.format, gmatch, gsub, string.match
local utf8lower, utf8sub = string.utf8lower, string.utf8sub

local UNKNOWN = UNKNOWN
local PRIEST_COLOR = RAID_CLASS_COLORS.PRIEST

local function abbrev(name)
	local letters, lastWord = "", match(name, ".+%s(.+)$")
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

function NP:Update_Name(frame, triggered)
	local db = NP.db.units[frame.UnitType].name
	if not triggered then
		if not db.enable then return end
	end

	local nameText = frame.UnitName or UNKNOWN
	frame.Name:SetText(db.abbrev and abbrev(nameText) or nameText)

	if not triggered then
		frame.Name:ClearAllPoints()
		if NP.db.units[frame.UnitType].health.enable or (NP.db.alwaysShowTargetHealth and frame.isTarget) then
			frame.Name:SetJustifyH("LEFT")
			frame.Name:SetPoint(E.InversePoints[db.position], db.parent == "Nameplate" and frame or frame[db.parent], db.position, db.xOffset, db.yOffset)
			frame.Name:SetParent(frame.Health)
		else
			frame.Name:SetJustifyH("CENTER")
			frame.Name:SetPoint("TOP", frame)
			frame.Name:SetParent(frame)
		end
	end

	local classColor, useClassColor, useReactionColor
	local colorDB = NP.db.colors
	local r, g, b = 1, 1, 1

	if frame.UnitClass then
		classColor = E:ClassColor(frame.UnitClass) or PRIEST_COLOR
		useClassColor = db and db.useClassColor
	end

	if frame.UnitReaction then
		useReactionColor = db and db.useReactionColor
	end

	if useClassColor and (frame.UnitType == "FRIENDLY_PLAYER" or frame.UnitType == "ENEMY_PLAYER") then
		if frame.UnitClass and classColor then
			r, g, b = classColor.r, classColor.g, classColor.b
		end
	elseif triggered or (not NP.db.units[frame.UnitType].health.enable and not frame.isTarget) or (useReactionColor and (frame.UnitType == "FRIENDLY_NPC" or frame.UnitType == "ENEMY_NPC")) then
		if frame.UnitReaction and frame.UnitReaction == 4 then
			r, g, b = colorDB.reactions.neutral.r, colorDB.reactions.neutral.g, colorDB.reactions.neutral.b
		elseif frame.UnitReaction and frame.UnitReaction > 4 then
			if frame.UnitType == "FRIENDLY_PLAYER" then
				r, g, b = colorDB.reactions.friendlyPlayer.r, colorDB.reactions.friendlyPlayer.g, colorDB.reactions.friendlyPlayer.b
			else
				r, g, b = colorDB.reactions.good.r, colorDB.reactions.good.g, colorDB.reactions.good.b
			end
		else
			r, g, b = colorDB.reactions.bad.r, colorDB.reactions.bad.g, colorDB.reactions.bad.b
		end
	end

	-- if for some reason the values failed just default to white
	if not (r and g and b) then
		r, g, b = 1, 1, 1
	end

	if triggered or (r ~= frame.Name.r or g ~= frame.Name.g or b ~= frame.Name.b) then
		frame.Name:SetTextColor(r, g, b)

		if not triggered then
			frame.Name.r, frame.Name.g, frame.Name.b = r, g, b
		end
	end

	if NP.db.nameColoredGlow then
		frame.Name.NameOnlyGlow:SetVertexColor(r - 0.1, g - 0.1, b - 0.1, 1)
	else
		frame.Name.NameOnlyGlow:SetVertexColor(colorDB.glowColor.r, colorDB.glowColor.g, colorDB.glowColor.b, colorDB.glowColor.a)
	end
end

function NP:Configure_Name(frame)
	local db = self.db.units[frame.UnitType].name

	frame.Name:FontTemplate(LSM:Fetch("font", db.font), db.fontSize, db.fontOutline)
end

function NP:Configure_NameOnlyGlow(frame)
	frame.Name.NameOnlyGlow:ClearAllPoints()
	frame.Name.NameOnlyGlow:SetPoint("TOPLEFT", frame.IconOnlyChanged and frame.IconFrame or frame.Name, -20, 8)
	frame.Name.NameOnlyGlow:SetPoint("BOTTOMRIGHT", frame.IconOnlyChanged and frame.IconFrame or frame.Name, 20, -8)
end

function NP:Construct_Name(frame)
	local name = frame:CreateFontString(nil, "OVERLAY")
	name:SetJustifyV("BOTTOM")
	name:SetWordWrap(false)

	local g = frame:CreateTexture(nil, "BACKGROUND", nil, -5)
	g:SetTexture(E.Media.Textures.Spark)
	g:Hide()
	g:SetPoint("TOPLEFT", name, -20, 8)
	g:SetPoint("BOTTOMRIGHT", name, 20, -8)

	name.NameOnlyGlow = g

	return name
end