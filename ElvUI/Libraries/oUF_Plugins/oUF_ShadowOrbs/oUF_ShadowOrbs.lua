local _, ns = ...
local oUF = oUF or ns.oUF
assert(oUF, "oUF_ShadowOrbs was unable to locate oUF install.")

if select(2, UnitClass("player")) ~= "PRIEST" then return end

local SHADOW_ORBS = GetSpellInfo(77487)

local function UpdateBar(self, elapsed)
	if not self.expirationTime then return end

	self.elapsed = (self.elapsed or 0) + elapsed

	if self.elapsed >= 0.5 then
		local timeLeft = self.expirationTime - GetTime()

		if timeLeft > 0 then
			self:SetValue(timeLeft)
		else
			self:SetScript("OnUpdate", nil)
		end
	end
end

local Update = function(self, event)
	local element = self.ShadowOrbs
	local unit = self.unit or "player"

	if element.PreUpdate then
		element:PreUpdate(event)
	end

	local name, _, _, count, _, start, timeLeft = UnitBuff(unit, SHADOW_ORBS)
	local orbs, maxOrbs = 0, 3

	if name then
		orbs = count or 0
		duration = start
		expirationTime = timeLeft
	end

	for i = 1, maxOrbs do
		if start and timeLeft then
			element[i]:SetMinMaxValues(0, start)
			element[i].duration = start
			element[i].expirationTime = timeLeft
		end

		if i <= orbs then
			element[i]:SetValue(start)
			element[i]:SetScript("OnUpdate", UpdateBar)
		else
			element[i]:SetValue(0)
			element[i]:SetScript("OnUpdate", nil)
		end
	end

	if element.PostUpdate then
		return element:PostUpdate(event, orbs, maxOrbs)
	end
end

local Path = function(self, ...)
	return (self.ShadowOrbs.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Enable(self, unit)
	local element = self.ShadowOrbs

	if element then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		for i = 1, 3 do
			if element[i]:IsObjectType("StatusBar") and not element[i]:GetStatusBarTexture() then
				element[i]:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
			end

			element[i]:SetMinMaxValues(0, 1)
			element[i]:SetValue(0)
			element[i]:SetFrameLevel(element:GetFrameLevel() + 1)
		end

		self:RegisterEvent("UNIT_AURA", Path)
		self:RegisterEvent("SPELLS_CHANGED", Path)
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", Path)
		self:RegisterEvent("PLAYER_ENTERING_WORLD", Path)

		return true
	end
end

local function Disable(self, unit)
	local element = self.ShadowOrbs

	if element then
		self:UnregisterEvent("UNIT_AURA", Path)
		self:UnregisterEvent("SPELLS_CHANGED", Path)
		self:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED", Path)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD", Path)

		element:Hide()
	end
end

oUF:AddElement("ShadowOrbs", Path, Enable, Disable)