local E, L, V, P, G = unpack(select(2, ...));
local RB = E:NewModule("ReminderBuffs", "AceEvent-3.0");
local LSM = LibStub("LibSharedMedia-3.0");

E.ReminderBuffs = RB;

RB.Spell1Buffs = {
	94160,	-- Flask of Flowing Water			(300 Spirit)
	79470,	-- Flask of the Draconic Mind		(300 Intellect)
	79471,	-- Flask of the Winds				(300 Agility)
	79472,	-- Flask of Titanic Strength		(300 Strength)
	79638,	-- Flask of Enhancement				(80 Strength)
	79639,	-- Flask of Enhancement				(80 Agility)
	79640,	-- Flask of Enhancement				(80 Intellect)
	92679,	-- Flask of Battle
	79469,	-- Flask of Steelskin				(450 Stamina)
	79481,	-- Elixir of Impossible Accuracy	(225 Hit)
	79632,	-- Elixir of Mighty Speed			(225 Haste)
	79477,	-- Elixir of the Cobra				(225 Critical)
	79635,	-- Elixir of the Master 			(225 Mastery)
	79474,	-- Elixir of the Naga				(225 Expertise)
	79468,	-- Ghost Elixir						(225 Spirit)
	79480,	-- Elixir of Deep Earth				(900 Armor)
	79631,	-- Prismatic Elixir					(90 Resistance)
	53752,	-- Lesser Flask of Toughness		(50 Resilience)
};

RB.Spell2Buffs = {
	87545,	-- 90 Strength
	87546,	-- 90 Agility
	87547,	-- 90 Intellect
	87548,	-- 90 Spirit
	87549,	-- 90 Mastery
	87550,	-- 90 Hit
	87551,	-- 90 Critical
	87552,	-- 90 Haste
	87554,	-- 90 Dodge
	87555,	-- 90 Parry
	87635,	-- 90 Expertise
	87556,	-- 60 Strength
	87557,	-- 60 Agility
	87558,	-- 60 Intellect
	87559,	-- 60 Spirit
	87560,	-- 60 Mastery
	87561,	-- 60 Hit
	87562,	-- 60 Critical
	87563,	-- 60 Haste
	87564,	-- 60 Dodge
	87634,	-- 60 Expertise
};

RB.Spell3Buffs = {
	1126,	-- Mark of the Wild
	90363,	-- Embrace of the Shale Spider
	20217,	-- Greater Blessing of Kings
};

RB.Spell4Buffs = {
	469,	-- Commanding Shout
	6307,	-- Blood Pact
	90364,	-- Qiraji Fortitude
	72590,	-- Drums of fortitude
	21562,	-- Fortitude
};

RB.CasterSpell5Buffs = {
	61316,	-- Dalaran Brilliance (6% SP)
	1459,	-- Arcane Brilliance (6% SP)
};

RB.MeleeSpell5Buffs = {
	6673,	-- Battle Shout
	57330,	-- Horn of Winter
	93435,	-- Roar of Courage
	8076,	-- Strength of Earth Totem
};

RB.CasterSpell6Buffs = {
	5677,	-- Mana Spring Totem
	54424,	-- Fel Intelligence
	19740,	-- Blessing of Might
};

RB.MeleeSpell6Buffs = {
	19740,	-- Blessing of Might
	30808,	-- Unleashed Rage
	53138,	-- Abomination Might
	19506,	-- Trusehot Aura
};

function RB:CheckFilterForActiveBuff(filter)
	local spellName, name, texture, duration, expirationTime;

	for _, spell in pairs(filter) do
		spellName = GetSpellInfo(spell);
		name, _, texture, _, _, duration, expirationTime = UnitAura("player", spellName);

		if(name) then
			return true, texture, duration, expirationTime;
		end
	end

	return false, texture, duration, expirationTime;
end

function RB:UpdateReminderTime(elapsed)
	self.expiration = self.expiration - elapsed;

	if(self.nextUpdate > 0) then
		self.nextUpdate = self.nextUpdate - elapsed;

		return;
	end

	if(self.expiration <= 0) then
		self.timer:SetText("");
		self:SetScript("OnUpdate", nil);

		return;
	end

	local timervalue, formatid;
	timervalue, formatid, self.nextUpdate = E:GetTimeInfo(self.expiration, 4);
	self.timer:SetFormattedText(("%s%s|r"):format(E.TimeColors[formatid], E.TimeFormats[formatid][1]), timervalue);
end

function RB:UpdateReminder(event, unit)
	if(event == "UNIT_AURA" and unit ~= "player") then return; end

	for i = 1, 6 do
		local hasBuff, texture, duration, expirationTime = self:CheckFilterForActiveBuff(self["Spell" .. i .. "Buffs"]);
		local button = self.frame[i];

		if(hasBuff) then
			button.t:SetTexture(texture);

			if(duration == 0 and expirationTime == 0) then
				button.t:SetAlpha(1);
				button:SetScript("OnUpdate", nil);
				button.timer:SetText(nil);
				CooldownFrame_SetTimer(button.cd, 0, 0, 0);
			else
				button.expiration = expirationTime - GetTime();
				button.nextUpdate = 0;
				button.t:SetAlpha(1)
				CooldownFrame_SetTimer(button.cd, expirationTime - duration, duration, 1);
				button:SetScript("OnUpdate", self.UpdateReminderTime);
			end
		else
			CooldownFrame_SetTimer(button.cd, 0, 0, 0);
			button.t:SetAlpha(0.3);
			button:SetScript("OnUpdate", nil);
			button.timer:SetText(nil);
			button.t:SetTexture(self.DefaultIcons[i]);
		end
	end
end

function RB:CreateButton()
	local button = CreateFrame("Button", nil, ElvUI_ReminderBuffs);
	button:SetTemplate("Default");

	button.t = button:CreateTexture(nil, "OVERLAY");
	button.t:SetTexCoord(unpack(E.TexCoords));
	button.t:SetInside();
	button.t:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");

	button.cd = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate");
	button.cd:SetInside();
	button.cd.noOCC = true;
	button.cd.noCooldownCount = true;
	button.cd:SetReverse(true);

	button.timer = button.cd:CreateFontString(nil, "OVERLAY");
	button.timer:SetPoint("CENTER");

	return button;
end

function RB:EnableRB()
	ElvUI_ReminderBuffs:Show();
	self:RegisterEvent("UNIT_AURA", "UpdateReminder");
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "UpdateReminder");
	self:RegisterEvent("PLAYER_TALENT_UPDATE", "UpdateReminder");
	self:RegisterEvent("CHARACTER_POINTS_CHANGED", "UpdateReminder");
	E.RegisterCallback(self, "RoleChanged", "UpdateSettings");
	self:UpdateReminder();
end

function RB:DisableRB()
	ElvUI_ReminderBuffs:Hide();
	self:UnregisterEvent("UNIT_AURA");
	self:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	self:UnregisterEvent("PLAYER_TALENT_UPDATE", "UpdateReminder");
	self:UnregisterEvent("CHARACTER_POINTS_CHANGED");
	E.UnregisterCallback(self, "RoleChanged", "UpdateSettings");
end

function RB:UpdateSettings(isCallback)
	local frame = self.frame;
	frame:Width(E.RBRWidth);

	self:UpdateDefaultIcons();

	for i = 1, 6 do
		local button = frame[i];
		button:ClearAllPoints();
		button:SetWidth(E.RBRWidth);
		button:SetHeight(E.RBRWidth);

		if(i == 1) then
			button:Point("TOP", ElvUI_ReminderBuffs, "TOP", 0, 0);
		else
			button:Point("TOP", frame[i - 1], "BOTTOM", 0, E.Border - E.Spacing*3);
		end

		if(i == 6) then
			button:Point("BOTTOM", ElvUI_ReminderBuffs, "BOTTOM", 0, 0);
		end

		if(E.db.general.reminder.durations) then
			button.cd:SetAlpha(1);
		else
			button.cd:SetAlpha(0);
		end

		button.cd:SetReverse(E.db.general.reminder.reverse);

		local font = LSM:Fetch("font", E.db.general.reminder.font);
		button.timer:FontTemplate(font, E.db.general.reminder.fontSize, E.db.general.reminder.fontOutline);
	end

	if(not isCallback) then
		if(E.db.general.reminder.enable and E.private.general.minimap.enable) then
			RB:EnableRB();
		else
			RB:DisableRB();
		end
	else
		self:UpdateReminder();
	end
end

function RB:UpdatePosition()
	Minimap:ClearAllPoints();
	ElvConfigToggle:ClearAllPoints();
	ElvUI_ReminderBuffs:ClearAllPoints();
	if(E.db.general.reminder.position == "LEFT") then
		Minimap:Point("TOPRIGHT", MMHolder, "TOPRIGHT", -E.Border, -E.Border);
		ElvConfigToggle:SetPoint("TOPRIGHT", LeftMiniPanel, "TOPLEFT", E.Border - E.Spacing*3, 0);
		ElvConfigToggle:SetPoint("BOTTOMRIGHT", LeftMiniPanel, "BOTTOMLEFT", E.Border - E.Spacing*3, 0);
		ElvUI_ReminderBuffs:SetPoint("TOPRIGHT", Minimap.backdrop, "TOPLEFT", E.Border - E.Spacing*3, 0);
		ElvUI_ReminderBuffs:SetPoint("BOTTOMRIGHT", Minimap.backdrop, "BOTTOMLEFT", E.Border - E.Spacing*3, 0);
	else
		Minimap:Point("TOPLEFT", MMHolder, "TOPLEFT", E.Border, -E.Border);
		ElvConfigToggle:SetPoint("TOPLEFT", RightMiniPanel, "TOPRIGHT", -E.Border + E.Spacing*3, 0);
		ElvConfigToggle:SetPoint("BOTTOMLEFT", RightMiniPanel, "BOTTOMRIGHT", -E.Border + E.Spacing*3, 0);
		ElvUI_ReminderBuffs:SetPoint("TOPLEFT", Minimap.backdrop, "TOPRIGHT", -E.Border + E.Spacing*3, 0);
		ElvUI_ReminderBuffs:SetPoint("BOTTOMLEFT", Minimap.backdrop, "BOTTOMRIGHT", -E.Border + E.Spacing*3, 0);
	end
end

function RB:UpdateDefaultIcons()
	self.DefaultIcons = {
		[1] = "Interface\\Icons\\INV_PotionE_4",
		[2] = "Interface\\Icons\\INV_Misc_Food_68",
		[3] = "Interface\\Icons\\Spell_Nature_Regeneration",
		[4] = "Interface\\Icons\\Spell_Holy_WordFortitude",
		[5] = (E.Role == "Caster" and "Interface\\Icons\\Spell_Holy_MagicalSentry") or "Interface\\Icons\\Ability_Warrior_BattleShout",
		[6] = "Interface\\Icons\\Spell_Holy_GreaterBlessingofKings"
	};

	if(E.Role == "Caster") then
		self.Spell5Buffs = self.CasterSpell5Buffs;
		self.Spell6Buffs = self.CasterSpell6Buffs;
	else
		self.Spell5Buffs = self.MeleeSpell5Buffs;
		self.Spell6Buffs = self.MeleeSpell6Buffs;
	end
end

function RB:Initialize()
	if(not E.private.general.minimap.enable) then return end

	self.db = E.db.general.reminder;

	local frame = CreateFrame("Frame", "ElvUI_ReminderBuffs", Minimap);
	frame:SetTemplate("Default");
	frame:Width(E.RBRWidth);
	if(E.db.general.reminder.position == "LEFT") then
		frame:Point("TOPRIGHT", Minimap.backdrop, "TOPLEFT", E.Border - E.Spacing*3, 0);
		frame:Point("BOTTOMRIGHT", Minimap.backdrop, "BOTTOMLEFT", E.Border - E.Spacing*3, 0);
	else
		frame:Point("TOPLEFT", Minimap.backdrop, "TOPRIGHT", -E.Border + E.Spacing*3, 0);
		frame:Point("BOTTOMLEFT", Minimap.backdrop, "BOTTOMRIGHT", -E.Border + E.Spacing*3, 0);
	end
	self.frame = frame;

	for i = 1, 6 do
		frame[i] = self:CreateButton();
		frame[i]:SetID(i);
	end

	self:UpdateSettings();
end

E:RegisterModule(RB:GetName());