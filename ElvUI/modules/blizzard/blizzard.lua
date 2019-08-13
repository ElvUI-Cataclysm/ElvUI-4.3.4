local E, L, V, P, G = unpack(select(2, ...))
local B = E:GetModule("Blizzard")
local Skins = E:GetModule("Skins")

local _G = _G
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

function B:Initialize()
	self.Initialized = true

	self:EnhanceColorPicker()
	self:KillBlizzard()
	self:AlertMovers()
	self:PositionCaptureBar()
	self:PositionDurabilityFrame()
	self:PositionGMFrames()
	self:SkinBlizzTimers()
	self:PositionVehicleFrame()
	self:MoveWatchFrame()

	if not IsAddOnLoaded("SimplePowerBar") then
		self:PositionAltPowerBar()
		self:SkinAltPowerBar()
	end

	if GetLocale() == "deDE" then
		DAY_ONELETTER_ABBR = "%d d"
	end

	CreateFrame("Frame"):SetScript("OnUpdate", function()
		if LFRBrowseFrame.timeToClear then
			LFRBrowseFrame.timeToClear = nil
		end
	end)

	-- MicroButton Talent Alert
	if E.global.general.showMissingTalentAlert then
		TalentMicroButtonAlert:StripTextures(true)
		TalentMicroButtonAlert:SetTemplate("Transparent")
		TalentMicroButtonAlert:ClearAllPoints()
		TalentMicroButtonAlert:SetPoint("CENTER", E.UIParent, "TOP", 0, -75)
		TalentMicroButtonAlert:Width(230)

		TalentMicroButtonAlertArrow:Hide()
		TalentMicroButtonAlertText:Point("TOPLEFT", 42, -23)
		TalentMicroButtonAlertText:FontTemplate()
		Skins:HandleCloseButton(TalentMicroButtonAlertCloseButton)

		TalentMicroButtonAlert.tex = TalentMicroButtonAlert:CreateTexture(nil, "OVERLAY")
		TalentMicroButtonAlert.tex:Point("LEFT", 5, -4)
		TalentMicroButtonAlert.tex:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew")
		TalentMicroButtonAlert.tex:SetSize(32, 32)

		TalentMicroButtonAlert.button = CreateFrame("Button", nil, TalentMicroButtonAlert, nil)
		TalentMicroButtonAlert.button:SetAllPoints(TalentMicroButtonAlert)
		TalentMicroButtonAlert.button:HookScript("OnClick", function()
			if not PlayerTalentFrame then
				TalentFrame_LoadUI()
			end
			if not GlyphFrame then
				GlyphFrame_LoadUI()
			end
			if not PlayerTalentFrame:IsShown() then
				ShowUIPanel(PlayerTalentFrame)
			else
				HideUIPanel(PlayerTalentFrame)
			end
		end)
	else
		TalentMicroButtonAlert:Kill() -- Kill it, because then the blizz default will show
	end
end

local function InitializeCallback()
	B:Initialize()
end

E:RegisterModule(B:GetName(), InitializeCallback)