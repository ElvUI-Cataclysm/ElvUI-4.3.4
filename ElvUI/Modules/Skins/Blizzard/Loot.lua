local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local unpack, select = unpack, select

local UnitName = UnitName
local IsFishingLoot = IsFishingLoot
local GetItemQualityColor = GetItemQualityColor
local GetLootSlotInfo = GetLootSlotInfo
local LOOTFRAME_NUMBUTTONS = LOOTFRAME_NUMBUTTONS
local LOOT, ITEMS = LOOT, ITEMS

local function LoadSkin()
	if E.private.general.loot then return end
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.loot then return end

	LootFrame:StripTextures()

	LootFrame:CreateBackdrop("Transparent")
	LootFrame.backdrop:Point("TOPLEFT", 14, -14)
	LootFrame.backdrop:Point("BOTTOMRIGHT", -75, 5)

	LootFramePortraitOverlay:SetParent(E.HiddenFrame)

	S:HandleNextPrevButton(LootFrameUpButton)
	LootFrameUpButton:Point("BOTTOMLEFT", 25, 20)
	LootFrameUpButton:Size(24)

	S:HandleNextPrevButton(LootFrameDownButton)
	LootFrameDownButton:Point("BOTTOMLEFT", 145, 20)
	LootFrameDownButton:Size(24)

	LootFrame:EnableMouseWheel(true)
	LootFrame:SetScript("OnMouseWheel", function(_, value)
		if value > 0 then
			if LootFrameUpButton:IsShown() and LootFrameUpButton:IsEnabled() == 1 then
				LootFrame_PageUp()
			end
		else
			if LootFrameDownButton:IsShown() and LootFrameDownButton:IsEnabled() == 1 then
				LootFrame_PageDown()
			end
		end
	end)

	S:HandleCloseButton(LootCloseButton)
	LootCloseButton:Point("CENTER", LootFrame, "TOPRIGHT", -87, -26)

	for i = 1, LootFrame:GetNumRegions() do
		local region = select(i, LootFrame:GetRegions())
		if region:GetObjectType() == "FontString" then
			if region:GetText() == ITEMS then
				LootFrame.Title = region
			end
		end
	end

	LootFrame.Title:ClearAllPoints()
	LootFrame.Title:Point("TOPLEFT", LootFrame.backdrop, "TOPLEFT", 4, -4)
	LootFrame.Title:SetJustifyH("LEFT")

	LootFrame:HookScript("OnShow", function(self)
		if IsFishingLoot() then
			self.Title:SetText(L["Fishy Loot"])
		elseif not UnitIsFriend("player", "target") and UnitIsDead("target") then
			self.Title:SetText(UnitName("target"))
		else
			self.Title:SetText(LOOT)
		end
	end)

	for i = 1, LOOTFRAME_NUMBUTTONS do
		local button = _G["LootButton"..i]
		local questTexture = _G["LootButton"..i.."IconQuestTexture"]

		S:HandleItemButton(button, true)

		button.bg = CreateFrame("Frame", nil, button)
		button.bg:SetTemplate()
		button.bg:Point("TOPLEFT", 40, 0)
		button.bg:Point("BOTTOMRIGHT", 110, 0)
		button.bg:SetFrameLevel(button.bg:GetFrameLevel() - 1)

		questTexture:SetTexture(E.Media.Textures.BagQuestIcon)
		questTexture.SetTexture = E.noop
		questTexture:SetTexCoord(0, 1, 0, 1)
		questTexture:SetInside()

		_G["LootButton"..i.."NameFrame"]:Hide()
	end

	local QuestColors = {
		questStarter = {E.db.bags.colors.items.questStarter.r, E.db.bags.colors.items.questStarter.g, E.db.bags.colors.items.questStarter.b},
		questItem =	{E.db.bags.colors.items.questItem.r, E.db.bags.colors.items.questItem.g, E.db.bags.colors.items.questItem.b}
	}

	hooksecurefunc("LootFrame_UpdateButton", function(index)
		local numLootItems = LootFrame.numLootItems
		local numLootToShow = LOOTFRAME_NUMBUTTONS
		if numLootItems > LOOTFRAME_NUMBUTTONS then
			numLootToShow = numLootToShow - 1
		end

		local button = _G["LootButton"..index]
		local slot = (numLootToShow * (LootFrame.page - 1)) + index

		if slot <= numLootItems then
			if (LootSlotIsItem(slot) or LootSlotIsCoin(slot) or LootSlotIsCurrency(slot)) and index <= numLootToShow then
				local texture, _, _, quality, _, isQuestItem, questId, isActive = GetLootSlotInfo(slot)
				if texture then
					local questTexture = _G["LootButton"..index.."IconQuestTexture"]

					questTexture:Hide()

					if questId and not isActive then
						button.backdrop:SetBackdropBorderColor(unpack(QuestColors.questStarter))
						questTexture:Show()
					elseif questId or isQuestItem then
						button.backdrop:SetBackdropBorderColor(unpack(QuestColors.questItem))
					elseif quality then
						button.backdrop:SetBackdropBorderColor(GetItemQualityColor(quality))
					else
						button.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
					end
				end
			end
		end
	end)
end

S:AddCallback("Loot", LoadSkin)