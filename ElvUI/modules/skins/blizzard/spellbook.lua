local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local select, unpack = select, unpack

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.spellbook ~= true then return end

	local SpellBookFrame = _G["SpellBookFrame"]
	SpellBookFrame:StripTextures(true)
	SpellBookFrame:SetTemplate("Transparent")
	SpellBookFrame:Width(460)

	SpellBookFrameInset:StripTextures(true)
	SpellBookSpellIconsFrame:StripTextures(true)
	SpellBookSideTabsFrame:StripTextures(true)
	SpellBookPageNavigationFrame:StripTextures(true)

	SpellBookPageText:SetTextColor(1, 1, 1)
	SpellBookPageText:Point("BOTTOMRIGHT", SpellBookFrame, "BOTTOMRIGHT", -90, 15)

	S:HandleNextPrevButton(SpellBookPrevPageButton)
	SpellBookPrevPageButton:Point("BOTTOMRIGHT", SpellBookFrame, "BOTTOMRIGHT", -45, 10)
	SpellBookPrevPageButton:Size(24)

	S:HandleNextPrevButton(SpellBookNextPageButton)
	SpellBookNextPageButton:Point("BOTTOMRIGHT", SpellBookPageNavigationFrame, "BOTTOMRIGHT", -10, 10)
	SpellBookNextPageButton:Size(24)

	S:HandleCloseButton(SpellBookFrameCloseButton)

	-- Spell Buttons
	for i = 1, SPELLS_PER_PAGE do
		local button = _G["SpellButton"..i]
		local icon = _G["SpellButton"..i.."IconTexture"]
		local cooldown = _G["SpellButton"..i.."Cooldown"]

		for i = 1, button:GetNumRegions() do
			local region = select(i, button:GetRegions())
			if region:GetObjectType() == "Texture" then
				if region:GetTexture() ~= "Interface\\Buttons\\ActionBarFlyoutButton" then
					region:SetTexture(nil)
				end
			end
		end

		button:CreateBackdrop("Default", true)
		button.backdrop:SetFrameLevel(button.backdrop:GetFrameLevel() - 1)

		icon:SetTexCoord(unpack(E.TexCoords))

		button.SpellSubName:SetTextColor(0.6, 0.6, 0.6)
		button.RequiredLevelString:SetTextColor(0.6, 0.6, 0.6)

		button.bg = CreateFrame("Frame", nil, button)
		button.bg:CreateBackdrop("Transparent", true)
		button.bg:Point("TOPLEFT", -7, 9)
		button.bg:Point("BOTTOMRIGHT", 170, -10)
		button.bg:SetFrameLevel(button.bg:GetFrameLevel() - 2)

		E:RegisterCooldown(cooldown)
	end

	SpellButton1:Point("TOPLEFT", SpellBookSpellIconsFrame, "TOPLEFT", 15, -75)
	SpellButton2:Point("TOPLEFT", SpellButton1, "TOPLEFT", 225, 0)
	SpellButton3:Point("TOPLEFT", SpellButton1, "BOTTOMLEFT", 0, -27)
	SpellButton4:Point("TOPLEFT", SpellButton3, "TOPLEFT", 225, 0)
	SpellButton5:Point("TOPLEFT", SpellButton3, "BOTTOMLEFT", 0, -27)
	SpellButton6:Point("TOPLEFT", SpellButton5, "TOPLEFT", 225, 0)
	SpellButton7:Point("TOPLEFT", SpellButton5, "BOTTOMLEFT", 0, -27)
	SpellButton8:Point("TOPLEFT", SpellButton7, "TOPLEFT", 225, 0)
	SpellButton9:Point("TOPLEFT", SpellButton7, "BOTTOMLEFT", 0, -27)
	SpellButton10:Point("TOPLEFT", SpellButton9, "TOPLEFT", 225, 0)
	SpellButton11:Point("TOPLEFT", SpellButton9, "BOTTOMLEFT", 0, -27)
	SpellButton12:Point("TOPLEFT", SpellButton11, "TOPLEFT", 225, 0)

	hooksecurefunc("SpellButton_UpdateButton", function(self)
		local spellName = _G[self:GetName().."SpellName"]
		local highlight = _G[self:GetName().."Highlight"]

		if highlight then
			highlight:SetTexture(1, 1, 1, 0.3)
		end

		local r, g, b = spellName:GetTextColor()

		if r < 0.8 then
			spellName:SetTextColor(0.6, 0.6, 0.6)
		end
	end)

	-- Skill Line Tabs
	for i = 1, MAX_SKILLLINE_TABS do
		local tab = _G["SpellBookSkillLineTab"..i]
		local flash = _G["SpellBookSkillLineTab"..i.."Flash"]

		tab:StripTextures()
		tab:SetTemplate()
		tab:StyleButton(nil, true)
		tab.pushed = true

		tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
		tab:GetNormalTexture():SetInside()

		if i == 1 then
			tab:Point("TOPLEFT", SpellBookSideTabsFrame, "TOPRIGHT", E.PixelMode and -1 or 1, -40)
		end

		hooksecurefunc(tab:GetHighlightTexture(), "SetTexture", function(self, texPath)
			if texPath ~= nil then
				self:SetPushedTexture(nil)
			end
		end)

		hooksecurefunc(tab:GetCheckedTexture(), "SetTexture", function(self, texPath)
			if texPath ~= nil then
				self:SetHighlightTexture(nil)
			end
		end)

		flash:Kill()
	end

	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", function()
		for i = 1, MAX_SKILLLINE_TABS do
			local tab = _G["SpellBookSkillLineTab"..i]
			local _, _, _, _, isGuild = GetSpellTabInfo(i)

			if isGuild then
				tab:GetNormalTexture():SetInside()
				tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
				tab:StyleButton(nil, true)
			end
		end
	end)

	-- Bottom Tabs
	for i = 1, 5 do
		local tab = _G["SpellBookFrameTabButton"..i]

		S:HandleTab(tab)

		if i == 1 then
			tab:ClearAllPoints()
			tab:Point("TOPLEFT", SpellBookFrame, "BOTTOMLEFT", 0, 2)
		end
	end

	-- Professions
	for frame, numItems in pairs({["PrimaryProfession"] = 2, ["SecondaryProfession"] = 4}) do
		for i = 1, numItems do
			local item = _G[frame..i]

			item:StripTextures()
			item:CreateBackdrop("Transparent")
			item:Height(numItems == 2 and 90 or 60)

			item.missingHeader:SetTextColor(1, 0.80, 0.10)
			item.missingText:SetTextColor(1, 1, 1)
			item.missingText:FontTemplate(nil, 12, "OUTLINE")

			item.statusBar:StripTextures()
			item.statusBar:CreateBackdrop("Default")
			item.statusBar:SetStatusBarTexture(E.media.normTex)
			item.statusBar:SetStatusBarColor(0.22, 0.39, 0.84)
			item.statusBar:Size(numItems == 2 and 180 or 120, numItems == 2 and 20 or 18)
			item.statusBar:Point("TOPLEFT", numItems == 2 and 250 or 5, numItems == 2 and -10 or -35)
			item.statusBar.rankText:Point("CENTER")
			item.statusBar.rankText:FontTemplate(nil, 12, "OUTLINE")

			if item.unlearn then item.unlearn:Point("RIGHT", item.statusBar, "LEFT", -135, -10) end
			if item.icon then item.icon:SetTexCoord(unpack(E.TexCoords)) end

			if numItems == 2 then
				item:Point("TOPLEFT", 10, -(i == 1 and 30 or 130))
				item.rank:Point("TOPLEFT", 120, -23)
			end

			for j = 1, 2 do
				local button = item["button"..j]

				button:StripTextures()
				button:CreateBackdrop("Default")
				button:SetFrameLevel(button:GetFrameLevel() + 2)

				if numItems == 2 then
					button:Point(j == 1 and "TOPLEFT" or "TOPRIGHT", j == 1 and item.button2 or item, j == 1 and "BOTTOMLEFT" or "TOPRIGHT", j == 1 and 135 or -235, j == 1 and 40 or -45)
				elseif numItems == 4 then
					button:Point("TOPRIGHT", j == 1 and item or item.button1, j == 1 and "TOPRIGHT" or "TOPLEFT", j == 1 and -100 or -95, j == 1 and -10 or 0)
				end

				button:StyleButton(true)
				button.pushed:SetAllPoints()
				button.checked:SetAllPoints()
				button.highlightTexture:SetAllPoints()
				hooksecurefunc(button.highlightTexture, "SetTexture", function(self, texture)
					if texture == "Interface\\Buttons\\ButtonHilight-Square" then
						self:SetTexture(1, 1, 1, 0.3)
					end
				end)

				button.iconTexture:SetTexCoord(unpack(E.TexCoords))
				button.iconTexture:SetAllPoints()

				button.subSpellString:SetTextColor(1, 1, 1)

				button.cooldown:SetAllPoints()
				E:RegisterCooldown(button.cooldown)
			end
		end
	end

	-- Mounts/Companions
	for i = 1, NUM_COMPANIONS_PER_PAGE do
		local button = _G["SpellBookCompanionButton"..i]

		button:StripTextures()
		button:SetTemplate("Default", true)
		button:StyleButton(false)

		if i == 1 then
			button:Point("TOPLEFT", 9, -310)
		end

		button.IconTexture:SetTexCoord(unpack(E.TexCoords))
		button.IconTexture:SetInside(button)

		button.bg = CreateFrame("Frame", nil, button)
		button.bg:CreateBackdrop("Transparent", true)
		button.bg:Point("TOPLEFT", E.PixelMode and 1 or -1, E.PixelMode and -1 or 1)
		button.bg:Point("BOTTOMRIGHT", 105, E.PixelMode and 1 or -1)
	end

	SpellBookCompanionModelFrame:StripTextures()
	SpellBookCompanionModelFrame:CreateBackdrop()
	SpellBookCompanionModelFrame:Size(410, 255)
	SpellBookCompanionModelFrame:ClearAllPoints()
	SpellBookCompanionModelFrame:Point("TOP", SpellBookCompanionsFrame, "TOP", 0, -46)

	SpellBookCompanionsModelFrame:SetInside(SpellBookCompanionModelFrame.backdrop)
	SpellBookCompanionsModelFrame:SetDesaturated(true)

	S:HandleButton(SpellBookCompanionSummonButton)
	SpellBookCompanionSummonButton:Point("BOTTOM", -3, 10)
	SpellBookCompanionSummonButton:Size(140, 25)

	SpellBookCompanionSelectedName:Point("TOP", 0, 255)

	SpellBookCompanionModelFrameRotateRightButton:Kill()
	SpellBookCompanionModelFrameRotateLeftButton:Kill()
end

S:AddCallback("Spellbook", LoadSkin)