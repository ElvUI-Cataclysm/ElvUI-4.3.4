local E, L, V, P, G = unpack(select(2, ...));
local A = E:NewModule("Auras", "AceEvent-3.0");
local LSM = LibStub("LibSharedMedia-3.0");

local GetTime = GetTime;
local _G = _G;
local select, unpack, pairs, ipairs = select, unpack, pairs, ipairs;
local floor, min, max, huge = math.floor, math.min, math.max, math.huge;
local format = string.format;
local wipe, tinsert, tremove, tsort = table.wipe, table.insert, table.remove, table.sort;

local CreateFrame = CreateFrame;
local UnitAura = UnitAura;
local CancelUnitBuff = CancelUnitBuff;

local Masque = LibStub("Masque", true)
local MasqueGroupBuffs = Masque and Masque:Group("ElvUI", "Buffs")
local MasqueGroupDebuffs = Masque and Masque:Group("ElvUI", "Debuffs")

local DIRECTION_TO_POINT = {
	DOWN_RIGHT = "TOPLEFT",
	DOWN_LEFT = "TOPRIGHT",
	UP_RIGHT = "BOTTOMLEFT",
	UP_LEFT = "BOTTOMRIGHT",
	RIGHT_DOWN = "TOPLEFT",
	RIGHT_UP = "BOTTOMLEFT",
	LEFT_DOWN = "TOPRIGHT",
	LEFT_UP = "BOTTOMRIGHT"
};

local DIRECTION_TO_HORIZONTAL_SPACING_MULTIPLIER = {
	DOWN_RIGHT = 1,
	DOWN_LEFT = -1,
	UP_RIGHT = 1,
	UP_LEFT = -1,
	RIGHT_DOWN = 1,
	RIGHT_UP = 1,
	LEFT_DOWN = -1,
	LEFT_UP = -1
};

local DIRECTION_TO_VERTICAL_SPACING_MULTIPLIER = {
	DOWN_RIGHT = -1,
	DOWN_LEFT = -1,
	UP_RIGHT = 1,
	UP_LEFT = 1,
	RIGHT_DOWN = -1,
	RIGHT_UP = 1,
	LEFT_DOWN = -1,
	LEFT_UP = 1
};

local IS_HORIZONTAL_GROWTH = {
	RIGHT_DOWN = true,
	RIGHT_UP = true,
	LEFT_DOWN = true,
	LEFT_UP = true
};

function A:UpdateTime(elapsed)
	self.timeLeft = self.timeLeft - elapsed;

	if(self.nextUpdate > 0) then
		self.nextUpdate = self.nextUpdate - elapsed;
		return;
	end

	local timerValue, formatID;
	timerValue, formatID, self.nextUpdate = E:GetTimeInfo(self.timeLeft, A.db.fadeThreshold);
	self.time:SetFormattedText(("%s%s|r"):format(E.TimeColors[formatID], E.TimeFormats[formatID][1]), timerValue);

	if(self.timeLeft > E.db.auras.fadeThreshold) then
		E:StopFlash(self);
	else
		E:Flash(self, 1);
	end
end

local UpdateTooltip = function(self)
	GameTooltip:SetUnitAura("player", self:GetID(), self:GetParent().filter);
end

local OnEnter = function(self)
	if(not self:IsVisible()) then return end

	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT", -5, -5);
	self:UpdateTooltip();
end

local OnLeave = function()
	GameTooltip:Hide();
end

local OnClick = function(self)
	CancelUnitBuff("player", self:GetID(), self:GetParent().filter);
end

function A:CreateIcon(button)
	local font = LSM:Fetch("font", self.db.font);
	button:RegisterForClicks("RightButtonUp");

	-- button:SetFrameLevel(4)
	button.texture = button:CreateTexture(nil, "BORDER");
	button.texture:SetInside();
	button.texture:SetTexCoord(unpack(E.TexCoords));

	button.count = button:CreateFontString(nil, "ARTWORK");
	button.count:SetPoint("BOTTOMRIGHT", -1 + self.db.countXOffset, 1 + self.db.countYOffset);
	button.count:FontTemplate(font, self.db.fontSize, self.db.fontOutline);

	button.time = button:CreateFontString(nil, "ARTWORK");
	button.time:SetPoint("TOP", button, "BOTTOM", 1 + self.db.timeXOffset, 0 + self.db.timeYOffset);
	button.time:FontTemplate(font, self.db.fontSize, self.db.fontOutline);

	button.highlight = button:CreateTexture(nil, "HIGHLIGHT");
	button.highlight:SetTexture(1, 1, 1, 0.45);
	button.highlight:SetInside();

	E:SetUpAnimGroup(button);

	button.UpdateTooltip = UpdateTooltip;
	button:SetScript("OnEnter", OnEnter);
	button:SetScript("OnLeave", OnLeave);
	button:SetScript("OnClick", OnClick);

	local ButtonData = {
		FloatingBG = nil,
		Icon = button.texture,
		Cooldown = nil,
		Flash = nil,
		Pushed = nil,
		Normal = nil,
		Disabled = nil,
		Checked = nil,
		Border = nil,
		AutoCastable = nil,
		Highlight = button.highlight,
		HotKey = nil,
		Count = false,
		Name = nil,
		Duration = false,
		AutoCast = nil,
	}

	local header = button:GetParent()
	local auraType = header.filter

	if auraType == "HELPFUL" then
		if MasqueGroupBuffs and E.private.auras.masque.buffs then
			MasqueGroupBuffs:AddButton(button, ButtonData)
			if button.__MSQ_BaseFrame then
				button.__MSQ_BaseFrame:SetFrameLevel(2)
			end
			MasqueGroupBuffs:ReSkin()
		else
			button:SetTemplate("Default")
		end
	elseif auraType == "HARMFUL" then
		if MasqueGroupDebuffs and E.private.auras.masque.debuffs then
			MasqueGroupDebuffs:AddButton(button, ButtonData)
			if button.__MSQ_BaseFrame then
				button.__MSQ_BaseFrame:SetFrameLevel(2)
			end
			MasqueGroupDebuffs:ReSkin()
		else
			button:SetTemplate("Default")
		end
	end
end

local buttons = {};
function A:ConfigureAuras(header, auraTable)
	local headerName = header:GetName()

	local db = self.db.debuffs;
	if(header.filter == "HELPFUL") then
		db = self.db.buffs;
	end

	local size = db.size;
	local point = DIRECTION_TO_POINT[db.growthDirection];
	local xOffset = 0;
	local yOffset = 0;
	local wrapXOffset = 0;
	local wrapYOffset = 0;
	local wrapAfter = db.wrapAfter;
	local maxWraps = db.maxWraps;
	local minWidth = 0;
	local minHeight = 0;

	if(IS_HORIZONTAL_GROWTH[db.growthDirection]) then
		minWidth = ((wrapAfter == 1 and 0 or db.horizontalSpacing) + size) * wrapAfter;
		minHeight = (db.verticalSpacing + size) * maxWraps;
		xOffset = DIRECTION_TO_HORIZONTAL_SPACING_MULTIPLIER[db.growthDirection] * (db.horizontalSpacing + size);
		yOffset = 0;
		wrapXOffset = 0;
		wrapYOffset = DIRECTION_TO_VERTICAL_SPACING_MULTIPLIER[db.growthDirection] * (db.verticalSpacing + size);
	else
		minWidth = (db.horizontalSpacing + size) * maxWraps;
		minHeight = ((wrapAfter == 1 and 0 or db.verticalSpacing) + size) * wrapAfter;
		xOffset = 0;
		yOffset = DIRECTION_TO_VERTICAL_SPACING_MULTIPLIER[db.growthDirection] * (db.verticalSpacing + size);
		wrapXOffset = DIRECTION_TO_HORIZONTAL_SPACING_MULTIPLIER[db.growthDirection] * (db.horizontalSpacing + size);
		wrapYOffset = 0;
	end

	wipe(buttons);
	for i = 1, #auraTable do
		local button = _G[headerName.."AuraButton"..i]
		if(button) then
			if(button:IsShown()) then button:Hide(); end
		else
			button = CreateFrame("Button", "$parentAuraButton" .. i, header);
			self:CreateIcon(button);
		end
		local buffInfo = auraTable[i];
		button:SetID(buffInfo.index);

		if(buffInfo.duration > 0 and buffInfo.expires) then
			local timeLeft = buffInfo.expires - GetTime();
			if(not button.timeLeft) then
				button.timeLeft = timeLeft;
				button:SetScript("OnUpdate", self.UpdateTime);
			else
				button.timeLeft = timeLeft;
			end

			button.nextUpdate = -1;
			self.UpdateTime(button, 0);
		else
			button.timeLeft = nil;
			button.time:SetText("");
			button:SetScript("OnUpdate", nil);
		end

		if(buffInfo.count > 1) then
			button.count:SetText(buffInfo.count);
		else
			button.count:SetText("");
		end

		if(buffInfo.filter == "HARMFUL") then
			local color = DebuffTypeColor[buffInfo.dispelType or ""];
			button:SetBackdropBorderColor(color.r, color.g, color.b);
		else
			button:SetBackdropBorderColor(unpack(E.media.bordercolor));
		end

		button.texture:SetTexture(buffInfo.icon);

		buttons[i] = button;
	end

	local display = #buttons;
	if(wrapAfter and maxWraps) then
		display = min(display, wrapAfter * maxWraps);
	end

	local left, right, top, bottom = huge, -huge, -huge, huge;
	for index = 1, display do
		local button = buttons[index];
		local wrapAfter = wrapAfter or index;
		local tick, cycle = floor((index - 1) % wrapAfter), floor((index - 1) / wrapAfter);
		button:ClearAllPoints();
		button:SetPoint(point, header, cycle * wrapXOffset + tick * xOffset, cycle * wrapYOffset + tick * yOffset);

		button:SetSize(size, size);

		if(button.time) then
			local font = LSM:Fetch("font", self.db.font);
			button.time:ClearAllPoints();
			button.time:SetPoint("TOP", button, "BOTTOM", 1 + self.db.timeXOffset, 0 + self.db.timeYOffset);
			button.time:FontTemplate(font, self.db.fontSize, self.db.fontOutline);

			button.count:ClearAllPoints();
			button.count:SetPoint("BOTTOMRIGHT", -1 + self.db.countXOffset, 0 + self.db.countYOffset);
			button.count:FontTemplate(font, self.db.fontSize, self.db.fontOutline);
		end

		button:Show();
		left = min(left, button:GetLeft() or huge);
		right = max(right, button:GetRight() or -huge);
		top = max(top, button:GetTop() or -huge);
		bottom = min(bottom, button:GetBottom() or huge);
	end
	local deadIndex = #(auraTable) + 1;
	local button = _G[headerName.."AuraButton"..deadIndex]
	while(button) do
		if(button:IsShown()) then button:Hide(); end
		deadIndex = deadIndex + 1;
		button = _G[headerName.."AuraButton"..deadIndex]
	end

	if(display >= 1) then
		header:SetWidth(max(right - left, minWidth));
		header:SetHeight(max(top - bottom, minHeight));
	else
		header:SetWidth(minWidth);
		header:SetHeight(minHeight);
	end
end

local freshTable;
local releaseTable;
do
	local tableReserve = {};
	freshTable = function ()
		local t = next(tableReserve) or {};
		tableReserve[t] = nil;
		return t;
	end
	releaseTable = function (t)
		tableReserve[t] = wipe(t);
	end
end

local function sortFactory(key, separateOwn, reverse)
	if(separateOwn ~= 0) then
		if(reverse) then
			return function(a, b)
				if(a.filter == b.filter) then
					local ownA, ownB = a.caster == "player", b.caster == "player";
					if(ownA ~= ownB) then
						return ownA == (separateOwn > 0)
					end
					return a[key] > b[key];
				else
					return a.filter < b.filter;
				end
			end;
		else
			return function(a, b)
				if(a.filter == b.filter) then
					local ownA, ownB = a.caster == "player", b.caster == "player";
					if(ownA ~= ownB) then
						return ownA == (separateOwn > 0);
					end
					return a[key] < b[key];
				else
					return a.filter < b.filter;
				end
			end;
		end
	else
		if(reverse) then
			return function(a, b)
				if(a.filter == b.filter) then
					return a[key] > b[key];
				else
					return a.filter < b.filter;
				end
			end;
		else
			return function(a, b)
				if(a.filter == b.filter) then
					return a[key] < b[key];
				else
					return a.filter < b.filter;
				end
			end;
		end
	end
end

local sorters = {};
for i, key in ipairs{"index", "name", "expires"} do
	local label = key:upper();
	sorters[label] = {};
	for bool in pairs{[true] = true, [false] = false} do
		sorters[label][bool] = {}
		for sep = -1, 1 do
			sorters[label][bool][sep] = sortFactory(key, sep, bool);
		end
	end
end
sorters.TIME = sorters.EXPIRES;

local sortingTable = {};
function A:UpdateHeader(header)
	if(not E.private.auras.enable) then return end

	local filter = header.filter;
	local db = self.db.debuffs;
	if(filter == "HELPFUL") then
		db = self.db.buffs;
	end

	wipe(sortingTable);

	local i = 1;
	repeat
		local aura, _ = freshTable();
		aura.name, _, aura.icon, aura.count, aura.dispelType, aura.duration, aura.expires, aura.caster = UnitAura("player", i, filter);
		if(aura.name) then
			aura.filter = filter;
			aura.index = i;

			tinsert(sortingTable, aura);
		else
			releaseTable(aura);
		end
		i = i + 1;
	until(not aura.name);

	local sortMethod = (sorters[db.sortMethod] or sorters["INDEX"])[db.sortDir == "-"][db.seperateOwn];
	tsort(sortingTable, sortMethod);

	self:ConfigureAuras(header, sortingTable);
	while(sortingTable[1]) do
		releaseTable(tremove(sortingTable));
	end

	if MasqueGroupBuffs and E.private.auras.masque.buffs then MasqueGroupBuffs:ReSkin() end
	if MasqueGroupDebuffs and E.private.auras.masque.debuffs then MasqueGroupDebuffs:ReSkin() end
end

function A:CreateAuraHeader(filter)
	local name = "ElvUIPlayerDebuffs";
	if(filter == "HELPFUL") then
		name = "ElvUIPlayerBuffs";
	end

	local header = CreateFrame("Frame", name, UIParent);
	header:SetClampedToScreen(true);
	header.filter = filter;

	header:RegisterEvent("UNIT_AURA");
	header:SetScript("OnEvent", function(self, event, unit)
		if(event == "UNIT_AURA" and unit == "player") then
			A:UpdateHeader(self);
		end
	end);

	self:UpdateHeader(header);

	return header;
end

--Blizzard Temp Enchant
local function updateTime(button, timeLeft)
	if(not E.private.auras.enable) then return; end

	local temp = _G[button:GetName()];
	local duration = _G[button:GetName().."Duration"];
	local font = LSM:Fetch("font", A.db.font);

	if(SHOW_BUFF_DURATIONS == "1" and timeLeft) then
		duration:SetTextColor(1, 1, 1);
		duration:FontTemplate(font, A.db.fontSize, A.db.fontOutline);

		duration:ClearAllPoints();
		duration:SetPoint("TOP", button, "BOTTOM", 1 + A.db.timeXOffset, 0 + A.db.timeYOffset);

		local d, h, m, s = ChatFrame_TimeBreakDown(timeLeft);
		if(d > 0) then
			duration:SetFormattedText("%1dd", d);
		elseif(h > 0) then
			duration:SetFormattedText("%1dh", h);
		elseif(m > 0) then
			duration:SetFormattedText("%1dm", m);
		else
			duration:SetTextColor(1, 0, 0);
			duration:SetFormattedText("%1d", s);
		end
	end

	temp:Size(A.db.buffs.size);
end
hooksecurefunc("AuraButton_UpdateDuration", updateTime)

function A:Initialize()
	if(self.db) then return; end

	if(E.private.auras.disableBlizzard) then
		BuffFrame:Kill();
		ConsolidatedBuffs:Kill();
	end

	if(not E.private.auras.enable) then return; end

	self.db = E.db.auras;

	self.BuffFrame = self:CreateAuraHeader("HELPFUL");
	self.BuffFrame:Point("TOPRIGHT", MMHolder, "TOPLEFT", -(6 + E.Border), -E.Border - E.Spacing);
	E:CreateMover(self.BuffFrame, "BuffsMover", L["Player Buffs"]);

	self.DebuffFrame = self:CreateAuraHeader("HARMFUL");
	self.DebuffFrame:Point("BOTTOMRIGHT", MMHolder, "BOTTOMLEFT", -(6 + E.Border), E.Border + E.Spacing);
	E:CreateMover(self.DebuffFrame, "DebuffsMover", L["Player Debuffs"]);

	--Temp Enchant
	self.WeaponFrame = CreateFrame("Frame", "ElvUIPlayerWeapons", UIParent);
	self.WeaponFrame:Point("TOPRIGHT", MMHolder, "BOTTOMRIGHT", 0, -E.Border - E.Spacing);

	if(E.myclass == "ROGUE") then
		self.WeaponFrame:Size(110, 32);
	else
		self.WeaponFrame:Size(71, 32);
	end

	TemporaryEnchantFrame:ClearAllPoints();
	TemporaryEnchantFrame:Point("TOPRIGHT", ElvUIPlayerWeapons, "TOPRIGHT", 0, 0);
	E:CreateMover(self.WeaponFrame, "WeaponsMover", L["Weapons"]);

	for i = 1, 3 do
		_G["TempEnchant"..i]:ClearAllPoints();
		_G["TempEnchant"..i]:SetTemplate();
		_G["TempEnchant"..i]:SetBackdropColor(0, 0, 0, 0)
		_G["TempEnchant"..i]:SetBackdropBorderColor(0.5, 0, 0.8);
		_G["TempEnchant"..i].backdropTexture:SetAlpha(0)
		_G["TempEnchant"..i]:StyleButton(nil, true);

		_G["TempEnchant"..i.."Icon"]:SetTexCoord(unpack(E.TexCoords));

		_G["TempEnchant"..i.."Border"]:Hide();
	end

	TempEnchant1:Point("TOPRIGHT", ElvUIPlayerWeapons, "TOPRIGHT");
	TempEnchant2:Point("RIGHT", TempEnchant1, "LEFT", -7, 0);
	TempEnchant3:Point("RIGHT", TempEnchant2, "LEFT", -7, 0);

	if Masque then
		if MasqueGroupBuffs then A.BuffsMasqueGroup = MasqueGroupBuffs end
		if MasqueGroupDebuffs then A.DebuffsMasqueGroup = MasqueGroupDebuffs end
	end
end

local function InitializeCallback()
	A:Initialize()
end

E:RegisterModule(A:GetName(), InitializeCallback)