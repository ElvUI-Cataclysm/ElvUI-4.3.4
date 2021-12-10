local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")
local _, ns = ...
local ElvUF = ns.oUF
assert(ElvUF, "ElvUI was unable to locate oUF.")

local CreateFrame = CreateFrame

function UF:Construct_RaidpetFrames()
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	self.RaisedElementParent = CreateFrame("Frame", nil, self)
	self.RaisedElementParent.TextureParent = CreateFrame("Frame", nil, self.RaisedElementParent)
	self.RaisedElementParent:SetFrameLevel(self:GetFrameLevel() + 100)

	self.Health = UF:Construct_HealthBar(self, true, true, "RIGHT")
	self.Name = UF:Construct_NameText(self)
	self.Portrait3D = UF:Construct_Portrait(self, "model")
	self.Portrait2D = UF:Construct_Portrait(self, "texture")
	self.Buffs = UF:Construct_Buffs(self)
	self.Debuffs = UF:Construct_Debuffs(self)
	self.AuraWatch = UF:Construct_AuraWatch(self)
	self.RaidDebuffs = UF:Construct_RaidDebuffs(self)
	self.AuraHighlight = UF:Construct_AuraHighlight(self)
	self.TargetGlow = UF:Construct_TargetGlow(self)
	self.FocusGlow = UF:Construct_FocusGlow(self)
	self.MouseGlow = UF:Construct_MouseGlow(self)
	self.ThreatIndicator = UF:Construct_Threat(self)
	self.RaidTargetIndicator = UF:Construct_RaidIcon(self)
	self.HealthPrediction = UF:Construct_HealComm(self)
	self.Fader = UF:Construct_Fader()
	self.Cutaway = UF:Construct_Cutaway(self)

	self.customTexts = {}
	self.unitframeType = "raidpet"

	UF:Update_StatusBars()
	UF:Update_FontStrings()

	return self
end

function UF:Update_RaidpetHeader(header, db)
	local parent = header:GetParent()
	parent.db = db

	if not parent.positioned then
		parent:ClearAllPoints()
		parent:Point("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 4, 574)
		E:CreateMover(parent, parent:GetName().."Mover", L["Raid Pet Frames"], nil, nil, nil, "ALL,RAID", nil, "unitframe,groupUnits,raidpet,generalGroup")

		parent.positioned = true
	end
end

function UF:Update_RaidpetFrames(frame, db)
	frame.db = db

	frame.Portrait = frame.Portrait or (db.portrait.style == "2D" and frame.Portrait2D or frame.Portrait3D)
	frame.colors = ElvUF.colors
	frame:RegisterForClicks(UF.db.targetOnMouseDown and "AnyDown" or "AnyUp")

	do
		frame.ORIENTATION = db.orientation
		frame.SHADOW_SPACING = 3
		frame.UNIT_WIDTH = db.width
		frame.UNIT_HEIGHT = db.height
		frame.USE_POWERBAR = false
		frame.POWERBAR_DETACHED = false
		frame.USE_INSET_POWERBAR = false
		frame.USE_MINI_POWERBAR = false
		frame.USE_POWERBAR_OFFSET = false
		frame.POWERBAR_OFFSET = 0
		frame.POWERBAR_HEIGHT = 0
		frame.POWERBAR_WIDTH = 0
		frame.USE_PORTRAIT = db.portrait and db.portrait.enable
		frame.USE_PORTRAIT_OVERLAY = frame.USE_PORTRAIT and (db.portrait.overlay or frame.ORIENTATION == "MIDDLE")
		frame.PORTRAIT_WIDTH = (frame.USE_PORTRAIT_OVERLAY or not frame.USE_PORTRAIT) and 0 or db.portrait.width
		frame.CLASSBAR_WIDTH = 0
		frame.CLASSBAR_YOFFSET = 0
		frame.BOTTOM_OFFSET = 0
	end

	frame.Health.colorPetByUnitClass = db.health.colorPetByUnitClass
	frame:Size(frame.UNIT_WIDTH, frame.UNIT_HEIGHT)

	UF:Configure_HealthBar(frame)
	UF:UpdateNameSettings(frame)
	UF:Configure_Portrait(frame)
	UF:Configure_Threat(frame)
	UF:EnableDisable_Auras(frame)
	UF:Configure_AllAuras(frame)
	UF:Configure_RaidDebuffs(frame)
	UF:Configure_RaidIcon(frame)
	UF:Configure_AuraHighlight(frame)
	UF:Configure_HealComm(frame)
	UF:Configure_Fader(frame)
	UF:Configure_Cutaway(frame)
	UF:Configure_CustomTexts(frame)
	UF:UpdateAuraWatch(frame, true)

	frame:UpdateAllElements("ElvUI_UpdateAllElements")
end

--Added an additional argument at the end, specifying the header Template we want to use
UF.headerstoload.raidpet = {nil, nil, "SecureGroupPetHeaderTemplate"}