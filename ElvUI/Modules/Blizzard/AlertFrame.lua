local E, L, V, P, G = unpack(select(2, ...))
local B = E:GetModule("Blizzard")
local Misc = E:GetModule("Misc")

local _G = _G
local pairs = pairs

local NUM_GROUP_LOOT_FRAMES = NUM_GROUP_LOOT_FRAMES

local POSITION, ANCHOR_POINT, YOFFSET = "TOP", "BOTTOM", -10

function E:PostAlertMove()
	local _, y = AlertFrameMover:GetCenter()
	local screenHeight = E.UIParent:GetTop()
	local screenY = y > (screenHeight / 2)

	POSITION = screenY and "TOP" or "BOTTOM"
	ANCHOR_POINT = screenY and "BOTTOM" or "TOP"
	YOFFSET = screenY and -10 or 10

	local yOffset = screenY and -4 or 4
	local directionText = screenY and "(Grow Down)" or "(Grow Up)"
	AlertFrameMover:SetText(format("%s %s", AlertFrameMover.textString, directionText))

	if E.private.general.lootRoll then
		local lastframe, lastShownFrame

		for i, frame in pairs(Misc.RollBars) do
			local alertAnchor = i ~= 1 and lastframe or AlertFrameHolder

			frame:ClearAllPoints()
			frame:Point(POSITION, alertAnchor, ANCHOR_POINT, 0, yOffset)

			lastframe = frame

			if frame:IsShown() then
				lastShownFrame = frame
			end
		end

		AlertFrame:ClearAllPoints()
		if lastShownFrame then
			AlertFrame:SetAllPoints(lastShownFrame)
		else
			AlertFrame:SetAllPoints(AlertFrameHolder)
		end
	elseif E.private.skins.blizzard.enable and E.private.skins.blizzard.lootRoll then
		local lastframe, lastShownFrame

		for i = 1, NUM_GROUP_LOOT_FRAMES do
			local frame = _G["GroupLootFrame"..i]

			if frame then
				local alertAnchor = i ~= 1 and lastframe or AlertFrameHolder

				frame:ClearAllPoints()
				frame:Point(POSITION, alertAnchor, ANCHOR_POINT, 0, yOffset)

				lastframe = frame

				if frame:IsShown() then
					lastShownFrame = frame
				end
			end
		end

		AlertFrame:ClearAllPoints()
		if lastShownFrame then
			AlertFrame:SetAllPoints(lastShownFrame)
		else
			AlertFrame:SetAllPoints(AlertFrameHolder)
		end
	else
		AlertFrame:ClearAllPoints()
		AlertFrame:SetAllPoints(AlertFrameHolder)
	end
end

function B:AchievementAlertFrame_FixAnchors()
	local alertAnchor
	for i = 1, MAX_ACHIEVEMENT_ALERTS do
		local frame = _G["AchievementAlertFrame"..i]

		if frame then
			frame:ClearAllPoints()

			if alertAnchor and alertAnchor:IsShown() then
				frame:Point(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
			else
				frame:Point(POSITION, AlertFrame, ANCHOR_POINT)
			end

			alertAnchor = frame
		end
	end
end

function B:DungeonCompletionAlertFrame_FixAnchors()
	for i = MAX_ACHIEVEMENT_ALERTS, 1, -1 do
		local frame = _G["AchievementAlertFrame"..i]

		if frame and frame:IsShown() then
			DungeonCompletionAlertFrame1:ClearAllPoints()
			DungeonCompletionAlertFrame1:Point(POSITION, frame, ANCHOR_POINT, 0, YOFFSET)
			return
		end

		DungeonCompletionAlertFrame1:ClearAllPoints()
		DungeonCompletionAlertFrame1:Point(POSITION, AlertFrame, ANCHOR_POINT)
	end
end

function B:GuildChallengeAlertFrame_FixAnchors()
	if DungeonCompletionAlertFrame1:IsShown() then
		GuildChallengeAlertFrame:ClearAllPoints()
		GuildChallengeAlertFrame:Point(POSITION, DungeonCompletionAlertFrame1, ANCHOR_POINT, 0, YOFFSET)
		return
	end

	for i = MAX_ACHIEVEMENT_ALERTS, 1, -1 do
		local frame = _G["AchievementAlertFrame"..i]

		if frame and frame:IsShown() then
			GuildChallengeAlertFrame:ClearAllPoints()
			GuildChallengeAlertFrame:Point(POSITION, frame, ANCHOR_POINT, 0, YOFFSET)
			return
		end
	end

	GuildChallengeAlertFrame:ClearAllPoints()
	GuildChallengeAlertFrame:Point(POSITION, AlertFrame, ANCHOR_POINT)
end

function B:AlertMovers()
	local AlertFrameHolder = CreateFrame("Frame", "AlertFrameHolder", E.UIParent)
	AlertFrameHolder:Size(250, 20)
	AlertFrameHolder:Point("TOP", E.UIParent, "TOP", 0, -18)

	self:SecureHook("AlertFrame_FixAnchors", E.PostAlertMove)
	self:SecureHook("AchievementAlertFrame_FixAnchors")
	self:SecureHook("DungeonCompletionAlertFrame_FixAnchors")
	self:SecureHook("GuildChallengeAlertFrame_FixAnchors")

	E:CreateMover(AlertFrameHolder, "AlertFrameMover", L["Loot / Alert Frames"], nil, nil, E.PostAlertMove, nil, nil, "general,blizzUIImprovements")
end