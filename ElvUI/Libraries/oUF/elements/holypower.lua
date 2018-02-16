if(select(2, UnitClass('player')) ~= 'PALADIN') then return end

local _, ns = ...
local oUF = ns.oUF

local SPELL_POWER_HOLY_POWER = SPELL_POWER_HOLY_POWER
local MAX_HOLY_POWER = MAX_HOLY_POWER

local Update = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'HOLY_POWER')) then return end

	local element = self.HolyPower
	if(element.PreUpdate) then element:PreUpdate() end

	local cur = UnitPower('player', SPELL_POWER_HOLY_POWER)
	for i = 1, MAX_HOLY_POWER do
		if(i <= cur) then
			element[i]:Show()
		else
			element[i]:Hide()
		end
	end

	if(element.PostUpdate) then
		return element:PostUpdate(cur)
	end
end

local Path = function(self, ...)
	return (self.HolyPower.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit, 'HOLY_POWER')
end

local function Enable(self)
	local element = self.HolyPower
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_POWER', Path)

		return true
	end
end

local function Disable(self)
	local element = self.HolyPower
	if(element) then
		self:UnregisterEvent('UNIT_POWER', Path)
	end
end

oUF:AddElement('HolyPower', Path, Enable, Disable)