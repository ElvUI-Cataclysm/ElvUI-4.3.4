local E, L, V, P, G = unpack(select(2, ...));
local WF = E:NewModule("WatchFrame", "AceEvent-3.0");

local watchFrame;

local statedriver = {
	["NONE"] = function(frame) 
		WatchFrame.userCollapsed = false;
		WatchFrame_Expand(watchFrame);
		WatchFrame:Show();
	end,
	["COLLAPSED"] = function(frame)
		WatchFrame.userCollapsed = true;
		WatchFrame_Collapse(watchFrame);
		WatchFrame:Show();
	end,
	["HIDDEN"] = function(frame)
		WatchFrame:Hide();
	end
};

function WF:ChangeState(event)
	if(UnitAffectingCombat("player")) then self:RegisterEvent("PLAYER_REGEN_ENABLED", "ChangeState"); return; end
	
	if(IsResting()) then
		statedriver[E.db.watchframe.city](watchFrame);
	else
		local instance, instanceType = IsInInstance();
		if(instanceType == "pvp") then
			statedriver[E.db.watchframe.pvp](watchFrame);
		elseif(instanceType == "arena") then
			statedriver[E.db.watchframe.arena](watchFrame);
		elseif(instanceType == "party") then
			statedriver[E.db.watchframe.party](watchFrame);
		elseif(instanceType == "raid") then
			statedriver[E.db.watchframe.raid](watchFrame);
		else
			statedriver["NONE"](watchFrame);
		end
	end

	self:UnregisterEvent("PLAYER_REGEN_ENABLED");
end

function WF:UpdateSettings()
	if(E.private.watchframe.enable) then
		self:RegisterEvent("PLAYER_ENTERING_WORLD", "ChangeState");
		self:RegisterEvent("PLAYER_UPDATE_RESTING", "ChangeState");
	else
		self:UnregisterEvent("PLAYER_ENTERING_WORLD");
		self:UnregisterEvent("PLAYER_UPDATE_RESTING");
	end
end

function WF:Initialize()
	watchFrame = _G["WatchFrame"];
	WF:UpdateSettings();
end

E:RegisterModule(WF:GetName());