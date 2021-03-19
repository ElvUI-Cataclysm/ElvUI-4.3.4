local E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule("DataTexts")

local pairs = pairs
local format = string.format

local GetCurrencyInfo = GetCurrencyInfo
local GetMoney = GetMoney
local ToggleCharacter = ToggleCharacter

local CURRENCY, OTHER, PVP = CURRENCY, OTHER, PVP
local EXPANSION_NAME3 = EXPANSION_NAME3
local COMPACT_UNIT_FRAME_PROFILE_AUTOACTIVATEPVE = COMPACT_UNIT_FRAME_PROFILE_AUTOACTIVATEPVE

local iconPath = "Interface\\Icons\\"
local iconString = "\124T%s%s:%d:%d:0:0:64:64:4:60:4:60\124t"

local currencyList, gold

local function getCurrencyCount(id)
	local _, count = GetCurrencyInfo(id)
	return count
end

local function AddTexture(texture)
	return format(iconString, iconPath, texture, 14, 14)
end

local currencies = {
	-- PvP
	["392"] = {ID = 392, NAME = GetCurrencyInfo(392), ICON = AddTexture("PVPCurrency-Honor-"..E.myfaction)},	-- Honor Points
	["390"] = {ID = 390, NAME = GetCurrencyInfo(390), ICON = AddTexture("PVPCurrency-Conquest-"..E.myfaction)},	-- Conquest points
	-- PvE
	["395"] = {ID = 395, NAME = GetCurrencyInfo(395), ICON = AddTexture("pvecurrency-justice")},				-- Justice Points
	["396"] = {ID = 396, NAME = GetCurrencyInfo(396), ICON = AddTexture("pvecurrency-valor")},					-- Valor Points
	-- Cata
	["402"] = {ID = 402, NAME = GetCurrencyInfo(402), ICON = AddTexture("achievement_profession_chefhat")},		-- Chef's Award
	["515"] = {ID = 515, NAME = GetCurrencyInfo(515), ICON = AddTexture("inv_misc_ticket_darkmoon_01")},		-- Darkmoon Prize Ticket
	["361"] = {ID = 361, NAME = GetCurrencyInfo(361), ICON = AddTexture("inv_misc_token_argentdawn3")},			-- Illustrious jewelcrafter's Token
	["416"] = {ID = 416, NAME = GetCurrencyInfo(416), ICON = AddTexture("inv_misc_markoftheworldtree")},		-- Mark of the World Tree
	["614"] = {ID = 614, NAME = GetCurrencyInfo(614), ICON = AddTexture("spell_shadow_sealofkings")},			-- Mote of Darkness
	["391"] = {ID = 391, NAME = GetCurrencyInfo(391), ICON = AddTexture("Achievement_Zone_TolBarad")},			-- Tol Barad Commendation
	-- Other
	["081"] = {ID = 081, NAME = GetCurrencyInfo(81),  ICON = AddTexture("INV_Misc_Ribbon_01")},					-- Dalaran Cooking Award
	["061"] = {ID = 061, NAME = GetCurrencyInfo(61),  ICON = AddTexture("INV_Misc_Gem_Variety_01")},			-- Dalaran Jewelcrafter's Token
	["126"] = {ID = 126, NAME = GetCurrencyInfo(126), ICON = AddTexture("INV_Jewelry_Ring_66")},				-- Wintergrasp Mark of Honor
}

for _, data in pairs(currencies) do
	data.TEXT = format("%s %s", data.ICON, data.NAME)
end

function DT:Currencies_GetCurrencyList()
	if not currencyList then
		currencyList = {}
		for currency, data in pairs(currencies) do
			currencyList[currency] = data.NAME
		end
		currencyList.GOLD = L["Gold"]
	end

	return currencyList
end

local function OnEvent(self)
	gold = GetMoney()

	if E.db.datatexts.currencies.displayedCurrency == "GOLD" then
		self.text:SetText(E:FormatMoney(gold, E.db.datatexts.goldFormat or "BLIZZARD", not E.db.datatexts.goldCoins))
	else
		local chosenCurrency = currencies[E.db.datatexts.currencies.displayedCurrency]

		if chosenCurrency then
			if E.db.datatexts.currencies.displayStyle == "ICON" then
				self.text:SetFormattedText("%s %d", chosenCurrency.ICON, getCurrencyCount(chosenCurrency.ID))
			elseif E.db.datatexts.currencies.displayStyle == "ICON_TEXT" then
				self.text:SetFormattedText("%s %s %d", chosenCurrency.ICON, chosenCurrency.NAME, getCurrencyCount(chosenCurrency.ID))
			else
				self.text:SetFormattedText("%s %s %d", chosenCurrency.ICON, E:AbbreviateString(chosenCurrency.NAME), getCurrencyCount(chosenCurrency.ID))
			end
		end
	end
end

local function OnClick()
	ToggleCharacter("TokenFrame")
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	-- Gold
	DT.tooltip:AddDoubleLine(L["Gold"]..":", E:FormatMoney(gold, E.db.datatexts.goldFormat or "BLIZZARD", not E.db.datatexts.goldCoins), nil, nil, nil, 1, 1, 1)
	DT.tooltip:AddLine(" ")
	-- PvP
	DT.tooltip:AddLine(PVP)
	DT.tooltip:AddDoubleLine(currencies["392"].TEXT, getCurrencyCount(392), 1, 1, 1)	-- Honor Points
	DT.tooltip:AddDoubleLine(currencies["390"].TEXT, getCurrencyCount(390), 1, 1, 1)	-- Conquest points
	DT.tooltip:AddLine(" ")
	-- PvE
	DT.tooltip:AddLine(COMPACT_UNIT_FRAME_PROFILE_AUTOACTIVATEPVE)
	DT.tooltip:AddDoubleLine(currencies["395"].TEXT, getCurrencyCount(395), 1, 1, 1)	-- Justice Points
	DT.tooltip:AddDoubleLine(currencies["396"].TEXT, getCurrencyCount(396), 1, 1, 1)	-- Valor Points
	DT.tooltip:AddLine(" ")
	-- Cata
	DT.tooltip:AddLine(EXPANSION_NAME3)
	DT.tooltip:AddDoubleLine(currencies["402"].TEXT, getCurrencyCount(402), 1, 1, 1)	-- Chef's Award
	DT.tooltip:AddDoubleLine(currencies["515"].TEXT, getCurrencyCount(515), 1, 1, 1)	-- Darkmoon Prize Ticket
	DT.tooltip:AddDoubleLine(currencies["361"].TEXT, getCurrencyCount(361), 1, 1, 1)	-- Illustrious jewelcrafter's Token
	DT.tooltip:AddDoubleLine(currencies["416"].TEXT, getCurrencyCount(416), 1, 1, 1)	-- Mark of the World Tree
	DT.tooltip:AddDoubleLine(currencies["614"].TEXT, getCurrencyCount(614), 1, 1, 1)	-- Mote of Darkness
	DT.tooltip:AddDoubleLine(currencies["391"].TEXT, getCurrencyCount(391), 1, 1, 1)	-- Tol Barad Commendation
	DT.tooltip:AddLine(" ")
	-- Other
	DT.tooltip:AddLine(OTHER)
	DT.tooltip:AddDoubleLine(currencies["081"].TEXT, getCurrencyCount(081), 1, 1, 1)	-- Dalaran Cooking Award
	DT.tooltip:AddDoubleLine(currencies["061"].TEXT, getCurrencyCount(061), 1, 1, 1)	-- Dalaran Jewelcrafter's Token
	DT.tooltip:AddDoubleLine(currencies["126"].TEXT, getCurrencyCount(126), 1, 1, 1)	-- Wintergrasp Mark of Honor

	DT.tooltip:Show()
end

DT:RegisterDatatext("Currencies", {"PLAYER_ENTERING_WORLD", "PLAYER_MONEY", "SEND_MAIL_MONEY_CHANGED", "SEND_MAIL_COD_CHANGED", "PLAYER_TRADE_MONEY", "TRADE_MONEY_CHANGED", "CHAT_MSG_CURRENCY", "CURRENCY_DISPLAY_UPDATE"}, OnEvent, nil, OnClick, OnEnter, nil, CURRENCY)