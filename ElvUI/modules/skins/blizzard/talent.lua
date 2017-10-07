local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local unpack, select = unpack, select
local find = string.find

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.talent ~= true then return end

	PlayerTalentFrame:StripTextures()
	PlayerTalentFrame:CreateBackdrop("Transparent")
	PlayerTalentFrame.backdrop:Point("BOTTOMRIGHT", PlayerTalentFrame, 0, -1)

	PlayerTalentFrameInset:StripTextures()
	PlayerTalentFrameTalents:StripTextures()
	PlayerTalentFramePetTalents:StripTextures()
	PlayerTalentFrameLearnButtonTutorial:Kill()

	S:HandleButton(PlayerTalentFrameActivateButton)

	S:HandleButton(PlayerTalentFrameToggleSummariesButton)
	PlayerTalentFrameToggleSummariesButton:Point("BOTTOM", PlayerTalentFrame, "BOTTOM", 0, 5)

	local function StripTalentFramePanelTextures(object)
		for i = 1, object:GetNumRegions() do
			local region = select(i, object:GetRegions())
			if region:GetObjectType() == "Texture" then
				if region:GetName():find("Branch") then
					region:SetDrawLayer("OVERLAY")
				else
					region:SetTexture(nil)
				end
			end
		end
	end

	for i = 1, 3 do
		local panel = _G["PlayerTalentFramePanel"..i]
		local summary = _G["PlayerTalentFramePanel"..i.."Summary"]
		local summaryIcon = _G["PlayerTalentFramePanel"..i.."SummaryIcon"]
		local header = _G["PlayerTalentFramePanel"..i.."HeaderIcon"]
		local headerIcon = _G["PlayerTalentFramePanel"..i.."HeaderIconIcon"]
		local headerText = _G["PlayerTalentFramePanel"..i.."HeaderIconPointsSpent"]
		local shadow = _G["PlayerTalentFramePanel"..i.."InactiveShadow"]
		local roleIcon = _G["PlayerTalentFramePanel"..i.."SummaryRoleIcon"]
		local treeButton = _G["PlayerTalentFramePanel"..i.."SelectTreeButton"]
		local activeBonus = _G["PlayerTalentFramePanel"..i.."SummaryActiveBonus1"]
		local activeBonusIcon = _G["PlayerTalentFramePanel"..i.."SummaryActiveBonus1Icon"]
		local arrow = _G["PlayerTalentFramePanel"..i.."Arrow"]
		local tab = _G["PlayerTalentFrameTab"..i]

		StripTalentFramePanelTextures(panel)

		panel:CreateBackdrop("Transparent")
		panel.backdrop:Point("TOPLEFT", 4, -4)
		panel.backdrop:Point("BOTTOMRIGHT", -4, 4)

		summary:StripTextures()
		summary:CreateBackdrop()
		summary:SetFrameLevel(summary:GetFrameLevel() + 2)

		summaryIcon:SetTexCoord(unpack(E.TexCoords))

		header:StripTextures()
		header:CreateBackdrop()
		header.backdrop:SetOutside(headerIcon)
		header:SetFrameLevel(header:GetFrameLevel() + 1)
		header:Point("TOPLEFT", panel, "TOPLEFT", 4, -4)

		headerIcon:Size(E.PixelMode and 34 or 30)
		headerIcon:SetTexCoord(unpack(E.TexCoords))
		headerIcon:Point("TOPLEFT", E.PixelMode and 1 or 4, -(E.PixelMode and 1 or 4))

		headerText:FontTemplate(nil, 13, "OUTLINE")
		headerText:Point("BOTTOMRIGHT", header, "BOTTOMRIGHT", 125, 11)

		activeBonus:StripTextures()
		activeBonus:CreateBackdrop()
		activeBonus.backdrop:SetOutside(activeBonusIcon)
		activeBonus:SetFrameLevel(activeBonus:GetFrameLevel() + 1)

		activeBonusIcon:SetTexCoord(unpack(E.TexCoords))

		S:HandleButton(treeButton)
		treeButton:SetFrameLevel(treeButton:GetFrameLevel() + 5)

		arrow:SetFrameLevel(arrow:GetFrameLevel() + 2)

		shadow:Kill()
		roleIcon:Kill()

		for j = 1, 4 do
			local summaryBonus = _G["PlayerTalentFramePanel"..i.."SummaryBonus"..j]
			local summaryBonusIcon = _G["PlayerTalentFramePanel"..i.."SummaryBonus"..j.."Icon"]

			summaryBonus:StripTextures()
			summaryBonus:CreateBackdrop()
			summaryBonus.backdrop:SetOutside(summaryBonusIcon)
			summaryBonus:SetFrameLevel(summaryBonus:GetFrameLevel() + 1)

			summaryBonusIcon:SetTexCoord(unpack(E.TexCoords))
		end

		S:HandleTab(tab)
	end

	hooksecurefunc("PlayerTalentFramePanel_UpdateSummary", function(self)
		if self.Summary then
			if PlayerTalentFrame.primaryTree and self.talentTree == PlayerTalentFrame.primaryTree then
				self.Summary.backdrop:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor))
			else
				self.Summary.backdrop:SetBackdropBorderColor(unpack(E["media"].bordercolor))
			end
		end
	end)

	function talentpairs(inspect, pet)
		local tab, tal = 1, 0
		return function()
			tal = tal + 1
			if tal > GetNumTalents(tab, inspect, pet) then
				tal = 1
				tab = tab + 1
			end
			if tab <= GetNumTalentTabs(inspect, pet) then
				return tab, tal
			end
		end
	end

	local function TalentButtons(self, first, i, j)
		local button = _G["PlayerTalentFramePanel"..i.."Talent"..j]
		local icon = _G["PlayerTalentFramePanel"..i.."Talent"..j.."IconTexture"]

		if first then
			button:StripTextures()
		end

		if button.Rank then
			button.Rank:FontTemplate(nil, 12, "OUTLINE")
			button.Rank:Point("BOTTOMRIGHT", 9, -12)
		end

		if icon then
			button:CreateBackdrop()
			button:StyleButton()
			button:SetFrameLevel(button:GetFrameLevel() + 1)

			button.SetHighlightTexture = E.noop
			button:GetHighlightTexture():SetAllPoints(icon)
			button.SetPushedTexture = E.noop
			button:GetPushedTexture():SetAllPoints(icon)
			button:GetPushedTexture():SetTexCoord(unpack(E.TexCoords))
			button:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))

			icon:SetTexCoord(unpack(E.TexCoords))
			icon:SetAllPoints()
		end
	end

	for tab, talent in talentpairs() do
		TalentButtons(nil, true, tab, talent)
	end

	PlayerTalentFramePanel2SummaryRoleIcon2:Kill()
	PlayerTalentFramePetShadowOverlay:Kill()
	PlayerTalentFrameHeaderHelpBox:Kill()

	S:HandleCloseButton(PlayerTalentFrameCloseButton)

	-- Side Tabs
	for i = 1, 2 do
		local tab = _G["PlayerSpecTab"..i]

		tab:GetRegions():Hide()
		tab:SetTemplate()
		tab:StyleButton(nil, true)
		tab:GetNormalTexture():SetInside()
		tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	end

	PlayerSpecTab1:ClearAllPoints()
	PlayerSpecTab1:Point("TOPLEFT", PlayerTalentFrame, "TOPRIGHT", E.PixelMode and -1 or 1, -32)
	PlayerSpecTab1.SetPoint = E.noop

	-- Pet Talents
	PlayerTalentFramePetModel:CreateBackdrop("Transparent")
	PlayerTalentFramePetModel:Height(319)

	PlayerTalentFramePetModelRotateLeftButton:Kill()
	PlayerTalentFramePetModelRotateRightButton:Kill()

	S:HandleButton(PlayerTalentFrameLearnButton, true)
	S:HandleButton(PlayerTalentFrameResetButton, true)

	PlayerTalentFramePetInfo:StripTextures()
	PlayerTalentFramePetInfo:CreateBackdrop()
	PlayerTalentFramePetInfo.backdrop:SetOutside(PlayerTalentFramePetIcon)
	PlayerTalentFramePetInfo:SetFrameLevel(PlayerTalentFramePetInfo:GetFrameLevel() + 1)
	PlayerTalentFramePetInfo:ClearAllPoints()
	PlayerTalentFramePetInfo:Point("BOTTOMLEFT", PlayerTalentFramePetModel, "TOPLEFT", 0, 10)

	PlayerTalentFramePetIcon:SetTexCoord(unpack(E.TexCoords))

	PlayerTalentFramePetDiet:StripTextures()
	PlayerTalentFramePetDiet:CreateBackdrop()
	PlayerTalentFramePetDiet:Size(22)

	PlayerTalentFramePetDiet.icon = PlayerTalentFramePetDiet:CreateTexture(nil, "OVERLAY")
	PlayerTalentFramePetDiet.icon:SetTexture("Interface\\Icons\\Ability_Hunter_BeastTraining")
	PlayerTalentFramePetDiet.icon:SetAllPoints()
	PlayerTalentFramePetDiet.icon:SetTexCoord(unpack(E.TexCoords))

	StripTalentFramePanelTextures(PlayerTalentFramePetPanel)

	PlayerTalentFramePetPanelHeaderIcon:StripTextures()
	PlayerTalentFramePetPanelHeaderIcon:CreateBackdrop()
	PlayerTalentFramePetPanelHeaderIcon.backdrop:SetOutside(PlayerTalentFramePetPanelHeaderIconIcon)
	PlayerTalentFramePetPanelHeaderIcon:SetFrameLevel(PlayerTalentFramePetPanelHeaderIcon:GetFrameLevel() + 1)
	PlayerTalentFramePetPanelHeaderIcon:Point("TOPLEFT", PlayerTalentFramePetPanel, "TOPLEFT", 5, -5)

	PlayerTalentFramePetPanelHeaderIconIcon:SetTexCoord(unpack(E.TexCoords))
	PlayerTalentFramePetPanelHeaderIconIcon:Size(E.PixelMode and 46 or 42)
	PlayerTalentFramePetPanelHeaderIconIcon:SetTexCoord(unpack(E.TexCoords))
	PlayerTalentFramePetPanelHeaderIconIcon:Point("TOPLEFT", E.PixelMode and 0 or 3, E.PixelMode and 0 or -3)

	local petPoints = select(4, PlayerTalentFramePetPanelHeaderIcon:GetRegions())
	petPoints:FontTemplate(nil, 13, "OUTLINE")
	petPoints:ClearAllPoints()
	petPoints:Point("BOTTOMRIGHT", PlayerTalentFramePetPanelHeaderIcon, "BOTTOMRIGHT", 150, 15)

	PlayerTalentFramePetPanelArrow:SetFrameStrata("HIGH")

	PlayerTalentFramePetPanel:CreateBackdrop("Transparent")
	PlayerTalentFramePetPanel.backdrop:Point("TOPLEFT", 4, -4)
	PlayerTalentFramePetPanel.backdrop:Point("BOTTOMRIGHT", -4, 4)

	PlayerTalentFramePetPanel:HookScript("OnShow", function()
		for i = 1, GetNumTalents(1, false, true) do
			local button = _G["PlayerTalentFramePetPanelTalent"..i]
			local icon = _G["PlayerTalentFramePetPanelTalent"..i.."IconTexture"]

			if not button.isSkinned then
				button:StripTextures()
				button:CreateBackdrop()
				button:StyleButton()
				button:SetFrameLevel(button:GetFrameLevel() + 1)

				button.SetHighlightTexture = E.noop
				button:GetHighlightTexture():SetAllPoints(icon)
				button.SetPushedTexture = E.noop
				button:GetPushedTexture():SetAllPoints(icon)
				button:GetPushedTexture():SetTexCoord(unpack(E.TexCoords))
				button:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))

				icon:SetTexCoord(unpack(E.TexCoords))
				icon:SetAllPoints()

				if button.Rank then
					button.Rank:FontTemplate(nil, 12, "OUTLINE")
					button.Rank:ClearAllPoints()
					button.Rank:Point("BOTTOMRIGHT", 9, -12)
				end

				button.isSkinned = true
			end
		end
	end)
end

S:AddCallbackForAddon("Blizzard_TalentUI", "Talent", LoadSkin)