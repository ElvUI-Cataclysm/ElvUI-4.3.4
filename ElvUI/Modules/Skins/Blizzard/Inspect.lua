local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local pairs, unpack = pairs, unpack

local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.inspect then return end

	local InspectFrame = _G["InspectFrame"]
	InspectFrame:StripTextures(true)
	InspectFrame:SetTemplate("Transparent")

	InspectFrameInset:StripTextures(true)

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
	InspectModelFrame:CreateBackdrop("Default")

	--Re-add the overlay texture which was removed via StripTextures
	InspectModelFrameBackgroundOverlay:SetTexture(0, 0, 0)

	-- Give inspect frame model backdrop it's color back
	for _, corner in pairs({"TopLeft", "TopRight", "BotLeft", "BotRight"}) do
		local bg = _G["InspectModelFrameBackground"..corner]
		if bg then
			bg:SetDesaturated(false)
			bg.ignoreDesaturated = true -- so plugins can prevent this if they want.

			hooksecurefunc(bg, "SetDesaturated", function(bckgnd, value)
				if value and bckgnd.ignoreDesaturated then
					bckgnd:SetDesaturated(false)
				end
			end)
		end
	end

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
		local button = _G["Inspect"..slot]
		local icon = _G["Inspect"..slot.."IconTexture"]

		button:StripTextures()
		button:CreateBackdrop("Default")
		button.backdrop:SetAllPoints()
		button:SetFrameLevel(button:GetFrameLevel() + 2)
		button:StyleButton()

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside()
	end

	hooksecurefunc("InspectPaperDollItemSlotButton_Update", function(button)
		if button.hasItem then
			local itemID = GetInventoryItemLink(InspectFrame.unit, button:GetID())
			if itemID then
				local _, _, quality = GetItemInfo(itemID)
				if not quality then
					E:Delay(0.1, function()
						if InspectFrame.unit then
							InspectPaperDollItemSlotButton_Update(button)
						end
					end)
					return
				elseif quality then
					button.backdrop:SetBackdropBorderColor(GetItemQualityColor(quality))
					return
				end
			end
		else
			button.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
	end)

	-- PvP Tab
	InspectPVPFrame:HookScript("OnShow", function() InspectPVPFrameBG:Kill() end)
	InspectPVPFrameBottom:Kill()

	for i = 1, MAX_ARENA_TEAMS do
		local frame = _G["InspectPVPTeam"..i]
		local standard = _G["InspectPVPTeam"..i.."Standard"]

		frame:StripTextures()
		frame:CreateBackdrop()
		frame.backdrop:Point("TOPLEFT", 8, -2)
		frame.backdrop:Point("BOTTOMRIGHT", -21, 2)
		frame:SetHitRectInsets(8, 22, 2, 2)
		frame:EnableMouse(true)

		frame:Point("LEFT", standard, "LEFT", 38, 0)

		frame:HookScript("OnEnter", S.SetModifiedBackdrop)
		frame:HookScript("OnLeave", S.SetOriginalBackdrop)
	end

	-- Talent Tab
	for i = 1, MAX_TALENT_TABS do
		local headerTab = _G["InspectTalentFrameTab"..i]

		headerTab:StripTextures()
		headerTab.backdrop = CreateFrame("Frame", nil, headerTab)
		headerTab.backdrop:SetTemplate("Default", true)
		headerTab.backdrop:SetFrameLevel(headerTab:GetFrameLevel() - 1)
		headerTab.backdrop:Point("TOPLEFT", 3, -7)
		headerTab.backdrop:Point("BOTTOMRIGHT", 0, -1)

		headerTab:Width(108)
		headerTab.SetWidth = E.noop
		headerTab:SetHitRectInsets(3, 0, 7, -1)

		if i == 1 then
			headerTab:Point("BOTTOMLEFT", InspectFrameInset, "TOPLEFT", 0, 4)
		end

		headerTab:HookScript("OnEnter", S.SetModifiedBackdrop)
		headerTab:HookScript("OnLeave", S.SetOriginalBackdrop)
	end

	InspectTalentFramePointsBar:StripTextures()

	InspectTalentFrame.bg = CreateFrame("Frame", nil, InspectTalentFrame)
	InspectTalentFrame.bg:SetTemplate("Default")
	InspectTalentFrame.bg:Point("TOPLEFT", InspectTalentFrameBackgroundTopLeft, "TOPLEFT", 0, 0)
	InspectTalentFrame.bg:Point("BOTTOMRIGHT", InspectTalentFrameBackgroundBottomRight, "BOTTOMRIGHT", -21, 53)
	InspectTalentFrame.bg:SetBackdropColor(0, 0, 0, 0)
	InspectTalentFrame.bg.backdropTexture:SetAlpha(0)

	InspectTalentFrameBackgroundTopLeft:SetParent(InspectTalentFrame.bg)
	InspectTalentFrameBackgroundTopRight:SetParent(InspectTalentFrame.bg)
	InspectTalentFrameBackgroundBottomLeft:SetParent(InspectTalentFrame.bg)
	InspectTalentFrameBackgroundBottomRight:SetParent(InspectTalentFrame.bg)

	for i = 1, MAX_NUM_TALENTS do
		local button = _G["InspectTalentFrameTalent"..i]
		local icon = _G["InspectTalentFrameTalent"..i.."IconTexture"]

		if button then
			button:StripTextures()
			button:StyleButton()
			button:SetTemplate("Default")

			button:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
			button.SetHighlightTexture = E.noop
			button:GetHighlightTexture():SetAllPoints(icon)
			button.SetPushedTexture = E.noop
			button:GetPushedTexture():SetTexCoord(unpack(E.TexCoords))
			button:GetPushedTexture():SetAllPoints(icon)

			icon:SetTexCoord(unpack(E.TexCoords))
			icon:SetInside()

			if button.Rank then
				button.Rank:FontTemplate(nil, 12, "OUTLINE")
				button.Rank:ClearAllPoints()
				button.Rank:SetPoint("BOTTOMRIGHT", 9, -12)
			end
		end
	end

	-- Guild Tab
	InspectGuildFrame.bg = CreateFrame("Frame", nil, InspectGuildFrame)
	InspectGuildFrame.bg:SetTemplate("Default")
	InspectGuildFrame.bg:Point("TOPLEFT", 7, -63)
	InspectGuildFrame.bg:Point("BOTTOMRIGHT", -9, 27)
	InspectGuildFrame.bg:SetBackdropColor(0, 0, 0, 0)
	InspectGuildFrame.bg.backdropTexture:SetAlpha(0)

	InspectGuildFrameBG:SetInside(InspectGuildFrame.bg)
	InspectGuildFrameBG:SetParent(InspectGuildFrame.bg)
	InspectGuildFrameBG:SetDesaturated(true)

	InspectGuildFrameBanner:SetParent(InspectGuildFrame.bg)
	InspectGuildFrameBannerBorder:SetParent(InspectGuildFrame.bg)
	InspectGuildFrameTabardLeftIcon:SetParent(InspectGuildFrame.bg)
	InspectGuildFrameTabardRightIcon:SetParent(InspectGuildFrame.bg)
	InspectGuildFrameGuildName:SetParent(InspectGuildFrame.bg)
	InspectGuildFrameGuildLevel:SetParent(InspectGuildFrame.bg)
	InspectGuildFrameGuildNumMembers:SetParent(InspectGuildFrame.bg)

	-- Control Frame
	S:HandleModelControlFrame(InspectModelFrameControlFrame)
end

S:AddCallbackForAddon("Blizzard_InspectUI", "Inspect", LoadSkin)