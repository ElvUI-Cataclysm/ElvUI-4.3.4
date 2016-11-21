local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule("Skins");

local _G = _G;
local unpack, select = unpack, select;

local GetItemInfo = GetItemInfo;
local GetItemQualityColor = GetItemQualityColor;
local GetTradeSkillItemLink = GetTradeSkillItemLink;
local GetTradeSkillReagentInfo = GetTradeSkillReagentInfo;
local GetTradeSkillReagentItemLink = GetTradeSkillReagentItemLink;

local function LoadSkin()
	if(E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.tradeskill ~= true) then return; end

	TradeSkillListScrollFrame:StripTextures();
	TradeSkillDetailScrollFrame:StripTextures();
	TradeSkillFrameInset:StripTextures();
	TradeSkillExpandButtonFrame:StripTextures();
	TradeSkillDetailScrollChildFrame:StripTextures();

	TradeSkillFrame:StripTextures(true);
	TradeSkillFrame:SetTemplate("Transparent");

	TradeSkillRankFrame:StripTextures();
	TradeSkillRankFrame:CreateBackdrop("Default");
	TradeSkillRankFrame:Size(280, 16);
	TradeSkillRankFrame:SetStatusBarTexture(E["media"].normTex);
	TradeSkillRankFrame:Point("TOPLEFT", TradeSkillFrame, "TOPLEFT", 28, -30);
	E:RegisterStatusBar(TradeSkillRankFrame);

	TradeSkillRankFrameSkillRank:FontTemplate(nil, 12, "OUTLINE");

	TradeSkillFilterButton:StripTextures(true);
	TradeSkillFilterButton:CreateBackdrop("Default", true);
	TradeSkillFilterButton.backdrop:SetAllPoints();
	TradeSkillFilterButton:Size(60, 20);
	TradeSkillFilterButton:Point("LEFT", TradeSkillFilterFrame, "LEFT", 5, 0);

	S:HandleButton(TradeSkillCreateButton, true);
	S:HandleButton(TradeSkillCancelButton, true);

	S:HandleButton(TradeSkillCreateAllButton, true);
	S:HandleButton(TradeSkillViewGuildCraftersButton, true);

	S:HandleScrollBar(TradeSkillListScrollFrameScrollBar);
	S:HandleScrollBar(TradeSkillDetailScrollFrameScrollBar);

	TradeSkillLinkButton:GetNormalTexture():SetTexCoord(0.25, 0.7, 0.37, 0.75);
	TradeSkillLinkButton:GetPushedTexture():SetTexCoord(0.25, 0.7, 0.45, 0.8);
	TradeSkillLinkButton:GetHighlightTexture():Kill();
	TradeSkillLinkButton:CreateBackdrop("Default");
	TradeSkillLinkButton:Size(17, 14);
	TradeSkillLinkButton:Point("LEFT", TradeSkillLinkFrame, "LEFT", 0, -27);

	S:HandleEditBox(TradeSkillFrameSearchBox);
	TradeSkillFrameSearchBox:Size(170, 17);
	TradeSkillFrameSearchBox:Point("TOPLEFT", TradeSkillRankFrame, "BOTTOMLEFT", 30, -10);

	S:HandleEditBox(TradeSkillInputBox);

	S:HandleNextPrevButton(TradeSkillDecrementButton);
	TradeSkillDecrementButton:Point("LEFT", TradeSkillCreateAllButton, "RIGHT", 8, 0);

	S:HandleNextPrevButton(TradeSkillIncrementButton);
	TradeSkillIncrementButton:Point("RIGHT", TradeSkillCreateButton, "LEFT", -9, 0);

	TradeSkillRequirementLabel:SetTextColor(1, 0.80, 0.10);

	S:HandleCloseButton(TradeSkillFrameCloseButton);

	TradeSkillReagent1:Point("TOPLEFT", TradeSkillReagentLabel, "BOTTOMLEFT", -2, -3);
	TradeSkillReagent2:Point("LEFT", TradeSkillReagent1, "RIGHT", 3, 0);
	TradeSkillReagent4:Point("LEFT", TradeSkillReagent3, "RIGHT", 3, 0);
	TradeSkillReagent6:Point("LEFT", TradeSkillReagent5, "RIGHT", 3, 0);
	TradeSkillReagent8:Point("LEFT", TradeSkillReagent7, "RIGHT", 3, 0);

	TradeSkillSkillIcon:StyleButton(nil, true);
	TradeSkillSkillIcon:SetTemplate();
	TradeSkillSkillIcon:SetAlpha(0);

	hooksecurefunc("TradeSkillFrame_SetSelection", function(id)
		TradeSkillRankFrame:SetStatusBarColor(0.11, 0.50, 1.00);
		if(TradeSkillSkillIcon:GetNormalTexture()) then
			TradeSkillSkillIcon:SetAlpha(1);
			TradeSkillSkillIcon:GetNormalTexture():SetTexCoord(unpack(E.TexCoords));
			TradeSkillSkillIcon:GetNormalTexture():SetInside();
		else
			TradeSkillSkillIcon:SetAlpha(0);
		end

		local skillLink = GetTradeSkillItemLink(id)
		if(skillLink) then
			local quality = select(3, GetItemInfo(skillLink));
			if(quality and quality > 1) then
				TradeSkillSkillIcon:SetBackdropBorderColor(GetItemQualityColor(quality));
				TradeSkillSkillName:SetTextColor(GetItemQualityColor(quality));
			else
				TradeSkillSkillIcon:SetBackdropBorderColor(unpack(E["media"].bordercolor));
				TradeSkillSkillName:SetTextColor(1, 1, 1);
			end
		end

		local numReagents = GetTradeSkillNumReagents(id);
		for i = 1, numReagents, 1 do
			local reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(id, i);
			local reagentLink = GetTradeSkillReagentItemLink(id, i);
			local reagent = _G["TradeSkillReagent" .. i];
			local icon = _G["TradeSkillReagent" .. i .. "IconTexture"];
			local name = _G["TradeSkillReagent" .. i .. "Name"];
			local count = _G["TradeSkillReagent" .. i .. "Count"];
			local nameFrame = _G["TradeSkillReagent" .. i .. "NameFrame"];

			if((reagentName or reagentTexture) and not reagent.isSkinned) then
				reagent:SetTemplate("Transparent", true);
				reagent:StyleButton(nil, true);
				reagent:Size(reagent:GetWidth(), reagent:GetHeight() + 1);

				icon:SetTexCoord(unpack(E.TexCoords));
				icon:SetDrawLayer("OVERLAY");
				icon:Size(38);
				icon:Point("TOPLEFT", 2, -2);

				icon.backdrop = CreateFrame("Frame", nil, reagent);
				icon.backdrop:SetFrameLevel(reagent:GetFrameLevel() - 1);
				icon.backdrop:SetTemplate();
				icon.backdrop:SetOutside(icon);

				icon:SetParent(icon.backdrop);
				count:SetParent(icon.backdrop);
				count:SetDrawLayer("OVERLAY");

				nameFrame:Kill();

				reagent.isSkinned = true;
			end

			if(reagentLink) then
				local quality = select(3, GetItemInfo(reagentLink));
				if(quality and quality > 1) then
					icon.backdrop:SetBackdropBorderColor(GetItemQualityColor(quality));
					 if(playerReagentCount < reagentCount) then
						name:SetTextColor(0.5, 0.5, 0.5);
					else
						name:SetTextColor(GetItemQualityColor(quality));
					end
				else
					icon.backdrop:SetBackdropBorderColor(unpack(E["media"].bordercolor));
 				end
			end
		end
	end)

	hooksecurefunc("TradeSkillFrame_Update", function()
		local skillOffset = FauxScrollFrame_GetOffset(TradeSkillListScrollFrame);
		local hasFilterBar = TradeSkillFilterBar:IsShown();
		local diplayedSkills = TRADE_SKILLS_DISPLAYED;
		if(hasFilterBar) then
			diplayedSkills = TRADE_SKILLS_DISPLAYED - 1;
		end
		local numTradeSkills = GetNumTradeSkills();
		local buttonIndex = 1;
		for i = 1, diplayedSkills, 1 do
			local skillIndex = i + skillOffset;
			local _, skillType, _, isExpanded = GetTradeSkillInfo(skillIndex);
			if(skillIndex <= numTradeSkills) then
				if(skillType == "header") then
					if(hasFilterBar) then
						buttonIndex = i + 1;
					else
						buttonIndex = i;
					end
					local skillButton = _G["TradeSkillSkill"..buttonIndex];
					skillButton:SetNormalTexture("Interface\\Buttons\\UI-PlusMinus-Buttons");
					skillButton:GetNormalTexture():Size(11);
					skillButton:GetNormalTexture():Point("LEFT", 3, 2);
					skillButton:SetHighlightTexture("");
					if(isExpanded) then
						skillButton:GetNormalTexture():SetTexCoord(0.5625, 1, 0, 0.4375);
					else
						skillButton:GetNormalTexture():SetTexCoord(0, 0.4375, 0, 0.4375);
					end
				end
			end
		end
	end)

	--Collapse All Button
	TradeSkillCollapseAllButton:HookScript("OnUpdate", function(self)
		self:SetNormalTexture("Interface\\Buttons\\UI-PlusMinus-Buttons");
		self:SetHighlightTexture("");
		self:GetNormalTexture():SetPoint("LEFT", 3, 2);
		self:GetNormalTexture():Size(11);
		if(self.collapsed) then
			self:GetNormalTexture():SetTexCoord(0, 0.4375, 0, 0.4375);
		else
			self:GetNormalTexture():SetTexCoord(0.5625, 1, 0, 0.4375);
		end
		self:SetDisabledTexture("Interface\\Buttons\\UI-PlusMinus-Buttons");
		self:GetDisabledTexture():Point("LEFT", 3, 2);
		self:GetDisabledTexture():Size(11);
		self:GetDisabledTexture():SetTexCoord(0, 0.4375, 0, 0.4375);
		self:GetDisabledTexture():SetDesaturated(true);
	end)

	--Guild Crafters
	TradeSkillGuildFrame:StripTextures();
	TradeSkillGuildFrame:SetTemplate("Transparent");
	TradeSkillGuildFrame:Point("BOTTOMLEFT", TradeSkillFrame, "BOTTOMRIGHT", 3, 19);

	TradeSkillGuildFrameContainer:StripTextures();
	TradeSkillGuildFrameContainer:SetTemplate("Default");

	S:HandleCloseButton(TradeSkillGuildFrameCloseButton);
end

S:AddCallbackForAddon("Blizzard_TradeSkillUI", "TradeSkill", LoadSkin);