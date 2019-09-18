local E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM

function NP:UpdateElement_Name(frame, triggered)
	if not triggered then
		if not NP.db.units[frame.UnitType].showName then return end
	end

	frame.Name:SetText(frame.UnitName)

	local r, g, b, classColor, useClassColor, useReactionColor
	local class = frame.UnitClass
	local reactionType = frame.UnitReaction
	if class then
		classColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
		useClassColor = NP.db.units[frame.UnitType].name and NP.db.units[frame.UnitType].name.useClassColor
	end
	if reactionType then
		useReactionColor = NP.db.units[frame.UnitType].name and NP.db.units[frame.UnitType].name.useReactionColor
	end

	if useClassColor and (frame.UnitType == "FRIENDLY_PLAYER" or frame.UnitType == "ENEMY_PLAYER") then
		if class and classColor then
			r, g, b = classColor.r, classColor.g, classColor.b
		end
	elseif useReactionColor and (frame.UnitType == "FRIENDLY_NPC" or frame.UnitType == "ENEMY_NPC") then
		if reactionType and reactionType == 4 then
			r, g, b = NP.db.reactions.neutral.r, NP.db.reactions.neutral.g, NP.db.reactions.neutral.b
		elseif reactionType and reactionType > 4 then
			r, g, b = NP.db.reactions.good.r, NP.db.reactions.good.g, NP.db.reactions.good.b
		else
			r, g, b = NP.db.reactions.bad.r, NP.db.reactions.bad.g, NP.db.reactions.bad.b
		end
	elseif triggered or (not NP.db.units[frame.UnitType].healthbar.enable and not frame.isTarget) then
		if reactionType and reactionType == 4 then
			r, g, b = NP.db.reactions.neutral.r, NP.db.reactions.neutral.g, NP.db.reactions.neutral.b
		elseif reactionType and reactionType > 4 then
			if frame.UnitType == "FRIENDLY_PLAYER" then
				r, g, b = NP.db.reactions.friendlyPlayer.r, NP.db.reactions.friendlyPlayer.g, NP.db.reactions.friendlyPlayer.b
			else
				r, g, b = NP.db.reactions.good.r, NP.db.reactions.good.g, NP.db.reactions.good.b
			end
		else
			r, g, b = NP.db.reactions.bad.r, NP.db.reactions.bad.g, NP.db.reactions.bad.b
		end
	else
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
		frame.Name.NameOnlyGlow:SetVertexColor(NP.db.glowColor.r, NP.db.glowColor.g, NP.db.glowColor.b, NP.db.glowColor.a)
	end
end

function NP:ConfigureElement_Name(frame)
	local name = frame.Name

	name:SetJustifyH("LEFT")
	name:SetJustifyV("BOTTOM")
	name:ClearAllPoints()
	if NP.db.units[frame.UnitType].healthbar.enable or (NP.db.alwaysShowTargetHealth and frame.isTarget) then
		name:SetJustifyH("LEFT")
		name:SetPoint("BOTTOMLEFT", frame.HealthBar, "TOPLEFT", 0, E.Border*2)
		name:SetPoint("BOTTOMRIGHT", frame.Level, "BOTTOMLEFT")
	else
		name:SetJustifyH("CENTER")
		name:SetPoint("TOP", frame)
	end

	name:SetFont(LSM:Fetch("font", NP.db.font), NP.db.fontSize, NP.db.fontOutline)
end

function NP:ConstructElement_Name(frame)
	local name = frame:CreateFontString(nil, "OVERLAY")
	name:SetFont(LSM:Fetch("font", NP.db.font), NP.db.fontSize, NP.db.fontOutline)
	name:SetWordWrap(false)

	local g = frame:CreateTexture(nil, "BACKGROUND", nil, -5)
	g:SetTexture(E.Media.Textures.Spark)
	g:Hide()
	g:SetPoint("TOPLEFT", name, -20, 8)
	g:SetPoint("BOTTOMRIGHT", name, 20, -8)

	name.NameOnlyGlow = g

	return name
end