local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins')

local _G = _G
local unpack, pairs, select = unpack, pairs, select

local CharacterFrameExpandButton = CharacterFrameExpandButton
local SquareButton_SetIcon = SquareButton_SetIcon

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true then return end

	S:HandleCloseButton(CharacterFrameCloseButton)
	S:HandleScrollBar(CharacterStatsPaneScrollBar)
	S:HandleScrollBar(ReputationListScrollFrameScrollBar)
	S:HandleScrollBar(TokenFrameContainerScrollBar)
	S:HandleScrollBar(GearManagerDialogPopupScrollFrameScrollBar)

	local slots = {
		"HeadSlot",
		"NeckSlot",
		"ShoulderSlot",
		"BackSlot",
		"ChestSlot",
		"ShirtSlot",
		"TabardSlot",
		"WristSlot",
		"HandsSlot",
		"WaistSlot",
		"LegsSlot",
		"FeetSlot",
		"Finger0Slot",
		"Finger1Slot",
		"Trinket0Slot",
		"Trinket1Slot",
		"MainHandSlot",
		"SecondaryHandSlot",
		"RangedSlot",
	}

	for _, slot in pairs(slots) do
		local icon = _G["Character"..slot.."IconTexture"]
		local cooldown = _G["Character"..slot.."Cooldown"];

		slot = _G["Character"..slot]
		slot:StripTextures()
		slot:StyleButton(false)
		slot.ignoreTexture:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-LeaveItem-Transparent]])
		slot:SetTemplate("Default", true, true);
		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside();

		slot:SetFrameLevel(PaperDollFrame:GetFrameLevel() + 2);

		if(cooldown) then
			E:RegisterCooldown(cooldown);
		end
	end

	local function ColorItemBorder()
		for _, slot in pairs(slots) do
			local target = _G['Character'..slot]
			local slotId, _, _ = GetInventorySlotInfo(slot)
			local itemId = GetInventoryItemID('player', slotId)

			if(itemId) then
				local rarity = GetInventoryItemQuality("player", slotId);
				if(rarity and rarity > 1) then
					target:SetBackdropBorderColor(GetItemQualityColor(rarity))
				else
					target:SetBackdropBorderColor(unpack(E['media'].bordercolor))
				end
			else
				target:SetBackdropBorderColor(unpack(E['media'].bordercolor))
			end
		end
	end

	local CheckItemBorderColor = CreateFrame("Frame")
	CheckItemBorderColor:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	CheckItemBorderColor:SetScript("OnEvent", ColorItemBorder)
	CharacterFrame:HookScript("OnShow", ColorItemBorder)
	ColorItemBorder()

	--Strip Textures
	local charframe = {
		"CharacterFrame",
		"CharacterModelFrame",
		"CharacterFrameInset", 
		"CharacterStatsPane",
		"CharacterFrameInsetRight",
		"PaperDollSidebarTabs",
		"PaperDollEquipmentManagerPane",
	}

	CharacterFrameExpandButton:Size(CharacterFrameExpandButton:GetWidth() - 5, CharacterFrameExpandButton:GetHeight() - 5)
	S:HandleNextPrevButton(CharacterFrameExpandButton)

	hooksecurefunc('CharacterFrame_Collapse', function()
		CharacterFrameExpandButton:SetNormalTexture(nil);
		CharacterFrameExpandButton:SetPushedTexture(nil);
		CharacterFrameExpandButton:SetDisabledTexture(nil);
		SquareButton_SetIcon(CharacterFrameExpandButton, 'RIGHT')
	end)

	hooksecurefunc('CharacterFrame_Expand', function()
		CharacterFrameExpandButton:SetNormalTexture(nil);
		CharacterFrameExpandButton:SetPushedTexture(nil);
		CharacterFrameExpandButton:SetDisabledTexture(nil);
		SquareButton_SetIcon(CharacterFrameExpandButton, 'LEFT');
	end)

	if(GetCVar("characterFrameCollapsed") ~= "0") then
		SquareButton_SetIcon(CharacterFrameExpandButton, 'RIGHT')
	else
		SquareButton_SetIcon(CharacterFrameExpandButton, 'LEFT');
	end

	local function SkinItemFlyouts(button)
		EquipmentFlyoutFrameButtons:StripTextures();
		button.icon = _G[button:GetName() .. "IconTexture"];

		button:GetNormalTexture():SetTexture(nil);
		button:SetTemplate("Default");
		button:StyleButton(false);

		button.icon:SetInside();
		button.icon:SetTexCoord(unpack(E.TexCoords));

		local cooldown = _G[button:GetName() .."Cooldown"];
		if(cooldown) then
			E:RegisterCooldown(cooldown);
		end

		local location = button.location;
		if(not location) then return; end
		if(location and location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION) then return; end

		local id = EquipmentManager_GetItemInfoByLocation(location);
		local _, _, quality = GetItemInfo(id);
		local r, g, b = GetItemQualityColor(quality);

		button:SetBackdropBorderColor(r, g, b);
 	end
 	hooksecurefunc("EquipmentFlyout_DisplayButton", SkinItemFlyouts);

	local function SkinFrameFlyouts()
		EquipmentFlyoutFrameButtons:StripTextures();
		EquipmentFlyoutFrameHighlight:Kill()
	end
	hooksecurefunc("EquipmentFlyout_Show", SkinFrameFlyouts)

	--Icon in upper right corner of character frame
	CharacterFramePortrait:Kill()
	CharacterModelFrame:CreateBackdrop("Default")

	local controlbuttons = {
		"CharacterModelFrameControlFrameZoomInButton",
		"CharacterModelFrameControlFrameZoomOutButton",
		"CharacterModelFrameControlFramePanButton",
		"CharacterModelFrameControlFrameRotateLeftButton",
		"CharacterModelFrameControlFrameRotateRightButton",
		"CharacterModelFrameControlFrameRotateResetButton",
	}

	for i = 1, getn(controlbuttons) do
		S:HandleButton(_G[controlbuttons[i]]);
		_G[controlbuttons[i]]:StyleButton()
		_G[controlbuttons[i].."Bg"]:Hide()
	end

	CharacterModelFrameControlFrame:StripTextures()

	local scrollbars = {
		"PaperDollTitlesPaneScrollBar",
		"PaperDollEquipmentManagerPaneScrollBar",
	}

	for _, scrollbar in pairs(scrollbars) do
		S:HandleScrollBar(_G[scrollbar], 5)
	end

	for _, object in pairs(charframe) do
		_G[object]:StripTextures()
	end

	CharacterFrame:SetTemplate("Transparent")

	--Titles
	PaperDollTitlesPane:HookScript("OnShow", function(self)
		for x, object in pairs(PaperDollTitlesPane.buttons) do
			object.BgTop:SetTexture(nil)
			object.BgBottom:SetTexture(nil)
			object.BgMiddle:SetTexture(nil)

			object.Check:SetTexture(nil)
			object.text:FontTemplate()
			object.text.SetFont = E.noop
			object:StyleButton()
			object.SelectedBar:SetTexture(0, 0.7, 1, 0.75)
		end
	end)

	--Equipement Manager
	S:HandleButton(PaperDollEquipmentManagerPaneEquipSet)
	S:HandleButton(PaperDollEquipmentManagerPaneSaveSet)

	PaperDollEquipmentManagerPaneEquipSet:Point("TOPLEFT", PaperDollEquipmentManagerPane, "TOPLEFT", 8, 0)
	PaperDollEquipmentManagerPaneEquipSet:Width(PaperDollEquipmentManagerPaneEquipSet:GetWidth() - 8)
	PaperDollEquipmentManagerPaneEquipSet.ButtonBackground:SetTexture(nil)

	PaperDollEquipmentManagerPaneSaveSet:Point("LEFT", PaperDollEquipmentManagerPaneEquipSet, "RIGHT", 4, 0)
	PaperDollEquipmentManagerPaneSaveSet:Width(PaperDollEquipmentManagerPaneSaveSet:GetWidth() - 8)

	PaperDollEquipmentManagerPane:HookScript("OnShow", function(self)
		for x, object in pairs(PaperDollEquipmentManagerPane.buttons) do
			object.BgTop:SetTexture(nil)
			object.BgBottom:SetTexture(nil)
			object.BgMiddle:SetTexture(nil)

			object.Check:SetTexture(nil)
			object.icon:SetTexCoord(unpack(E.TexCoords))

			object:StyleButton()
			object.SelectedBar:SetTexture(0, 0.7, 1, 0.75)
			object.HighlightBar:SetTexture(nil)

			object:CreateBackdrop("Default")
			object.backdrop:SetOutside(object.icon)
			object.icon:SetParent(object.backdrop)

			object.icon:SetPoint("LEFT", object, "LEFT", 1, 0)
			object.icon.SetPoint = E.noop
			object.icon:Size(42)
			object.icon.SetSize = E.noop
		end

		GearManagerDialogPopup:StripTextures()
		GearManagerDialogPopup:SetTemplate("Transparent")
		GearManagerDialogPopup:Point("TOPLEFT", PaperDollFrame, "TOPRIGHT", 1, 0)

		GearManagerDialogPopupEditBox:StripTextures()
		GearManagerDialogPopupEditBox:SetTemplate("Default")

		GearManagerDialogPopupScrollFrame:StripTextures()

		S:HandleButton(GearManagerDialogPopupOkay)
		S:HandleButton(GearManagerDialogPopupCancel)

		for i = 1, NUM_GEARSET_ICONS_SHOWN do
			local button = _G["GearManagerDialogPopupButton"..i]
			local icon = button.icon

			icon:SetTexture(nil)

			button:StripTextures()
			button:CreateBackdrop()
			button.backdrop:SetOutside(icon)
			button:SetFrameLevel(button:GetFrameLevel() + 3)
			button:StyleButton(nil, true)

			icon:SetTexCoord(unpack(E.TexCoords))
			icon:SetParent(button.backdrop)
		end
	end)

	--Handle Tabs at bottom of character frame
	for i = 1, 4 do
		S:HandleTab(_G["CharacterFrameTab"..i])
	end

	--Buttons used to toggle between equipment manager, titles, and character stats
	local function FixSidebarTabCoords()
		for i = 1, #PAPERDOLL_SIDEBARS do
			local tab = _G["PaperDollSidebarTab"..i]
			if(tab) then
				tab.Highlight:SetTexture(1, 1, 1, 0.3)
				tab.Highlight:Point("TOPLEFT", 3, -4)
				tab.Highlight:Point("BOTTOMRIGHT", -1, 0)
				tab.Hider:SetTexture(0.4,0.4,0.4,0.4)
				tab.Hider:Point("TOPLEFT", 3, -4)
				tab.Hider:Point("BOTTOMRIGHT", -1, 0)
				tab.TabBg:Kill()

				if(i == 1) then
					for i = 1, tab:GetNumRegions() do
						local region = select(i, tab:GetRegions())
						region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
						region.SetTexCoord = E.noop
					end
				end
				tab:CreateBackdrop("Default")
				tab.backdrop:Point("TOPLEFT", 1, -2)
				tab.backdrop:Point("BOTTOMRIGHT", 1, -2)	
			end
		end
	end
	hooksecurefunc("PaperDollFrame_UpdateSidebarTabs", FixSidebarTabCoords)

	--Stat panels, atm it looks like 7 is the max
	for i = 1, 7 do
		_G["CharacterStatsPaneCategory"..i]:StripTextures()
	end

	--Reputation
	ReputationFrame:StripTextures(true)
	ReputationListScrollFrame:StripTextures()

	local function UpdateFactionSkins()
		for i = 1, GetNumFactions() do
			local statusbar = _G["ReputationBar"..i.."ReputationBar"]
			if(statusbar) then
				statusbar:SetStatusBarTexture(E["media"].normTex)
				statusbar:CreateBackdrop("Default")
				_G["ReputationBar"..i.."Background"]:SetTexture(nil)
				_G["ReputationBar"..i.."LeftLine"]:Kill()
				_G["ReputationBar"..i.."BottomLine"]:Kill()
				_G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(nil)	
				_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(nil)
				_G["ReputationBar"..i.."ExpandOrCollapseButton"]:SetNormalTexture("Interface\\Buttons\\UI-PlusMinus-Buttons")
				_G["ReputationBar"..i.."ExpandOrCollapseButton"].SetNormalTexture = function() end
				_G["ReputationBar"..i.."ExpandOrCollapseButton"]:GetNormalTexture():SetInside()
				_G["ReputationBar"..i.."ExpandOrCollapseButton"]:SetHighlightTexture(nil)
			end
		end
	end

	local function UpdateFaction()
		local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)
		local numFactions = GetNumFactions()
		for i = 1, NUM_FACTIONS_DISPLAYED, 1 do
			local Bar = _G["ReputationBar"..i]
			local Button = _G["ReputationBar"..i.."ExpandOrCollapseButton"]
			local FactionName = _G["ReputationBar"..i.."FactionName"]
			local factionIndex = factionOffset + i
			if(factionIndex <= numFactions) then
				local name, _, _, _, _, _, atWarWith, canToggleAtWar, _, isCollapsed = GetFactionInfo(factionIndex);

				if(isCollapsed) then
					Button:GetNormalTexture():SetTexCoord(0, 0.4375, 0, 0.4375)
				else
					Button:GetNormalTexture():SetTexCoord(0.5625, 1, 0, 0.4375)
				end

				FactionName:SetText(name)
				if(atWarWith and canToggleAtWar) then
					FactionName:SetFormattedText("%s|TInterface\\Buttons\\UI-CheckBox-SwordCheck:16:16:%d:0:32:32:0:16:0:16|t", name, -(20 + FactionName:GetStringWidth()))
				end
			end
		end
	end

	ReputationFrame:HookScript("OnShow", UpdateFactionSkins)
	hooksecurefunc("ExpandFactionHeader", UpdateFactionSkins)
	hooksecurefunc("CollapseFactionHeader", UpdateFactionSkins)
	hooksecurefunc("ReputationFrame_Update", UpdateFaction)

	ReputationDetailFrame:StripTextures()
	ReputationDetailFrame:SetTemplate("Transparent")
	ReputationDetailFrame:Point("TOPLEFT", ReputationFrame, "TOPRIGHT", 1, 0)

	ReputationDetailFactionDescription:FontTemplate(nil, 12)

	S:HandleCheckBox(ReputationDetailMainScreenCheckBox)
	S:HandleCheckBox(ReputationDetailInactiveCheckBox)

	S:HandleCheckBox(ReputationDetailAtWarCheckBox)
	ReputationDetailAtWarCheckBox:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-SwordCheck")

	S:HandleCloseButton(ReputationDetailCloseButton)
	ReputationDetailCloseButton:Point("TOPRIGHT", ReputationDetail, "TOPRIGHT", 3, 4)

	--Currency
	TokenFrame:HookScript("OnShow", function()
		for i = 1, GetCurrencyListSize() do
			local button = _G["TokenFrameContainerButton"..i]

			if(button) then
				button.highlight:Kill()
				button.categoryMiddle:Kill()	
				button.categoryLeft:Kill()	
				button.categoryRight:Kill()

				button.icon:SetTexCoord(unpack(E.TexCoords))
			end
		end
		TokenFramePopup:StripTextures()
		TokenFramePopup:SetTemplate("Transparent")
		TokenFramePopup:Point("TOPLEFT", TokenFrame, "TOPRIGHT", 1, 0)
	end)

	S:HandleCheckBox(TokenFramePopupInactiveCheckBox)
	S:HandleCheckBox(TokenFramePopupBackpackCheckBox)

	S:HandleCloseButton(TokenFramePopupCloseButton)
	TokenFramePopupCloseButton:Point("TOPRIGHT", TokenFramePopup, "TOPRIGHT", 3, 4)

	--Pet
	PetModelFrame:CreateBackdrop("Default")

	PetPaperDollFrameExpBar:StripTextures()
	PetPaperDollFrameExpBar:CreateBackdrop("Default")
	PetPaperDollFrameExpBar:SetStatusBarTexture(E["media"].normTex)

	S:HandleRotateButton(PetModelFrameRotateRightButton)
	S:HandleRotateButton(PetModelFrameRotateLeftButton)

	PetModelFrameRotateRightButton:ClearAllPoints()
	PetModelFrameRotateRightButton:Point("LEFT", PetModelFrameRotateLeftButton, "RIGHT", 4, 0)

	local xtex = PetPaperDollPetInfo:GetRegions()
	xtex:SetTexCoord(.12, .63, .15, .55)

	PetPaperDollPetInfo:CreateBackdrop("Default")
	PetPaperDollPetInfo:Size(24, 24)
end

S:AddCallback("Character", LoadSkin);