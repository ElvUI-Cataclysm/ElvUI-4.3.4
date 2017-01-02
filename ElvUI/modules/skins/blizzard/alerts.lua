local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule("Skins");

local _G = _G;
local unpack, select = unpack, select;

local CreateFrame = CreateFrame;
local MAX_ACHIEVEMENT_ALERTS = MAX_ACHIEVEMENT_ALERTS;

local function LoadSkin()
	if(E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.alertframes ~= true) then return; end

	local function SkinAchievePopUp()
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G["AchievementAlertFrame"..i]

			if frame then
				frame:SetAlpha(1)
				frame.SetAlpha = E.noop
				if not frame.backdrop then
					frame:CreateBackdrop("Transparent")
					frame.backdrop:Point("TOPLEFT", _G[frame:GetName().."Background"], "TOPLEFT", -2, -6)
					frame.backdrop:Point("BOTTOMRIGHT", _G[frame:GetName().."Background"], "BOTTOMRIGHT", -2, 6)
				end

				-- Background
				_G["AchievementAlertFrame"..i.."Background"]:SetTexture(nil)
				_G["AchievementAlertFrame"..i.."Glow"]:Kill()
				_G["AchievementAlertFrame"..i.."Shine"]:Kill()

				-- Text
				_G["AchievementAlertFrame"..i.."Unlocked"]:FontTemplate(nil, 12)
				_G["AchievementAlertFrame"..i.."Unlocked"]:SetTextColor(1, 1, 1)
				_G["AchievementAlertFrame"..i.."Name"]:FontTemplate(nil, 12)

				-- Icon
				_G["AchievementAlertFrame"..i.."IconTexture"]:SetTexCoord(0.08, 0.92, 0.08, 0.92)
				_G["AchievementAlertFrame"..i.."IconOverlay"]:Kill()
				_G["AchievementAlertFrame"..i.."IconTexture"]:ClearAllPoints()
				_G["AchievementAlertFrame"..i.."IconTexture"]:Point("LEFT", frame, 7, 0)

				if not _G["AchievementAlertFrame"..i.."IconTexture"].b then
					_G["AchievementAlertFrame"..i.."IconTexture"].b = CreateFrame("Frame", nil, _G["AchievementAlertFrame"..i])
					_G["AchievementAlertFrame"..i.."IconTexture"].b:SetFrameLevel(0)
					_G["AchievementAlertFrame"..i.."IconTexture"].b:SetTemplate("Transparent")
					_G["AchievementAlertFrame"..i.."IconTexture"].b:Point("TOPLEFT", _G["AchievementAlertFrame"..i.."IconTexture"], "TOPLEFT", -2, 2)
					_G["AchievementAlertFrame"..i.."IconTexture"].b:Point("BOTTOMRIGHT", _G["AchievementAlertFrame"..i.."IconTexture"], "BOTTOMRIGHT", 2, -2)
				end
			end
		end
	end
	hooksecurefunc("AchievementAlertFrame_FixAnchors", SkinAchievePopUp)

	function SkinDungeonPopUP()
		for i = 1, DUNGEON_COMPLETION_MAX_REWARDS do
			local frame = _G["DungeonCompletionAlertFrame"..i]
			local reward = _G["DungeonCompletionAlertFrame"..i.."Reward1"]
			if frame then
				frame:SetAlpha(1)
				frame.SetAlpha = E.noop
				if not frame.backdrop then
					frame:CreateBackdrop("Transparent")
					frame.backdrop:Point("TOPLEFT", frame, "TOPLEFT", -2, -6)
					frame.backdrop:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 6)
				end

				frame.shine:Kill()
				frame.glowFrame:Kill()
				frame.glowFrame.glow:Kill()
				reward:Hide()

				frame.raidArt:Kill()
				frame.dungeonArt1:Kill()
				frame.dungeonArt2:Kill()
				frame.dungeonArt3:Kill()
				frame.dungeonArt4:Kill()

				-- Icon
				frame.dungeonTexture:SetTexCoord(0.08, 0.92, 0.08, 0.92)

				frame.dungeonTexture:ClearAllPoints()
				frame.dungeonTexture:Point("LEFT", frame, 7, 0)

				if not frame.dungeonTexture.b then
					frame.dungeonTexture.b = CreateFrame("Frame", nil, frame)
					frame.dungeonTexture.b:SetFrameLevel(0)
					frame.dungeonTexture.b:SetTemplate("Transparent")
					frame.dungeonTexture.b:Point("TOPLEFT", frame.dungeonTexture, "TOPLEFT", -2, 2)
					frame.dungeonTexture.b:Point("BOTTOMRIGHT", frame.dungeonTexture, "BOTTOMRIGHT", 2, -2)
				end
			end
		end
	end

	hooksecurefunc("DungeonCompletionAlertFrame_FixAnchors", SkinDungeonPopUP)

	local function DungeonCompletionAlertFrameReward_SetReward(self)
		self:Hide()
	end
	hooksecurefunc("DungeonCompletionAlertFrameReward_SetReward", DungeonCompletionAlertFrameReward_SetReward)

	--Guild Alert
	for i=1, GuildChallengeAlertFrame:GetNumRegions() do
		local region = select(i, GuildChallengeAlertFrame:GetRegions()) 
		if region and region:GetObjectType() == "Texture" and not region:GetName() then
			region:SetTexture(nil)
		end
	end

	GuildChallengeAlertFrame:SetTemplate("Transparent", true)
	GuildChallengeAlertFrameEmblemBackground:SetVertexColor(unpack(E.media.bordercolor))
	GuildChallengeAlertFrameEmblemBackground.SetVertexColor = E.noop
	GuildChallengeAlertFrame:Height(65)
end

S:AddCallback("Alerts", LoadSkin);