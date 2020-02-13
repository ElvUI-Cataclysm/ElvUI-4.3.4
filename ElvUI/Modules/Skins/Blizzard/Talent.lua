local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local unpack, select = unpack, select
local find = string.find

local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.talent then return end

	PlayerTalentFrame:StripTextures()
	PlayerTalentFrame:CreateBackdrop("Transparent")
	PlayerTalentFrame.backdrop:Point("BOTTOMRIGHT", PlayerTalentFrame, 1, -1)

	PlayerTalentFrameInset:StripTextures()
	PlayerTalentFrameTalents:StripTextures()
	PlayerTalentFrameLearnButtonTutorial:Kill()

	S:HandleButton(PlayerTalentFrameActivateButton)

	S:HandleButton(PlayerTalentFrameToggleSummariesButton)
	PlayerTalentFrameToggleSummariesButton:Point("BOTTOM", PlayerTalentFrame, "BOTTOM", 0, 5)

	local function StripPanelTextures(object)
		for i = 1, object:GetNumRegions() do
			local region = select(i, object:GetRegions())

			if region and region:IsObjectType("Texture") then
				if find(region:GetName(), "Branch") then
					region:SetDrawLayer("OVERLAY")
				else
					region:SetTexture(nil)
				end
			end
		end
	end

	for i = 1, 3 do
		local tab = _G["PlayerTalentFrameTab"..i]
		local panel = _G["PlayerTalentFramePanel"..i]
		local arrow = _G["PlayerTalentFramePanel"..i.."Arrow"]
		local activeBonus = _G["PlayerTalentFramePanel"..i.."SummaryActiveBonus1"]

		S:HandleTab(tab)

		StripPanelTextures(panel)
		panel:CreateBackdrop("Transparent")
		panel.backdrop:Point("TOPLEFT", 4, -4)
		panel.backdrop:Point("BOTTOMRIGHT", -4, 4)

		panel.InactiveShadow:Kill()

		panel.Summary:StripTextures()
		panel.Summary:CreateBackdrop()
		panel.Summary:SetFrameLevel(panel.Summary:GetFrameLevel() + 2)

		panel.Summary.Icon:SetTexCoord(unpack(E.TexCoords))

		panel.Summary.RoleIcon:Kill()
		panel.Summary.RoleIcon2:Kill()

		panel.HeaderIcon:StripTextures()
		panel.HeaderIcon:CreateBackdrop()
		panel.HeaderIcon.backdrop:SetOutside(panel.HeaderIcon.Icon)
		panel.HeaderIcon:SetFrameLevel(panel.HeaderIcon:GetFrameLevel() + 1)
		panel.HeaderIcon:Point("TOPLEFT", 4, -4)

		panel.HeaderIcon.Icon:Size(E.PixelMode and 34 or 30)
		panel.HeaderIcon.Icon:SetTexCoord(unpack(E.TexCoords))
		panel.HeaderIcon.Icon:Point("TOPLEFT", E.PixelMode and 1 or 4, -(E.PixelMode and 1 or 4))

		panel.HeaderIcon.PointsSpent:FontTemplate(nil, 13, "OUTLINE")
		panel.HeaderIcon.PointsSpent:Point("BOTTOMRIGHT", 125, 11)

		S:HandleButton(panel.SelectTreeButton)
		panel.SelectTreeButton:SetFrameLevel(panel.SelectTreeButton:GetFrameLevel() + 5)

		arrow:SetFrameLevel(arrow:GetFrameLevel() + 2)

		activeBonus:StripTextures()
		activeBonus:CreateBackdrop()
		activeBonus.backdrop:SetOutside(activeBonus.Icon)
		activeBonus:SetFrameLevel(activeBonus:GetFrameLevel() + 1)

		activeBonus.Icon:SetTexCoord(unpack(E.TexCoords))

		for j = 1, 5 do
			local bonus = _G["PlayerTalentFramePanel"..i.."SummaryBonus"..j]

			bonus:StripTextures()
			bonus:CreateBackdrop()
			bonus.backdrop:SetOutside(bonus.Icon)
			bonus:SetFrameLevel(bonus:GetFrameLevel() + 1)

			bonus.Icon:SetTexCoord(unpack(E.TexCoords))
		end
	end

	hooksecurefunc("PlayerTalentFramePanel_UpdateSummary", function(self)
		if self.Summary then
			if PlayerTalentFrame.primaryTree and self.talentTree == PlayerTalentFrame.primaryTree then
				self.Summary.backdrop:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
			else
				self.Summary.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end
		end
	end)

	local function talentPairs()
		local tab, talent = 1, 0

		return function()
			talent = talent + 1

			if talent > GetNumTalents(tab) then
				talent = 1
				tab = tab + 1
			end

			if tab <= GetNumTalentTabs() then
				return tab, talent
			end
		end
	end

	local function SkinTalents(button, icon)
		button:StripTextures()
		button:CreateBackdrop()
		button:StyleButton()
		button:SetFrameLevel(button:GetFrameLevel() + 1)

		button:GetHighlightTexture():SetAllPoints(icon)
		hooksecurefunc(button, "SetHighlightTexture", function(self, texture)
			if texture == "Interface\\Buttons\\ButtonHilight-Square" then
				self:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
			end
		end)

		button:GetPushedTexture():SetAllPoints(icon)
		hooksecurefunc(button, "SetPushedTexture", function(self, texture)
			if texture == "Interface\\Buttons\\UI-Quickslot-Depress" then
				self:GetPushedTexture():SetTexture(0.9, 0.8, 0.1, 0.3)
			end
		end)

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetAllPoints()

		button.Rank:FontTemplate(nil, 12, "OUTLINE")
		button.Rank:Point("BOTTOMRIGHT", 9, -12)
	end

	for panel, talent in talentPairs() do
		local button = _G["PlayerTalentFramePanel"..panel.."Talent"..talent]
		local icon = _G["PlayerTalentFramePanel"..panel.."Talent"..talent.."IconTexture"]

		SkinTalents(button, icon)
	end

	PlayerTalentFrameHeaderHelpBox:Kill()

	S:HandleCloseButton(PlayerTalentFrameCloseButton)

	-- Pet Talents
	StripPanelTextures(PlayerTalentFramePetPanel)
	PlayerTalentFramePetPanel:CreateBackdrop("Transparent")
	PlayerTalentFramePetPanel.backdrop:Point("TOPLEFT", 4, -4)
	PlayerTalentFramePetPanel.backdrop:Point("BOTTOMRIGHT", -4, 4)

	PlayerTalentFramePetPanel:HookScript("OnShow", function()
		for i = 1, GetNumTalents(1, false, true) do
			local button = _G["PlayerTalentFramePetPanelTalent"..i]
			local icon = _G["PlayerTalentFramePetPanelTalent"..i.."IconTexture"]

			if not button.isSkinned then
				SkinTalents(button, icon)

				button.isSkinned = true
			end
		end
	end)

	PlayerTalentFramePetShadowOverlay:Kill()

	PlayerTalentFramePetTalents:StripTextures()

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
	PlayerTalentFramePetInfo:Point("BOTTOMLEFT", PlayerTalentFramePetModel, "TOPLEFT", -3, 9)

	PlayerTalentFramePetIcon:SetTexCoord(unpack(E.TexCoords))

	PlayerTalentFramePetDiet:StripTextures()
	PlayerTalentFramePetDiet:CreateBackdrop()
	PlayerTalentFramePetDiet:Point("TOPRIGHT", 2, -2)
	PlayerTalentFramePetDiet:Size(40)

	PlayerTalentFramePetDiet.icon = PlayerTalentFramePetDiet:CreateTexture(nil, "ARTWORK")
	PlayerTalentFramePetDiet.icon:SetTexture("Interface\\Icons\\Ability_Hunter_BeastTraining")
	PlayerTalentFramePetDiet.icon:SetAllPoints()
	PlayerTalentFramePetDiet.icon:SetTexCoord(unpack(E.TexCoords))

	PlayerTalentFramePetTypeText:Point("BOTTOMRIGHT", -45, 10)

	PlayerTalentFramePetPanelHeaderIcon:StripTextures()
	PlayerTalentFramePetPanelHeaderIcon:CreateBackdrop()
	PlayerTalentFramePetPanelHeaderIcon.backdrop:SetOutside(PlayerTalentFramePetPanelHeaderIconIcon)
	PlayerTalentFramePetPanelHeaderIcon:SetFrameLevel(PlayerTalentFramePetPanelHeaderIcon:GetFrameLevel() + 1)
	PlayerTalentFramePetPanelHeaderIcon:Point("TOPLEFT", 5, -5)

	PlayerTalentFramePetPanelHeaderIconIcon:Size(E.PixelMode and 46 or 42)
	PlayerTalentFramePetPanelHeaderIconIcon:SetTexCoord(unpack(E.TexCoords))
	PlayerTalentFramePetPanelHeaderIconIcon:Point("TOPLEFT", E.PixelMode and 0 or 3, E.PixelMode and 0 or -3)

	local petPoints = select(4, PlayerTalentFramePetPanelHeaderIcon:GetRegions())
	petPoints:FontTemplate(nil, 13, "OUTLINE")
	petPoints:ClearAllPoints()
	petPoints:Point("BOTTOMRIGHT", 150, 15)

	PlayerTalentFramePetPanelArrow:SetFrameStrata("HIGH")

	-- Side Tabs
	for i = 1, 2 do
		local tab = _G["PlayerSpecTab"..i]

		tab:GetRegions():Hide()
		tab:SetTemplate()
		tab:StyleButton(nil, true)
		tab:GetNormalTexture():SetInside()
		tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	end
end

S:AddCallbackForAddon("Blizzard_TalentUI", "Talent", LoadSkin)