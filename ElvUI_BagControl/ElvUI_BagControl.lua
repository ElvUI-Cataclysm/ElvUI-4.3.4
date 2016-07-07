local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local B = E:GetModule("Bags")
local MyPlugin = E:NewModule("BagControl", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0"); --Create a plugin within ElvUI and adopt AceHook-3.0, AceEvent-3.0 and AceTimer-3.0. We can make use of these later.
local EP = LibStub("LibElvUIPlugin-1.0") --We can use this to automatically insert our GUI tables when ElvUI_Config is loaded.
local addonName, addonTable = ... --See http://www.wowinterface.com/forums/showthread.php?t=51502&p=304704&postcount=2

--Default options

P["BagControl"] = {
	["Enabled"] = true,
	["Open"] = {
		["Mail"] = true,
		["Vendor"] = true,
		["Bank"] = true,
		["GB"] = true,
		["AH"] = true,
		["VS"] = true,
		["TS"] = true,
		["Trade"] =true,
	},
	["Close"] = {
		["Mail"] = true,
		["Vendor"] = true,
		["Bank"] = true,
		["GB"] = true,
		["AH"] = true,
		["VS"] = true,
		["TS"] = true,
		["Trade"] = true,
	},
}
local OpenEvents = {
	["MAIL_SHOW"] = "Mail",
	["MERCHANT_SHOW"] = "Vendor",
	["BANKFRAME_OPENED"] = "Bank",
	["GUILDBANKFRAME_OPENED"] = "GB",
	["AUCTION_HOUSE_SHOW"] = "AH",
	["VOID_STORAGE_OPEN"] = "VS",
	["TRADE_SKILL_SHOW"] = "TS",
	["TRADE_SHOW"] = "Trade",
}

local CloseEvents = {
	["MAIL_CLOSED"] = "Mail",
	["MERCHANT_CLOSED"] = "Vendor",
	["BANKFRAME_CLOSED"] = "Bank",
	["GUILDBANKFRAME_CLOSED"] = "GB",
	["AUCTION_HOUSE_CLOSED"] = "AH",
	["VOID_STORAGE_CLOSE"] = "VS",
	["TRADE_SKILL_CLOSE"] = "TS",
	["TRADE_CLOSED"] = "Trade",
}

function MyPlugin:InsertOptions()
	E.Options.args.BagControl = {
		type = "group",
		name = "Bag Control",
		get = function(info) return E.db.BagControl[ info[#info] ] end,
		set = function(info, value) E.db.BagControl[ info[#info] ] = value; end,
		args = {
			intro = {
				order = 1,
				type = "description",
				name = L['Take Control of your Bags'],
			},
			Enabled = {
				order = 2,
				type = "toggle",
				name = L['Enable'],
				set = function(info, value) E.db.BagControl[ info[#info] ] = value; MyPlugin:Update() end,
			},
			Open = {
				order = 3,
				type = "group",
				name = L['Open bags when the following windows open:'],
				guiInline = true,
				disabled = function() return not E.db.BagControl.Enabled end,
				get = function(info) return E.db.BagControl.Open[ info[#info] ] end,
				set = function(info, value) E.db.BagControl.Open[ info[#info] ] = value; end,
				args = {
					Mail = {
						order = 4,
						type = "toggle",
						name = "Mailbox",
					},
					Vendor = {
						order = 5,
						type = "toggle",
						name = "Merchant",
					},
					Bank = {
						order = 6,
						type = "toggle",
						name = "Bank",
					},
					GB = {
						order = 7,
						type = "toggle",
						name = "Guild Bank",
					},
					AH = {
						order = 8,
						type = "toggle",
						name = "Auction House",
					},
					VS = {
						order = 9,
						type = "toggle",
						name = "Void Storage",
					},
					TS = {
						order = 10,
						type = "toggle",
						name = "Crafting",
					},
					Trade = {
						order = 11,
						type = "toggle",
						name = "Trade with Player",
					}, -- Trade
				}, -- args
			}, --Open
			Close = {
				order = 12,
				type = "group",
				name = L['Close bags when the following windows close:'],
				guiInline = true,
				disabled = function() return not E.db.BagControl.Enabled end,
				get = function(info) return E.db.BagControl.Close[ info[#info] ] end,
				set = function(info, value) E.db.BagControl.Close[ info[#info] ] = value; end,
				args = {
					Mail = {
						order = 13,
						type = "toggle",
						name = "Mailbox",
					},
					Vendor = {
						order = 14,
						type = "toggle",
						name = "Merchant",
					},
					Bank = {
						order = 15,
						type = "toggle",
						name = "Bank",
					},
					GB = {
						order = 16,
						type = "toggle",
						name = "Guild Bank",
					},
					AH = {
						order = 17,
						type = "toggle",
						name = "Auction House",
					},
					VS = {
						order = 18,
						type = "toggle",
						name = "Void Storage",
					},
					TS = {
						order = 19,
						type = "toggle",
						name = "Crafting",
					},
					Trade = {
						order = 20,
						type = "toggle",
						name = "Trade with Player",
					}, --Trade
				}, -- args
			}, --Close
		}, -- args
	} -- BagControl
end

local function EventHandler(self, event, ...)
	if OpenEvents[event] then
		if event == "BANKFRAME_OPENED" then
			B:OpenBank()
			--Bags are automatically opened with Bank, so close them if needed
			if not E.db.BagControl.Open[OpenEvents[event]] then
				B.BagFrame:Hide() --We can't use regular CloseBags, as that would close the bank as well
			end
			return
		elseif E.db.BagControl.Open[OpenEvents[event]] then
			B:OpenBags()
			return
		else
			B:CloseBags()
			return
		end
	elseif CloseEvents[event] then
		if E.db.BagControl.Close[CloseEvents[event]] then
			B:CloseBags()
			return
		else
			B:OpenBags()
			return
		end
	end
end

local EventFrame = CreateFrame("Frame")
EventFrame:SetScript("OnEvent", EventHandler)

local eventsRegistered = false
local function RegisterMyEvents()
	for event in pairs(OpenEvents) do
		EventFrame:RegisterEvent(event)
	end

	for event in pairs(CloseEvents) do
		EventFrame:RegisterEvent(event)
	end

	eventsRegistered = true
end

local function UnregisterMyEvents()
	for event in pairs(OpenEvents) do
		EventFrame:UnregisterEvent(event)
	end

	for event in pairs(CloseEvents) do
		EventFrame:UnregisterEvent(event)
	end

	eventsRegistered = false
end

function MyPlugin:Update()
	if E.db.BagControl.Enabled and not eventsRegistered then
		RegisterMyEvents()
	elseif not E.db.BagControl.Enabled and eventsRegistered then
		UnregisterMyEvents()
	end
end

function MyPlugin:Initialize()
	EP:RegisterPlugin(addonName, MyPlugin.InsertOptions)
	MyPlugin:Update()
end

E:RegisterModule(MyPlugin:GetName()) --Register the module with ElvUI. ElvUI will now call MyPlugin:Initialize() when ElvUI is ready to load our plugin.