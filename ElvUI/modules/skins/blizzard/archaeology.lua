local E, L, V, P, G = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.archaeology ~= true then return end

	--Main Frame
	ArchaeologyFrame:StripTextures(true)
	ArchaeologyFrameInset:StripTextures(true)
	ArchaeologyFrame:SetTemplate("Transparent")
	ArchaeologyFrame:SetWidth(500)

	--Status Rank Bar
	ArchaeologyFrameRankBar:StripTextures()
	ArchaeologyFrameRankBar:SetStatusBarTexture(E["media"].normTex)
	ArchaeologyFrameRankBar:CreateBackdrop("Default")
	ArchaeologyFrameRankBar:Width(332)
	ArchaeologyFrameRankBar:Height(20)
	ArchaeologyFrameRankBar:SetStatusBarColor(0.11, 0.50, 1.00)

	--Solve Rank Bar
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:StripTextures()
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:SetStatusBarTexture(E["media"].normTex)
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:CreateBackdrop("Default")
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:Width(460)
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:SetStatusBarColor(0.7, 0.2, 0)
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:Point("TOP", ArchaeologyFrameArtifactPageSolveFrame, "TOP", -15, -40)

	--Help Button
	ArchaeologyFrameInfoButton:GetHighlightTexture():Kill()
	ArchaeologyFrameInfoButtonTexture:SetTexCoord(unpack(E.TexCoords))
	ArchaeologyFrameInfoButton:Point("TOPLEFT", ArchaeologyFrame, "TOPLEFT", 5, -5)

	--Help Frame
	select(2, ArchaeologyFrameHelpPage:GetRegions()):SetTexture("")
	select(3, ArchaeologyFrameHelpPage:GetRegions()):SetTexture("")

	ArchaeologyFrameHelpPageDigTex:SetTexCoord(0.05, 0.885, 0.055, 0.9)
	ArchaeologyFrameHelpPageDigTex:Point("LEFT", -35, 0)

	ArchaeologyFrameHelpPage:CreateBackdrop("Transparent", true)
	ArchaeologyFrameHelpPage.backdrop:Point("TOPLEFT", -28, -235);
	ArchaeologyFrameHelpPage.backdrop:Point("BOTTOMRIGHT", -22, 37);

	ArchaeologyFrameHelpPageHelpScroll:CreateBackdrop("Transparent")
	ArchaeologyFrameHelpPageHelpScroll.backdrop:Point("TOPLEFT", -15, 30);
	ArchaeologyFrameHelpPageHelpScroll.backdrop:Point("BOTTOMRIGHT", 10, 37);
	ArchaeologyFrameHelpPageHelpScroll:ClearAllPoints()
	ArchaeologyFrameHelpPageHelpScroll:Point("TOP", ArchaeologyFrameHelpPage, "TOP", -22, -60)

	ArchaeologyFrameHelpPageTitle:SetTextColor(1, 0.80, 0.10)
	ArchaeologyFrameHelpPageTitle:Point("TOP", ArchaeologyFrameHelpPage, "TOP", -22, -40)

	ArchaeologyFrameHelpPageDigTitle:SetTextColor(1, 0.80, 0.10)
	ArchaeologyFrameHelpPageDigTitle:Point("TOP", ArchaeologyFrameHelpPageDigTex, "TOP", 0, -10)

	ArchaeologyFrameHelpPageHelpScrollHelpText:SetTextColor(1, 1, 1)

	--Artifact Page
	ArchaeologyFrameArtifactPage:CreateBackdrop("Transparent")
	ArchaeologyFrameArtifactPage.backdrop:Point("TOPLEFT", -45, -45);
	ArchaeologyFrameArtifactPage.backdrop:Point("BOTTOMRIGHT", 0, 95);

	ArchaeologyFrameArtifactPageHistoryScroll:ClearAllPoints()
	ArchaeologyFrameArtifactPageHistoryScroll:Point("BOTTOMLEFT", ArchaeologyFrameArtifactPageSolveFrame, "BOTTOMLEFT", -40, 70)
	ArchaeologyFrameArtifactPageHistoryScrollChildText:SetTextColor(1, 1, 1)

	select(2, ArchaeologyFrameArtifactPage:GetRegions()):SetTexture("")
	select(3, ArchaeologyFrameArtifactPage:GetRegions()):SetTexture("")

	ArchaeologyFrameArtifactPageHistoryTitle:SetAlpha(0)

	ArchaeologyFrameArtifactPageIcon:SetTexCoord(unpack(E.TexCoords))
	ArchaeologyFrameArtifactPageIcon.backdrop = CreateFrame("Frame", nil, ArchaeologyFrameArtifactPage)
	ArchaeologyFrameArtifactPageIcon.backdrop:SetTemplate("Default")
	ArchaeologyFrameArtifactPageIcon.backdrop:Point("TOPLEFT", ArchaeologyFrameArtifactPageIcon, "TOPLEFT", -1, 1)
	ArchaeologyFrameArtifactPageIcon.backdrop:Point("BOTTOMRIGHT", ArchaeologyFrameArtifactPageIcon, "BOTTOMRIGHT", 1, -1)
	ArchaeologyFrameArtifactPageIcon:SetParent(ArchaeologyFrameArtifactPageIcon.backdrop)
	ArchaeologyFrameArtifactPageIcon:SetDrawLayer("OVERLAY")
	ArchaeologyFrameArtifactPageIcon:Point("TOPLEFT", ArchaeologyFrameArtifactPage, "TOPLEFT", -42, -47)

	ArchaeologyFrameArtifactPage.glow:Kill()
 
	ArchaeologyFrameArtifactPageRaceBG:ClearAllPoints()
	ArchaeologyFrameArtifactPageRaceBG:Point("TOPRIGHT", ArchaeologyFrameArtifactPage, "TOPRIGHT", 10, -40)

	ArchaeologyFrameArtifactPageArtifactBG:ClearAllPoints()
	ArchaeologyFrameArtifactPageArtifactBG:Point("TOPRIGHT", ArchaeologyFrameArtifactPage, "TOPRIGHT", 0, -45)

	S:HandleButton(ArchaeologyFrameArtifactPageSolveFrameSolveButton, true)
	ArchaeologyFrameArtifactPageSolveFrameSolveButton:Point("BOTTOMRIGHT", ArchaeologyFrameArtifactPageSolveFrame, "BOTTOMRIGHT", 0, -10)

	S:HandleButton(ArchaeologyFrameArtifactPageBackButton, true)
	ArchaeologyFrameArtifactPageBackButton:Point("BOTTOMLEFT", ArchaeologyFrameArtifactPage, "BOTTOMLEFT", 350, 15)

	ArchaeologyFrameArtifactPageSolveFrameKeystone1:Point("BOTTOMLEFT", ArchaeologyFrameArtifactPageSolveFrame, "BOTTOMLEFT", -25, -30)

	--Summary Page
	select(2, ArchaeologyFrameSummaryPage:GetRegions()):SetTexture("")
	select(3, ArchaeologyFrameSummaryPage:GetRegions()):SetTexture("")

	ArchaeologyFrameSummaryPageRace1:SetPoint("TOPLEFT", ArchaeologyFrameSummaryPage, "TOPLEFT", 15, -85)

	for i=1, ARCHAEOLOGY_MAX_RACES do
		local frame = _G["ArchaeologyFrameSummaryPageRace"..i]
		local frameIcon = frame:GetNormalTexture()

		if frame then
			frame.raceName:SetTextColor(1, 1, 1)
			frame:CreateBackdrop("Transparent", true)
			frame.backdrop:Point("TOPLEFT", -5, 1);
			frame.backdrop:Point("BOTTOMRIGHT", 5, -25);
		end
	end

	for i=1, ArchaeologyFrameSummaryPage:GetNumRegions() do
		local region = select(i, ArchaeologyFrameSummaryPage:GetRegions())
		if region:GetObjectType() == "FontString" then
			region:SetTextColor(1, 0.80, 0.10)
		end
	end

	ArchaeologyFrameSummaryPageTitle:SetAlpha(0)

	--Completed Page
	for i=1, ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
		local artifact = _G["ArchaeologyFrameCompletedPageArtifact"..i]
		local icon = _G["ArchaeologyFrameCompletedPageArtifact"..i.."Icon"]

		if artifact then
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."Border"]:Kill()
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."Bg"]:Kill()
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."ArtifactName"]:SetTextColor(1, 0.80, 0.10)
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."ArtifactSubText"]:SetTextColor(0.6, 0.6, 0.6)

			artifact:SetTemplate("Transparent");
			artifact:StyleButton()

			icon:SetTexCoord(unpack(E.TexCoords))
			icon:SetDrawLayer("OVERLAY")
			icon:Size(icon:GetWidth() - 2, icon:GetHeight() - 2)

			artifact.bg1 = CreateFrame("Frame", nil, artifact)
			artifact.bg1:CreateBackdrop()
			artifact.bg1:SetInside(icon)
			icon:SetParent(artifact.bg1)
		end
	end

	for i=1, ArchaeologyFrameCompletedPage:GetNumRegions() do
		local region = select(i, ArchaeologyFrameCompletedPage:GetRegions())
		if region:GetObjectType() == "FontString" then
			region:SetTextColor(1, 1, 1)
			region:SetPoint("LEFT", -10, 0)
		end
	end

	select(3, ArchaeologyFrameCompletedPage:GetRegions()):SetTexture("")
	select(4, ArchaeologyFrameCompletedPage:GetRegions()):SetTexture("")
	select(6, ArchaeologyFrameCompletedPage:GetRegions()):SetTexture("")
	select(7, ArchaeologyFrameCompletedPage:GetRegions()):SetTexture("")
	select(9, ArchaeologyFrameCompletedPage:GetRegions()):SetTexture("")
	select(10, ArchaeologyFrameCompletedPage:GetRegions()):SetTexture("")

	ArchaeologyFrameCompletedPage.infoText:SetTextColor(1, 1, 1)

	S:HandleButton(ArchaeologyFrameCompletedPageNextPageButton)
	S:HandleButton(ArchaeologyFrameCompletedPagePrevPageButton)
	ArchaeologyFrameCompletedPagePrevPageButton:ClearAllPoints()
	ArchaeologyFrameCompletedPagePrevPageButton:SetPoint("LEFT", ArchaeologyFrameCompletedPagePageText, "RIGHT", 10, 0)

	ArchaeologyFrameCompletedPage.pageText:SetTextColor(1, 1, 1)
	ArchaeologyFrameCompletedPage.pageText:SetPoint("BOTTOMRIGHT", ArchaeologyFrameCompletedPage, "BOTTOMRIGHT", -75, 15)

	ArchaeologyFrameCompletedPageArtifact1:SetPoint("TOPLEFT", ArchaeologyFrameCompletedPage, "TOPLEFT", -10, -85)

	--Summary Tab
	ArchaeologyFrameSummarytButton:StripTextures()
	ArchaeologyFrameSummarytButton:GetHighlightTexture():SetTexture(nil)
	ArchaeologyFrameSummarytButton:SetSize(50, 50)
	ArchaeologyFrameSummarytButton.backdrop = CreateFrame("Frame", nil, ArchaeologyFrameSummarytButton)
	ArchaeologyFrameSummarytButton.backdrop:SetTemplate("Transparent",true)
	ArchaeologyFrameSummarytButton.backdrop:Point("TOPLEFT", ArchaeologyFrameSummarytButton, "TOPLEFT", -1, -3)
	ArchaeologyFrameSummarytButton.backdrop:Point("BOTTOMRIGHT", ArchaeologyFrameSummarytButton, "BOTTOMRIGHT", -5, 5)
	ArchaeologyFrameSummarytButton.backdrop:SetFrameLevel(ArchaeologyFrameSummarytButton:GetFrameLevel())
	ArchaeologyFrameSummarytButton:SetPoint("TOPLEFT", ArchaeologyFrame, "TOPRIGHT", 0, -30)

	ArchaeologyFrameSummarytButton.icon = ArchaeologyFrameSummarytButton:CreateTexture(nil, "OVERLAY");
	ArchaeologyFrameSummarytButton.icon:SetAlpha(0.7)
	ArchaeologyFrameSummarytButton.icon:SetTexCoord(0, 0.58, 0.100, 0.33)
	ArchaeologyFrameSummarytButton.icon:SetPoint("TOPLEFT", ArchaeologyFrameSummarytButton, "TOPLEFT", -7, -12)
	ArchaeologyFrameSummarytButton.icon:SetPoint("BOTTOMRIGHT", ArchaeologyFrameSummarytButton, "BOTTOMRIGHT", 0, 15)
	ArchaeologyFrameSummarytButton.icon:SetTexture("Interface\\ARCHEOLOGY\\ARCH-RACE-TOLVIR")
	ArchaeologyFrameSummarytButton.icon:SetDesaturated(false)

	--Complete Tab
	ArchaeologyFrameCompletedButton:StripTextures()
	ArchaeologyFrameCompletedButton:GetHighlightTexture():SetTexture(nil)
	ArchaeologyFrameCompletedButton:SetSize(50, 50)
	ArchaeologyFrameCompletedButton.backdrop = CreateFrame("Frame", nil, ArchaeologyFrameCompletedButton)
	ArchaeologyFrameCompletedButton.backdrop:SetTemplate("Transparent",true)
	ArchaeologyFrameCompletedButton.backdrop:Point("TOPLEFT", ArchaeologyFrameCompletedButton, "TOPLEFT", -1, -3)
	ArchaeologyFrameCompletedButton.backdrop:Point("BOTTOMRIGHT", ArchaeologyFrameCompletedButton, "BOTTOMRIGHT", -5, 5)
	ArchaeologyFrameCompletedButton.backdrop:SetFrameLevel(ArchaeologyFrameCompletedButton:GetFrameLevel())
	ArchaeologyFrameCompletedButton:SetPoint("TOPLEFT", ArchaeologyFrame, "TOPRIGHT", 0, -80)

	ArchaeologyFrameCompletedButton.icon = ArchaeologyFrameCompletedButton:CreateTexture(nil, "OVERLAY");
	ArchaeologyFrameCompletedButton.icon:SetAlpha(0.7)
	ArchaeologyFrameCompletedButton.icon:SetTexCoord(0, 0.58, 0.344, 0.68)
	ArchaeologyFrameCompletedButton.icon:SetPoint("TOPLEFT", ArchaeologyFrameCompletedButton, "TOPLEFT", -5, -12)
	ArchaeologyFrameCompletedButton.icon:SetPoint("BOTTOMRIGHT", ArchaeologyFrameCompletedButton, "BOTTOMRIGHT", 0, -10)
	ArchaeologyFrameCompletedButton.icon:SetTexture("Interface\\ARCHEOLOGY\\ARCH-RACE-TOLVIR")
	ArchaeologyFrameCompletedButton.icon:SetDesaturated(true)

	--Clicked Tab Script
	ArchaeologyFrameSummarytButton:HookScript("OnClick", function()
		ArchaeologyFrameSummarytButton.icon:SetDesaturated(false)
		ArchaeologyFrameCompletedButton.icon:SetDesaturated(true)
	end)

	ArchaeologyFrameCompletedButton:HookScript("OnClick", function()
		ArchaeologyFrameCompletedButton.icon:SetDesaturated(false)
		ArchaeologyFrameSummarytButton.icon:SetDesaturated(true)
	end)

	--Filter Dropdown
	S:HandleDropDownBox(ArchaeologyFrameRaceFilter, 125)
	ArchaeologyFrameRaceFilter:SetPoint("TOPRIGHT", ArchaeologyFrame, "TOPRIGHT", -25, -3)

	--Close Button
	S:HandleCloseButton(ArchaeologyFrameCloseButton)
end
S:RegisterSkin("Blizzard_ArchaeologyUI", LoadSkin)