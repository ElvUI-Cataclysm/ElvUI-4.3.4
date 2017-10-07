local E, L, V, P, G = unpack(select(2, ...));
local UF = E:GetModule('UnitFrames');

local CreateFrame = CreateFrame

function UF:Construct_HealComm(frame)
	local mhpb = CreateFrame("StatusBar", nil, frame.Health)
	mhpb:SetStatusBarTexture(E["media"].blankTex);
	mhpb:Hide();

	local ohpb = CreateFrame("StatusBar", nil, frame.Health)
	ohpb:SetStatusBarTexture(E["media"].blankTex);
	ohpb:Hide();

	local HealthPrediction = {
		myBar = mhpb,
		otherBar = ohpb,
		maxOverflow = 1,
		PostUpdate = UF.UpdateHealComm
	}
	HealthPrediction.parent = frame

	return HealthPrediction
end

function UF:Configure_HealComm(frame)
	local healPrediction = frame.HealthPrediction
	local c = self.db.colors.healPrediction

	if(frame.db.healPrediction) then
		if(not frame:IsElementEnabled("HealthPrediction")) then
			frame:EnableElement("HealthPrediction");
		end

		if(not frame.USE_PORTRAIT_OVERLAY) then
			healPrediction.myBar:SetParent(frame.Health);
			healPrediction.otherBar:SetParent(frame.Health);
		else
			healPrediction.myBar:SetParent(frame.Portrait.overlay);
			healPrediction.otherBar:SetParent(frame.Portrait.overlay);
		end

		local orientation = frame.db.health and frame.db.health.orientation
		if(orientation) then
			healPrediction.myBar:SetOrientation(orientation);
			healPrediction.otherBar:SetOrientation(orientation);
		end

		healPrediction.myBar:SetStatusBarColor(c.personal.r, c.personal.g, c.personal.b, c.personal.a);
		healPrediction.otherBar:SetStatusBarColor(c.others.r, c.others.g, c.others.b, c.others.a);

		healPrediction.maxOverflow = (1 + (c.maxOverflow or 0))
	else
		if(frame:IsElementEnabled("HealthPrediction")) then
			frame:DisableElement("HealthPrediction");
		end
	end
end

function UF:UpdateFillBar(frame, previousTexture, bar, amount)
	if(amount == 0) then
		bar:Hide();
		return previousTexture;
	end

	local orientation = frame.Health:GetOrientation()
	bar:ClearAllPoints();
	if(orientation == "HORIZONTAL") then
		bar:Point("TOPLEFT", previousTexture, "TOPRIGHT");
		bar:Point("BOTTOMLEFT", previousTexture, "BOTTOMRIGHT");
	else
		bar:Point("BOTTOMRIGHT", previousTexture, "TOPRIGHT");
		bar:Point("BOTTOMLEFT", previousTexture, "TOPLEFT");
	end

	local totalWidth, totalHeight = frame.Health:GetSize();
	if(orientation == "HORIZONTAL") then
		bar:Width(totalWidth);
	else
		bar:Height(totalHeight);
	end

	return bar:GetStatusBarTexture();
end

function UF:UpdateHealComm(_, myIncomingHeal, allIncomingHeal)
	local frame = self.parent
	local previousTexture = frame.Health:GetStatusBarTexture();

	previousTexture = UF:UpdateFillBar(frame, previousTexture, self.myBar, myIncomingHeal)
	previousTexture = UF:UpdateFillBar(frame, previousTexture, self.otherBar, allIncomingHeal)
end