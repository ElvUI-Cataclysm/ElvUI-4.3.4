local E, L, V, P, G, _ = unpack(ElvUI);
local addon = E:GetModule("AddOnSkins");

if(not addon:CheckAddOn("_NPCScan")) then return; end

function addon:_NPCScan()
	local S = E:GetModule("Skins");

	_NPCScanButton:SetScale(1);
	_NPCScanButton.SetScale = E.noop;

	_NPCScanButton:StripTextures();
	_NPCScanButton:SetTemplate("Transparent", true);

	_NPCScanButton:HookScript("OnEnter", S.SetModifiedBackdrop);
	_NPCScanButton:HookScript("OnLeave", S.SetOriginalBackdrop);

	for i = 1, _NPCScanButton:GetNumChildren() do
		local child = select(i, _NPCScanButton:GetChildren())
		if(child and child:IsObjectType("Button")) then
			S:HandleCloseButton(child);
			child:ClearAllPoints();
			child:SetPoint("TOPRIGHT", _NPCScanButton, "TOPRIGHT", 4, 4);
			child:SetScale(1);
		end
	end

	local NPCFoundText = select(4, _NPCScanButton:GetRegions());
	NPCFoundText:SetTextColor(1, 1, 1, 1);
	NPCFoundText:SetShadowOffset(1, -1);

	--Interface Options
	S:HandleButton(_NPCScanTest)
	_NPCScanConfigAlert:StripTextures()
	
	S:HandleCheckBox(_NPCScanConfigCacheWarningsCheckbox)
	S:HandleCheckBox(_NPCScanConfigPrintTimeCheckbox)
	S:HandleCheckBox(_NPCScanConfigUnmuteCheckbox)
	S:HandleCheckBox(_NPCScanSearchAchievementAddFoundCheckbox)
	
	S:HandleDropDownBox(_NPCScanConfigSoundDropdown)

	for i = 1, 3 do
 	   S:HandleTab(_G["_NPCScanSearchTab" .. i]);
	end

	S:HandleEditBox(_NPCScanSearchNpcName)
	S:HandleEditBox(_NPCScanSearchNpcID)
	S:HandleEditBox(_NPCScanSearchNpcWorld)

end

addon:RegisterSkin("_NPCScan", addon._NPCScan);