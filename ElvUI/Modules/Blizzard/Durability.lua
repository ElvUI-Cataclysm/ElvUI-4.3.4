local E, L, V, P, G = unpack(select(2, ...))
local B = E:GetModule("Blizzard")

local _G = _G
local hooksecurefunc = hooksecurefunc

local function SetPosition(frame, _, parent)
	if parent == "MinimapCluster" or parent == _G["MinimapCluster"] then
		frame:ClearAllPoints()
		frame:Point("RIGHT", Minimap, "RIGHT")
		frame:SetScale(0.6)
	end
end
	
function B:PositionDurabilityFrame()
	DurabilityFrame:SetFrameStrata("HIGH")

	hooksecurefunc(DurabilityFrame, "SetPoint", SetPosition)
end