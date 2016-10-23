local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule('Skins')

local _G = _G
local unpack, pairs = unpack, pairs
local find = string.find;

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.lfr ~= true then return end

	S:HandleButton(LFRQueueFrameFindGroupButton);
	S:HandleButton(LFRQueueFrameAcceptCommentButton);
	S:HandleButton(LFRBrowseFrameSendMessageButton);
	S:HandleButton(LFRBrowseFrameInviteButton);
	S:HandleButton(LFRBrowseFrameRefreshButton);

	S:HandleDropDownBox(LFRBrowseFrameRaidDropDown)

	for i = 1, 7 do
		local button = "LFRBrowseFrameColumnHeader"..i
		_G[button.."Left"]:Kill()
		_G[button.."Middle"]:Kill()
		_G[button.."Right"]:Kill()
		_G[button]:StyleButton()
	end

	S:HandleCheckBox(LFRQueueFrameRoleButtonTank:GetChildren())
	S:HandleCheckBox(LFRQueueFrameRoleButtonHealer:GetChildren())
	S:HandleCheckBox(LFRQueueFrameRoleButtonDPS:GetChildren())
	LFRQueueFrameRoleButtonTank:GetChildren():SetFrameLevel(LFRQueueFrameRoleButtonTank:GetChildren():GetFrameLevel() + 2)
	LFRQueueFrameRoleButtonHealer:GetChildren():SetFrameLevel(LFRQueueFrameRoleButtonHealer:GetChildren():GetFrameLevel() + 2)
	LFRQueueFrameRoleButtonDPS:GetChildren():SetFrameLevel(LFRQueueFrameRoleButtonDPS:GetChildren():GetFrameLevel() + 2)

	LFRQueueFrameSpecificListScrollFrame:StripTextures()

	for i = 1, 2 do
		local tab = _G["LFRParentFrameSideTab"..i]
		tab:GetRegions():Hide();
		tab:SetTemplate("Default");
		tab:StyleButton(nil, true);
		tab:GetNormalTexture():SetInside();
		tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords));
	end

	LFRParentFrameSideTab1:Point("TOPLEFT", LFRParentFrame, "TOPRIGHT", -1, -35)

	RaidParentFrame:StripTextures()
	RaidParentFrame:SetTemplate('Transparent')

	for i = 1, 3 do 
		S:HandleTab(_G['RaidParentFrameTab'..i])
	end

	S:HandleButton(RaidFinderFrameFindRaidButton, true)
	S:HandleButton(RaidFinderFrameCancelButton, true)
	S:HandleDropDownBox(RaidFinderQueueFrameSelectionDropDown)

	RaidFinderQueueFrame:StripTextures()
	RaidParentFrameInset:StripTextures()
	RaidFinderQueueFrame:StripTextures(true)
	RaidFinderFrameRoleInset:StripTextures()

	RaidFinderFrame:StripTextures()
	LFRParentFrame:StripTextures()
	LFRQueueFrame:StripTextures()
	LFRQueueFrameListInset:StripTextures()
	LFRQueueFrameRoleInset:StripTextures()
	LFRQueueFrameCommentInset:StripTextures()
	LFRBrowseFrame:StripTextures()

	S:HandleScrollBar(LFRQueueFrameCommentScrollFrameScrollBar)

	RaidFinderQueueFrameSelectionDropDown:Width(225)
	RaidFinderQueueFrameSelectionDropDown.SetWidth = E.noop

	LFRQueueFrameCommentTextButton:CreateBackdrop("Default")
	LFRQueueFrameCommentTextButton:Height(35)

	LFRBrowseFrame:HookScript('OnShow', function()
		if(not LFRBrowseFrameListScrollFrameScrollBar.skinned) then
			S:HandleScrollBar(LFRBrowseFrameListScrollFrameScrollBar)
			LFRBrowseFrameListScrollFrameScrollBar.skinned = true
		end
	end)

	local checkButtons = {
		"RaidFinderQueueFrameRoleButtonTank",
		"RaidFinderQueueFrameRoleButtonHealer",
		"RaidFinderQueueFrameRoleButtonDPS",
		"RaidFinderQueueFrameRoleButtonLeader"
	}

	for _, object in pairs(checkButtons) do
		_G[object].checkButton:SetFrameLevel(_G[object].checkButton:GetFrameLevel() + 2)
		S:HandleCheckBox(_G[object].checkButton)
	end

	for i = 1, 1 do
		local button = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i]
		local icon = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."IconTexture"]
		local count = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."Count"]

		if(button) then
			button:StripTextures()
			button:CreateBackdrop("Default")
			button.backdrop:SetOutside(icon)

			icon:SetTexCoord(unpack(E.TexCoords))
			icon:SetParent(button.backdrop);

			icon:SetDrawLayer("OVERLAY")
			count:SetDrawLayer("OVERLAY")

			if(count) then count:SetParent(button.backdrop) end
		end
	end

	S:HandleButton(RaidFinderQueueFrameIneligibleFrameLeaveQueueButton)
	S:HandleButton(LFRQueueFrameNoLFRWhileLFDLeaveQueueButton)
	S:HandleCloseButton(RaidParentFrameCloseButton)

	for i = 1, NUM_LFR_CHOICE_BUTTONS do
		local button = _G["LFRQueueFrameSpecificListButton" .. i];
		S:HandleCheckBox(button.enableButton);

		button.expandOrCollapseButton:SetNormalTexture("Interface\\Buttons\\UI-PlusMinus-Buttons");
		button.expandOrCollapseButton.SetNormalTexture = E.noop;
		button.expandOrCollapseButton:SetHighlightTexture(nil);
		button.expandOrCollapseButton:GetNormalTexture():Size(12)
		button.expandOrCollapseButton:GetNormalTexture():Point("CENTER", 4, 0);

		hooksecurefunc(button.expandOrCollapseButton, "SetNormalTexture", function(self, texture)
			if(find(texture, "MinusButton")) then
				self:GetNormalTexture():SetTexCoord(0.5625, 1, 0, 0.4375)
			else
				self:GetNormalTexture():SetTexCoord(0, 0.4375, 0, 0.4375)
			end
		end);
 	end
end

S:AddCallback("LFR", LoadSkin);