local E, L, V, P, G = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

local _G = _G
local select, unpack, pairs = select, unpack, pairs

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.encounterjournal ~= true then return end

	local EJ = EncounterJournal
	EJ:StripTextures(true)
	EJ.inset:StripTextures(true)
	EJ:CreateBackdrop("Transparent")

	EJ.navBar:StripTextures(true)
	EJ.navBar.overlay:StripTextures(true)

	EJ.navBar:CreateBackdrop("Default")
	EJ.navBar.backdrop:Point("TOPLEFT", -2, 0)
	EJ.navBar.backdrop:Point("BOTTOMRIGHT")
	S:HandleButton(EJ.navBar.home, true)

	S:HandleEditBox(EJ.searchBox)
	S:HandleCloseButton(EncounterJournalCloseButton)

	--Instance Selection Frame
	local InstanceSelect = EJ.instanceSelect
	InstanceSelect.bg:Kill()
	S:HandleDropDownBox(InstanceSelect.tierDropDown)
	S:HandleScrollBar(InstanceSelect.scroll.ScrollBar, 4)

	--Dungeon/Raid Tabs
	InstanceSelect.dungeonsTab:StripTextures()
	InstanceSelect.dungeonsTab:CreateBackdrop("Default",true)
	InstanceSelect.dungeonsTab.backdrop:Point("TOPLEFT", 3, -7)
	InstanceSelect.dungeonsTab.backdrop:Point("BOTTOMRIGHT", -2, -1)
	InstanceSelect.dungeonsTab:Point("BOTTOMRIGHT", EncounterJournalInstanceSelectRaidTab, "BOTTOMLEFT", 0, 0)

	InstanceSelect.raidsTab:StripTextures()	
	InstanceSelect.raidsTab:CreateBackdrop("Default",true)
	InstanceSelect.raidsTab.backdrop:Point("TOPLEFT", 3, -7)
	InstanceSelect.raidsTab.backdrop:Point("BOTTOMRIGHT", -2, -1)

	--Encounter Info Frame
	local EncounterInfo = EJ.encounter.info
	EncounterJournalEncounterFrameInfoBG:Kill()

	EncounterInfo.difficulty:StripTextures()
	S:HandleButton(EncounterInfo.difficulty)
	EncounterInfo.difficulty:Width(100)
	EncounterJournalEncounterFrameInfoResetButton:StripTextures()

	S:HandleButton(EncounterJournalEncounterFrameInfoResetButton)
	EncounterJournalEncounterFrameInfoResetButtonTexture:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
	EncounterJournalEncounterFrameInfoResetButtonTexture:SetTexCoord(0.90625000, 0.94726563, 0.00097656, 0.02050781)

	EncounterJournalEncounterFrameModelFrame:StripTextures()
	EncounterJournalEncounterFrameModelFrame:CreateBackdrop('Transparent')

	local scrollFrames = {
		EncounterInfo.overviewScroll,
		EncounterInfo.lootScroll,
		EncounterInfo.detailsScroll,
	}

	for _, scrollFrame in pairs(scrollFrames) do
		scrollFrame:CreateBackdrop("Transparent")
	end

	EncounterInfo.lootScroll.filter:StripTextures()
	S:HandleButton(EncounterInfo.lootScroll.filter)

	EncounterInfo.detailsScroll.child.description:SetTextColor(1, 1, 1)

	EncounterInfo.lootTab:GetNormalTexture():SetTexture(nil)
	EncounterInfo.lootTab:GetPushedTexture():SetTexture(nil)
	EncounterInfo.lootTab:GetDisabledTexture():SetTexture(nil)
	EncounterInfo.lootTab:GetHighlightTexture():SetTexture(nil)
	EncounterInfo.lootTab:CreateBackdrop('Default')
	EncounterInfo.lootTab.backdrop:Point('TOPLEFT', 11, -8)
	EncounterInfo.lootTab.backdrop:Point('BOTTOMRIGHT', -6, 8)

	EncounterInfo.bossTab:GetNormalTexture():SetTexture(nil)
	EncounterInfo.bossTab:GetPushedTexture():SetTexture(nil)
	EncounterInfo.bossTab:GetDisabledTexture():SetTexture(nil)
	EncounterInfo.bossTab:GetHighlightTexture():SetTexture(nil)
	EncounterInfo.bossTab:CreateBackdrop('Default')
	EncounterInfo.bossTab.backdrop:Point('TOPLEFT', 11, -8)
	EncounterInfo.bossTab.backdrop:Point('BOTTOMRIGHT', -6, 8)

	--Encounter Instance Frame
	local EncounterInstance = EJ.encounter.instance

	EncounterInstance:CreateBackdrop("Transparent", true)
	EncounterInstance.loreScroll.child.lore:SetTextColor(1, 1, 1)

	EncounterJournalEncounterFrameInfoLootScrollFrameClassFilterClearFrame:StripTextures()

	EncounterJournalEncounterFrameInstanceFrameMapButton:StripTextures();
	S:HandleButton(EncounterJournalEncounterFrameInstanceFrameMapButton)
	EncounterJournalEncounterFrameInstanceFrameMapButton:ClearAllPoints()
	EncounterJournalEncounterFrameInstanceFrameMapButton:SetPoint("TOPLEFT", EncounterJournalEncounterFrameInstanceFrame, "TOPLEFT", 5, 37)
	EncounterJournalEncounterFrameInstanceFrameMapButton:SetSize(43, 32)
	EncounterJournalEncounterFrameInstanceFrameMapButtonText:ClearAllPoints()
	EncounterJournalEncounterFrameInstanceFrameMapButtonText:SetPoint("CENTER", EncounterJournalEncounterFrameInstanceFrameMapButton, "CENTER", 0, 0)

	--Class Filter Frame
	EncounterJournalEncounterFrameInfoLootScrollFrameClassFilterFrame:StripTextures()
	EncounterJournalEncounterFrameInfoLootScrollFrameClassFilterFrame:SetTemplate("Transparent")

	for i, class in ipairs(CLASS_SORT_ORDER) do
		local button =  _G["EncounterJournalEncounterFrameInfoLootScrollFrameClassFilterFrameClass"..i]
		button:StripTextures()
		button:CreateBackdrop("Default")
		S:HandleButton(button)
		button:StyleButton()

		local tcoords = CLASS_ICON_TCOORDS[class]
		local buttonIcon = button:GetNormalTexture()
		local buttonHighlight = button:GetHighlightTexture()
		local buttonPushed = button:GetPushedTexture()
		buttonIcon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
		buttonIcon:SetTexCoord(tcoords[1] + 0.023, tcoords[2] - 0.02, tcoords[3] + 0.018, tcoords[4] - 0.02)
		buttonHighlight:SetTexture()
		buttonPushed:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
		buttonPushed:SetTexCoord(tcoords[1] + 0.023, tcoords[2] - 0.02, tcoords[3] + 0.018, tcoords[4] - 0.02)
	end

	--Dungeon/raid selection buttons
	local function SkinDungeons()
		local b1 = EncounterJournalInstanceSelectScrollFrameScrollChildInstanceButton1
		if b1 and not b1.isSkinned then
			S:HandleButton(b1)
			b1.bgImage:SetInside()
			b1.bgImage:SetTexCoord(.08, .6, .08, .6)
			b1.bgImage:SetDrawLayer("ARTWORK")
			b1.isSkinned = true
		end

		for i = 1, 100 do
			local b = _G["EncounterJournalInstanceSelectScrollFrameinstance"..i]
			if b and not b.isSkinned then
				S:HandleButton(b)
				b.bgImage:SetInside()
				b.bgImage:SetTexCoord(0.08,.6,0.08,.6)
				b.bgImage:SetDrawLayer("ARTWORK")
				b.isSkinned = true
			end
		end
	end
	hooksecurefunc("EncounterJournal_ListInstances", SkinDungeons)
	EncounterJournal_ListInstances()


	--Boss selection buttons
	local function SkinBosses()
		local bossIndex = 1;
		local name, description, bossID, _, link = EJ_GetEncounterInfoByIndex(bossIndex);
		local bossButton;

		while bossID do
			bossButton = _G["EncounterJournalBossButton"..bossIndex];
			if bossButton and not bossButton.isSkinned then
				S:HandleButton(bossButton)
				bossButton.isSkinned = true
			end

			bossIndex = bossIndex + 1;
			name, description, bossID, _, link = EJ_GetEncounterInfoByIndex(bossIndex);
		end
	end
	hooksecurefunc("EncounterJournal_DisplayInstance", SkinBosses)

	--Loot buttons
	local items = EncounterJournal.encounter.info.lootScroll.buttons
	for i = 1, #items do
		local item = items[i]

		item.boss:SetTextColor(1, 1, 1)
		item.boss:ClearAllPoints()
		item.boss:Point("BOTTOMLEFT", 4, 7)
		item.slot:SetTextColor(1, 1, 1)
		item.armorType:SetTextColor(1, 1, 1)
		item.armorType:ClearAllPoints()
		item.armorType:Point("BOTTOMRIGHT", item.name, "TOPLEFT", 264, -25)

		item.bossTexture:SetAlpha(0)
		item.bosslessTexture:SetAlpha(0)

		item.icon:SetSize(41, 41)
		item.icon:Point("TOPLEFT", 2, -2)

		S:HandleIcon(item.icon)
		item.icon:SetDrawLayer("OVERLAY")

		item:SetTemplate("Default");
		item:StyleButton()

		if i == 1 then
			item:ClearAllPoints()
			item:Point("TOPLEFT", EncounterInfo.lootScroll.scrollChild, "TOPLEFT", 5, 0)
		end
	end

	--Abilities Info (From Aurora)
	local function SkinAbilitiesInfo()
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
				header.button.bg:SetOutside(header.button.abilityIcon)
				header.button.bg:SetFrameLevel(header.button.bg:GetFrameLevel() - 1)
				header.button.abilityIcon:SetTexCoord(.08, .92, .08, .92)

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
	end
	hooksecurefunc("EncounterJournal_ToggleHeaders", SkinAbilitiesInfo)

	--Search Frame
	EncounterJournalSearchResultsScrollFrame:StripTextures();
	EncounterJournalSearchResultsScrollFrameScrollChild:StripTextures();

	for i=1, 9 do
		_G["EncounterJournalSearchResultsScrollFrameButton"..i]:StripTextures();
		_G["EncounterJournalSearchResultsScrollFrameButton"..i]:SetTemplate("Default")
		_G["EncounterJournalSearchResultsScrollFrameButton"..i]:StyleButton()
		_G["EncounterJournalSearchResultsScrollFrameButton"..i.."Icon"]:SetTexCoord(.08, .92, .08, .92)
		_G["EncounterJournalSearchResultsScrollFrameButton"..i.."Icon"]:Point("TOPLEFT", 1, -6)
		_G["EncounterJournalSearchResultsScrollFrameButton"..i]:CreateBackdrop()
		_G["EncounterJournalSearchResultsScrollFrameButton"..i].backdrop:SetOutside(_G["EncounterJournalSearchResultsScrollFrameButton"..i.."Icon"])
		_G["EncounterJournalSearchResultsScrollFrameButton"..i.."Icon"]:SetParent(_G["EncounterJournalSearchResultsScrollFrameButton"..i].backdrop)
	end

	for i=1, 5 do
		_G["EncounterJournalSearchBoxSearchButton"..i]:StripTextures();
		_G["EncounterJournalSearchBoxSearchButton"..i]:StyleButton()
		_G["EncounterJournalSearchBoxSearchButton"..i.."Icon"]:SetTexCoord(unpack(E.TexCoords))
		_G["EncounterJournalSearchBoxSearchButton"..i.."Icon"]:Point("TOPLEFT", 2, -2)
		_G["EncounterJournalSearchBoxSearchButton"..i]:CreateBackdrop()
	end

	S:HandleButton(EncounterJournalSearchBoxShowALL)

	EncounterJournalSearchResults:StripTextures();
	EncounterJournalSearchResults:SetTemplate("Transparent")

	S:HandleScrollBar(EncounterJournalSearchResultsScrollFrameScrollBar)
	S:HandleCloseButton(EncounterJournalSearchResultsCloseButton)

	S:HandleScrollBar(EncounterJournalInstanceSelectScrollFrameScrollBar, 4)
	S:HandleScrollBar(EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollBar, 4)
	S:HandleScrollBar(EncounterJournalEncounterFrameInfoLootScrollFrameScrollBar, 4)
	S:HandleScrollBar(EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollBar, 4)
	S:HandleScrollBar(EncounterJournalEncounterFrameInfoBossesScrollFrameScrollBar, 4)
end

S:RegisterSkin('Blizzard_EncounterJournal', LoadSkin)