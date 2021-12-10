local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")

local random = math.random

local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitIsConnected = UnitIsConnected

function UF:Construct_RoleIcon(frame)
	local tex = frame.RaisedElementParent.TextureParent:CreateTexture(nil, "ARTWORK")
	tex:Size(17)
	tex:Point("BOTTOM", frame.Health, "BOTTOM", 0, 2)
	tex.Override = UF.UpdateRoleIcon
	frame:RegisterEvent("UNIT_CONNECTION", UF.UpdateRoleIcon)

	return tex
end

local roleIconTextures = {
	TANK = E.Media.Textures.Tank,
	HEALER = E.Media.Textures.Healer,
	DAMAGER = E.Media.Textures.DPS
}

function UF:UpdateRoleIcon(event)
	if not self.db then return end

	local db = self.db.roleIcon
	if (not db) or (db and not db.enable) then
		self.GroupRoleIndicator:Hide()
		return
	end

	local role = UnitGroupRolesAssigned(self.unit)
	if self.isForced and role == "NONE" then
		local rnd = random(1, 3)
		role = rnd == 1 and "TANK" or (rnd == 2 and "HEALER" or (rnd == 3 and "DAMAGER"))
	end

	local shouldHide = ((event == "PLAYER_REGEN_DISABLED" and db.combatHide and true) or false)

	if (self.isForced or UnitIsConnected(self.unit)) and ((role == "DAMAGER" and db.damager) or (role == "HEALER" and db.healer) or (role == "TANK" and db.tank)) then
		self.GroupRoleIndicator:SetTexture(roleIconTextures[role])
		if not shouldHide then
			self.GroupRoleIndicator:Show()
		else
			self.GroupRoleIndicator:Hide()
		end
	else
		self.GroupRoleIndicator:Hide()
	end
end

function UF:Configure_RoleIcon(frame)
	local db = frame.db.roleIcon

	if db.enable then
		frame:EnableElement("GroupRoleIndicator")

		local attachPoint = self:GetObjectAnchorPoint(frame, db.attachTo)
		frame.GroupRoleIndicator:ClearAllPoints()
		frame.GroupRoleIndicator:Point(db.position, attachPoint, db.position, db.xOffset, db.yOffset)
		frame.GroupRoleIndicator:Size(db.size)

		if db.combatHide then
			E:RegisterEventForObject("PLAYER_REGEN_ENABLED", frame, UF.UpdateRoleIcon)
			E:RegisterEventForObject("PLAYER_REGEN_DISABLED", frame, UF.UpdateRoleIcon)
		else
			E:UnregisterEventForObject("PLAYER_REGEN_ENABLED", frame, UF.UpdateRoleIcon)
			E:UnregisterEventForObject("PLAYER_REGEN_DISABLED", frame, UF.UpdateRoleIcon)
		end
	else
		frame:DisableElement("GroupRoleIndicator")
		frame.GroupRoleIndicator:Hide()

		--Unregister combat hide events
		E:UnregisterEventForObject("PLAYER_REGEN_ENABLED", frame, UF.UpdateRoleIcon)
		E:UnregisterEventForObject("PLAYER_REGEN_DISABLED", frame, UF.UpdateRoleIcon)
	end
end