local E, L, V, P, G = unpack(select(2, ...))
local B = E:GetModule("Blizzard")

local min = math.min

local hooksecurefunc = hooksecurefunc
local GetScreenHeight = GetScreenHeight

function B:SetWatchFrameHeight()
	local top = _G.WatchFrame:GetTop() or 0
	local screenHeight = GetScreenHeight()
	local gapFromTop = screenHeight - top
	local maxHeight = screenHeight - gapFromTop
	local watchFrameHeight = min(maxHeight, E.db.general.watchFrameHeight)

	_G.WatchFrame:Height(watchFrameHeight)
end

function B:MoveWatchFrame()
	local WatchFrameHolder = CreateFrame("Frame", "WatchFrameHolder", E.UIParent)
	WatchFrameHolder:Width(207)
	WatchFrameHolder:Height(22)
	WatchFrameHolder:Point('TOPRIGHT', E.UIParent, 'TOPRIGHT', -135, -300)

	E:CreateMover(WatchFrameHolder, "WatchFrameMover", L["Objective Frame"])
	WatchFrameHolder:SetAllPoints(WatchFrameMover)

	WatchFrame:ClearAllPoints()
	WatchFrame:SetPoint("TOP", WatchFrameHolder, "TOP")
	B:SetWatchFrameHeight()
	WatchFrame:SetClampedToScreen(false)

	local function WatchFrame_SetPosition(_, _, parent)
		if parent ~= WatchFrameHolder then
			WatchFrame:ClearAllPoints()
			WatchFrame:SetPoint("TOP", WatchFrameHolder, "TOP")
		end
	end
	hooksecurefunc(WatchFrame, "SetPoint", WatchFrame_SetPosition)
end