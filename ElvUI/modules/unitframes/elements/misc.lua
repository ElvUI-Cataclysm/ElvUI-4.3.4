local E, L, V, P, G = unpack(select(2, ...));
local UF = E:GetModule('UnitFrames');

local LSM = LibStub("LibSharedMedia-3.0");

function UF:SpawnMenu()
	local unit = E:StringTitle(self.unit)
	if self.unit:find("targettarget") then return; end
	if _G[unit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[unit.."FrameDropDown"], "cursor")
	elseif (self.unit:match("party")) then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor")
	else
		FriendsDropDown.unit = self.unit
		FriendsDropDown.id = self.id
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
		ToggleDropDownMenu(1, nil, FriendsDropDown, "cursor")
	end
end