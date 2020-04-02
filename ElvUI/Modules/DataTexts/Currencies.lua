local E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule("DataTexts")

local select, pairs = select, pairs
local format, join = string.format, string.join

local GetCurrencyInfo = GetCurrencyInfo
local GetMoney = GetMoney

local CURRENCY, OTHER, PVP = CURRENCY, OTHER, PVP
local EXPANSION_NAME3 = EXPANSION_NAME3
local COMPACT_UNIT_FRAME_PROFILE_AUTOACTIVATEPVE = COMPACT_UNIT_FRAME_PROFILE_AUTOACTIVATEPVE

local IconPath = "Interface\\Icons\\"
local iconString = "\124T%s:%d:%d:0:0:64:64:4:60:4:60\124t"

local currencyList, gold

local function getCurrencyInfo(id)
	local name, count = GetCurrencyInfo(id)

	return name, count
end

local function AddTexture(texture)
	local icon = format(iconString, IconPath..texture, 14, 14)

	return icon
end

local Currencies = {
	-- PvP
	["392"] = {ID = 392, NAME = getCurrencyInfo(392), ICON = AddTexture("PVPCurrency-Honor-"..E.myfaction)},	-- Honor Points
	["390"] = {ID = 390, NAME = getCurrencyInfo(390), ICON = AddTexture("PVPCurrency-Conquest-"..E.myfaction)},	-- Conquest points
	-- PvE
	["395"] = {ID = 395, NAME = getCurrencyInfo(395), ICON = AddTexture("pvecurrency-justice")},				-- Justice Points
	["396"] = {ID = 396, NAME = getCurrencyInfo(396), ICON = AddTexture("pvecurrency-valor")},					-- Valor Points
	-- Cata
	["402"] = {ID = 402, NAME = getCurrencyInfo(402), ICON = AddTexture("achievement_profession_chefhat")},		-- Chef's Award
	["515"] = {ID = 515, NAME = getCurrencyInfo(515), ICON = AddTexture("inv_misc_ticket_darkmoon_01")},		-- Darkmoon Prize Ticket
	["361"] = {ID = 361, NAME = getCurrencyInfo(361), ICON = AddTexture("inv_misc_token_argentdawn3")},			-- Illustrious jewelcrafter's Token
	["416"] = {ID = 416, NAME = getCurrencyInfo(416), ICON = AddTexture("inv_misc_markoftheworldtree")},		-- Mark of the World Tree
	["614"] = {ID = 614, NAME = getCurrencyInfo(614), ICON = AddTexture("spell_shadow_sealofkings")},			-- Mote of Darkness
	["391"] = {ID = 391, NAME = getCurrencyInfo(391), ICON = AddTexture("Achievement_Zone_TolBarad")},			-- Tol Barad Commendation
	-- Other
	["081"] = {ID = 081, NAME = getCurrencyInfo(81),  ICON = AddTexture("INV_Misc_Ribbon_01")},					-- Dalaran Cooking Award
	["061"] = {ID = 061, NAME = getCurrencyInfo(61),  ICON = AddTexture("INV_Misc_Gem_Variety_01")},			-- Dalaran Jewelcrafter's Token
	["126"] = {ID = 126, NAME = getCurrencyInfo(126), ICON = AddTexture("INV_Jewelry_Ring_66")},				-- Wintergrasp Mark of Honor
}

function DT:Currencies_GetCurrencyList()
	currencyList = {}
	for currency, data in pairs(Currencies) do
		currencyList[currency] = data.NAME
	end
	currencyList.GOLD = L["Gold"]

	return currencyList
end

local function OnEvent(self)
	gold = GetMoney()

	if E.db.datatexts.currencies.displayedCurrency == "GOLD" then
		self.text:SetText(E:FormatMoney(gold, E.db.datatexts.goldFormat or "BLIZZARD", not E.db.datatexts.goldCoins))
	else
		local chosenCurrency = Currencies[E.db.datatexts.currencies.displayedCurrency]

		if chosenCurrency then
			local count = select(2, getCurrencyInfo(chosenCurrency.ID))

			if E.db.datatexts.currencies.displayStyle == "ICON" then
				self.text:SetFormattedText("%s %d", chosenCurrency.ICON, count)
			elseif E.db.datatexts.currencies.displayStyle == "ICON_TEXT" then
				self.text:SetFormattedText("%s %s %d", chosenCurrency.ICON, chosenCurrency.NAME, count)
			else
				self.text:SetFormattedText("%s %s %d", chosenCurrency.ICON, E:AbbreviateString(chosenCurrency.NAME), count)
			end
		end
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	-- Gold
	DT.tooltip:AddDoubleLine(L["Gold"]..":", E:FormatMoney(gold, E.db.datatexts.goldFormat or "BLIZZARD", not E.db.datatexts.goldCoins), nil, nil, nil, 1, 1, 1)
	DT.tooltip:AddLine(" ")
	-- PvP
	DT.tooltip:AddLine(PVP)
	DT.tooltip:AddDoubleLine(join("", Currencies["392"].ICON, " ", Currencies["392"].NAME), select(2, getCurrencyInfo(392)), 1, 1, 1)	-- Honor Points
	DT.tooltip:AddDoubleLine(join("", Currencies["390"].ICON, " ", Currencies["390"].NAME), select(2, getCurrencyInfo(390)), 1, 1, 1)	-- Conquest points
	DT.tooltip:AddLine(" ")
	-- PvE
	DT.tooltip:AddLine(COMPACT_UNIT_FRAME_PROFILE_AUTOACTIVATEPVE)
	DT.tooltip:AddDoubleLine(join("", Currencies["395"].ICON, " ", Currencies["395"].NAME), select(2, getCurrencyInfo(395)), 1, 1, 1)	-- Justice Points
	DT.tooltip:AddDoubleLine(join("", Currencies["396"].ICON, " ", Currencies["396"].NAME), select(2, getCurrencyInfo(396)), 1, 1, 1)	-- Valor Points
	DT.tooltip:AddLine(" ")
	-- Cata
	DT.tooltip:AddLine(EXPANSION_NAME3)
	DT.tooltip:AddDoubleLine(join("", Currencies["402"].ICON, " ", Currencies["402"].NAME), select(2, getCurrencyInfo(402)), 1, 1, 1)	-- Chef's Award
	DT.tooltip:AddDoubleLine(join("", Currencies["515"].ICON, " ", Currencies["515"].NAME), select(2, getCurrencyInfo(515)), 1, 1, 1)	-- Darkmoon Prize Ticket
	DT.tooltip:AddDoubleLine(join("", Currencies["361"].ICON, " ", Currencies["361"].NAME), select(2, getCurrencyInfo(361)), 1, 1, 1)	-- Illustrious jewelcrafter's Token
	DT.tooltip:AddDoubleLine(join("", Currencies["416"].ICON, " ", Currencies["416"].NAME), select(2, getCurrencyInfo(416)), 1, 1, 1)	-- Mark of the World Tree
	DT.tooltip:AddDoubleLine(join("", Currencies["614"].ICON, " ", Currencies["614"].NAME), select(2, getCurrencyInfo(614)), 1, 1, 1)	-- Mote of Darkness
	DT.tooltip:AddDoubleLine(join("", Currencies["391"].ICON, " ", Currencies["391"].NAME), select(2, getCurrencyInfo(391)), 1, 1, 1)	-- Tol Barad Commendation
	DT.tooltip:AddLine(" ")
	-- Other
	DT.tooltip:AddLine(OTHER)
	DT.tooltip:AddDoubleLine(join("", Currencies["081"].ICON, " ", Currencies["081"].NAME), select(2, getCurrencyInfo(081)), 1, 1, 1)	-- Dalaran Cooking Award
	DT.tooltip:AddDoubleLine(join("", Currencies["061"].ICON, " ", Currencies["061"].NAME), select(2, getCurrencyInfo(061)), 1, 1, 1)	-- Dalaran Jewelcrafter's Token
	DT.tooltip:AddDoubleLine(join("", Currencies["126"].ICON, " ", Currencies["126"].NAME), select(2, getCurrencyInfo(126)), 1, 1, 1)	-- Wintergrasp Mark of Honor

	DT.tooltip:Show()
end

DT:RegisterDatatext("Currencies", {"PLAYER_ENTERING_WORLD", "PLAYER_MONEY", "SEND_MAIL_MONEY_CHANGED", "SEND_MAIL_COD_CHANGED", "PLAYER_TRADE_MONEY", "TRADE_MONEY_CHANGED", "CHAT_MSG_CURRENCY", "CURRENCY_DISPLAY_UPDATE"}, OnEvent, nil, nil, OnEnter, nil, CURRENCY)