local E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule("DataTexts")

local _G = _G
local pairs, select = pairs, select
local format = string.format
local wipe = table.wipe

local GetInventoryItemDurability = GetInventoryItemDurability
local GetInventoryItemTexture = GetInventoryItemTexture
local GetInventoryItemLink = GetInventoryItemLink
local GetMoneyString = GetMoneyString
local InCombatLockdown = InCombatLockdown
local ToggleCharacter = ToggleCharacter

local DURABILITY = DURABILITY
local REPAIR_COST = REPAIR_COST

local displayString = DURABILITY..": %s%d%%|r"
local tooltipString = "%d%%"
local totalDurability = 0
local invDurability = {}
local totalRepairCost

local slots = {
	[1] = INVTYPE_HEAD,
	[3] = INVTYPE_SHOULDER,
	[5] = INVTYPE_CHEST,
	[6] = INVTYPE_WAIST,
	[7] = INVTYPE_LEGS,
	[8] = INVTYPE_FEET,
	[9] = INVTYPE_WRIST,
	[10] = INVTYPE_HAND,
	[16] = INVTYPE_WEAPONMAINHAND,
	[17] = INVTYPE_WEAPONOFFHAND,
	[18] = RANGEDSLOT
}

local function OnEvent(self)
	totalDurability = 100
	totalRepairCost = 0

	wipe(invDurability)

	for index in pairs(slots) do
		local currentDura, maxDura = GetInventoryItemDurability(index)
		if currentDura and maxDura > 0 then
			local perc = (currentDura / maxDura) * 100
			invDurability[index] = perc

			if perc < totalDurability then
				totalDurability = perc
			end

			totalRepairCost = totalRepairCost + select(3, E.ScanTooltip:SetInventoryItem("player", index))
		end
	end

	local r, g, b = E:ColorGradient(totalDurability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
	local hex = E:RGBToHex(r, g, b)
	self.text:SetFormattedText(displayString, hex, totalDurability)

	if totalDurability <= 30 then
		E:Flash(self, 0.53, true)
	else
		E:StopFlash(self)
	end
end

local function OnClick()
	ToggleCharacter("PaperDollFrame")
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	for slot, durability in pairs(invDurability) do
		DT.tooltip:AddDoubleLine(format("|T%s:14:14:0:0:64:64:4:60:4:60|t  %s", GetInventoryItemTexture("player", slot), GetInventoryItemLink("player", slot)), format(tooltipString, durability), 1, 1, 1, E:ColorGradient(durability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1))
	end

	if totalRepairCost > 0 then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(REPAIR_COST, GetMoneyString(totalRepairCost), 0.6, 0.8, 1, 1, 1, 1)
	end

	DT.tooltip:Show()
end

DT:RegisterDatatext("Durability", {"PLAYER_ENTERING_WORLD", "UPDATE_INVENTORY_DURABILITY", "MERCHANT_SHOW"}, OnEvent, nil, OnClick, OnEnter, nil, DURABILITY)