local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local select, unpack, pairs = select, unpack, pairs

local CreateFrame = CreateFrame
local EJ_GetEncounterInfoByIndex = EJ_GetEncounterInfoByIndex
local EJ_GetNumLoot = EJ_GetNumLoot
local EJ_GetLootInfoByIndex = EJ_GetLootInfoByIndex
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local hooksecurefunc = hooksecurefunc
local SHOW_MAP = SHOW_MAP

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.encounterjournal then return end

	EncounterJournal.inset:StripTextures(true)
	EncounterJournal:StripTextures(true)
	EncounterJournal:SetTemplate("Transparent")

	S:HandleCloseButton(EncounterJournalCloseButton)

	-- NavBar
	EncounterJournal.navBar:StripTextures(true)
	EncounterJournal.navBar:CreateBackdrop()
	EncounterJournal.navBar.backdrop:Point("TOPLEFT", -2, 0)
	EncounterJournal.navBar.backdrop:Point("BOTTOMRIGHT")
	EncounterJournal.navBar:Point("TOPLEFT", 12, -20)

	EncounterJournal.navBar.overlay:StripTextures(true)

	S:HandleButton(EncounterJournal.navBar.home, true)

	local function navButtonFrameLevel(frame)
		for i = 1, #frame.navList do
			local navButton = frame.navList[i]
			local lastNav = frame.navList[i - 1]

			if navButton and lastNav then
				navButton:SetFrameLevel(lastNav:GetFrameLevel() + 2)
				navButton:ClearAllPoints()
				navButton:Point("LEFT", lastNav, "RIGHT", 1, 0)
			end
		end
	end

	hooksecurefunc("NavBar_AddButton", function(frame)
		if frame:GetParent():GetName() ~= "EncounterJournal" then return end

		local navButton = frame.navList[#frame.navList]

		if navButton and not navButton.isSkinned then
			S:HandleButton(navButton, true)

			navButton:HookScript("OnClick", function()
				navButtonFrameLevel(frame)
			end)

			navButton.isSkinned = true
		end

		navButtonFrameLevel(frame)
	end)

	-- Side Tabs
	for _, tab in pairs({EncounterJournalEncounterFrameInfoBossTab, EncounterJournalEncounterFrameInfoLootTab}) do
		tab:StripTextures()
		tab:SetTemplate("Transparent")
		tab:StyleButton()
		tab:Size(45, 40)

		local normal, pushed, disabled = tab:GetNormalTexture(), tab:GetPushedTexture(), tab:GetDisabledTexture()

		normal:SetTexture([[Interface\EncounterJournal\UI-EncounterJournalTextures]])
		pushed:SetTexture([[Interface\EncounterJournal\UI-EncounterJournalTextures]])
		disabled:SetTexture([[Interface\EncounterJournal\UI-EncounterJournalTextures]])

		if tab == EncounterJournalEncounterFrameInfoBossTab then
			normal:SetTexCoord(0.902, 0.996, 0.269, 0.311)
			pushed:SetTexCoord(0.902, 0.996, 0.269, 0.311)
			disabled:SetTexCoord(0.902, 0.996, 0.269, 0.311)
		else
			normal:SetTexCoord(0.632, 0.726, 0.618, 0.660)
			pushed:SetTexCoord(0.632, 0.726, 0.618, 0.660)
			disabled:SetTexCoord(0.632, 0.726, 0.618, 0.660)
		end
	end

	EncounterJournalEncounterFrameInfoBossTab:Point("TOPLEFT", EncounterJournalEncounterFrameInfo, "TOPRIGHT", E.PixelMode and 7 or 9, 40)
	EncounterJournalEncounterFrameInfoLootTab:Point("TOP", EncounterJournalEncounterFrameInfoBossTab, "BOTTOM", 0, -10)

	-- Dungeon / Raid Select
	EncounterJournal.instanceSelect:StripTextures(true)

	S:HandleDropDownBox(EncounterJournal.instanceSelect.tierDropDown)

	EncounterJournal.instanceSelect.scroll:CreateBackdrop("Transparent")
	EncounterJournal.instanceSelect.scroll.backdrop:Point("TOPLEFT", 6, 2)
	EncounterJournal.instanceSelect.scroll.backdrop:Point("BOTTOMRIGHT", -25, -1)

	S:HandleScrollBar(EncounterJournal.instanceSelect.scroll.ScrollBar)
	EncounterJournal.instanceSelect.scroll.ScrollBar:ClearAllPoints()
	EncounterJournal.instanceSelect.scroll.ScrollBar:Point("TOPRIGHT", EncounterJournal.instanceSelect.scroll, 1, -13)
	EncounterJournal.instanceSelect.scroll.ScrollBar:Point("BOTTOMRIGHT", EncounterJournal.instanceSelect.scroll, 0, 14)

	for _, tab in pairs({EncounterJournal.instanceSelect.dungeonsTab, EncounterJournal.instanceSelect.raidsTab}) do
		tab:StripTextures()
		tab:CreateBackdrop(nil, true)
		tab:Height(28)
		tab.SetHeight = E.noop
		tab:SetHitRectInsets(0, 0, 0, 0)
		tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)

		tab:HookScript("OnEnter", S.SetModifiedBackdrop)
		tab:HookScript("OnLeave", S.SetOriginalBackdrop)
	end

	EncounterJournal.instanceSelect.raidsTab:Point("BOTTOMRIGHT", EncounterJournalInstanceSelect, "TOPRIGHT", -25, -36)
	EncounterJournal.instanceSelect.dungeonsTab:Point("BOTTOMRIGHT", EncounterJournalInstanceSelectRaidTab, "BOTTOMLEFT", -10, 0)

	local function SkinDungeons()
		local button1 = EncounterJournalInstanceSelectScrollFrameScrollChildInstanceButton1

		if button1 and not button1.isSkinned then
			S:HandleButton(button1)
			button1:Point("TOPLEFT", 12, -4)

			button1.bgImage:SetInside()
			button1.bgImage:SetTexCoord(0.08, 0.6, 0.08, 0.6)
			button1.bgImage:SetDrawLayer("ARTWORK")

			button1.isSkinned = true
		end

		for i = 2, 14 do
			local button = _G["EncounterJournalInstanceSelectScrollFrameinstance"..i]

			if button and not button.isSkinned then
				S:HandleButton(button)

				if i == 2 then
					button:Point("LEFT", button1, "RIGHT", 15, -1)
				end

				button.bgImage:SetInside()
				button.bgImage:SetTexCoord(0.08, 0.6, 0.08, 0.6)
				button.bgImage:SetDrawLayer("ARTWORK")

				button.isSkinned = true
			end
		end
	end
	hooksecurefunc("EncounterJournal_ListInstances", SkinDungeons)
	EncounterJournal_ListInstances()

	-- Encounter Info Frame
	EncounterJournalEncounterFrameInfoBG:Kill()

	S:HandleButton(EncounterJournal.encounter.info.difficulty, true)
	EncounterJournal.encounter.info.difficulty:Width(100)
	EncounterJournal.encounter.info.difficulty:Point("TOPRIGHT", -24, -7)
	EncounterJournal.encounter.info.difficulty:SetHitRectInsets(0, 0, 0, 0)

	S:HandleButton(EncounterJournalEncounterFrameInfoResetButton)

	EncounterJournalEncounterFrameInfoResetButtonTexture:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
	EncounterJournalEncounterFrameInfoResetButtonTexture:SetTexCoord(0.90625000, 0.94726563, 0.00097656, 0.02050781)

	EncounterJournalEncounterFrameModelFrameShadow:Hide()
	EncounterJournalEncounterFrameModelFrame:CreateBackdrop("Transparent")

	-- Map Button
	S:HandleButton(EncounterJournalEncounterFrameInstanceFrameMapButton, true)
	EncounterJournalEncounterFrameInstanceFrameMapButton:Size(82, 30)

	EncounterJournalEncounterFrameInstanceFrameMapButtonText:SetText(SHOW_MAP)
	EncounterJournalEncounterFrameInstanceFrameMapButtonText:ClearAllPoints()
	EncounterJournalEncounterFrameInstanceFrameMapButtonText:Point("CENTER")

	-- Filter
	S:HandleButton(EncounterJournal.encounter.info.lootScroll.filter, true)
	EncounterJournal.encounter.info.lootScroll.filter:Point("TOPLEFT", EncounterJournalEncounterFrameInfo, "TOPRIGHT", -357, -7)

	EncounterJournal.encounter.info.lootScroll.classClearFilter:CreateBackdrop("Transparent")
	EncounterJournal.encounter.info.lootScroll.classClearFilter:Size(330, 22)
	EncounterJournal.encounter.info.lootScroll.classClearFilter:Point("BOTTOM", EncounterJournal.encounter.info.lootScroll, "TOP", 0, 4)

	EncounterJournal.encounter.info.lootScroll.classClearFilter.text:Point("LEFT", 5, 0)

	S:HandleCloseButton(EncounterJournalEncounterFrameInfoLootScrollFrameClassFilterClearFrameExitButton)
	EncounterJournalEncounterFrameInfoLootScrollFrameClassFilterClearFrameExitButton:Size(26)
	EncounterJournalEncounterFrameInfoLootScrollFrameClassFilterClearFrameExitButton:Point("RIGHT", -5, 0)
	EncounterJournalEncounterFrameInfoLootScrollFrameClassFilterClearFrameExitButton.Texture:SetVertexColor(1, 0, 0)
	EncounterJournalEncounterFrameInfoLootScrollFrameClassFilterClearFrameExitButton:HookScript("OnEnter", function(btn) btn.Texture:SetVertexColor(1, 1, 1) end)
	EncounterJournalEncounterFrameInfoLootScrollFrameClassFilterClearFrameExitButton:HookScript("OnLeave", function(btn) btn.Texture:SetVertexColor(1, 0, 0) end)

	for i = 1, EncounterJournal.encounter.info.lootScroll.classClearFilter:GetNumRegions() do
		local region = select(i, EncounterJournal.encounter.info.lootScroll.classClearFilter:GetRegions())

		if region.IsObjectType and region:IsObjectType("Texture") and region:GetTexture() then
			region:SetTexture(E.Media.Textures.Highlight)
			region:SetTexCoord(0, 1, 0, 1)
			region:SetInside(EncounterJournal.encounter.info.lootScroll.classClearFilter.backdrop)
			region:SetVertexColor(1, 0.8, 0.2, 0.40)
		end
	end

	EncounterJournalEncounterFrameInfoLootScrollFrameClassFilterFrame:StripTextures()
	EncounterJournalEncounterFrameInfoLootScrollFrameClassFilterFrame:SetTemplate()
	EncounterJournalEncounterFrameInfoLootScrollFrameClassFilterFrame:SetOutside(EncounterJournal.encounter.info.lootScroll)

	for i = 1, 10 do
		local button = _G["EncounterJournalEncounterFrameInfoLootScrollFrameClassFilterFrameClass"..i]

		S:HandleButton(button, true)

		button:GetNormalTexture():SetTexture([[Interface\WorldStateFrame\Icons-Classes]])
		button:GetPushedTexture():SetTexture([[Interface\WorldStateFrame\Icons-Classes]])

		local checked = button:GetCheckedTexture()
		checked:SetTexture(1, 1, 1, 0.3)
		checked:SetInside()

		button.bevel:Kill()
		button.shadow:Kill()
	end

	-- Loot List
	EncounterJournal.encounter.info.lootScroll:CreateBackdrop("Transparent")
	EncounterJournal.encounter.info.lootScroll:Point("BOTTOMRIGHT", -25, 1)
	EncounterJournal.encounter.info.lootScroll:Size(331, 384)

	S:HandleScrollBar(EncounterJournal.encounter.info.lootScroll.scrollBar)
	EncounterJournal.encounter.info.lootScroll.scrollBar:ClearAllPoints()
	EncounterJournal.encounter.info.lootScroll.scrollBar:Point("TOPRIGHT", EncounterJournal.encounter.info.lootScroll, 26, -14)
	EncounterJournal.encounter.info.lootScroll.scrollBar:Point("BOTTOMRIGHT", EncounterJournal.encounter.info.lootScroll, 0, 14)

	local items = EncounterJournal.encounter.info.lootScroll.buttons
	for i = 1, #items do
		local item = items[i]

		item:CreateBackdrop()
		item.backdrop:Point("TOPLEFT", 0, -4)
		item.backdrop:Point("BOTTOMRIGHT", -2, E.PixelMode and 1 or -1)
		item:SetHitRectInsets(0, 2, 4, 1)
		item:HookScript("OnEnter", S.SetModifiedBackdrop)
		item:HookScript("OnLeave", S.SetOriginalBackdrop)

		if i == 1 then
			item:Point("TOPLEFT", EncounterJournal.encounter.info.lootScroll.scrollChild, 6, 0)
		elseif i == 2 then
			item:Point("TOPLEFT", items[1], "BOTTOMLEFT", 1, 0)
		end

		item.name:ClearAllPoints()
		item.name:Point("TOPLEFT", item.icon, "TOPRIGHT", 6, -2)
		item.name:SetParent(item.backdrop)

		item.boss:SetTextColor(1, 1, 1)
		item.boss:ClearAllPoints()
		item.boss:Point("BOTTOMLEFT", 4, 6)
		item.boss:SetParent(item.backdrop)

		item.armorType:SetTextColor(1, 1, 1)
		item.armorType:ClearAllPoints()
		item.armorType:Point("BOTTOMRIGHT", item.name, "TOPLEFT", 264, -25)
		item.armorType:SetParent(item.backdrop)

		item.slot:SetTextColor(1, 1, 1)
		item.slot:ClearAllPoints()
		item.slot:Point("TOPLEFT", item.name, "BOTTOMLEFT", 0, -3)
		item.slot:SetParent(item.backdrop)

		item.IconBackdrop = CreateFrame("Frame", nil, item)
		item.IconBackdrop:SetTemplate()
		item.IconBackdrop:SetFrameLevel(item:GetFrameLevel())
		item.IconBackdrop:SetOutside(item.icon)

		item.icon:Size(E.PixelMode and 34 or 30)
		item.icon:Point("TOPLEFT", E.PixelMode and (i == 1 and 4 or 3) or (i == 1 and 7 or 5), -(E.PixelMode and 7 or 10))
		item.icon:SetDrawLayer("ARTWORK")
		item.icon:SetTexCoord(unpack(E.TexCoords))
		item.icon:SetParent(item.IconBackdrop)

		item.bossTexture:SetAlpha(0)
		item.bosslessTexture:SetAlpha(0)
	end

	local function SkinLootItems()
		local offset = HybridScrollFrame_GetOffset(EncounterJournal.encounter.info.lootScroll)
		local buttons = EncounterJournal.encounter.info.lootScroll.buttons
		local numLoot = EJ_GetNumLoot()
		local item, index, itemID, quality

		for i = 1, #buttons do
			item = buttons[i]
			index = offset + i
			if index <= numLoot then
				itemID = select(5, EJ_GetLootInfoByIndex(index))
				quality = select(3, GetItemInfo(itemID))

				item.IconBackdrop:SetBackdropBorderColor(GetItemQualityColor(quality))
			end
		end
	end
	hooksecurefunc("EncounterJournal_LootUpdate", SkinLootItems)
	hooksecurefunc("HybridScrollFrame_Update", SkinLootItems)

	-- Boss List
	hooksecurefunc("EncounterJournal_DisplayInstance", function()
		local index, button = 1
		local _, _, bossID = EJ_GetEncounterInfoByIndex(index)

		while bossID do
			button = _G["EncounterJournalBossButton"..index]

			if button and not button.isSkinned then
				S:HandleButton(button)

				if index == 1 then
					button:Point("TOPLEFT", 3, -10)
				elseif index == 2 then
					button:Point("TOPLEFT", EncounterJournalBossButton1, "BOTTOMLEFT", 1, -15)
				end

				button.creature:ClearAllPoints()
				button.creature:Point("TOPLEFT", 1, -4)

				button.isSkinned = true
			end

			index = index + 1
			_, _, bossID = EJ_GetEncounterInfoByIndex(index)
		end
	end)

	-- Abilities List
	EncounterJournal.encounter.info.detailsScroll:CreateBackdrop("Transparent")
	EncounterJournal.encounter.info.detailsScroll:Point("BOTTOMRIGHT", -25, 1)
	EncounterJournal.encounter.info.detailsScroll:Size(331, 384)

	S:HandleScrollBar(EncounterJournal.encounter.info.detailsScroll.ScrollBar)
	EncounterJournal.encounter.info.detailsScroll.ScrollBar:ClearAllPoints()
	EncounterJournal.encounter.info.detailsScroll.ScrollBar:Point("TOPRIGHT", EncounterJournal.encounter.info.detailsScroll, 26, -14)
	EncounterJournal.encounter.info.detailsScroll.ScrollBar:Point("BOTTOMRIGHT", EncounterJournal.encounter.info.detailsScroll, 0, 14)

	EncounterJournal.encounter.info.detailsScroll.child.description:SetTextColor(1, 1, 1)

	hooksecurefunc("EncounterJournal_ToggleHeaders", function()
		local index = 1
		local header = _G["EncounterJournalInfoHeader"..index]
		while header do
			if not header.isSkinned then
				header.flashAnim.Play = E.noop

				header.descriptionBG:SetAlpha(0)
				header.descriptionBGBottom:SetAlpha(0)

				for i = 4, 18 do
					select(i, header.button:GetRegions()):SetTexture("")
				end

				header.description:SetTextColor(1, 1, 1)

				header.button.title:SetTextColor(unpack(E.media.rgbvaluecolor))
				header.button.title.SetTextColor = E.noop

				header.button.expandedIcon:SetTextColor(1, 1, 1)
				header.button.expandedIcon.SetTextColor = E.noop

				S:HandleButton(header.button)

				header.button.bg = CreateFrame("Frame", nil, header.button)
				header.button.bg:SetTemplate()
				header.button.bg:SetOutside(header.button.abilityIcon)
				header.button.bg:SetFrameLevel(header.button.bg:GetFrameLevel() - 1)

				header.button.abilityIcon:SetTexCoord(unpack(E.TexCoords))
				header.button.abilityIcon:SetParent(header.button.bg)

				header.isSkinned = true
			end

			if header.button.abilityIcon:IsShown() then
				header.button.bg:Show()
			else
				header.button.bg:Hide()
			end

			index = index + 1
			header = _G["EncounterJournalInfoHeader"..index]
		end
	end)

	-- Encounter Instance Frame
	EncounterJournal.encounter.instance:CreateBackdrop("Transparent")
	EncounterJournal.encounter.instance.backdrop:Point("TOPLEFT", 8, -8)
	EncounterJournal.encounter.instance.backdrop:Point("BOTTOMRIGHT", 4, 84)
	EncounterJournal.encounter.instance:Point("TOPLEFT", -2, 10)

	-- Lore
	EncounterJournal.encounter.instance.loreScroll:Size(364, 90)
	EncounterJournal.encounter.instance.loreScroll:CreateBackdrop("Transparent")
	EncounterJournal.encounter.instance.loreScroll.backdrop:Point("TOPLEFT", 0, 2)
	EncounterJournal.encounter.instance.loreScroll.backdrop:Point("BOTTOMRIGHT", 0, -2)
	EncounterJournal.encounter.instance.loreScroll:Point("BOTTOM", -5, -12)

	EncounterJournal.encounter.instance.loreScroll.child.lore:SetTextColor(1, 1, 1)

	S:HandleScrollBar(EncounterJournal.encounter.instance.loreScroll.ScrollBar)
	EncounterJournal.encounter.instance.loreScroll.ScrollBar:ClearAllPoints()
	EncounterJournal.encounter.instance.loreScroll.ScrollBar:Point("TOPRIGHT", EncounterJournal.encounter.instance.loreScroll, 24, -13)
	EncounterJournal.encounter.instance.loreScroll.ScrollBar:Point("BOTTOMRIGHT", EncounterJournal.encounter.instance.loreScroll, 0, 13)
	EncounterJournal.encounter.instance.loreScroll.ScrollBar:Show()
	EncounterJournal.encounter.instance.loreScroll.ScrollBar.Hide = E.noop

	-- Search Box
	S:HandleEditBox(EncounterJournal.searchBox)
	EncounterJournal.searchBox:Point("TOPRIGHT", -32, -27)

	for i = 1, 5 do
		local button = _G["EncounterJournalSearchBoxSearchButton"..i]

		button:StripTextures()
		button:CreateBackdrop()
		button.backdrop:SetOutside(button.icon)
		button.backdrop:SetFrameLevel(button.backdrop:GetFrameLevel() + 2)

		S:HandleButtonHighlight(button)

		if i == 1 then
			button.bg = CreateFrame("Frame", nil, button)
			button.bg:SetTemplate()
			button.bg:SetFrameLevel(button.bg:GetFrameLevel() - 1)
			button.bg:Point("TOPLEFT", EncounterJournalSearchBoxSearchButton1, 0, 1)
			button.bg:Point("BOTTOMRIGHT", EncounterJournalSearchBoxSearchButton5, 0, -1)

			button:ClearAllPoints()
			button:Point("LEFT", EncounterJournal.searchBox, -1, 0)
			button:Point("RIGHT", EncounterJournal.searchBox, 1, 0)
			button:Point("BOTTOM", EncounterJournal.searchBox, 0, -30)
		end

		button.icon:SetTexCoord(unpack(E.TexCoords))
		button.icon:Point("TOPLEFT", 4, -5)
		button.icon:SetParent(button.backdrop)
	end

	S:HandleButton(EncounterJournalSearchBoxShowALL)
	EncounterJournalSearchBoxShowALL:Point("TOP", EncounterJournalSearchBoxSearchButton5, "BOTTOM", 0, -2)

	-- Search Frame
	EncounterJournalSearchResults:StripTextures()
	EncounterJournalSearchResults:SetTemplate("Transparent")
	EncounterJournalSearchResults:Size(610, 406)
	EncounterJournalSearchResults:Point("BOTTOM", 0, 33)
	EncounterJournalSearchResults:EnableMouse(true)

	S:HandleCloseButton(EncounterJournalSearchResultsCloseButton)
	EncounterJournalSearchResultsCloseButton:Point("TOPRIGHT", 2, 4)

	EncounterJournalSearchResultsScrollFrame:StripTextures()
	EncounterJournalSearchResultsScrollFrame:CreateBackdrop()
	EncounterJournalSearchResultsScrollFrame.backdrop:Point("BOTTOMRIGHT", 0, -2)
	EncounterJournalSearchResultsScrollFrame:Point("BOTTOMLEFT", 6, 8)

	S:HandleScrollBar(EncounterJournalSearchResultsScrollFrameScrollBar)
	EncounterJournalSearchResultsScrollFrameScrollBar:ClearAllPoints()
	EncounterJournalSearchResultsScrollFrameScrollBar:Point("TOPRIGHT", EncounterJournalSearchResultsScrollFrame, 22, -15)
	EncounterJournalSearchResultsScrollFrameScrollBar:Point("BOTTOMRIGHT", EncounterJournalSearchResultsScrollFrame, 0, 14)

	for i = 1, 9 do
		local button = _G["EncounterJournalSearchResultsScrollFrameButton"..i]

		button:StripTextures()
		button:CreateBackdrop()
		button.backdrop:SetOutside(button.icon)
		S:HandleButtonHighlight(button)

		button.icon:Point("TOPLEFT", 6, -7)
		button.icon:SetParent(button.backdrop)
	end

	local function SkinSearchUpdate()
		local offset = HybridScrollFrame_GetOffset(EncounterJournal.searchResults.scrollFrame)
		local results = EncounterJournal.searchResults.scrollFrame.buttons
		local numResults = EJ_GetNumSearchResults()

		for i = 1, #results do
			local result = results[i]
			local index = offset + i

			if index <= numResults then
				local _, _, _, _, _, itemID, stype = EncounterJournal_GetSearchDisplay(index)

				if stype == 4 then
					result.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
					result.handledHighlight:SetVertexColor(1, 1, 1)
					result.icon:SetTexCoord(0.16796875, 0.51171875, 0.03125, 0.71875)
				else
					if itemID then
						local r, g, b = GetItemQualityColor(select(3, GetItemInfo(itemID)))

						result.backdrop:SetBackdropBorderColor(r, g, b)
						result.handledHighlight:SetVertexColor(r, g, b)
					else
						result.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
						result.handledHighlight:SetVertexColor(1, 1, 1)
					end

					result.icon:SetTexCoord(unpack(E.TexCoords))
				end
			end
		end
	end
	hooksecurefunc("EncounterJournal_SearchUpdate", SkinSearchUpdate)
	hooksecurefunc("HybridScrollFrame_Update", SkinSearchUpdate)
end

S:AddCallbackForAddon("Blizzard_EncounterJournal", "EncounterJournal", LoadSkin)