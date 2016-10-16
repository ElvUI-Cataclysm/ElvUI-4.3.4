local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins')

local unpack = unpack

local GetItemQualityColor = GetItemQualityColor

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.inspect ~= true then return end

	InspectFrame:StripTextures(true)
	InspectFrameInset:StripTextures(true)
	InspectTalentFramePointsBar:StripTextures()
	InspectFrame:CreateBackdrop("Transparent")
	InspectFrame.backdrop:SetAllPoints()
	S:HandleCloseButton(InspectFrameCloseButton)

	for i = 1, 4 do
		S:HandleTab(_G["InspectFrameTab"..i])
	end

	InspectModelFrameBorderTopLeft:Kill()
	InspectModelFrameBorderTopRight:Kill()
	InspectModelFrameBorderTop:Kill()
	InspectModelFrameBorderLeft:Kill()
	InspectModelFrameBorderRight:Kill()
	InspectModelFrameBorderBottomLeft:Kill()
	InspectModelFrameBorderBottomRight:Kill()
	InspectModelFrameBorderBottom:Kill()
	InspectModelFrameBorderBottom2:Kill()
	InspectModelFrameBackgroundOverlay:Kill()
	InspectModelFrame:CreateBackdrop("Default")

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
		local icon = _G["Inspect"..slot.."IconTexture"]
		local slot = _G["Inspect"..slot]
		slot:StripTextures()
		slot:StyleButton(false)
		slot:SetTemplate("Default", true)
		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside()
	end

	local CheckItemBorderColor = CreateFrame("Frame")
	local function ScanSlots()
		local notFound
		for _, slot in pairs(slots) do
			local target = _G["Inspect"..slot]
			local slotId, _, _ = GetInventorySlotInfo(slot)
			local itemId = GetInventoryItemID("target", slotId)

			if itemId then
				local _, _, rarity, _, _, _, _, _, _, _, _ = GetItemInfo(itemId)
				if not rarity then notFound = true end
				if rarity and rarity > 1 then
					target:SetBackdropBorderColor(GetItemQualityColor(rarity))
				else
					target:SetBackdropBorderColor(unpack(E.media.bordercolor))
				end
			else
				target:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end
		end

		if notFound == true then
			return false
		else
			CheckItemBorderColor:SetScript('OnUpdate', nil) --Stop updating
			return true
		end
	end

	local function ColorItemBorder(self)
		if self and not ScanSlots() then
			self:SetScript("OnUpdate", ScanSlots) --Run function until all items borders are colored, sometimes when you have never seen an item before GetItemInfo will return nil, when this happens we have to wait for the server to send information.
		end 
	end

	CheckItemBorderColor:RegisterEvent("PLAYER_TARGET_CHANGED")
	CheckItemBorderColor:RegisterEvent("UNIT_PORTRAIT_UPDATE")
	CheckItemBorderColor:RegisterEvent("PARTY_MEMBERS_CHANGED")
	CheckItemBorderColor:SetScript("OnEvent", ColorItemBorder)
	InspectFrame:HookScript("OnShow", ColorItemBorder)
	ColorItemBorder(CheckItemBorderColor)

	InspectPVPFrameBottom:Kill()
	InspectGuildFrameBG:Kill()
	InspectPVPFrame:HookScript("OnShow", function() InspectPVPFrameBG:Kill() end)

	for i = 1, 3 do
		_G["InspectPVPTeam"..i]:StripTextures()

		local headerTab = _G["InspectTalentFrameTab"..i]
		headerTab:StripTextures()
		headerTab.backdrop = CreateFrame("Frame", nil, headerTab)
		headerTab.backdrop:SetTemplate("Default", true)
		headerTab.backdrop:SetFrameLevel(headerTab:GetFrameLevel() - 1)
		headerTab.backdrop:Point("TOPLEFT", 3, -7)
		headerTab.backdrop:Point("BOTTOMRIGHT", -2, -1)

		headerTab:HookScript("OnEnter", S.SetModifiedBackdrop);
		headerTab:HookScript("OnLeave", S.SetOriginalBackdrop);
	end

	InspectTalentFrame.bg = CreateFrame("Frame", nil, InspectTalentFrame)
	InspectTalentFrame.bg:SetTemplate("Default")
	InspectTalentFrame.bg:Point("TOPLEFT", InspectTalentFrameBackgroundTopLeft, "TOPLEFT", -2, 2)
	InspectTalentFrame.bg:Point("BOTTOMRIGHT", InspectTalentFrameBackgroundBottomRight, "BOTTOMRIGHT", -20, 52)
	InspectTalentFrame.bg:SetFrameLevel(InspectTalentFrame.bg:GetFrameLevel() - 2)

	for i = 1, MAX_NUM_TALENTS do
		local button = _G["InspectTalentFrameTalent"..i]
		local icon = _G["InspectTalentFrameTalent"..i.."IconTexture"]
		if button then
			button:StripTextures()
			button:StyleButton()
			button:SetTemplate("Default")
			button.SetHighlightTexture = E.noop
			button.SetPushedTexture = E.noop
			button:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
			button:GetPushedTexture():SetTexCoord(unpack(E.TexCoords))
			button:GetHighlightTexture():SetAllPoints(icon)
			button:GetPushedTexture():SetAllPoints(icon)

			if button.Rank then
				button.Rank:FontTemplate(nil, 12, 'OUTLINE')
				button.Rank:ClearAllPoints()
				button.Rank:SetPoint("BOTTOMRIGHT", 9, -12)
			end

			icon:SetTexCoord(unpack(E.TexCoords))
			icon:SetInside()
		end
	end

	InspectModelFrameControlFrame:StripTextures()

	local controlbuttons = {
		"InspectModelFrameControlFrameZoomInButton",
		"InspectModelFrameControlFrameZoomOutButton",
		"InspectModelFrameControlFramePanButton",
		"InspectModelFrameControlFrameRotateRightButton",
		"InspectModelFrameControlFrameRotateLeftButton",
		"InspectModelFrameControlFrameRotateResetButton",
	}

	for i = 1, getn(controlbuttons) do
		S:HandleButton(_G[controlbuttons[i]]);
		_G[controlbuttons[i]]:StyleButton()
		_G[controlbuttons[i].."Bg"]:Hide()
	end
end

S:AddCallbackForAddon("Blizzard_InspectUI", "Inspect", LoadSkin);