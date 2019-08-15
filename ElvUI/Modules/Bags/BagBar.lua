local E, L, V, P, G = unpack(select(2, ...))
local B = E:GetModule("Bags")

local _G = _G
local unpack = unpack
local tinsert = table.insert

local CreateFrame = CreateFrame
local NUM_BAG_FRAMES = NUM_BAG_FRAMES
local RegisterStateDriver = RegisterStateDriver

local function OnEnter()
	if not E.db.bags.bagBar.mouseover then return end
	E:UIFrameFadeOut(ElvUIBags, 0.2, ElvUIBags:GetAlpha(), 1)
end

local function OnLeave()
	if not E.db.bags.bagBar.mouseover then return end
	E:UIFrameFadeOut(ElvUIBags, 0.2, ElvUIBags:GetAlpha(), 0)
end

function B:SkinBag(bag)
	local icon = _G[bag:GetName().."IconTexture"]
	bag.oldTex = icon:GetTexture()

	bag:StripTextures()
	bag:SetTemplate("Default", true)
	bag:StyleButton(true)

	icon:SetTexture(bag.oldTex)
	icon:SetInside()
	icon:SetTexCoord(unpack(E.TexCoords))
end

function B:SizeAndPositionBagBar()
	if not ElvUIBags then return end

	local buttonSpacing = E:Scale(E.db.bags.bagBar.spacing)
	local backdropSpacing = E:Scale(E.db.bags.bagBar.backdropSpacing)
	local bagBarSize = E:Scale(E.db.bags.bagBar.size)
	local showBackdrop = E.db.bags.bagBar.showBackdrop
	local growthDirection = E.db.bags.bagBar.growthDirection
	local sortDirection = E.db.bags.bagBar.sortDirection

	local visibility = E.db.bags.bagBar.visibility
	if visibility and visibility:match("[\n\r]") then
		visibility = visibility:gsub("[\n\r]","")
	end

	RegisterStateDriver(ElvUIBags, "visibility", visibility)

	if E.db.bags.bagBar.mouseover then
		ElvUIBags:SetAlpha(0)
	else
		ElvUIBags:SetAlpha(1)
	end

	if showBackdrop then
		ElvUIBags.backdrop:Show()
	else
		ElvUIBags.backdrop:Hide()
	end

	local bdpSpacing = (showBackdrop and backdropSpacing + E.Border) or 0
	local btnSpacing = (buttonSpacing + E.Border)

	for i = 1, #ElvUIBags.buttons do
		local button = ElvUIBags.buttons[i]
		local prevButton = ElvUIBags.buttons[i - 1]
		button:SetSize(bagBarSize, bagBarSize)
		button:ClearAllPoints()

		if growthDirection == "HORIZONTAL" and sortDirection == "ASCENDING" then
			if i == 1 then
				button:SetPoint("LEFT", ElvUIBags, "LEFT", bdpSpacing, 0)
			elseif prevButton then
				button:SetPoint("LEFT", prevButton, "RIGHT", btnSpacing, 0)
			end
		elseif growthDirection == "VERTICAL" and sortDirection == "ASCENDING" then
			if i == 1 then
				button:SetPoint("TOP", ElvUIBags, "TOP", 0, -bdpSpacing)
			elseif prevButton then
				button:SetPoint("TOP", prevButton, "BOTTOM", 0, -btnSpacing)
			end
		elseif growthDirection == "HORIZONTAL" and sortDirection == "DESCENDING" then
			if i == 1 then
				button:SetPoint("RIGHT", ElvUIBags, "RIGHT", -bdpSpacing, 0)
			elseif prevButton then
				button:SetPoint("RIGHT", prevButton, "LEFT", -btnSpacing, 0)
			end
		else
			if i == 1 then
				button:SetPoint("BOTTOM", ElvUIBags, "BOTTOM", 0, bdpSpacing)
			elseif prevButton then
				button:SetPoint("BOTTOM", prevButton, "TOP", 0, btnSpacing)
			end
		end
	end

	local btnSize = bagBarSize * (NUM_BAG_FRAMES + 1)
	local btnSpace = btnSpacing * NUM_BAG_FRAMES
	local bdpDoubled = bdpSpacing * 2

	if growthDirection == "HORIZONTAL" then
		ElvUIBags:SetWidth(btnSize + btnSpace + bdpDoubled)
		ElvUIBags:SetHeight(bagBarSize + bdpDoubled)
	else
		ElvUIBags:SetHeight(btnSize + btnSpace + bdpDoubled)
		ElvUIBags:SetWidth(bagBarSize + bdpDoubled)
	end
end

function B:LoadBagBar()
	if not E.private.bags.bagBar then return end

	local ElvUIBags = CreateFrame("Frame", "ElvUIBags", E.UIParent)
	ElvUIBags:Point("TOPRIGHT", RightChatPanel, "TOPLEFT", -4, 0)
	ElvUIBags.buttons = {}
	ElvUIBags:CreateBackdrop()
	ElvUIBags.backdrop:SetAllPoints()
	ElvUIBags:EnableMouse(true)
	ElvUIBags:SetScript("OnEnter", OnEnter)
	ElvUIBags:SetScript("OnLeave", OnLeave)

	MainMenuBarBackpackButton:SetParent(ElvUIBags)
	MainMenuBarBackpackButton.SetParent = E.dummy
	MainMenuBarBackpackButton:ClearAllPoints()

	MainMenuBarBackpackButtonCount:FontTemplate(nil, 10)
	MainMenuBarBackpackButtonCount:ClearAllPoints()
	MainMenuBarBackpackButtonCount:Point("BOTTOMRIGHT", MainMenuBarBackpackButton, "BOTTOMRIGHT", -1, 4)

	MainMenuBarBackpackButton:HookScript("OnEnter", OnEnter)
	MainMenuBarBackpackButton:HookScript("OnLeave", OnLeave)

	tinsert(ElvUIBags.buttons, MainMenuBarBackpackButton)
	B:SkinBag(MainMenuBarBackpackButton)

	for i = 0, NUM_BAG_FRAMES - 1 do
		local slot = _G["CharacterBag"..i.."Slot"]

		slot:SetParent(ElvUIBags)
		slot.SetParent = E.dummy
		slot:HookScript("OnEnter", OnEnter)
		slot:HookScript("OnLeave", OnLeave)

		B:SkinBag(slot)
		tinsert(ElvUIBags.buttons, slot)
	end

	B:SizeAndPositionBagBar()
	E:CreateMover(ElvUIBags, "BagsMover", L["Bags"], nil, nil, nil, nil, nil, "bags,general")
end