local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local ipairs, select, unpack = ipairs, select, unpack

local GetAchievementCriteriaInfo = GetAchievementCriteriaInfo
local GetAchievementNumCriteria = GetAchievementNumCriteria
local hooksecurefunc = hooksecurefunc
local IsAddOnLoaded = IsAddOnLoaded

local function LoadSkin(event)
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.achievement) then return end

	local function SkinAchievement(achievement, BiggerIcon)
		if achievement.isSkinned then return end

		achievement:StripTextures(true)
		achievement:CreateBackdrop("Default", true)
		achievement.backdrop:Point("TOPLEFT", 2, -1)
		achievement.backdrop:Point("BOTTOMRIGHT", -2, 1)

		achievement.icon:SetTemplate()
		achievement.icon:SetSize(BiggerIcon and 54 or 36, BiggerIcon and 54 or 36)
		achievement.icon:ClearAllPoints()
		achievement.icon:Point("TOPLEFT", 8, -6)
		achievement.icon.bling:Kill()
		achievement.icon.frame:Kill()
		achievement.icon.texture:SetTexCoord(unpack(E.TexCoords))
		achievement.icon.texture:SetInside()
		achievement.icon:SetParent(achievement.backdrop)

		if achievement.highlight then
			achievement.highlight:StripTextures()
			achievement:HookScript("OnEnter", S.SetModifiedBackdrop)
			achievement:HookScript("OnLeave", S.SetOriginalBackdrop)
		end

		if achievement.label then
			achievement.label:SetTextColor(1, 1, 1)
			achievement.label:SetParent(achievement.backdrop)
		end

		if achievement.description then
			achievement.description:SetTextColor(0.6, 0.6, 0.6)
			achievement.description:SetParent(achievement.backdrop)
			hooksecurefunc(achievement.description, "SetTextColor", function(_, r, g, b)
				if r == 0 and g == 0 and b == 0 then
					achievement.description:SetTextColor(0.6, 0.6, 0.6)
				end
			end)
		end

		if achievement.hiddenDescription then
			achievement.hiddenDescription:SetTextColor(1, 1, 1)
			achievement.hiddenDescription:SetParent(achievement.backdrop)
		end

		if achievement.shield then
			achievement.shield:SetParent(achievement.backdrop)
		end

		if achievement.tracked then
			S:HandleCheckBox(achievement.tracked, true)
			achievement.tracked:Size(14, 14)
			achievement.tracked:ClearAllPoints()
			achievement.tracked:Point("TOPLEFT", achievement.icon, "BOTTOMLEFT", 0, -4)
			achievement.tracked:SetParent(achievement.backdrop)
			achievement.tracked:SetFrameLevel(achievement.backdrop:GetFrameLevel() + 2)
		end

		local trackedText = _G[achievement:GetName().."TrackedText"]
		if trackedText then
			trackedText:SetTextColor(1, 1, 1)
			trackedText:Point("TOPLEFT", 18, -2)
		end

		hooksecurefunc(achievement, "Saturate", function()
			achievement:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end)
		hooksecurefunc(achievement, "Desaturate", function()
			achievement:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end)

		achievement.isSkinned = true
	end

	if event == "PLAYER_ENTERING_WORLD" then
		hooksecurefunc("HybridScrollFrame_CreateButtons", function(frame, template)
			if template == "AchievementCategoryTemplate" then
				for _, button in ipairs(frame.buttons) do
					if button.isSkinned then return end

					button:StripTextures()

					local highlight = button:GetHighlightTexture()
					highlight:SetTexture(E.Media.Textures.Highlight)
					highlight:SetTexCoord(0, 1, 0, 1)
					highlight:SetAlpha(0.35)
					highlight:SetInside()

					button.isSkinned = true
				end
			elseif template == "AchievementTemplate" then
				for _, achievement in ipairs(frame.buttons) do
					SkinAchievement(achievement, true)
				end
			elseif template == "ComparisonTemplate" then
				for _, achievement in ipairs(frame.buttons) do
					if achievement.isSkinned then return end

					SkinAchievement(achievement.player)
					SkinAchievement(achievement.friend)
				end
			elseif template == "StatTemplate" then
				for _, stats in ipairs(frame.buttons) do
					stats:StyleButton()
				end
			end
		end)
	end

	if not IsAddOnLoaded("Blizzard_AchievementUI") then return end

	local frames = {
		"AchievementFrame",
		"AchievementFrameCategories",
		"AchievementFrameSummary",
		"AchievementFrameHeader",
		"AchievementFrameSummaryCategoriesHeader",
		"AchievementFrameSummaryAchievementsHeader",
		"AchievementFrameStatsBG",
		"AchievementFrameAchievements",
		"AchievementFrameComparison",
		"AchievementFrameComparisonHeader",
		"AchievementFrameComparisonSummaryPlayer",
		"AchievementFrameComparisonSummaryFriend"
	}

	for _, frame in ipairs(frames) do
		_G[frame]:StripTextures(true)
	end

	local noname_frames = {
		"AchievementFrameStats",
		"AchievementFrameSummary",
		"AchievementFrameAchievements",
		"AchievementFrameComparison"
	}

	for _, frame in ipairs(noname_frames) do
		frame = _G[frame]
		for i = 1, frame:GetNumChildren() do
			local child = select(i, frame:GetChildren())
			if child and not child:GetName() then
				child:SetBackdrop(nil)
			end
		end
	end

	local AchievementFrame = _G["AchievementFrame"]
	AchievementFrame:CreateBackdrop("Transparent")
	AchievementFrame.backdrop:Point("TOPLEFT", 0, 6)
	AchievementFrame.backdrop:Point("BOTTOMRIGHT", -15, 0)

	AchievementFrameHeaderTitle:ClearAllPoints()
	AchievementFrameHeaderTitle:Point("TOPLEFT", AchievementFrame.backdrop, "TOPLEFT", -30, -8)

	AchievementFrameHeaderPoints:ClearAllPoints()
	AchievementFrameHeaderPoints:Point("LEFT", AchievementFrameHeaderTitle, "RIGHT", 2, 0)

	AchievementFrameSummaryAchievementsEmptyText:Point("TOP", AchievementFrameSummaryAchievements, "TOP", 0, 20)

	S:HandleDropDownBox(AchievementFrameFilterDropDown, 200)
	AchievementFrameFilterDropDown:Point("TOPRIGHT", AchievementFrame, "TOPRIGHT", -38, 8)

	S:HandleCloseButton(AchievementFrameCloseButton, AchievementFrame.backdrop)

	AchievementFrameCategoriesContainer:CreateBackdrop("Transparent")
	AchievementFrameCategoriesContainer.backdrop:Point("TOPLEFT", 0, 3)
	AchievementFrameCategoriesContainer.backdrop:Point("BOTTOMRIGHT", -2, -2)

	AchievementFrameAchievementsContainer:CreateBackdrop("Transparent")
	AchievementFrameAchievementsContainer.backdrop:Point("TOPLEFT", -2, 1)
	AchievementFrameAchievementsContainer.backdrop:Point("BOTTOMRIGHT", -4, -2)

	AchievementFrameComparisonContainer:CreateBackdrop("Transparent")
	AchievementFrameComparisonContainer.backdrop:Point("TOPLEFT", -2, 2)
	AchievementFrameComparisonContainer.backdrop:Point("BOTTOMRIGHT", -3, -2)

	AchievementFrameComparisonStatsContainer:CreateBackdrop("Transparent")
	AchievementFrameComparisonStatsContainer.backdrop:Point("TOPLEFT", -1, 1)
	AchievementFrameComparisonStatsContainer.backdrop:Point("BOTTOMRIGHT", -7, -2)

	S:HandleScrollBar(AchievementFrameComparisonContainerScrollBar)
	AchievementFrameComparisonContainerScrollBar:ClearAllPoints()
	AchievementFrameComparisonContainerScrollBar:Point("TOPLEFT", AchievementFrameComparisonSummary, "TOPRIGHT", 7, -63)
	AchievementFrameComparisonContainerScrollBar:Point("BOTTOMLEFT", AchievementFrameComparisonSummary, "BOTTOMRIGHT", 0, -389)

	S:HandleScrollBar(AchievementFrameComparisonStatsContainerScrollBar)
	AchievementFrameComparisonStatsContainerScrollBar:ClearAllPoints()
	AchievementFrameComparisonStatsContainerScrollBar:Point("TOPLEFT", AchievementFrameComparisonStatsContainer, "TOPRIGHT", 1, -15)
	AchievementFrameComparisonStatsContainerScrollBar:Point("BOTTOMLEFT", AchievementFrameComparisonStatsContainer, "BOTTOMRIGHT", 0, 14)

	S:HandleScrollBar(AchievementFrameCategoriesContainerScrollBar)
	AchievementFrameCategoriesContainerScrollBar:ClearAllPoints()
	AchievementFrameCategoriesContainerScrollBar:Point("TOPLEFT", AchievementFrameCategoriesContainer, "TOPRIGHT", 1, -13)
	AchievementFrameCategoriesContainerScrollBar:Point("BOTTOMLEFT", AchievementFrameCategoriesContainer, "BOTTOMRIGHT", 0, 14)

	S:HandleScrollBar(AchievementFrameAchievementsContainerScrollBar)
	AchievementFrameAchievementsContainerScrollBar:ClearAllPoints()
	AchievementFrameAchievementsContainerScrollBar:Point("TOPLEFT", AchievementFrameAchievementsContainer, "TOPRIGHT", 0, -15)
	AchievementFrameAchievementsContainerScrollBar:Point("BOTTOMLEFT", AchievementFrameAchievementsContainer, "BOTTOMRIGHT", 0, 14)

	S:HandleScrollBar(AchievementFrameStatsContainerScrollBar)
	AchievementFrameStatsContainerScrollBar:ClearAllPoints()
	AchievementFrameStatsContainerScrollBar:Point("TOPLEFT", AchievementFrameStatsContainer, "TOPRIGHT", 0, -15)
	AchievementFrameStatsContainerScrollBar:Point("BOTTOMLEFT", AchievementFrameStatsContainer, "BOTTOMRIGHT", 0, 14)

	for i = 1, 3 do
		S:HandleTab(_G["AchievementFrameTab"..i])
	end

	local function SkinStatusBar(bar)
		local r, g, b = unpack(E.media.rgbvaluecolor)

		bar:StripTextures()
		bar:CreateBackdrop("Transparent")
		bar:SetStatusBarTexture(E.media.normTex)
		bar:SetStatusBarColor(r, g, b)
		E:RegisterStatusBar(bar)

		local barName = bar:GetName()
		if _G[barName.."Title"] then
			_G[barName.."Title"]:Point("LEFT", 4, 0)
			_G[barName.."Title"]:FontTemplate()
		end
		if _G[barName.."Label"] then
			_G[barName.."Label"]:Point("LEFT", 4, 0)
			_G[barName.."Label"]:FontTemplate()
		end
		if _G[barName.."Text"] then
			_G[barName.."Text"]:Point("RIGHT", -4, 0)
			_G[barName.."Text"]:FontTemplate()
		end
		if _G[barName.."FillBar"] then
			_G[barName.."FillBar"]:SetTexture(E.media.normTex)
			_G[barName.."FillBar"]:SetVertexColor(r * 0.3, g * 0.3, b * 0.3)
		end
	end

	SkinStatusBar(AchievementFrameSummaryCategoriesStatusBar)

	SkinStatusBar(AchievementFrameComparisonSummaryPlayerStatusBar)
	AchievementFrameComparisonSummaryPlayerStatusBar:Point("TOPLEFT", -1, -17)

	SkinStatusBar(AchievementFrameComparisonSummaryFriendStatusBar)
	AchievementFrameComparisonSummaryFriendStatusBar:Point("TOP", -13, -17)

	AchievementFrameComparisonSummaryFriendStatusBar.text:ClearAllPoints()
	AchievementFrameComparisonSummaryFriendStatusBar.text:Point("CENTER")

	AchievementFrameComparisonHeader:Point("BOTTOMRIGHT", AchievementFrameComparison, "TOPRIGHT", 45, -10)

	for i = 1, 8 do
		local frame = _G["AchievementFrameSummaryCategoriesCategory"..i]
		local button = _G["AchievementFrameSummaryCategoriesCategory"..i.."Button"]
		local highlight = _G["AchievementFrameSummaryCategoriesCategory"..i.."ButtonHighlight"]

		SkinStatusBar(frame)
		button:StripTextures()
		highlight:StripTextures()

		_G[highlight:GetName().."Middle"]:SetTexture(1, 1, 1, 0.3)
		_G[highlight:GetName().."Middle"]:SetAllPoints(frame)
	end

	hooksecurefunc("AchievementFrameSummary_UpdateAchievements", function()
		for i = 1, ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
			local frame = _G["AchievementFrameSummaryAchievement"..i]

			if not frame.isSkinned then
				SkinAchievement(frame)

				if frame.shield.points then
					frame.shield.points:ClearAllPoints()
					frame.shield.points:Point("CENTER", 0, 2)
				end

				frame.isSkinned = true
			end

			local prevFrame = _G["AchievementFrameSummaryAchievement"..(i - 1)]
			if i ~= 1 then
				frame:ClearAllPoints()
				frame:Point("TOPLEFT", prevFrame, "BOTTOMLEFT", 0, -1)
				frame:Point("TOPRIGHT", prevFrame, "BOTTOMRIGHT", 0, 1)
			end

			frame:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
	end)

	AchievementFrameStatsContainer:CreateBackdrop("Transparent")
	AchievementFrameStatsContainer.backdrop:Point("TOPLEFT", -1, 1)
	AchievementFrameStatsContainer.backdrop:Point("BOTTOMRIGHT", -6, -2)

	for _, frame in pairs({"AchievementFrameStatsContainerButton", "AchievementFrameComparisonStatsContainerButton"}) do
		for i = 1, 20 do
			_G[frame..i]:StripTextures()

			_G[frame..i]:SetHighlightTexture(E.Media.Textures.Highlight)
			_G[frame..i]:GetHighlightTexture():SetAlpha(0.35)
			_G[frame..i]:GetHighlightTexture():SetInside()

			_G[frame..i.."BG"]:SetTexture(0, 0, 0, 0.6)
			_G[frame..i.."BG"]:Point("TOPLEFT", 1, 0)
			_G[frame..i.."BG"]:Point("BOTTOMRIGHT", -1, 0)
			_G[frame..i.."HeaderLeft"]:Kill()
			_G[frame..i.."HeaderRight"]:Kill()
			_G[frame..i.."HeaderMiddle"]:Kill()
		end
	end

	hooksecurefunc("AchievementButton_GetProgressBar", function(index)
		local Bar = _G["AchievementFrameProgressBar"..index]

		if Bar and not Bar.isSkinned then
			local BarBG = _G["AchievementFrameProgressBar"..index.."BG"]
			local r, g, b = unpack(E.media.rgbvaluecolor)

			Bar:StripTextures()
			Bar:CreateBackdrop("Transparent")
			Bar.backdrop:SetBackdropColor(0, 0, 0, 0)
			Bar:Height(Bar:GetHeight() + 2)
			Bar:SetStatusBarTexture(E.media.normTex)
			Bar:SetStatusBarColor(r, g, b)
			E:RegisterStatusBar(Bar)

			BarBG:SetTexture(E.media.normTex)
			BarBG:SetVertexColor(r * 0.3, g * 0.3, b * 0.3)

			Bar.text:ClearAllPoints()
			Bar.text:Point("CENTER", Bar, "CENTER", 0, -1)
			Bar.text:FontTemplate()
			Bar.text:SetJustifyH("CENTER")

			if index > 1 then
				Bar:ClearAllPoints()
				Bar.ClearAllPoints = E.noop
				Bar:Point("TOP", _G["AchievementFrameProgressBar"..index - 1], "BOTTOM", 0, -5)
				Bar.SetPoint = E.noop
			end

			Bar.isSkinned = true
		end
	end)

	hooksecurefunc("AchievementObjectives_DisplayCriteria", function(objectivesFrame, id)
		local numCriteria = GetAchievementNumCriteria(id)
		local textStrings, metas = 0, 0
		for i = 1, numCriteria do
			local _, criteriaType, completed, _, _, _, _, assetID = GetAchievementCriteriaInfo(id, i)
			if criteriaType == CRITERIA_TYPE_ACHIEVEMENT and assetID then
				metas = metas + 1
				local metaCriteria = AchievementButton_GetMeta(metas)

				metaCriteria:Height(21)
				metaCriteria:StyleButton()
				metaCriteria.border:Kill()
				metaCriteria.icon:SetTexCoord(unpack(E.TexCoords))
				metaCriteria.icon:Point("TOPLEFT", 2, -2)
				metaCriteria.label:Point("LEFT", 26, 0)

				if objectivesFrame.completed and completed then
					metaCriteria.label:SetShadowOffset(0, 0)
					metaCriteria.label:SetTextColor(1, 1, 1, 1)
				elseif completed then
					metaCriteria.label:SetShadowOffset(1, -1)
					metaCriteria.label:SetTextColor(0, 1, 0, 1)
				else
					metaCriteria.label:SetShadowOffset(1, -1)
					metaCriteria.label:SetTextColor(0.6, 0.6, 0.6, 1)
				end
			elseif criteriaType ~= 1 then
				textStrings = textStrings + 1
				local criteria = AchievementButton_GetCriteria(textStrings)
				if objectivesFrame.completed and completed then
					criteria.name:SetTextColor(1, 1, 1, 1)
					criteria.name:SetShadowOffset(0, 0)
				elseif completed then
					criteria.name:SetTextColor(0, 1, 0, 1)
					criteria.name:SetShadowOffset(1, -1)
				else
					criteria.name:SetTextColor(.6, .6, .6, 1)
					criteria.name:SetShadowOffset(1, -1)
				end
			end
		end
	end)

	hooksecurefunc("AchievementObjectives_DisplayProgressiveAchievement", function(objectivesFrame, id)
		for i = 1, 18 do
			local mini = _G["AchievementFrameMiniAchievement"..i]

			if mini and not mini.isSkinned then
				local icon = _G["AchievementFrameMiniAchievement"..i.."Icon"]
				local points = _G["AchievementFrameMiniAchievement"..i.."Points"]
				local border = _G["AchievementFrameMiniAchievement"..i.."Border"]
				local shield = _G["AchievementFrameMiniAchievement"..i.."Shield"]

				mini:SetTemplate()
				mini:SetBackdropColor(0, 0, 0, 0)
				mini.backdropTexture:SetAlpha(0)
				mini:Size(32)

				local prevFrame = _G["AchievementFrameMiniAchievement"..i - 1]
				if i ~= 1 and i ~= 7 then
					mini:Point("TOPLEFT", prevFrame, "TOPRIGHT", 10, 0)
				elseif i == 1 then
					mini:Point("TOPLEFT", 6, -4)
				elseif i == 7 then
					mini:Point("TOPLEFT", AchievementFrameMiniAchievement1, "BOTTOMLEFT", 0, -20)
				end
				mini.SetPoint = E.noop

				icon:SetTexCoord(unpack(E.TexCoords))
				icon:SetInside()

				points:Point("BOTTOMRIGHT", -8, -15)
				points:SetTextColor(1, 0.80, 0.10)

				border:Kill()
				shield:Kill()

				mini.isSkinned = true
			end
		end
	end)
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	LoadSkin(event)
end)

S:AddCallbackForAddon("Blizzard_AchievementUI", "Achievement", LoadSkin)