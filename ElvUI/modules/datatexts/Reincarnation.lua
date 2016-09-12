local E, L, V, P, G, _ =  unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local GetTime = GetTime
local lastPanel;
local sName = L["Reincarnation"]
local _hex
local red = "|cffb11919"
local texture = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', GetSpellTexture(20608))

local function OnUpdate(self)
	if E.myclass == "SHAMAN" then
		local isKnown = IsSpellKnown(20608, false)
		if (not isKnown) then
			return
		end
		local s, d = GetSpellCooldown(sName)
		if s > 0 and d > 0 then 
			self.text:SetFormattedText(texture.." "..red..format("%d:%02d", floor((d-(GetTime()-s))/60), floor((d-(GetTime()-s))%60)).."|r")
		else
			self.text:SetFormattedText(texture.." ".._hex..L["Ready"].."!|r")
		end
	end
end

local function OnEvent(self, event, timerType, timeSeconds, totalTime)
	if E.myclass == "SHAMAN" then
		local isKnown = IsSpellKnown(20608, false)
		if (not isKnown) then
			self.text:SetFormattedText(_hex..sName.."|r "..L["Not learned!"])
		else
			if(event == "SPELL_UPDATE_COOLDOWN") then
				self:SetScript("OnUpdate", OnUpdate)
			elseif(not self.text:GetText()) then
				local s, d = GetSpellCooldown(sName)
				if s > 0 and d > 0 then 
					self.text:SetFormattedText(texture.." "..red..format("%d:%02d", floor((d-(GetTime()-s))/60), floor((d-(GetTime()-s))%60)).."|r")
				else
					self.text:SetFormattedText(texture.." ".._hex..L["Ready"].."!|r")
				end
			end
		end
	else
		self.text:SetFormattedText(red..L["Datatext disabled"].."!|r")
	end
	lastPanel = self
end

local function ValueColorUpdate(hex)
	_hex = hex
	if lastPanel ~= nil then OnEvent(lastPanel) end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true

DT:RegisterDatatext("Reincarnation", {"PLAYER_ENTERING_WORLD", "SPELL_UPDATE_COOLDOWN"}, OnEvent, OnUpdate)