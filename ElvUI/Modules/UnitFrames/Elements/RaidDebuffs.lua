local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")

local unpack = unpack

local CreateFrame = CreateFrame

function UF:Construct_RaidDebuffs(frame)
	local rdebuff = CreateFrame("Frame", nil, frame.RaisedElementParent)
	rdebuff:SetTemplate("Default", nil, nil, UF.thinBorders, true)
	rdebuff:SetFrameLevel(frame.RaisedElementParent:GetFrameLevel() + 20) --Make them appear above regular buffs or debuffs

	rdebuff.icon = rdebuff:CreateTexture(nil, "OVERLAY")
	rdebuff.icon:SetInside(rdebuff, UF.BORDER, UF.BORDER)

	rdebuff.count = rdebuff:CreateFontString(nil, "OVERLAY")
	rdebuff.count:FontTemplate(nil, 10, "OUTLINE")
	rdebuff.count:Point("BOTTOMRIGHT", 0, 2)
	rdebuff.count:SetTextColor(1, 0.9, 0)

	rdebuff.time = rdebuff:CreateFontString(nil, "OVERLAY")
	rdebuff.time:FontTemplate(nil, 10, "OUTLINE")
	rdebuff.time:Point("CENTER")
	rdebuff.time:SetTextColor(1, 0.9, 0)

	return rdebuff
end

function UF:Configure_RaidDebuffs(frame)
	local db = frame.db.rdebuffs

	if db.enable then
		local rdebuffsFont = UF.LSM:Fetch("font", db.font)
		if not frame:IsElementEnabled("RaidDebuffs") then
			frame:EnableElement("RaidDebuffs")
		end

		frame.RaidDebuffs.showDispellableDebuff = db.showDispellableDebuff
		frame.RaidDebuffs.onlyMatchSpellID = db.onlyMatchSpellID
		frame.RaidDebuffs.forceShow = frame.forceShowAuras

		frame.RaidDebuffs:Size(db.size)
		frame.RaidDebuffs:Point("BOTTOM", frame, "BOTTOM", db.xOffset, db.yOffset + UF.SPACING)

		frame.RaidDebuffs.icon:SetTexCoord(unpack(E.TexCoords))

		frame.RaidDebuffs.count:FontTemplate(rdebuffsFont, db.fontSize, db.fontOutline)
		frame.RaidDebuffs.count:ClearAllPoints()
		frame.RaidDebuffs.count:Point(db.stack.position, db.stack.xOffset, db.stack.yOffset)
		frame.RaidDebuffs.count:SetTextColor(db.stack.color.r, db.stack.color.g, db.stack.color.b, db.stack.color.a)

		frame.RaidDebuffs.time:FontTemplate(rdebuffsFont, db.fontSize, db.fontOutline)
		frame.RaidDebuffs.time:ClearAllPoints()
		frame.RaidDebuffs.time:Point(db.duration.position, db.duration.xOffset, db.duration.yOffset)
		frame.RaidDebuffs.time:SetTextColor(db.duration.color.r, db.duration.color.g, db.duration.color.b, db.duration.color.a)
	elseif frame:IsElementEnabled("RaidDebuffs") then
		frame:DisableElement("RaidDebuffs")
		frame.RaidDebuffs:Hide()
	end
end