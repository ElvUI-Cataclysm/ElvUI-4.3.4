local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins')

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.lfguild ~= true then return end
	local checkbox = {
		"LookingForGuildPvPButton",
		"LookingForGuildWeekendsButton",
		"LookingForGuildWeekdaysButton",
		"LookingForGuildRPButton",
		"LookingForGuildRaidButton",
		"LookingForGuildQuestButton",
		"LookingForGuildDungeonButton",
	}

	-- skin checkboxes
	for _, v in pairs(checkbox) do
		S:HandleCheckBox(_G[v])
	end

	-- have to skin these checkboxes seperate for some reason o_O
	S:HandleCheckBox(LookingForGuildTankButton.checkButton)
	S:HandleCheckBox(LookingForGuildHealerButton.checkButton)
	S:HandleCheckBox(LookingForGuildDamagerButton.checkButton)

	-- skinning other frames
	LookingForGuildFrameInset:StripTextures(false)
	LookingForGuildFrame:StripTextures()
	LookingForGuildFrame:SetTemplate("Transparent")
	LookingForGuildBrowseButton_LeftSeparator:Kill()
	LookingForGuildRequestButton_RightSeparator:Kill()
	S:HandleScrollBar(LookingForGuildBrowseFrameContainerScrollBar)
	S:HandleButton(LookingForGuildBrowseButton)
	S:HandleButton(LookingForGuildRequestButton)
	S:HandleCloseButton(LookingForGuildFrameCloseButton)
	LookingForGuildCommentInputFrame:CreateBackdrop("Transparent")
	LookingForGuildCommentInputFrame:StripTextures(false)

	-- skin container buttons on browse and request page
	for i = 1, 5 do
		local b = _G["LookingForGuildBrowseFrameContainerButton"..i]
		b.selectedTex:SetTexture(1, 1, 1, 0.3)
		b:SetBackdrop(nil)
		b:SetTemplate("Transparent")
		b:StyleButton()
	end

	for i = 1, 5 do
		_G["LookingForGuildBrowseFrameContainerButton"..i.."Ring"]:SetAlpha(0)
		_G["LookingForGuildBrowseFrameContainerButton"..i.."LevelRing"]:SetAlpha(0)
		_G["LookingForGuildBrowseFrameContainerButton"..i.."TabardBorder"]:SetAlpha(0)
		_G["LookingForGuildBrowseFrameContainerButton"..i.."LevelRing"]:SetPoint("TOPLEFT", -42, 33)
	end

	for i = 1, 10 do
		local t = _G["LookingForGuildAppsFrameContainerButton"..i]
		t:SetBackdrop(nil)
		t:SetTemplate("Transparent")
		t:StyleButton()
	end

	-- skin tabs
	for i= 1, 3 do
		_G["LookingForGuildFrameTab"..i]:StripTextures()
		_G["LookingForGuildFrameTab"..i]:CreateBackdrop("Default",true)
		_G["LookingForGuildFrameTab"..i].backdrop:Point("TOPLEFT", 3, -7)
		_G["LookingForGuildFrameTab"..i].backdrop:Point("BOTTOMRIGHT", -2, -1)
	end

	GuildFinderRequestMembershipFrame:StripTextures(true)
	GuildFinderRequestMembershipFrame:SetTemplate("Transparent")
	S:HandleButton(GuildFinderRequestMembershipFrameAcceptButton)
	S:HandleButton(GuildFinderRequestMembershipFrameCancelButton)
	GuildFinderRequestMembershipFrameInputFrame:StripTextures()
	GuildFinderRequestMembershipFrameInputFrame:SetTemplate("Default")

	--Tank Icon
	LookingForGuildTankButton:StripTextures()
	LookingForGuildTankButton:CreateBackdrop("Default");
	LookingForGuildTankButton.backdrop:Point("TOPLEFT", LookingForGuildTankButton, "TOPLEFT", 3, -3)
	LookingForGuildTankButton.backdrop:Point("BOTTOMRIGHT", LookingForGuildTankButton, "BOTTOMRIGHT", -3, 3)
	LookingForGuildTankButton.icon = LookingForGuildTankButton:CreateTexture(nil, "OVERLAY");
	LookingForGuildTankButton.icon:SetTexCoord(unpack(E.TexCoords))
	LookingForGuildTankButton.icon:SetTexture('Interface\\Icons\\Ability_Defend');
	LookingForGuildTankButton.icon:SetInside(LookingForGuildTankButton.backdrop)

	--Healer Icon
	LookingForGuildHealerButton:StripTextures()
	LookingForGuildHealerButton:CreateBackdrop("Default");
	LookingForGuildHealerButton.backdrop:Point("TOPLEFT", LookingForGuildHealerButton, "TOPLEFT", 3, -3)
	LookingForGuildHealerButton.backdrop:Point("BOTTOMRIGHT", LookingForGuildHealerButton, "BOTTOMRIGHT", -3, 3)
	LookingForGuildHealerButton.icon = LookingForGuildHealerButton:CreateTexture(nil, "OVERLAY");
	LookingForGuildHealerButton.icon:SetTexCoord(unpack(E.TexCoords))
	LookingForGuildHealerButton.icon:SetTexture('Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH');
	LookingForGuildHealerButton.icon:SetInside(LookingForGuildHealerButton.backdrop)

	--Damage Icon
	LookingForGuildDamagerButton:StripTextures()
	LookingForGuildDamagerButton:CreateBackdrop("Default");
	LookingForGuildDamagerButton.backdrop:Point("TOPLEFT", LookingForGuildDamagerButton, "TOPLEFT", 3, -3)
	LookingForGuildDamagerButton.backdrop:Point("BOTTOMRIGHT", LookingForGuildDamagerButton, "BOTTOMRIGHT", -3, 3)
	LookingForGuildDamagerButton.icon = LookingForGuildDamagerButton:CreateTexture(nil, "OVERLAY");
	LookingForGuildDamagerButton.icon:SetTexCoord(unpack(E.TexCoords))
	LookingForGuildDamagerButton.icon:SetTexture('Interface\\Icons\\INV_Knife_1H_Common_B_01');
	LookingForGuildDamagerButton.icon:SetInside(LookingForGuildDamagerButton.backdrop)
end

S:RegisterSkin("Blizzard_LookingForGuildUI", LoadSkin)