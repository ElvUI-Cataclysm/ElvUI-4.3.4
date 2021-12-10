local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")
local _, ns = ...
local ElvUF = ns.oUF
assert(ElvUF, "ElvUI was unable to locate oUF.")

local _G = _G
local tinsert = table.insert

local IsAddOnLoaded = IsAddOnLoaded
local MAX_COMBO_POINTS = MAX_COMBO_POINTS

function UF:Construct_TargetFrame(frame)
	frame.Health = UF:Construct_HealthBar(frame, true, true, "RIGHT")
	frame.Health.frequentUpdates = true
	frame.Power = UF:Construct_PowerBar(frame, true, true, "LEFT")
	frame.Power.frequentUpdates = true
	frame.Name = UF:Construct_NameText(frame)
	frame.Portrait3D = UF:Construct_Portrait(frame, "model")
	frame.Portrait2D = UF:Construct_Portrait(frame, "texture")
	frame.Buffs = UF:Construct_Buffs(frame)
	frame.Debuffs = UF:Construct_Debuffs(frame)
	frame.ThreatIndicator = UF:Construct_Threat(frame)
	frame.Castbar = UF:Construct_Castbar(frame, L["Target Castbar"])
	frame.Castbar.SafeZone = nil
	frame.Castbar.LatencyTexture:Hide()
	frame.RaidTargetIndicator = UF:Construct_RaidIcon(frame)

	frame.ComboPointsHolder = CreateFrame("Frame", nil, frame)
	frame.ComboPointsHolder:Point("BOTTOM", E.UIParent, "BOTTOM", 0, 200)
	frame.ComboPoints = UF:Construct_Combobar(frame)

	frame.HealthPrediction = UF:Construct_HealComm(frame)
	frame.AuraHighlight = UF:Construct_AuraHighlight(frame)
	frame.GPS = UF:Construct_GPS(frame)
	frame.InfoPanel = UF:Construct_InfoPanel(frame)
	frame.MouseGlow = UF:Construct_MouseGlow(frame)
	frame.TargetGlow = UF:Construct_TargetGlow(frame)
	frame.FocusGlow = UF:Construct_FocusGlow(frame)
	frame.AuraBars = UF:Construct_AuraBarHeader(frame)
	frame.PhaseIndicator = UF:Construct_PhaseIcon(frame)
	frame.ResurrectIndicator = UF:Construct_ResurrectionIcon(frame)
	frame.RaidRoleFramesAnchor = UF:Construct_RaidRoleFrames(frame)
	frame.PvPIndicator = UF:Construct_PvPIcon(frame)
	frame.Fader = UF:Construct_Fader()
	frame.Cutaway = UF:Construct_Cutaway(frame)
	frame.CombatIndicator = UF:Construct_CombatIndicator(frame)

	frame.customTexts = {}
	frame:Point("BOTTOMRIGHT", E.UIParent, "BOTTOM", 413, 68)
	E:CreateMover(frame, frame:GetName().."Mover", L["Target Frame"], nil, nil, nil, "ALL,SOLO", nil, "unitframe,individualUnits,target,generalGroup")
	frame.unitframeType = "target"
end

function UF:Update_TargetFrame(frame, db)
	frame.db = db

	do
		frame.ORIENTATION = db.orientation
		frame.UNIT_WIDTH = db.width
		frame.UNIT_HEIGHT = db.infoPanel.enable and (db.height + db.infoPanel.height) or db.height
		frame.USE_POWERBAR = db.power.enable
		frame.POWERBAR_DETACHED = db.power.detachFromFrame
		frame.USE_INSET_POWERBAR = not frame.POWERBAR_DETACHED and db.power.width == "inset" and frame.USE_POWERBAR
		frame.USE_MINI_POWERBAR = (not frame.POWERBAR_DETACHED and db.power.width == "spaced" and frame.USE_POWERBAR)
		frame.USE_POWERBAR_OFFSET = (db.power.width == "offset" and db.power.offset ~= 0) and frame.USE_POWERBAR and not frame.POWERBAR_DETACHED
		frame.POWERBAR_OFFSET = frame.USE_POWERBAR_OFFSET and db.power.offset or 0
		frame.POWERBAR_HEIGHT = not frame.USE_POWERBAR and 0 or db.power.height
		frame.POWERBAR_WIDTH = frame.USE_MINI_POWERBAR and (frame.UNIT_WIDTH - (UF.BORDER * 2)) / 2 or (frame.POWERBAR_DETACHED and db.power.detachedWidth or (frame.UNIT_WIDTH - ((UF.BORDER + UF.SPACING) * 2)))
		frame.USE_PORTRAIT = db.portrait and db.portrait.enable
		frame.USE_PORTRAIT_OVERLAY = frame.USE_PORTRAIT and (db.portrait.overlay or frame.ORIENTATION == "MIDDLE")
		frame.PORTRAIT_WIDTH = (frame.USE_PORTRAIT_OVERLAY or not frame.USE_PORTRAIT) and 0 or db.portrait.width
		frame.CAN_HAVE_CLASSBAR = db.combobar.enable
		frame.MAX_CLASS_BAR = MAX_COMBO_POINTS
		frame.USE_CLASSBAR = db.combobar.enable
		frame.CLASSBAR_SHOWN = frame.CAN_HAVE_CLASSBAR and frame.ComboPoints:IsShown()
		frame.CLASSBAR_DETACHED = db.combobar.detachFromFrame
		frame.USE_MINI_CLASSBAR = db.combobar.fill == "spaced" and frame.USE_CLASSBAR
		frame.CLASSBAR_HEIGHT = frame.USE_CLASSBAR and db.combobar.height or 0
		frame.CLASSBAR_WIDTH = frame.UNIT_WIDTH - ((UF.BORDER + UF.SPACING) * 2) - frame.PORTRAIT_WIDTH - frame.POWERBAR_OFFSET
		frame.CLASSBAR_YOFFSET = (not frame.USE_CLASSBAR or not frame.CLASSBAR_SHOWN or frame.CLASSBAR_DETACHED) and 0 or (frame.USE_MINI_CLASSBAR and (UF.SPACING + (frame.CLASSBAR_HEIGHT / 2)) or (frame.CLASSBAR_HEIGHT + UF.SPACING))
		frame.USE_INFO_PANEL = not frame.USE_MINI_POWERBAR and not frame.USE_POWERBAR_OFFSET and db.infoPanel.enable
		frame.INFO_PANEL_HEIGHT = frame.USE_INFO_PANEL and db.infoPanel.height or 0
		frame.BOTTOM_OFFSET = UF:GetHealthBottomOffset(frame)
	end

	if db.strataAndLevel and db.strataAndLevel.useCustomStrata then
		frame:SetFrameStrata(db.strataAndLevel.frameStrata)
	else
		frame:SetFrameStrata(frame:GetParent():GetFrameStrata())
	end

	if db.strataAndLevel and db.strataAndLevel.useCustomLevel then
		frame:SetFrameLevel(db.strataAndLevel.frameLevel)
	else
		frame:SetFrameLevel(frame:GetParent():GetFrameLevel() + 1)
	end

	frame.colors = ElvUF.colors
	frame.Portrait = frame.Portrait or (db.portrait.style == "2D" and frame.Portrait2D or frame.Portrait3D)
	frame:RegisterForClicks(self.db.targetOnMouseDown and "AnyDown" or "AnyUp")
	frame:Size(frame.UNIT_WIDTH, frame.UNIT_HEIGHT)
	_G[frame:GetName().."Mover"]:Size(frame:GetSize())

	if not IsAddOnLoaded("Clique") then
		if db.middleClickFocus then
			frame:SetAttribute("type3", "focus")
		elseif frame:GetAttribute("type3") == "focus" then
			frame:SetAttribute("type3", nil)
		end
	end

	UF:Configure_InfoPanel(frame)
	UF:Configure_HealthBar(frame)
	UF:UpdateNameSettings(frame)
	UF:Configure_Power(frame)
	UF:Configure_Portrait(frame)
	UF:Configure_Threat(frame)
	UF:EnableDisable_Auras(frame)
	UF:Configure_AllAuras(frame)
	UF:Configure_ResurrectionIcon(frame)
	UF:Configure_RaidRoleIcons(frame)
	UF:Configure_Castbar(frame)
	UF:Configure_Fader(frame)
	UF:Configure_ComboPoints(frame)
	UF:Configure_AuraHighlight(frame)
	UF:Configure_GPS(frame)
	UF:Configure_HealComm(frame)
	UF:Configure_RaidIcon(frame)
	UF:Configure_AuraBars(frame)
	UF:Configure_PhaseIcon(frame)
	UF:Configure_PVPIcon(frame)
	UF:Configure_Cutaway(frame)
	UF:Configure_CustomTexts(frame)
	UF:Configure_CombatIndicator(frame)

	E:SetMoverSnapOffset(frame:GetName().."Mover", -(12 + db.castbar.height))
	frame:UpdateAllElements("ElvUI_UpdateAllElements")
end

tinsert(UF.unitstoload, "target")