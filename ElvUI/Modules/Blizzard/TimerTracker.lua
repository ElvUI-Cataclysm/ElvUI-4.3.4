local E, L, V, P, G = unpack(select(2, ...))
local B = E:GetModule("Blizzard")

local select, unpack, pairs = select, unpack, pairs

local CreateFrame = CreateFrame

local function SkinIt(bar)
	for i = 1, bar:GetNumRegions() do
		local region = select(i, bar:GetRegions())
		if region:IsObjectType("Texture") then
			region:SetTexture()
		elseif region:IsObjectType("FontString") then
			region:FontTemplate(nil, 12, "OUTLINE")
		end
	end

	bar:StripTextures()
	bar:CreateBackdrop("Transparent")
	bar:SetStatusBarTexture(E.media.normTex)
	bar:SetStatusBarColor(unpack(E.media.rgbvaluecolor))
	E:RegisterStatusBar(bar)
end

function B:START_TIMER()
	for _, b in pairs(TimerTracker.timerList) do
		if b.bar and not b.bar.skinned then
			SkinIt(b.bar)

			b.bar.skinned = true
		end
	end
end

function B:SkinBlizzTimers()
	self:RegisterEvent("START_TIMER")
	self:START_TIMER()
end