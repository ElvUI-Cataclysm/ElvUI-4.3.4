local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local unpack, select = unpack, select
local tonumber = tonumber

local CreateFrame = CreateFrame

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.alertframes then return end

	-- Achievement Alerts
	S:RawHook("AchievementAlertFrame_GetAlertFrame", function()
		local frame = S.hooks.AchievementAlertFrame_GetAlertFrame()
		if frame and not frame.isSkinned then
			local name = frame:GetName()

			frame:DisableDrawLayer("OVERLAY")
			frame:SetTemplate("Transparent")
			frame:Height(66)
			frame.SetHeight = E.noop

			local icon = _G[name.."IconTexture"]
			icon:ClearAllPoints()
			icon:Point("LEFT", frame, 7, 0)
			icon:SetTexCoord(unpack(E.TexCoords))

			icon.backdrop = CreateFrame("Frame", nil, frame)
			icon.backdrop:SetTemplate()
			icon.backdrop:SetOutside(icon)

			local unlocked = _G[name.."Unlocked"]
			unlocked:ClearAllPoints()
			unlocked:Point("BOTTOM", frame, 0, 8)
			unlocked.SetPoint = E.noop
			unlocked:SetTextColor(0.973, 0.937, 0.580)

			local achievementName = _G[name.."Name"]
			achievementName:ClearAllPoints()
			achievementName:Point("LEFT", frame, 62, 3)
			achievementName:Point("RIGHT", frame, -55, 3)
			achievementName.SetPoint = E.noop

			local achievementGuildName = _G[name.."GuildName"]
			achievementGuildName:ClearAllPoints()
			achievementGuildName:Point("TOPLEFT", frame, 50, -2)
			achievementGuildName:Point("TOPRIGHT", frame, -50, -2)
			achievementGuildName.SetPoint = E.noop

			local shield = _G[name.."Shield"]
			shield:ClearAllPoints()
			shield:Point("TOPRIGHT", frame, -4, -6)
			shield.SetPoint = E.noop

			_G[name.."Background"]:Kill()
			_G[name.."GuildBanner"]:Kill()
			_G[name.."GuildBorder"]:Kill()
			_G[name.."IconOverlay"]:Kill()

			frame.isSkinned = true

			if tonumber(name:match(".+(%d+)")) == MAX_ACHIEVEMENT_ALERTS then
				S:Unhook("AchievementAlertFrame_GetAlertFrame")
			end
		end
		return frame
	end, true)

	-- Dungeon Alerts
	local function SkinRewards(frame)
		if frame.isSkinned then return end

		frame:SetTemplate()
		frame:Size(24)
		S:HandleFrameHighlight(frame, frame.backdrop)

		frame.texture:SetInside(frame.backdrop)
		frame.texture:SetTexCoord(unpack(E.TexCoords))

		_G[frame:GetName().."Border"]:Hide()

		frame.isSkinned = true
	end

	DungeonCompletionAlertFrame1:StripTextures()
	DungeonCompletionAlertFrame1:SetTemplate("Transparent")
	DungeonCompletionAlertFrame1:Size(310, 60)

	DungeonCompletionAlertFrame1.dungeonTexture:ClearAllPoints()
	DungeonCompletionAlertFrame1.dungeonTexture:Point("BOTTOMLEFT", 8, 8)
	DungeonCompletionAlertFrame1.dungeonTexture.SetPoint = E.noop

	DungeonCompletionAlertFrame1.dungeonTexture.backdrop = CreateFrame("Frame", nil, DungeonCompletionAlertFrame1)
	DungeonCompletionAlertFrame1.dungeonTexture.backdrop:SetTemplate()
	DungeonCompletionAlertFrame1.dungeonTexture.backdrop:SetOutside(DungeonCompletionAlertFrame1.dungeonTexture)

	DungeonCompletionAlertFrame1.dungeonTexture:SetTexCoord(unpack(E.TexCoords))
	DungeonCompletionAlertFrame1.dungeonTexture:Size(44)
	DungeonCompletionAlertFrame1.dungeonTexture:SetDrawLayer("ARTWORK")
	DungeonCompletionAlertFrame1.dungeonTexture:SetParent(DungeonCompletionAlertFrame1.dungeonTexture.backdrop)

	DungeonCompletionAlertFrame1.glowFrame:DisableDrawLayer("OVERLAY")

	SkinRewards(DungeonCompletionAlertFrame1Reward1)
	DungeonCompletionAlertFrame1Reward1:Point("TOPLEFT", frame, 64, 7)
	DungeonCompletionAlertFrame1Reward1.SetPoint = E.noop

	for i = 1, DungeonCompletionAlertFrame1:GetNumRegions() do
		local region = select(i, DungeonCompletionAlertFrame1:GetRegions())
		if region.IsObjectType and region:IsObjectType("FontString") and region.GetText and region:GetText() == DUNGEON_COMPLETED then
			region:Point("TOP", 20, -18)
			region:SetTextColor(0.973, 0.937, 0.580)
		end
	end

	DungeonCompletionAlertFrame1.instanceName:ClearAllPoints()
	DungeonCompletionAlertFrame1.instanceName:Point("BOTTOM", 20, 12)
	DungeonCompletionAlertFrame1.instanceName.SetPoint = E.noop
	DungeonCompletionAlertFrame1.instanceName:SetTextColor(1, 1, 1)

	DungeonCompletionAlertFrame1.heroicIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-HEROIC")

	hooksecurefunc("DungeonCompletionAlertFrameReward_SetReward", function(frame, index)
		SkinRewards(frame)

		SetPortraitToTexture(frame.texture, nil)
		frame.texture:SetTexture(GetLFGCompletionRewardItem(index))
	end)

	-- Guild Challenge Alerts
	GuildChallengeAlertFrame:StripTextures()
	GuildChallengeAlertFrame:SetTemplate("Transparent")
	GuildChallengeAlertFrame:Size(260, 64)

	GuildChallengeAlertFrameEmblemIcon.backdrop = CreateFrame("Frame", nil, GuildChallengeAlertFrame)
	GuildChallengeAlertFrameEmblemIcon.backdrop:SetTemplate()
	GuildChallengeAlertFrameEmblemIcon.backdrop:SetOutside(GuildChallengeAlertFrameEmblemIcon)

	GuildChallengeAlertFrameEmblemIcon:Size(52)
	GuildChallengeAlertFrameEmblemIcon:Point("LEFT", 6, 0)
	GuildChallengeAlertFrameEmblemIcon:SetParent(GuildChallengeAlertFrameEmblemIcon.backdrop)

	GuildChallengeAlertFrameType:Point("LEFT", 67, -10)
	GuildChallengeAlertFrameCount:Point("BOTTOMRIGHT", -7, 7)
end

S:AddCallback("Alerts", LoadSkin)