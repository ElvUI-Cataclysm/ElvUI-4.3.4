local E, L, DF = unpack(select(2, ...));
local B = E:GetModule("Blizzard");

local _G = _G;

function B:WorldStateAlwaysUpFrame_Update()
	local captureBar;
	for i = 1, NUM_EXTENDED_UI_FRAMES do
		captureBar = _G["WorldStateCaptureBar" .. i];
		_G["WorldStateCaptureBar" .. i]:SetScale(0.9)
		if(captureBar and captureBar:IsShown()) then
			captureBar:ClearAllPoints();
			captureBar:Point("TOPRIGHT", E.UIParent, "TOPRIGHT", -30, -235);
		end
	end
end

function B:PositionCaptureBar()
	self:SecureHook("WorldStateAlwaysUpFrame_Update");
end