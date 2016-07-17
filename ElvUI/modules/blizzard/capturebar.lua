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
			captureBar:Point("TOPRIGHT", E.UIParent, "TOPRIGHT", -25, -235);
		end
	end
end

hooksecurefunc("WorldStateAlwaysUpFrame_Update", function()
	WorldStateAlwaysUpFrame:ClearAllPoints()
	WorldStateAlwaysUpFrame:SetPoint("TOP", UIParent, "TOP", 0, 0)

	local _, _, _, _, y = AlwaysUpFrame1:GetPoint()
	AlwaysUpFrame1:SetPoint("TOP", WorldStateAlwaysUpFrame, "TOP", 0, y)

	for i = 1, NUM_ALWAYS_UP_UI_FRAMES do
		local frame = _G["AlwaysUpFrame"..i]
	
		local text = _G["AlwaysUpFrame"..i.."Text"]
		text:ClearAllPoints()
		text:SetPoint("CENTER", frame, "CENTER", 0, 0)
		text:SetJustifyH("CENTER")
	
		local icon = _G["AlwaysUpFrame"..i.."Icon"]
		icon:ClearAllPoints()
		icon:SetPoint("RIGHT", text, "LEFT", 10, -8)

		local dynamicIcon = _G["AlwaysUpFrame"..i.."DynamicIconButton"]
		dynamicIcon:ClearAllPoints()
		dynamicIcon:SetPoint("LEFT", text, "RIGHT", 5, 0)
	end
end)

function B:PositionCaptureBar()
	self:SecureHook("WorldStateAlwaysUpFrame_Update");
end