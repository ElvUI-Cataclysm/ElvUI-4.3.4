local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule("Skins")

local unpack = unpack
local find = string.find;

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true then return end

	QuestInfoSkillPointFrame:StripTextures()
	QuestInfoSkillPointFrame:StyleButton()
	QuestInfoSkillPointFrame:Width(QuestInfoSkillPointFrame:GetWidth() - 7)
	QuestInfoSkillPointFrame:SetFrameLevel(QuestInfoSkillPointFrame:GetFrameLevel() + 2)
	QuestInfoSkillPointFrameIconTexture:SetTexCoord(unpack(E.TexCoords))
	QuestInfoSkillPointFrameIconTexture:SetDrawLayer("OVERLAY")
	QuestInfoSkillPointFrameIconTexture:Point("TOPLEFT", 2, -2)
	QuestInfoSkillPointFrameIconTexture:Size(QuestInfoSkillPointFrameIconTexture:GetWidth() - 2, QuestInfoSkillPointFrameIconTexture:GetHeight() - 2)
	QuestInfoSkillPointFrame:SetTemplate("Default")
	QuestInfoSkillPointFrame:CreateBackdrop()
	QuestInfoSkillPointFrame.backdrop:SetOutside(QuestInfoSkillPointFrameIconTexture)
	QuestInfoSkillPointFrameIconTexture:SetParent(QuestInfoSkillPointFrame.backdrop)
	QuestInfoSkillPointFramePoints:Point("LEFT", 42, -1)

	QuestInfoSpellObjectiveFrame:StripTextures()
	QuestInfoSpellObjectiveFrame:StyleButton()
	QuestInfoSpellObjectiveFrame:Width(QuestInfoSpellObjectiveFrame:GetWidth() - 7)
	QuestInfoSpellObjectiveFrame:Height(QuestInfoSpellObjectiveFrame:GetHeight() - 16)
	QuestInfoSpellObjectiveFrame:SetFrameLevel(QuestInfoSpellObjectiveFrame:GetFrameLevel() + 2)
	QuestInfoSpellObjectiveFrameIconTexture:SetTexCoord(unpack(E.TexCoords))
	QuestInfoSpellObjectiveFrameIconTexture:SetDrawLayer("OVERLAY")
	QuestInfoSpellObjectiveFrameIconTexture:Point("TOPLEFT", 2, -2)
	QuestInfoSpellObjectiveFrameIconTexture:Size(QuestInfoSpellObjectiveFrameIconTexture:GetWidth() - 2, QuestInfoSpellObjectiveFrameIconTexture:GetHeight() - 2)
	QuestInfoSpellObjectiveFrame:SetTemplate("Default")
	QuestInfoSpellObjectiveFrame:CreateBackdrop()
	QuestInfoSpellObjectiveFrame.backdrop:SetOutside(QuestInfoSpellObjectiveFrameIconTexture)
	QuestInfoSpellObjectiveFrameIconTexture:SetParent(QuestInfoSpellObjectiveFrame.backdrop)

	QuestInfoRewardSpell:StripTextures()
	QuestInfoRewardSpell:StyleButton()
	QuestInfoRewardSpell:Width(QuestInfoRewardSpell:GetWidth() - 7)
	QuestInfoRewardSpell:Height(QuestInfoRewardSpell:GetHeight() - 16)
	QuestInfoRewardSpell:SetFrameLevel(QuestInfoRewardSpell:GetFrameLevel() + 2)
	QuestInfoRewardSpellIconTexture:SetTexCoord(unpack(E.TexCoords))
	QuestInfoRewardSpellIconTexture:SetDrawLayer("OVERLAY")
	QuestInfoRewardSpellIconTexture:Point("TOPLEFT", 2, -2)
	QuestInfoRewardSpellIconTexture:Size(QuestInfoRewardSpellIconTexture:GetWidth() - 2, QuestInfoRewardSpellIconTexture:GetHeight() - 3)
	QuestInfoRewardSpell:SetTemplate("Default")
	QuestInfoRewardSpell:CreateBackdrop()
	QuestInfoRewardSpell.backdrop:SetOutside(QuestInfoRewardSpellIconTexture)
	QuestInfoRewardSpellIconTexture:SetParent(QuestInfoRewardSpell.backdrop)

	QuestInfoTalentFrame:StripTextures()
	QuestInfoTalentFrame:StyleButton()
	QuestInfoTalentFrame:Width(QuestInfoTalentFrame:GetWidth() - 7)
	--QuestInfoTalentFrameIconTexture:SetTexCoord(unpack(E.TexCoords))
	QuestInfoTalentFrameIconTexture:SetDrawLayer("OVERLAY")
	QuestInfoTalentFrameIconTexture:Point("TOPLEFT", 2, -2)
	QuestInfoTalentFrameIconTexture:Size(QuestInfoTalentFrameIconTexture:GetWidth() -1, QuestInfoTalentFrameIconTexture:GetHeight() - 1)
	QuestInfoTalentFrame:SetTemplate("Default")
	QuestInfoTalentFrame:CreateBackdrop()
	QuestInfoTalentFrame.backdrop:SetOutside(QuestInfoTalentFrameIconTexture)
	QuestInfoTalentFrameIconTexture:SetParent(QuestInfoTalentFrame.backdrop)
	QuestInfoTalentFramePoints:Point("LEFT", 42, -1)

	QuestLogFrame:StripTextures();
	QuestLogFrame:CreateBackdrop("Transparent");
	QuestLogFrame.backdrop:Point("TOPLEFT", 10, -12);
	QuestLogFrame.backdrop:Point("BOTTOMRIGHT", -1, 8);

	QuestLogCount:StripTextures()
	QuestLogCount:SetTemplate("Transparent")

	for i = 1, MAX_NUM_ITEMS do
		local questItem = _G["QuestInfoItem" .. i]
		local questIcon = _G["QuestInfoItem" .. i .. "IconTexture"]
		local questCount = _G["QuestInfoItem" .. i .. "Count"]

		questItem:StripTextures();
		questItem:SetTemplate("Default");
		questItem:StyleButton();
		questItem:Width(questItem:GetWidth() - 4);
		questItem:SetFrameLevel(questItem:GetFrameLevel() + 2);

		questIcon:SetTexCoord(unpack(E.TexCoords));
		questIcon:SetDrawLayer("OVERLAY");
		questIcon:Size(questIcon:GetWidth() -(E.Spacing*2), questIcon:GetHeight() -(E.Spacing*2));
		questIcon:Point("TOPLEFT", E.Border, -E.Border);
		S:HandleIcon(questIcon);

		questCount:SetParent(questItem.backdrop);
		questCount:SetDrawLayer("OVERLAY");
	end

	QuestInfoItemHighlight:StripTextures();
	QuestInfoItemHighlight:SetTemplate("Default", nil, true);
	QuestInfoItemHighlight:SetBackdropBorderColor(1, 1, 0);
	QuestInfoItemHighlight:SetBackdropColor(0, 0, 0, 0);
	QuestInfoItemHighlight:Size(142, 40);

	hooksecurefunc("QuestInfoItem_OnClick", function(self)
		QuestInfoItemHighlight:ClearAllPoints();
		QuestInfoItemHighlight:SetOutside(self:GetName() .. "IconTexture");
		_G[self:GetName() .. "Name"]:SetTextColor(1, 1, 0);

		for i = 1, MAX_NUM_ITEMS do
			local questItem = _G["QuestInfoItem" .. i];
			if(questItem ~= self) then
				_G[questItem:GetName() .. "Name"]:SetTextColor(1, 1, 1);
			end
		end
	end);

	EmptyQuestLogFrame:StripTextures()

	S:HandleScrollBar(QuestDetailScrollFrameScrollBar)

	QuestLogFrameShowMapButton:StripTextures()
	S:HandleButton(QuestLogFrameShowMapButton)
	QuestLogFrameShowMapButton.text:ClearAllPoints()
	QuestLogFrameShowMapButton.text:Point("CENTER")
	QuestLogFrameShowMapButton:Size(QuestLogFrameShowMapButton:GetWidth() - 30, QuestLogFrameShowMapButton:GetHeight(), - 40)

	S:HandleButton(QuestLogFrameAbandonButton)
	S:HandleButton(QuestLogFramePushQuestButton)
	S:HandleButton(QuestLogFrameTrackButton)
	S:HandleButton(QuestLogFrameCancelButton)

	QuestLogFramePushQuestButton:Point("LEFT", QuestLogFrameAbandonButton, "RIGHT", 2, 0)
	QuestLogFramePushQuestButton:Point("RIGHT", QuestLogFrameTrackButton, "LEFT", -2, 0)

	--Everything here to make the text a readable color
	local function QuestObjectiveText()
		local numObjectives = GetNumQuestLeaderBoards()
		local objective
		local _, type, finished;
		local numVisibleObjectives = 0
		for i = 1, numObjectives do
			_, type, finished = GetQuestLogLeaderBoard(i)
			if(type ~= "spell") then
				numVisibleObjectives = numVisibleObjectives+1
				objective = _G["QuestInfoObjective"..numVisibleObjectives]
				if(finished) then
					objective:SetTextColor(1, 0.80, 0.10)
				else
					objective:SetTextColor(0.6, 0.6, 0.6)
				end
			end
		end
	end

	hooksecurefunc("QuestInfo_Display", function()
		local textColor = {1, 1, 1}
		local titleTextColor = {1, 0.80, 0.10}

		-- headers
		QuestInfoTitleHeader:SetTextColor(unpack(titleTextColor))
		QuestInfoDescriptionHeader:SetTextColor(unpack(titleTextColor))
		QuestInfoObjectivesHeader:SetTextColor(unpack(titleTextColor))
		QuestInfoRewardsHeader:SetTextColor(unpack(titleTextColor))
		-- other text
		QuestInfoDescriptionText:SetTextColor(unpack(textColor))
		QuestInfoObjectivesText:SetTextColor(unpack(textColor))
		QuestInfoGroupSize:SetTextColor(unpack(textColor))
		QuestInfoRewardText:SetTextColor(unpack(textColor))
		-- reward frame text
		QuestInfoItemChooseText:SetTextColor(unpack(textColor))
		QuestInfoItemReceiveText:SetTextColor(unpack(textColor))
		QuestInfoSpellLearnText:SetTextColor(unpack(textColor))
		QuestInfoXPFrameReceiveText:SetTextColor(unpack(textColor))	

		QuestObjectiveText()
	end)

	hooksecurefunc("QuestInfo_ShowRequiredMoney", function()
		local requiredMoney = GetQuestLogRequiredMoney()
		if(requiredMoney > 0) then
			if(requiredMoney > GetMoney()) then
				QuestInfoRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
			else
				QuestInfoRequiredMoneyText:SetTextColor(1, 0.80, 0.10)
			end
		end
	end)

	QuestLogDetailFrame:StripTextures()
	QuestLogDetailFrame:CreateBackdrop("Transparent")
	QuestLogDetailFrame.backdrop:Point("TOPLEFT", 10, -12);
	QuestLogDetailFrame.backdrop:Point("BOTTOMRIGHT", -1, 1);

	QuestLogDetailScrollFrame:StripTextures()

	QuestLogFrame:HookScript("OnShow", function()
		QuestLogScrollFrame:Size(302, 331)
		QuestLogScrollFrame:CreateBackdrop("Default", true)

		QuestLogDetailScrollFrame:Height(331)
		QuestLogDetailScrollFrame:Point("TOPRIGHT", -32, -75)

		QuestLogFrameShowMapButton:Point("TOPRIGHT", -31, -38)

		if(not QuestLogDetailScrollFrame.backdrop) then
			QuestLogDetailScrollFrame:CreateBackdrop("Default", true)
		end
	end)

	QuestLogDetailFrame:HookScript("OnShow", function()
		QuestLogDetailScrollFrame:Height(331)

		QuestLogFrameShowMapButton:Point("TOPRIGHT", -31, -38)

		if(not QuestLogDetailScrollFrame.backdrop) then
			QuestLogDetailScrollFrame:CreateBackdrop("Default", true)
		end
	end)

	S:HandleCloseButton(QuestLogDetailFrameCloseButton)
	QuestLogDetailFrameCloseButton:Point("TOPRIGHT", 4, -8)

	S:HandleCloseButton(QuestLogFrameCloseButton)
	QuestLogFrameCloseButton:Point("TOPRIGHT", 3, -7)

	S:HandleScrollBar(QuestLogDetailScrollFrameScrollBar)
	QuestLogDetailScrollFrameScrollBar:Point("RIGHT", 22, 0)

	S:HandleScrollBar(QuestLogScrollFrameScrollBar, 5)
	QuestLogScrollFrameScrollBar:Point("RIGHT", 27, 0)

	S:HandleScrollBar(QuestProgressScrollFrameScrollBar)
	S:HandleScrollBar(QuestRewardScrollFrameScrollBar)

	--Quest Frame
	QuestFrame:StripTextures(true)
	QuestFrame:CreateBackdrop("Transparent")
	QuestFrame.backdrop:Point("TOPLEFT", 6, -8)
	QuestFrame.backdrop:Point("BOTTOMRIGHT", -20, 65)
	QuestFrame:Width(374)

	QuestFrameDetailPanel:StripTextures(true)
	QuestDetailScrollFrame:StripTextures(true)
	QuestDetailScrollChildFrame:StripTextures(true)
	QuestRewardScrollFrame:StripTextures(true)
	QuestRewardScrollChildFrame:StripTextures(true)
	QuestFrameProgressPanel:StripTextures(true)
	QuestFrameRewardPanel:StripTextures(true)

	S:HandleButton(QuestFrameAcceptButton, true)
	S:HandleButton(QuestFrameDeclineButton, true)
	S:HandleButton(QuestFrameCompleteButton, true)
	S:HandleButton(QuestFrameGoodbyeButton, true)
	S:HandleButton(QuestFrameCompleteQuestButton, true)

	S:HandleCloseButton(QuestFrameCloseButton, QuestFrame.backdrop)

	for i = 1, 6 do
		local button = _G["QuestProgressItem"..i]
		local texture = _G["QuestProgressItem"..i.."IconTexture"]
		local count = _G["QuestProgressItem"..i.."Count"]

		button:StripTextures()
		button:StyleButton()
		button:Width(button:GetWidth() - 4)
		button:SetFrameLevel(button:GetFrameLevel() + 2)

		texture:SetTexCoord(unpack(E.TexCoords))
		texture:SetDrawLayer("OVERLAY")
		texture:Point("TOPLEFT", 2, -2)
		texture:Size(texture:GetWidth() - 2, texture:GetHeight() - 2)

		button:SetTemplate("Default")
		button:CreateBackdrop()
		button.backdrop:SetOutside(texture)

		texture:SetParent(button.backdrop)
		count:SetParent(button.backdrop)
		count:SetDrawLayer("OVERLAY")
	end

	hooksecurefunc("QuestFrameProgressItems_Update", function()
		QuestProgressTitleText:SetTextColor(1, 0.80, 0.10)
		QuestProgressText:SetTextColor(1, 1, 1)
		QuestProgressRequiredItemsText:SetTextColor(1, 0.80, 0.10)
		QuestProgressRequiredMoneyText:SetTextColor(1, 0.80, 0.10)
	end)

	QuestNPCModel:StripTextures()
	QuestNPCModel:CreateBackdrop("Transparent")
	QuestNPCModel:Point("TOPLEFT", QuestLogDetailFrame, "TOPRIGHT", 4, -34)

	QuestNPCModelTextFrame:StripTextures()
	QuestNPCModelTextFrame:CreateBackdrop("Default")
	QuestNPCModelTextFrame.backdrop:Point("TOPLEFT", QuestNPCModel.backdrop, "BOTTOMLEFT", 0, -2)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, portrait, text, name, x, y)
		QuestNPCModel:ClearAllPoints();
		QuestNPCModel:Point("TOPLEFT", parentFrame, "TOPRIGHT", x + 18, y);
	end)

	for i = 1, #QuestLogScrollFrame.buttons do
		local questLogTitle = _G["QuestLogScrollFrameButton" .. i];
		questLogTitle:SetNormalTexture("Interface\\Buttons\\UI-PlusMinus-Buttons");
		questLogTitle.SetNormalTexture = E.noop;
		questLogTitle:GetNormalTexture():Size(11);
		questLogTitle:GetNormalTexture():Point("LEFT", 5, 0);
		questLogTitle:SetHighlightTexture("");
		questLogTitle.SetHighlightTexture = E.noop;

		hooksecurefunc(questLogTitle, "SetNormalTexture", function(self, texture)
			if(find(texture, "MinusButton")) then
				self:GetNormalTexture():SetTexCoord(0.5625, 1, 0, 0.4375);
			elseif(find(texture, "PlusButton")) then
				self:GetNormalTexture():SetTexCoord(0, 0.4375, 0, 0.4375);
			else
				self:GetNormalTexture():SetTexCoord(0, 0, 0, 0);
 			end
		end);
	end
end

S:AddCallback("Quest", LoadSkin);