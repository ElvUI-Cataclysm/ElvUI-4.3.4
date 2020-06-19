local _, ns = ...
local oUF = ns.oUF
if not oUF then return end

local playerClass = select(2, UnitClass('player'))
local DispelList, BlackList = {}, {}

DispelList.PRIEST = {Magic = true, Disease = true}
DispelList.SHAMAN = {Magic = false, Curse = true}
DispelList.PALADIN = {Magic = false, Poison = true, Disease = true}
DispelList.DRUID = {Magic = false, Curse = true, Poison = true}
DispelList.MAGE = {Curse = true}

local CanDispel = DispelList[playerClass] or {}

BlackList[105171] = true -- Deep Corruption
BlackList[108220] = true -- Deep Corruption

local DispellPriority = {Magic = 4, Curse = 3, Disease = 2, Poison = 1}
local FilterList = {}

local function GetAuraType(unit, filter, filterTable)
	if not unit or not UnitCanAssist('player', unit) then return nil end

	local i = 1
	while true do
		local name, _, texture, _, debufftype, _, _, _, _, _, spellID = UnitAura(unit, i, 'HARMFUL')
		if not texture then break end

		local filterSpell = filterTable[spellID] or filterTable[name]

		if filterTable and filterSpell then
			if filterSpell.enable then
				return debufftype, texture, true, filterSpell.style, filterSpell.color
			end
		elseif debufftype and (not filter or (filter and CanDispel[debufftype])) and not (BlackList[name] or BlackList[spellID]) then
			return debufftype, texture
		end

		i = i + 1
	end

	i = 1
	while true do
		local _, _, texture, _, debufftype, _, _, _, _, _, spellID = UnitAura(unit, i)
		if not texture then break end

		local filterSpell = filterTable[spellID]

		if filterTable and filterSpell then
			if filterSpell.enable then
				return debufftype, texture, true, filterSpell.style, filterSpell.color
			end
		end

		i = i + 1
	end
end

local function FilterTable()
	local debufftype, texture, filterSpell

	return debufftype, texture, true, filterSpell.style, filterSpell.color
end

local function CheckForKnownTalent(spellID)
	local spellName = GetSpellInfo(spellID)
	if not spellName then return nil end

	for i = 1, GetNumTalentTabs() do
		for j = 1, GetNumTalents(i) do
			local name, _, _, _, rank = GetTalentInfo(i, j)

			if name and (name == spellName) then
				if rank and (rank > 0) then
					return true
				else
					return false
				end
			end
		end
	end

	return false
end

local function CheckSpec()
	-- Check for certain talents to see if we can dispel magic or not
	if playerClass == 'PALADIN' then
		CanDispel.Magic = CheckForKnownTalent(53551) -- Sacred Cleansing
	elseif playerClass == 'SHAMAN' then
		CanDispel.Magic = CheckForKnownTalent(77130) -- Improved Cleanse Spirit
	elseif playerClass == 'DRUID' then
		CanDispel.Magic = CheckForKnownTalent(88423) -- Nature's Cure
	end
end

local function Update(self, _, unit)
	if unit ~= self.unit then return end

	local debuffType, texture, wasFiltered, style, color = GetAuraType(unit, self.AuraHighlightFilter, self.AuraHighlightFilterTable)

	if wasFiltered then
		if style == 'GLOW' and self.AuraHightlightGlow then
			self.AuraHightlightGlow:Show()
			self.AuraHightlightGlow:SetBackdropBorderColor(color.r, color.g, color.b)
		elseif self.AuraHightlightGlow then
			self.AuraHightlightGlow:Hide()
			self.AuraHighlight:SetVertexColor(color.r, color.g, color.b, color.a)
		end
	elseif debuffType then
		color = DebuffTypeColor[debuffType or 'none']
		if self.AuraHighlightBackdrop and self.AuraHightlightGlow then
			self.AuraHightlightGlow:Show()
			self.AuraHightlightGlow:SetBackdropBorderColor(color.r, color.g, color.b)
		elseif self.AuraHighlightUseTexture then
			self.AuraHighlight:SetTexture(texture)
		else
			self.AuraHighlight:SetVertexColor(color.r, color.g, color.b, color.a)
		end
	else
		if self.AuraHightlightGlow then
			self.AuraHightlightGlow:Hide()
		end

		if self.AuraHighlightUseTexture then
			self.AuraHighlight:SetTexture(nil)
		else
			self.AuraHighlight:SetVertexColor(0, 0, 0, 0)
		end
	end

	if self.AuraHighlight.PostUpdate then
		self.AuraHighlight:PostUpdate(self, debuffType, texture, wasFiltered, style, color)
	end
end

local function Enable(self)
	local element = self.AuraHighlight
	if element then

		self:RegisterEvent('UNIT_AURA', Update)

		return true
	end
end

local function Disable(self)
	local element = self.AuraHighlight
	if element then
		self:UnregisterEvent('UNIT_AURA', Update)

		if self.AuraHightlightGlow then
			self.AuraHightlightGlow:Hide()
		end

		if self.AuraHighlight then
			self.AuraHighlight:SetVertexColor(0, 0, 0, 0)
		end
	end
end

local f = CreateFrame('Frame')
f:RegisterEvent('CHARACTER_POINTS_CHANGED')
f:RegisterEvent('PLAYER_TALENT_UPDATE')
f:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
f:SetScript('OnEvent', CheckSpec)

oUF:AddElement('AuraHighlight', Update, Enable, Disable)