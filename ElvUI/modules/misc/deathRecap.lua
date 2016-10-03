local E, L, V, P, G, _ = unpack(ElvUI);
local mod = E:NewModule("DeathRecap", "AceHook-3.0", "AceEvent-3.0");

local format, upper = string.format, string.upper;
local floor = math.floor;
local tsort, twipe = table.sort, table.wipe;
local band = bit.band;
local tonumber, strsub = tonumber, strsub;

local UnitHealth = UnitHealth;
local UnitHealthMax = UnitHealthMax;
local COMBATLOG_FILTER_ME = COMBATLOG_FILTER_ME;
local GetReleaseTimeRemaining = GetReleaseTimeRemaining;
local RepopMe = RepopMe;
local IsShiftKeyDown = IsShiftKeyDown;

local lastDeathEvents;
local index = 0;
local deathList = {};
local eventList = {};

function mod:AddEvent(timestamp, event, sourceName, spellId, spellName, environmentalType, amount, overkill, school, resisted, blocked, absorbed)
	if((index > 0) and (eventList[index].timestamp + 10 <= timestamp)) then
		index = 0;
		twipe(eventList);
	end

	if(index < 5) then
		index = index + 1;
	elseif(index == 5) then
		index = 1;
	end

	if(not eventList[index]) then
		eventList[index] = {};
	else
		twipe(eventList[index]);
	end

	eventList[index].timestamp = timestamp;
	eventList[index].event = event;
	eventList[index].sourceName = sourceName;
	eventList[index].spellId = spellId;
	eventList[index].spellName = spellName;
	eventList[index].environmentalType = environmentalType;
	eventList[index].amount = amount;
	eventList[index].overkill = overkill;
	eventList[index].school = school;
	eventList[index].resisted = resisted;
	eventList[index].blocked = blocked;
	eventList[index].absorbed = absorbed;
	eventList[index].currentHP = UnitHealth("player");
	eventList[index].maxHP = UnitHealthMax("player");
end

function mod:EraseEvents()
	if(index > 0) then
		index = 0;
		twipe(eventList);
	end
end

function mod:AddDeath()
	if #eventList > 0 then
		local _, deathEvents = self:HasEvents();
		local deathIndex = deathEvents + 1;
		deathList[deathIndex] = CopyTable(eventList);
		self:EraseEvents();

		DEFAULT_CHAT_FRAME:AddMessage("|cff71d5ff|Hdeath:" .. deathIndex .. "|h[" .. L["You died."] .. "]|h|r");

		return true;
	end
end

function mod:GetDeathEvents(recapID)
	if(recapID and deathList[recapID]) then
		local deathEvents = deathList[recapID];
		tsort(deathEvents, function(a, b) return a.timestamp > b.timestamp end);
		return deathEvents;
	end
end

function mod:HasEvents()
	if lastDeathEvents then
		return #deathList > 0, #deathList;
	else
		return false, #deathList;
	end
end

function mod:PLAYER_DEAD()
	if(StaticPopup_FindVisible("DEATH")) then
		if(self:AddDeath()) then
			lastDeathEvents = true
		else
			lastDeathEvents = false
		end

		StaticPopup_Hide("DEATH");

		E:StaticPopup_Show("DEATH", GetReleaseTimeRemaining(), SECONDS);
	end
end

function mod:HidePopup()
	E:StaticPopup_Hide("DEATH");
end

function mod:OpenRecap(recapID)
	local self = DeathRecapFrame;

	if(self:IsShown() and self.recapID == recapID) then
		HideUIPanel(self);
		return;
	end

	local deathEvents = mod:GetDeathEvents(recapID);
	if(not deathEvents) then return; end

	self.recapID = recapID;
	ShowUIPanel(self);

	if(not deathEvents or #deathEvents <= 0) then
		for i = 1, 5 do
			self.DeathRecapEntry[i]:Hide();
		end
		self.Unavailable:Show();
		return;
	end
	self.Unavailable:Hide();

	local highestDmgIdx, highestDmgAmount = 1, 0;
	self.DeathTimeStamp = nil;

	for i = 1, #deathEvents do
		local entry = self.DeathRecapEntry[i];
		local dmgInfo = entry.DamageInfo;
		local evtData = deathEvents[i];
		local spellId, spellName, texture = mod:GetTableInfo(evtData);

		entry:Show();
		self.DeathTimeStamp = self.DeathTimeStamp or evtData.timestamp;

		if(evtData.amount) then
			local amountStr = -(evtData.amount);
			dmgInfo.Amount:SetText(amountStr);
			dmgInfo.AmountLarge:SetText(amountStr);
			dmgInfo.amount = evtData.amount;

			dmgInfo.dmgExtraStr = "";
			if(evtData.overkill and evtData.overkill > 0) then
				dmgInfo.dmgExtraStr = format(L["(%d Overkill)"], evtData.overkill);
				dmgInfo.amount = evtData.amount - evtData.overkill;
			end
			if(evtData.absorbed and evtData.absorbed > 0) then
				dmgInfo.dmgExtraStr = dmgInfo.dmgExtraStr .. " " .. format(L["(%d Absorbed)"], evtData.absorbed);
				dmgInfo.amount = evtData.amount - evtData.absorbed;
			end
			if(evtData.resisted and evtData.resisted > 0) then
				dmgInfo.dmgExtraStr = dmgInfo.dmgExtraStr .. " " .. format(L["(%d Resisted)"], evtData.resisted);
				dmgInfo.amount = evtData.amount - evtData.resisted;
			end
			if(evtData.blocked and evtData.blocked > 0) then
				dmgInfo.dmgExtraStr = dmgInfo.dmgExtraStr .. " " .. format(L["(%d Blocked)"], evtData.blocked);
				dmgInfo.amount = evtData.amount - evtData.blocked;
			end

			if(evtData.amount > highestDmgAmount) then
				highestDmgIdx = i;
				highestDmgAmount = evtData.amount;
			end

			dmgInfo.Amount:Show();
			dmgInfo.AmountLarge:Hide();
		else
			dmgInfo.Amount:SetText("");
			dmgInfo.AmountLarge:SetText("");
			dmgInfo.amount = nil;
			dmgInfo.dmgExtraStr = nil;
		end

		dmgInfo.timestamp = evtData.timestamp;
		dmgInfo.hpPercent = floor(evtData.currentHP / evtData.maxHP * 100);

		dmgInfo.spellName = spellName;

		dmgInfo.caster = evtData.sourceName or COMBATLOG_UNKNOWN_UNIT;

		if(evtData.school and evtData.school > 1) then
			local colorArray = CombatLog_Color_ColorArrayBySchool(evtData.school);
			entry.SpellInfo.FrameIcom:SetBackdropBorderColor(colorArray.r, colorArray.g, colorArray.b);
		else
			entry.SpellInfo.FrameIcom:SetBackdropBorderColor(unpack(E.media.bordercolor));
		end

		dmgInfo.school = evtData.school;

		entry.SpellInfo.Caster:SetText(dmgInfo.caster);

		entry.SpellInfo.Name:SetText(spellName);
		entry.SpellInfo.Icon:SetTexture(texture);

		entry.SpellInfo.spellId = spellId;
	end

	for i = #deathEvents + 1, #(self.DeathRecapEntry) do
		self.DeathRecapEntry[i]:Hide();
	end

	local entry = self.DeathRecapEntry[highestDmgIdx];
	if(entry.DamageInfo.amount) then
		entry.DamageInfo.Amount:Hide();
		entry.DamageInfo.AmountLarge:Show();
	end

	local deathEntry = self.DeathRecapEntry[1];
	local tombstoneIcon = deathEntry.tombstone;
	if(entry == deathEntry) then
		tombstoneIcon:Point("RIGHT", deathEntry.DamageInfo.AmountLarge, "LEFT", -10, 0);
	end
end

function mod:Spell_OnEnter()
	if(self.spellId) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:SetHyperlink(GetSpellLink(self.spellId));
		GameTooltip:Show();
	end
end

function mod:Amount_OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_LEFT");
	GameTooltip:ClearLines();
	if(self.amount) then
		local valueStr = self.school and format(TEXT_MODE_A_STRING_VALUE_SCHOOL, self.amount, CombatLog_String_SchoolString(self.school)) or self.amount;
		GameTooltip:AddLine(format(L["%s %s"], valueStr, self.dmgExtraStr), 1, 0, 0, false);
	end

	if(self.spellName) then
		if(self.caster) then
			GameTooltip:AddLine(format(L["%s by %s"], self.spellName, self.caster), 1, 1, 1, true);
		else
			GameTooltip:AddLine(self.spellName, 1, 1, 1, true);
		end
	end

	local seconds = DeathRecapFrame.DeathTimeStamp - self.timestamp;
	if(seconds > 0) then
		GameTooltip:AddLine(format(L["%s sec before death at %s%% health."], format("%.1F", seconds), self.hpPercent), 1, 0.824, 0, true);
	else
		GameTooltip:AddLine(format(L["Killing blow at %s%% health."], self.hpPercent), 1, 0.824, 0, true);
	end

	GameTooltip:Show();
end

function mod:GetTableInfo(data)
	local texture;
	local nameIsNotSpell = false;

	local event = data.event;
	local spellId = data.spellId;
	local spellName = data.spellName;

	if(event == "SWING_DAMAGE") then
		spellId = 6603;
		spellName = ACTION_SWING;

		nameIsNotSpell = true;
	elseif(event == "RANGE_DAMAGE") then
		nameIsNotSpell = true;
--	elseif(strsub(event, 1, 5) == "SPELL") then
	elseif(event == "ENVIRONMENTAL_DAMAGE") then
		local environmentalType = data.environmentalType;
		environmentalType = upper(environmentalType);
		spellName = _G["ACTION_ENVIRONMENTAL_DAMAGE_" .. environmentalType];
		nameIsNotSpell = true;
		if(environmentalType == "DROWNING") then
			texture = "spell_shadow_demonbreath";
		elseif(environmentalType == "FALLING") then
			texture = "ability_rogue_quickrecovery";
		elseif(environmentalType == "FIRE" or environmentalType == "LAVA") then
			texture = "spell_fire_fire";
		elseif(environmentalType == "SLIME") then
			texture = "inv_misc_slime_01";
		elseif(environmentalType == "FATIGUE") then
			texture = "ability_creature_cursed_05";
		else
			texture = "ability_creature_cursed_05";
		end
		texture = "Interface\\Icons\\" .. texture;
	end

	local spellNameStr = spellName;
	local spellString;
	if(spellName) then
		if(nameIsNotSpell) then
			spellString = format("|Haction:%s|h%s|h", event, spellNameStr);
		else
			spellString = spellName;
		end
	end

	if(spellId and not texture) then
		texture = select(3, GetSpellInfo(spellId));
	end
	return spellId, spellString, texture;
end

function mod:COMBAT_LOG_EVENT_UNFILTERED(_, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
	if((band(destFlags, COMBATLOG_FILTER_ME) ~= COMBATLOG_FILTER_ME) or (band(sourceFlags, COMBATLOG_FILTER_ME) == COMBATLOG_FILTER_ME)) then return; end
	if ((event ~= "ENVIRONMENTAL_DAMAGE")
	and (event ~= "RANGE_DAMAGE")
	and (event ~= "SPELL_DAMAGE")
	and (event ~= "SPELL_EXTRA_ATTACKS")
	and (event ~= "SPELL_INSTAKILL")
	and (event ~= "SPELL_PERIODIC_DAMAGE")
	and (event ~= "SWING_DAMAGE"))
	then return end

	local environmentalType, amount, overkill, school, critical, glancing, crushing;
	local spellId, spellName;
	local subVal = strsub(event, 1, 5);

	if(event == "SWING_DAMAGE") then
		amount, overkill, school, resisted, blocked, absorbed = ...;
	elseif(subVal == "SPELL") then
		spellId, spellName, _, amount, overkill, school, resisted, blocked, absorbed = ...;
	elseif(event == "ENVIRONMENTAL_DAMAGE") then
		environmentalType, amount, overkill, school, resisted, blocked, absorbed = ...;
	end

	if(not tonumber(amount)) then return; end

	self:AddEvent(timestamp, event, sourceName, spellId, spellName, environmentalType, amount, overkill, school, resisted, blocked, absorbed);
end

function mod:SetItemRef(link, ...)
	if(strsub(link, 1, 5) == "death") then
		local _, id = strsplit(":", link);
		mod:OpenRecap(tonumber(id));
		return;
	else
		self.hooks.SetItemRef(link, ...)
	end
end

function mod:Initialize()
	local S = E:GetModule("Skins");

	local frame = CreateFrame("Frame", "DeathRecapFrame", UIParent);
	frame:Size(340, 326);
	frame:Point("CENTER");
	frame:SetTemplate("Transparent");
	frame:Hide();
	tinsert(UISpecialFrames, frame:GetName());

	frame.Title = frame:CreateFontString("ARTWORK", nil, "GameFontNormal");
	frame.Title:Point("TOPLEFT", 12, -9);
	frame.Title:SetText(L["Death Recap"]);

	frame.Unavailable = frame:CreateFontString("ARTWORK", nil, "GameFontNormal");
	frame.Unavailable:Point("CENTER");
	frame.Unavailable:SetText(L["Death Recap unavailable."]);

	frame.CloseXButton = CreateFrame("Button", "$parentCloseXButton", frame);
	frame.CloseXButton:Size(32, 32);
	frame.CloseXButton:Point("TOPRIGHT", 2, 1);
	frame.CloseXButton:SetScript("OnClick", function(self) HideUIPanel(self:GetParent()); end);
	S:HandleCloseButton(frame.CloseXButton);

	frame:SetClampedToScreen(true);
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:RegisterForDrag("LeftButton");

	frame:SetScript("OnDragStart", function(self)
		if IsShiftKeyDown() then
			self:StartMoving();
		end
	end)

	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing();
	end)

	frame:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4);
		GameTooltip:ClearLines();
		GameTooltip:AddDoubleLine(L["Hold Shift + Drag:"], L["Temporary Move"], 1, 1, 1);

		GameTooltip:Show();
	end);
	frame:SetScript("OnLeave", function(self) GameTooltip:Hide(); end);

	frame.DeathRecapEntry = {};

	frame:SetScript("OnShow", function()
		PlaySound("igMainMenuOption");
	end);

	frame:SetScript("OnHide", function()
		PlaySound("igMainMenuOptionCheckBoxOn");
	end);

	for i = 1, 5 do
		local button = CreateFrame("Frame", nil, frame);
		button:Size(308, 32);
		button:CreateBackdrop("Transparent");

		frame.DeathRecapEntry[i] = button;

		button.DamageInfo = CreateFrame("Button", nil, button);
		button.DamageInfo:Point("TOPLEFT", 0, 0);
		button.DamageInfo:Point("BOTTOMRIGHT", button, "BOTTOMLEFT", 80, 0);
		button.DamageInfo:SetScript("OnEnter", self.Amount_OnEnter);
		button.DamageInfo:SetScript("OnLeave", GameTooltip_Hide);

		button.DamageInfo.Amount = button.DamageInfo:CreateFontString("ARTWORK", nil, "GameFontNormalRight");
		button.DamageInfo.Amount:SetJustifyH("RIGHT");
		button.DamageInfo.Amount:SetJustifyV("CENTER");
		button.DamageInfo.Amount:Size(0, 32);
		button.DamageInfo.Amount:Point("TOPRIGHT", 0, 0);
		button.DamageInfo.Amount:SetTextColor(0.75, 0.05, 0.05, 1);

		button.DamageInfo.AmountLarge = button.DamageInfo:CreateFontString("ARTWORK", nil, "NumberFont_Outline_Large");
		button.DamageInfo.AmountLarge:SetJustifyH("RIGHT");
		button.DamageInfo.AmountLarge:SetJustifyV("CENTER");
		button.DamageInfo.AmountLarge:Size(0, 32);
		button.DamageInfo.AmountLarge:Point("TOPRIGHT", 0, 0);
		button.DamageInfo.AmountLarge:SetTextColor(1, 0.07, 0.07, 1);

		button.SpellInfo = CreateFrame("Button", nil, button);
		button.SpellInfo:Point("TOPLEFT", button.DamageInfo, "TOPRIGHT", 16, 0);
		button.SpellInfo:Point("BOTTOMRIGHT", 0, 0);
		button.SpellInfo:SetScript("OnEnter", self.Spell_OnEnter);
		button.SpellInfo:SetScript("OnLeave", GameTooltip_Hide);

		button.SpellInfo.FrameIcom = CreateFrame("Button", nil, button.SpellInfo);
		button.SpellInfo.FrameIcom:Size(34, 34);
		button.SpellInfo.FrameIcom:Point("LEFT", 0, 0);
		button.SpellInfo.FrameIcom:SetTemplate("Default");

		button.SpellInfo.Icon = button.SpellInfo:CreateTexture("ARTWORK");
		button.SpellInfo.Icon:SetParent(button.SpellInfo.FrameIcom);
		button.SpellInfo.Icon:SetTexCoord(unpack(E.TexCoords));
		button.SpellInfo.Icon:SetInside();

		button.SpellInfo.Name = button.SpellInfo:CreateFontString("ARTWORK", nil, "GameFontNormal");
		button.SpellInfo.Name:SetJustifyH("LEFT");
		button.SpellInfo.Name:SetJustifyV("BOTTOM");
		button.SpellInfo.Name:Point("BOTTOMLEFT", button.SpellInfo.Icon, "RIGHT", 8, 1);
		button.SpellInfo.Name:Point("TOPRIGHT", 0, 0);

		button.SpellInfo.Caster = button.SpellInfo:CreateFontString("ARTWORK", nil, "SystemFont_Shadow_Small");
		button.SpellInfo.Caster:SetJustifyH("LEFT");
		button.SpellInfo.Caster:SetJustifyV("TOP");
		button.SpellInfo.Caster:Point("TOPLEFT", button.SpellInfo.Icon, "RIGHT", 8, -2);
		button.SpellInfo.Caster:Point("BOTTOMRIGHT", 0, 0);
		button.SpellInfo.Caster:SetTextColor(0.5, 0.5, 0.5, 1);

		if(i == 1) then
			button:SetPoint("BOTTOMLEFT", 16, 64);
			button.tombstone = button:CreateTexture("ARTWORK");
			button.tombstone:Size(15, 20);
			button.tombstone:Point("RIGHT", button.DamageInfo.Amount, "LEFT", -10, 0);
			button.tombstone:SetTexCoord(0.658203125, 0.6875, 0.00390625, 0.08203125);
			button.tombstone:SetTexture("Interface\\AddOns\\ElvUI\\media\\textures\\DeathRecap");
		else
			button:Point("BOTTOM", frame.DeathRecapEntry[i - 1], "TOP", 0, 14);
		end
	end

	frame.CloseButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate");
	frame.CloseButton:Size(144, 21);
	frame.CloseButton:Point("BOTTOM", 0, 15);
	frame.CloseButton:SetText(CLOSE);
	frame.CloseButton:SetScript("OnClick", function(self) HideUIPanel(DeathRecapFrame); end);
	S:HandleButton(frame.CloseButton);

	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	self:RegisterEvent("PLAYER_DEAD");
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "HidePopup");
	self:RegisterEvent("RESURRECT_REQUEST", "HidePopup");
	self:RegisterEvent("PLAYER_ALIVE", "HidePopup");
	self:RegisterEvent("RAISED_AS_GHOUL", "HidePopup");

	self:RawHook("SetItemRef", true);

	E.PopupDialogs["DEATH"] = {
		text = DEATH_RELEASE_TIMER,
		button1 = DEATH_RELEASE,
		button2 = USE_SOULSTONE,
		button3 = L["Death Recap"],
		OnShow = function(self)
			self.timeleft = GetReleaseTimeRemaining();
			local text = HasSoulstone();
			if(text) then
				self.button2:SetText(text);
			end

			if(IsActiveBattlefieldArena()) then
				self.text:SetText(DEATH_RELEASE_SPECTATOR);
			elseif(self.timeleft == -1) then
				self.text:SetText(DEATH_RELEASE_NOTIMER);
			end
			if(mod:HasEvents()) then
				self.button3:Enable();
				self.button3:SetScript("OnEnter", nil);
				self.button3:SetScript("OnLeave", nil);
			else
				self.button3:Disable();
				self.button3:SetScript("OnEnter", function(self)
					GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
					GameTooltip:SetText(L["Death Recap unavailable."]);
					GameTooltip:Show();
				end);
				self.button3:SetScript("OnLeave", GameTooltip_Hide);
			end
		end,
		OnHide = function(self)
			self.button3:SetScript("OnEnter", nil);
			self.button3:SetScript("OnLeave", nil);
			HideUIPanel(DeathRecapFrame);
		end,
		OnAccept = function(self)
			if(IsActiveBattlefieldArena()) then
				local info = ChatTypeInfo["SYSTEM"];
				DEFAULT_CHAT_FRAME:AddMessage(ARENA_SPECTATOR, info.r, info.g, info.b, info.id);
			end
			RepopMe();
			if(CannotBeResurrected()) then
				return 1
			end
		end,
		OnCancel = function(self, data, reason)
			if(reason == "override") then
				StaticPopup_Show("RECOVER_CORPSE");
				return;
			end
			if(reason == "timeout") then
				return;
			end
			if(reason == "clicked") then
				if(HasSoulstone()) then
					UseSoulstone();
				else
					RepopMe();
				end
				if(CannotBeResurrected()) then
					return 1;
				end
			end
		end,
		OnAlt = function()
			local _, recapID = self:HasEvents();
			mod:OpenRecap(recapID);
		end,
		OnUpdate = function(self, elapsed)
			if(self.timeleft > 0) then
				local text = _G[self:GetName() .. "Text"];
				local timeleft = self.timeleft;

				if(timeleft < 60) then
					text:SetFormattedText(DEATH_RELEASE_TIMER, timeleft, SECONDS);
				else
					text:SetFormattedText(DEATH_RELEASE_TIMER, ceil(timeleft / 60), MINUTES);
				end
			end

			if(IsFalling() and not IsOutOfBounds()) then
				self.button1:Disable();
				self.button2:Disable();
				return;
			else
				self.button1:Enable();
			end
			if(HasSoulstone()) then
				self.button2:Enable();
			else
				self.button2:Disable();
			end
		end,
		DisplayButton2 = function(self)
			return HasSoulstone();
		end,

		timeout = 0,
		whileDead = 1,
		interruptCinematic = 1,
		noCancelOnReuse = 1,
		hideOnEscape = false,
		noCloseOnAlt = true
	};
end

E:RegisterModule(mod:GetName());