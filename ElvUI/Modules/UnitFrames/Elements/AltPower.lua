local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")

local CreateFrame = CreateFrame

function UF:Construct_AltPowerBar(frame)
	local altpower = CreateFrame("StatusBar", nil, frame)
	altpower:SetStatusBarTexture(E.media.blankTex)
	altpower:SetStatusBarColor(0.7, 0.7, 0.6)
	altpower:GetStatusBarTexture():SetHorizTile(false)
	UF.statusbars[altpower] = true

	altpower:CreateBackdrop(nil, nil, nil, self.thinBorders, true)
	altpower.BG = altpower:CreateTexture(nil, "BORDER")
	altpower.BG:SetAllPoints()
	altpower.BG:SetTexture(E.media.blankTex)

	altpower.RaisedElementParent = CreateFrame("Frame", nil, altpower)
	altpower.RaisedElementParent:SetFrameLevel(altpower:GetFrameLevel() + 100)
	altpower.RaisedElementParent:SetAllPoints()

	altpower.value = altpower.RaisedElementParent:CreateFontString(nil, "OVERLAY")
	altpower.value:Point("CENTER")
	altpower.value:SetJustifyH("CENTER")
	UF:Configure_FontString(altpower.value)

	altpower:SetScript("OnShow", UF.ToggleResourceBar)
	altpower:SetScript("OnHide", UF.ToggleResourceBar)
	altpower:Hide()

	return altpower
end

function UF:Configure_AltPowerBar(frame)
	local db = frame.db.classbar

	if db.enable then
		if not frame:IsElementEnabled("AlternativePower") then
			frame:EnableElement("AlternativePower")
			frame.AlternativePower:Show()
		end

		frame:Tag(frame.AlternativePower.value, db.altPowerTextFormat)
		UF:ToggleTransparentStatusBar(false, frame.AlternativePower, frame.AlternativePower.BG)

		local color = db.altPowerColor
		frame.AlternativePower:SetStatusBarColor(color.r, color.g, color.b)

		E:SetSmoothing(frame.AlternativePower, UF.db.smoothbars)
	elseif frame:IsElementEnabled("AlternativePower") then
		frame:DisableElement("AlternativePower")
		frame.AlternativePower:Hide()
	end
end