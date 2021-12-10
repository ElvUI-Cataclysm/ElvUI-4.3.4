local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")

function UF:PostUpdate_PhaseIcon(isInSamePhase)
	if not isInSamePhase then
		self.Center:Show()
	else
		self.Center:Hide()
	end
end

function UF:Construct_PhaseIcon(frame)
	local PhaseIndicator = frame.RaisedElementParent.TextureParent:CreateTexture(nil, "OVERLAY", nil, 6)
	PhaseIndicator:SetTexture(E.Media.Textures.PhaseBorder)
	PhaseIndicator:Point("CENTER", frame.Health)
	PhaseIndicator:Size(32)

	local Center = frame.RaisedElementParent.TextureParent:CreateTexture(nil, "OVERLAY", nil, 7)
	Center:SetTexture(E.Media.Textures.PhaseCenter)
	Center:Point("CENTER", frame.Health)
	Center:Size(32)
	Center:Hide()

	PhaseIndicator.Center = Center
	PhaseIndicator.PostUpdate = UF.PostUpdate_PhaseIcon

	return PhaseIndicator
end

function UF:Configure_PhaseIcon(frame)
	local db = frame.db.phaseIndicator
	local size = 32 * (db.scale or 1)

	frame.PhaseIndicator:ClearAllPoints()
	frame.PhaseIndicator:Point(db.anchorPoint, frame.Health, db.anchorPoint, db.xOffset, db.yOffset)
	frame.PhaseIndicator:Size(size)

	frame.PhaseIndicator.Center:Size(size)
	frame.PhaseIndicator.Center:ClearAllPoints()
	frame.PhaseIndicator.Center:SetAllPoints(frame.PhaseIndicator)
	frame.PhaseIndicator.Center:SetVertexColor(db.color.r, db.color.g, db.color.b)

	if db.enable and not frame:IsElementEnabled("PhaseIndicator") then
		frame:EnableElement("PhaseIndicator")
	elseif not db.enable and frame:IsElementEnabled("PhaseIndicator") then
		frame:DisableElement("PhaseIndicator")
		frame.PhaseIndicator.Center:Hide()
	end
end