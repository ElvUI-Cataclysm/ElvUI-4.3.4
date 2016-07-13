local E, L, V, P, G, _ =  unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local Mail_Icon = "";

local Read;


local function MakeIconString()
	local str = ""
		str = str..Mail_Icon

	return str
end

local function OnEvent(self, event, ...)
	local newMail = false
	
	if event == "UPDATE_PENDING_MAIL" or event == "PLAYER_ENTERING_WORLD" or event =="PLAYER_LOGIN" then
	
		newMail = HasNewMail() 
		
		if unreadMail ~= newMail then
			unreadMail = newMail
		end
	
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:UnregisterEvent("PLAYER_LOGIN")
	end
	
	if event == "MAIL_INBOX_UPDATE" or event == "MAIL_SHOW" or event == "MAIL_CLOSED" then
		for i = 1, GetInboxNumItems() do
			local _, _, _, _, _, _, _, _, wasRead = GetInboxHeaderInfo(i);
			if( not wasRead ) then
				newMail = true;
				break;
			end
		end
	end
	
	if newMail then
		self.text:SetText("|cff00d316New Mail|r")
		Read = false;
	else
		self.text:SetText("No Mail")
		Read = true;
	end

end

local function OnEnter(self)
	DT:SetupTooltip(self)
	
	
	
	local sender1, sender2, sender3 = GetLatestThreeSenders()
	
	if not Read then

		if sender1 then
		DT.tooltip:AddLine(HAVE_MAIL_FROM)
		DT.tooltip:AddLine("    "..sender1)
		if sender2 then DT.tooltip:AddLine("    "..sender2) end
		if sender3 then DT.tooltip:AddLine("    "..sender3) end
		end
	end
	DT.tooltip:Show()
end

--[[
	DT:RegisterDatatext(name, events, eventFunc, updateFunc, clickFunc, onEnterFunc, onLeaveFunc)
	
	name - name of the datatext (required)
	events - must be a table with string values of event names to register 
	eventFunc - function that gets fired when an event gets triggered
	updateFunc - onUpdate script target function
	click - function to fire when clicking the datatext
	onEnterFunc - function to fire OnEnter
	onLeaveFunc - function to fire OnLeave, if not provided one will be set for you that hides the tooltip.
]]

DT:RegisterDatatext('Mail', {'PLAYER_ENTERING_WORLD', 'MAIL_INBOX_UPDATE', 'UPDATE_PENDING_MAIL', 'MAIL_CLOSED', 'PLAYER_LOGIN','MAIL_SHOW'}, OnEvent, nil, nil, OnEnter)

