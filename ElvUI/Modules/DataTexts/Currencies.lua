local E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule("DataTexts")

local select, pairs = select, pairs
local format, join = string.format, string.join

local GetCurrencyInfo = GetCurrencyInfo
local GetMoney = GetMoney
--local PROFESSIONS_ARCHAEOLOGY = PROFESSIONS_ARCHAEOLOGY
local EXPANSION_NAME2 = EXPANSION_NAME2
local EXPANSION_NAME3 = EXPANSION_NAME3

local displayString = ""
local displayString2 = ""
local IconPath = "Interface\\Icons\\"
local iconString = "\124T%s:%d:%d:0:0:64:64:4:60:4:60\124t"

local currencyList, chosenCurrency, gold
local lastPanel

local Currencies = {
	["395"] = {NAME = GetCurrencyInfo(395), ICON = IconPath.."pvecurrency-justice", COUNT = select(2, GetCurrencyInfo(395))},							-- Justice Points
	["396"] = {NAME = GetCurrencyInfo(396), ICON = IconPath.."pvecurrency-valor", COUNT = select(2, GetCurrencyInfo(396))},								-- Valor Points
	["392"] = {NAME = GetCurrencyInfo(392), ICON = IconPath.."PVPCurrency-Honor-"..E.myfaction, COUNT = select(2, GetCurrencyInfo(392))},				-- Honor Points
	["390"] = {NAME = GetCurrencyInfo(390), ICON = IconPath.."PVPCurrency-Conquest-"..E.myfaction, COUNT = select(2, GetCurrencyInfo(390))},			-- Conquest points
	-- Cataclysm
	["402"] = {NAME = GetCurrencyInfo(402), ICON = IconPath.."achievement_profession_chefhat", COUNT = select(2, GetCurrencyInfo(402))},				-- Chef's Award
	["515"] = {NAME = GetCurrencyInfo(515), ICON = IconPath.."inv_misc_ticket_darkmoon_01", COUNT = select(2, GetCurrencyInfo(515))},					-- Darkmoon Prize Ticket
	["361"] = {NAME = GetCurrencyInfo(361), ICON = IconPath.."inv_misc_token_argentdawn3", COUNT = select(2, GetCurrencyInfo(361))},					-- Illustrious jewelcrafter's Token
	["416"] = {NAME = GetCurrencyInfo(416), ICON = IconPath.."inv_misc_markoftheworldtree", COUNT = select(2, GetCurrencyInfo(416))},					-- Mark of the World Tree
	["614"] = {NAME = GetCurrencyInfo(614), ICON = IconPath.."spell_shadow_sealofkings", COUNT = select(2, GetCurrencyInfo(614))},						-- Mote of Darkness
	["391"] = {NAME = GetCurrencyInfo(391), ICON = IconPath.."Achievement_Zone_TolBarad", COUNT = select(2, GetCurrencyInfo(391))},						-- Tol Barad Commendation
	-- Wrath of the Lich King
	["241"] = {NAME = GetCurrencyInfo(241), ICON = IconPath.."Ability_Paladin_ArtofWar", COUNT = select(2, GetCurrencyInfo(241))},						-- Champion's Seal
	["081"] = {NAME = GetCurrencyInfo(81), ICON = IconPath.."INV_Misc_Ribbon_01", COUNT = select(2, GetCurrencyInfo(81))},								-- Dalaran Cooking Award
	["061"] = {NAME = GetCurrencyInfo(61), ICON = IconPath.."INV_Misc_Gem_Variety_01", COUNT = select(2, GetCurrencyInfo(61))}, 						-- Dalaran Jewelcrafter's Token
	["201"] = {NAME = GetCurrencyInfo(201), ICON = IconPath.."INV_Misc_Coin_16", COUNT = select(2, GetCurrencyInfo(201))},								-- Venture Coin
	["126"] = {NAME = GetCurrencyInfo(126), ICON = IconPath.."INV_Jewelry_Ring_66", COUNT = select(2, GetCurrencyInfo(126))},							-- Wintergrasp Mark of Honor
	-- Archaeology
--[[
	["398"] = {NAME = GetCurrencyInfo(398), ICON = IconPath.."trade_archaeology_draenei_artifactfragment", COUNT = select(2, GetCurrencyInfo(398))},	-- Draenei Archaeology Fragment
	["384"] = {NAME = GetCurrencyInfo(384), ICON = IconPath.."trade_archaeology_dwarf_artifactfragment", COUNT = select(2, GetCurrencyInfo(384))},		-- Dwarf Archaeology Fragment
	["393"] = {NAME = GetCurrencyInfo(393), ICON = IconPath.."trade_archaeology_fossil_fern", COUNT = select(2, GetCurrencyInfo(393))},					-- Fossil Archaeology Fragment
	["400"] = {NAME = GetCurrencyInfo(400), ICON = IconPath.."trade_archaeology_nerubian_artifactfragment", COUNT = select(2, GetCurrencyInfo(400))},	-- Nerubian Archaeology Fragment
	["394"] = {NAME = GetCurrencyInfo(394), ICON = IconPath.."trade_archaeology_highborne_artifactfragment", COUNT = select(2, GetCurrencyInfo(394))},	-- Night Elf Archaeology Fragment
	["397"] = {NAME = GetCurrencyInfo(397), ICON = IconPath.."trade_archaeology_orc_artifactfragment", COUNT = select(2, GetCurrencyInfo(397))},		-- Orc Archaeology Fragment
	["385"] = {NAME = GetCurrencyInfo(385), ICON = IconPath.."trade_archaeology_troll_artifactfragment", COUNT = select(2, GetCurrencyInfo(385))},		-- Troll Archaeology Fragment
	["401"] = {NAME = GetCurrencyInfo(401), ICON = IconPath.."trade_archaeology_titan_fragment", COUNT = select(2, GetCurrencyInfo(401))},				-- Tol'vir Archaeology Fragment
	["399"] = {NAME = GetCurrencyInfo(399), ICON = IconPath.."trade_archaeology_vrykul_artifactfragment", COUNT = select(2, GetCurrencyInfo(399))}		-- Vrykul Archaeology Fragment
]]
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
		chosenCurrency = Currencies[E.db.datatexts.currencies.displayedCurrency]
		if chosenCurrency then
			if E.db.datatexts.currencies.displayStyle == "ICON" then
				self.text:SetFormattedText(displayString, format(iconString, chosenCurrency.ICON, 16, 16), chosenCurrency.COUNT)
			elseif E.db.datatexts.currencies.displayStyle == "ICON_TEXT" then
				self.text:SetFormattedText(displayString2, format(iconString, chosenCurrency.ICON, 16, 16), chosenCurrency.NAME, chosenCurrency.COUNT)
			else
				self.text:SetFormattedText(displayString2, format(iconString, chosenCurrency.ICON, 16, 16), E:AbbreviateString(chosenCurrency.NAME), chosenCurrency.COUNT)
			end
		end
	end

	lastPanel = self
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	DT.tooltip:AddDoubleLine(L["Gold:"], E:FormatMoney(gold, E.db.datatexts.goldFormat or "BLIZZARD", not E.db.datatexts.goldCoins), nil, nil, nil, 1, 1, 1)
	DT.tooltip:AddLine(" ")

	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["395"].ICON, 12, 12), " ", Currencies["395"].NAME), Currencies["395"].COUNT, 1, 1, 1)	-- Justice Points
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["396"].ICON, 12, 12), " ", Currencies["396"].NAME), Currencies["396"].COUNT, 1, 1, 1)	-- Valor Points
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["392"].ICON, 12, 12), " ", Currencies["392"].NAME), Currencies["392"].COUNT, 1, 1, 1)	-- Honor Points
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["390"].ICON, 12, 12), " ", Currencies["390"].NAME), Currencies["390"].COUNT, 1, 1, 1)	-- Conquest points
	DT.tooltip:AddLine(" ")
	-- Cataclysm
	DT.tooltip:AddLine(EXPANSION_NAME3)
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["402"].ICON, 12, 12), " ", Currencies["402"].NAME), Currencies["402"].COUNT, 1, 1, 1)	-- Chef's Award
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["515"].ICON, 12, 12), " ", Currencies["515"].NAME), Currencies["515"].COUNT, 1, 1, 1)	-- Darkmoon Prize Ticket
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["361"].ICON, 12, 12), " ", Currencies["361"].NAME), Currencies["361"].COUNT, 1, 1, 1)	-- Illustrious jewelcrafter's Token
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["416"].ICON, 12, 12), " ", Currencies["416"].NAME), Currencies["416"].COUNT, 1, 1, 1)	-- Mark of the World Tree
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["614"].ICON, 12, 12), " ", Currencies["614"].NAME), Currencies["614"].COUNT, 1, 1, 1)	-- Mote of Darkness
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["391"].ICON, 12, 12), " ", Currencies["391"].NAME), Currencies["391"].COUNT, 1, 1, 1)	-- Tol Barad Commendation
	DT.tooltip:AddLine(" ")
	-- Wrath of the Lich King
	DT.tooltip:AddLine(EXPANSION_NAME2)
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["241"].ICON, 12, 12), " ", Currencies["241"].NAME), Currencies["241"].COUNT, 1, 1, 1)	-- Champion's Seal
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["081"].ICON, 12, 12), " ", Currencies["081"].NAME), Currencies["081"].COUNT, 1, 1, 1)	-- Dalaran Cooking Award
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["061"].ICON, 12, 12), " ", Currencies["061"].NAME), Currencies["061"].COUNT, 1, 1, 1)	-- Dalaran Jewelcrafter's Token
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["201"].ICON, 12, 12), " ", Currencies["201"].NAME), Currencies["201"].COUNT, 1, 1, 1)	-- Dalaran Jewelcrafter's Token
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["126"].ICON, 12, 12), " ", Currencies["126"].NAME), Currencies["126"].COUNT, 1, 1, 1)	-- Wintergrasp Mark of Honor
	DT.tooltip:AddLine(" ")
	-- Archeology
--[[
	DT.tooltip:AddLine(PROFESSIONS_ARCHAEOLOGY)
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["398"].ICON, 12, 12), " ", Currencies["398"].NAME), Currencies["398"].COUNT, 1, 1, 1)	-- Draenei Archaeology Fragment
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["384"].ICON, 12, 12), " ", Currencies["384"].NAME), Currencies["384"].COUNT, 1, 1, 1)	-- Dwarf Archaeology Fragment
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["393"].ICON, 12, 12), " ", Currencies["393"].NAME), Currencies["393"].COUNT, 1, 1, 1)	-- Fossil Archaeology Fragment
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["400"].ICON, 12, 12), " ", Currencies["400"].NAME), Currencies["400"].COUNT, 1, 1, 1)	-- Nerubian Archaeology Fragment
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["394"].ICON, 12, 12), " ", Currencies["394"].NAME), Currencies["394"].COUNT, 1, 1, 1)	-- Night Elf Archaeology Fragment
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["397"].ICON, 12, 12), " ", Currencies["397"].NAME), Currencies["397"].COUNT, 1, 1, 1)	-- Orc Archaeology Fragment
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["401"].ICON, 12, 12), " ", Currencies["401"].NAME), Currencies["401"].COUNT, 1, 1, 1)	-- Tol'vir Archaeology Fragment
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["385"].ICON, 12, 12), " ", Currencies["385"].NAME), Currencies["385"].COUNT, 1, 1, 1)	-- Troll Archaeology Fragment
	DT.tooltip:AddDoubleLine(join("", format(iconString, Currencies["399"].ICON, 12, 12), " ", Currencies["399"].NAME), Currencies["399"].COUNT, 1, 1, 1)	-- Vrykul Archaeology Fragment
]]
	DT.tooltip:Show()
end

local function ValueColorUpdate(hex)
	displayString = join("", "%s ", hex, "%d|r")
	displayString2 = join("", "%s %s: ", hex, "%d|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext("Currencies", {"PLAYER_ENTERING_WORLD", "PLAYER_MONEY", "SEND_MAIL_MONEY_CHANGED", "SEND_MAIL_COD_CHANGED", "PLAYER_TRADE_MONEY", "TRADE_MONEY_CHANGED", "CHAT_MSG_CURRENCY", "CURRENCY_DISPLAY_UPDATE"}, OnEvent, nil, nil, OnEnter, nil, CURRENCY)