local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local unpack, ipairs, pairs, select = unpack, ipairs, pairs, select
local find, gsub, upper = string.find, string.gsub, string.upper

local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local GetMoney = GetMoney
local GetNumQuestLeaderBoards = GetNumQuestLeaderBoards
local GetQuestItemLink = GetQuestItemLink
local GetQuestLogItemLink = GetQuestLogItemLink
local GetQuestLogLeaderBoard = GetQuestLogLeaderBoard
local GetQuestLogRequiredMoney = GetQuestLogRequiredMoney
local GetQuestMoneyToGet = GetQuestMoneyToGet
local hooksecurefunc = hooksecurefunc

local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS
local MAX_NUM_ITEMS = MAX_NUM_ITEMS
local MAX_REPUTATIONS = MAX_REPUTATIONS
local MAX_REQUIRED_ITEMS = MAX_REQUIRED_ITEMS

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.quest then return end

	QuestLogFrame:StripTextures()
	QuestLogFrame:CreateBackdrop("Transparent")
	QuestLogFrame.backdrop:Point("TOPLEFT", 12, -12)
	QuestLogFrame.backdrop:Point("BOTTOMRIGHT", -1, 7)

	S:SetUIPanelWindowInfo(QuestLogFrame, "width")
	S:SetBackdropHitRect(QuestLogFrame)

	EmptyQuestLogFrame:StripTextures()

	QuestLogCount:StripTextures()
	QuestLogCount:CreateBackdrop("Transparent")
	QuestLogCount.backdrop:Point("TOPLEFT", -1, 0)
	QuestLogCount.backdrop:Point("BOTTOMRIGHT", 1, -4)
	QuestLogCount:ClearAllPoints()
	QuestLogCount:Point("BOTTOMLEFT", QuestLogScrollFrame, "TOPLEFT", 1, 13)
	QuestLogCount.SetPoint = E.noop

	QuestLogScrollFrame:CreateBackdrop("Transparent")
	QuestLogScrollFrame.backdrop:Point("TOPLEFT", 0, 2)
	QuestLogScrollFrame.backdrop:Point("BOTTOMRIGHT", 0, -2)
	QuestLogScrollFrame:Point("TOPLEFT", 19, -74)
	QuestLogScrollFrame:Size(303, 331)

	S:HandleScrollBar(QuestLogScrollFrameScrollBar)
	QuestLogScrollFrameScrollBar:ClearAllPoints()
	QuestLogScrollFrameScrollBar:Point("TOPRIGHT", QuestLogScrollFrame, 24, -14)
	QuestLogScrollFrameScrollBar:Point("BOTTOMRIGHT", QuestLogScrollFrame, 0, 14)

	QuestLogSkillHighlight:SetTexture(E.Media.Textures.Highlight)
	QuestLogSkillHighlight:SetAlpha(0.35)

	for _, questLogTitle in ipairs(QuestLogScrollFrame.buttons) do
		questLogTitle:SetNormalTexture(E.Media.Textures.Plus)
		questLogTitle.SetNormalTexture = E.noop

		local normal = questLogTitle:GetNormalTexture()
		normal:Size(16)
		normal:Point("LEFT", 3, 1)

		questLogTitle:SetHighlightTexture("")
		questLogTitle.SetHighlightTexture = E.noop

		hooksecurefunc(questLogTitle, "SetNormalTexture", function(_, texture)
			if find(texture, "MinusButton") then
				normal:SetTexture(E.Media.Textures.Minus)
			elseif find(texture, "PlusButton") then
				normal:SetTexture(E.Media.Textures.Plus)
			else
				normal:SetTexture("")
			end
		end)
	end

	S:HandleCloseButton(QuestLogFrameCloseButton, QuestLogFrame.backdrop)

	QuestLogDetailFrame:Height(490)
	QuestLogDetailFrame:StripTextures()
	QuestLogDetailFrame:CreateBackdrop("Transparent")
	QuestLogDetailFrame.backdrop:Point("TOPLEFT", 12, -12)
	QuestLogDetailFrame.backdrop:Point("BOTTOMRIGHT", -1, 6)

	S:SetUIPanelWindowInfo(QuestLogDetailFrame, "height", nil, nil, true)
	S:SetUIPanelWindowInfo(QuestLogDetailFrame, "width")
	S:SetBackdropHitRect(QuestLogDetailFrame)

	QuestLogDetailScrollFrame:StripTextures()
	QuestLogDetailScrollFrame:CreateBackdrop("Transparent")
	QuestLogDetailScrollFrame.backdrop:Point("TOPLEFT", -4, 2)
	QuestLogDetailScrollFrame.backdrop:Point("BOTTOMRIGHT", 0, -2)

	S:HandleScrollBar(QuestLogDetailScrollFrameScrollBar)
	QuestLogDetailScrollFrameScrollBar:ClearAllPoints()
	QuestLogDetailScrollFrameScrollBar:Point("TOPRIGHT", QuestLogDetailScrollFrame, 22, -16)
	QuestLogDetailScrollFrameScrollBar:Point("BOTTOMRIGHT", QuestLogDetailScrollFrame, 0, 16)
	QuestLogDetailScrollFrameScrollBar.SetPoint = E.noop

	S:HandleCloseButton(QuestLogDetailFrameCloseButton, QuestLogDetailFrame.backdrop)

	S:HandleButton(QuestLogFrameShowMapButton, true)
	QuestLogFrameShowMapButton:Size(84, 32)
	QuestLogFrameShowMapButton.text:ClearAllPoints()
	QuestLogFrameShowMapButton.text:Point("CENTER")

	S:HandleButton(QuestLogFrameAbandonButton)
	QuestLogFrameAbandonButton:Size(100, 22)

	S:HandleButton(QuestLogFrameTrackButton)
	QuestLogFrameTrackButton:Size(100, 22)

	S:HandleButton(QuestLogFramePushQuestButton)
	QuestLogFramePushQuestButton:Height(22)
	QuestLogFramePushQuestButton:Point("LEFT", QuestLogFrameAbandonButton, "RIGHT", E.PixelMode and 2 or 3, 0)
	QuestLogFramePushQuestButton:Point("RIGHT", QuestLogFrameTrackButton, "LEFT", E.PixelMode and -2 or -3, 0)

	S:HandleButton(QuestLogFrameCancelButton)
	QuestLogFrameCancelButton:Point("BOTTOMRIGHT", -30, 13)

	S:HandleButton(QuestLogFrameCompleteButton, true)
	QuestLogFrameCompleteButton:Point("TOPRIGHT", QuestLogFrameCancelButton, "TOPLEFT", E.PixelMode and -2 or -3, 0)
	QuestLogFrameCompleteButton:HookScript("OnUpdate", function(self)
		self:SetAlpha(QuestLogFrameCompleteButtonFlash:GetAlpha())
	end)

	QuestLogFrame:HookScript("OnShow", function()
		QuestLogDetailScrollFrame:Height(331)
		QuestLogDetailScrollFrame:Point("TOPRIGHT", -30, -74)

		QuestLogFrameShowMapButton:Point("TOPRIGHT", -30, -35)
		QuestLogFrameAbandonButton:Point("LEFT", QuestLogControlPanel, "LEFT", 1, 0)
		QuestLogFrameTrackButton:Point("RIGHT", QuestLogControlPanel, "RIGHT", -3, 0)
	end)

	QuestLogDetailFrame:HookScript("OnShow", function()
		QuestLogDetailScrollFrame:Height(374)
		QuestLogDetailScrollFrame:Point("TOPLEFT", 22, -75)

		QuestLogFrameShowMapButton:Point("TOPRIGHT", -30, -35)
		QuestLogFrameAbandonButton:Point("LEFT", QuestLogControlPanel, "LEFT", 0, 5)
		QuestLogFrameTrackButton:Point("RIGHT", QuestLogControlPanel, "RIGHT", -25, 5)
	end)

	-- Quest NPC Model
	QuestNPCModel:StripTextures()
	QuestNPCModel:CreateBackdrop("Transparent")
	QuestNPCModel.backdrop:Point("BOTTOMRIGHT", 2, -2)
	QuestNPCModel:Point("TOPLEFT", QuestLogDetailFrame, "TOPRIGHT", 4, -34)

	QuestNPCModelTextFrame:StripTextures()
	QuestNPCModelTextFrame:CreateBackdrop()
	QuestNPCModelTextFrame.backdrop:Point("TOPLEFT", E.PixelMode and -1 or -2, 16)
	QuestNPCModelTextFrame.backdrop:Point("BOTTOMRIGHT", 2, -2)

	QuestNPCModelNameText:Point("TOPLEFT", QuestNPCModelNameplate, 22, -20)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, _, _, _, x, y)
		QuestNPCModel:ClearAllPoints()
		QuestNPCModel:Point("TOPLEFT", parentFrame, "TOPRIGHT", x + 18, y)
	end)

	S:HandleNextPrevButton(QuestNPCModelTextScrollFrameScrollBarScrollUpButton)
	QuestNPCModelTextScrollFrameScrollBarScrollUpButton:Size(18, 16)

	S:HandleNextPrevButton(QuestNPCModelTextScrollFrameScrollBarScrollDownButton)
	QuestNPCModelTextScrollFrameScrollBarScrollDownButton:Size(18, 16)

	-- Quest Info
	QuestInfoTimerText:SetTextColor(1, 1, 1)
	QuestInfoAnchor:SetTextColor(1, 1, 1)

	local function HandleQuestRewards(item, icon, count, points)
		item:StripTextures()
		item:SetTemplate()
		item:StyleButton()
		item:Size(143, 40)
		item:SetFrameLevel(item:GetFrameLevel() + 2)

		icon:Size(E.PixelMode and 38 or 32)
		icon:SetDrawLayer("ARTWORK")
		icon:Point("TOPLEFT", E.PixelMode and 1 or 4, -(E.PixelMode and 1 or 4))
		S:HandleIcon(icon)

		if count then
			count:SetParent(item.backdrop)
			count:SetDrawLayer("OVERLAY")
		end

		if points then
			points:SetParent(item.backdrop)
			points:Point("BOTTOMRIGHT", icon)
			points:FontTemplate(nil, 12, "OUTLINE")
			points:SetTextColor(1, 1, 1)
		end
	end

	for i = 1, MAX_NUM_ITEMS do
		HandleQuestRewards(_G["QuestInfoItem"..i], _G["QuestInfoItem"..i.."IconTexture"], _G["QuestInfoItem"..i.."Count"])
	end

	for _, frame in pairs({"QuestInfoSkillPointFrame", "QuestInfoSpellObjectiveFrame", "QuestInfoRewardSpell", "QuestInfoTalentFrame"}) do
		HandleQuestRewards(_G[frame], _G[frame.."IconTexture"], _G[frame.."Count"], _G[frame.."Points"])

		_G[frame.."Name"]:Point("LEFT", _G[frame.."NameFrame"], "LEFT", 15, 0)
	end

	QuestInfoRewardSpell:SetHitRectInsets(0, 0, 0, 0)
	QuestInfoSpellObjectiveFrame:SetHitRectInsets(0, 0, 0, 0)

	local tCoords = CLASS_ICON_TCOORDS[upper(E.myclass)]
	QuestInfoTalentFrameIconTexture:SetTexCoord(tCoords[1] + 0.019, tCoords[2] - 0.02, tCoords[3] + 0.018, tCoords[4] - 0.02)
	QuestInfoTalentFrameIconTexture.SetTexCoord = E.noop

	QuestInfoPlayerTitleFrame:SetTemplate()
	QuestInfoPlayerTitleFrame:Size(285, 40)

	QuestInfoPlayerTitleFrameIconTexture:Size(E.PixelMode and 38 or 32)
	QuestInfoPlayerTitleFrameIconTexture:Point("TOPLEFT", E.PixelMode and 1 or 4, -(E.PixelMode and 1 or 4))
	QuestInfoPlayerTitleFrameIconTexture:SetDrawLayer("ARTWORK")
	S:HandleIcon(QuestInfoPlayerTitleFrameIconTexture)

	local function QuestQualityColors(frame, text, link)
		local quality = link and select(3, GetItemInfo(link))

		if (frame and frame.objectType == "currency") or (frame.objectType ~= "currency" and not quality) then
			frame:SetBackdropBorderColor(unpack(E.media.bordercolor))
			frame.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))

			text:SetTextColor(1, 1, 1)
		else
			local r, g, b = GetItemQualityColor(quality)
			frame:SetBackdropBorderColor(r, g, b)
			frame.backdrop:SetBackdropBorderColor(r, g, b)

			text:SetTextColor(r, g, b)
		end
	end

	QuestInfoItemHighlight:StripTextures()

	hooksecurefunc("QuestInfoItem_OnClick", function(self)
		if self.type and self.type == "choice" then
			self:SetBackdropBorderColor(1, 0.80, 0.10)
			self.backdrop:SetBackdropBorderColor(1, 0.80, 0.10)
			_G[self:GetName().."Name"]:SetTextColor(1, 0.80, 0.10)

			for i = 1, MAX_NUM_ITEMS do
				local item = _G["QuestInfoItem"..i]

				if item ~= self then
					QuestQualityColors(item, _G["QuestInfoItem"..i.."Name"], item.type and GetQuestItemLink(item.type, item:GetID()))
				end
			end
		end
	end)

	hooksecurefunc("QuestInfo_Display", function()
		QuestInfoTitleHeader:SetTextColor(1, 0.80, 0.10)
		QuestInfoDescriptionHeader:SetTextColor(1, 0.80, 0.10)
		QuestInfoObjectivesHeader:SetTextColor(1, 0.80, 0.10)
		QuestInfoRewardsHeader:SetTextColor(1, 0.80, 0.10)

		QuestInfoDescriptionText:SetTextColor(1, 1, 1)
		QuestInfoObjectivesText:SetTextColor(1, 1, 1)
		QuestInfoGroupSize:SetTextColor(1, 1, 1)
		QuestInfoRewardText:SetTextColor(1, 1, 1)

		QuestInfoItemChooseText:SetTextColor(1, 1, 1)
		QuestInfoItemReceiveText:SetTextColor(1, 1, 1)
		QuestInfoSpellLearnText:SetTextColor(1, 1, 1)
		QuestInfoXPFrameReceiveText:SetTextColor(1, 1, 1)
		QuestInfoReputationText:SetTextColor(1, 1, 1)
		QuestInfoSpellObjectiveLearnLabel:SetTextColor(1, 1, 1)

		for i = 1, MAX_REPUTATIONS do
			_G["QuestInfoReputation"..i.."Faction"]:SetTextColor(1, 1, 1)
		end

		local requiredMoney = GetQuestLogRequiredMoney()
		if requiredMoney > 0 then
			if requiredMoney > GetMoney() then
				QuestInfoRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
			else
				QuestInfoRequiredMoneyText:SetTextColor(0.2, 1, 0.2)
			end
		end

		local numVisibleObjectives = 0
		for i = 1, GetNumQuestLeaderBoards() do
			local _, questType, finished = GetQuestLogLeaderBoard(i)

			if questType ~= "spell" then
				numVisibleObjectives = numVisibleObjectives + 1
				local objective = _G["QuestInfoObjective"..numVisibleObjectives]

				if finished then
					objective:SetTextColor(0.2, 1, 0.2)
				else
					objective:SetTextColor(0.6, 0.6, 0.6)
				end
			end
		end
	
		for i = 1, MAX_NUM_ITEMS do
			local item = _G["QuestInfoItem"..i]

			QuestQualityColors(item, _G["QuestInfoItem"..i.."Name"], item.type and (QuestInfoFrame.questLog and GetQuestLogItemLink or GetQuestItemLink)(item.type, item:GetID()))
		end
	end)

	hooksecurefunc("QuestInfo_ShowRewards", function()
		for i = 1, MAX_NUM_ITEMS do
			local item = _G["QuestInfoItem"..i]

			QuestQualityColors(item, _G["QuestInfoItem"..i.."Name"], item.type and (QuestInfoFrame.questLog and GetQuestLogItemLink or GetQuestItemLink)(item.type, item:GetID()))
		end
	end)

	-- Quest Frames
	QuestFrame:StripTextures(true)
	QuestFrame:CreateBackdrop("Transparent")
	QuestFrame.backdrop:Point("TOPLEFT", 13, -11)
	QuestFrame.backdrop:Point("BOTTOMRIGHT", -16, 0)
	QuestFrame:Width(374)

	S:SetUIPanelWindowInfo(QuestFrame, "width")
	S:SetBackdropHitRect(QuestFrame)

	S:HandleCloseButton(QuestFrameCloseButton, QuestFrame.backdrop)

	for _, frame in pairs({"Greeting", "Detail", "Progress", "Reward"}) do
		_G["QuestFrame"..frame.."Panel"]:StripTextures(true)

		local scrollFrame = _G["Quest"..frame.."ScrollFrame"]
		scrollFrame:CreateBackdrop("Transparent")
		scrollFrame.backdrop:Point("TOPLEFT", -3, 2)
		scrollFrame.backdrop:Point("BOTTOMRIGHT", 4, -2)
		scrollFrame:Height(403)
		scrollFrame:Point("TOPLEFT", 23, -74)

		local scrollBar = _G["Quest"..frame.."ScrollFrameScrollBar"]
		S:HandleScrollBar(scrollBar)
		scrollBar:ClearAllPoints()
		scrollBar:Point("TOPRIGHT", scrollFrame, 27, -16)
		scrollBar:Point("BOTTOMRIGHT", scrollFrame, 0, 16)
	end

	-- Greeting Frame
	QuestGreetingFrameHorizontalBreak:Kill()

	S:HandleButton(QuestFrameGreetingGoodbyeButton)
	QuestFrameGreetingGoodbyeButton:Point("BOTTOMRIGHT", -57, 6)

	GreetingText:SetTextColor(1, 1, 1)
	GreetingText.SetTextColor = E.noop

	CurrentQuestsText:SetTextColor(1, 0.80, 0.10)
	CurrentQuestsText.SetTextColor = E.noop

	AvailableQuestsText:SetTextColor(1, 0.80, 0.10)
	AvailableQuestsText.SetTextColor = E.noop

	for i = 1, MAX_NUM_QUESTS do
		local button = _G["QuestTitleButton"..i]

		S:HandleButtonHighlight(button)
		button.handledHighlight:SetVertexColor(1, 0.80, 0.10)
	end

	QuestFrameGreetingPanel:HookScript("OnEvent", function(frame)
		if not frame:IsShown() then return end

		for i = 1, MAX_NUM_QUESTS do
			local button = _G["QuestTitleButton"..i]

			if button:GetFontString() then
				local text = button:GetText()

				if text and find(text, "|cff000000") then
					button:SetText(gsub(text, "|cff000000", "|cffFFFF00"))
				end
			end
		end
	end)
	QuestFrameGreetingPanel:RegisterEvent("QUEST_GREETING")
	QuestFrameGreetingPanel:RegisterEvent("QUEST_LOG_UPDATE")

	-- Detail Frame
	S:HandleButton(QuestFrameAcceptButton)
	QuestFrameAcceptButton:Point("BOTTOMLEFT", 20, 6)

	S:HandleButton(QuestFrameDeclineButton)
	QuestFrameDeclineButton:Point("BOTTOMRIGHT", -57, 6)

	-- Progress Frame
	S:HandleButton(QuestFrameCompleteButton)
	QuestFrameCompleteButton:Point("BOTTOMLEFT", 20, 6)

	S:HandleButton(QuestFrameGoodbyeButton)
	QuestFrameGoodbyeButton:Point("BOTTOMRIGHT", -57, 6)

	for i = 1, MAX_REQUIRED_ITEMS do
		HandleQuestRewards(_G["QuestProgressItem"..i], _G["QuestProgressItem"..i.."IconTexture"], _G["QuestProgressItem"..i.."Count"])
	end

	hooksecurefunc("QuestFrameProgressItems_Update", function()
		QuestProgressTitleText:SetTextColor(1, 0.80, 0.10)
		QuestProgressText:SetTextColor(1, 1, 1)
		QuestProgressRequiredItemsText:SetTextColor(1, 0.80, 0.10)

		local moneyToGet = GetQuestMoneyToGet()
		if moneyToGet > 0 then
			if moneyToGet > GetMoney() then
				QuestProgressRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
			else
				QuestProgressRequiredMoneyText:SetTextColor(0.2, 1, 0.2)
			end
		end

		for i = 1, MAX_REQUIRED_ITEMS do
			local item = _G["QuestProgressItem"..i]

			QuestQualityColors(item, _G["QuestProgressItem"..i.."Name"], item.type and GetQuestItemLink(item.type, item:GetID()))
		end
	end)

	-- Reward Frame
	S:HandleButton(QuestFrameCompleteQuestButton)
	QuestFrameCompleteQuestButton:Point("BOTTOMLEFT", 20, 6)
end

S:AddCallback("Quest", LoadSkin)