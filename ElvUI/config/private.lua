local E, L, V, P, G = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

--Locked Settings, These settings are stored for your character only regardless of profile options.

V['general'] = {
	['loot'] = true,
	['lootRoll'] = true,
	["normTex"] = "ElvUI Norm",
	["glossTex"] = "ElvUI Norm",	
	["dmgfont"] = "Homespun",
	["namefont"] = "PT Sans Narrow",
	["chatBubbles"] = "backdrop",
	["chatBubbleFont"] = "PT Sans Narrow",
	["chatBubbleFontSize"] = 14,
	['pixelPerfect'] = true,
	["replaceBlizzFonts"] = true,
	['minimap'] = {
		['enable'] = true,
		['hideCalendar'] = true,
	},
	["classColorMentionsSpeech"] = true
}

V['bags'] = {
	['enable'] = true,
	['bagBar'] = false,
}

V["nameplate"] = {
	["enable"] = true,
}

V['auras'] = {
	['enable'] = true,
	['disableBlizzard'] = true,
}

V['chat'] = {
	['enable'] = true,
}

V['skins'] = {
	['ace3'] = {
		["animations"] = true,
		['enable'] = true,
	},
	['blizzard'] = {
		['enable'] = true,
		['achievement'] = true,
		['achievement_popup'] = true,
		['archaeology'] = true,
		['arena'] = true,
		['arenaregistrar'] = true,
		['auctionhouse'] = true,
		['bags'] = true,
		['barber'] = true,
		['bgmap'] = true,
		['bgscore'] = true,
		['binding'] = true,
		['calendar'] = true,
		['character'] = true,
		['debug'] = true,
		['dressingroom'] = true,
		['encounterjournal'] = true,
		['friends'] = true,
		['gbank'] = true,
		['glyph'] = true,
		['gossip'] = true,
		['greeting'] = true,
		['guild'] = true,
		['guildcontrol'] = true,
		['guildregistrar'] = true,
		['help'] = true,
		['inspect'] = true,
		['lfd'] = true,
		['lfguild'] = true,
		['lfr'] = true,
		['macro'] = true,
		['mail'] = true,
		['merchant'] = true,
		['misc'] = true,
		['movepad'] = true,
		['petition'] = true,
		['pvp'] = true,
		['quest'] = true,
		['raid'] = true,
		['reforge'] = true,
		['socket'] = true,
		['spellbook'] = true,
		['stable'] = true,
		['tabard'] = true,
		['talent'] = true,
		['taxi'] = true,
		['timemanager'] = true,
		['trade'] = true,
		['tradeskill'] = true,
		['trainer'] = true,
		['transmogrify'] = true,
		['tutorial'] = true,
		['voidstorage'] = true,
		['worldmap'] = true,
		["mirrorTimers"] = true
	},
}

V['tooltip'] = {
	['enable'] = true,
}

V['unitframe'] = {
	['enable'] = true,
	["disabledBlizzardFrames"] = {
		["player"] = true,
		["target"] = true,
		["focus"] = true,
		["boss"] = true,
		["arena"] = true,
		["party"] = true,
		['raid'] = true,
	}
}

V["actionbar"] = {
	["enable"] = true,
}

V["cooldown"] = {
	enable = true
}