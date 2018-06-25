local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local unpack = unpack
local find = string.find

local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true then return end

	QuestLogFrame:StripTextures()
	QuestLogFrame:CreateBackdrop("Transparent")
	QuestLogFrame.backdrop:Point("TOPLEFT", 10, -12)
	QuestLogFrame.backdrop:Point("BOTTOMRIGHT", -1, 8)

	QuestLogCount:StripTextures()
	QuestLogCount:SetTemplate("Transparent")

	for i = 1, MAX_NUM_ITEMS do
		local questItem = _G["QuestInfoItem"..i]
		local questIcon = _G["QuestInfoItem"..i.."IconTexture"]
		local questCount = _G["QuestInfoItem"..i.."Count"]

		questItem:StripTextures()
		questItem:SetTemplate("Default")
		questItem:StyleButton()
		questItem:Size(143, 40)
		questItem:SetFrameLevel(questItem:GetFrameLevel() + 2)

		questIcon:Size(E.PixelMode and 38 or 32)
		questIcon:SetDrawLayer("OVERLAY")
		questIcon:Point("TOPLEFT", E.PixelMode and 1 or 4, -(E.PixelMode and 1 or 4))
		S:HandleIcon(questIcon)

		questCount:SetParent(questItem.backdrop)
		questCount:SetDrawLayer("OVERLAY")
	end

	local questIcons = {
		"QuestInfoSkillPointFrame",
		"QuestInfoSpellObjectiveFrame",
		"QuestInfoRewardSpell",
		"QuestInfoTalentFrame"
	}

	for i = 1, #questIcons do
		local item = _G[questIcons[i]]
		local icon = _G[questIcons[i].."IconTexture"]
		local count = _G[questIcons[i].."Count"]
		local points = _G[questIcons[i].."Points"]

		item:StripTextures()
		item:SetTemplate("Default")
		item:StyleButton()
		item:Size(140, 40)
		item:SetFrameLevel(item:GetFrameLevel() + 2)

		icon:Size(E.PixelMode and 38 or 32)
		icon:Point("TOPLEFT", E.PixelMode and 1 or 4, -(E.PixelMode and 1 or 4))
		icon:SetDrawLayer("OVERLAY")
		S:HandleIcon(icon)

		if count then
			count:SetParent(item.backdrop)
			count:SetDrawLayer("OVERLAY")
		end

		if points then
			points:Point("LEFT", 42, -1)
		end
	end

	QuestInfoRewardSpell:SetHitRectInsets(0, 1, 3, -2)
	QuestInfoSpellObjectiveFrame:SetHitRectInsets(0, 1, 3, -2)

	QuestInfoItemHighlight:StripTextures()
	QuestInfoItemHighlight:SetTemplate("Default", nil, true)
	QuestInfoItemHighlight:SetBackdropBorderColor(1, 1, 0)
	QuestInfoItemHighlight:SetBackdropColor(0, 0, 0, 0)
	QuestInfoItemHighlight.backdropTexture:SetAlpha(0)
	QuestInfoItemHighlight:Size(142, 40)

	local function QuestQualityColors(frame, text, quality, link)
		if link and not quality then
			quality = select(3, GetItemInfo(link))
		end

		if frame and frame.objectType == "currency" then
			frame:SetBackdropBorderColor(unpack(E["media"].bordercolor))
			frame.backdrop:SetBackdropBorderColor(unpack(E["media"].bordercolor))

			text:SetTextColor(1, 1, 1)
		else
			if quality then
				if frame then
					frame:SetBackdropBorderColor(GetItemQualityColor(quality))
					frame.backdrop:SetBackdropBorderColor(GetItemQualityColor(quality))
				end
				text:SetTextColor(GetItemQualityColor(quality))
			else
				if frame then
					frame:SetBackdropBorderColor(unpack(E["media"].bordercolor))
					frame.backdrop:SetBackdropBorderColor(unpack(E["media"].bordercolor))
				end
				text:SetTextColor(1, 1, 1)
			end
		end
	end

	hooksecurefunc("QuestInfoItem_OnClick", function(self)
		QuestInfoItemHighlight:ClearAllPoints()
		QuestInfoItemHighlight:SetOutside(self:GetName().."IconTexture")
		_G[self:GetName() .. "Name"]:SetTextColor(1, 1, 0)

		for i = 1, MAX_NUM_ITEMS do
			local questItem = _G["QuestInfoItem" .. i]
			local questName = _G["QuestInfoItem"..i.."Name"]
			local link = questItem.type and (QuestInfoFrame.questLog and GetQuestLogItemLink or GetQuestItemLink)(questItem.type, questItem:GetID())

			if questItem ~= self then
				QuestQualityColors(nil, questName, nil, link)
			end
		end
	end)

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

	S:HandleButton(QuestLogFrameCompleteButton, true)
	QuestLogFrameCompleteButton:Point("TOPRIGHT", QuestLogFrameCancelButton, "TOPLEFT", -3, 0)
	QuestLogFrameCompleteButton:HookScript("OnUpdate", function(self) self:SetAlpha(QuestLogFrameCompleteButtonFlash:GetAlpha()) end)

	QuestLogFramePushQuestButton:Point("LEFT", QuestLogFrameAbandonButton, "RIGHT", 2, 0)
	QuestLogFramePushQuestButton:Point("RIGHT", QuestLogFrameTrackButton, "LEFT", -2, 0)

	local function QuestObjectiveText()
		local numObjectives = GetNumQuestLeaderBoards()
		local objective
		local _, type, finished
		local numVisibleObjectives = 0
		for i = 1, numObjectives do
			_, type, finished = GetQuestLogLeaderBoard(i)
			if type ~= "spell" then
				numVisibleObjectives = numVisibleObjectives + 1
				objective = _G["QuestInfoObjective"..numVisibleObjectives]
				if finished then
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

		QuestInfoTitleHeader:SetTextColor(unpack(titleTextColor))
		QuestInfoDescriptionHeader:SetTextColor(unpack(titleTextColor))
		QuestInfoObjectivesHeader:SetTextColor(unpack(titleTextColor))
		QuestInfoRewardsHeader:SetTextColor(unpack(titleTextColor))

		QuestInfoDescriptionText:SetTextColor(unpack(textColor))
		QuestInfoObjectivesText:SetTextColor(unpack(textColor))
		QuestInfoGroupSize:SetTextColor(unpack(textColor))
		QuestInfoRewardText:SetTextColor(unpack(textColor))

		QuestInfoItemChooseText:SetTextColor(unpack(textColor))
		QuestInfoItemReceiveText:SetTextColor(unpack(textColor))
		QuestInfoSpellLearnText:SetTextColor(unpack(textColor))
		QuestInfoXPFrameReceiveText:SetTextColor(unpack(textColor))	
		QuestInfoSpellObjectiveLearnLabel:SetTextColor(unpack(textColor))

		for i = 1, MAX_REPUTATIONS do
			_G["QuestInfoReputation"..i.."Faction"]:SetTextColor(unpack(textColor))
		end

		if GetQuestLogRequiredMoney() > 0 then
			if GetQuestLogRequiredMoney() > GetMoney() then
				QuestInfoRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
			else
				QuestInfoRequiredMoneyText:SetTextColor(1, 0.80, 0.10)
			end
		end

		QuestObjectiveText()

		QuestInfoTalentFrameIconTexture:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
		QuestInfoTalentFrameIconTexture.SetTexture = E.noop

		for i = 1, MAX_NUM_ITEMS do
			local questItem = _G["QuestInfoItem"..i]
			local questName = _G["QuestInfoItem"..i.."Name"]
			local link = questItem.type and (QuestInfoFrame.questLog and GetQuestLogItemLink or GetQuestItemLink)(questItem.type, questItem:GetID())

			QuestQualityColors(questItem, questName, nil, link)
		end
	end)

	hooksecurefunc("QuestInfo_ShowRewards", function()
		for i = 1, MAX_NUM_ITEMS do
			local questItem = _G["QuestInfoItem"..i]
			local questName = _G["QuestInfoItem"..i.."Name"]
			local link = questItem.type and (QuestInfoFrame.questLog and GetQuestLogItemLink or GetQuestItemLink)(questItem.type, questItem:GetID())

			QuestQualityColors(questItem, questName, nil, link)
		end
	end)

	hooksecurefunc("QuestInfo_ShowRequiredMoney", function()
		local requiredMoney = GetQuestLogRequiredMoney()
		if requiredMoney > 0 then
			if requiredMoney > GetMoney() then
				QuestInfoRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
			else
				QuestInfoRequiredMoneyText:SetTextColor(1, 0.80, 0.10)
			end
		end
	end)

	QuestInfoTimerText:SetTextColor(1, 1, 1)
	QuestInfoAnchor:SetTextColor(1, 1, 1)

	QuestLogDetailFrame:SetAttribute("UIPanelLayout-height", E:Scale(490))
	QuestLogDetailFrame:Height(490)
	QuestLogDetailFrame:StripTextures()
	QuestLogDetailFrame:CreateBackdrop("Transparent")
	QuestLogDetailFrame.backdrop:Point("TOPLEFT", 10, -12)
	QuestLogDetailFrame.backdrop:Point("BOTTOMRIGHT", -1, 1)

	QuestLogDetailScrollFrame:StripTextures()

	QuestLogFrame:HookScript("OnShow", function()
		local questFrame = QuestLogFrame:GetFrameLevel()
		local controlPanel = QuestLogControlPanel:GetFrameLevel()
		local scrollFrame = QuestLogDetailScrollFrame:GetFrameLevel()

		if questFrame >= controlPanel then
			QuestLogControlPanel:SetFrameLevel(questFrame + 1)
		end
		if questFrame >= scrollFrame then
			QuestLogDetailScrollFrame:SetFrameLevel(questFrame + 1)
		end

		if not QuestLogScrollFrame.backdrop then
			QuestLogScrollFrame:CreateBackdrop("Default", true)
		end
		QuestLogScrollFrame.backdrop:Point("TOPLEFT", 0, 2)
		QuestLogScrollFrame.backdrop:Point("BOTTOMRIGHT", 0, -2)
		QuestLogScrollFrame:Size(302, 331)

		if not QuestLogDetailScrollFrame.backdrop then
			QuestLogDetailScrollFrame:CreateBackdrop("Default", true)
		end
		QuestLogDetailScrollFrame.backdrop:Point("TOPLEFT", 0, 3)
		QuestLogDetailScrollFrame.backdrop:Point("BOTTOMRIGHT", 0, -2)
		QuestLogDetailScrollFrame:Height(331)
		QuestLogDetailScrollFrame:Point("TOPRIGHT", -32, -76)

		QuestLogFrameShowMapButton:Point("TOPRIGHT", -32, -35)

		QuestLogScrollFrameScrollBar:Point("TOPLEFT", QuestLogScrollFrame, "TOPRIGHT", 5, -12)
		QuestLogDetailScrollFrameScrollBar:Point("TOPLEFT", QuestLogDetailScrollFrame, "TOPRIGHT", 6, -13)
	end)

	QuestLogDetailFrame:HookScript("OnShow", function()
		local questFrame = QuestLogFrame:GetFrameLevel()
		local controlPanel = QuestLogControlPanel:GetFrameLevel()
		local scrollFrame = QuestLogDetailScrollFrame:GetFrameLevel()

		if questFrame >= controlPanel then
			QuestLogControlPanel:SetFrameLevel(questFrame + 1)
		end
		if questFrame >= scrollFrame then
			QuestLogDetailScrollFrame:SetFrameLevel(questFrame + 1)
		end

		if not QuestLogDetailScrollFrame.backdrop then
			QuestLogDetailScrollFrame:CreateBackdrop("Default", true)
		end
		QuestLogDetailScrollFrame.backdrop:Point("BOTTOMRIGHT", 0, -2)
		QuestLogDetailScrollFrame:Height(375)

		QuestLogFrameShowMapButton:Point("TOPRIGHT", -33, -35)

		QuestLogDetailScrollFrameScrollBar:Point("TOPLEFT", QuestLogDetailScrollFrame, "TOPRIGHT", 6, -13)
	end)

	S:HandleCloseButton(QuestLogDetailFrameCloseButton)
	QuestLogDetailFrameCloseButton:Point("TOPRIGHT", 4, -8)

	S:HandleCloseButton(QuestLogFrameCloseButton)
	QuestLogFrameCloseButton:Point("TOPRIGHT", 3, -7)

	S:HandleScrollBar(QuestLogDetailScrollFrameScrollBar)
	S:HandleScrollBar(QuestLogScrollFrameScrollBar)
	S:HandleScrollBar(QuestProgressScrollFrameScrollBar)
	S:HandleScrollBar(QuestRewardScrollFrameScrollBar)

	-- Quest Frame
	QuestFrame:StripTextures(true)
	QuestFrame:CreateBackdrop("Transparent")
	QuestFrame.backdrop:Point("TOPLEFT", 15, -11)
	QuestFrame.backdrop:Point("BOTTOMRIGHT", -20, 0)
	QuestFrame:Width(374)

	QuestFrameDetailPanel:StripTextures(true)
	QuestDetailScrollFrame:StripTextures(true)
	QuestDetailScrollFrame:Height(403)
	QuestDetailScrollChildFrame:StripTextures(true)
	QuestRewardScrollFrame:StripTextures(true)
	QuestRewardScrollFrame:Height(403)
	QuestRewardScrollChildFrame:StripTextures(true)
	QuestFrameProgressPanel:StripTextures(true)
	QuestProgressScrollFrame:Height(403)
	QuestFrameRewardPanel:StripTextures(true)

	S:HandleButton(QuestFrameAcceptButton, true)
	QuestFrameAcceptButton:Point("BOTTOMLEFT", 20, 4)

	S:HandleButton(QuestFrameDeclineButton, true)
	QuestFrameDeclineButton:Point("BOTTOMRIGHT", -37, 4)

	S:HandleButton(QuestFrameCompleteButton, true)
	QuestFrameCompleteButton:Point("BOTTOMLEFT", 20, 4)

	S:HandleButton(QuestFrameGoodbyeButton, true)
	QuestFrameGoodbyeButton:Point("BOTTOMRIGHT", -37, 4)

	S:HandleButton(QuestFrameCompleteQuestButton, true)
	QuestFrameCompleteQuestButton:Point("BOTTOMLEFT", 20, 4)

	S:HandleCloseButton(QuestFrameCloseButton, QuestFrame.backdrop)

	for i = 1, 6 do
		local button = _G["QuestProgressItem"..i]
		local texture = _G["QuestProgressItem"..i.."IconTexture"]
		local count = _G["QuestProgressItem"..i.."Count"]

		button:StripTextures()
		button:SetTemplate("Default")
		button:StyleButton()
		button:Size(143, 40)
		button:SetFrameLevel(button:GetFrameLevel() + 2)

		texture:Size(E.PixelMode and 38 or 32)
		texture:SetDrawLayer("OVERLAY")
		texture:Point("TOPLEFT", E.PixelMode and 1 or 4, -(E.PixelMode and 1 or 4))
		S:HandleIcon(texture)

		count:SetParent(button.backdrop)
		count:SetDrawLayer("OVERLAY")
	end

	hooksecurefunc("QuestFrameProgressItems_Update", function()
		QuestProgressTitleText:SetTextColor(1, 0.80, 0.10)
		QuestProgressText:SetTextColor(1, 1, 1)
		QuestProgressRequiredItemsText:SetTextColor(1, 0.80, 0.10)

		if GetQuestMoneyToGet() > 0 then
			if GetQuestMoneyToGet() > GetMoney() then
				QuestProgressRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
			else
				QuestProgressRequiredMoneyText:SetTextColor(1, 0.80, 0.10)
			end
		end

		for i = 1, MAX_REQUIRED_ITEMS do
			local item = _G["QuestProgressItem"..i]
			local name = _G["QuestProgressItem"..i.."Name"]
			local link = item.type and GetQuestItemLink(item.type, item:GetID())

			QuestQualityColors(item, name, nil, link)
		end
	end)

	QuestNPCModel:StripTextures()
	QuestNPCModel:CreateBackdrop("Transparent")
	QuestNPCModel.backdrop:Point("BOTTOMRIGHT", 2, -2)
	QuestNPCModel:Point("TOPLEFT", QuestLogDetailFrame, "TOPRIGHT", 4, -34)

	QuestNPCModelTextFrame:StripTextures()
	QuestNPCModelTextFrame:CreateBackdrop("Default")
	QuestNPCModelTextFrame.backdrop:Point("TOPLEFT", E.PixelMode and -1 or -2, 16)
	QuestNPCModelTextFrame.backdrop:Point("BOTTOMRIGHT", 2, -2)

	QuestNPCModelNameText:Point("TOPLEFT", QuestNPCModelNameplate, 22, -20)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, _, _, _, x, y)
		QuestNPCModel:ClearAllPoints()
		QuestNPCModel:Point("TOPLEFT", parentFrame, "TOPRIGHT", x + 18, y)
	end)

	S:HandleNextPrevButton(QuestNPCModelTextScrollFrameScrollBarScrollUpButton)
	SquareButton_SetIcon(QuestNPCModelTextScrollFrameScrollBarScrollUpButton, "UP")
	QuestNPCModelTextScrollFrameScrollBarScrollUpButton:Size(18, 16)

	S:HandleNextPrevButton(QuestNPCModelTextScrollFrameScrollBarScrollDownButton)
	SquareButton_SetIcon(QuestNPCModelTextScrollFrameScrollBarScrollDownButton, "DOWN")
	QuestNPCModelTextScrollFrameScrollBarScrollDownButton:Size(18, 16)

	for i = 1, #QuestLogScrollFrame.buttons do
		local questLogTitle = _G["QuestLogScrollFrameButton"..i]
		questLogTitle:SetNormalTexture("Interface\\AddOns\\ElvUI\\media\\textures\\PlusMinusButton")
		questLogTitle.SetNormalTexture = E.noop
		questLogTitle:GetNormalTexture():Size(14)
		questLogTitle:GetNormalTexture():Point("LEFT", 3, 0)
		questLogTitle:SetHighlightTexture("")
		questLogTitle.SetHighlightTexture = E.noop

		hooksecurefunc(questLogTitle, "SetNormalTexture", function(self, texture)
			if find(texture, "MinusButton") then
				self:GetNormalTexture():SetTexCoord(0.540, 0.965, 0.085, 0.920)
			elseif find(texture, "PlusButton") then
				self:GetNormalTexture():SetTexCoord(0.040, 0.465, 0.085, 0.920)
			else
				self:GetNormalTexture():SetTexCoord(0, 0, 0, 0)
 			end
		end)
	end
end

S:AddCallback("Quest", LoadSkin)