local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")

local DEFAULT = [[Interface\CharacterFrame\UI-StateIcon]]

function UF:Construct_RestingIndicator(frame)
	return frame.RaisedElementParent.TextureParent:CreateTexture(nil, "OVERLAY")
end

function UF:Configure_RestingIndicator(frame)
	local db = frame.db.RestIcon

	if db.enable then
		if not frame:IsElementEnabled("RestingIndicator") then
			frame:EnableElement("RestingIndicator")
		end

		if db.defaultColor then
			frame.RestingIndicator:SetVertexColor(1, 1, 1, 1)
			frame.RestingIndicator:SetDesaturated(false)
		else
			frame.RestingIndicator:SetVertexColor(db.color.r, db.color.g, db.color.b, db.color.a)
			frame.RestingIndicator:SetDesaturated(true)
		end

		if db.texture == "CUSTOM" and db.customTexture then
			frame.RestingIndicator:SetTexture(db.customTexture)
			frame.RestingIndicator:SetTexCoord(0, 1, 0, 1)
		elseif db.texture ~= "DEFAULT" and E.Media.RestIcons[db.texture] then
			frame.RestingIndicator:SetTexture(E.Media.RestIcons[db.texture])
			frame.RestingIndicator:SetTexCoord(0, 1, 0, 1)
		else
			frame.RestingIndicator:SetTexture(DEFAULT)
			frame.RestingIndicator:SetTexCoord(0, 0.5, 0, 0.421875)
		end

		frame.RestingIndicator:Size(db.size)
		frame.RestingIndicator:ClearAllPoints()
		if frame.ORIENTATION ~= "RIGHT" and (frame.USE_PORTRAIT and not frame.USE_PORTRAIT_OVERLAY) then
			frame.RestingIndicator:Point("CENTER", frame.Portrait, db.anchorPoint, db.xOffset, db.yOffset)
		else
			frame.RestingIndicator:Point("CENTER", frame.Health, db.anchorPoint, db.xOffset, db.yOffset)
		end
	elseif frame:IsElementEnabled("RestingIndicator") then
		frame:DisableElement("RestingIndicator")
	end
end