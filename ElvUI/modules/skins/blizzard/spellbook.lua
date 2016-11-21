local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule("Skins");

local _G = _G;
local select, unpack = select, unpack;

local function LoadSkin()
	if(E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.spellbook ~= true) then return; end

	SpellBookFrame:StripTextures(true);
	SpellBookFrame:SetTemplate("Transparent")
	SpellBookFrame:Width(460)

	SpellBookFrameInset:StripTextures(true);
	SpellBookSpellIconsFrame:StripTextures(true);
	SpellBookSideTabsFrame:StripTextures(true);
	SpellBookPageNavigationFrame:StripTextures(true);

	SpellBookPageText:SetTextColor(1, 1, 1)
	SpellBookPageText:Point("BOTTOMRIGHT", SpellBookFrame, "BOTTOMRIGHT", -90, 15)

	S:HandleNextPrevButton(SpellBookPrevPageButton)
	SpellBookPrevPageButton:Point("BOTTOMRIGHT", SpellBookFrame, "BOTTOMRIGHT", -45, 10)

	S:HandleNextPrevButton(SpellBookNextPageButton)
	SpellBookNextPageButton:Point("BOTTOMRIGHT", SpellBookPageNavigationFrame, "BOTTOMRIGHT", -10, 10)

	S:HandleCloseButton(SpellBookFrameCloseButton)

	-- Spell Buttons
	for i = 1, SPELLS_PER_PAGE do
		local button = _G["SpellButton"..i]
		local icon = _G["SpellButton"..i.."IconTexture"]
		local cooldown = _G["SpellButton"..i.."Cooldown"]
		local spellName = _G["SpellButton"..i.."SpellName"]

		button:CreateBackdrop("Default", true)
		button.backdrop:SetFrameLevel(button.backdrop:GetFrameLevel() - 1)

		icon:SetTexCoord(unpack(E.TexCoords))

		_G["SpellButton"..i.."SubSpellName"]:SetTextColor(0.6, 0.6, 0.6)
		_G["SpellButton"..i.."RequiredLevelString"]:SetTextColor(0.6, 0.6, 0.6)

		button.bg = CreateFrame("Frame", nil, button)
		button.bg:CreateBackdrop("Transparent", true);
		button.bg:Point("TOPLEFT", -7, 8);
		button.bg:Point("BOTTOMRIGHT", 170, -10);
		button.bg:SetFrameLevel(button.bg:GetFrameLevel() - 2)

		if(cooldown) then
			E:RegisterCooldown(cooldown);
		end
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

	local function SpellButtons(_, first)
		for i = 1, SPELLS_PER_PAGE do
			local button = _G["SpellButton"..i]
			local highlight = _G["SpellButton"..i.."Highlight"]
			local spellName = _G["SpellButton"..i.."SpellName"]

			if(first) then
				for i = 1, button:GetNumRegions() do
					local region = select(i, button:GetRegions())
					if(region:GetObjectType() == "Texture") then
						if(region:GetTexture() ~= "Interface\\Buttons\\ActionBarFlyoutButton") then
							region:SetTexture(nil)
						end
					end
				end
			end

			if(highlight) then
				highlight:SetTexture(1, 1, 1, 0.3)
			end

			local r, g, b = spellName:GetTextColor()

			if(r < 0.8) then
				spellName:SetTextColor(0.6, 0.6, 0.6)
			end
		end
	end
	SpellButtons(nil, true)
	hooksecurefunc("SpellButton_UpdateButton", SpellButtons)

	--Skill Line Tabs
	local function SkinTab(tab)
		tab:StripTextures()
		tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
		tab:GetNormalTexture():SetInside()

		tab.pushed = true;
		tab:CreateBackdrop("Default")
		tab.backdrop:SetAllPoints()
		tab:StyleButton(true)
		hooksecurefunc(tab:GetHighlightTexture(), "SetTexture", function(self, texPath)
			if(texPath ~= nil) then
				self:SetPushedTexture(nil);
			end
		end)

		hooksecurefunc(tab:GetCheckedTexture(), "SetTexture", function(self, texPath)
			if(texPath ~= nil) then
				self:SetHighlightTexture(nil);
			end
		end)

		local point, relatedTo, point2, x, y = tab:GetPoint()
		tab:Point(point, relatedTo, point2, 1, y)
	end

	for i = 1, MAX_SKILLLINE_TABS do
		local tab = _G["SpellBookSkillLineTab"..i]
		_G["SpellBookSkillLineTab"..i.."Flash"]:Kill()
		SkinTab(tab)
		tab:StyleButton(nil, true);
	end

	local function SkinSkillLine()
		for i = 1, MAX_SKILLLINE_TABS do
			local tab = _G["SpellBookSkillLineTab"..i]
			local _, _, _, _, isGuild = GetSpellTabInfo(i)
			if(isGuild) then
				tab:GetNormalTexture():SetInside()
				tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
				tab:StyleButton(nil, true);
			end
		end
	end
	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", SkinSkillLine)

	SpellBookSkillLineTab1:Point("TOPLEFT", SpellBookSideTabsFrame, "TOPRIGHT", -1, -40)

	--Bottom Tabs
	for i = 1, 5 do
		S:HandleTab(_G["SpellBookFrameTabButton"..i])
	end

	SpellBookFrameTabButton1:ClearAllPoints()
	SpellBookFrameTabButton1:Point("TOPLEFT", SpellBookFrame, "BOTTOMLEFT", 0, 2)

	-- Primary Professions
	PrimaryProfession1:Point("TOPLEFT", 10, -30)
	PrimaryProfession2:Point("TOPLEFT", 10, -130)

	for i = 1, 2 do
		local primaryProf = _G["PrimaryProfession"..i]
		local primaryBar = _G["PrimaryProfession"..i.."StatusBar"]
		local primaryRank = _G["PrimaryProfession"..i.."Rank"]
		local primaryUnlearn = _G["PrimaryProfession"..i.."UnlearnButton"]
		local primarySpellTop = _G["PrimaryProfession"..i.."SpellButtonTop"]
		local primarySpellBot = _G["PrimaryProfession"..i.."SpellButtonBottom"]
		local primaryMissing = _G["PrimaryProfession"..i.."Missing"]
		local primarySpellButtonTop = _G["PrimaryProfession"..i.."SpellButtonTop"]
		local primarySpellButtonTopTex = _G["PrimaryProfession"..i.."SpellButtonTopIconTexture"]
		local primarySpellButtonBot = _G["PrimaryProfession"..i.."SpellButtonBottom"]
		local primarySpellButtonBotTex = _G["PrimaryProfession"..i.."SpellButtonBottomIconTexture"]
		local cooldown1 = _G["PrimaryProfession"..i.."SpellButtonTopCooldown"]
		local cooldown2 = _G["PrimaryProfession"..i.."SpellButtonBottomCooldown"]

		primaryProf:CreateBackdrop("Transparent")
		primaryProf:Height(90)

		primaryBar:StripTextures()
		primaryBar:CreateBackdrop("Default")
		primaryBar:SetStatusBarTexture(E["media"].normTex)
		primaryBar:SetStatusBarColor(0.11, 0.50, 1.00)
		primaryBar:SetSize(180, 20)
		primaryBar:Point("TOPLEFT", 250, -10)

		primaryBar.rankText:Point("CENTER")
		primaryBar.rankText:FontTemplate(nil, 12, "OUTLINE");

		primaryRank:Point("TOPLEFT", 120, -23)
		primaryUnlearn:Point("RIGHT", primaryBar, "LEFT", -135, -10)

		primarySpellTop:Point("TOPRIGHT", primaryProf, "TOPRIGHT", -225, -45)
		primarySpellBot:Point("TOPLEFT", primarySpellTop, "BOTTOMLEFT", 135, 40)

		primaryMissing:SetTextColor(1, 0.80, 0.10)

		primaryProf.missingText:SetTextColor(1, 1, 1)
		primaryProf.missingText:FontTemplate(nil, 12, "OUTLINE")

		primarySpellButtonTop:StripTextures()
		primarySpellButtonTop:CreateBackdrop("Default", true)
		primarySpellButtonTop:GetHighlightTexture():Hide()
		primarySpellButtonTop:StyleButton(true)
		primarySpellButtonTop:SetFrameLevel(primarySpellButtonTop:GetFrameLevel() + 2)

		primarySpellButtonTopTex:SetTexCoord(unpack(E.TexCoords))
		primarySpellButtonTopTex:SetInside()

		primarySpellButtonBot:StripTextures()
		primarySpellButtonBot:CreateBackdrop("Default", true)
		primarySpellButtonBot:GetHighlightTexture():Hide()
		primarySpellButtonBot:StyleButton(true)
		primarySpellButtonBot:SetFrameLevel(primarySpellButtonBot:GetFrameLevel() + 2)

		primarySpellButtonBotTex:SetTexCoord(unpack(E.TexCoords))
		primarySpellButtonBotTex:SetInside()

		_G["PrimaryProfession"..i.."SpellButtonTopSubSpellName"]:SetTextColor(1, 1, 1)
		_G["PrimaryProfession"..i.."SpellButtonBottomSubSpellName"]:SetTextColor(1, 1, 1)

		_G["PrimaryProfession"..i.."IconBorder"]:Hide()
		_G["PrimaryProfession"..i.."Icon"]:SetTexCoord(unpack(E.TexCoords))

		if(cooldown1) then
			E:RegisterCooldown(cooldown1);
		end

		if(cooldown2) then
			E:RegisterCooldown(cooldown2);
		end
	end

	-- Secondary Professions
	for i = 1, 4 do
		local secondaryProf = _G["SecondaryProfession"..i]
		local secondaryBar = _G["SecondaryProfession"..i.."StatusBar"]
		local spellButtonRight = _G["SecondaryProfession"..i.."SpellButtonRight"]
		local secondaryMissing =  _G["SecondaryProfession"..i.."Missing"]
		local secondarySpellButtonLeft = _G["SecondaryProfession"..i.."SpellButtonLeft"]
		local secondarySpellButtonLeftTex = _G["SecondaryProfession"..i.."SpellButtonLeftIconTexture"]
		local secondarySpellButtonRight = _G["SecondaryProfession"..i.."SpellButtonRight"]
		local secondarySpellButtonRightTex = _G["SecondaryProfession"..i.."SpellButtonRightIconTexture"]
		local cooldown1 = _G["SecondaryProfession"..i.."SpellButtonLeftCooldown"]
		local cooldown2 = _G["SecondaryProfession"..i.."SpellButtonRightCooldown"]

		secondaryProf:CreateBackdrop("Transparent")
		secondaryProf:Height(60)

		secondaryBar:StripTextures()
		secondaryBar:CreateBackdrop("Default")
		secondaryBar:SetStatusBarTexture(E["media"].normTex)
		secondaryBar:SetStatusBarColor(0.11, 0.50, 1.00)
		secondaryBar:SetSize(120, 18)
		secondaryBar:Point("TOPLEFT", 5, -35)

		secondaryBar.rankText:Point("CENTER")
		secondaryBar.rankText:FontTemplate(nil, 12, "OUTLINE");

		spellButtonRight:Point("TOPRIGHT", -90, -10)

		secondaryMissing:SetTextColor(1, 0.80, 0.10)

		secondaryProf.missingText:SetTextColor(1, 1, 1)
		secondaryProf.missingText:FontTemplate(nil, 12, "OUTLINE")

		secondarySpellButtonLeft:StripTextures()
		secondarySpellButtonLeft:CreateBackdrop("Default", true)
		secondarySpellButtonLeft:GetHighlightTexture():Hide()
		secondarySpellButtonLeft:StyleButton(true)
		secondarySpellButtonLeft:SetFrameLevel(secondarySpellButtonLeft:GetFrameLevel() + 2)

		secondarySpellButtonLeftTex:SetTexCoord(unpack(E.TexCoords))
		secondarySpellButtonLeftTex:SetInside()

		secondarySpellButtonRight:StripTextures()
		secondarySpellButtonRight:CreateBackdrop("Default", true)
		secondarySpellButtonRight:GetHighlightTexture():Hide()
		secondarySpellButtonRight:StyleButton(true)
		secondarySpellButtonRight:SetFrameLevel(secondarySpellButtonRight:GetFrameLevel() + 2)

		secondarySpellButtonRightTex:SetTexCoord(unpack(E.TexCoords))
		secondarySpellButtonRightTex:SetInside()

		_G["SecondaryProfession"..i.."SpellButtonRightSubSpellName"]:SetTextColor(1, 1, 1)
		_G["SecondaryProfession"..i.."SpellButtonLeftSubSpellName"]:SetTextColor(1, 1, 1)

		if(cooldown1) then
			E:RegisterCooldown(cooldown1);
		end

		if(cooldown2) then
			E:RegisterCooldown(cooldown2);
		end
	end

	SecondaryProfession1SpellButtonLeft:Point("TOPRIGHT", SecondaryProfession1SpellButtonRight, "TOPLEFT", -96, 0)
	SecondaryProfession3SpellButtonLeft:Point("TOPRIGHT", SecondaryProfession3SpellButtonRight, "TOPLEFT", -96, 0)

	--Mounts/Companions
	for i = 1, NUM_COMPANIONS_PER_PAGE do
		local button = _G["SpellBookCompanionButton"..i]
		local icon = _G["SpellBookCompanionButton"..i.."IconTexture"]
		button:StripTextures()
		button:StyleButton(false)

		if(icon) then
			icon:SetTexCoord(unpack(E.TexCoords))
			icon:SetInside()

			button:SetFrameLevel(button:GetFrameLevel() + 2)
			button:CreateBackdrop("Default", true)
		end
	end

	for i = 1, 12 do
		_G["SpellBookCompanionButton" .. i]:CreateBackdrop("Transparent", true);
		_G["SpellBookCompanionButton" .. i].backdrop:Point("TOPLEFT", -3, 3);
		_G["SpellBookCompanionButton" .. i].backdrop:Point("BOTTOMRIGHT", 105, -3);
	end

	SpellBookCompanionButton1:Point("TOPLEFT",  SpellBookCompanionsFrame, "TOPLEFT", 10, -280)

	SpellBookCompanionModelFrame:StripTextures()
	SpellBookCompanionModelFrame:SetTemplate("Transparent")
	SpellBookCompanionModelFrame:ClearAllPoints()
	SpellBookCompanionModelFrame:Point("TOP", SpellBookCompanionsFrame, "TOP", 0, -60)
	SpellBookCompanionModelFrame:Width(270)
	SpellBookCompanionModelFrame:Height(185)

	SpellBookCompanionModelFrameShadowOverlay:StripTextures()
	SpellBookCompanionsModelFrame:Kill()

	S:HandleButton(SpellBookCompanionSummonButton)
	SpellBookCompanionSummonButton:Point("BOTTOM", SpellBookCompanionModelFrame, "BOTTOM", -3, -235)
	SpellBookCompanionSummonButton:SetScale(1.1)

	SpellBookCompanionSelectedName:Point("TOP", SpellBookCompanionModelFrame, "TOP", 0, 175)

	S:HandleRotateButton(SpellBookCompanionModelFrameRotateRightButton)
	S:HandleRotateButton(SpellBookCompanionModelFrameRotateLeftButton)
	SpellBookCompanionModelFrameRotateLeftButton:ClearAllPoints()
	SpellBookCompanionModelFrameRotateLeftButton:Point("TOPLEFT", SpellBookCompanionModelFrame, "TOPLEFT", 2, -2)

	SpellBookCompanionModelFrameRotateRightButton:SetAlpha(0)
	SpellBookCompanionModelFrameRotateLeftButton:SetAlpha(0)

	SpellBookCompanionModelFrame:HookScript("OnEnter", function()
		SpellBookCompanionModelFrameRotateRightButton:SetAlpha(1)
		SpellBookCompanionModelFrameRotateLeftButton:SetAlpha(1)
	end)

	SpellBookFrame:HookScript("OnEnter", function()
		SpellBookCompanionModelFrameRotateRightButton:SetAlpha(0)
		SpellBookCompanionModelFrameRotateLeftButton:SetAlpha(0)
	end)
end

S:AddCallback("Spellbook", LoadSkin);