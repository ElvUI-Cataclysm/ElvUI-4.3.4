local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")

local CreateFrame = CreateFrame

function UF.HealthClipFrame_HealComm(frame)
	local pred = frame.HealthPrediction
	if pred then
		UF:SetAlpha_HealComm(pred, true)
		UF:SetVisibility_HealComm(pred)
	end
end

function UF:SetAlpha_HealComm(obj, show)
	obj.myBar:SetAlpha(show and 1 or 0)
	obj.otherBar:SetAlpha(show and 1 or 0)
end

function UF:SetTexture_HealComm(obj, texture)
	obj.myBar:SetStatusBarTexture(texture)
	obj.otherBar:SetStatusBarTexture(texture)
end

function UF:SetVisibility_HealComm(obj)
	-- the first update is from `HealthClipFrame_HealComm`
	-- we set this variable to allow `Configure_HealComm` to
	-- update the elements overflow lock later on by option
	if not obj.allowClippingUpdate then
		obj.allowClippingUpdate = true
	end

	if obj.maxOverflow > 1 then
		obj.myBar:SetParent(obj.health)
		obj.otherBar:SetParent(obj.health)
	else
		obj.myBar:SetParent(obj.parent)
		obj.otherBar:SetParent(obj.parent)
	end
end

function UF:Construct_HealComm(frame)
	local health = frame.Health
	local parent = health.ClipFrame

	local myBar = CreateFrame("StatusBar", nil, parent)
	local otherBar = CreateFrame("StatusBar", nil, parent)

	myBar:SetFrameLevel(11)
	otherBar:SetFrameLevel(11)

	local prediction = {
		myBar = myBar,
		otherBar = otherBar,
		PostUpdate = UF.UpdateHealComm,
		maxOverflow = 1,
		health = health,
		parent = parent,
		frame = frame
	}

	UF:SetAlpha_HealComm(prediction)
	UF:SetTexture_HealComm(prediction, E.media.blankTex)

	return prediction
end

function UF:Configure_HealComm(frame)
	if frame.db.healPrediction and frame.db.healPrediction.enable then
		local healPrediction = frame.HealthPrediction
		local myBar = healPrediction.myBar
		local otherBar = healPrediction.otherBar
		local c = self.db.colors.healPrediction
		healPrediction.maxOverflow = 1 + (c.maxOverflow or 0)

		if healPrediction.allowClippingUpdate then
			UF:SetVisibility_HealComm(healPrediction)
		end

		if not frame:IsElementEnabled("HealthPrediction") then
			frame:EnableElement("HealthPrediction")
		end

		local health = frame.Health
		local orientation = health:GetOrientation()
		local reverseFill = health:GetReverseFill()
		local healthBarTexture = health:GetStatusBarTexture()

		UF:SetTexture_HealComm(healPrediction, UF.db.colors.transparentHealth and E.media.blankTex or healthBarTexture:GetTexture())

		myBar:SetOrientation(orientation)
		otherBar:SetOrientation(orientation)

		myBar:SetReverseFill(reverseFill)
		otherBar:SetReverseFill(reverseFill)

		myBar:SetStatusBarColor(c.personal.r, c.personal.g, c.personal.b, c.personal.a)
		otherBar:SetStatusBarColor(c.others.r, c.others.g, c.others.b, c.others.a)

		if orientation == "HORIZONTAL" then
			local width = health:GetWidth()
			width = (width > 0 and width) or health.WIDTH
			local p1 = reverseFill and "RIGHT" or "LEFT"
			local p2 = reverseFill and "LEFT" or "RIGHT"

			myBar:Size(width, 0)
			myBar:ClearAllPoints()
			myBar:Point("TOP", health, "TOP")
			myBar:Point("BOTTOM", health, "BOTTOM")
			myBar:Point(p1, healthBarTexture, p2)

			otherBar:Size(width, 0)
			otherBar:ClearAllPoints()
			otherBar:Point("TOP", health, "TOP")
			otherBar:Point("BOTTOM", health, "BOTTOM")
			otherBar:Point(p1, myBar:GetStatusBarTexture(), p2)
		else
			local height = health:GetHeight()
			height = (height > 0 and height) or health.HEIGHT
			local p1 = reverseFill and "TOP" or "BOTTOM"
			local p2 = reverseFill and "BOTTOM" or "TOP"

			myBar:Size(0, height)
			myBar:ClearAllPoints()
			myBar:Point("LEFT", health, "LEFT")
			myBar:Point("RIGHT", health, "RIGHT")
			myBar:Point(p1, healthBarTexture, p2)

			otherBar:Size(0, height)
			otherBar:ClearAllPoints()
			otherBar:Point("LEFT", health, "LEFT")
			otherBar:Point("RIGHT", health, "RIGHT")
			otherBar:Point(p1, myBar:GetStatusBarTexture(), p2)
		end
	elseif frame:IsElementEnabled("HealthPrediction") then
		frame:DisableElement("HealthPrediction")
	end
end