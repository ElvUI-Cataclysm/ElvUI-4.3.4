local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule("Skins")

local _G = _G
local pairs, unpack = pairs, unpack;

local function LoadSkin()
	if(not E.private.skins.blizzard.enable or not E.private.skins.blizzard.inspect) then return; end

	InspectFrame:StripTextures(true)
	InspectFrame:CreateBackdrop("Transparent")
	InspectFrame.backdrop:SetAllPoints()

	InspectFrameInset:StripTextures(true)
	InspectTalentFramePointsBar:StripTextures()

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
		"RangedSlot"
	}

	for _, slot in pairs(slots) do
		local icon = _G["Inspect"..slot.."IconTexture"]
		local slot = _G["Inspect"..slot]
		slot:StripTextures()
		slot:StyleButton()
		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside()
		slot:SetFrameLevel(slot:GetFrameLevel() + 2)
		slot:CreateBackdrop("Default")
		slot.backdrop:SetAllPoints()
	end

	hooksecurefunc("InspectPaperDollItemSlotButton_Update", function(button)
		if(button.hasItem) then
			local itemID = GetInventoryItemID(InspectFrame.unit, button:GetID())
			if(itemID) then
				local _, _, quality = GetItemInfo(itemID)
				if(not quality) then
					E:Delay(0.1, function()
						if(InspectFrame.unit) then
							InspectPaperDollItemSlotButton_Update(button);
						end
					end);
					return
				elseif(quality and quality > 1) then
					button.backdrop:SetBackdropBorderColor(GetItemQualityColor(quality));
					return
 				end
			end
		end
		button.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor));
 	end)

	InspectPVPFrameBottom:Kill()
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

		if(button) then
			button:StripTextures()
			button:StyleButton()
			button:SetTemplate("Default")
			button.SetHighlightTexture = E.noop
			button.SetPushedTexture = E.noop
			button:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
			button:GetPushedTexture():SetTexCoord(unpack(E.TexCoords))
			button:GetHighlightTexture():SetAllPoints(icon)
			button:GetPushedTexture():SetAllPoints(icon)

			if(button.Rank) then
				button.Rank:FontTemplate(nil, 12, "OUTLINE")
				button.Rank:ClearAllPoints()
				button.Rank:SetPoint("BOTTOMRIGHT", 9, -12)
			end

			icon:SetTexCoord(unpack(E.TexCoords))
			icon:SetInside()
		end
	end

	InspectGuildFrameBG:SetDesaturated(true)

	-- Control Frame
	InspectModelFrameControlFrame:StripTextures()

	local controlbuttons = {
		"InspectModelFrameControlFrameZoomInButton",
		"InspectModelFrameControlFrameZoomOutButton",
		"InspectModelFrameControlFramePanButton",
		"InspectModelFrameControlFrameRotateRightButton",
		"InspectModelFrameControlFrameRotateLeftButton",
		"InspectModelFrameControlFrameRotateResetButton"
	}

	for i = 1, #controlbuttons do
		S:HandleButton(_G[controlbuttons[i]]);
		_G[controlbuttons[i]]:StyleButton()
		_G[controlbuttons[i].."Bg"]:Hide()
	end
end

S:AddCallbackForAddon("Blizzard_InspectUI", "Inspect", LoadSkin);