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
	
	WorldStateAlwaysUpFrame:ClearAllPoints()
	WorldStateAlwaysUpFrame:SetPoint("TOP", UIParent, "TOP", 0, -15)

	alwaysUpShown = 1
	frame = "AlwaysUpFrame"..alwaysUpShown
	offset = 0

	for i=alwaysUpShown, NUM_ALWAYS_UP_UI_FRAMES do
		frame = _G["AlwaysUpFrame"..i]
		frameText = _G["AlwaysUpFrame"..i.."Text"]
		frameIcon = _G["AlwaysUpFrame"..i.."Icon"]
		frameIcon2 = _G["AlwaysUpFrame"..i.."DynamicIconButton"]

		frame:ClearAllPoints()
		frameText:ClearAllPoints()
		frameIcon:ClearAllPoints()
		frameIcon2:ClearAllPoints()

		frameText:SetPoint("CENTER", WorldStateAlwaysUpFrame, "CENTER", 0, offset)
		frameText:SetJustifyH("CENTER")
		frameIcon:SetPoint("CENTER", frameText, "LEFT", -13, -8)
		frameIcon2:SetPoint("LEFT", frameText, "RIGHT", 5, 0)

		offset = offset - 25
	end
end

function B:PositionCaptureBar()
	self:SecureHook("WorldStateAlwaysUpFrame_Update");
end