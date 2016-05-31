local E, L, V, P, G, _ = unpack(ElvUI);
local addon = E:GetModule("AddOnSkins");

local captureBarCreate, captureBarUpdate;
function addon:Blizzard_WorldStateFrame(...)
	captureBarCreate = function(id)
		local bar = _G["WorldStateCaptureBar"..id];
		bar:SetSize(173, 16);
		bar:ClearAllPoints()
		bar:SetPoint("CENTER", UIParent, "CENTER", 0, 360);
		bar:CreateBackdrop("Default");
		
		_G["WorldStateCaptureBar"..id.."LeftBar"]:SetSize(85, 16);
		_G["WorldStateCaptureBar"..id.."LeftBar"]:SetPoint("LEFT", 0, 0);
		_G["WorldStateCaptureBar"..id.."LeftBar"]:SetTexture(E.media.glossTex);
		_G["WorldStateCaptureBar"..id.."LeftBar"]:SetTexCoord(1, 0, 1, 0);
		_G["WorldStateCaptureBar"..id.."LeftBar"]:SetVertexColor(0, .44, .87);
		
		bar.leftBarIcon = bar:CreateTexture("$parentLeftBarIcon", "ARTWORK");
		bar.leftBarIcon:SetTexture("Interface\\AddOns\\ElvUI_AddOnSkins\\media\\alliance");
		bar.leftBarIcon:SetPoint("RIGHT", bar, "LEFT", 0, 0);
		bar.leftBarIcon:SetSize(32, 32);
		
		_G["WorldStateCaptureBar"..id.."RightBar"]:SetSize(85, 16);
		_G["WorldStateCaptureBar"..id.."RightBar"]:SetPoint("RIGHT", 0, 0);
		_G["WorldStateCaptureBar"..id.."RightBar"]:SetTexture(E.media.glossTex);
		_G["WorldStateCaptureBar"..id.."RightBar"]:SetTexCoord(1, 0, 1, 0);
		_G["WorldStateCaptureBar"..id.."RightBar"]:SetVertexColor(.77, .12, .23);
		
		bar.rightBarIcon = bar:CreateTexture("$parentRightBarIcon", "ARTWORK");
		bar.rightBarIcon:SetTexture("Interface\\AddOns\\ElvUI_AddOnSkins\\media\\horde");
		bar.rightBarIcon:SetPoint("LEFT", bar, "RIGHT", 0, 0);
		bar.rightBarIcon:SetSize(32, 32);
		
		_G["WorldStateCaptureBar"..id.."MiddleBar"]:SetSize(25, 16);
		_G["WorldStateCaptureBar"..id.."MiddleBar"]:SetTexture(E.media.glossTex);
		_G["WorldStateCaptureBar"..id.."MiddleBar"]:SetTexCoord(1, 0, 1, 0);
		_G["WorldStateCaptureBar"..id.."MiddleBar"]:SetVertexColor(1, 1, 1);
		
		select(4, bar:GetRegions()):SetTexture(nil);
		
		_G["WorldStateCaptureBar"..id.."LeftLine"]:SetTexture(nil);
		_G["WorldStateCaptureBar"..id.."RightLine"]:SetTexture(nil);
		
		_G["WorldStateCaptureBar"..id.."LeftIconHighlight"]:SetTexture(nil);
		_G["WorldStateCaptureBar"..id.."RightIconHighlight"]:SetTexture(nil);
		
		_G["WorldStateCaptureBar"..id.."Indicator"]:StripTextures();
		
		bar.spark = CreateFrame("Frame", "$parentSpark", bar);
		bar.spark:SetTemplate("Default", true);
		bar.spark:SetSize(4, 18);
	end
	
	captureBarUpdate = function(id, value, neutralPercent)
		local position = 173*(1 - value/100);
		local bar = _G["WorldStateCaptureBar"..id];
		local barSize = 170;
		if(not bar.oldValue) then
			bar.oldValue = position;
		end
		
		local middleBar = _G["WorldStateCaptureBar"..id.."MiddleBar"];
		if(neutralPercent == 0) then
			middleBar:SetWidth(1);
		else
			middleBar:SetWidth(neutralPercent/100*barSize);
		end
		bar.oldValue = position;
		_G["WorldStateCaptureBar"..id].spark:SetPoint("CENTER", "WorldStateCaptureBar"..id, "LEFT", position, 0);
	end
	
	hooksecurefunc(ExtendedUI["CAPTUREPOINT"], "create", captureBarCreate);
	hooksecurefunc(ExtendedUI["CAPTUREPOINT"], "update", captureBarUpdate);
end

addon:RegisterSkin("Blizzard_WorldStateFrame", addon.Blizzard_WorldStateFrame);