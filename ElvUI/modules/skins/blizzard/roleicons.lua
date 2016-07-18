local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins')

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.roleicons ~= true then return end
	
	--Dungeon Finder Role Icons
	LFDQueueFrameRoleButtonTank:Point("BOTTOMLEFT", LFDQueueFrame, "BOTTOMLEFT", 25, 334)
	LFDQueueFrameRoleButtonHealer:Point("LEFT", LFDQueueFrameRoleButtonTank,"RIGHT", 23, 0)
	LFDQueueFrameRoleButtonLeader:Point("LEFT", LFDQueueFrameRoleButtonDPS, "RIGHT", 50, 0)
	--Leader Button
	LFDQueueFrameRoleButtonLeader:StripTextures()
	LFDQueueFrameRoleButtonLeader:CreateBackdrop("Default");
	LFDQueueFrameRoleButtonLeader.backdrop:Point("TOPLEFT", LFDQueueFrameRoleButtonLeader, "TOPLEFT", 3, -3)
	LFDQueueFrameRoleButtonLeader.backdrop:Point("BOTTOMRIGHT", LFDQueueFrameRoleButtonLeader, "BOTTOMRIGHT", -3, 3)
	LFDQueueFrameRoleButtonLeader.icon = LFDQueueFrameRoleButtonLeader:CreateTexture(nil, "OVERLAY");
	LFDQueueFrameRoleButtonLeader.icon:SetTexCoord(unpack(E.TexCoords))
	LFDQueueFrameRoleButtonLeader.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfgleader');
	LFDQueueFrameRoleButtonLeader.icon:SetInside(LFDQueueFrameRoleButtonLeader.backdrop)
	--Healer Role Button
	LFDQueueFrameRoleButtonHealer:StripTextures()
	LFDQueueFrameRoleButtonHealer:CreateBackdrop("Default", true, true);
	LFDQueueFrameRoleButtonHealer.backdrop:SetTemplate("Default", true, true);
	LFDQueueFrameRoleButtonHealer.backdrop:Point("TOPLEFT", LFDQueueFrameRoleButtonHealer, "TOPLEFT", 3, -3)
	LFDQueueFrameRoleButtonHealer.backdrop:Point("BOTTOMRIGHT", LFDQueueFrameRoleButtonHealer, "BOTTOMRIGHT", -3, 3)
	LFDQueueFrameRoleButtonHealer.icon = LFDQueueFrameRoleButtonHealer:CreateTexture(nil, "OVERLAY");
	LFDQueueFrameRoleButtonHealer.icon:SetTexCoord(unpack(E.TexCoords))
	LFDQueueFrameRoleButtonHealer.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfghealer');
	LFDQueueFrameRoleButtonHealer.icon:SetInside(LFDQueueFrameRoleButtonHealer.backdrop)
	--Damage Role Button
	LFDQueueFrameRoleButtonDPS:StripTextures()
	LFDQueueFrameRoleButtonDPS:CreateBackdrop("Default", true, true);
	LFDQueueFrameRoleButtonDPS.backdrop:SetTemplate("Default", true, true);
	LFDQueueFrameRoleButtonDPS.backdrop:Point("TOPLEFT", LFDQueueFrameRoleButtonDPS, "TOPLEFT", 3, -3)
	LFDQueueFrameRoleButtonDPS.backdrop:Point("BOTTOMRIGHT", LFDQueueFrameRoleButtonDPS, "BOTTOMRIGHT", -3, 3)
	LFDQueueFrameRoleButtonDPS.icon = LFDQueueFrameRoleButtonDPS:CreateTexture(nil, "OVERLAY");
	LFDQueueFrameRoleButtonDPS.icon:SetTexCoord(unpack(E.TexCoords))
	LFDQueueFrameRoleButtonDPS.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfgdamage');
	LFDQueueFrameRoleButtonDPS.icon:SetInside(LFDQueueFrameRoleButtonDPS.backdrop)
	--Tank Role Button
	LFDQueueFrameRoleButtonTank:StripTextures()
	LFDQueueFrameRoleButtonTank:CreateBackdrop("Default", true, true);
	LFDQueueFrameRoleButtonTank.backdrop:SetTemplate("Default", true, true);
	LFDQueueFrameRoleButtonTank.backdrop:Point("TOPLEFT", LFDQueueFrameRoleButtonTank, "TOPLEFT", 3, -3)
	LFDQueueFrameRoleButtonTank.backdrop:Point("BOTTOMRIGHT", LFDQueueFrameRoleButtonTank, "BOTTOMRIGHT", -3, 3)
	LFDQueueFrameRoleButtonTank.icon = LFDQueueFrameRoleButtonTank:CreateTexture(nil, "OVERLAY");
	LFDQueueFrameRoleButtonTank.icon:SetTexCoord(unpack(E.TexCoords))
	LFDQueueFrameRoleButtonTank.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfgtank');
	LFDQueueFrameRoleButtonTank.icon:SetInside(LFDQueueFrameRoleButtonTank.backdrop)
	
	--Raid Finder / Raid Finder Tab Icons
	RaidFinderQueueFrameRoleButtonTank:Point("BOTTOMLEFT", RaidFinderQueueFrame, "BOTTOMLEFT", 25, 334)
	RaidFinderQueueFrameRoleButtonHealer:Point("LEFT", RaidFinderQueueFrameRoleButtonTank, "RIGHT", 23, 0)
	RaidFinderQueueFrameRoleButtonLeader:Point("LEFT", RaidFinderQueueFrameRoleButtonDPS, "RIGHT", 50, 0)
	--Leader Button
	RaidFinderQueueFrameRoleButtonLeader:StripTextures()
	RaidFinderQueueFrameRoleButtonLeader:CreateBackdrop("Default");
	RaidFinderQueueFrameRoleButtonLeader.backdrop:Point("TOPLEFT", RaidFinderQueueFrameRoleButtonLeader, "TOPLEFT", 3, -3)
	RaidFinderQueueFrameRoleButtonLeader.backdrop:Point("BOTTOMRIGHT", RaidFinderQueueFrameRoleButtonLeader, "BOTTOMRIGHT", -3, 3)
	RaidFinderQueueFrameRoleButtonLeader.icon = RaidFinderQueueFrameRoleButtonLeader:CreateTexture(nil, "OVERLAY");
	RaidFinderQueueFrameRoleButtonLeader.icon:SetTexCoord(unpack(E.TexCoords))
	RaidFinderQueueFrameRoleButtonLeader.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfgleader');
	RaidFinderQueueFrameRoleButtonLeader.icon:SetInside(RaidFinderQueueFrameRoleButtonLeader.backdrop)
	--Healer Role Button
	RaidFinderQueueFrameRoleButtonHealer:StripTextures()
	RaidFinderQueueFrameRoleButtonHealer:CreateBackdrop("Default", true, true);
	RaidFinderQueueFrameRoleButtonHealer.backdrop:SetTemplate("Default", true, true);
	RaidFinderQueueFrameRoleButtonHealer.backdrop:Point("TOPLEFT", RaidFinderQueueFrameRoleButtonHealer, "TOPLEFT", 3, -3)
	RaidFinderQueueFrameRoleButtonHealer.backdrop:Point("BOTTOMRIGHT", RaidFinderQueueFrameRoleButtonHealer, "BOTTOMRIGHT", -3, 3)
	RaidFinderQueueFrameRoleButtonHealer.icon = RaidFinderQueueFrameRoleButtonHealer:CreateTexture(nil, "OVERLAY");
	RaidFinderQueueFrameRoleButtonHealer.icon:SetTexCoord(unpack(E.TexCoords))
	RaidFinderQueueFrameRoleButtonHealer.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfghealer');
	RaidFinderQueueFrameRoleButtonHealer.icon:SetInside(RaidFinderQueueFrameRoleButtonHealer.backdrop)
	--Damage Role Button
	RaidFinderQueueFrameRoleButtonDPS:StripTextures()
	RaidFinderQueueFrameRoleButtonDPS:CreateBackdrop("Default", true, true);
	RaidFinderQueueFrameRoleButtonDPS.backdrop:SetTemplate("Default", true, true);
	RaidFinderQueueFrameRoleButtonDPS.backdrop:Point("TOPLEFT", RaidFinderQueueFrameRoleButtonDPS, "TOPLEFT", 3, -3)
	RaidFinderQueueFrameRoleButtonDPS.backdrop:Point("BOTTOMRIGHT", RaidFinderQueueFrameRoleButtonDPS, "BOTTOMRIGHT", -3, 3)
	RaidFinderQueueFrameRoleButtonDPS.icon = RaidFinderQueueFrameRoleButtonDPS:CreateTexture(nil, "OVERLAY");
	RaidFinderQueueFrameRoleButtonDPS.icon:SetTexCoord(unpack(E.TexCoords))
	RaidFinderQueueFrameRoleButtonDPS.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfgdamage');
	RaidFinderQueueFrameRoleButtonDPS.icon:SetInside(RaidFinderQueueFrameRoleButtonDPS.backdrop)
	--Tank Role Button
	RaidFinderQueueFrameRoleButtonTank:StripTextures()
	RaidFinderQueueFrameRoleButtonTank:CreateBackdrop("Default", true, true);
	RaidFinderQueueFrameRoleButtonTank.backdrop:SetTemplate("Default", true, true);
	RaidFinderQueueFrameRoleButtonTank.backdrop:Point("TOPLEFT", RaidFinderQueueFrameRoleButtonTank, "TOPLEFT", 3, -3)
	RaidFinderQueueFrameRoleButtonTank.backdrop:Point("BOTTOMRIGHT", RaidFinderQueueFrameRoleButtonTank, "BOTTOMRIGHT", -3, 3)
	RaidFinderQueueFrameRoleButtonTank.icon = RaidFinderQueueFrameRoleButtonTank:CreateTexture(nil, "OVERLAY");
	RaidFinderQueueFrameRoleButtonTank.icon:SetTexCoord(unpack(E.TexCoords))
	RaidFinderQueueFrameRoleButtonTank.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfgtank');
	RaidFinderQueueFrameRoleButtonTank.icon:SetInside(RaidFinderQueueFrameRoleButtonTank.backdrop)
	
	--Raid Finder / Other Raids Tab Icons
	LFRQueueFrameRoleButtonTank:Point("TOPLEFT", LFRQueueFrame, "TOPLEFT", 50, -45)
	LFRQueueFrameRoleButtonHealer:Point("LEFT", LFRQueueFrameRoleButtonTank, "RIGHT", 43, 0)
	--Healer Role Button
	LFRQueueFrameRoleButtonHealer:StripTextures()
	LFRQueueFrameRoleButtonHealer:CreateBackdrop("Default", true, true);
	LFRQueueFrameRoleButtonHealer.backdrop:SetTemplate("Default", true, true);
	LFRQueueFrameRoleButtonHealer.backdrop:Point("TOPLEFT", LFRQueueFrameRoleButtonHealer, "TOPLEFT", 3, -3)
	LFRQueueFrameRoleButtonHealer.backdrop:Point("BOTTOMRIGHT", LFRQueueFrameRoleButtonHealer, "BOTTOMRIGHT", -3, 3)
	LFRQueueFrameRoleButtonHealer.icon = LFRQueueFrameRoleButtonHealer:CreateTexture(nil, "OVERLAY");
	LFRQueueFrameRoleButtonHealer.icon:SetTexCoord(unpack(E.TexCoords))
	LFRQueueFrameRoleButtonHealer.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfghealer');
	LFRQueueFrameRoleButtonHealer.icon:SetInside(LFRQueueFrameRoleButtonHealer.backdrop)
	--Damage Role Button
	LFRQueueFrameRoleButtonDPS:StripTextures()
	LFRQueueFrameRoleButtonDPS:CreateBackdrop("Default", true, true);
	LFRQueueFrameRoleButtonDPS.backdrop:SetTemplate("Default", true, true);
	LFRQueueFrameRoleButtonDPS.backdrop:Point("TOPLEFT", LFRQueueFrameRoleButtonDPS, "TOPLEFT", 3, -3)
	LFRQueueFrameRoleButtonDPS.backdrop:Point("BOTTOMRIGHT", LFRQueueFrameRoleButtonDPS, "BOTTOMRIGHT", -3, 3)
	LFRQueueFrameRoleButtonDPS.icon = LFRQueueFrameRoleButtonDPS:CreateTexture(nil, "OVERLAY");
	LFRQueueFrameRoleButtonDPS.icon:SetTexCoord(unpack(E.TexCoords))
	LFRQueueFrameRoleButtonDPS.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfgdamage');
	LFRQueueFrameRoleButtonDPS.icon:SetInside(LFRQueueFrameRoleButtonDPS.backdrop)
	--Tank Role Button
	LFRQueueFrameRoleButtonTank:StripTextures()
	LFRQueueFrameRoleButtonTank:CreateBackdrop("Default", true, true);
	LFRQueueFrameRoleButtonTank.backdrop:SetTemplate("Default", true, true);
	LFRQueueFrameRoleButtonTank.backdrop:Point("TOPLEFT", LFRQueueFrameRoleButtonTank, "TOPLEFT", 3, -3)
	LFRQueueFrameRoleButtonTank.backdrop:Point("BOTTOMRIGHT", LFRQueueFrameRoleButtonTank, "BOTTOMRIGHT", -3, 3)
	LFRQueueFrameRoleButtonTank.icon = LFRQueueFrameRoleButtonTank:CreateTexture(nil, "OVERLAY");
	LFRQueueFrameRoleButtonTank.icon:SetTexCoord(unpack(E.TexCoords))
	LFRQueueFrameRoleButtonTank.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfgtank');
	LFRQueueFrameRoleButtonTank.icon:SetInside(LFRQueueFrameRoleButtonTank.backdrop)
	
	--LF Dungeon Role Check PopUp
	--Tank Role Button
	LFDRoleCheckPopupRoleButtonTank:StripTextures()
	LFDRoleCheckPopupRoleButtonTank:CreateBackdrop("Default", true, true);
	LFDRoleCheckPopupRoleButtonTank.backdrop:SetTemplate("Default", true, true);
	LFDRoleCheckPopupRoleButtonTank.backdrop:Point("TOPLEFT", LFDRoleCheckPopupRoleButtonTank, "TOPLEFT", 7, -7)
	LFDRoleCheckPopupRoleButtonTank.backdrop:Point("BOTTOMRIGHT", LFDRoleCheckPopupRoleButtonTank, "BOTTOMRIGHT", -7, 7)
	LFDRoleCheckPopupRoleButtonTank.icon = LFDRoleCheckPopupRoleButtonTank:CreateTexture(nil, "OVERLAY");
	LFDRoleCheckPopupRoleButtonTank.icon:SetTexCoord(unpack(E.TexCoords))
	LFDRoleCheckPopupRoleButtonTank.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfgtank');
	LFDRoleCheckPopupRoleButtonTank.icon:SetInside(LFDRoleCheckPopupRoleButtonTank.backdrop)
	--Healer Role Button
	LFDRoleCheckPopupRoleButtonHealer:StripTextures()
	LFDRoleCheckPopupRoleButtonHealer:CreateBackdrop("Default", true, true);
	LFDRoleCheckPopupRoleButtonHealer.backdrop:SetTemplate("Default", true, true);
	LFDRoleCheckPopupRoleButtonHealer.backdrop:Point("TOPLEFT", LFDRoleCheckPopupRoleButtonHealer, "TOPLEFT", 7, -7)
	LFDRoleCheckPopupRoleButtonHealer.backdrop:Point("BOTTOMRIGHT", LFDRoleCheckPopupRoleButtonHealer, "BOTTOMRIGHT", -7, 7)
	LFDRoleCheckPopupRoleButtonHealer.icon = LFDRoleCheckPopupRoleButtonHealer:CreateTexture(nil, "OVERLAY");
	LFDRoleCheckPopupRoleButtonHealer.icon:SetTexCoord(unpack(E.TexCoords))
	LFDRoleCheckPopupRoleButtonHealer.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfghealer');
	LFDRoleCheckPopupRoleButtonHealer.icon:SetInside(LFDRoleCheckPopupRoleButtonHealer.backdrop)
	--Damage Role Button
	LFDRoleCheckPopupRoleButtonDPS:StripTextures()
	LFDRoleCheckPopupRoleButtonDPS:CreateBackdrop("Default", true, true);
	LFDRoleCheckPopupRoleButtonDPS.backdrop:SetTemplate("Default", true, true);
	LFDRoleCheckPopupRoleButtonDPS.backdrop:Point("TOPLEFT", LFDRoleCheckPopupRoleButtonDPS, "TOPLEFT", 7, -7)
	LFDRoleCheckPopupRoleButtonDPS.backdrop:Point("BOTTOMRIGHT", LFDRoleCheckPopupRoleButtonDPS, "BOTTOMRIGHT", -7, 7)
	LFDRoleCheckPopupRoleButtonDPS.icon = LFDRoleCheckPopupRoleButtonDPS:CreateTexture(nil, "OVERLAY");
	LFDRoleCheckPopupRoleButtonDPS.icon:SetTexCoord(unpack(E.TexCoords))
	LFDRoleCheckPopupRoleButtonDPS.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfgdamage');
	LFDRoleCheckPopupRoleButtonDPS.icon:SetInside(LFDRoleCheckPopupRoleButtonDPS.backdrop)
	
	hooksecurefunc("LFG_SetRoleIconIncentive", function(roleButton, incentiveIndex)
		if incentiveIndex then
			roleButton.backdrop:SetBackdropBorderColor(1, 0.80, 0.10)
		end
	end)
	
	hooksecurefunc("LFG_PermanentlyDisableRoleButton", function(button)
		if button.icon then
			button.icon:SetDesaturated(true)
		end
	end)
	
	hooksecurefunc("LFG_DisableRoleButton", function(button)
		if button.icon then
			button.icon:SetDesaturated(true)
		end
	end)
	
	hooksecurefunc("LFG_EnableRoleButton", function(button)
		if button.icon then
			button.icon:SetDesaturated(false)
		end
	end)
	
	--Role Check
	RolePollPopupRoleButtonTank:Point("TOPLEFT", RolePollPopup, "TOPLEFT", 32, -35)
	--Tank Role Button
	RolePollPopupRoleButtonTank:StripTextures()
	RolePollPopupRoleButtonTank:CreateBackdrop("Default");
	RolePollPopupRoleButtonTank.backdrop:Point("TOPLEFT", RolePollPopupRoleButtonTank, "TOPLEFT", 7, -7)
	RolePollPopupRoleButtonTank.backdrop:Point("BOTTOMRIGHT", RolePollPopupRoleButtonTank, "BOTTOMRIGHT", -7, 7)
	RolePollPopupRoleButtonTank.icon = RolePollPopupRoleButtonTank:CreateTexture(nil, "OVERLAY");
	RolePollPopupRoleButtonTank.icon:SetTexCoord(unpack(E.TexCoords))
	RolePollPopupRoleButtonTank.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfgtank');
	RolePollPopupRoleButtonTank.icon:SetInside(RolePollPopupRoleButtonTank.backdrop)
	--Damage Role Button
	RolePollPopupRoleButtonDPS:StripTextures()
	RolePollPopupRoleButtonDPS:CreateBackdrop("Default");
	RolePollPopupRoleButtonDPS.backdrop:Point("TOPLEFT", RolePollPopupRoleButtonDPS, "TOPLEFT", 7, -7)
	RolePollPopupRoleButtonDPS.backdrop:Point("BOTTOMRIGHT", RolePollPopupRoleButtonDPS, "BOTTOMRIGHT", -7, 7)
	RolePollPopupRoleButtonDPS.icon = RolePollPopupRoleButtonDPS:CreateTexture(nil, "OVERLAY");
	RolePollPopupRoleButtonDPS.icon:SetTexCoord(unpack(E.TexCoords))
	RolePollPopupRoleButtonDPS.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfgdamage');
	RolePollPopupRoleButtonDPS.icon:SetInside(RolePollPopupRoleButtonDPS.backdrop)
	--Healer Role Button
	RolePollPopupRoleButtonHealer:StripTextures()
	RolePollPopupRoleButtonHealer:CreateBackdrop("Default");
	RolePollPopupRoleButtonHealer.backdrop:Point("TOPLEFT", RolePollPopupRoleButtonHealer, "TOPLEFT", 7, -7)
	RolePollPopupRoleButtonHealer.backdrop:Point("BOTTOMRIGHT", RolePollPopupRoleButtonHealer, "BOTTOMRIGHT", -7, 7)
	RolePollPopupRoleButtonHealer.icon = RolePollPopupRoleButtonHealer:CreateTexture(nil, "OVERLAY");
	RolePollPopupRoleButtonHealer.icon:SetTexCoord(unpack(E.TexCoords))
	RolePollPopupRoleButtonHealer.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfghealer');
	RolePollPopupRoleButtonHealer.icon:SetInside(RolePollPopupRoleButtonHealer.backdrop)
	
	hooksecurefunc("RolePollPopup_Show", function(self)
	local canBeTank, canBeHealer, canBeDamager = UnitGetAvailableRoles("player");
		if ( canBeTank ) then
			RolePollPopupRoleButtonTank.icon:SetDesaturated(false)
		else
			RolePollPopupRoleButtonTank.icon:SetDesaturated(true)
		end
		if ( canBeHealer ) then
			RolePollPopupRoleButtonHealer.icon:SetDesaturated(false)
		else
			RolePollPopupRoleButtonHealer.icon:SetDesaturated(true)
		end
		if ( canBeDamager ) then
			RolePollPopupRoleButtonDPS.icon:SetDesaturated(false)
		else
			RolePollPopupRoleButtonDPS.icon:SetDesaturated(true)
		end
	end)

	--LFG Search Status
	--Tank Role Button
	LFGSearchStatusIndividualRoleDisplayTank1:StripTextures()
	LFGSearchStatusIndividualRoleDisplayTank1:CreateBackdrop("Default");
	LFGSearchStatusIndividualRoleDisplayTank1.backdrop:Point("TOPLEFT", LFGSearchStatusIndividualRoleDisplayTank1, "TOPLEFT", 5, -5)
	LFGSearchStatusIndividualRoleDisplayTank1.backdrop:Point("BOTTOMRIGHT", LFGSearchStatusIndividualRoleDisplayTank1, "BOTTOMRIGHT", -5, 5)
	LFGSearchStatusIndividualRoleDisplayTank1.icon = LFGSearchStatusIndividualRoleDisplayTank1:CreateTexture(nil, "OVERLAY");
	LFGSearchStatusIndividualRoleDisplayTank1.icon:SetTexCoord(unpack(E.TexCoords))
	LFGSearchStatusIndividualRoleDisplayTank1.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfgtank');
	LFGSearchStatusIndividualRoleDisplayTank1.icon:SetInside(LFGSearchStatusIndividualRoleDisplayTank1.backdrop)
	--Healer Role Button
	LFGSearchStatusIndividualRoleDisplayHealer1:StripTextures()
	LFGSearchStatusIndividualRoleDisplayHealer1:CreateBackdrop("Default");
	LFGSearchStatusIndividualRoleDisplayHealer1.backdrop:Point("TOPLEFT", LFGSearchStatusIndividualRoleDisplayHealer1, "TOPLEFT", 5, -5)
	LFGSearchStatusIndividualRoleDisplayHealer1.backdrop:Point("BOTTOMRIGHT", LFGSearchStatusIndividualRoleDisplayHealer1, "BOTTOMRIGHT", -5, 5)
	LFGSearchStatusIndividualRoleDisplayHealer1.icon = LFGSearchStatusIndividualRoleDisplayHealer1:CreateTexture(nil, "OVERLAY");
	LFGSearchStatusIndividualRoleDisplayHealer1.icon:SetTexCoord(unpack(E.TexCoords))
	LFGSearchStatusIndividualRoleDisplayHealer1.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfghealer');
	LFGSearchStatusIndividualRoleDisplayHealer1.icon:SetInside(LFGSearchStatusIndividualRoleDisplayHealer1.backdrop)
	--Damage Role Buttons
	for i=1, 3 do
		_G["LFGSearchStatusIndividualRoleDisplayDamage"..i]:StripTextures()
		_G["LFGSearchStatusIndividualRoleDisplayDamage"..i]:CreateBackdrop("Default");
		_G["LFGSearchStatusIndividualRoleDisplayDamage"..i].backdrop:Point("TOPLEFT", _G["LFGSearchStatusIndividualRoleDisplayDamage"..i], "TOPLEFT", 5, -5)
		_G["LFGSearchStatusIndividualRoleDisplayDamage"..i].backdrop:Point("BOTTOMRIGHT", _G["LFGSearchStatusIndividualRoleDisplayDamage"..i], "BOTTOMRIGHT", -5, 5)
		_G["LFGSearchStatusIndividualRoleDisplayDamage"..i].icon = _G["LFGSearchStatusIndividualRoleDisplayDamage"..i]:CreateTexture(nil, "OVERLAY");
		_G["LFGSearchStatusIndividualRoleDisplayDamage"..i].icon:SetTexCoord(unpack(E.TexCoords))
		_G["LFGSearchStatusIndividualRoleDisplayDamage"..i].icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfgdamage');
		_G["LFGSearchStatusIndividualRoleDisplayDamage"..i].icon:SetInside(_G["LFGSearchStatusIndividualRoleDisplayDamage"..i].backdrop)
	end
	
	hooksecurefunc("LFGSearchStatusPlayer_SetFound", function(button, isFound)
		if button.icon then
			if ( isFound ) then
				button.icon:SetDesaturated(false)
			else
				button.icon:SetDesaturated(true)
			end
		end
	end)
	
	--Dungeon Ready PopUp
	hooksecurefunc("LFGDungeonReadyPopup_Update", function()
	local b, c, d, e, f, g, h, i, j, k, l, m = GetLFGProposal()
		if LFGDungeonReadyDialogRoleIcon:IsShown() then
			LFGDungeonReadyDialogRoleIcon:StripTextures()
			LFGDungeonReadyDialogRoleIcon:CreateBackdrop();
			LFGDungeonReadyDialogRoleIcon.backdrop:Point("TOPLEFT", LFGDungeonReadyDialogRoleIcon, "TOPLEFT", 7, -7)
			LFGDungeonReadyDialogRoleIcon.backdrop:Point("BOTTOMRIGHT", LFGDungeonReadyDialogRoleIcon, "BOTTOMRIGHT", -7, 7)
			LFGDungeonReadyDialogRoleIcon.icon = LFGDungeonReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY");
			LFGDungeonReadyDialogRoleIcon.icon:SetTexCoord(unpack(E.TexCoords))
			if h == "DAMAGER" then
				LFGDungeonReadyDialogRoleIcon.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfgdamage');
			elseif h == "TANK" then
				LFGDungeonReadyDialogRoleIcon.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfgtank');
			elseif h == "HEALER" then
				LFGDungeonReadyDialogRoleIcon.icon:SetTexture('Interface\\AddOns\\ElvUI\\media\\textures\\lfghealer');
			end
			LFGDungeonReadyDialogRoleIcon.icon:SetInside(LFGDungeonReadyDialogRoleIcon.backdrop)
		end
	end)
	
	--[[for i = 1, 5 do
		_G["LFGDungeonReadyStatusIndividualPlayer"..i]:StripTextures()
		_G["LFGDungeonReadyStatusIndividualPlayer"..i]:CreateBackdrop();
	end]]
end

S:RegisterSkin('ElvUI', LoadSkin)