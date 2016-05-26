-------------------------------------------------
--
-- ElvUI Microbar Enhancement by Darth Predator
-- Дартпредатор - Вечная Песня (Eversong) RU
--
-------------------------------------------------
--
-- Thanks to / Благодарности:
-- Elv and ElvUI community
-- Blazeflack for helping with option storage and profile changing
--
-------------------------------------------------
--
-- Usage / Использование:
-- Just install and configure for yourself
-- Устанавливаем, настраиваем и получаем профит
--
-------------------------------------------------

local E, L, V, P, G, _ =  unpack(ElvUI);
local AB = E:GetModule("ActionBars");
local EP = LibStub("LibElvUIPlugin-1.0")
local S = E:GetModule("Skins")
local addon = ...
local UB

P.actionbar.microbar.scale = 1
P.actionbar.microbar.symbolic = false
P.actionbar.microbar.backdrop = false
P.actionbar.microbar.colorS = {r = 1,g = 1,b = 1 }
P.actionbar.microbar.classColor = false

local MICRO_BUTTONS = {
	"CharacterMicroButton",
	"SpellbookMicroButton",
	"TalentMicroButton",
	"AchievementMicroButton",
	"QuestLogMicroButton",
	"SocialsMicroButton",
	"PVPMicroButton",
	"LFDMicroButton",
	"MainMenuMicroButton",
	"HelpMicroButton"
};

local Sbuttons = {}

function AB:GetOptions()
	E.Options.args.actionbar.args.microbar.args.scale = {
		order = 5,
		type = "range",
		name = L["Set Scale"],
		desc = L["Sets Scale of the Micro Bar"],
		isPercent = true,
		min = 0.3, max = 2, step = 0.01,
		get = function(info) return AB.db.microbar.scale end,
		set = function(info, value) AB.db.microbar.scale = value; AB:UpdateMicroPositionDimensions(); end
	};
	E.Options.args.actionbar.args.microbar.args.backdrop = {
		order = 6,
		type = "toggle",
		name = L["Backdrop"],
		disabled = function() return not AB.db.microbar.enabled end,
		get = function(info) return AB.db.microbar.backdrop end,
		set = function(info, value) AB.db.microbar.backdrop = value; AB:UpdateMicroPositionDimensions(); end
	};
	E.Options.args.actionbar.args.microbar.args.symbolic = {
		order = 7,
		type = "toggle",
		name = L["As Letters"],
		desc = L["Replace icons with just letters.\n|cffFF0000Warning:|r this will disable original Blizzard's tooltips for microbar."],
		disabled = function() return not AB.db.microbar.enabled end,
		get = function(info) return AB.db.microbar.symbolic end,
		set = function(info, value) AB.db.microbar.symbolic = value; AB:MenuShow(); end
	};
	E.Options.args.actionbar.args.microbar.args.color = {
		order = 8,
		type = "color",
		name = L["Text Color"],
		get = function(info)
			local t = AB.db.microbar.colorS;
			local d = P.actionbar.microbar.colorS;
			return t.r, t.g, t.b, d.r, d.g, d.b;
		end,
		set = function(info, r, g, b)
			local t = AB.db.microbar.colorS;
			t.r, t.g, t.b = r, g, b;
			AB:SetSymbloColor();
		end,
		disabled = function() return not AB.db.microbar.enabled or AB.db.microbar.classColor; end
	};
	E.Options.args.actionbar.args.microbar.args.classColor = {
		order = 9,
		type = "toggle",
		name = CLASS,
		disabled = function() return not AB.db.microbar.enabled; end,
		get = function(info) return AB.db.microbar.classColor; end,
		set = function(info, value) AB.db.microbar.classColor = value; AB:SetSymbloColor(); end
	};
end

function AB:MicroScale()
	ElvUI_MicroBar.mover:SetWidth(AB.MicroWidth*AB.db.microbar.scale);
	ElvUI_MicroBar.mover:SetHeight(AB.MicroHeight*AB.db.microbar.scale);
	ElvUI_MicroBar:SetScale(AB.db.microbar.scale);
	ElvUI_MicroBarS:SetScale(AB.db.microbar.scale);
end

E.UpdateAllMB = E.UpdateAll
function E:UpdateAll()
    E.UpdateAllMB(self);
	AB:MicroScale();
	AB:MenuShow();
end

local function Letter_OnEnter()
	if(AB.db.microbar.mouseover) then
		E:UIFrameFadeIn(ElvUI_MicroBarS, 0.2, ElvUI_MicroBarS:GetAlpha(), AB.db.microbar.alpha);
	end
end

local function Letter_OnLeave()
	if(AB.db.microbar.mouseover) then
		E:UIFrameFadeOut(ElvUI_MicroBarS, 0.2, ElvUI_MicroBarS:GetAlpha(), 0);
	end
end

function AB:CreateSymbolButton(name, text, tooltip, click)
	local button = CreateFrame("Button", name, ElvUI_MicroBarS);
	button:SetScript("OnClick", click);
	if(tooltip) then
		button:SetScript("OnEnter", function(self)
			Letter_OnEnter();
			GameTooltip:SetOwner(self);
			GameTooltip:AddLine(tooltip, 1, 1, 1, 1, 1, 1);
			GameTooltip:Show();
		end);
		button:SetScript("OnLeave", function(self)
			Letter_OnLeave();
			GameTooltip:Hide();
		end);
	else
		button:HookScript("OnEnter", Letter_OnEnter);
		button:HookScript("OnEnter", Letter_OnLeave);
	end

	S:HandleButton(button);

	if(text) then
		button.text = button:CreateFontString(nil,"OVERLAY",button);
		button.text:FontTemplate();
		button.text:SetPoint("CENTER", button, "CENTER", 0, -1);
		button.text:SetJustifyH("CENTER");
		button.text:SetText(text);
		button:SetFontString(button.text);
	end

	tinsert(Sbuttons, button);
end

function AB:SetSymbloColor()
	local color = AB.db.microbar.classColor and (E.myclass == "PRIEST" and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])) or AB.db.microbar.colorS;
	for i = 1, #Sbuttons do
		Sbuttons[i].text:SetTextColor(color.r, color.g, color.b);
	end
end

function AB:SetupSymbolBar()
	local frame = CreateFrame("Frame", "ElvUI_MicroBarS", E.UIParent);
	frame:SetPoint("CENTER", ElvUI_MicroBar, 0, 0);
	frame:EnableMouse(true);
	frame:SetScript("OnEnter", Letter_OnEnter);
	frame:SetScript("OnLeave", Letter_OnLeave);

	AB:CreateSymbolButton("EMB_Character", "C", CHARACTER_BUTTON, function() 
		if(CharacterFrame:IsShown()) then
			HideUIPanel(CharacterFrame);
		else
			ShowUIPanel(CharacterFrame);
		end
	end);
	AB:CreateSymbolButton("EMB_Spellbook", "S", SPELLBOOK_ABILITIES_BUTTON, function() 
		if(SpellBookFrame:IsShown()) then
			HideUIPanel(SpellBookFrame);
		else
			ShowUIPanel(SpellBookFrame);
		end
	end);
	AB:CreateSymbolButton("EMB_Talents", "T", TALENTS_BUTTON, function()
		if(UnitLevel("player") >= 10) then
			if(PlayerTalentFrame) then
				if(PlayerTalentFrame:IsShown()) then
					HideUIPanel(PlayerTalentFrame);
				else
					ShowUIPanel(PlayerTalentFrame);
				end
			else
				LoadAddOn("Blizzard_TalentUI");
				ShowUIPanel(PlayerTalentFrame);
			end
		end
	end)
	AB:CreateSymbolButton("EMB_Achievement", "A", ACHIEVEMENT_BUTTON, function() ToggleAchievementFrame(); end);
	AB:CreateSymbolButton("EMB_Quest", "Q", QUESTLOG_BUTTON, function()
		if(QuestLogFrame:IsShown()) then
			HideUIPanel(QuestLogFrame);
		else
			ShowUIPanel(QuestLogFrame);
		end
	end);
	AB:CreateSymbolButton("EMB_Socials", "F", SOCIAL_BUTTON, function() ToggleFriendsFrame(); end);
	AB:CreateSymbolButton("EMB_PVP", "L", PLAYER_V_PLAYER, function() TogglePVPFrame(); end)
	AB:CreateSymbolButton("EMB_LFD", "J", DUNGEONS_BUTTON, function() ToggleLFDParentFrame(); end);
	AB:CreateSymbolButton("EMB_MenuSys", "M", MAINMENU_BUTTON, function()
		if(GameMenuFrame:IsShown()) then
			HideUIPanel(GameMenuFrame);
		else
			ShowUIPanel(GameMenuFrame);
		end
	end);
	AB:CreateSymbolButton("EMB_Help", "?", HELP_BUTTON, function() ToggleHelpFrame(); end);

	AB:UpdateMicroPositionDimensions();
end

function AB:UpdateMicroPositionDimensions()
	if(not ElvUI_MicroBar) then return; end

	local numRows = 1;
	for i = 1, #MICRO_BUTTONS do
		local button = _G[MICRO_BUTTONS[i]];
		local prevButton = _G[MICRO_BUTTONS[i-1]] or ElvUI_MicroBar;
		local lastColumnButton = _G[MICRO_BUTTONS[i-self.db.microbar.buttonsPerRow]];

		button:ClearAllPoints();
		if(prevButton == ElvUI_MicroBar) then
			button:SetPoint("TOPLEFT", prevButton, "TOPLEFT", -2 + E.Border, 28 - E.Border);
		elseif((i - 1) % self.db.microbar.buttonsPerRow == 0) then
			button:Point("TOP", lastColumnButton, "BOTTOM", 0, 28 - self.db.microbar.yOffset);	
			numRows = numRows + 1;
		else
			button:Point("LEFT", prevButton, "RIGHT", - 4 + self.db.microbar.xOffset, 0);
		end
	end

	if(AB.db.microbar.mouseover) then
		ElvUI_MicroBar:SetAlpha(0);
	else
		ElvUI_MicroBar:SetAlpha(self.db.microbar.alpha);
	end

	AB.MicroWidth = ((CharacterMicroButton:GetWidth() - 4) * self.db.microbar.buttonsPerRow) + (self.db.microbar.xOffset * (self.db.microbar.buttonsPerRow-1)) + E.Border*2;
	AB.MicroHeight = ((CharacterMicroButton:GetHeight() - 28) * numRows) + (self.db.microbar.yOffset * (numRows-1)) + E.Border*2;

	ElvUI_MicroBar:SetWidth(AB.MicroWidth);
	ElvUI_MicroBar:SetHeight(AB.MicroHeight);

	if(not ElvUI_MicroBar.backdrop) then
		ElvUI_MicroBar:CreateBackdrop("Transparent");
	end

	if(self.db.microbar.enabled) then
		ElvUI_MicroBar:Show();
	else
		ElvUI_MicroBar:Hide();
	end

	if(not Sbuttons[1]) then return; end
	AB:MenuShow();
	local numRowsS = 1;
	for i=1, #MICRO_BUTTONS do
		local button = Sbuttons[i];
		local prevButton = Sbuttons[i-1] or ElvUI_MicroBarS;
		local lastColumnButton = Sbuttons[i-self.db.microbar.buttonsPerRow];
		button:Width(28 - 4)
		button:Height(58 - 28);

		button:ClearAllPoints();
		if(prevButton == ElvUI_MicroBarS) then
			button:SetPoint("TOPLEFT", prevButton, "TOPLEFT", E.Border, -E.Border);
		elseif((i - 1) % self.db.microbar.buttonsPerRow == 0) then
			button:Point("TOP", lastColumnButton, "BOTTOM", 0, -self.db.microbar.yOffset);	
			numRowsS = numRowsS + 1;
		else
			button:Point("LEFT", prevButton, "RIGHT", self.db.microbar.xOffset, 0);
		end

		prevButton = button;
	end

	ElvUI_MicroBarS:SetWidth(AB.MicroWidth);
	ElvUI_MicroBarS:SetHeight(AB.MicroHeight);

	if(not ElvUI_MicroBarS.backdrop) then
		ElvUI_MicroBarS:CreateBackdrop("Transparent");
	end

	if(AB.db.microbar.backdrop) then
		ElvUI_MicroBar.backdrop:Show();
		ElvUI_MicroBarS.backdrop:Show();
	else
		ElvUI_MicroBar.backdrop:Hide();
		ElvUI_MicroBarS.backdrop:Hide();
	end

	if(AB.db.microbar.mouseover) then
		ElvUI_MicroBarS:SetAlpha(0);
	elseif(not AB.db.microbar.mouseover and  AB.db.microbar.symbolic) then
		ElvUI_MicroBarS:SetAlpha(AB.db.microbar.alpha);
	end

	AB:MicroScale();
	AB:SetSymbloColor();
end

function AB:MenuShow()
	if AB.db.microbar.symbolic then
		if AB.db.microbar.enabled then
			ElvUI_MicroBar:Hide()
			ElvUI_MicroBarS:Show()
			if not AB.db.microbar.mouseover then
				E:UIFrameFadeIn(ElvUI_MicroBarS, 0.2, ElvUI_MicroBarS:GetAlpha(), AB.db.microbar.alpha)
			end
		else
			ElvUI_MicroBarS:Hide()
		end
	else
		if AB.db.microbar.enabled then
			ElvUI_MicroBar:Show()
		end
		ElvUI_MicroBarS:Hide()
	end
end

-- function AB:CreateUIButton()
	-- UB:CreateDropdownButton(true, "Addon", "Microbar", L["Micro Bar"], L["Micro Bar"], nil, function() E:ToggleConfig(); LibStub("AceConfigDialog-3.0"):SelectGroup("ElvUI", "actionbar", "microbar") end)
-- end

function AB:EnhancementInit()
	EP:RegisterPlugin(addon, AB.GetOptions);
	AB:SetupSymbolBar();
	AB:MicroScale();
	AB:MenuShow();

	-- if not IsAddOnLoaded("ElvUI_SLE") then return end
	-- UB = E:GetModule("SLE_UIButtons");
	-- hooksecurefunc(UB, "InsertButtons", AB.CreateUIButton)
end

hooksecurefunc(AB, "Initialize", AB.EnhancementInit)