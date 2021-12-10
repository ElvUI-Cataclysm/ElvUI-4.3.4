local E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule("NamePlates")
local LSM = E.Libs.LSM

local ipairs = ipairs

local CreateFrame = CreateFrame

--[[
Target Glow Style Option Variables
	style1 - Border
	style2 - Background
	style3 - Top Arrow Only
	style4 - Side Arrows Only
	style5 - Border + Top Arrow
	style6 - Background + Top Arrow
	style7 - Border + Side Arrows
	style8 - Background + Side Arrows
]]

function NP:Update_Glow(frame)
	local showIndicator

	if frame.isTarget then
		showIndicator = 1
	elseif NP.db.lowHealthThreshold > 0 then
		local health = frame.oldHealthBar:GetValue()
		local _, maxHealth = frame.oldHealthBar:GetMinMaxValues()
		local perc = health / maxHealth

		if health > 1 and perc <= NP.db.lowHealthThreshold then
			if perc <= NP.db.lowHealthThreshold / 2 then
				showIndicator = 2
			else
				showIndicator = 3
			end
		end
	end

	local glowStyle = NP.db.glowStyle
	local healthIsShown = frame.Health:IsShown()
	local nameExists = frame.Name:IsShown() and frame.Name:GetText() ~= nil

	if not healthIsShown and not frame.IconOnlyChanged and nameExists then
		if glowStyle == "style1" then
			glowStyle = "none"
		elseif glowStyle == "style5" then
			glowStyle = "style3"
		elseif glowStyle == "style7" then
			glowStyle = "style4"
		end
	end

	if showIndicator and glowStyle ~= "none" then
		local r, g, b

		if showIndicator == 1 then
			local color = NP.db.colors.glowColor
			r, g, b = color.r, color.g, color.b
		elseif showIndicator == 2 then
			r, g, b = 1, 0, 0
		else
			r, g, b = 1, 1, 0
		end

		-- Indicators
		frame.TopIndicator:SetVertexColor(r, g, b)
		frame.LeftIndicator:SetVertexColor(r, g, b)
		frame.RightIndicator:SetVertexColor(r, g, b)

		if glowStyle == "style3" or glowStyle == "style5" or glowStyle == "style6" then
			frame.LeftIndicator:Hide()
			frame.RightIndicator:Hide()

			if healthIsShown or frame.IconOnlyChanged or nameExists then
				frame.TopIndicator:Show()
			end
		elseif glowStyle == "style4" or glowStyle == "style7" or glowStyle == "style8" then
			frame.TopIndicator:Hide()

			if healthIsShown or frame.IconOnlyChanged or nameExists then
				frame.LeftIndicator:Show()
				frame.RightIndicator:Show()
			end
		end

		-- Spark / Shadow
		frame.Shadow:SetBackdropBorderColor(r, g, b)
		frame.Spark:SetVertexColor(r, g, b)

		if glowStyle == "style1" or glowStyle == "style5" or glowStyle == "style7" then
			frame.Spark:Hide()
			if healthIsShown or frame.IconOnlyChanged then
				frame.Shadow:Show()
			end
		elseif glowStyle == "style2" or glowStyle == "style6" or glowStyle == "style8" then
			frame.Shadow:Hide()
			if healthIsShown or frame.IconOnlyChanged or nameExists then
				frame.Spark:Show()
			end
		elseif glowStyle == "style3" or glowStyle == "style4" then
			frame.Shadow:Hide()
			frame.Spark:Hide()
		end
	else
		frame.TopIndicator:Hide()
		frame.LeftIndicator:Hide()
		frame.RightIndicator:Hide()
		frame.Shadow:Hide()
		frame.Spark:Hide()
	end
end

function NP:Configure_Glow(frame)
	local glowStyle = NP.db.glowStyle
	local healthIsShown = frame.Health:IsShown()
	local nameExists = frame.Name:IsShown() and frame.Name:GetText() ~= nil

	if not healthIsShown and not frame.IconOnlyChanged and nameExists then
		if glowStyle == "style1" then
			glowStyle = "none"
		elseif glowStyle == "style5" then
			glowStyle = "style3"
		elseif glowStyle == "style7" then
			glowStyle = "style4"
		end
	end

	if glowStyle ~= "none" then
		local color = NP.db.colors.glowColor
		local r, g, b, a = color.r, color.g, color.b, color.a
		local arrowTex, arrowSize, arrowSpacing = E.Media.Arrows[NP.db.arrow], NP.db.arrowSize, NP.db.arrowSpacing

		-- Indicators
		frame.TopIndicator:SetTexture(arrowTex)
		frame.TopIndicator:SetSize(arrowSize, arrowSize)
		frame.TopIndicator:SetVertexColor(r, g, b)
		frame.TopIndicator:ClearAllPoints()

		frame.LeftIndicator:SetTexture(arrowTex)
		frame.LeftIndicator:SetSize(arrowSize, arrowSize)
		frame.LeftIndicator:SetVertexColor(r, g, b)
		frame.LeftIndicator:ClearAllPoints()

		frame.RightIndicator:SetTexture(arrowTex)
		frame.RightIndicator:SetSize(arrowSize, arrowSize)
		frame.RightIndicator:SetVertexColor(r, g, b)
		frame.RightIndicator:ClearAllPoints()

		if glowStyle == "style3" or glowStyle == "style5" or glowStyle == "style6" then
			if frame.IconOnlyChanged then
				frame.TopIndicator:SetPoint("BOTTOM", frame.IconFrame, "TOP", -1, arrowSpacing)
			else
				frame.TopIndicator:SetPoint("BOTTOM", healthIsShown and frame.Health or frame.Name, "TOP", 0, arrowSpacing)
			end
		elseif glowStyle == "style4" or glowStyle == "style7" or glowStyle == "style8" then
			if frame.IconOnlyChanged then
				frame.LeftIndicator:SetPoint("LEFT", frame.IconFrame, "RIGHT", arrowSpacing, 0)
				frame.RightIndicator:SetPoint("RIGHT", frame.IconFrame, "LEFT", -arrowSpacing, 0)
			else
				frame.LeftIndicator:SetPoint("LEFT", healthIsShown and frame.Health or frame.Name, "RIGHT", arrowSpacing, 0)
				frame.RightIndicator:SetPoint("RIGHT", healthIsShown and frame.Health or frame.Name, "LEFT", -arrowSpacing, 0)
			end
		end

		-- Spark / Shadow
		frame.Shadow:SetBackdropBorderColor(r, g, b)
		frame.Shadow:SetAlpha(a)

		frame.Spark:SetVertexColor(r, g, b, a)
		frame.Spark:ClearAllPoints()

		if glowStyle == "style1" or glowStyle == "style5" or glowStyle == "style7" then
			local offset = E:Scale(NP.thinBorders and 6 or 8)
			frame.Shadow:SetOutside(frame.IconOnlyChanged and frame.IconFrame or frame.Health, offset, offset)
		elseif glowStyle == "style2" or glowStyle == "style6" or glowStyle == "style8" then
			if healthIsShown then
				local size = E.Border + 14
				local x = size * 2
				frame.Spark:SetPoint("TOPLEFT", frame.Health, -x, size)
				frame.Spark:SetPoint("BOTTOMRIGHT", frame.Health, x, -size)
			else
				frame.Spark:SetPoint("TOPLEFT", frame.IconOnlyChanged and frame.IconFrame or frame.Name, -20, 8)
				frame.Spark:SetPoint("BOTTOMRIGHT", frame.IconOnlyChanged and frame.IconFrame or frame.Name, 20, -8)
			end
		end
	end
end

function NP:Construct_Glow(frame)
	frame.Shadow = CreateFrame("Frame", "$parentGlow", frame)
	frame.Shadow:SetFrameLevel(frame.Health:GetFrameLevel() - 1)
	frame.Shadow:SetBackdrop({edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = E:Scale(6)})
	frame.Shadow:Hide()

	for _, object in ipairs({"Spark", "TopIndicator", "LeftIndicator", "RightIndicator"}) do
		frame[object] = frame:CreateTexture(nil, "BACKGROUND")
		frame[object]:Hide()
	end

	frame.Spark:SetTexture(E.Media.Textures.Spark)
	frame.TopIndicator:SetTexCoord(1, 1, 1, 0, 0, 1, 0, 0) -- Rotates texture 180 degress (Up arrow to face down)
	frame.LeftIndicator:SetTexCoord(1, 0, 0, 0, 1, 1, 0, 1) -- Rotates texture 90 degrees clockwise (Up arrow to face right)
	frame.RightIndicator:SetTexCoord(1, 1, 0, 1, 1, 0, 0, 0) -- Flips texture horizontally (Right facing arrow to face left)
end