﻿local E, L, V, P, G = unpack(select(2, ...))
local B = E:GetModule("Bags")
local TT = E:GetModule("Tooltip")
local Skins = E:GetModule("Skins")
local Search = E.Libs.ItemSearch

local _G = _G
local type, ipairs, pairs, unpack, select, pcall = type, ipairs, pairs, unpack, select, pcall
local tinsert, tremove, twipe, tmaxn = tinsert, tremove, wipe, table.maxn
local floor, ceil = math.floor, math.ceil
local format, sub, gsub = string.format, string.sub, string.gsub

local BankFrameItemButton_Update = BankFrameItemButton_Update
local BankFrameItemButton_UpdateLocked = BankFrameItemButton_UpdateLocked
local CloseBag, CloseBackpack, CloseBankFrame = CloseBag, CloseBackpack, CloseBankFrame
local CooldownFrame_SetTimer = CooldownFrame_SetTimer
local CreateFrame = CreateFrame
local DeleteCursorItem = DeleteCursorItem
local GameTooltip_Hide = GameTooltip_Hide
local GetBackpackCurrencyInfo = GetBackpackCurrencyInfo
local GetContainerItemCooldown = GetContainerItemCooldown
local GetContainerItemID = GetContainerItemID
local GetContainerItemInfo = GetContainerItemInfo
local GetContainerItemLink = GetContainerItemLink
local GetContainerItemQuestInfo = GetContainerItemQuestInfo
local GetContainerNumFreeSlots = GetContainerNumFreeSlots
local GetContainerNumSlots = GetContainerNumSlots
local GetCurrencyLink = GetCurrencyLink
local GetCurrentGuildBankTab = GetCurrentGuildBankTab
local GetCVarBool = GetCVarBool
local GetGuildBankItemLink = GetGuildBankItemLink
local GetGuildBankTabInfo = GetGuildBankTabInfo
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local GetMoney = GetMoney
local GetNumBankSlots = GetNumBankSlots
local GetScreenWidth, GetScreenHeight = GetScreenWidth, GetScreenHeight
local IsBagOpen, IsOptionFrameOpen = IsBagOpen, IsOptionFrameOpen
local IsModifiedClick = IsModifiedClick
local IsShiftKeyDown, IsControlKeyDown = IsShiftKeyDown, IsControlKeyDown
local PickupContainerItem = PickupContainerItem
local PlaySound = PlaySound
local PutItemInBackpack = PutItemInBackpack
local PutItemInBag = PutItemInBag
local SetItemButtonCount = SetItemButtonCount
local SetItemButtonDesaturated = SetItemButtonDesaturated
local SetItemButtonTexture = SetItemButtonTexture
local SetItemButtonTextureVertexColor = SetItemButtonTextureVertexColor
local ToggleFrame = ToggleFrame
local UseContainerItem = UseContainerItem

local BACKPACK_TOOLTIP = BACKPACK_TOOLTIP
local CONTAINER_OFFSET_X, CONTAINER_OFFSET_Y = CONTAINER_OFFSET_X, CONTAINER_OFFSET_Y
local CONTAINER_SCALE = CONTAINER_SCALE
local CONTAINER_SPACING, VISIBLE_CONTAINER_SPACING = CONTAINER_SPACING, VISIBLE_CONTAINER_SPACING
local CONTAINER_WIDTH = CONTAINER_WIDTH
local ITEM_ACCOUNTBOUND = ITEM_ACCOUNTBOUND
local ITEM_BIND_ON_EQUIP = ITEM_BIND_ON_EQUIP
local ITEM_BIND_ON_USE = ITEM_BIND_ON_USE
local ITEM_BNETACCOUNTBOUND = ITEM_BNETACCOUNTBOUND
local ITEM_SOULBOUND = ITEM_SOULBOUND
local MAX_CONTAINER_ITEMS = MAX_CONTAINER_ITEMS
local MAX_WATCHED_TOKENS = MAX_WATCHED_TOKENS
local NUM_BAG_FRAMES = NUM_BAG_FRAMES
local NUM_CONTAINER_FRAMES = NUM_CONTAINER_FRAMES
local SEARCH = SEARCH

local SEARCH_STRING = ""

function B:GetContainerFrame(arg)
	if type(arg) == "boolean" and arg == true then
		return B.BankFrame
	elseif type(arg) == "number" then
		if B.BankFrame then
			for _, bagID in ipairs(B.BankFrame.BagIDs) do
				if bagID == arg then
					return B.BankFrame
				end
			end
		end
	end

	return B.BagFrame
end

function B:Tooltip_Show()
	GameTooltip:SetOwner(self)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(self.ttText)

	if self.ttText2 then
		if self.ttText2desc then
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine(self.ttText2, self.ttText2desc, 1, 1, 1)
		else
			GameTooltip:AddLine(self.ttText2)
		end
	end

	if self.ttValue and self.ttValue() > 0 then
		GameTooltip:AddLine(E:FormatMoney(self.ttValue(), E.db.bags.moneyFormat, not E.db.bags.moneyCoins), 1, 1, 1)
	end

	GameTooltip:Show()
end

function B:DisableBlizzard()
	BankFrame:UnregisterAllEvents()

	for i = 1, NUM_CONTAINER_FRAMES do
		_G["ContainerFrame"..i]:Kill()
	end
end

function B:SearchReset()
	SEARCH_STRING = ""
end

function B:IsSearching()
	return SEARCH_STRING ~= "" and SEARCH_STRING ~= SEARCH
end

function B:UpdateSearch()
	local search = self:GetText()
	if self.Instructions then
		self.Instructions:SetShown(search == "")
	end

	local MIN_REPEAT_CHARACTERS = 3
	local prevSearch = SEARCH_STRING
	if #search > MIN_REPEAT_CHARACTERS then
		local repeatChar = true
		for i = 1, MIN_REPEAT_CHARACTERS, 1 do
			if sub(search, (0 - i), (0 - i)) ~= sub(search, (-1 - i), (-1 - i)) then
				repeatChar = false
				break
			end
		end

		if repeatChar then
			B:ResetAndClear()
			return
		end
	end

	--Keep active search term when switching between bank and reagent bank
	if search == SEARCH and prevSearch ~= "" then
		search = prevSearch
	elseif search == SEARCH then
		search = ""
	end

	SEARCH_STRING = search

	B:RefreshSearch()
	B:SetGuildBankSearch(SEARCH_STRING)
end

function B:OpenEditbox()
	B.BagFrame.detail:Hide()
	B.BagFrame.editBox:Show()
	B.BagFrame.editBox:SetText(SEARCH)
	B.BagFrame.editBox:HighlightText()
end

function B:ResetAndClear()
	B.BagFrame.editBox:SetText(SEARCH)
	B.BagFrame.editBox:ClearFocus()

	if B.BankFrame then
		B.BankFrame.editBox:SetText(SEARCH)
		B.BankFrame.editBox:ClearFocus()
	end

	B:SearchReset()
end

function B:SetSearch(query)
	local empty = #(gsub(query, " ", "")) == 0
	local method = Search.Matches
	if Search.Filters.tipPhrases.keywords[query] then
		method = Search.TooltipPhrase
		query = Search.Filters.tipPhrases.keywords[query]
	end

	for _, bagFrame in pairs(B.BagFrames) do
		for _, bagID in ipairs(bagFrame.BagIDs) do
			for slotID = 1, GetContainerNumSlots(bagID) do
				local _, _, _, _, _, _, link = GetContainerItemInfo(bagID, slotID)
				local button = bagFrame.Bags[bagID][slotID]
				local success, result = pcall(method, Search, link, query)

				if empty or (success and result) then
					SetItemButtonDesaturated(button, button.locked or button.junkDesaturate)
					button.searchOverlay:Hide()
					button:SetAlpha(1)
				else
					SetItemButtonDesaturated(button, 1)
					button.searchOverlay:Show()
					button:SetAlpha(0.5)
				end
			end
		end
	end
end

function B:SetGuildBankSearch(query)
	local empty = #(gsub(query, " ", "")) == 0
	local method = Search.Matches
	if Search.Filters.tipPhrases.keywords[query] then
		method = Search.TooltipPhrase
		query = Search.Filters.tipPhrases.keywords[query]
	end

	if GuildBankFrame and GuildBankFrame:IsShown() then
		local tab = GetCurrentGuildBankTab()
		local _, _, isViewable = GetGuildBankTabInfo(tab)

		if isViewable then
			for slotID = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
				local link = GetGuildBankItemLink(tab, slotID)
				--A column goes from 1-14, e.g. GuildBankColumn1Button14 (slotID 14) or GuildBankColumn2Button3 (slotID 17)
				local col = ceil(slotID / 14)
				local btn = (slotID % 14)
				if col == 0 then col = 1 end
				if btn == 0 then btn = 14 end
				local button = _G["GuildBankColumn"..col.."Button"..btn]
				local success, result = pcall(method, Search, link, query)
				if empty or (success and result) then
					SetItemButtonDesaturated(button, button.locked or button.junkDesaturate)
					button.searchOverlay:Hide()
					button:SetAlpha(1)
				else
					SetItemButtonDesaturated(button, 1)
					button.searchOverlay:Show()
					button:SetAlpha(0.5)
				end
			end
		end
	end
end

function B:UpdateItemLevelDisplay()
	if not E.private.bags.enable then return end

	local font = E.Libs.LSM:Fetch("font", E.db.bags.itemLevelFont)

	for _, bagFrame in pairs(B.BagFrames) do
		for _, bagID in ipairs(bagFrame.BagIDs) do
			for slotID = 1, GetContainerNumSlots(bagID) do
				local slot = bagFrame.Bags[bagID][slotID]
				if slot and slot.itemLevel then
					slot.itemLevel:FontTemplate(font, E.db.bags.itemLevelFontSize, E.db.bags.itemLevelFontOutline)
				end
			end
		end

		B:UpdateAllSlots(bagFrame)
	end
end

function B:UpdateCountDisplay()
	if not E.private.bags.enable then return end

	local font = E.Libs.LSM:Fetch("font", E.db.bags.countFont)

	for _, bagFrame in pairs(B.BagFrames) do
		for _, bagID in ipairs(bagFrame.BagIDs) do
			for slotID = 1, GetContainerNumSlots(bagID) do
				local slot = bagFrame.Bags[bagID][slotID]
				if slot and slot.Count then
					slot.Count:FontTemplate(font, E.db.bags.countFontSize, E.db.bags.countFontOutline)
				end
			end
		end

		B:UpdateAllSlots(bagFrame)
	end
end

function B:UpdateBagTypes(isBank)
	local f = B:GetContainerFrame(isBank)
	for _, bagID in ipairs(f.BagIDs) do
		if f.Bags[bagID] then
			f.Bags[bagID].type = select(2, GetContainerNumFreeSlots(bagID))
		end
	end
end

function B:UpdateAllBagSlots()
	if not E.private.bags.enable then return end

	for _, bagFrame in pairs(B.BagFrames) do
		B:UpdateAllSlots(bagFrame)
	end
end

local function ColorizeProfessionBagSlots(slot, profR, profG, profB, qualityR, qualityG, qualityB)
	local fadeR, fadeG, fadeB, fadeA = unpack(E.media.backdropfadecolor)

	if B.db.professionBagColorsStyle == "BACKDROP" or B.db.professionBagColorsStyle == "BOTH" then
		local mult = B.db.professionBagColorsMult
		if E.db.bags.transparent then
			slot:SetBackdropColor(profR * mult, profG * mult, profB * mult, fadeA)
		else
			slot.backdropTexture:SetVertexColor(profR * mult, profG * mult, profB * mult, 1)
		end
	else
		if E.db.bags.transparent then
			slot:SetBackdropColor(fadeR, fadeG, fadeB, fadeA)
		else
			slot.backdropTexture:SetVertexColor(unpack(E.media.backdropcolor))
		end
	end

	if B.db.professionBagColorsStyle == "BORDER" or B.db.professionBagColorsStyle == "BOTH" then
		slot:SetBackdropBorderColor(profR, profG, profB)
		slot.ignoreBorderColors = true
	else
		if B.db.qualityColors and (slot.rarity and slot.rarity > 1) then
			slot:SetBackdropBorderColor(qualityR, qualityG, qualityB)
			slot.ignoreBorderColors = true
		else
			slot:SetBackdropBorderColor(unpack(E.media.bordercolor))
			slot.ignoreBorderColors = nil
		end
	end
end

function B:UpdateSlot(frame, bagID, slotID)
	if (frame.Bags[bagID] and frame.Bags[bagID].numSlots ~= GetContainerNumSlots(bagID)) or not frame.Bags[bagID] or not frame.Bags[bagID][slotID] then return end

	local slot = frame.Bags[bagID][slotID]
	local bagType = frame.Bags[bagID].type
	local texture, count, locked, _, readable = GetContainerItemInfo(bagID, slotID)
	local link = GetContainerItemLink(bagID, slotID)

	slot.name, slot.rarity, slot.locked, slot.readable, slot.isJunk, slot.junkDesaturate = nil, nil, locked, readable, nil, nil

	slot:Show()
	slot.questIcon:Hide()
	slot.JunkIcon:Hide()
	slot.itemLevel:SetText("")
	slot.bindType:SetText("")

	local borderR, borderG, borderB = unpack(E.media.bordercolor)
	local fadeR, fadeG, fadeB, fadeA = unpack(E.media.backdropfadecolor)
	local backdropR, backdropG, backdropB = unpack(E.media.backdropcolor)

	if link then
		local name, _, itemRarity, iLvl, _, iType, _, _, itemEquipLoc, _, itemPrice = GetItemInfo(link)
		local isQuestItem, questId, isActiveQuest = GetContainerItemQuestInfo(bagID, slotID)
		local qualityR, qualityG, qualityB

		slot.name = name
		slot.rarity = itemRarity
		slot.isJunk = (slot.rarity and slot.rarity == 0) and (itemPrice and itemPrice > 0) and (iType and iType ~= "Quest")
		slot.junkDesaturate = slot.isJunk and B.db.junkDesaturate

		if slot.rarity then
			qualityR, qualityG, qualityB = GetItemQualityColor(slot.rarity)
		end

		if B.db.showBindType and (slot.rarity and slot.rarity > 1) then
			local bindTypeLines = GetCVarBool("colorblindmode") and 8 or 7
			local BoE, BoU

			E.ScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
			if slot.GetInventorySlot then -- this fixes bank bagid -1
				E.ScanTooltip:SetInventoryItem("player", slot:GetInventorySlot())
			else
				E.ScanTooltip:SetBagItem(bagID, slotID)
			end
			E.ScanTooltip:Show()

			for i = 2, bindTypeLines do
				local line = _G["ElvUI_ScanTooltipTextLeft"..i]:GetText()
				if (not line or line == "") or (line == ITEM_SOULBOUND or line == ITEM_ACCOUNTBOUND or line == ITEM_BNETACCOUNTBOUND) then break end

				BoE, BoU = line == ITEM_BIND_ON_EQUIP, line == ITEM_BIND_ON_USE

				if not B.db.showBindType and (slot.rarity and slot.rarity > 1) or (BoE or BoU) then break end
			end

			E.ScanTooltip:Hide()

			if BoE or BoU then
				slot.bindType:SetText(BoE and L["BoE"] or L["BoU"])
				slot.bindType:SetVertexColor(qualityR, qualityG, qualityB)
			end
		end

		-- Item Level
		if iLvl and B.db.itemLevel and (itemEquipLoc ~= nil and itemEquipLoc ~= "" and itemEquipLoc ~= "INVTYPE_BAG" and itemEquipLoc ~= "INVTYPE_QUIVER" and itemEquipLoc ~= "INVTYPE_TABARD") and (slot.rarity and slot.rarity > 1) and iLvl >= B.db.itemLevelThreshold then
			slot.itemLevel:SetText(iLvl)
			if B.db.itemLevelCustomColorEnable then
				slot.itemLevel:SetTextColor(B.db.itemLevelCustomColor.r, B.db.itemLevelCustomColor.g, B.db.itemLevelCustomColor.b)
			else
				slot.itemLevel:SetTextColor(qualityR, qualityG, qualityB)
			end
		end

		-- Junk Icon
		if B.db.junkIcon and slot.isJunk then
			slot.JunkIcon:Show()
		end

		-- Quest Icon
		if B.db.questIcon and (questId and not isActiveQuest) then
			slot.questIcon:Show()
		end

		local color = B.db.countFontColor
		slot.Count:SetTextColor(color.r, color.g, color.b)

		if B.db.professionBagColors and B.ProfessionColors[bagType] then -- Profession Bags with Item
			local profR, profG, profB = unpack(B.ProfessionColors[bagType])
			ColorizeProfessionBagSlots(slot, profR, profG, profB, qualityR, qualityG, qualityB)
		elseif B.db.questItemColors and (questId and not isActiveQuest) then -- Quest Starter Item
			slot:SetBackdropBorderColor(unpack(B.QuestColors.questStarter))
			slot.ignoreBorderColors = true
		elseif B.db.questItemColors and (questId or isQuestItem) then -- Quest Item
			slot:SetBackdropBorderColor(unpack(B.QuestColors.questItem))
			slot.ignoreBorderColors = true
		elseif B.db.qualityColors and (slot.rarity and slot.rarity > 1) then -- Color slot according to item quality
			slot:SetBackdropBorderColor(qualityR, qualityG, qualityB)
			slot.ignoreBorderColors = true
		else
			slot:SetBackdropBorderColor(borderR, borderG, borderB)
			slot.ignoreBorderColors = nil
		end

		if B.db.transparent then
			slot:SetBackdropColor(fadeR, fadeG, fadeB, fadeA)
		else
			slot.backdropTexture:SetVertexColor(backdropR, backdropG, backdropB)
		end
	else
		if B.db.professionBagColors and B.ProfessionColors[bagType] then -- Profession Bags without Item
			local profR, profG, profB = unpack(B.ProfessionColors[bagType])
			ColorizeProfessionBagSlots(slot, profR, profG, profB)
		else -- Empty
			if B.db.transparent then
				slot:SetBackdropColor(fadeR, fadeG, fadeB, fadeA)
			else
				slot.backdropTexture:SetVertexColor(backdropR, backdropG, backdropB)
			end

			slot:SetBackdropBorderColor(borderR, borderG, borderB)
			slot.ignoreBorderColors = nil
		end
	end

	if texture then
		local start, duration, enable = GetContainerItemCooldown(bagID, slotID)
		CooldownFrame_SetTimer(slot.cooldown, start, duration, enable)
		if duration > 0 and enable == 0 then
			SetItemButtonTextureVertexColor(slot, 0.4, 0.4, 0.4)
		else
			SetItemButtonTextureVertexColor(slot, 1, 1, 1)
		end
		slot.hasItem = 1
	else
		slot.cooldown:Hide()
		slot.hasItem = nil
	end

	SetItemButtonTexture(slot, texture)
	SetItemButtonCount(slot, count)
	SetItemButtonDesaturated(slot, slot.locked or slot.junkDesaturate)

	if GameTooltip:GetOwner() == slot and not slot.hasItem then
		GameTooltip_Hide()
	end
end

function B:UpdateBagSlots(frame, bagID)
	for slotID = 1, GetContainerNumSlots(bagID) do
		B:UpdateSlot(frame, bagID, slotID)
	end
end

function B:RefreshSearch()
	B:SetSearch(SEARCH_STRING)
end

function B:SortingFadeBags(bagFrame, registerUpdate)
	if not (bagFrame and bagFrame.BagIDs) then return end
	bagFrame.registerUpdate = registerUpdate

	for _, bagID in ipairs(bagFrame.BagIDs) do
		for slotID = 1, GetContainerNumSlots(bagID) do
			local button = bagFrame.Bags[bagID][slotID]
			SetItemButtonDesaturated(button, 1)
			button.searchOverlay:Show()
			button:SetAlpha(0.5)
		end
	end
end

function B:UpdateCooldowns(frame)
	if not (frame and frame.BagIDs) then return end

	for _, bagID in ipairs(frame.BagIDs) do
		for slotID = 1, GetContainerNumSlots(bagID) do
			local start, duration, enable = GetContainerItemCooldown(bagID, slotID)
			CooldownFrame_SetTimer(frame.Bags[bagID][slotID].cooldown, start, duration, enable)
		end
	end
end

function B:UpdateAllSlots(frame)
	if not (frame and frame.BagIDs) then return end

	for _, bagID in ipairs(frame.BagIDs) do
		local bag = frame.Bags[bagID]
		if bag then B:UpdateBagSlots(frame, bagID) end
	end

	-- Refresh search in case we moved items around
	if not frame.registerUpdate and B:IsSearching() then
		B:RefreshSearch()
	end
end

function B:SetSlotAlphaForBag(f)
	for _, bagID in ipairs(f.BagIDs) do
		if f.Bags[bagID] then
			for slotID = 1, GetContainerNumSlots(bagID) do
				if f.Bags[bagID][slotID] then
					if bagID == self.id then
						f.Bags[bagID][slotID]:SetAlpha(1)
					else
						f.Bags[bagID][slotID]:SetAlpha(0.1)
					end
				end
			end
		end
	end
end

function B:ResetSlotAlphaForBags(f)
	for _, bagID in ipairs(f.BagIDs) do
		if f.Bags[bagID] then
			for slotID = 1, GetContainerNumSlots(bagID) do
				if f.Bags[bagID][slotID] then
					f.Bags[bagID][slotID]:SetAlpha(1)
				end
			end
		end
	end
end

function B:Layout(isBank)
	if not E.private.bags.enable then return end

	local f = B:GetContainerFrame(isBank)
	if not f then return end

	local buttonSize = isBank and B.db.bankSize or B.db.bagSize
	local buttonSpacing = isBank and B.db.bankButtonSpacing or B.db.bagButtonSpacing
	local containerWidth = ((isBank and B.db.bankWidth) or B.db.bagWidth)
	local numContainerColumns = floor(containerWidth / (buttonSize + buttonSpacing))
	local holderWidth = ((buttonSize + buttonSpacing) * numContainerColumns) - buttonSpacing
	local numContainerRows, numBags, numBagSlots = 0, 0, 0
	local bagSpacing = isBank and B.db.split.bankSpacing or B.db.split.bagSpacing
	local countColor = E.db.bags.countFontColor
	local isSplit = B.db.split[isBank and "bank" or "player"]

	f.holderFrame:Width(holderWidth)

	f.totalSlots = 0
	local lastButton, lastRowButton, lastContainerButton, newBag
	local numContainerSlots = GetNumBankSlots()

	for i, bagID in ipairs(f.BagIDs) do
		if isSplit then
			newBag = (bagID ~= -1 or bagID ~= 0) and B.db.split["bag"..bagID] or false
		end

		--Bag Containers
		if (not isBank) or (isBank and bagID ~= -1 and numContainerSlots >= 1 and not (i - 1 > numContainerSlots)) then
			if not f.ContainerHolder[i] then
				if isBank then
					f.ContainerHolder[i] = CreateFrame("CheckButton", "ElvUIBankBag"..bagID - 4, f.ContainerHolder, "BankItemButtonBagTemplate")
					f.ContainerHolder[i]:SetScript("OnClick", function(holder)
						local inventoryID = holder:GetInventorySlot()
						PutItemInBag(inventoryID)
					end)
				else
					if bagID == 0 then
						f.ContainerHolder[i] = CreateFrame("CheckButton", "ElvUIMainBagBackpack", f.ContainerHolder, "ItemButtonTemplate")

						f.ContainerHolder[i].model = CreateFrame("Model", "$parentItemAnim", f.ContainerHolder[i], "ItemAnimTemplate")
						f.ContainerHolder[i].model:SetPoint("BOTTOMRIGHT", -10, 0)

						f.ContainerHolder[i]:SetScript("OnClick", function()
							PutItemInBackpack()
						end)
						f.ContainerHolder[i]:SetScript("OnReceiveDrag", function()
							PutItemInBackpack()
						end)
						f.ContainerHolder[i]:SetScript("OnEnter", function(holder)
							GameTooltip:SetOwner(holder, "ANCHOR_LEFT")
							GameTooltip:SetText(BACKPACK_TOOLTIP, 1, 1, 1)
							GameTooltip:Show()
						end)
						f.ContainerHolder[i]:SetScript("OnLeave", GameTooltip_Hide)
					else
						f.ContainerHolder[i] = CreateFrame("CheckButton", "ElvUIMainBag"..(bagID - 1).."Slot", f.ContainerHolder, "BagSlotButtonTemplate")
						f.ContainerHolder[i]:SetScript("OnClick", function(holder)
							local id = holder:GetID()
							PutItemInBag(id)
						end)
					end
				end

				f.ContainerHolder[i]:SetTemplate(E.db.bags.transparent and "Transparent", true)
				f.ContainerHolder[i]:StyleButton()
				f.ContainerHolder[i]:SetNormalTexture("")
				f.ContainerHolder[i]:SetCheckedTexture(nil)
				f.ContainerHolder[i]:SetPushedTexture("")
				f.ContainerHolder[i].id = bagID
				f.ContainerHolder[i]:HookScript("OnEnter", function(ch) B.SetSlotAlphaForBag(ch, f) end)
				f.ContainerHolder[i]:HookScript("OnLeave", function(ch) B.ResetSlotAlphaForBags(ch, f) end)

				if isBank then
					f.ContainerHolder[i]:SetID(bagID)
					if not f.ContainerHolder[i].tooltipText then
						f.ContainerHolder[i].tooltipText = ""
					end
				end

				f.ContainerHolder[i].iconTexture = _G[f.ContainerHolder[i]:GetName().."IconTexture"]
				if bagID == 0 then
					f.ContainerHolder[i].iconTexture:SetTexture("Interface\\Buttons\\Button-Backpack-Up")
				end
				f.ContainerHolder[i].iconTexture:SetInside()
				f.ContainerHolder[i].iconTexture:SetTexCoord(unpack(E.TexCoords))
			end

			f.ContainerHolder:Size(((buttonSize + buttonSpacing) * (isBank and i - 1 or i)) + buttonSpacing, buttonSize + (buttonSpacing * 2))

			if isBank then
				BankFrameItemButton_Update(f.ContainerHolder[i])
				BankFrameItemButton_UpdateLocked(f.ContainerHolder[i])
			end

			f.ContainerHolder[i]:Size(buttonSize)
			f.ContainerHolder[i]:ClearAllPoints()
			if (isBank and i == 2) or (not isBank and i == 1) then
				f.ContainerHolder[i]:Point("BOTTOMLEFT", f.ContainerHolder, "BOTTOMLEFT", buttonSpacing, buttonSpacing)
			else
				f.ContainerHolder[i]:Point("LEFT", lastContainerButton, "RIGHT", buttonSpacing, 0)
			end

			lastContainerButton = f.ContainerHolder[i]
		end

		--Bag Slots
		local numSlots = GetContainerNumSlots(bagID)
		if numSlots > 0 then
			if not f.Bags[bagID] then
				f.Bags[bagID] = CreateFrame("Frame", f:GetName().."Bag"..bagID, f.holderFrame)
				f.Bags[bagID]:SetID(bagID)
			end

			f.Bags[bagID].numSlots = numSlots
			f.Bags[bagID].type = select(2, GetContainerNumFreeSlots(bagID))

			--Hide unused slots
			for y = 1, MAX_CONTAINER_ITEMS do
				if f.Bags[bagID][y] then
					f.Bags[bagID][y]:Hide()
				end
			end

			for slotID = 1, numSlots do
				f.totalSlots = f.totalSlots + 1
				if not f.Bags[bagID][slotID] then
					f.Bags[bagID][slotID] = CreateFrame("CheckButton", f.Bags[bagID]:GetName().."Slot"..slotID, f.Bags[bagID], bagID == -1 and "BankItemButtonGenericTemplate" or "ContainerFrameItemButtonTemplate")
					f.Bags[bagID][slotID]:StyleButton()
					f.Bags[bagID][slotID]:SetTemplate(E.db.bags.transparent and "Transparent", true)
					f.Bags[bagID][slotID]:SetNormalTexture(nil)
					f.Bags[bagID][slotID]:SetCheckedTexture(nil)

					f.Bags[bagID][slotID].Count = _G[f.Bags[bagID][slotID]:GetName().."Count"]
					f.Bags[bagID][slotID].Count:ClearAllPoints()
					f.Bags[bagID][slotID].Count:Point("BOTTOMRIGHT", -1, 3)
					f.Bags[bagID][slotID].Count:FontTemplate(E.Libs.LSM:Fetch("font", E.db.bags.countFont), E.db.bags.countFontSize, E.db.bags.countFontOutline)
					f.Bags[bagID][slotID].Count:SetTextColor(countColor.r, countColor.g, countColor.b)

					if not f.Bags[bagID][slotID].questIcon then
						f.Bags[bagID][slotID].questIcon = _G[f.Bags[bagID][slotID]:GetName().."IconQuestTexture"] or _G[f.Bags[bagID][slotID]:GetName()].IconQuestTexture
						f.Bags[bagID][slotID].questIcon:SetTexture(E.Media.Textures.BagQuestIcon)
						f.Bags[bagID][slotID].questIcon:SetTexCoord(0, 1, 0, 1)
						f.Bags[bagID][slotID].questIcon:SetInside()
						f.Bags[bagID][slotID].questIcon:Hide()
					end

					if not f.Bags[bagID][slotID].JunkIcon then
						local JunkIcon = f.Bags[bagID][slotID]:CreateTexture(nil, "OVERLAY")
						JunkIcon:SetTexture(E.Media.Textures.BagJunkIcon)
						JunkIcon:Point("TOPLEFT", 1, 0)
						JunkIcon:Hide()
						f.Bags[bagID][slotID].JunkIcon = JunkIcon
					end

					f.Bags[bagID][slotID].iconTexture = _G[f.Bags[bagID][slotID]:GetName().."IconTexture"]
					f.Bags[bagID][slotID].iconTexture:SetInside(f.Bags[bagID][slotID])
					f.Bags[bagID][slotID].iconTexture:SetTexCoord(unpack(E.TexCoords))

					f.Bags[bagID][slotID].searchOverlay:SetAllPoints()

					f.Bags[bagID][slotID].cooldown = _G[f.Bags[bagID][slotID]:GetName().."Cooldown"]
					f.Bags[bagID][slotID].cooldown.CooldownOverride = "bags"
					E:RegisterCooldown(f.Bags[bagID][slotID].cooldown)
					f.Bags[bagID][slotID].bagID = bagID
					f.Bags[bagID][slotID].slotID = slotID

					f.Bags[bagID][slotID].itemLevel = f.Bags[bagID][slotID]:CreateFontString(nil, "ARTWORK")
					f.Bags[bagID][slotID].itemLevel:Point("BOTTOMRIGHT", -1, 3)
					f.Bags[bagID][slotID].itemLevel:FontTemplate(E.Libs.LSM:Fetch("font", E.db.bags.itemLevelFont), E.db.bags.itemLevelFontSize, E.db.bags.itemLevelFontOutline)

					f.Bags[bagID][slotID].bindType = f.Bags[bagID][slotID]:CreateFontString(nil, "ARTWORK")
					f.Bags[bagID][slotID].bindType:Point("TOP", 0, -2)
					f.Bags[bagID][slotID].bindType:FontTemplate(E.Libs.LSM:Fetch("font", E.db.bags.itemLevelFont), E.db.bags.itemLevelFontSize, E.db.bags.itemLevelFontOutline)
				end

				f.Bags[bagID][slotID]:SetID(slotID)
				f.Bags[bagID][slotID]:Size(buttonSize)

				if f.Bags[bagID][slotID].JunkIcon then
					f.Bags[bagID][slotID].JunkIcon:Size(buttonSize / 2)
				end

				B:UpdateSlot(f, bagID, slotID)

				if f.Bags[bagID][slotID]:GetPoint() then
					f.Bags[bagID][slotID]:ClearAllPoints()
				end

				if lastButton then
					local anchorPoint, relativePoint = (B.db.reverseSlots and "BOTTOM" or "TOP"), (B.db.reverseSlots and "TOP" or "BOTTOM")
					if isSplit and newBag and slotID == 1 then
						f.Bags[bagID][slotID]:Point(anchorPoint, lastRowButton, relativePoint, 0, B.db.reverseSlots and (buttonSpacing + bagSpacing) or -(buttonSpacing + bagSpacing))
						lastRowButton = f.Bags[bagID][slotID]
						numContainerRows = numContainerRows + 1
						numBags = numBags + 1
						numBagSlots = 0
					elseif isSplit and numBagSlots % numContainerColumns == 0 then
						f.Bags[bagID][slotID]:Point(anchorPoint, lastRowButton, relativePoint, 0, B.db.reverseSlots and buttonSpacing or -buttonSpacing)
						lastRowButton = f.Bags[bagID][slotID]
						numContainerRows = numContainerRows + 1
					elseif (not isSplit) and (f.totalSlots - 1) % numContainerColumns == 0 then
						f.Bags[bagID][slotID]:Point(anchorPoint, lastRowButton, relativePoint, 0, B.db.reverseSlots and buttonSpacing or -buttonSpacing)
						lastRowButton = f.Bags[bagID][slotID]
						numContainerRows = numContainerRows + 1
					else
						anchorPoint, relativePoint = (B.db.reverseSlots and "RIGHT" or "LEFT"), (B.db.reverseSlots and "LEFT" or "RIGHT")
						f.Bags[bagID][slotID]:Point(anchorPoint, lastButton, relativePoint, B.db.reverseSlots and -buttonSpacing or buttonSpacing, 0)
					end
				else
					local anchorPoint = B.db.reverseSlots and "BOTTOMRIGHT" or "TOPLEFT"
					f.Bags[bagID][slotID]:Point(anchorPoint, f.holderFrame, anchorPoint, 0, B.db.reverseSlots and f.bottomOffset - 8 or 0)
					lastRowButton = f.Bags[bagID][slotID]
					numContainerRows = numContainerRows + 1
				end

				lastButton = f.Bags[bagID][slotID]
				numBagSlots = numBagSlots + 1
			end
		else
			--Hide unused slots
			for y = 1, MAX_CONTAINER_ITEMS do
				if f.Bags[bagID] and f.Bags[bagID][y] then
					f.Bags[bagID][y]:Hide()
				end
			end

			if f.Bags[bagID] then
				f.Bags[bagID].numSlots = numSlots
			end

			local container = isBank and f.ContainerHolder[i]
			if container then
				BankFrameItemButton_Update(container)
				BankFrameItemButton_UpdateLocked(container)
			end
		end
	end

	f:Size(containerWidth, (((buttonSize + buttonSpacing) * numContainerRows) - buttonSpacing) + (isSplit and (numBags * bagSpacing) or 0) + f.topOffset + f.bottomOffset) -- 8 is the cussion of the f.holderFrame
end

function B:UpdateAll()
	if B.BagFrame then B:Layout() end
	if B.BankFrame then B:Layout(true) end
end

function B:OnEvent(event, ...)
	if event == "ITEM_LOCK_CHANGED" or event == "ITEM_UNLOCKED" then
		local bag, slot = ...
		B:UpdateSlot(self, bag, slot)
	elseif event == "BAG_UPDATE" then
		for _, bagID in ipairs(self.BagIDs) do
			local numSlots = GetContainerNumSlots(bagID)
			if (not self.Bags[bagID] and numSlots ~= 0) or (self.Bags[bagID] and numSlots ~= self.Bags[bagID].numSlots) then
				B:Layout(self.isBank)
				return
			end
		end

		B:UpdateBagTypes()
		B:UpdateBagSlots(self, ...)

		--Refresh search in case we moved items around
		if B:IsSearching() then B:RefreshSearch() end
	elseif event == "BAG_UPDATE_COOLDOWN" then
		if not self:IsShown() then return end

		B:UpdateCooldowns(self)
	elseif event == "PLAYERBANKSLOTS_CHANGED" then
		B:UpdateBagTypes()
		B:UpdateBagSlots(self, -1)
	elseif (event == "QUEST_ACCEPTED" or event == "QUEST_REMOVED" or event == "QUEST_LOG_UPDATE") and self:IsShown() then
		B:UpdateAllSlots(self)
	end
end

function B:UpdateTokens()
	local f = B.BagFrame
	local numTokens = 0

	for _, button in ipairs(f.currencyButton) do
		button:Hide()
	end

	for i = 1, MAX_WATCHED_TOKENS do
		local name, count, icon, currencyID = GetBackpackCurrencyInfo(i)
		if not name then break end

		local button = f.currencyButton[i]
		button:ClearAllPoints()
		button.icon:SetTexture(icon)

		if B.db.currencyFormat == "ICON_TEXT" then
			button.text:SetText(name..": "..count)
		elseif B.db.currencyFormat == "ICON_TEXT_ABBR" then
			button.text:SetText(E:AbbreviateString(name)..": "..count)
		elseif B.db.currencyFormat == "ICON" then
			button.text:SetText(count)
		end

		button.currencyID = currencyID
		button:Show()
		numTokens = numTokens + 1
	end

	if numTokens == 0 then
		if f.bottomOffset > 8 then
			f.bottomOffset = 8
			B:Layout()
		end
	else
		if f.bottomOffset < 28 then
			f.bottomOffset = 28
			B:Layout()
		end

		if numTokens == 1 then
			f.currencyButton[1]:Point("BOTTOM", f.currencyButton, "BOTTOM", -(f.currencyButton[1].text:GetWidth() / 2), 3)
		elseif numTokens == 2 then
			f.currencyButton[1]:Point("BOTTOM", f.currencyButton, "BOTTOM", -(f.currencyButton[1].text:GetWidth()) - (f.currencyButton[1]:GetWidth() / 2), 3)
			f.currencyButton[2]:Point("BOTTOMLEFT", f.currencyButton, "BOTTOM", f.currencyButton[2]:GetWidth() / 2, 3)
		else
			f.currencyButton[1]:Point("BOTTOMLEFT", f.currencyButton, "BOTTOMLEFT", 3, 3)
			f.currencyButton[2]:Point("BOTTOM", f.currencyButton, "BOTTOM", -(f.currencyButton[2].text:GetWidth() / 3), 3)
			f.currencyButton[3]:Point("BOTTOMRIGHT", f.currencyButton, "BOTTOMRIGHT", -(f.currencyButton[3].text:GetWidth()) - (f.currencyButton[3]:GetWidth() / 2), 3)
		end
	end
end

function B:Token_OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetBackpackToken(self:GetID())
end

function B:Token_OnClick()
	if IsModifiedClick("CHATLINK") then
		HandleModifiedItemClick(GetCurrencyLink(self.currencyID))
	end
end

function B:UpdateGoldText()
	B.BagFrame.goldText:SetText(E:FormatMoney(GetMoney(), E.db.bags.moneyFormat, not E.db.bags.moneyCoins))

	local goldPos = E.db.bags.moneyCoins and (E.db.bags.moneyFormat == "SMART" or E.db.bags.moneyFormat == "FULL" or E.db.bags.moneyFormat == "BLIZZARD")
	B.BagFrame.goldText:Point("BOTTOMRIGHT", B.BagFrame.holderFrame, "TOPRIGHT", goldPos and -8 or -2, 4)
end

function B:GetGraysValue()
	local value = 0

	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemID = GetContainerItemID(bag, slot)
			if itemID then
				local _, _, rarity, _, _, iType, _, _, _, _, itemPrice = GetItemInfo(itemID)
				if itemPrice and itemPrice > 0 then
					local stackCount = select(2, GetContainerItemInfo(bag, slot)) or 1
					local stackPrice = itemPrice * stackCount
					if (rarity and rarity == 0) and (iType and iType ~= "Quest") then
						value = value + stackPrice
					end
				end
			end
		end
	end

	return value
end

function B:VendorGrays(delete)
	if B.SellFrame:IsShown() then return end

	if (not MerchantFrame or not MerchantFrame:IsShown()) and not delete then
		E:Print(L["You must be at a vendor."])
		return
	end

	for bag = 0, 4, 1 do
		for slot = 1, GetContainerNumSlots(bag), 1 do
			local itemID = GetContainerItemID(bag, slot)
			if itemID then
				local _, name, rarity, _, _, iType, _, _, _, _, itemPrice = GetItemInfo(itemID)

				if (rarity and rarity == 0) and (iType and iType ~= "Quest") and (itemPrice and itemPrice > 0) then
					tinsert(B.SellFrame.Info.itemList, {bag, slot, itemPrice, name})
				end
			end
		end
	end

	if not B.SellFrame.Info.itemList or tmaxn(B.SellFrame.Info.itemList) < 1 then return end

	--Resetting stuff
	B.SellFrame.Info.delete = delete or false
	B.SellFrame.Info.ProgressTimer = 0
	B.SellFrame.Info.SellInterval = E.db.bags.vendorGrays.interval
	B.SellFrame.Info.ProgressMax = tmaxn(B.SellFrame.Info.itemList)
	B.SellFrame.Info.goldGained = 0
	B.SellFrame.Info.itemsSold = 0

	B.SellFrame.statusbar:SetValue(0)
	B.SellFrame.statusbar:SetMinMaxValues(0, B.SellFrame.Info.ProgressMax)
	B.SellFrame.statusbar.ValueText:SetText("0 / "..B.SellFrame.Info.ProgressMax)

	--Time to sell
	B.SellFrame:Show()
end

function B:VendorGrayCheck()
	local value = B:GetGraysValue()

	if value == 0 then
		E:Print(L["No gray items to delete."])
	elseif not MerchantFrame or not MerchantFrame:IsShown() then
		E.PopupDialogs.DELETE_GRAYS.Money = value
		E:StaticPopup_Show("DELETE_GRAYS")
	else
		B:VendorGrays()
	end
end

function B:SetButtonTexture(button, texture)
	button:SetNormalTexture(texture)
	button:SetPushedTexture(texture)
	button:SetDisabledTexture(texture)

	local Normal, Pushed, Disabled = button:GetNormalTexture(), button:GetPushedTexture(), button:GetDisabledTexture()

	Normal:SetTexCoord(unpack(E.TexCoords))
	Normal:SetInside()

	Pushed:SetTexCoord(unpack(E.TexCoords))
	Pushed:SetInside()

	Disabled:SetTexCoord(unpack(E.TexCoords))
	Disabled:SetInside()
	Disabled:SetDesaturated(true)
end

function B:ConstructContainerFrame(name, isBank)
	local strata = E.db.bags.strata or "DIALOG"

	local f = CreateFrame("Button", name, E.UIParent)
	f:SetTemplate("Transparent")
	f:SetFrameStrata(strata)

	f.events = isBank and {"PLAYERBANKSLOTS_CHANGED"} or {"ITEM_LOCK_CHANGED", "ITEM_UNLOCKED", "QUEST_ACCEPTED", "QUEST_REMOVED", "QUEST_LOG_UPDATE"}

	f:Hide()

	f.isBank = isBank
	f.bottomOffset = isBank and 8 or 28
	f.topOffset = isBank and 45 or 50
	f.BagIDs = isBank and {-1, 5, 6, 7, 8, 9, 10, 11} or {0, 1, 2, 3, 4}
	f.Bags = {}

	local mover = (isBank and ElvUIBankMover) or ElvUIBagMover
	if mover then
		f:Point(mover.POINT, mover)
		f.mover = mover
	end

	--Allow dragging the frame around
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton", "RightButton")
	f:RegisterForClicks("AnyUp")
	f:SetScript("OnEvent", B.OnEvent)
	f:SetScript("OnShow", B.ContainerOnShow)
	f:SetScript("OnHide", B.ContainerOnHide)
	f:SetScript("OnDragStart", function(frame) if IsShiftKeyDown() then frame:StartMoving() end end)
	f:SetScript("OnDragStop", function(frame) frame:StopMovingOrSizing() end)
	f:SetScript("OnClick", function(frame) if IsControlKeyDown() then B.PostBagMove(frame.mover) end end)
	f:SetScript("OnLeave", GameTooltip_Hide)
	f:SetScript("OnEnter", function(frame)
		GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT", 0, 4)
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine(L["Hold Shift + Drag:"], L["Temporary Move"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Hold Control + Right Click:"], L["Reset Position"], 1, 1, 1)
		GameTooltip:Show()
	end)

	f.closeButton = CreateFrame("Button", name.."CloseButton", f, "UIPanelCloseButton")
	f.closeButton:Point("TOPRIGHT", 0, 2)

	Skins:HandleCloseButton(f.closeButton)

	f.holderFrame = CreateFrame("Frame", nil, f)
	f.holderFrame:Point("TOP", f, "TOP", 0, -f.topOffset)
	f.holderFrame:Point("BOTTOM", f, "BOTTOM", 0, 8)

	f.ContainerHolder = CreateFrame("Button", name.."ContainerHolder", f)
	f.ContainerHolder:Point("BOTTOMLEFT", f, "TOPLEFT", 0, 1)
	f.ContainerHolder:SetTemplate("Transparent")
	f.ContainerHolder:Hide()

	if isBank then
		--Bag Text
		f.bagText = f:CreateFontString(nil, "OVERLAY")
		f.bagText:FontTemplate()
		f.bagText:Point("BOTTOMRIGHT", f.holderFrame, "TOPRIGHT", -2, 4)
		f.bagText:SetJustifyH("RIGHT")
		f.bagText:SetText(L["Bank"])

		-- Stack Button
		f.stackButton = CreateFrame("Button", name.."StackButton", f)
		f.stackButton:Size(16 + E.Border)
		f.stackButton:SetTemplate()
		f.stackButton:Point("RIGHT", f.bagText, "LEFT", -5, E.Border * 2)
		B:SetButtonTexture(f.stackButton, [[Interface\Cursor\Repair]])
		f.stackButton:StyleButton(nil, true)
		f.stackButton.ttText = L["Stack Items In Bank"]
		f.stackButton.ttText2 = L["Hold Shift:"]
		f.stackButton.ttText2desc = L["Stack Items To Bags"]
		f.stackButton:SetScript("OnEnter", B.Tooltip_Show)
		f.stackButton:SetScript("OnLeave", GameTooltip_Hide)
		f.stackButton:SetScript("OnClick", function()
			f:UnregisterAllEvents() --Unregister to prevent unnecessary updates
			if not f.registerUpdate then f.registerUpdate = true end
			if IsShiftKeyDown() then
				B:CommandDecorator(B.Stack, "bank bags")()
			else
				B:CommandDecorator(B.Compress, "bank")()
			end
		end)

		--Sort Button
		f.sortButton = CreateFrame("Button", name.."SortButton", f)
		f.sortButton:Size(16 + E.Border)
		f.sortButton:SetTemplate()
		f.sortButton:Point("RIGHT", f.stackButton, "LEFT", -5, 0)
		B:SetButtonTexture(f.sortButton, E.Media.Textures.Broom)
		f.sortButton:StyleButton(nil, true)
		f.sortButton.ttText = L["Sort Bags"]
		f.sortButton:SetScript("OnEnter", B.Tooltip_Show)
		f.sortButton:SetScript("OnLeave", GameTooltip_Hide)
		f.sortButton:SetScript("OnClick", function()
			f:UnregisterAllEvents() --Unregister to prevent unnecessary updates
			if not f.registerUpdate then
				B:SortingFadeBags(f, true)
			end
			B:CommandDecorator(B.SortBags, "bank")()
		end)
		if E.db.bags.disableBankSort then
			f.sortButton:Disable()
		end

		--Toggle Bags Button
		f.bagsButton = CreateFrame("Button", name.."BagsButton", f.holderFrame)
		f.bagsButton:Size(16 + E.Border)
		f.bagsButton:SetTemplate()
		f.bagsButton:Point("RIGHT", f.sortButton, "LEFT", -5, 0)
		B:SetButtonTexture(f.bagsButton, [[Interface\Buttons\Button-Backpack-Up]])
		f.bagsButton:StyleButton(nil, true)
		f.bagsButton.ttText = L["Toggle Bags"]
		f.bagsButton:SetScript("OnEnter", B.Tooltip_Show)
		f.bagsButton:SetScript("OnLeave", GameTooltip_Hide)
		f.bagsButton:SetScript("OnClick", function()
			local numSlots = GetNumBankSlots()
			PlaySound("igMainMenuOption")
			if numSlots >= 1 then
				ToggleFrame(f.ContainerHolder)
			else
				E:StaticPopup_Show("NO_BANK_BAGS")
			end
		end)

		--Purchase Bags Button
		f.purchaseBagButton = CreateFrame("Button", nil, f.holderFrame)
		f.purchaseBagButton:Size(16 + E.Border)
		f.purchaseBagButton:SetTemplate()
		f.purchaseBagButton:Point("RIGHT", f.bagsButton, "LEFT", -5, 0)
		B:SetButtonTexture(f.purchaseBagButton, [[Interface\Icons\INV_Misc_Coin_01]])
		f.purchaseBagButton:StyleButton(nil, true)
		f.purchaseBagButton.ttText = L["Purchase Bags"]
		f.purchaseBagButton:SetScript("OnEnter", B.Tooltip_Show)
		f.purchaseBagButton:SetScript("OnLeave", GameTooltip_Hide)
		f.purchaseBagButton:SetScript("OnClick", function()
			local _, full = GetNumBankSlots()
			if full then
				E:StaticPopup_Show("CANNOT_BUY_BANK_SLOT")
			else
				E:StaticPopup_Show("BUY_BANK_SLOT")
			end
		end)

		--Search
		f.editBox = CreateFrame("EditBox", name.."EditBox", f)
		f.editBox:FontTemplate()
		f.editBox:SetFrameLevel(f.editBox:GetFrameLevel() + 2)
		f.editBox:CreateBackdrop()
		f.editBox.backdrop:Point("TOPLEFT", f.editBox, "TOPLEFT", -20, 2)
		f.editBox:Height(15)
		f.editBox:Point("BOTTOMLEFT", f.holderFrame, "TOPLEFT", (E.Border * 2) + 18, E.Border * 2 + 2)
		f.editBox:Point("RIGHT", f.purchaseBagButton, "LEFT", -5, 0)
		f.editBox:SetAutoFocus(false)
		f.editBox:SetScript("OnEscapePressed", B.ResetAndClear)
		f.editBox:SetScript("OnEnterPressed", function(eb) eb:ClearFocus() end)
		f.editBox:SetScript("OnEditFocusGained", f.editBox.HighlightText)
		f.editBox:SetScript("OnTextChanged", B.UpdateSearch)
		f.editBox:SetScript("OnChar", B.UpdateSearch)
		f.editBox:SetText(SEARCH)

		f.editBox.searchIcon = f.editBox:CreateTexture(nil, "OVERLAY")
		f.editBox.searchIcon:SetTexture([[Interface\Common\UI-Searchbox-Icon]])
		f.editBox.searchIcon:Point("LEFT", f.editBox.backdrop, "LEFT", E.Border + 1, -1)
		f.editBox.searchIcon:Size(15)
	else
		--Gold Text
		f.goldText = f:CreateFontString(nil, "OVERLAY")
		f.goldText:FontTemplate()
		f.goldText:Point("BOTTOMRIGHT", f.holderFrame, "TOPRIGHT", -2, 4)
		f.goldText:SetJustifyH("RIGHT")

		-- Stack Button
		f.stackButton = CreateFrame("Button", name.."StackButton", f)
		f.stackButton:Size(16 + E.Border)
		f.stackButton:SetTemplate()
		f.stackButton:Point("RIGHT", f.goldText, "LEFT", -5, E.Border * 2)
		B:SetButtonTexture(f.stackButton, [[Interface\Cursor\Repair]])
		f.stackButton:StyleButton(nil, true)
		f.stackButton.ttText = L["Stack Items In Bags"]
		f.stackButton.ttText2 = L["Hold Shift:"]
		f.stackButton.ttText2desc = L["Stack Items To Bank"]
		f.stackButton:SetScript("OnEnter", B.Tooltip_Show)
		f.stackButton:SetScript("OnLeave", GameTooltip_Hide)
		f.stackButton:SetScript("OnClick", function()
			f:UnregisterAllEvents() --Unregister to prevent unnecessary updates
			if not f.registerUpdate then f.registerUpdate = true end
			if IsShiftKeyDown() then
				B:CommandDecorator(B.Stack, "bags bank")()
			else
				B:CommandDecorator(B.Compress, "bags")()
			end
		end)

		--Sort Button
		f.sortButton = CreateFrame("Button", name.."SortButton", f)
		f.sortButton:Size(16 + E.Border)
		f.sortButton:SetTemplate()
		f.sortButton:Point("RIGHT", f.stackButton, "LEFT", -5, 0)
		B:SetButtonTexture(f.sortButton, E.Media.Textures.Broom)
		f.sortButton:StyleButton(nil, true)
		f.sortButton.ttText = L["Sort Bags"]
		f.sortButton:SetScript("OnEnter", B.Tooltip_Show)
		f.sortButton:SetScript("OnLeave", GameTooltip_Hide)
		f.sortButton:SetScript("OnClick", function()
			f:UnregisterAllEvents() --Unregister to prevent unnecessary updates
			if not f.registerUpdate then B:SortingFadeBags(f, true) end
			B:CommandDecorator(B.SortBags, "bags")()
		end)
		if E.db.bags.disableBagSort then
			f.sortButton:Disable()
		end

		--Bags Button
		f.bagsButton = CreateFrame("Button", name.."BagsButton", f)
		f.bagsButton:Size(16 + E.Border)
		f.bagsButton:SetTemplate()
		f.bagsButton:Point("RIGHT", f.sortButton, "LEFT", -5, 0)
		B:SetButtonTexture(f.bagsButton, [[Interface\Buttons\Button-Backpack-Up]])
		f.bagsButton:StyleButton(nil, true)
		f.bagsButton.ttText = L["Toggle Bags"]
		f.bagsButton:SetScript("OnEnter", B.Tooltip_Show)
		f.bagsButton:SetScript("OnLeave", GameTooltip_Hide)
		f.bagsButton:SetScript("OnClick", function() ToggleFrame(f.ContainerHolder) end)

		--Vendor Grays
		f.vendorGraysButton = CreateFrame("Button", nil, f.holderFrame)
		f.vendorGraysButton:Size(16 + E.Border)
		f.vendorGraysButton:SetTemplate()
		f.vendorGraysButton:Point("RIGHT", f.bagsButton, "LEFT", -5, 0)
		B:SetButtonTexture(f.vendorGraysButton, [[Interface\Icons\INV_Misc_Coin_01]])
		f.vendorGraysButton:StyleButton(nil, true)
		f.vendorGraysButton.ttText = L["Vendor / Delete Grays"]
		f.vendorGraysButton.ttValue = B.GetGraysValue
		f.vendorGraysButton:SetScript("OnEnter", B.Tooltip_Show)
		f.vendorGraysButton:SetScript("OnLeave", GameTooltip_Hide)
		f.vendorGraysButton:SetScript("OnClick", B.VendorGrayCheck)

		--Search
		f.editBox = CreateFrame("EditBox", name.."EditBox", f)
		f.editBox:SetFrameLevel(f.editBox:GetFrameLevel() + 2)
		f.editBox:CreateBackdrop()
		f.editBox.backdrop:Point("TOPLEFT", f.editBox, "TOPLEFT", -20, 2)
		f.editBox:Height(15)
		f.editBox:Point("BOTTOMLEFT", f.holderFrame, "TOPLEFT", (E.Border * 2) + 18, E.Border * 2 + 2)
		f.editBox:Point("RIGHT", f.vendorGraysButton, "LEFT", -5, 0)
		f.editBox:SetAutoFocus(false)
		f.editBox:SetScript("OnEscapePressed", B.ResetAndClear)
		f.editBox:SetScript("OnEnterPressed", function(eb) eb:ClearFocus() end)
		f.editBox:SetScript("OnEditFocusGained", f.editBox.HighlightText)
		f.editBox:SetScript("OnTextChanged", B.UpdateSearch)
		f.editBox:SetScript("OnChar", B.UpdateSearch)
		f.editBox:SetText(SEARCH)
		f.editBox:FontTemplate()

		f.editBox.searchIcon = f.editBox:CreateTexture(nil, "OVERLAY")
		f.editBox.searchIcon:SetTexture([[Interface\Common\UI-Searchbox-Icon]])
		f.editBox.searchIcon:Point("LEFT", f.editBox.backdrop, "LEFT", E.Border + 1, -1)
		f.editBox.searchIcon:Size(15)

		--Currency
		f.currencyButton = CreateFrame("Frame", nil, f)
		f.currencyButton:Point("BOTTOM", 0, 4)
		f.currencyButton:Point("TOPLEFT", f.holderFrame, "BOTTOMLEFT", 0, 18)
		f.currencyButton:Point("TOPRIGHT", f.holderFrame, "BOTTOMRIGHT", 0, 18)
		f.currencyButton:Height(22)

		for i = 1, MAX_WATCHED_TOKENS do
			f.currencyButton[i] = CreateFrame("Button", f:GetName().."CurrencyButton"..i, f.currencyButton)
			f.currencyButton[i]:Size(16)
			f.currencyButton[i]:SetTemplate()
			f.currencyButton[i]:SetID(i)
			f.currencyButton[i].icon = f.currencyButton[i]:CreateTexture(nil, "OVERLAY")
			f.currencyButton[i].icon:SetInside()
			f.currencyButton[i].icon:SetTexCoord(unpack(E.TexCoords))
			f.currencyButton[i].text = f.currencyButton[i]:CreateFontString(nil, "OVERLAY")
			f.currencyButton[i].text:Point("LEFT", f.currencyButton[i], "RIGHT", 2, 0)
			f.currencyButton[i].text:FontTemplate()

			f.currencyButton[i]:SetScript("OnEnter", B.Token_OnEnter)
			f.currencyButton[i]:SetScript("OnLeave", GameTooltip_Hide)
			f.currencyButton[i]:SetScript("OnClick", B.Token_OnClick)
			f.currencyButton[i]:Hide()
		end
	end

	tinsert(UISpecialFrames, f:GetName()) --Keep an eye on this for taints..
	tinsert(B.BagFrames, f)
	return f
end

function B:ToggleBags(id)
	if id and (GetContainerNumSlots(id) == 0) then return end

	if B.BagFrame:IsShown() then
		B:CloseBags()
	else
		B:OpenBags()
	end
end

function B:ToggleBackpack()
	if IsOptionFrameOpen() then return end

	if IsBagOpen(0) then
		B:OpenBags()
		PlaySound("igBackPackOpen")
	else
		B:CloseBags()
		PlaySound("igBackPackClose")
	end
end

function B:ToggleSortButtonState(isBank)
	local button, disable
	if isBank and B.BankFrame then
		button = B.BankFrame.sortButton
		disable = E.db.bags.disableBankSort
	elseif not isBank and B.BagFrame then
		button = B.BagFrame.sortButton
		disable = E.db.bags.disableBagSort
	end

	if button and disable then
		button:Disable()
	elseif button and not disable then
		button:Enable()
	end
end

function B:ContainerOnShow()
	B:SetListeners(self)

	-- bags open with bank, so this will fire from bags
	if not self.isBank then
		B:RefreshSearch()
	end
end

function B:ContainerOnHide()
	B:ClearListeners(self)

	if self.isBank then
		CloseBankFrame()
	else
		CloseBackpack()

		for i = 1, NUM_BAG_FRAMES do
			CloseBag(i)
		end
	end

	if not BankFrame:IsShown() and B.db.clearSearchOnClose then
		B:ResetAndClear()
	end
end

function B:SetListeners(frame)
	frame:RegisterEvent("BAG_UPDATE")
	frame:RegisterEvent("BAG_UPDATE_COOLDOWN")

	for _, event in pairs(frame.events) do
		frame:RegisterEvent(event)
	end
end

function B:ClearListeners(frame)
	frame:UnregisterEvent("BAG_UPDATE")
	frame:UnregisterEvent("BAG_UPDATE_COOLDOWN")

	for _, event in pairs(frame.events) do
		frame:UnregisterEvent(event)
	end
end

function B:OpenBags()
	B.BagFrame:Show()

	TT:GameTooltip_SetDefaultAnchor(GameTooltip)
end

function B:CloseBags()
	B.BagFrame:Hide()

	if B.BankFrame then
		B.BankFrame:Hide()
	end

	TT:GameTooltip_SetDefaultAnchor(GameTooltip)
end

function B:OpenBank()
	if not B.BankFrame then
		B.BankFrame = B:ConstructContainerFrame("ElvUI_BankContainerFrame", true)
	end

	--Call :Layout first so all elements are created before we update
	B:Layout(true)

	B:OpenBags()
	B:UpdateTokens()

	B.BankFrame:Show()
end

function B:PLAYERBANKBAGSLOTS_CHANGED()
	B:Layout(true)
end

function B:GuildBankFrame_Update()
	B:SetGuildBankSearch(SEARCH_STRING)
end

function B:CloseBank()
	if not B.BankFrame then return end

	B.BankFrame:Hide()
	B.BagFrame:Hide()
end

function B:GUILDBANKFRAME_OPENED(event)
	if GuildItemSearchBox then
		GuildItemSearchBox:SetScript("OnEscapePressed", B.ResetAndClear)
		GuildItemSearchBox:SetScript("OnEnterPressed", function(sb) sb:ClearFocus() end)
		GuildItemSearchBox:SetScript("OnEditFocusGained", GuildItemSearchBox.HighlightText)
		GuildItemSearchBox:SetScript("OnTextChanged", B.UpdateSearch)
		GuildItemSearchBox:SetScript("OnChar", B.UpdateSearch)
	end

	hooksecurefunc("GuildBankFrame_Update", B.GuildBankFrame_Update)

	B:UnregisterEvent(event)
end

function B:PlayerEnteringWorld()
	B:UpdateBagTypes()
	B:Layout()
end

function B:PLAYER_ENTERING_WORLD()
	B:UpdateGoldText()

	-- Update bag types for bagslot coloring
	E:Delay(2, B.PlayerEnteringWorld)
end

function B:updateContainerFrameAnchors()
	local xOffset, yOffset, screenHeight, freeScreenHeight, leftMostPoint, column
	local screenWidth = GetScreenWidth()
	local containerScale = 1
	local leftLimit = 0

	if BankFrame:IsShown() then
		leftLimit = BankFrame:GetRight() - 25
	end

	while containerScale > CONTAINER_SCALE do
		screenHeight = GetScreenHeight() / containerScale
		-- Adjust the start anchor for bags depending on the multibars
		xOffset = CONTAINER_OFFSET_X / containerScale
		yOffset = CONTAINER_OFFSET_Y / containerScale
		-- freeScreenHeight determines when to start a new column of bags
		freeScreenHeight = screenHeight - yOffset
		leftMostPoint = screenWidth - xOffset
		column = 1

		for _, frameName in ipairs(ContainerFrame1.bags) do
			local frameHeight = _G[frameName]:GetHeight()

			if freeScreenHeight < frameHeight then
				-- Start a new column
				column = column + 1
				leftMostPoint = screenWidth - (column * CONTAINER_WIDTH * containerScale) - xOffset
				freeScreenHeight = screenHeight - yOffset
			end

			freeScreenHeight = freeScreenHeight - frameHeight - VISIBLE_CONTAINER_SPACING
		end

		if leftMostPoint < leftLimit then
			containerScale = containerScale - 0.01
		else
			break
		end
	end

	if containerScale < CONTAINER_SCALE then
		containerScale = CONTAINER_SCALE
	end

	screenHeight = GetScreenHeight() / containerScale
	-- Adjust the start anchor for bags depending on the multibars
	-- xOffset = CONTAINER_OFFSET_X / containerScale
	yOffset = CONTAINER_OFFSET_Y / containerScale
	-- freeScreenHeight determines when to start a new column of bags
	freeScreenHeight = screenHeight - yOffset
	column = 0

	local bagsPerColumn = 0
	for index, frameName in ipairs(ContainerFrame1.bags) do
		local frame = _G[frameName]
		frame:SetScale(1)

		if index == 1 then
			-- First bag
			frame:Point("BOTTOMRIGHT", ElvUIBagMover, "BOTTOMRIGHT", E.Spacing, -E.Border)
			bagsPerColumn = bagsPerColumn + 1
		elseif freeScreenHeight < frame:GetHeight() then
			-- Start a new column
			column = column + 1
			freeScreenHeight = screenHeight - yOffset
			if column > 1 then
				frame:Point("BOTTOMRIGHT", ContainerFrame1.bags[(index - bagsPerColumn) - 1], "BOTTOMLEFT", -CONTAINER_SPACING, 0)
			else
				frame:Point("BOTTOMRIGHT", ContainerFrame1.bags[index - bagsPerColumn], "BOTTOMLEFT", -CONTAINER_SPACING, 0)
			end
			bagsPerColumn = 0
		else
			-- Anchor to the previous bag
			frame:Point("BOTTOMRIGHT", ContainerFrame1.bags[index - 1], "TOPRIGHT", 0, CONTAINER_SPACING)
			bagsPerColumn = bagsPerColumn + 1
		end

		freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING
	end
end

function B:PostBagMove()
	if not E.private.bags.enable then return end

	-- self refers to the mover (bag or bank)
	local x, y = self:GetCenter()
	local screenHeight = E.UIParent:GetTop()
	local screenWidth = E.UIParent:GetRight()

	if y > (screenHeight / 2) then
		self:SetText(self.textGrowDown)
		self.POINT = ((x > (screenWidth / 2)) and "TOPRIGHT" or "TOPLEFT")
	else
		self:SetText(self.textGrowUp)
		self.POINT = ((x > (screenWidth / 2)) and "BOTTOMRIGHT" or "BOTTOMLEFT")
	end

	local bagFrame
	if self.name == "ElvUIBankMover" then
		bagFrame = B.BankFrame
	else
		bagFrame = B.BagFrame
	end

	if bagFrame then
		bagFrame:ClearAllPoints()
		bagFrame:Point(self.POINT, self)
	end
end

function B:MERCHANT_CLOSED()
	B.SellFrame:Hide()

	twipe(B.SellFrame.Info.itemList)
	B.SellFrame.Info.delete = false
	B.SellFrame.Info.ProgressTimer = 0
	B.SellFrame.Info.SellInterval = E.db.bags.vendorGrays.interval
	B.SellFrame.Info.ProgressMax = 0
	B.SellFrame.Info.goldGained = 0
	B.SellFrame.Info.itemsSold = 0
end

function B:ProgressQuickVendor()
	local item = B.SellFrame.Info.itemList[1]
	if not item then return nil, true end --No more to sell
	local bag, slot, itemPrice, link = unpack(item)

	local stackPrice = 0
	if B.SellFrame.Info.delete then
		PickupContainerItem(bag, slot)
		DeleteCursorItem()
	else
		local stackCount = select(2, GetContainerItemInfo(bag, slot)) or 1
		stackPrice = (itemPrice or 0) * stackCount
		if E.db.bags.vendorGrays.details and link then
			E:Print(format("%s|cFF00DDDDx%d|r %s", link, stackCount, E:FormatMoney(stackPrice, E.db.bags.moneyFormat, not E.db.bags.moneyCoins)))
		end
		UseContainerItem(bag, slot)
	end

	tremove(B.SellFrame.Info.itemList, 1)

	return stackPrice
end

function B:VendorGreys_OnUpdate(elapsed)
	B.SellFrame.Info.ProgressTimer = B.SellFrame.Info.ProgressTimer - elapsed
	if B.SellFrame.Info.ProgressTimer > 0 then return end
	B.SellFrame.Info.ProgressTimer = B.SellFrame.Info.SellInterval

	local goldGained, lastItem = B:ProgressQuickVendor()
	if goldGained then
		B.SellFrame.Info.goldGained = B.SellFrame.Info.goldGained + goldGained
		B.SellFrame.Info.itemsSold = B.SellFrame.Info.itemsSold + 1
		B.SellFrame.statusbar:SetValue(B.SellFrame.Info.itemsSold)
		local timeLeft = (B.SellFrame.Info.ProgressMax - B.SellFrame.Info.itemsSold)*B.SellFrame.Info.SellInterval
		B.SellFrame.statusbar.ValueText:SetText(B.SellFrame.Info.itemsSold.." / "..B.SellFrame.Info.ProgressMax.." ( "..timeLeft.."s )")
	elseif lastItem then
		B.SellFrame:Hide()
		if B.SellFrame.Info.goldGained > 0 then
			E:Print((L["Vendored gray items for: %s"]):format(E:FormatMoney(B.SellFrame.Info.goldGained, E.db.bags.moneyFormat, not E.db.bags.moneyCoins)))
		end
	end
end

function B:CreateSellFrame()
	B.SellFrame = CreateFrame("Frame", "ElvUIVendorGraysFrame", E.UIParent)
	B.SellFrame:Size(200, 40)
	B.SellFrame:Point("CENTER", E.UIParent)
	B.SellFrame:CreateBackdrop("Transparent")
	B.SellFrame:SetAlpha(E.db.bags.vendorGrays.progressBar and 1 or 0)

	B.SellFrame.title = B.SellFrame:CreateFontString(nil, "OVERLAY")
	B.SellFrame.title:FontTemplate(nil, 12, "OUTLINE")
	B.SellFrame.title:Point("TOP", B.SellFrame, "TOP", 0, -2)
	B.SellFrame.title:SetText(L["Vendoring Grays"])

	B.SellFrame.statusbar = CreateFrame("StatusBar", "ElvUIVendorGraysFrameStatusbar", B.SellFrame)
	B.SellFrame.statusbar:Size(180, 16)
	B.SellFrame.statusbar:Point("BOTTOM", B.SellFrame, "BOTTOM", 0, 4)
	B.SellFrame.statusbar:SetStatusBarTexture(E.media.normTex)
	B.SellFrame.statusbar:SetStatusBarColor(1, 0, 0)
	B.SellFrame.statusbar:CreateBackdrop("Transparent")

	B.SellFrame.statusbar.anim = CreateAnimationGroup(B.SellFrame.statusbar)
	B.SellFrame.statusbar.anim.progress = B.SellFrame.statusbar.anim:CreateAnimation("Progress")
	B.SellFrame.statusbar.anim.progress:SetEasing("Out")
	B.SellFrame.statusbar.anim.progress:SetDuration(0.3)

	B.SellFrame.statusbar.ValueText = B.SellFrame.statusbar:CreateFontString(nil, "OVERLAY")
	B.SellFrame.statusbar.ValueText:FontTemplate(nil, 12, "OUTLINE")
	B.SellFrame.statusbar.ValueText:Point("CENTER", B.SellFrame.statusbar)
	B.SellFrame.statusbar.ValueText:SetText("0 / 0 ( 0s )")

	B.SellFrame.Info = {
		delete = false,
		ProgressTimer = 0,
		SellInterval = E.db.bags.vendorGrays.interval,
		ProgressMax = 0,
		goldGained = 0,
		itemsSold = 0,
		itemList = {}
	}

	B.SellFrame:SetScript("OnUpdate", B.VendorGreys_OnUpdate)

	B.SellFrame:Hide()
end

function B:UpdateSellFrameSettings()
	if not B.SellFrame or not B.SellFrame.Info then return end

	B.SellFrame.Info.SellInterval = E.db.bags.vendorGrays.interval
	B.SellFrame:SetAlpha(E.db.bags.vendorGrays.progressBar and 1 or 0)
end

B.BagIndice = {
	leatherworking = 0x0008,
	inscription = 0x0010,
	herbs = 0x0020,
	enchanting = 0x0040,
	engineering = 0x0080,
	gems = 0x0200,
	mining = 0x0400,
	fishing = 0x8000,
}

B.QuestKeys = {
	questStarter = "questStarter",
	questItem = "questItem",
}

function B:UpdateBagColors(table, indice, r, g, b)
	B[table][B.BagIndice[indice]] = {r, g, b}
end

function B:UpdateQuestColors(table, indice, r, g, b)
	B[table][B.QuestKeys[indice]] = {r, g, b}
end

function B:Initialize()
	B:LoadBagBar()

	--Creating vendor grays frame
	B:CreateSellFrame()
	B:RegisterEvent("MERCHANT_CLOSED")

	--Bag Mover (We want it created even if Bags module is disabled, so we can use it for default bags too)
	local BagFrameHolder = CreateFrame("Frame", nil, E.UIParent)
	BagFrameHolder:Width(200)
	BagFrameHolder:Height(22)
	BagFrameHolder:SetFrameLevel(BagFrameHolder:GetFrameLevel() + 400)

	if not E.private.bags.enable then
		-- Set a different default anchor
		BagFrameHolder:Point("BOTTOMRIGHT", RightChatPanel, "BOTTOMRIGHT", -(E.Border * 2), 22 + E.Border * 4 - E.Spacing * 2)
		E:CreateMover(BagFrameHolder, "ElvUIBagMover", L["Bag Mover"], nil, nil, B.PostBagMove, nil, nil, "bags,general")

		B:SecureHook("updateContainerFrameAnchors")

		return
	end

	B.Initialized = true
	B.db = E.db.bags

	B.BagFrames = {}
	B.ProfessionColors = {
		[0x0008] = {B.db.colors.profession.leatherworking.r, B.db.colors.profession.leatherworking.g, B.db.colors.profession.leatherworking.b},
		[0x0010] = {B.db.colors.profession.inscription.r, B.db.colors.profession.inscription.g, B.db.colors.profession.inscription.b},
		[0x0020] = {B.db.colors.profession.herbs.r, B.db.colors.profession.herbs.g, B.db.colors.profession.herbs.b},
		[0x0040] = {B.db.colors.profession.enchanting.r, B.db.colors.profession.enchanting.g, B.db.colors.profession.enchanting.b},
		[0x0080] = {B.db.colors.profession.engineering.r, B.db.colors.profession.engineering.g, B.db.colors.profession.engineering.b},
		[0x0200] = {B.db.colors.profession.gems.r, B.db.colors.profession.gems.g, B.db.colors.profession.gems.b},
		[0x0400] = {B.db.colors.profession.mining.r, B.db.colors.profession.mining.g, B.db.colors.profession.mining.b},
		[0x8000] = {B.db.colors.profession.fishing.r, B.db.colors.profession.fishing.g, B.db.colors.profession.fishing.b}
	}

	B.QuestColors = {
		questStarter = {B.db.colors.items.questStarter.r, B.db.colors.items.questStarter.g, B.db.colors.items.questStarter.b},
		questItem = {B.db.colors.items.questItem.r, B.db.colors.items.questItem.g, B.db.colors.items.questItem.b}
	}

	--Bag Mover: Set default anchor point and create mover
	BagFrameHolder:Point("BOTTOMRIGHT", RightChatPanel, "BOTTOMRIGHT", 0, 22 + E.Border * 4 - E.Spacing * 2)
	E:CreateMover(BagFrameHolder, "ElvUIBagMover", L["Bag Mover (Grow Up)"], nil, nil, B.PostBagMove, nil, nil, "bags,general")

	--Bank Mover
	local BankFrameHolder = CreateFrame("Frame", nil, E.UIParent)
	BankFrameHolder:Width(200)
	BankFrameHolder:Height(22)
	BankFrameHolder:Point("BOTTOMLEFT", LeftChatPanel, "BOTTOMLEFT", 0, 22 + E.Border * 4 - E.Spacing * 2)
	BankFrameHolder:SetFrameLevel(BankFrameHolder:GetFrameLevel() + 400)
	E:CreateMover(BankFrameHolder, "ElvUIBankMover", L["Bank Mover (Grow Up)"], nil, nil, B.PostBagMove, nil, nil, "bags,general")

	--Set some variables on movers
	ElvUIBagMover.textGrowUp = L["Bag Mover (Grow Up)"]
	ElvUIBagMover.textGrowDown = L["Bag Mover (Grow Down)"]
	ElvUIBagMover.POINT = "BOTTOM"
	ElvUIBankMover.textGrowUp = L["Bank Mover (Grow Up)"]
	ElvUIBankMover.textGrowDown = L["Bank Mover (Grow Down)"]
	ElvUIBankMover.POINT = "BOTTOM"

	--Create Containers
	B.BagFrame = B:ConstructContainerFrame("ElvUI_ContainerFrame")

	--Hook onto Blizzard Functions
	B:SecureHook("ToggleBackpack")
	B:SecureHook("OpenAllBags", "OpenBags")
	B:SecureHook("CloseAllBags", "CloseBags")
	B:SecureHook("ToggleBag", "ToggleBags")
	B:SecureHook("ToggleAllBags", "ToggleBackpack")
	B:SecureHook("BackpackTokenFrame_Update", "UpdateTokens")
	B:Layout()

	B:DisableBlizzard()
	B:RegisterEvent("PLAYER_ENTERING_WORLD")
	B:RegisterEvent("PLAYER_MONEY", "UpdateGoldText")
	B:RegisterEvent("PLAYER_TRADE_MONEY", "UpdateGoldText")
	B:RegisterEvent("TRADE_MONEY_CHANGED", "UpdateGoldText")
	B:RegisterEvent("BANKFRAME_OPENED", "OpenBank")
	B:RegisterEvent("BANKFRAME_CLOSED", "CloseBank")
	B:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED")
	B:RegisterEvent("GUILDBANKFRAME_OPENED")
end

local function InitializeCallback()
	B:Initialize()
end

E:RegisterModule(B:GetName(), InitializeCallback)