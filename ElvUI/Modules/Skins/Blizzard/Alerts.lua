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
			frame:CreateBackdrop("Transparent")
			frame.backdrop:Point("TOPLEFT", frame, "TOPLEFT", -2, -6)
			frame.backdrop:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 6)

			_G[name.."Background"]:Kill()
			_G[name.."Glow"]:Kill()
			_G[name.."Shine"]:Kill()
			_G[name.."GuildBanner"]:Kill()
			_G[name.."GuildBorder"]:Kill()
			_G[name.."IconOverlay"]:Kill()

			_G[name.."Unlocked"]:SetTextColor(1, 1, 1)

			_G[name.."IconTexture"]:ClearAllPoints()
			_G[name.."IconTexture"]:Point("LEFT", frame, 7, 0)
			_G[name.."IconTexture"]:SetTexCoord(unpack(E.TexCoords))
			_G[name.."IconTexture"].backdrop = CreateFrame("Frame", nil, frame)
			_G[name.."IconTexture"].backdrop:SetTemplate("Default")
			_G[name.."IconTexture"].backdrop:SetOutside(_G[name.."IconTexture"])

			frame.isSkinned = true

			if tonumber(name:match(".+(%d+)")) == MAX_ACHIEVEMENT_ALERTS then
				S:Unhook("AchievementAlertFrame_GetAlertFrame")
			end
		end
		return frame
	end, true)

	-- Dungeon Completion Alerts
	local frame = DungeonCompletionAlertFrame1
	frame:DisableDrawLayer("BORDER")
	frame:DisableDrawLayer("OVERLAY")

	frame:CreateBackdrop("Transparent")
	frame.backdrop:Point("TOPLEFT", frame, "TOPLEFT", -2, -6)
	frame.backdrop:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 6)

	frame.shine:Kill()
	frame.glowFrame:Kill()
	frame.glowFrame:DisableDrawLayer("OVERLAY")
	frame.glowFrame.glow:Kill()
	frame.heroicIcon:Hide()

	frame.raidArt:Kill()
	frame.dungeonArt1:Kill()
	frame.dungeonArt2:Kill()
	frame.dungeonArt3:Kill()
	frame.dungeonArt4:Kill()

	frame.dungeonTexture:ClearAllPoints()
	frame.dungeonTexture:Point("LEFT", frame.backdrop, 9, 0)
	frame.dungeonTexture:SetTexCoord(unpack(E.TexCoords))

	frame.dungeonTexture.backdrop = CreateFrame("Frame", "$parentDungeonTextureBackground", frame)
	frame.dungeonTexture.backdrop:SetTemplate("Default")
	frame.dungeonTexture.backdrop:SetOutside(frame.dungeonTexture)
	frame.dungeonTexture.backdrop:SetFrameLevel(0)

	DungeonCompletionAlertFrame1Reward1:Hide()

	local function DungeonCompletionAlertFrameReward_SetReward(self)
		self:Hide()
	end
	hooksecurefunc("DungeonCompletionAlertFrameReward_SetReward", DungeonCompletionAlertFrameReward_SetReward)

	-- Guild Challenge Alerts
	GuildChallengeAlertFrame:CreateBackdrop("Transparent")
	GuildChallengeAlertFrame.backdrop:SetPoint("TOPLEFT", GuildChallengeAlertFrame, "TOPLEFT", -2, -6)
	GuildChallengeAlertFrame.backdrop:SetPoint("BOTTOMRIGHT", GuildChallengeAlertFrame, "BOTTOMRIGHT", -2, 6)

	for i = 1, GuildChallengeAlertFrame:GetNumRegions() do
		local region = select(i, GuildChallengeAlertFrame:GetRegions()) 
		if region and region:IsObjectType("Texture") and not region:GetName() then
			region:SetTexture(nil)
		end
	end

	GuildChallengeAlertFrameEmblemBorder:Kill()
	GuildChallengeAlertFrameGlow:Kill()
	GuildChallengeAlertFrameShine:Kill()

	GuildChallengeAlertFrameEmblemIcon.backdrop = CreateFrame("Frame", nil, GuildChallengeAlertFrame)
	GuildChallengeAlertFrameEmblemIcon.backdrop:SetTemplate("Default")
	GuildChallengeAlertFrameEmblemIcon.backdrop:SetPoint("TOPLEFT", GuildChallengeAlertFrameEmblemIcon, "TOPLEFT", -2, 2)
	GuildChallengeAlertFrameEmblemIcon.backdrop:SetPoint("BOTTOMRIGHT",GuildChallengeAlertFrameEmblemIcon, "BOTTOMRIGHT", 2, -2)
	GuildChallengeAlertFrameEmblemIcon.backdrop:SetFrameLevel(0)
end

S:AddCallback("Alerts", LoadSkin)