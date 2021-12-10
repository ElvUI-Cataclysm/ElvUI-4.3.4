local E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule("NamePlates")

function NP:Update_CutawayHealthFadeOut(frame)
	frame.CutawayHealth.fading = true
	E:UIFrameFadeOut(frame.CutawayHealth, NP.db.cutawayHealthFadeOutTime, frame.CutawayHealth:GetAlpha(), 0)
	frame.CutawayHealth.isPlaying = nil
end

local function CutawayHealthClosure(frame)
	NP:Update_CutawayHealthFadeOut(frame)
end

function NP:CutawayHealthValueChangeCallback(frame, health, maxHealth)
	if NP.db.cutawayHealth then
		frame.CutawayHealth:SetMinMaxValues(0, maxHealth)
		local oldValue = frame.Health:GetValue()
		local change = oldValue - health
		if change > 0 and not frame.CutawayHealth.isPlaying then
			if frame.CutawayHealth.fading then
				E:UIFrameFadeRemoveFrame(frame.CutawayHealth)
			end
			frame.CutawayHealth.fading = false
			frame.CutawayHealth:SetValue(oldValue)
			frame.CutawayHealth:SetAlpha(1)

			E:Delay(NP.db.cutawayHealthLength, CutawayHealthClosure, frame)

			frame.CutawayHealth.isPlaying = true
			frame.CutawayHealth:Show()
		end
	else
		if frame.CutawayHealth.isPlaying then
			frame.CutawayHealth.isPlaying = nil
			frame.CutawayHealth:SetScript("OnUpdate", nil)
		end
		frame.CutawayHealth:Hide()
	end
end

function NP:CutawayHealthColorChangeCallback(frame, r, g, b)
	frame.CutawayHealth:SetStatusBarColor(r * 1.5, g * 1.5, b * 1.5, 1)
end

function NP:Construct_CutawayHealth(parent)
	local cutawayHealth = CreateFrame("StatusBar", "$parentCutawayHealth", parent.Health)
	cutawayHealth:SetAllPoints()
	cutawayHealth:SetStatusBarTexture(E.media.blankTex)
	cutawayHealth:SetFrameLevel(parent.Health:GetFrameLevel() - 1)

	NP:RegisterHealthCallbacks(parent, NP.CutawayHealthValueChangeCallback, NP.CutawayHealthColorChangeCallback)

	return cutawayHealth
end