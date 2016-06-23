local E, L, V, P, G = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

local format = string.format

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.guild ~= true then return end

	GuildFrame:StripTextures(true)
	GuildFrame:SetTemplate("Transparent")
	GuildLevelFrame:Kill()
	
	S:HandleCloseButton(GuildFrameCloseButton)
	
	local striptextures = {
		"GuildNewPerksFrame",
		"GuildFrameInset",
		"GuildFrameBottomInset",
		"GuildAllPerksFrame",
		"GuildMemberDetailFrame",
		"GuildMemberNoteBackground",
		"GuildInfoFrameInfo",
		"GuildLogContainer",
		"GuildLogFrame",
		"GuildRewardsFrame",
		"GuildMemberOfficerNoteBackground",
		"GuildTextEditContainer",
		"GuildTextEditFrame",
		"GuildRecruitmentRolesFrame",
		"GuildRecruitmentAvailabilityFrame",
		"GuildRecruitmentInterestFrame",
		"GuildRecruitmentLevelFrame",
		"GuildRecruitmentCommentFrame",
		"GuildRecruitmentCommentInputFrame",
		"GuildInfoFrameApplicantsContainer",
		"GuildInfoFrameApplicants",
		"GuildNewsBossModel",
		"GuildNewsBossModelTextFrame",
	}
	GuildRewardsFrameVisitText:ClearAllPoints()
	GuildRewardsFrameVisitText:SetPoint("TOP", GuildRewardsFrame, "TOP", 0, 30)
	for _, frame in pairs(striptextures) do
		_G[frame]:StripTextures()
	end

	for i=1, 7 do
		_G["GuildUpdatesButton"..i]:StyleButton()
	end

	GuildNewsBossModel:CreateBackdrop("Transparent")
	GuildNewsBossModelTextFrame:CreateBackdrop("Default")
	GuildNewsBossModelTextFrame.backdrop:Point("TOPLEFT", GuildNewsBossModel.backdrop, "BOTTOMLEFT", 0, -1)
	GuildNewsBossModel:Point("TOPLEFT", GuildFrame, "TOPRIGHT", 4, -43)
	
	GuildPerksToggleButton:StripTextures()

	local buttons = {
		"GuildPerksToggleButton",
		"GuildMemberRemoveButton",
		"GuildMemberGroupInviteButton",
		"GuildAddMemberButton",
		"GuildViewLogButton",
		"GuildControlButton",
		"GuildRecruitmentListGuildButton",
		"GuildTextEditFrameAcceptButton",
		"GuildRecruitmentInviteButton",
		"GuildRecruitmentMessageButton",
		"GuildRecruitmentDeclineButton",
	}
	
	for i, button in pairs(buttons) do
		if i == 1 then
			S:HandleButton(_G[button])
		else
			S:HandleButton(_G[button], true)
		end
	end

	local checkbuttons = {
		"Quest", 
		"Dungeon",
		"Raid",
		"PvP",
		"RP",
		"Weekdays",
		"Weekends",
		"LevelAny",
		"LevelMax",
	}
	
	for _, frame in pairs(checkbuttons) do
		S:HandleCheckBox(_G["GuildRecruitment"..frame.."Button"])
	end
	
	S:HandleCheckBox(GuildRecruitmentTankButton:GetChildren())
	S:HandleCheckBox(GuildRecruitmentHealerButton:GetChildren())
	S:HandleCheckBox(GuildRecruitmentDamagerButton:GetChildren())
	
	for i=1,5 do
		S:HandleTab(_G["GuildFrameTab"..i])
	end
	GuildXPFrame:ClearAllPoints()
	GuildXPFrame:Point("TOP", GuildFrame, "TOP", 0, -40)
	
	S:HandleScrollBar(GuildPerksContainerScrollBar, 4)
	
	GuildFactionBar:StripTextures()
	GuildFactionBar.progress:SetTexture(E["media"].normTex)
	GuildFactionBar:CreateBackdrop("Default")
	GuildFactionBar.backdrop:Point("TOPLEFT", GuildFactionBar.progress, "TOPLEFT", -2, 2)
	GuildFactionBar.backdrop:Point("BOTTOMRIGHT", GuildFactionBar, "BOTTOMRIGHT", -2, 0)
	
	GuildXPBarLeft:Kill()
	GuildXPBarRight:Kill()
	GuildXPBarMiddle:Kill()
	GuildXPBarBG:Kill()
	GuildXPBarShadow:Kill()
	GuildXPBarCap:Kill()
	GuildXPBar.progress:SetTexture(E["media"].normTex)
	GuildXPBar:CreateBackdrop("Default")
	GuildXPBar.backdrop:Point("TOPLEFT", GuildXPBar.progress, "TOPLEFT", -2, 2)
	GuildXPBar.backdrop:Point("BOTTOMRIGHT", GuildXPBar, "BOTTOMRIGHT", -2, 4)
	
	GuildLatestPerkButton:StripTextures()
	GuildLatestPerkButtonIconTexture:SetTexCoord(unpack(E.TexCoords))
	GuildLatestPerkButtonIconTexture:ClearAllPoints()
	GuildLatestPerkButtonIconTexture:Point("TOPLEFT", 2, -2)
	GuildLatestPerkButton:CreateBackdrop("Default")
	GuildLatestPerkButton.backdrop:Point("TOPLEFT", GuildLatestPerkButtonIconTexture, "TOPLEFT", -2, 2)
	GuildLatestPerkButton.backdrop:Point("BOTTOMRIGHT", GuildLatestPerkButtonIconTexture, "BOTTOMRIGHT", 2, -2)
	
	GuildNextPerkButton:StripTextures()
	GuildNextPerkButtonIconTexture:SetTexCoord(unpack(E.TexCoords))
	GuildNextPerkButtonIconTexture:ClearAllPoints()
	GuildNextPerkButtonIconTexture:Point("TOPLEFT", 2, -2)
	GuildNextPerkButton:CreateBackdrop("Default")
	GuildNextPerkButton.backdrop:Point("TOPLEFT", GuildNextPerkButtonIconTexture, "TOPLEFT", -2, 2)
	GuildNextPerkButton.backdrop:Point("BOTTOMRIGHT", GuildNextPerkButtonIconTexture, "BOTTOMRIGHT", 2, -2)
	
	--Guild Perk buttons list
	for i=1, 8 do
		local button = _G["GuildPerksContainerButton"..i]
		button:StripTextures()
		button:StyleButton()

		if button.icon then
			button.icon:SetTexCoord(unpack(E.TexCoords))
			button.icon:ClearAllPoints()
			button.icon:Point("TOPLEFT", 2, -2)
			button:CreateBackdrop("Default")
			button.backdrop:Point("TOPLEFT", button.icon, "TOPLEFT", -2, 2)
			button.backdrop:Point("BOTTOMRIGHT", button.icon, "BOTTOMRIGHT", 2, -2)
			button.icon:SetParent(button.backdrop)
		end
	end

	--Roster
	S:HandleScrollBar(GuildRosterContainerScrollBar, 5)
	S:HandleCheckBox(GuildRosterShowOfflineButton)
	
	
	for i=1, 4 do
		_G["GuildRosterColumnButton"..i]:StripTextures(true)
		_G["GuildRosterColumnButton"..i]:StyleButton()
	end
	
	S:HandleDropDownBox(GuildRosterViewDropdown, 200)
	
	for i=1, 14 do
		S:HandleButton(_G["GuildRosterContainerButton"..i.."HeaderButton"], true)
		_G["GuildRosterContainerButton"..i]:StyleButton()
		_G["GuildRosterContainerButton"..i.."BarTexture"]:SetTexture(E["media"].normTex)
	end
	
	--Detail Frame
	GuildMemberDetailFrame:SetTemplate("Transparent")
	GuildMemberDetailFrame:Point("TOPLEFT", GuildFrame, "TOPRIGHT", 1, 0)
	GuildMemberNoteBackground:SetTemplate("Default")
	GuildMemberOfficerNoteBackground:SetTemplate("Default")
	GuildMemberRankDropdown:SetFrameLevel(GuildMemberRankDropdown:GetFrameLevel() + 5)
	S:HandleDropDownBox(GuildMemberRankDropdown, 175)
	S:HandleCloseButton(GuildMemberDetailCloseButton)
	GuildMemberDetailCloseButton:Point("TOPRIGHT", GuildMemberDetail, "TOPRIGHT", 2, 2)

	--News
	GuildNewsFrame:StripTextures()
	for i=1, 17 do
		if _G["GuildNewsContainerButton"..i] then
			_G["GuildNewsContainerButton"..i].header:Kill()
			_G["GuildNewsContainerButton"..i]:StyleButton()
		end
	end
	
	GuildNewsFiltersFrame:StripTextures()
	GuildNewsFiltersFrame:SetTemplate("Transparent")
	S:HandleCloseButton(GuildNewsFiltersFrameCloseButton)
	GuildNewsContainer:SetTemplate("Transparent")
	
	GuildNewsFiltersFrameCloseButton:SetPoint("TOPRIGHT", GuildNewsFiltersFrame, "TOPRIGHT", 2, 2)

	for i=1, 7 do
		S:HandleCheckBox(_G["GuildNewsFilterButton"..i])
	end
	
	GuildNewsFiltersFrame:Point("TOPLEFT", GuildFrame, "TOPRIGHT", 4, -20)
	S:HandleScrollBar(GuildNewsContainerScrollBar, 4)
	
	--Info Frame
	S:HandleScrollBar(GuildInfoDetailsFrameScrollBar, 4)
	S:HandleScrollBar(GuildInfoFrameApplicantsContainerScrollBar)

	for i=1, 3 do
		_G["GuildInfoFrameTab"..i]:StripTextures()
		_G["GuildInfoFrameTab"..i]:CreateBackdrop("Default",true)
		_G["GuildInfoFrameTab"..i].backdrop:Point("TOPLEFT", 3, -7)
		_G["GuildInfoFrameTab"..i].backdrop:Point("BOTTOMRIGHT", -2, -1)
	end

	GuildInfoFrameTab1:SetPoint("TOPLEFT", GuildInfoFrame, "TOPLEFT", 45, 33)

	local backdrop1 = CreateFrame("Frame", nil, GuildInfoFrameInfo)
	backdrop1:SetTemplate("Default")
	backdrop1:SetFrameLevel(GuildInfoFrameInfo:GetFrameLevel() - 1)
	backdrop1:Point("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -22)
	backdrop1:Point("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 200)
	
	local backdrop2 = CreateFrame("Frame", nil, GuildInfoFrameInfo)
	backdrop2:SetTemplate("Default")
	backdrop2:SetFrameLevel(GuildInfoFrameInfo:GetFrameLevel() - 1)
	backdrop2:Point("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -158)
	backdrop2:Point("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 118)	

	local backdrop3 = CreateFrame("Frame", nil, GuildInfoFrameInfo)
	backdrop3:SetTemplate("Default")
	backdrop3:SetFrameLevel(GuildInfoFrameInfo:GetFrameLevel() - 1)
	backdrop3:Point("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -233)
	backdrop3:Point("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 3)	
	
	GuildRecruitmentCommentInputFrame:SetTemplate("Default")
	
	for _, button in next, GuildInfoFrameApplicantsContainer.buttons do
		button.selectedTex:SetTexture(1, 1, 1, 0.3)
		button:GetHighlightTexture():Kill()
		button:SetBackdrop(nil)
		button:StyleButton()
		button:SetTemplate("Transparent")
	end

	for i=1, 5 do
		_G["GuildInfoFrameApplicantsContainerButton"..i.."Ring"]:SetAlpha(0)
		_G["GuildInfoFrameApplicantsContainerButton"..i.."LevelRing"]:SetAlpha(0)
		_G["GuildInfoFrameApplicantsContainerButton"..i.."LevelRing"]:SetPoint("TOPLEFT", -42, 33)
	end


	--Text Edit Frame
	GuildTextEditFrame:SetTemplate("Transparent")
	S:HandleScrollBar(GuildTextEditScrollFrameScrollBar, 5)
	GuildTextEditContainer:SetTemplate("Default")
	for i=1, GuildTextEditFrame:GetNumChildren() do
		local child = select(i, GuildTextEditFrame:GetChildren())
		if child:GetName() == "GuildTextEditFrameCloseButton" and child:GetWidth() < 33 then
			S:HandleCloseButton(child)
		elseif child:GetName() == "GuildTextEditFrameCloseButton" then
			S:HandleButton(child, true)
		end
	end
	
	--Guild Log
	S:HandleScrollBar(GuildLogScrollFrameScrollBar, 4)
	GuildLogFrame:SetTemplate("Transparent")
	GuildLogScrollFrame:SetTemplate("Transparent")

	--Blizzard has two buttons with the same name, this is a fucked up way of determining that it isn't the other button
	for i=1, GuildLogFrame:GetNumChildren() do
		local child = select(i, GuildLogFrame:GetChildren())
		if child:GetName() == "GuildLogFrameCloseButton" and child:GetWidth() < 33 then
			S:HandleCloseButton(child)
		elseif child:GetName() == "GuildLogFrameCloseButton" then
			S:HandleButton(child, true)
		end
	end
	
	--Rewards
	S:HandleScrollBar(GuildRewardsContainerScrollBar, 5)
	
	for i=1, 8 do
		local button = _G["GuildRewardsContainerButton"..i]
		button:StripTextures()
		button:SetTemplate("Default",true)
		button:StyleButton()
		if button.icon then
			button.icon:SetTexCoord(unpack(E.TexCoords))
			button.icon:ClearAllPoints()
			button.icon:Point("TOPLEFT", 2, -3)
			button.icon:Size(41, 41)
			button:CreateBackdrop("Default")
			button.backdrop:Point("TOPLEFT", button.icon, "TOPLEFT", -2, 2)
			button.backdrop:Point("BOTTOMRIGHT", button.icon, "BOTTOMRIGHT", 2, -2)
			button.icon:SetParent(button.backdrop)
		end
	end
end

S:RegisterSkin("Blizzard_GuildUI", LoadSkin)