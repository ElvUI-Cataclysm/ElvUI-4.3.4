local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local pairs, unpack = pairs, unpack
local find = string.find

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.pvp then return end

	local buttons = {
		"PVPFrameLeftButton",
		"PVPFrameRightButton",
		"PVPColorPickerButton1",
		"PVPColorPickerButton2",
		"PVPColorPickerButton3",
		"PVPBannerFrameAcceptButton"
	}

	for i = 1, #buttons do
		local button = _G[buttons[i]]

		button:StripTextures()
		S:HandleButton(button)
	end

	local KillTextures = {
		"PVPHonorFrameBGTex",
		"PVPHonorFrameInfoScrollFrameScrollBar",
		"PVPConquestFrameInfoButtonInfoBG",
		"PVPConquestFrameInfoButtonInfoBGOff",
		"PVPTeamManagementFrameFlag2GlowBG",
		"PVPTeamManagementFrameFlag3GlowBG",
		"PVPTeamManagementFrameFlag5GlowBG",
		"PVPTeamManagementFrameFlag2HeaderSelected",
		"PVPTeamManagementFrameFlag3HeaderSelected",
		"PVPTeamManagementFrameFlag5HeaderSelected",
		"PVPTeamManagementFrameFlag2Header",
		"PVPTeamManagementFrameFlag3Header",
		"PVPTeamManagementFrameFlag5Header",
		"PVPTeamManagementFrameWeeklyDisplayLeft",
		"PVPTeamManagementFrameWeeklyDisplayRight",
		"PVPTeamManagementFrameWeeklyDisplayMiddle",
		"PVPBannerFramePortrait",
		"PVPBannerFramePortraitFrame",
		"PVPBannerFrameInset",
		"PVPBannerFrameEditBoxLeft",
		"PVPBannerFrameEditBoxRight",
		"PVPBannerFrameEditBoxMiddle",
		"PVPBannerFrameCancelButton_LeftSeparator",
		"PVPFrameConquestBarLeft",
		"PVPFrameConquestBarRight",
		"PVPFrameConquestBarMiddle",
		"PVPFrameConquestBarBG",
		"PVPFrameConquestBarShadow"
	}

	for _, texture in pairs(KillTextures) do
		_G[texture]:Kill()
	end

	PVPFrameInset:StripTextures()
	PVPHonorFrame:StripTextures()
	PVPFrameTopInset:StripTextures()
	PVPConquestFrame:StripTextures()
	PVPTeamManagementFrame:StripTextures()
	PVPHonorFrameTypeScrollFrame:StripTextures()
	PVPBannerFrameCustomizationFrame:StripTextures()
	PVPTeamManagementFrameTeamScrollFrame:StripTextures()

	for i = 1, 5 do
		S:HandleButtonHighlight(_G["PVPHonorFrameBgButton"..i])
	end

	local function ArenaHeader(self, first, i)
		local button = _G["PVPTeamManagementFrameHeader"..i]

		if first then
			button:StripTextures()
		end
	end

	for i = 1, 4 do
		_G["PVPFrameConquestBarDivider"..i]:Hide()
		ArenaHeader(nil, true, i)
		S:HandleTab(_G["PVPFrameTab"..i])
	end

	for i = 1, 6 do
		S:HandleButtonHighlight(_G["PVPTeamManagementFrameTeamMemberButton"..i])
		_G["PVPTeamManagementFrameTeamMemberButton"..i.."ClassIcon"]:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
	end

	PVPFrameTab1:ClearAllPoints()
	PVPFrameTab1:Point("BOTTOMLEFT", PVPFrame, 0, -30)

	PVPBannerFrameEditBox:CreateBackdrop()
	PVPBannerFrameEditBox.backdrop:Point("TOPLEFT", -5, -5)
	PVPBannerFrameEditBox.backdrop:Point("BOTTOMRIGHT", 5, 5)

	PVPHonorFrameInfoScrollFrameChildFrameDescription:SetTextColor(1, 1, 1)
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfo.description:SetTextColor(1, 1, 1)

	PVPTeamManagementFrameInvalidTeamFrame:StripTextures()
	PVPTeamManagementFrameInvalidTeamFrame:CreateBackdrop()
	PVPTeamManagementFrameInvalidTeamFrame:SetFrameLevel(PVPTeamManagementFrameInvalidTeamFrame:GetFrameLevel() + 1)
	PVPTeamManagementFrameInvalidTeamFrame.backdrop:SetFrameLevel(PVPTeamManagementFrameInvalidTeamFrame:GetFrameLevel())

	PVPHonorFrameTypeScrollFrame:CreateBackdrop("Transparent")

	PVPTeamManagementFrameNoTeamsFrame:StripTextures()
	PVPTeamManagementFrameNoTeamsFrame:CreateBackdrop()
	PVPTeamManagementFrameNoTeamsFrame.backdrop:Point("TOPLEFT", 0, -15)
	PVPTeamManagementFrameNoTeamsFrame.backdrop:Point("BOTTOMRIGHT", 1, -2)
	PVPTeamManagementFrameNoTeamsFrame.backdrop:SetFrameLevel(PVPTeamManagementFrameNoTeamsFrame.backdrop:GetFrameLevel() + 1)

	S:HandleScrollBar(PVPTeamManagementFrameTeamScrollFrameScrollBar)
	S:HandleScrollBar(PVPHonorFrameTypeScrollFrameScrollBar)

	S:HandleButtonHighlight(PVPConquestFrameConquestButtonArena)
	S:HandleButtonHighlight(PVPConquestFrameConquestButtonRated)

	PVPFrameConquestBar:CreateBackdrop()
	PVPFrameConquestBar.backdrop:Point("TOPLEFT", PVPFrameConquestBar.progress, -1, 1)
	PVPFrameConquestBar.backdrop:Point("BOTTOMRIGHT", PVPFrameConquestBar, 3, 2)
	PVPFrameConquestBar:Point("LEFT", 40, 0)

	PVPFrameConquestBar.progress:SetTexture(E.media.normTex)
	PVPFrameConquestBar.progress:Point("LEFT")

	for i = 1, 2 do
		local cap = _G["PVPFrameConquestBarCap"..i]
		local marker = _G["PVPFrameConquestBarCap"..i.."Marker"]
		local markerTex = _G["PVPFrameConquestBarCap"..i.."MarkerTexture"]

		cap:SetTexture(E.media.normTex)

		marker:Size(4, 14)

		markerTex:SetTexture(E.media.blankTex)
		local r, g, b = cap:GetVertexColor()
		markerTex:SetVertexColor(r, g, b)
		markerTex.SetVertexColor = E.noop
	end

	PVPFrame:StripTextures()
	PVPFrame:SetTemplate("Transparent")

	PVPBannerFrame:StripTextures()
	PVPBannerFrame:SetTemplate("Transparent")

	PVPFrameLowLevelFrame:StripTextures()
	PVPFrameLowLevelFrame:CreateBackdrop()
	PVPFrameLowLevelFrame.backdrop:Point("TOPLEFT", -2, -40)
	PVPFrameLowLevelFrame.backdrop:Point("BOTTOMRIGHT", 5, 80)

	PVPBannerFrameCustomization1:StripTextures()
	PVPBannerFrameCustomization1:CreateBackdrop()
	PVPBannerFrameCustomization1.backdrop:Point("TOPLEFT", PVPBannerFrameCustomization1LeftButton, "TOPRIGHT", 2, 0)
	PVPBannerFrameCustomization1.backdrop:Point("BOTTOMRIGHT", PVPBannerFrameCustomization1RightButton, "BOTTOMLEFT", -2, 0)

	PVPBannerFrameCustomization2:StripTextures()
	PVPBannerFrameCustomization2:CreateBackdrop()
	PVPBannerFrameCustomization2.backdrop:Point("TOPLEFT", PVPBannerFrameCustomization2LeftButton, "TOPRIGHT", 2, 0)
	PVPBannerFrameCustomization2.backdrop:Point("BOTTOMRIGHT", PVPBannerFrameCustomization2RightButton, "BOTTOMLEFT", -2, 0)

	S:HandleCloseButton(PVPBannerFrameCloseButton, PVPBannerFrame)
	S:HandleCloseButton(PVPFrameCloseButton, PVPFrame)

	S:HandleNextPrevButton(PVPBannerFrameCustomization1LeftButton)
	PVPBannerFrameCustomization1LeftButton:Height(PVPBannerFrameCustomization1:GetHeight())

	S:HandleNextPrevButton(PVPBannerFrameCustomization1RightButton)
	PVPBannerFrameCustomization1RightButton:Height(PVPBannerFrameCustomization1:GetHeight())

	S:HandleNextPrevButton(PVPBannerFrameCustomization2LeftButton)
	PVPBannerFrameCustomization2LeftButton:Height(PVPBannerFrameCustomization1:GetHeight())

	S:HandleNextPrevButton(PVPBannerFrameCustomization2RightButton)
	PVPBannerFrameCustomization2RightButton:Height(PVPBannerFrameCustomization1:GetHeight())

	S:HandleNextPrevButton(PVPTeamManagementFrameWeeklyToggleLeft)
	S:HandleNextPrevButton(PVPTeamManagementFrameWeeklyToggleRight)

	PVPColorPickerButton1:Height(PVPColorPickerButton1:GetHeight() - 5)
	PVPColorPickerButton2:Height(PVPColorPickerButton1:GetHeight())
	PVPColorPickerButton3:Height(PVPColorPickerButton1:GetHeight())

	S:HandleButton(WarGameStartButton, true)
	S:HandleScrollBar(WarGamesFrameScrollFrameScrollBar, 5)

	WarGamesFrame:StripTextures()

	WarGameStartButton:ClearAllPoints()
	WarGameStartButton:Point("LEFT", PVPFrameLeftButton, "RIGHT", 2, 0)

	WarGamesFrameDescription:SetTextColor(1, 1, 1)

	for i = 1, 7 do
		local warGames = _G["WarGamesFrameScrollFrameButton"..i.."WarGame"]
		local warGamesHeader = _G["WarGamesFrameScrollFrameButton"..i.."Header"]
		local warGamesIcon = _G["WarGamesFrameScrollFrameButton"..i.."WarGameIcon"]
		local warGamesBG = _G["WarGamesFrameScrollFrameButton"..i.."WarGameBg"]
		local warGamesBorder = _G["WarGamesFrameScrollFrameButton"..i.."WarGameBorder"]

		warGames:StyleButton()
		warGames.selectedTex:SetTexture(1, 1, 1, 0.3)
		warGames.selectedTex:SetInside()
		warGames:CreateBackdrop()
		warGames.backdrop:SetOutside(warGamesIcon)

		warGamesBG:SetInside()
		warGamesBorder:Kill()

		warGamesIcon:Point("TOPLEFT", 2, -(E.PixelMode and 2 or 4))
		warGamesIcon:Size(E.PixelMode and 36 or 32)
		warGamesIcon:SetParent(warGames.backdrop)

		warGamesHeader:SetNormalTexture(E.Media.Textures.Plus)
		warGamesHeader.SetNormalTexture = E.noop
		warGamesHeader:GetNormalTexture():Size(16)
		warGamesHeader:GetNormalTexture():Point("LEFT", 2, 1)
		warGamesHeader:SetHighlightTexture("")
		warGamesHeader.SetHighlightTexture = E.noop

		hooksecurefunc(warGamesHeader, "SetNormalTexture", function(self, texture)
			local normal = self:GetNormalTexture()

			if find(texture, "MinusButton") then
				normal:SetTexture(E.Media.Textures.Minus)
			else
				normal:SetTexture(E.Media.Textures.Plus)
			end
		end)
	end

	S:HandleButton(PVPBannerFrameCancelButton)
	PVPBannerFrameCancelButton.backdrop = CreateFrame("Frame", nil, PVPBannerFrameCancelButton)
	PVPBannerFrameCancelButton.backdrop:SetTemplate("Default", true)
	PVPBannerFrameCancelButton.backdrop:SetFrameLevel(PVPBannerFrameCancelButton:GetFrameLevel() - 2)
	PVPBannerFrameCancelButton.backdrop:Point("TOPLEFT", PVPBannerFrameAcceptButton, "TOPLEFT", PVPBannerFrame:GetWidth() - PVPBannerFrameAcceptButton:GetWidth() -10, 0)
	PVPBannerFrameCancelButton.backdrop:Point("BOTTOMRIGHT", PVPBannerFrameAcceptButton, "BOTTOMRIGHT", PVPBannerFrame:GetWidth() - PVPBannerFrameAcceptButton:GetWidth() -10, 0)

	if PVPFrameCurrencyIcon then
		PVPFrameCurrency:CreateBackdrop()
		PVPFrameCurrency.backdrop:Point("TOPLEFT", 8, -8)
		PVPFrameCurrency.backdrop:Point("BOTTOMRIGHT", -8, 8)
		PVPFrameCurrency:SetHitRectInsets(8, 8, 8, 8)

		PVPFrameCurrencyIcon:SetAlpha(0)

		PVPFrameCurrency.texture = PVPFrameCurrency:CreateTexture(nil, "OVERLAY")
		PVPFrameCurrency.texture:SetTexture("Interface\\Icons\\PVPCurrency-Honor-"..E.myfaction)
		PVPFrameCurrency.texture:SetTexCoord(unpack(E.TexCoords))
		PVPFrameCurrency.texture:SetInside(PVPFrameCurrency.backdrop)
	end

	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoWinRewardHonorSymbol:SetTexture("Interface\\Icons\\PVPCurrency-Honor-"..E.myfaction)
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoWinRewardHonorSymbol.SetTexture = E.noop
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoWinRewardHonorSymbol:SetTexCoord(unpack(E.TexCoords))
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoWinRewardHonorSymbol:Size(30)

	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoWinRewardArenaSymbol:SetTexture("Interface\\Icons\\PVPCurrency-Conquest-"..E.myfaction)
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoWinRewardArenaSymbol.SetTexture = E.noop
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoWinRewardArenaSymbol:SetTexCoord(unpack(E.TexCoords))
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoWinRewardArenaSymbol:Size(30)

	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoLossRewardHonorSymbol:SetTexture("Interface\\Icons\\PVPCurrency-Honor-"..E.myfaction)
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoLossRewardHonorSymbol.SetTexture = E.noop
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoLossRewardHonorSymbol:SetTexCoord(unpack(E.TexCoords))
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoLossRewardHonorSymbol:Size(30)

	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoLossRewardArenaSymbol:SetTexture("Interface\\Icons\\PVPCurrency-Conquest-"..E.myfaction)
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoLossRewardArenaSymbol.SetTexture = E.noop
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoLossRewardArenaSymbol:SetTexCoord(unpack(E.TexCoords))
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoLossRewardArenaSymbol:Size(30)

	PVPConquestFrameWinRewardArenaSymbol:SetTexture("Interface\\Icons\\PVPCurrency-Conquest-"..E.myfaction)
	PVPConquestFrameWinRewardArenaSymbol.SetTexture = E.noop
	PVPConquestFrameWinRewardArenaSymbol:SetTexCoord(unpack(E.TexCoords))
	PVPConquestFrameWinRewardArenaSymbol:Size(30)
end

S:AddCallback("PvP", LoadSkin)