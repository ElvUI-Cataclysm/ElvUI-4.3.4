﻿local E, L, V, P, G, _ = unpack(select(2, ...));

local print, unpack = print, unpack;

local GetSpellInfo = GetSpellInfo;

local function SpellName(id)
	local name, _, _, _, _, _, _, _, _ = GetSpellInfo(id);
	if(not name) then
		print("|cff1784d1ElvUI:|r SpellID is not valid: "..id..". Please check for an updated version, if none exists report to ElvUI author.");
		return "Impale";
	else
		return name;
	end
end

local function Defaults(priorityOverride)
	return {["enable"] = true, ["priority"] = priorityOverride or 0, ["stackThreshold"] = 0};
end

G.unitframe.aurafilters = {};

G.unitframe.aurafilters["CCDebuffs"] = {
	["type"] = "Whitelist",
	["spells"] = {
	-- Death Knight
		[47476] = Defaults(),	-- Strangulate
		[49203] = Defaults(),	-- Hungering Cold
	-- Druid
		[339] = Defaults(),		-- Entangling Roots
		[2637] = Defaults(),	-- Hibernate
		[33786] = Defaults(),	-- Cyclone
		[78675] = Defaults(),	-- Solar Beam
		[80964] = Defaults(),	-- Skull Bash
	-- Hunter
		[1513] = Defaults(),	-- Scare Beast
		[3355] = Defaults(),	-- Freezing Trap Effect
		[19503] = Defaults(),	-- Scatter Shot
		[34490] = Defaults(),	-- Silence Shot
	-- Mage
		[122] = Defaults(),		-- Frost Nova
		[18469] = Defaults(),	-- Silenced - Improved Counterspell
		[31661] = Defaults(),	-- Dragon's Breath
		[55080] = Defaults(),	-- Shattered Barrier
		[61305] = Defaults(),	-- Polymorph
		[82691] = Defaults(),	-- Ring of Frost
	-- Paladin
		[853] = Defaults(),		-- Hammer of Justice
		[10326] = Defaults(),	-- Turn Evil
		[20066] = Defaults(),	-- Repentance
	-- Priest
		[605] = Defaults(),		-- Mind Control
		[8122] = Defaults(),	-- Psychic Scream
		[9484] = Defaults(),	-- Shackle Undead
		[15487] = Defaults(),	-- Silence
		[64044] = Defaults(),	-- Psychic Horror
	-- Rogue
		[1776] = Defaults(),	-- Gouge
		[2094] = Defaults(),	-- Blind
		[6770] = Defaults(),	-- Sap
		[18425] = Defaults(),	-- Silenced - Improved Kick
	-- Shaman
		[3600] = Defaults(),	-- Earthbind
		[8056] = Defaults(),	-- Frost Shock
		[39796] = Defaults(),	-- Stoneclaw Stun
		[51514] = Defaults(),	-- Hex
		[63685] = Defaults(),	-- Freeze
	-- Warlock
		[710] = Defaults(),		-- Banish
		[5484] = Defaults(),	-- Howl of Terror
		[5782] = Defaults(),	-- Fear
		[6358] = Defaults(),	-- Seduction
		[6789] = Defaults(),	-- Death Coil
		[30283] = Defaults(),	-- Shadowfury
		[89605] = Defaults(),	-- Aura of Foreboding
	-- Warrior
		[12809] = Defaults(),	-- Concussion Blow
		[20511] = Defaults(),	-- Intimidating Shout
	-- Racial
		[20549] = Defaults(),	-- War Stomp
		[25046] = Defaults(),	-- Arcane Torrent
	-- The Lich King
		[73787] = Defaults()	-- Necrotic Plague
	}
};

G.unitframe.aurafilters["TurtleBuffs"] = {
	["type"] = "Whitelist",
	["spells"] = {
	-- Mage
		[45438] = Defaults(5),	-- Ice Block
	-- Death Knight
		[48707] = Defaults(5),	-- Anti-Magic Shield
		[48792] = Defaults(),	-- Firmness of ice
		[49039] = Defaults(),	-- Degeneration
		[50461] = Defaults(),	-- Anti-Magic Zone
		[55233] = Defaults(),	-- Vampiric Blood
	-- Priest
		[33206] = Defaults(3),	-- Pain Suppression
		[47585] = Defaults(5),	-- Dispersion
		[47788] = Defaults(),	-- Guardian Spirit
		[62618] = Defaults(),	-- Power Word: Barrier
	-- Druid
		[22812] = Defaults(2),	-- Barkskin
		[61336] = Defaults(),	-- Survival Instinct
	-- Hunter
		[19263] = Defaults(5),	-- Deterrence
		[53480] = Defaults(),	-- Roar of sacrifice
	-- Rogue
		[5277] = Defaults(5),	-- Evasion
		[31224] = Defaults(),	-- Cloak of Shadows
		[45182] = Defaults(),	-- Cheating death
	-- Shaman
		[30823] = Defaults(),	-- Shamanistic Rage
	-- Paladin
		[498] = Defaults(2),	-- Divine protection
		[642] = Defaults(5),	-- Divine shield
		[1022] = Defaults(5),	-- Hand Protection
		[1038] = Defaults(5),	-- Hand of Salvation
		[1044] = Defaults(5),	-- Hand of Freedom
		[6940] = Defaults(),	-- Hand of Sacrifice
		[31821] = Defaults(3),	-- Aura Mastery
		[70940] = Defaults(3),	-- Divine Guardian
	-- Warrior
		[871] = Defaults(3),	-- Shield Wall
		[55694] = Defaults()	-- Enraged Regeneration
	}
};

G.unitframe.aurafilters["PlayerBuffs"] = {
	["type"] = "Whitelist",
	["spells"] = {
	-- Mage
		[12042] = Defaults(),	-- Arcane Power
		[12051] = Defaults(),	-- Evocation
		[12472] = Defaults(),	-- Steel blood
		[32612] = Defaults(),	-- Invisibility
		[45438] = Defaults(),	-- Ice Block
	-- Death Knight
		[48707] = Defaults(),	-- Anti-Magic shell
		[48792] = Defaults(),	-- Firmness of ice
		[49016] = Defaults(),	-- Hysteria
		[49039] = Defaults(),	-- Degeneration
		[49222] = Defaults(),	-- Bone shield
		[50461] = Defaults(),	-- Anti-Magic Zone
		[51271] = Defaults(),	-- Unbreakable armor
		[55233] = Defaults(),	-- Vampiric Blood
	-- Priest
		[6346] = Defaults(),	-- Fear Ward
		[10060] = Defaults(),	-- Power Infusion
		[27827] = Defaults(),	-- Spirit of Redemption
		[33206] = Defaults(),	-- Pain Suppression
		[47585] = Defaults(),	-- Dispersion
		[47788] = Defaults(),	-- Guardian spirit
	-- Warlock
	-- Druid
		[1850] = Defaults(),	-- Dash
		[22812] = Defaults(),	-- Barkskin
		[52610] = Defaults(),	-- Savage Roar
	-- Hunter
		[3045] = Defaults(),	-- Rapid Fire
		[5384] = Defaults(),	-- Feign Death
		[19263] = Defaults(),	-- Deterrence
		[53480] = Defaults(),	-- Roar of Sacrifice (Pet Cunning)
		[54216] = Defaults(),	-- Master's Call
	-- Rogue
		[2983] = Defaults(),	-- Sprint
		[5277] = Defaults(),	-- Evasion
		[11327] = Defaults(),	-- Vanish
		[13750] = Defaults(),	-- Adrenaline Rush
		[31224] = Defaults(),	-- Cloak of Shadows
		[45182] = Defaults(),	-- Cheating Death
	-- Shaman
		[2825] = Defaults(),	-- Bloodlust
		[8178] = Defaults(),	-- Grounding Totem Effect
		[16166] = Defaults(),	-- Elemental Mastery
		[16188] = Defaults(),	-- Nature's Swiftness
		[16191] = Defaults(),	-- Mana Tide Totem
		[30823] = Defaults(),	-- Shamanistic Rage
		[32182] = Defaults(),	-- Heroism
		[58875] = Defaults(),	-- Spirit Walk
	-- Paladin
	-- Warrior
		[871] = Defaults(),		-- Shield Wall
		[1719] = Defaults(),	-- Recklessness
		[3411] = Defaults(),	-- Intervene
		[12975] = Defaults(),	-- Last Stand
		[18499] = Defaults(),	-- Berserker Rage
		[23920] = Defaults(),	-- Spell Reflection
		[46924] = Defaults(),	-- Bladestorm
	-- Racial
		[20572] = Defaults(),	-- Blood Fury
		[20594] = Defaults(),	-- Stone shape
		[26297] = Defaults(),	-- Berserk
		[59545] = Defaults()	-- Gift of the naaru
	}
};

G.unitframe.aurafilters["Blacklist"] = {
	["type"] = "Blacklist",
	["spells"] = {
	-- Spells
		[6788] = Defaults(),	-- Weakended Soul
		[8326] = Defaults(),	-- Ghost
		[8733] = Defaults(),	-- Blessing of Blackfathom
		[23445] = Defaults(),	-- Evil Twin
		[24755] = Defaults(),	-- Trick or Treat
		[25163] = Defaults(),	-- Oozeling Disgusting Aura
		[25771] = Defaults(),	-- Forbearance
		[26013] = Defaults(),	-- Deserter
		[36032] = Defaults(),	-- Arcane Blast
		[41425] = Defaults(),	-- Hypothermia
		[55711] = Defaults(),	-- Weakened Heart
		[57723] = Defaults(),	-- Exhaustion
		[57724] = Defaults(),	-- Sated
		[58539] = Defaults(),	-- Watchers Corpse
		[71041] = Defaults(),	-- Dungeon deserter
		[80354] = Defaults(),	-- Timewarp
		[95809] = Defaults(),	-- Insanity
		[95223] = Defaults(),	-- Group Res
	-- Icecrown Citadel
		[69127] = Defaults(),	-- Chill of the Throne
	-- Blood Princes
		[71911] = Defaults(),	-- Shadow resonance
	-- Festergut
		[70852] = Defaults(),	-- The Viscous Muck
		[72144] = Defaults(),	-- Flex Orange Infection
		[73034] = Defaults(),	-- Infected Rot Spores
	-- Rotface
		[72145] = Defaults(),	-- Flex green contagion
	-- Putricide
		[72511] = Defaults()	-- Mutation
	}
};

G.unitframe.aurafilters["Whitelist"] = {
	["type"] = "Whitelist",
	["spells"] = {
		[1022] = Defaults(),	-- Hand protection
		[1490] = Defaults(),	-- Curse of the elements
		[2825] = Defaults(),	-- Bloodlust
		[12051] = Defaults(),	-- Evocation
		[18708] = Defaults(),	-- Fel Domination
		[22812] = Defaults(),	-- Barkskin
		[29166] = Defaults(),	-- Innervate
		[31821] = Defaults(),	-- Aura Mastery
		[32182] = Defaults(),	-- Heroism
		[33206] = Defaults(),	-- Pain Suppression
		[47788] = Defaults(),	-- Guardian Spirit
		[54428] = Defaults(),	-- Divine Plea
		[90355] = Defaults(),	-- Ancient Hysteria
		[80353] = Defaults(),	-- Time Warp
	-- Turtling abilities
		[871] = Defaults(),		-- Shield Wall
		[19263] = Defaults(),	-- Deterrence
		[31224] = Defaults(),	-- Cloak of Shadows
		[48707] = Defaults(),	-- Anti-Magic Shell
		[47585] = Defaults(),	-- Dispersion
	-- Imm
		[642] = Defaults(),		-- Divine shield
		[45438] = Defaults(),	-- Ice Block
		[96694] = Defaults(),	-- Reflective Shield
	-- Offensive Shit
		[31884] = Defaults(),	-- Avenging Wrath
		[34471] = Defaults()	-- The Beast Within
	}
};

G.unitframe.aurafilters["Whitelist (Strict)"] = {
	["type"] = "Whitelist",
	["spells"] = {

	}
};

G.unitframe.aurafilters["RaidDebuffs"] = { 
	["type"] = "Whitelist",
	["spells"] = {
	-- Naxxramas
		[27808] = Defaults(),	-- Ice blast
		[28408] = Defaults(),	-- Chains Kel'Thuzad
		[32407] = Defaults(),	-- Strange Aura
	-- Ulduar
		[66313] = Defaults(),	-- Fire bomb
		[63134] = Defaults(),	-- Sara Blessing
		[62717] = Defaults(),	-- Slag Pot
		[63018] = Defaults(),	-- Searing Light
		[64233] = Defaults(),	-- Gravity Bomb
		[63495] = Defaults(),	-- Static Disruption
	-- Trial of the Crusader
		[66406] = Defaults(),	-- Snobolled!
		[67479] = Defaults(),	-- Impale
		[67574] = Defaults(),	-- Pursued by Anub'arak
		[68509] = Defaults(),	-- Penetrating Cold
		[67651] = Defaults(),	-- Arctic Breath
		[68127] = Defaults(),	-- Flame Legion
		[67049] = Defaults(),	-- Incinerate Flesh
		[66869] = Defaults(),	-- Burning Bile
		[66823] = Defaults(),	-- Paralytic Toxin
	-- Icecrown Citadel
		[71224] = Defaults(),	-- Mutated Infection
		[71822] = Defaults(),	-- Shadow Resonance
		[70447] = Defaults(),	-- Isolation of Volatile Ooze
		[72293] = Defaults(),	-- Mark of the Fallen Champion
		[72448] = Defaults(),	-- Rune of Blood
		[71473] = Defaults(),	-- Essence of the Blood Queen
		[71624] = Defaults(),	-- Mad Attack
		[70923] = Defaults(),	-- Uncontrollable Frenzy
		[70588] = Defaults(),	-- Suppression
		[71738] = Defaults(),	-- Corrosion
		[71733] = Defaults(),	-- Acid Burst
		[72108] = Defaults(),	-- Death and Decay
		[71289] = Defaults(),	-- Dominate Mind
		[69762] = Defaults(),	-- Unchained Magic
		[69651] = Defaults(),	-- Wounding Strike
		[69065] = Defaults(),	-- Impaled
		[71218] = Defaults(),	-- Vile Gas
		[72442] = Defaults(),	-- Boiling Blood
		[72769] = Defaults(),	-- Scent of Blood
		[69279] = Defaults(),	-- Gas Spore
		[70949] = Defaults(),	-- Essence of the Blood Queen
		[72151] = Defaults(),	-- Frenzied Bloodthirst
		[71474] = Defaults(),	-- Frenzied Bloodthirst
		[71340] = Defaults(),	-- Pact of the Darkfallen
		[72985] = Defaults(),	-- Swarming Shadows
		[71267] = Defaults(),	-- Swarming Shadows
		[71264] = Defaults(),	-- Swarming Shadows
		[71807] = Defaults(),	-- Glittering Sparks
		[70873] = Defaults(),	-- Emerald Vigor
		[71283] = Defaults(),	-- Gut Spray
		[69766] = Defaults(),	-- Instability
		[70126] = Defaults(),	-- Ice Patch
		[70157] = Defaults(),	-- Ice Tomb
		[71056] = Defaults(),	-- Frost Breath
		[70106] = Defaults(),	-- Chilled to the Bone
		[70128] = Defaults(),	-- Mystic Buffet
		[73785] = Defaults(),	-- Necrotic Plague
		[73779] = Defaults(),	-- Infest
		[73800] = Defaults(),	-- Soul Shriek
		[73797] = Defaults(),	-- Soul Reaper
		[73708] = Defaults(),	-- Desecration
		[74322] = Defaults(),	-- Harvested Soul
	-- The Ruby ​​Sanctum
		[74502] = Defaults(),	-- Enervating Brand
		[75887] = Defaults(),	-- Blazing Aura
		[74562] = Defaults(),	-- Fiery Combustion
		[74567] = Defaults(),	-- Mark of Combustion
		[74792] = Defaults(),	-- Soul Consumption
		[74795] = Defaults(),	-- Mark of Consumption
	--Blackwing Descent
		--Magmaw
		[91911] = Defaults(),	-- Constricting Chains
		[94679] = Defaults(),	-- Parasitic Infection
		[94617] = Defaults(),	-- Mangle
		[78199] = Defaults(),	-- Sweltering Armor
		--Omintron Defense System
		[91433] = Defaults(),	-- Lightning Conductor
		[91521] = Defaults(),	-- Incineration Security Measure
		[80094] = Defaults(),	-- Fixate 
		--Maloriak
		[77699] = Defaults(),	-- Flash Freeze
		[77760] = Defaults(),	-- Biting Chill
		--Atramedes
		[92423] = Defaults(),	-- Searing Flame
		[92485] = Defaults(),	-- Roaring Flame
		[92407] = Defaults(),	-- Sonic Breath
		--Chimaeron
		[82881] = Defaults(),	-- Break
		[89084] = Defaults(),	-- Low Health
		--Sinestra
		[92956] = Defaults(),	-- Wrack
	--The Bastion of Twilight
		--Valiona & Theralion
		[92878] = Defaults(),	-- Blackout
		[86840] = Defaults(),	-- Devouring Flames
		[95639] = Defaults(),	-- Engulfing Magic
		[92886] = Defaults(),	-- Twilight Zone
		[88518] = Defaults(),	-- Twilight Meteorite
		--Halfus Wyrmbreaker
		[39171] = Defaults(),	-- Malevolent Strikes
		--Twilight Ascendant Council
		[92511] = Defaults(),	-- Hydro Lance
		[82762] = Defaults(),	-- Waterlogged
		[92505] = Defaults(),	-- Frozen
		[92518] = Defaults(),	-- Flame Torrent
		[83099] = Defaults(),	-- Lightning Rod
		[92075] = Defaults(),	-- Gravity Core
		[92488] = Defaults(),	-- Gravity Crush
		--Cho'gall
		[86028] = Defaults(),	-- Cho's Blast
		[86029] = Defaults(),	-- Gall's Blast
	--Throne of the Four Winds
		--Nezir
		[93131] = Defaults(),	-- Ice Patch
		--Anshal
		[86206] = Defaults(),	-- Soothing Breeze
		[93122] = Defaults(),	-- Toxic Spores
		--Rohash
		[93058] = Defaults(),	-- Slicing Gale
		--Al'Akir
		[93260] = Defaults(),	-- Ice Storm
		[93295] = Defaults(),	-- Lightning Rod
	--Firelands	
		--Beth'tilac
		[99506] = Defaults(),	-- Widows Kiss
		--Alysrazor
		[101296] = Defaults(),	-- Fiero Blast
		[100723] = Defaults(),	-- Gushing Wound
		--Shannox
		[99837] = Defaults(),	-- Crystal Prison
		[99937] = Defaults(),	-- Jagged Tear
		--Baleroc
		[99403] = Defaults(),	-- Tormented
		[99256] = Defaults(),	-- Torment
		--Majordomo Staghelm
		[98450] = Defaults(),	-- Searing Seeds
		[98565] = Defaults(),	-- Burning Orb
		--Ragnaros
		[99399] = Defaults(),	-- Burning Wound
		--Trash
		[99532] = Defaults(),	-- Melt Armor	
	--Baradin Hold
		--Occu'thar
		[96913] = Defaults(),	-- Searing Shadows
		--Alizabal
		[104936] = Defaults(),	-- Skewer
	--Dragon Soul
	    --Morchok
		[103541] = Defaults(),	-- Safe
		[103536] = Defaults(),	-- Warning
		[103534] = Defaults(),	-- Danger
		[108570] = Defaults(),	-- Black Blood of the Earth
		--Warlord Zon'ozz
		[103434] = Defaults(),	-- Disrupting Shadows
		--Yor'sahj the Unsleeping
		[105171] = Defaults(),	-- Deep Corruption
		--Hagara the Stormbinder
		[105465] = Defaults(),	-- Lighting Storm
		[104451] = Defaults(),	-- Ice Tomb
		[109325] = Defaults(),	-- Frostflake
		[105289] = Defaults(),	-- Shattered Ice
		[105285] = Defaults(),	-- Target
		--Ultraxion
		[109075] = Defaults(),	-- Fading Light
		--Warmaster Blackhorn
		[108043] = Defaults(),	-- Sunder Armor
		[107558] = Defaults(),	-- Degeneration
		[107567] = Defaults(),	-- Brutal Strike
		[108046] = Defaults(),	-- Shockwave
		--Spine of Deathwing
		[105479] = Defaults(),	-- Searing Plasma
		[105490] = Defaults(),	-- Fiery Grip
		[106199] = Defaults(),	-- Blood Corruption: Death
		--Madness of Deathwing
		[105841] = Defaults(),	-- Degenerative Bite
		[106385] = Defaults(),	-- Crush
		[106730] = Defaults(),	-- Tetanus
		[106444] = Defaults(),	-- Impale
		[106794] = Defaults()	-- Shrapnel (target)
	}
};

--Spells that we want to show the duration backwards
E.ReverseTimer = {
	[92956] = true,	-- Sinestra (Wrack)
	[89435] = true,	-- Sinestra (Wrack)
	[92955] = true,	-- Sinestra (Wrack)
	[89421] = true,	-- Sinestra (Wrack)
}

--BuffWatch
--List of personal spells to show on unitframes as icon
local function ClassBuff(id, point, color, anyUnit, onlyShowMissing, style, displayText, decimalThreshold, textColor, textThreshold, xOffset, yOffset)
	local r, g, b = unpack(color);
	local r2, g2, b2 = 1, 1, 1;
	if(textColor) then
		r2, g2, b2 = unpack(textColor);
	end

	return {["enabled"] = true, ["id"] = id, ["point"] = point, ["color"] = {["r"] = r, ["g"] = g, ["b"] = b},
	["anyUnit"] = anyUnit, ["onlyShowMissing"] = onlyShowMissing, ["style"] = style or "coloredIcon", ["displayText"] = displayText or false, ["decimalThreshold"] = decimalThreshold or 5,
	["textColor"] = {["r"] = r2, ["g"] = g2, ["b"] = b2}, ["textThreshold"] = textThreshold or -1, ["xOffset"] = xOffset or 0, ["yOffset"] = yOffset or 0};
end

-- Indicator Buffs
G.unitframe.buffwatch = {
	PRIEST = {
		[6788] = ClassBuff(6788, "TOPLEFT", {1, 0, 0}, true),						-- Weakened Soul
		[10060] = ClassBuff(10060 , "RIGHT", {227/255, 23/255, 13/255}),			-- Power Infusion
		[48066] = ClassBuff(48066, "BOTTOMRIGHT", {0.81, 0.85, 0.1}, true),			-- Power Word: Shield
		[48068] = ClassBuff(48068, "BOTTOMLEFT", {0.4, 0.7, 0.2}),					-- Renew
		[48111] = ClassBuff(48111, "TOPRIGHT", {0.2, 0.7, 0.2}),					-- Prayer of Mending
	},
	DRUID = {
		[48441] = ClassBuff(48441, "TOPRIGHT", {0.8, 0.4, 0.8}),					-- Rejuvenation
		[48443] = ClassBuff(48443, "BOTTOMLEFT", {0.2, 0.8, 0.2}),					-- Regrowth
		[48451] = ClassBuff(48451, "TOPLEFT", {0.4, 0.8, 0.2}),						-- Lifebloom
		[53251] = ClassBuff(53251, "BOTTOMRIGHT", {0.8, 0.4, 0}),					-- Wild Growth
	},
	PALADIN = {
		[1038] = ClassBuff(1038, "BOTTOMRIGHT", {238/255, 201/255, 0}, true),		-- Hand of Salvation
		[1044] = ClassBuff(1044, "BOTTOMRIGHT", {221/255, 117/255, 0}, true),		-- Hand of Freedom
		[6940] = ClassBuff(6940, "BOTTOMRIGHT", {227/255, 23/255, 13/255}, true),	-- Hand of Sacrafice
		[10278] = ClassBuff(10278, "BOTTOMRIGHT", {0.2, 0.2, 1}, true),				-- Hand of Protection
		[53563] = ClassBuff(53563, "TOPLEFT", {0.7, 0.3, 0.7}),						-- Beacon of Light
		[53601] = ClassBuff(53601, "TOPRIGHT", {0.4, 0.7, 0.2}),					-- Sacred Shield
	},
	SHAMAN = {
		[16237] = ClassBuff(16237, "BOTTOMLEFT", {0.4, 0.7, 0.2}),					-- Ancestral Fortitude
		[49284] = ClassBuff(49284, "TOPRIGHT", {0.2, 0.7, 0.2}),					-- Earth Shield
		[52000] = ClassBuff(52000, "BOTTOMRIGHT", {0.7, 0.4, 0}),					-- Earth Life
		[61301] = ClassBuff(61301, "TOPLEFT", {0.7, 0.3, 0.7}),						-- Riptide
	},
	ROGUE = {
		[57933] = ClassBuff(57933, "TOPRIGHT", {227/255, 23/255, 13/255}),			-- Tricks of the Trade
	},
	MAGE = {
		[54646] = ClassBuff(54646, "TOPRIGHT", {0.2, 0.2, 1}),						-- Focus Magic
	},
	WARRIOR = {
		[3411] = ClassBuff(3411, "TOPRIGHT", {227/255, 23/255, 13/255}),			-- Intervene
		[59665] = ClassBuff(59665, "TOPLEFT", {0.2, 0.2, 1}),						-- Vigilance
	},
	DEATHKNIGHT = {
		[49016] = ClassBuff(49016, "TOPRIGHT", {227/255, 23/255, 13/255})			-- Hysteria
	},
	HUNTER = {}
};

P["unitframe"]["filters"] = {
	["buffwatch"] = {}
};

-- Ticks
G.unitframe.ChannelTicks = {
	-- Warlock
	[SpellName(1120)] = 5,		-- "Drain Soul"
	[SpellName(689)] = 5,		-- "Drain Life"
	[SpellName(5740)] = 4,		-- "Rain of Fire"
	[SpellName(755)] = 10,		-- "Health Funnel"
	-- Druid
	[SpellName(44203)] = 4,		-- "Tranquility"
	[SpellName(16914)] = 10,	-- "Hurricane"
	-- Priest
	[SpellName(15407)] = 3,		-- "Mind Flay"
	[SpellName(48045)] = 5,		-- "Mind Sear"
	[SpellName(47540)] = 3,		-- "Penance"
	[SpellName(64901)] = 4,		-- "Hymn of Hope"
	[SpellName(64843)] = 4,		-- "Divine Hymn"
	-- Mage
	[SpellName(5143)] = 5,		-- "Arcane Missiles"
	[SpellName(10)] = 8,		-- "Blizzard"
	[SpellName(12051)] = 4		-- "Evocation"
};

G.unitframe.AuraBarColors = {
	[SpellName(2825)] = {r = 250/255, g = 146/255, b = 27/255},		-- Bloodlust
	[SpellName(32182)] = {r = 250/255, g = 146/255, b = 27/255},	-- Heroism
	[SpellName(90355)] = {r = 250/255, g = 146/255, b = 27/255},	-- Ancient Hysteria
	[SpellName(80353)] = {r = 250/255, g = 146/255, b = 27/255}		-- Time Warp
};

G.unitframe.InvalidSpells = {
	
};

G.unitframe.DebuffHighlightColors = {
	[SpellName(25771)] = {enable = false, style = "FILL", color = { r = 0.85, g = 0, b = 0, a = 0.85 }}
};

G.oldBuffWatch = {
	PRIEST = {
		ClassBuff(6788, "TOPLEFT", {1, 0, 0}, true),						-- Weakened Soul
		ClassBuff(10060 , "RIGHT", {227/255, 23/255, 13/255}),				-- Power Infusion
		ClassBuff(48066, "BOTTOMRIGHT", {0.81, 0.85, 0.1}, true),			-- Power Word: Shield
		ClassBuff(48068, "BOTTOMLEFT", {0.4, 0.7, 0.2}),					-- Renew
		ClassBuff(48111, "TOPRIGHT", {0.2, 0.7, 0.2}),						-- Prayer of Mending
	},
	DRUID = {
		ClassBuff(48441, "TOPRIGHT", {0.8, 0.4, 0.8}),						-- Rejuvenation
		ClassBuff(48443, "BOTTOMLEFT", {0.2, 0.8, 0.2}),					-- Regrowth
		ClassBuff(48451, "TOPLEFT", {0.4, 0.8, 0.2}),						-- Lifebloom
		ClassBuff(53251, "BOTTOMRIGHT", {0.8, 0.4, 0}),						-- Wild Growth
	},
	PALADIN = {
		ClassBuff(1038, "BOTTOMRIGHT", {238/255, 201/255, 0}, true),		-- Hand of Salvation
		ClassBuff(1044, "BOTTOMRIGHT", {221/255, 117/255, 0}, true),		-- Hand of Freedom
		ClassBuff(6940, "BOTTOMRIGHT", {227/255, 23/255, 13/255}, true),	-- Hand of Sacrafice
		ClassBuff(10278, "BOTTOMRIGHT", {0.2, 0.2, 1}, true),				-- Hand of Protection
		ClassBuff(53563, "TOPLEFT", {0.7, 0.3, 0.7}),						-- Beacon of Light
		ClassBuff(53601, "TOPRIGHT", {0.4, 0.7, 0.2}),						-- Sacred Shield
	},
	SHAMAN = {
		ClassBuff(16237, "BOTTOMLEFT", {0.4, 0.7, 0.2}),					-- Ancestral Fortitude
		ClassBuff(49284, "TOPRIGHT", {0.2, 0.7, 0.2}),						-- Earth Shield
		ClassBuff(52000, "BOTTOMRIGHT", {0.7, 0.4, 0}),						-- Earth Life
		ClassBuff(61301, "TOPLEFT", {0.7, 0.3, 0.7}),						-- Riptide
	},
	ROGUE = {
		ClassBuff(57933, "TOPRIGHT", {227/255, 23/255, 13/255}),			-- Tricks of the Trade
	},
	MAGE = {
		ClassBuff(54646, "TOPRIGHT", {0.2, 0.2, 1}),						-- Focus Magic
	},
	WARRIOR = {
		ClassBuff(3411, "TOPRIGHT", {227/255, 23/255, 13/255}),				-- Intervene
		ClassBuff(59665, "TOPLEFT", {0.2, 0.2, 1}),							-- Vigilance
	},
	DEATHKNIGHT = {
		ClassBuff(49016, "TOPRIGHT", {227/255, 23/255, 13/255})				-- Hysteria
	}
};