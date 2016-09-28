local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins')

local _G = _G
local unpack, pairs = unpack, pairs
local find = string.find;

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.lfd ~= true then return end

	local StripAllTextures = {
		"LFDParentFrame",
		"LFDQueueFrame",
		"LFDQueueFrameSpecific",
		"LFDQueueFrameRandom",
		"LFDQueueFrameRandomScrollFrame",
		"LFDQueueFrameCapBar"
	}
	tinsert(StripAllTextures, 'LFGDungeonReadyDialog')

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end

	local KillTextures = {
		"LFDQueueFrameBackground",
		"LFDParentFrameInset",
		"LFDParentFrameEyeFrame",
		"LFDQueueFrameRoleButtonTankBackground",
		"LFDQueueFrameRoleButtonHealerBackground",
		"LFDQueueFrameRoleButtonDPSBackground"
	}

	for _, texture in pairs(KillTextures) do
		_G[texture]:Kill()
	end

	local buttons = {
		"LFDQueueFrameFindGroupButton",
		"LFDQueueFrameCancelButton",
		"LFDQueueFramePartyBackfillBackfillButton",
		"LFDQueueFramePartyBackfillNoBackfillButton",
		"LFDQueueFrameNoLFDWhileLFRLeaveQueueButton"
	}

	for i = 1, #buttons do
		_G[buttons[i]]:StripTextures()
		S:HandleButton(_G[buttons[i]])
	end

	local checkButtons = {
		"LFDQueueFrameRoleButtonTank",
		"LFDQueueFrameRoleButtonHealer",
		"LFDQueueFrameRoleButtonDPS",
		"LFDQueueFrameRoleButtonLeader"
	}

	for _, object in pairs(checkButtons) do
		_G[object].checkButton:SetFrameLevel(_G[object].checkButton:GetFrameLevel() + 2)
		S:HandleCheckBox(_G[object].checkButton)
	end

	LFDParentFrame:SetTemplate("Transparent")

	LFDQueueFrameSpecificListScrollFrame:StripTextures()
	LFDQueueFrameSpecificListScrollFrame:Height(LFDQueueFrameSpecificListScrollFrame:GetHeight() - 8)

	S:HandleScrollBar(LFDQueueFrameSpecificListScrollFrameScrollBar)

	S:HandleDropDownBox(LFDQueueFrameTypeDropDown, 300)
	LFDQueueFrameTypeDropDown:Point("RIGHT",-10,0)

	LFDQueueFrameCapBar:SetPoint("LEFT", 40, 0)
	LFDQueueFrameCapBar:CreateBackdrop("Default")
	LFDQueueFrameCapBar.backdrop:Point("TOPLEFT", LFDQueueFrameCapBar, "TOPLEFT", -1, -1)
	LFDQueueFrameCapBar.backdrop:Point("BOTTOMRIGHT", LFDQueueFrameCapBar, "BOTTOMRIGHT", 0, 1 )

	LFDQueueFrameCapBarProgress:SetTexture(E["media"].normTex)
	LFDQueueFrameCapBarCap1Marker:Kill()
	LFDQueueFrameCapBarCap1:SetTexture(E["media"].normTex)
	LFDQueueFrameCapBarCap2Marker:Kill()
	LFDQueueFrameCapBarCap2:SetTexture(E["media"].normTex)

	LFGDungeonReadyDialogBackground:Kill()
	S:HandleButton(LFGDungeonReadyDialogEnterDungeonButton)
	S:HandleButton(LFGDungeonReadyDialogLeaveQueueButton)

	LFGDungeonReadyDialog:SetTemplate("Transparent")
	LFGDungeonReadyDialog.SetBackdrop = E.noop
	LFGDungeonReadyDialog.filigree:SetAlpha(0)
	LFGDungeonReadyDialog.bottomArt:SetAlpha(0)

	S:HandleButton(LFGDungeonReadyDialogLeaveQueueButton)
	S:HandleButton(LFGDungeonReadyDialogEnterDungeonButton)

	S:HandleCloseButton(LFDParentFrameCloseButton,LFDParentFrame)
	S:HandleCloseButton(LFGDungeonReadyStatusCloseButton)

	LFGSearchStatus:SetTemplate('Transparent');

	LFGDungeonReadyStatus:StripTextures()
	LFGDungeonReadyStatus:SetTemplate('Transparent');

	S:HandleCloseButton(LFGDungeonReadyDialogCloseButton)
	LFGDungeonReadyDialogCloseButton.text:SetText('-')
	LFGDungeonReadyDialogCloseButton.text:FontTemplate(nil, 22)

	hooksecurefunc("LFDQueueFrameRandom_UpdateFrame", function()
		local dungeonID = LFDQueueFrame.type
		if type(dungeonID) == "string" then return end
		local _, _, _, _, _, numRewards = GetLFGDungeonRewards(dungeonID)

		for i = 1, LFD_MAX_REWARDS do
			local button = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i]
			local icon = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."IconTexture"]
			local count = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."Count"]
			local role1 = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."RoleIcon1"]
			local role2 = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."RoleIcon2"]
			local role3 = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."RoleIcon3"]

			if(button) then
				local __texture = _G[button:GetName().."IconTexture"]:GetTexture()
				button:StripTextures()
				button:CreateBackdrop()
				button.backdrop:SetOutside(icon)

				icon:SetTexture(__texture)
				icon:SetTexCoord(unpack(E.TexCoords))
				icon:Point("TOPLEFT", 2, -2)
				icon:SetParent(button.backdrop)
				icon.SetPoint = E.noop

				icon:SetDrawLayer("OVERLAY")
				count:SetDrawLayer("OVERLAY")

				if(count) then count:SetParent(button.backdrop) end
				if(role1) then role1:SetParent(button.backdrop) end
				if(role2) then role2:SetParent(button.backdrop) end
				if(role3) then role3:SetParent(button.backdrop) end

				button:HookScript("OnUpdate", function(self)
					if(button.dungeonID) then
						local Link = GetLFGDungeonRewardLink(button.dungeonID, i)
						if(Link) then
							local quality = select(3, GetItemInfo(Link))
							if(quality and quality > 1) then
								button.backdrop:SetBackdropBorderColor(GetItemQualityColor(quality));
							else
								button.backdrop:SetBackdropBorderColor(unpack(E["media"].bordercolor));
							end
						end
					end
				end)
			end
		end
	end)

	local function SkinIcons()
		for i = 1, LFG_ROLE_NUM_SHORTAGE_TYPES do
			if _G['LFGDungeonReadyDialogRewardsFrameReward'..i] and not _G['LFGDungeonReadyDialogRewardsFrameReward'..i].IsDone then
				_G['LFGDungeonReadyDialogRewardsFrameReward'..i..'Border']:Kill()
				_G['LFGDungeonReadyDialogRewardsFrameReward'..i]:CreateBackdrop()
				_G['LFGDungeonReadyDialogRewardsFrameReward'..i].backdrop:Point("TOPLEFT", 7, -7)
				_G['LFGDungeonReadyDialogRewardsFrameReward'..i].backdrop:Point("BOTTOMRIGHT", -7, 7)
				_G['LFGDungeonReadyDialogRewardsFrameReward'..i..'Texture']:SetTexCoord(unpack(E.TexCoords))
				_G['LFGDungeonReadyDialogRewardsFrameReward'..i..'Texture']:SetInside(_G['LFGDungeonReadyDialogRewardsFrameReward'..i].backdrop)
				_G['LFGDungeonReadyDialogRewardsFrameReward'..i].IsDone = true
			end
		end
	end
	hooksecurefunc('LFGDungeonReadyDialog_UpdateRewards', SkinIcons)

	for i = 1, NUM_LFD_CHOICE_BUTTONS do
		local button = _G["LFDQueueFrameSpecificListButton" .. i];
		button.enableButton:StripTextures();
		button.enableButton:CreateBackdrop("Default");
		button.enableButton.backdrop:SetInside(nil, 4, 4);

		button.expandOrCollapseButton:SetNormalTexture("Interface\\Buttons\\UI-PlusMinus-Buttons");
		button.expandOrCollapseButton.SetNormalTexture = E.noop;
		button.expandOrCollapseButton:SetHighlightTexture(nil);
		button.expandOrCollapseButton:GetNormalTexture():Size(12)
		button.expandOrCollapseButton:GetNormalTexture():Point("CENTER", 4, 0);

		hooksecurefunc(button.expandOrCollapseButton, "SetNormalTexture", function(self, texture)
			if(find(texture, "MinusButton")) then
				self:GetNormalTexture():SetTexCoord(0.5625, 1, 0, 0.4375)
			else
				self:GetNormalTexture():SetTexCoord(0, 0.4375, 0, 0.4375)
			end
		end);
 	end
end

S:AddCallback("LFD", LoadSkin);