if(select(2, UnitClass('player')) ~= 'WARLOCK') then return end

local _, ns = ...
local oUF = ns.oUF

local SPELL_POWER_SOUL_SHARDS = SPELL_POWER_SOUL_SHARDS
local SHARD_BAR_NUM_SHARDS = SHARD_BAR_NUM_SHARDS

local Update = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'SOUL_SHARDS')) then return end

	local element = self.SoulShards
	if(element.PreUpdate) then element:PreUpdate() end

	local cur = UnitPower('player', SPELL_POWER_SOUL_SHARDS)
	for i = 1, SHARD_BAR_NUM_SHARDS do
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
	return (self.SoulShards.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit, 'SOUL_SHARDS')
end

local function Enable(self)
	local element = self.SoulShards
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_POWER', Path)

		return true
	end
end

local function Disable(self)
	local element = self.SoulShards
	if(element) then
		self:UnregisterEvent('UNIT_POWER', Path)
	end
end

oUF:AddElement('SoulShards', Path, Enable, Disable)