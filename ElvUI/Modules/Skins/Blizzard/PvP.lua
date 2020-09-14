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
	PVPTeamManagementFrameTeamScrollFrame:StripTextures()

	for i = 1, 5 do
		S:HandleButtonHighlight(_G["PVPHonorFrameBgButton"..i])
	end

	for i = 1, 4 do
		local tab = _G["PVPFrameTab"..i]

		S:HandleTab(tab)

		if i == 1 then
			tab:ClearAllPoints()
			tab:Point("BOTTOMLEFT", PVPFrame, 0, -30)
		end

		_G["PVPTeamManagementFrameHeader"..i]:StripTextures()
	end

	for i = 1, 6 do
		S:HandleButtonHighlight(_G["PVPTeamManagementFrameTeamMemberButton"..i])
		_G["PVPTeamManagementFrameTeamMemberButton"..i.."ClassIcon"]:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
	end

	PVPBannerFrameEditBox:CreateBackdrop()
	PVPBannerFrameEditBox.backdrop:Point("TOPLEFT", -5, -5)
	PVPBannerFrameEditBox.backdrop:Point("BOTTOMRIGHT", 5, 5)

	PVPHonorFrameInfoScrollFrameChildFrameDescription:SetTextColor(1, 1, 1)
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfo.description:SetTextColor(1, 1, 1)

	PVPTeamManagementFrameInvalidTeamFrame:StripTextures()
	PVPTeamManagementFrameInvalidTeamFrame:CreateBackdrop()
	PVPTeamManagementFrameInvalidTeamFrame:SetFrameLevel(PVPTeamManagementFrameInvalidTeamFrame:GetFrameLevel() + 1)
	PVPTeamManagementFrameInvalidTeamFrame.backdrop:SetFrameLevel(PVPTeamManagementFrameInvalidTeamFrame:GetFrameLevel())

	PVPHonorFrameTypeScrollFrame:StripTextures()
	PVPHonorFrameTypeScrollFrame:CreateBackdrop("Transparent")

	S:HandleScrollBar(PVPHonorFrameTypeScrollFrameScrollBar)

	PVPTeamManagementFrameNoTeamsFrame:StripTextures()
	PVPTeamManagementFrameNoTeamsFrame:CreateBackdrop()
	PVPTeamManagementFrameNoTeamsFrame.backdrop:Point("TOPLEFT", 0, -15)
	PVPTeamManagementFrameNoTeamsFrame.backdrop:Point("BOTTOMRIGHT", 1, -2)
	PVPTeamManagementFrameNoTeamsFrame.backdrop:SetFrameLevel(PVPTeamManagementFrameNoTeamsFrame.backdrop:GetFrameLevel() + 1)

	S:HandleScrollBar(PVPTeamManagementFrameTeamScrollFrameScrollBar)

	S:HandleButtonHighlight(PVPConquestFrameConquestButtonArena)
	S:HandleButtonHighlight(PVPConquestFrameConquestButtonRated)

	-- Conquest Bar
	PVPFrameConquestBar:StripTextures()
	PVPFrameConquestBar:CreateBackdrop()
	PVPFrameConquestBar.backdrop:Point("TOPLEFT", PVPFrameConquestBar.progress, -1, 1)
	PVPFrameConquestBar.backdrop:Point("BOTTOMRIGHT", PVPFrameConquestBar, 3, 2)
	PVPFrameConquestBar:Point("LEFT", 40, 0)

	PVPFrameConquestBar.progress:SetTexture(E.media.normTex)
	PVPFrameConquestBar.progress:Point("LEFT")

	for i = 1, 2 do
		_G["PVPFrameConquestBarCap"..i]:SetTexture(E.media.normTex)
		_G["PVPFrameConquestBarCap"..i.."Marker"]:Size(4, E.PixelMode and 14 or 12)

		local markerTex = _G["PVPFrameConquestBarCap"..i.."MarkerTexture"]
		markerTex:SetTexture(E.media.blankTex)
		markerTex:SetVertexColor(1, 1, 1, 0.40)
	end

	PVPFrame:StripTextures()
	PVPFrame:SetTemplate("Transparent")

	PVPFrameLowLevelFrame:StripTextures()
	PVPFrameLowLevelFrame:CreateBackdrop()
	PVPFrameLowLevelFrame.backdrop:Point("TOPLEFT", -2, -40)
	PVPFrameLowLevelFrame.backdrop:Point("BOTTOMRIGHT", 5, 80)

	-- PvP Icon
	if PVPFrameCurrency then
		PVPFrameCurrency:CreateBackdrop()
		PVPFrameCurrency:Size(32)
		PVPFrameCurrency:Point("TOP", 0, -26)
		S:HandleFrameHighlight(PVPFrameCurrency, PVPFrameCurrency.backdrop)

		PVPFrameCurrencyIcon:SetTexture("Interface\\Icons\\PVPCurrency-Honor-"..E.myfaction)
		PVPFrameCurrencyIcon.SetTexture = E.noop
		PVPFrameCurrencyIcon:SetTexCoord(unpack(E.TexCoords))
		PVPFrameCurrencyIcon:SetInside(PVPFrameCurrency.backdrop)

		PVPFrameCurrencyLabel:Hide()
		PVPFrameCurrencyValue:Point("LEFT", PVPFrameCurrencyIcon, "RIGHT", 6, 0)
	end

	-- Rewards
	for _, frame in pairs({"PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoWinReward", "PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoLossReward", "PVPConquestFrameWinReward"}) do
		local background = _G[frame]:GetRegions()
		background:SetTexture(E.Media.Textures.Highlight)
		if _G[frame] == PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoWinReward or _G[frame] == PVPConquestFrameWinReward then
			background:SetVertexColor(0, 0.439, 0, 0.5)
		else
			background:SetVertexColor(0.5608, 0, 0, 0.5)
		end

		if _G[frame] ~= PVPConquestFrameWinReward then
			local honor = _G[frame.."HonorSymbol"]
			honor:SetTexture("Interface\\Icons\\PVPCurrency-Honor-"..E.myfaction)
			honor.SetTexture = E.noop
			honor:SetTexCoord(unpack(E.TexCoords))
			honor:Size(30)
		end

		local conquest = _G[frame.."ArenaSymbol"]
		conquest:SetTexture("Interface\\Icons\\PVPCurrency-Conquest-"..E.myfaction)
		conquest.SetTexture = E.noop
		conquest:SetTexCoord(unpack(E.TexCoords))
		conquest:Size(30)
	end

	-- War Games
	WarGamesFrame:StripTextures()

	WarGamesFrameScrollFrame:CreateBackdrop("Transparent")
	WarGamesFrameScrollFrame.backdrop:Point("BOTTOMRIGHT", -2, -3)

	S:HandleScrollBar(WarGamesFrameScrollFrameScrollBar)
	WarGamesFrameScrollFrameScrollBar:ClearAllPoints()
	WarGamesFrameScrollFrameScrollBar:Point("TOPRIGHT", WarGamesFrameScrollFrame, 22, -15)
	WarGamesFrameScrollFrameScrollBar:Point("BOTTOMRIGHT", WarGamesFrameScrollFrame, 0, 13)

	for i = 1, 7 do
		local warGames = _G["WarGamesFrameScrollFrameButton"..i.."WarGame"]
		local warGamesHeader = _G["WarGamesFrameScrollFrameButton"..i.."Header"]
		local warGamesIcon = _G["WarGamesFrameScrollFrameButton"..i.."WarGameIcon"]

		warGames:StripTextures()
		warGames:CreateBackdrop()
		warGames.backdrop:SetOutside(warGamesIcon)
		S:HandleButtonHighlight(warGames)
		warGames.handledHighlight:SetInside()

		warGames.selectedTex:SetTexture(E.Media.Textures.Highlight)
		warGames.selectedTex:SetTexCoord(0, 1, 0, 1)
		warGames.selectedTex.SetTexCoord = E.noop
		warGames.selectedTex:SetVertexColor(1, 0.8, 0.2, 0.35)
		warGames.selectedTex:SetInside()

		warGamesIcon:Point("TOPLEFT", 2, -(E.PixelMode and 2 or 4))
		warGamesIcon:Size(E.PixelMode and 36 or 32)
		warGamesIcon:SetParent(warGames.backdrop)

		_G["WarGamesFrameScrollFrameButton"..i.."WarGameBg"]:SetInside()
		_G["WarGamesFrameScrollFrameButton"..i.."WarGameBorder"]:Kill()

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

	WarGamesFrameDescription:SetTextColor(1, 1, 1)

	S:HandleButton(WarGameStartButton, true)
	WarGameStartButton:ClearAllPoints()
	WarGameStartButton:Point("LEFT", PVPFrameLeftButton, "RIGHT", 2, 0)

	-- Create Arena Team
	PVPBannerFrame:StripTextures()
	PVPBannerFrame:SetTemplate("Transparent")

	PVPBannerFrameCustomizationFrame:StripTextures()

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
	PVPBannerFrameCustomization1LeftButton:Height(20)

	S:HandleNextPrevButton(PVPBannerFrameCustomization1RightButton)
	PVPBannerFrameCustomization1RightButton:Height(20)

	S:HandleNextPrevButton(PVPBannerFrameCustomization2LeftButton)
	PVPBannerFrameCustomization2LeftButton:Height(20)

	S:HandleNextPrevButton(PVPBannerFrameCustomization2RightButton)
	PVPBannerFrameCustomization2RightButton:Height(20)

	S:HandleNextPrevButton(PVPTeamManagementFrameWeeklyToggleLeft)
	S:HandleNextPrevButton(PVPTeamManagementFrameWeeklyToggleRight)

	PVPColorPickerButton1:Height(20)
	PVPColorPickerButton2:Height(20)
	PVPColorPickerButton3:Height(20)

	S:HandleButton(PVPBannerFrameCancelButton)
	PVPBannerFrameCancelButton.backdrop = CreateFrame("Frame", nil, PVPBannerFrameCancelButton)
	PVPBannerFrameCancelButton.backdrop:SetTemplate("Default", true)
	PVPBannerFrameCancelButton.backdrop:SetFrameLevel(PVPBannerFrameCancelButton:GetFrameLevel() - 2)
	PVPBannerFrameCancelButton.backdrop:Point("TOPLEFT", PVPBannerFrameAcceptButton, 248, 0)
	PVPBannerFrameCancelButton.backdrop:Point("BOTTOMRIGHT", PVPBannerFrameAcceptButton, 248, 0)
end

S:AddCallback("PvP", LoadSkin)