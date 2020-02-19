local E, L, V, P, G = unpack(select(2, ...))
local B = E:GetModule("Blizzard")

local select, unpack, pairs = select, unpack, pairs

local CreateFrame = CreateFrame

function B:START_TIMER()
	for _, b in pairs(TimerTracker.timerList) do
		if b.bar and not b.bar.isSkinned then
			for i = 1, b.bar:GetNumRegions() do
				local region = select(i, b.bar:GetRegions())
				if region:IsObjectType("Texture") then
					region:SetTexture()
				elseif region:IsObjectType("FontString") then
					region:FontTemplate(nil, 12, "OUTLINE")
				end
			end

			b.bar:StripTextures()
			b.bar:CreateBackdrop("Transparent")
			b.bar:SetStatusBarTexture(E.media.normTex)
			b.bar:SetStatusBarColor(unpack(E.media.rgbvaluecolor))
			E:RegisterStatusBar(b.bar)

			b.bar.isSkinned = true
		end
	end
end

function B:SkinBlizzTimers()
	self:RegisterEvent("START_TIMER")
	self:START_TIMER()
end