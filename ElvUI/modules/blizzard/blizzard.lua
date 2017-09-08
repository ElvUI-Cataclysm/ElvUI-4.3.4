local E, L, V, P, G = unpack(select(2, ...));
local B = E:NewModule('Blizzard', 'AceEvent-3.0', 'AceHook-3.0');

E.Blizzard = B;

function B:Initialize()
	self:AlertMovers();
	self:EnhanceColorPicker();
	self:KillBlizzard();
	self:PositionCaptureBar();
	self:PositionDurabilityFrame();
	self:PositionGMFrames();
	self:PositionVehicleFrame();
	self:MoveWatchFrame();
	self:SkinBlizzTimers();
	self:ErrorFrameSize()

 	if(not IsAddOnLoaded("SimplePowerBar")) then
 		self:PositionAltPowerBar();
	end

	if(GetLocale() == "deDE") then
		DAY_ONELETTER_ABBR = "%d d";
	end

	CreateFrame("Frame"):SetScript("OnUpdate", function(self, elapsed)
		if LFRBrowseFrame.timeToClear then
			LFRBrowseFrame.timeToClear = nil
		end
	end)

	WorldMapQuestDetailScrollFrame:Width(320)
	WorldMapQuestDetailScrollChildFrame:SetScale(1)

	WorldMapQuestRewardScrollFrame:Point("LEFT", WorldMapQuestDetailScrollFrame, "RIGHT", 27, 0)
	WorldMapQuestRewardScrollFrame:Width(307)
	WorldMapQuestRewardScrollChildFrame:SetScale(0.97)
end

local function InitializeCallback()
	B:Initialize()
end

E:RegisterModule(B:GetName(), InitializeCallback)