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

	S:HandleNextPrevButton(SpellBookPrevPageButton)
	S:HandleNextPrevButton(SpellBookNextPageButton)

	--Skin SpellButtons
	local function SpellButtons(self, first)
		for i=1, SPELLS_PER_PAGE do
			local button = _G["SpellButton"..i]
			local icon = _G["SpellButton"..i.."IconTexture"]
			
			if first then
				--button:StripTextures()
				for i=1, button:GetNumRegions() do
					local region = select(i, button:GetRegions())
					if region:GetObjectType() == "Texture" then
						if region:GetTexture() ~= "Interface\\Buttons\\ActionBarFlyoutButton" then
							region:SetTexture(nil)
						end
					end
				end
			end
			
			if _G["SpellButton"..i.."Highlight"] then
				_G["SpellButton"..i.."Highlight"]:SetTexture(1, 1, 1, 0.3)
				_G["SpellButton"..i.."Highlight"]:ClearAllPoints()
				_G["SpellButton"..i.."Highlight"]:SetAllPoints(icon)
			end

			if icon then
				icon:SetTexCoord(unpack(E.TexCoords))
				icon:ClearAllPoints()
				icon:SetAllPoints()

				if not button.backdrop then
					button:CreateBackdrop("Default", true)	
				end
			end	
			
			local r, g, b = _G["SpellButton"..i.."SpellName"]:GetTextColor()

			if r < 0.8 then
				_G["SpellButton"..i.."SpellName"]:SetTextColor(0.6, 0.6, 0.6)
			end
			_G["SpellButton"..i.."SubSpellName"]:SetTextColor(0.6, 0.6, 0.6)
			_G["SpellButton"..i.."RequiredLevelString"]:SetTextColor(0.6, 0.6, 0.6)
		end
	end
	SpellButtons(nil, true)
	hooksecurefunc("SpellButton_UpdateButton", SpellButtons)
	
	SpellBookPageText:SetTextColor(0.6, 0.6, 0.6)

	local function CoreAbilities(i)
		local button = SpellBookCoreAbilitiesFrame.Abilities[i];
		if button.skinned then return; end

		local icon = button.iconTexture

		if not InCombatLockdown() then
			if not button.properFrameLevel then
				button.properFrameLevel = button:GetFrameLevel() + 1
			end
			button:SetFrameLevel(button.properFrameLevel)
		end

		if not button.skinned then
			for i=1, button:GetNumRegions() do
				local region = select(i, button:GetRegions())
				if region:GetObjectType() == "Texture" then
					if region:GetTexture() ~= "Interface\\Buttons\\ActionBarFlyoutButton" then
						region:SetTexture(nil)
					end
				end
			end
			if button.highlightTexture then
				hooksecurefunc(button.highlightTexture,"SetTexture",function(self, texOrR, G, B)
					if texOrR == [[Interface\Buttons\ButtonHilight-Square]] then
						button.highlightTexture:SetTexture(1, 1, 1, 0.3)
					end
				end)
			end
			button.skinned = true
		end

		if icon then
			icon:SetTexCoord(unpack(E.TexCoords))
			icon:ClearAllPoints()
			icon:SetAllPoints()

			if not button.backdrop then
				button:CreateBackdrop("Default", true)
			end
		end

		button.skinned = true;
	end

	local function SkinTab(tab)
		tab:StripTextures()
		tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
		tab:GetNormalTexture():SetInside()

		tab.pushed = true;
		tab:CreateBackdrop("Default")
		tab.backdrop:SetAllPoints()
		tab:StyleButton(true)
		hooksecurefunc(tab:GetHighlightTexture(), "SetTexture", function(self, texPath)
			if texPath ~= nil then
				self:SetPushedTexture(nil);
			end
		end)

		hooksecurefunc(tab:GetCheckedTexture(), "SetTexture", function(self, texPath)
			if texPath ~= nil then
				self:SetHighlightTexture(nil);
			end
		end)

		local point, relatedTo, point2, x, y = tab:GetPoint()
		tab:Point(point, relatedTo, point2, 1, y)
	end

	for i = 1, 12 do
		_G["SpellButton" .. i]:CreateBackdrop("Transparent", true);
		_G["SpellButton" .. i].backdrop:Point("TOPLEFT", -7, 7);
		_G["SpellButton" .. i].backdrop:Point("BOTTOMRIGHT", 140, -7);
	end
	
	SpellButton1:SetPoint("TOPLEFT", SpellBookSpellIconsFrame, "TOPLEFT", 30, -75)
	
	--Skill Line Tabs
	for i=1, MAX_SKILLLINE_TABS do
		local tab = _G["SpellBookSkillLineTab"..i]
		_G["SpellBookSkillLineTab"..i]:CreateBackdrop()
		_G["SpellBookSkillLineTab"..i.."Flash"]:Kill()
		SkinTab(tab)
	end

	local function SkinSkillLine()
		for i=1, MAX_SKILLLINE_TABS do
			local tab = _G["SpellBookSkillLineTab"..i]
			local _, _, _, _, isGuild = GetSpellTabInfo(i)
			if isGuild then
				tab:GetNormalTexture():SetInside()
				tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
			end
		end
	end
	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", SkinSkillLine)

	--Profession Tab
	local professionbuttons = {
		"PrimaryProfession1SpellButtonTop",
		"PrimaryProfession1SpellButtonBottom",
		"PrimaryProfession2SpellButtonTop",
		"PrimaryProfession2SpellButtonBottom",
		"SecondaryProfession1SpellButtonLeft",
		"SecondaryProfession1SpellButtonRight",
		"SecondaryProfession2SpellButtonLeft",
		"SecondaryProfession2SpellButtonRight",
		"SecondaryProfession3SpellButtonLeft",
		"SecondaryProfession3SpellButtonRight",
		"SecondaryProfession4SpellButtonLeft",
		"SecondaryProfession4SpellButtonRight",
	}

	local professionheaders = {
		"PrimaryProfession1",
		"PrimaryProfession2",
		"SecondaryProfession1",
		"SecondaryProfession2",
		"SecondaryProfession3",
		"SecondaryProfession4",
	}

	for _, header in pairs(professionheaders) do
		_G[header.."Missing"]:SetTextColor(1, 1, 0)
		_G[header].missingText:SetTextColor(0.9, 0.9, 0.9)
	end

	for _, button in pairs(professionbuttons) do
		local icon = _G[button.."IconTexture"]
		local button = _G[button]
		button:StripTextures()
		button:GetHighlightTexture():Hide()
		button:StyleButton(true)

		if icon then
			icon:SetTexCoord(unpack(E.TexCoords))
			icon:SetInside()

			button:SetFrameLevel(button:GetFrameLevel() + 2)
			if not button.backdrop then
				button:CreateBackdrop("Default", true)
				button.backdrop:SetAllPoints()
			end
		end
	end

	local professionstatusbars = {
		"PrimaryProfession1StatusBar",
		"PrimaryProfession2StatusBar",
		"SecondaryProfession1StatusBar",
		"SecondaryProfession2StatusBar",
		"SecondaryProfession3StatusBar",
		"SecondaryProfession4StatusBar",
	}

	for _, statusbar in pairs(professionstatusbars) do
		local statusbar = _G[statusbar]
		statusbar:StripTextures()
		statusbar:SetStatusBarTexture(E["media"].normTex)
		statusbar:SetStatusBarColor(0.11, 0.50, 1.00)
		statusbar:CreateBackdrop("Default")

		statusbar.rankText:ClearAllPoints()
		statusbar.rankText:SetPoint("CENTER")
	end

	PrimaryProfession1:CreateBackdrop("Transparent")
	PrimaryProfession1:Height(90)
	PrimaryProfession1:SetPoint("TOPLEFT", 10, -30)
	PrimaryProfession1StatusBar:SetHeight(20)
	PrimaryProfession1StatusBar:SetWidth(180)
	PrimaryProfession1StatusBar:SetPoint("TOPLEFT", 250, -10)
	PrimaryProfession1UnlearnButton:SetPoint("RIGHT", PrimaryProfession1StatusBar, "LEFT", -135, -10)
	PrimaryProfession1Rank:SetPoint("TOPLEFT", 120, -23)
	PrimaryProfession1SpellButtonTop:SetPoint("TOPRIGHT", PrimaryProfession1, "TOPRIGHT", -225, -45)
	PrimaryProfession1SpellButtonBottom:SetPoint("TOPLEFT", PrimaryProfession1SpellButtonTop, "BOTTOMLEFT", 135, 40)

	PrimaryProfession2:CreateBackdrop("Transparent")
	PrimaryProfession2:Height(90)
	PrimaryProfession2:SetPoint("TOPLEFT", 10, -130)
	PrimaryProfession2StatusBar:SetHeight(20)
	PrimaryProfession2StatusBar:SetWidth(180)
	PrimaryProfession2StatusBar:SetPoint("TOPLEFT", 250, -10)
	PrimaryProfession2UnlearnButton:SetPoint("RIGHT", PrimaryProfession2StatusBar, "LEFT", -135, -10)
	PrimaryProfession2Rank:SetPoint("TOPLEFT", 120, -23)
	PrimaryProfession2SpellButtonTop:SetPoint("TOPRIGHT", PrimaryProfession2, "TOPRIGHT", -225, -45)
	PrimaryProfession2SpellButtonBottom:SetPoint("TOPLEFT", PrimaryProfession2SpellButtonTop, "BOTTOMLEFT", 135, 40)

	SecondaryProfession1:CreateBackdrop("Transparent")
	SecondaryProfession1:Height(60)
	SecondaryProfession1StatusBar:SetHeight(18)
	SecondaryProfession1StatusBar:SetWidth(120)
	SecondaryProfession1StatusBar:SetPoint("TOPLEFT", 5, -35)
	SecondaryProfession1SpellButtonRight:SetPoint("TOPRIGHT", -90, -10)
	SecondaryProfession1SpellButtonLeft:SetPoint("TOPRIGHT", SecondaryProfession1SpellButtonRight, "TOPLEFT", -96, 0)

	SecondaryProfession2:CreateBackdrop("Transparent")
	SecondaryProfession2:Height(60)
	SecondaryProfession2StatusBar:SetHeight(18)
	SecondaryProfession2StatusBar:SetWidth(120)
	SecondaryProfession2StatusBar:SetPoint("TOPLEFT", 5, -35)
	SecondaryProfession2SpellButtonRight:SetPoint("TOPRIGHT", -90, -10)

	SecondaryProfession3:CreateBackdrop("Transparent")
	SecondaryProfession3:Height(60)
	SecondaryProfession3StatusBar:SetHeight(18)
	SecondaryProfession3StatusBar:SetWidth(120)
	SecondaryProfession3StatusBar:SetPoint("TOPLEFT", 5, -35)
	SecondaryProfession3SpellButtonRight:SetPoint("TOPRIGHT", -90, -10)
	SecondaryProfession3SpellButtonLeft:SetPoint("TOPRIGHT", SecondaryProfession3SpellButtonRight, "TOPLEFT", -96, 0)

	SecondaryProfession4:CreateBackdrop("Transparent")
	SecondaryProfession4:Height(60)
	SecondaryProfession4StatusBar:SetHeight(18)
	SecondaryProfession4StatusBar:SetWidth(120)
	SecondaryProfession4StatusBar:SetPoint("TOPLEFT", 5, -35)
	SecondaryProfession4SpellButtonRight:SetPoint("TOPRIGHT", -90, -10)

	--Bottom Tabs
	for i=1, 5 do
		S:HandleTab(_G["SpellBookFrameTabButton"..i])
	end

	SpellBookFrameTabButton1:ClearAllPoints()
	SpellBookFrameTabButton1:Point('TOPLEFT', SpellBookFrame, 'BOTTOMLEFT', 0, 2)

	--Mounts/Companions
	for i = 1, NUM_COMPANIONS_PER_PAGE do
		local button = _G["SpellBookCompanionButton"..i]
		local icon = _G["SpellBookCompanionButton"..i.."IconTexture"]
		button:StripTextures()
		button:StyleButton(false)
		
		if icon then
			icon:SetTexCoord(unpack(E.TexCoords))
			icon:ClearAllPoints()
			icon:Point("TOPLEFT", 2, -2)
			icon:Point("BOTTOMRIGHT", -2, 2)
			
			button:SetFrameLevel(button:GetFrameLevel() + 2)
			if not button.backdrop then
				button:CreateBackdrop("Default", true)	
				button.backdrop:SetAllPoints()
			end
		end					
	end

	for i = 1, 12 do
		_G["SpellBookCompanionButton" .. i]:CreateBackdrop("Transparent", true);
		_G["SpellBookCompanionButton" .. i].backdrop:Point("TOPLEFT", -3, 3);
		_G["SpellBookCompanionButton" .. i].backdrop:Point("BOTTOMRIGHT", 105, -3);
	end

	SpellBookCompanionButton1:SetPoint("TOPLEFT",  SpellBookCompanionsFrame, "TOPLEFT", 10, -280)

	SpellBookCompanionModelFrame:StripTextures()
	SpellBookCompanionModelFrameShadowOverlay:StripTextures()
	SpellBookCompanionsModelFrame:Kill()
	SpellBookCompanionModelFrame:SetTemplate("Transparent")

	SpellBookCompanionModelFrame:ClearAllPoints()
	SpellBookCompanionModelFrame:SetPoint("TOP", SpellBookCompanionsFrame, "TOP", 0, -60)
	SpellBookCompanionModelFrame:Width(270)
	SpellBookCompanionModelFrame:Height(185)

	S:HandleButton(SpellBookCompanionSummonButton)
	SpellBookCompanionSummonButton:SetPoint("BOTTOM", SpellBookCompanionModelFrame, "BOTTOM", -15, -235)
	SpellBookCompanionSummonButton:SetScale(1.1)

	SpellBookCompanionSelectedName:SetPoint("TOP", SpellBookCompanionModelFrame, "TOP", 0, 175)

	S:HandleRotateButton(SpellBookCompanionModelFrameRotateRightButton)
	S:HandleRotateButton(SpellBookCompanionModelFrameRotateLeftButton)

	SpellBookCompanionModelFrameRotateLeftButton:ClearAllPoints()
	SpellBookCompanionModelFrameRotateLeftButton:SetPoint("BOTTOM", SpellBookCompanionModelFrame, "BOTTOM", -17, 3)

	S:HandleCloseButton(SpellBookFrameCloseButton)

end

S:RegisterSkin("ElvUI", LoadSkin);