local _, ns = ...
local oUF = ns.oUF or oUF
if not oUF then return end
 
local playerClass = select(2,UnitClass("player"))
local CanDispel = {
	PRIEST = { Magic = true, Disease = true, Poison = false, },
	SHAMAN = { Magic = false, Curse = true, },
	PALADIN = { Magic = false, Poison = true, Disease = true, },
	MAGE = { Curse = true, },
	DRUID = { Magic = false, Curse = true, Poison = true, }
}
local dispellist = CanDispel[playerClass] or {}
local origColors = {}
local origBorderColors = {}
local origPostUpdateAura = {}

local function GetDebuffType(unit, filter, filterTable)
	if not UnitCanAssist("player", unit) then return nil end
	local i = 1
	while true do
		local name, _, texture, _, debufftype = UnitAura(unit, i, "HARMFUL")
		if not texture then break end
		if(filterTable and filterTable[name] and filterTable[name].enable) then
			return debufftype, texture, true, filterTable[name].style, filterTable[name].color;
		elseif(debufftype and (not filter or (filter and dispellist[debufftype]))) then
			return debufftype, texture;
		end
		i = i + 1
	end
end

function CheckForKnownTalent(spellid)
	local wanted_name = GetSpellInfo(spellid)
	if not wanted_name then return nil end
	local num_tabs = GetNumTalentTabs()
	for t=1, num_tabs do
		local num_talents = GetNumTalents(t)
		for i=1, num_talents do
			local name_talent, _, _, _, current_rank = GetTalentInfo(t,i)
			if name_talent and (name_talent == wanted_name) then
				if current_rank and (current_rank > 0) then
					return true
				else
					return false
				end
			end
		end
	end
	return false
end

local function CheckSpec(self, event, levels)
	-- Not interested in gained points from leveling	
	if event == "CHARACTER_POINTS_CHANGED" and levels > 0 then return end
	
	--Check for certain talents to see if we can dispel magic or not
	if playerClass == "PALADIN" then
		--Check to see if we have the 'Sacred Cleansing' talent.
		if CheckForKnownTalent(53551) then
			dispellist.Magic = true
		else
			dispellist.Magic = false	
		end
	elseif playerClass == "SHAMAN" then
		--Check to see if we have the 'Improved Cleanse Spirit' talent.
		if CheckForKnownTalent(77130) then
			dispellist.Magic = true
		else
			dispellist.Magic = false	
		end
	elseif playerClass == "DRUID" then
		--Check to see if we have the 'Nature's Cure' talent.
		if CheckForKnownTalent(88423) then
			dispellist.Magic = true
		else
			dispellist.Magic = false	
		end
	elseif playerClass == "PRIEST" then
		--Check to see if we have the 'Body and Soul' talent.
		if CheckForKnownTalent(64129) then
			dispellist.Poison = true
		else
			dispellist.Poison = false
		end
	end
end

local function Update(object, event, unit)
	if(object.unit ~= unit) then return; end

	local debuffType, texture, wasFiltered, style, color = GetDebuffType(unit, object.DebuffHighlightFilter, object.DebuffHighlightFilterTable);
	if(wasFiltered) then
		if(style == "GLOW" and object.DBHGlow) then
			object.DBHGlow:Show();
			object.DBHGlow:SetBackdropBorderColor(color.r, color.g, color.b);
		elseif(object.DBHGlow) then
			object.DBHGlow:Hide();
			object.DebuffHighlight:SetVertexColor(color.r, color.g, color.b, color.a or object.DebuffHighlightAlpha or .5);
		end
	elseif(debuffType) then
		color = DebuffTypeColor[debuffType];
		if(object.DebuffHighlightBackdrop and object.DBHGlow) then
			object.DBHGlow:Show();
			object.DBHGlow:SetBackdropBorderColor(color.r, color.g, color.b);
		elseif(object.DebuffHighlightUseTexture) then
			object.DebuffHighlight:SetTexture(texture);
		else
			object.DebuffHighlight:SetVertexColor(color.r, color.g, color.b, object.DebuffHighlightAlpha or .5);
		end
	else
		if(object.DBHGlow) then
			object.DBHGlow:Hide();
		end

		if(object.DebuffHighlightUseTexture) then
			object.DebuffHighlight:SetTexture(nil);
		else
			object.DebuffHighlight:SetVertexColor(0, 0, 0, 0);
		end
	end
end

local function Enable(object)
	-- if we're not highlighting this unit return
	if not object.DebuffHighlightBackdrop and not object.DebuffHighlight and not object.DBHGlow then
		return
	end
	-- if we're filtering highlights and we're not of the dispelling type, return
	if object.DebuffHighlightFilter and not CanDispel[playerClass] then
		return
	end

	-- make sure aura scanning is active for this object
	object:RegisterEvent("UNIT_AURA", Update)
	object:RegisterEvent("PLAYER_TALENT_UPDATE", CheckSpec)
	object:RegisterEvent("CHARACTER_POINTS_CHANGED", CheckSpec)

	--[[if object.DebuffHighlightBackdrop then
		local r, g, b, a = object:GetBackdropColor()
		origColors[object] = { r = r, g = g, b = b, a = a}
		r, g, b, a = object:GetBackdropBorderColor()
		origBorderColors[object] = { r = r, g = g, b = b, a = a}
	elseif not object.DebuffHighlightUseTexture then
		local r, g, b, a = object.DebuffHighlight:GetVertexColor()
		origColors[object] = { r = r, g = g, b = b, a = a}
	end]]

	return true
end

local function Disable(object)
	--object:UnregisterEvent("UNIT_AURA", Update)
	object:UnregisterEvent("PLAYER_TALENT_UPDATE", CheckSpec)
	object:UnregisterEvent("CHARACTER_POINTS_CHANGED", CheckSpec)

	if object.DebuffHighlightBackdrop or object.DebuffHighlight or object.DBHGlow then
		object:UnregisterEvent("UNIT_AURA", Update)
		
		if(object.DBHGlow) then
			object.DBHGlow:Hide();
		end
		
		if(object.DebuffHighlight) then
			local color = origColors[object];
			if(color) then
				object.DebuffHighlight:SetVertexColor(color.r, color.g, color.b, color.a);
			end
		end
	end
end

oUF:AddElement('DebuffHighlight', Update, Enable, Disable)