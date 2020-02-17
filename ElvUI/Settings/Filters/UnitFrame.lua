local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")

local print, unpack = print, unpack

local GetSpellInfo = GetSpellInfo

local function SpellName(id)
	local name = GetSpellInfo(id)
	if not name then
		print("|cff1784d1ElvUI:|r SpellID is not valid: "..id..". Please check for an updated version, if none exists report to ElvUI author.")
		return "Impale"
	else
		return name
	end
end

local function Defaults(priorityOverride)
	return {
		enable = true,
		priority = priorityOverride or 0,
		stackThreshold = 0
	}
end

G.unitframe.aurafilters = {}

-- These are debuffs that are some form of CC
G.unitframe.aurafilters.CCDebuffs = {
	type = "Whitelist",
	spells = {
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
		[19306] = Defaults(),	-- Counterattack
		[19386] = Defaults(),	-- Wyvern Sting
		[24394] = Defaults(),	-- Intimidation
	-- Mage
		[122] = Defaults(),		-- Frost Nova
		[18469] = Defaults(),	-- Silenced - Improved Counterspell
		[31661] = Defaults(),	-- Dragon's Breath
		[55080] = Defaults(),	-- Shattered Barrier
		[61305] = Defaults(),	-- Polymorph
		[82691] = Defaults(),	-- Ring of Frost
	-- Paladin
		[853] = Defaults(),		-- Hammer of Justice
		[2812] = Defaults(),	-- Holy Wrath
		[10326] = Defaults(),	-- Turn Evil
		[20066] = Defaults(),	-- Repentance
	-- Priest
		[605] = Defaults(),		-- Mind Control
		[8122] = Defaults(),	-- Psychic Scream
		[9484] = Defaults(),	-- Shackle Undead
		[15487] = Defaults(),	-- Silence
		[64044] = Defaults(),	-- Psychic Horror
		[64058] = Defaults(),	-- Psychic Horror (Disarm)
	-- Rogue
		[408] = Defaults(),		-- Kidney Shot
		[1776] = Defaults(),	-- Gouge
		[1833] = Defaults(),	-- Cheap Shot
		[2094] = Defaults(),	-- Blind
		[6770] = Defaults(),	-- Sap
		[1330] = Defaults(),	-- Garrote - Silence
		[18425] = Defaults(),	-- Silenced - Improved Kick (Rank 1)
		[86759] = Defaults(),	-- Silenced - Improved Kick (Rank 2)
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
		[54786] = Defaults(),	-- Demon Leap
		[89605] = Defaults(),	-- Aura of Foreboding
	-- Warrior
		[12809] = Defaults(),	-- Concussion Blow
		[20511] = Defaults(),	-- Intimidating Shout
		[85388] = Defaults(),	-- Throwdown
		[46968] = Defaults(),	-- Shockwave
	-- Racial
		[20549] = Defaults(),	-- War Stomp
		[25046] = Defaults(),	-- Arcane Torrent
	-- The Lich King
		[73787] = Defaults()	-- Necrotic Plague
	}
}

-- These are buffs that can be considered "protection" buffs
G.unitframe.aurafilters.TurtleBuffs = {
	type = "Whitelist",
	spells = {
	-- Mage
		[45438] = Defaults(5),	-- Ice Block
	-- Death Knight
		[48707] = Defaults(5),	-- Anti-Magic Shell
		[48792] = Defaults(),	-- Icebound Fortitude
		[49039] = Defaults(),	-- Lichborne
		[50461] = Defaults(),	-- Anti-Magic Zone
		[55233] = Defaults(),	-- Vampiric Blood
		[81256] = Defaults(4),	-- Dancing Rune Weapon
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
		[1966] = Defaults(),	-- Feint
		[5277] = Defaults(5),	-- Evasion
		[31224] = Defaults(),	-- Cloak of Shadows
		[45182] = Defaults(),	-- Cheating Death
		[74001] = Defaults(),	-- Combat Readiness
	-- Shaman
		[30823] = Defaults(),	-- Shamanistic Rage
		[98007] = Defaults(),	-- Spirit Link Totem
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
		[12976] = Defaults(),	-- Last Stand
		[55694] = Defaults(),	-- Enraged Regeneration
		[97463] = Defaults(),	-- Rallying Cry
	}
}

G.unitframe.aurafilters.PlayerBuffs = {
	type = "Whitelist",
	spells = {
	-- Mage
		[12042] = Defaults(),	-- Arcane Power
		[12051] = Defaults(),	-- Evocation
		[80353] = Defaults(),	-- Time Warp
		[12472] = Defaults(),	-- Steel blood
		[32612] = Defaults(),	-- Invisibility
		[45438] = Defaults(),	-- Ice Block
	-- Death Knight
		[48707] = Defaults(),	-- Anti-Magic Shell
		[48792] = Defaults(),	-- Icebound Fortitude
		[49016] = Defaults(),	-- Unholy Frenzy
		[49039] = Defaults(),	-- Lichborne
		[49222] = Defaults(),	-- Bone shield
		[50461] = Defaults(),	-- Anti-Magic Zone
		[51271] = Defaults(),	-- Pillar of Frost
		[55233] = Defaults(),	-- Vampiric Blood
		[81256] = Defaults(),	-- Dancing Rune Weapon
		[96268] = Defaults(),	-- Death's Advance
	-- Priest
		[6346] = Defaults(),	-- Fear Ward
		[10060] = Defaults(),	-- Power Infusion
		[27827] = Defaults(),	-- Spirit of Redemption
		[33206] = Defaults(),	-- Pain Suppression
		[47585] = Defaults(),	-- Dispersion
		[47788] = Defaults(),	-- Guardian Spirit
		[62618] = Defaults(),	-- Power Word: Barrier
	-- Warlock
		[88448] = Defaults(),	-- Demonic Rebirth
	-- Druid
		[1850] = Defaults(),	-- Dash
		[16689] = Defaults(),	-- Nature's Grasp
		[22812] = Defaults(),	-- Barkskin
		[29166] = Defaults(),	-- Innervate
		[52610] = Defaults(),	-- Savage Roar
		[61336] = Defaults(),	-- Survival Instincts
		[69369] = Defaults(),	-- Predatory Swiftness
		[77761] = Defaults(),	-- Stampeding Roar (Bear Form)
		[77764] = Defaults(),	-- Stampeding Roar (Cat Form)
	-- Hunter
		[3045] = Defaults(),	-- Rapid Fire
		[5384] = Defaults(),	-- Feign Death
		[19263] = Defaults(),	-- Deterrence
		[34471] = Defaults(),	-- The Beast Within
		[51755] = Defaults(),	-- Camouflage
		[53480] = Defaults(),	-- Roar of Sacrifice (Pet Cunning)
		[54216] = Defaults(),	-- Master's Call
		[90355] = Defaults(),	-- Ancient Hysteria
		[90361] = Defaults(),	-- Spirit Mend
	-- Rogue
		[2983] = Defaults(),	-- Sprint
		[5277] = Defaults(),	-- Evasion
		[11327] = Defaults(),	-- Vanish
		[13750] = Defaults(),	-- Adrenaline Rush
		[31224] = Defaults(),	-- Cloak of Shadows
		[45182] = Defaults(),	-- Cheating Death
		[51713] = Defaults(),	-- Shadow Dance
		[57933] = Defaults(),	-- Tricks of the Trade
		[74001] = Defaults(),	-- Combat Readiness
		[79140] = Defaults(),	-- Vendetta
	-- Shaman
		[2825] = Defaults(),	-- Bloodlust
		[8178] = Defaults(),	-- Grounding Totem Effect
		[16166] = Defaults(),	-- Elemental Mastery
		[16188] = Defaults(),	-- Nature's Swiftness
		[16166] = Defaults(),	-- Elemental Mastery
		[16191] = Defaults(),	-- Mana Tide Totem
		[30823] = Defaults(),	-- Shamanistic Rage
		[32182] = Defaults(),	-- Heroism
		[58875] = Defaults(),	-- Spirit Walk
		[79206] = Defaults(),	-- Spiritwalker's Grace
		[98007] = Defaults(),	-- Spirit Link Totem
	-- Paladin
		[498] = Defaults(),		-- Divine Protection
		[642] = Defaults(),		-- Divine Shield
		[1044] = Defaults(),	-- Hand of Freedom
		[1022] = Defaults(),	-- Hand of Protection
		[1038] = Defaults(),	-- Hand of Salvation
		[6940] = Defaults(),	-- Hand of Sacrifice
		[31821] = Defaults(),	-- Aura Mastery
		[86659] = Defaults(),	-- Guardian of the Ancient Kings
		[20925] = Defaults(),	-- Holy Shield
		[31850] = Defaults(),	-- Ardent Defender
		[31884] = Defaults(),	-- Avenging Wrath
		[53563] = Defaults(),	-- Beacon of Light
		[31842] = Defaults(),	-- Divine Favor
		[54428] = Defaults(),	-- Divine Plea
		[85499] = Defaults(),	-- Speed of Light
	-- Warrior
		[871] = Defaults(),		-- Shield Wall
		[1719] = Defaults(),	-- Recklessness
		[3411] = Defaults(),	-- Intervene
		[12975] = Defaults(),	-- Last Stand
		[18499] = Defaults(),	-- Berserker Rage
		[23920] = Defaults(),	-- Spell Reflection
		[46924] = Defaults(),	-- Bladestorm
		[50720] = Defaults(),	-- Vigilance
		[55694] = Defaults(),	-- Enraged Regeneration
		[85730] = Defaults(),	-- Deadly Calm
		[97463] = Defaults(),	-- Rallying Cry
	-- Racial
		[20572] = Defaults(),	-- Blood Fury
		[20594] = Defaults(),	-- Stoneform
		[26297] = Defaults(),	-- Berserking
		[59545] = Defaults()	-- Gift of the Naaru
	}
}

-- Buffs that really we dont need to see
G.unitframe.aurafilters.Blacklist = {
	type = "Blacklist",
	spells = {
	-- Spells
		[6788] = Defaults(),	-- Weakended Soul
		[8326] = Defaults(),	-- Ghost
		[8733] = Defaults(),	-- Blessing of Blackfathom
		[15007] = Defaults(),	-- Resurrection Sickness
		[23445] = Defaults(),	-- Evil Twin
		[24755] = Defaults(),	-- Trick or Treat
		[25163] = Defaults(),	-- Oozeling Disgusting Aura
		[25771] = Defaults(),	-- Forbearance
		[26013] = Defaults(),	-- Deserter
		[36032] = Defaults(),	-- Arcane Blast
		[41425] = Defaults(),	-- Hypothermia
		[46221] = Defaults(),	-- Animal Blood
		[55711] = Defaults(),	-- Weakened Heart
		[57723] = Defaults(),	-- Exhaustion
		[57724] = Defaults(),	-- Sated
		[58539] = Defaults(),	-- Watchers Corpse
		[69438] = Defaults(),	-- Sample Satisfaction
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
}

--[[
	This should be a list of important buffs that we always want to see when they are active
	bloodlust, paladin hand spells, raid cooldowns, etc..
]]
G.unitframe.aurafilters.Whitelist = {
	type = "Whitelist",
	spells = {
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
	-- Turtling
		[871] = Defaults(),		-- Shield Wall
		[19263] = Defaults(),	-- Deterrence
		[31224] = Defaults(),	-- Cloak of Shadows
		[48707] = Defaults(),	-- Anti-Magic Shell
		[47585] = Defaults(),	-- Dispersion
	-- Immunities
		[642] = Defaults(),		-- Divine shield
		[45438] = Defaults(),	-- Ice Block
		[96694] = Defaults(),	-- Reflective Shield
	-- Offensive
		[31884] = Defaults(),	-- Avenging Wrath
		[34471] = Defaults()	-- The Beast Within
	}
}

-- RAID DEBUFFS: This should be pretty self explainitory
G.unitframe.aurafilters.RaidDebuffs = {
	type = "Whitelist",
	spells = {
	-- Baradin Hold
		-- Argaloth
		[95173] = Defaults(),	-- Consuming Darkness
		-- Occu'thar
		[96913] = Defaults(),	-- Searing Shadows
		-- Alizabal
		[104936] = Defaults(),	-- Skewer
		[105067] = Defaults(),	-- Seething Hate
	-- Blackwing Descent
		-- Magmaw
		[91911] = Defaults(),	-- Constricting Chains
		[94679] = Defaults(),	-- Parasitic Infection
		[94617] = Defaults(),	-- Mangle
		[78199] = Defaults(),	-- Sweltering Armor
		-- Omnotron Defense System
		[91433] = Defaults(),	-- Lightning Conductor
		[91521] = Defaults(),	-- Incineration Security Measure
		[80094] = Defaults(),	-- Fixate
		[91535] = Defaults(),	-- Flamethrower
		[80161] = Defaults(),	-- Chemical Cloud
		[92035] = Defaults(),	-- Acquiring Target
		[79835] = Defaults(),	-- Poison Soaked Shell
		[91555] = Defaults(),	-- Power Generator
		[92048] = Defaults(),	-- Shadow Infusion
		[92053] = Defaults(),	-- Shadow Conductor
		-- Maloriak
		[77699] = Defaults(),	-- Flash Freeze
		[77760] = Defaults(),	-- Biting Chill
		[92754] = Defaults(),	-- Engulfing Darkness
		[92971] = Defaults(),	-- Consuming Flames
		[92989] = Defaults(),	-- Rend
		-- Atramedes
		[92423] = Defaults(),	-- Searing Flame
		[92485] = Defaults(),	-- Roaring Flame
		[92407] = Defaults(),	-- Sonic Breath
		[78092] = Defaults(),	-- Tracking
		-- Chimaeron
		[82881] = Defaults(),	-- Break
		[89084] = Defaults(),	-- Low Health
		-- Nefarian
		[81114] = Defaults(),	-- Magma
		[94128] = Defaults(),	-- Tail Lash
		[79339] = Defaults(),	-- Explosive Cinders
		[79318] = Defaults(),	-- Dominion
	-- The Bastion of Twilight
		-- Halfus Wyrmbreaker
		[39171] = Defaults(),	-- Malevolent Strikes
		[83710] = Defaults(),	-- Furious Roar
		-- Valiona & Theralion
		[92878] = Defaults(),	-- Blackout
		[86840] = Defaults(),	-- Devouring Flames
		[95639] = Defaults(),	-- Engulfing Magic
		[92886] = Defaults(),	-- Twilight Zone
		[88518] = Defaults(),	-- Twilight Meteorite
		[86505] = Defaults(),	-- Fabulous Flames
		[93051] = Defaults(),	-- Twilight Shift
		-- Twilight Ascendant Council
		[92511] = Defaults(),	-- Hydro Lance
		[82762] = Defaults(),	-- Waterlogged
		[92505] = Defaults(),	-- Frozen
		[92518] = Defaults(),	-- Flame Torrent
		[83099] = Defaults(),	-- Lightning Rod
		[92075] = Defaults(),	-- Gravity Core
		[92488] = Defaults(),	-- Gravity Crush
		[82660] = Defaults(),	-- Burning Blood
		[82665] = Defaults(),	-- Heart of Ice
		[83500] = Defaults(),	-- Swirling Winds
		[83581] = Defaults(),	-- Grounded
		[92067] = Defaults(),	-- Static Overload
		-- Cho'gall
		[86028] = Defaults(),	-- Cho's Blast
		[86029] = Defaults(),	-- Gall's Blast
		[93187] = Defaults(),	-- Corrupted Blood
		[82125] = Defaults(),	-- Corruption: Malformation
		[82170] = Defaults(),	-- Corruption: Absolute
		[93200] = Defaults(),	-- Corruption: Sickness
		[82411] = Defaults(),	-- Debilitating Beam
		[91317] = Defaults(),	-- Worshipping
		-- Sinestra
		[92956] = Defaults(),	-- Wrack
	-- Throne of the Four Winds
		-- Nezir
		[93131] = Defaults(),	-- Ice Patch
		-- Anshal
		[86206] = Defaults(),	-- Soothing Breeze
		[93122] = Defaults(),	-- Toxic Spores
		-- Rohash
		[93058] = Defaults(),	-- Slicing Gale
		-- Al'Akir
		[93260] = Defaults(),	-- Ice Storm
		[93295] = Defaults(),	-- Lightning Rod
		[87873] = Defaults(),	-- Static Shock
		[87856] = Defaults(),	-- Squall Line
		[88427] = Defaults(),	-- Electrocute
	-- Firelands
		-- Beth'tilac
		[99506] = Defaults(),	-- Widows Kiss
		[97202] = Defaults(),	-- Fiery Web Spin
		[49026] = Defaults(),	-- Fixate
		[97079] = Defaults(),	-- Seeping Venom
		-- Alysrazor
		[99389] = Defaults(),	-- Imprinted
		[101296] = Defaults(),	-- Fiero Blast
		[100723] = Defaults(),	-- Gushing Wound
		[101729] = Defaults(),	-- Blazing Claw
		[100640] = Defaults(),	-- Harsh Winds
		[100555] = Defaults(),	-- Smouldering Roots
		-- Shannox
		[99837] = Defaults(),	-- Crystal Prison
		[99937] = Defaults(),	-- Jagged Tear
		-- Baleroc
		[99403] = Defaults(),	-- Tormented
		[99256] = Defaults(),	-- Torment
		[99252] = Defaults(),	-- Blaze of Glory
		[99516] = Defaults(),	-- Countdown
		-- Majordomo Staghelm
		[98450] = Defaults(),	-- Searing Seeds
		[98565] = Defaults(),	-- Burning Orb
		-- Ragnaros
		[98313] = Defaults(),	-- Magma Blast
		[99145] = Defaults(),	-- Blazing Heat
		[99399] = Defaults(),	-- Burning Wound
		[99613] = Defaults(),	-- Molten Blast
		[100293] = Defaults(),	-- Lava Wave
		[100675] = Defaults(),	-- Dreadflame
		[100249] = Defaults(),	-- Combustion
		-- Trash
		[99532] = Defaults(),	-- Melt Armor
	-- Dragon Soul
	    -- Morchok
		[103541] = Defaults(),	-- Safe
		[103536] = Defaults(),	-- Warning
		[103534] = Defaults(),	-- Danger
		[103687] = Defaults(),	-- Crush Armor
		[108570] = Defaults(),	-- Black Blood of the Earth
		-- Warlord Zon'ozz
		[103434] = Defaults(),	-- Disrupting Shadows
		-- Yor'sahj the Unsleeping
		[105171] = Defaults(),	-- Deep Corruption
		-- Hagara the Stormbinder
		[105465] = Defaults(),	-- Lighting Storm
		[104451] = Defaults(),	-- Ice Tomb
		[109325] = Defaults(),	-- Frostflake
		[105289] = Defaults(),	-- Shattered Ice
		[105285] = Defaults(),	-- Target
		[105259] = Defaults(),	-- Watery Entrenchment
		[107061] = Defaults(),	-- Ice Lance
		-- Ultraxion
		[109075] = Defaults(),	-- Fading Light
		-- Warmaster Blackhorn
		[108043] = Defaults(),	-- Sunder Armor
		[107558] = Defaults(),	-- Degeneration
		[107567] = Defaults(),	-- Brutal Strike
		[108046] = Defaults(),	-- Shockwave
		[110214] = Defaults(),	-- Shockwave
		-- Spine of Deathwing
		[105479] = Defaults(),	-- Searing Plasma
		[105490] = Defaults(),	-- Fiery Grip
		[105563] = Defaults(),	-- Grasping Tendrils
		[106199] = Defaults(),	-- Blood Corruption: Death
		-- Madness of Deathwing
		[105841] = Defaults(),	-- Degenerative Bite
		[106385] = Defaults(),	-- Crush
		[106730] = Defaults(),	-- Tetanus
		[106444] = Defaults(),	-- Impale
		[106794] = Defaults(),	-- Shrapnel (Target)
		[105445] = Defaults(),	-- Blistering Heat
		[108649] = Defaults(),	-- Corrupting Parasite
	}
}

-- Spells that we want to show the duration backwards
E.ReverseTimer = {
	[92956] = true,	-- Sinestra (Wrack)
	[89435] = true,	-- Sinestra (Wrack)
	[92955] = true,	-- Sinestra (Wrack)
	[89421] = true,	-- Sinestra (Wrack)
}

-- BuffWatch: List of personal spells to show on unitframes as icon
function UF:AuraWatch_AddSpell(id, point, color, anyUnit, onlyShowMissing, displayText, textThreshold, xOffset, yOffset)
	local r, g, b = 1, 1, 1
	if color then r, g, b = unpack(color) end

	return {
		enabled = true,
		id = id,
		point = point or "TOPLEFT",
		color = {r = r, g = g, b = b},
		anyUnit = anyUnit or false,
		onlyShowMissing = onlyShowMissing or false,
		displayText = displayText or false,
		textThreshold = textThreshold or -1,
		xOffset = xOffset or 0,
		yOffset = yOffset or 0,
		style = "coloredIcon",
		sizeOffset = 0
	}
end

G.unitframe.buffwatch = {
	PRIEST = {
		[17]	= UF:AuraWatch_AddSpell(17, "BOTTOMRIGHT", {0.7, 0.7, 0.7}, true),		-- Power Word: Shield
		[139]	= UF:AuraWatch_AddSpell(139, "BOTTOMLEFT", {0.4, 0.7, 0.2}),			-- Renew
		[6788]	= UF:AuraWatch_AddSpell(6788, "TOPLEFT", {1, 0, 0}, true),				-- Weakened Soul
		[10060] = UF:AuraWatch_AddSpell(10060, "RIGHT", {0.47, 0.35, 0.74}),			-- Power Infusion
		[33206] = UF:AuraWatch_AddSpell(33206, "LEFT", {0.47, 0.35, 0.74}, true),		-- Pain Suppression
		[41635] = UF:AuraWatch_AddSpell(41635, "TOPRIGHT", {0.2, 0.7, 0.2}),			-- Prayer of Mending
		[47788] = UF:AuraWatch_AddSpell(47788, "LEFT", {0.86, 0.45, 0}, true)			-- Guardian Spirit
	},
	DRUID = {
		[774]	= UF:AuraWatch_AddSpell(774, "TOPRIGHT", {0.8, 0.4, 0.8}),				-- Rejuvenation
		[8936]	= UF:AuraWatch_AddSpell(8936, "BOTTOMLEFT", {0.2, 0.8, 0.2}),			-- Regrowth
		[33763] = UF:AuraWatch_AddSpell(33763, "TOPLEFT", {0.4, 0.8, 0.2}),				-- Lifebloom
		[48438] = UF:AuraWatch_AddSpell(48438, "BOTTOMRIGHT", {0.8, 0.4, 0})			-- Wild Growth
	},
	PALADIN = {
		[1022]	= UF:AuraWatch_AddSpell(1022, "BOTTOMRIGHT", {0.2, 0.2, 1}, true),		-- Hand of Protection
		[1038]	= UF:AuraWatch_AddSpell(1038, "BOTTOMRIGHT", {0.89, 0.78, 0}, true),	-- Hand of Salvation
		[1044]	= UF:AuraWatch_AddSpell(1044, "BOTTOMRIGHT", {0.89, 0.45, 0}, true),	-- Hand of Freedom
		[6940]	= UF:AuraWatch_AddSpell(6940, "BOTTOMRIGHT", {0.89, 0.1, 0.1}, true),	-- Hand of Sacrifice
		[53563] = UF:AuraWatch_AddSpell(53563, "TOPLEFT", {0.7, 0.3, 0.7})				-- Beacon of Light
	},
	SHAMAN = {
		[974]	= UF:AuraWatch_AddSpell(974, "TOPRIGHT", {0.2, 0.7, 0.2}),				-- Earth Shield
		[16236] = UF:AuraWatch_AddSpell(16236, "BOTTOMLEFT", {0.4, 0.7, 0.2}),			-- Ancestral Fortitude
		[51945] = UF:AuraWatch_AddSpell(51945, "BOTTOMRIGHT", {0.7, 0.4, 0}),			-- Earthliving
		[61295] = UF:AuraWatch_AddSpell(61295, "TOPLEFT", {0.7, 0.3, 0.7})				-- Riptide
	},
	ROGUE = {
		[57933] = UF:AuraWatch_AddSpell(57933, "TOPRIGHT", {0.89, 0.09, 0.05}),			-- Tricks of the Trade
	},
	MAGE = {
		[54646] = UF:AuraWatch_AddSpell(54646, "TOPRIGHT", {0.2, 0.2, 1}),				-- Focus Magic
	},
	WARRIOR = {
		[3411]	= UF:AuraWatch_AddSpell(3411, "TOPRIGHT", {0.89, 0.09, 0.05}),			-- Intervene
		[50720] = UF:AuraWatch_AddSpell(50720, "TOPLEFT", {0.2, 0.2, 1})				-- Vigilance
	},
	DEATHKNIGHT = {
		[49016] = UF:AuraWatch_AddSpell(49016, "TOPRIGHT", {0.89, 0.1, 0.1})			-- Unholy Frenzy
	},
	HUNTER = {
		[34477]	= UF:AuraWatch_AddSpell(34477, "TOPRIGHT", {0.2, 0.8, 0.2}, true)		-- Misdirection
	},
	WARLOCK = {
		[20707]	= UF:AuraWatch_AddSpell(20707, "TOPRIGHT", {0.89, 0.09, 0.05}),			-- Soulstone Resurrection
		[85767] = UF:AuraWatch_AddSpell(85767, "TOPLEFT", {0.2, 0.2, 1})				-- Dark Intent
	},
	PET = {
		[136]	= UF:AuraWatch_AddSpell(136, "TOPRIGHT", {0.2, 0.8, 0.2}, true)			-- Mend Pet
	}
}

-- Profile specific BuffIndicator
P.unitframe.filters = {
	buffwatch = {}
}

-- Ticks
G.unitframe.ChannelTicks = {
	-- Warlock
	[SpellName(1120)]	= 5,	-- Drain Soul
	[SpellName(689)]	= 5,	-- Drain Life
	[SpellName(5740)]	= 4,	-- Rain of Fire
	[SpellName(755)]	= 10,	-- Health Funnel
	[SpellName(79268)]	= 3,	-- Soul Harvest
	[SpellName(1949)]	= 15,	-- Hellfire
	-- Druid
	[SpellName(44203)]	= 4,	-- Tranquility
	[SpellName(16914)]	= 10,	-- Hurricane
	-- Priest
	[SpellName(15407)]	= 3,	-- Mind Flay
	[SpellName(48045)]	= 5,	-- Mind Sear
	[SpellName(47540)]	= 3,	-- Penance
	[SpellName(64901)]	= 4,	-- Hymn of Hope
	[SpellName(64843)]	= 4,	-- Divine Hymn
	-- Mage
	[SpellName(5143)]	= 5,	-- Arcane Missiles
	[SpellName(10)]		= 8,	-- Blizzard
	[SpellName(12051)]	= 4,	-- Evocation
	-- Death Knight
    [SpellName(42650)]	= 8		-- Army of the Dead
}

--Spells Effected By Haste
G.unitframe.HastedChannelTicks = {
	[SpellName(64901)] = true,	-- Hymn of Hope
	[SpellName(64843)] = true,	-- Divine Hymn
	[SpellName(1120)] = true,	-- Drain Soul
}

-- This should probably be the same as the whitelist filter + any personal class ones that may be important to watch
G.unitframe.AuraBarColors = {
	[2825]	= {enable = true, color = {r = 0.98, g = 0.57, b = 0.10}},	-- Bloodlust
	[32182] = {enable = true, color = {r = 0.98, g = 0.57, b = 0.10}},	-- Heroism
	[80353] = {enable = true, color = {r = 0.98, g = 0.57, b = 0.10}},	-- Time Warp
	[90355] = {enable = true, color = {r = 0.98, g = 0.57, b = 0.10}},	-- Ancient Hysteria
}

G.unitframe.DebuffHighlightColors = {
	[25771] = {enable = false, style = "FILL", color = {r = 0.85, g = 0, b = 0, a = 0.85}} -- Forbearance
}

G.unitframe.specialFilters = {
	-- Whitelists
	Personal = true,
	nonPersonal = true,
	CastByUnit = true,
	notCastByUnit = true,
	Dispellable = true,
	notDispellable = true,

	-- Blacklists
	blockNonPersonal = true,
	blockNoDuration = true,
	blockDispellable = true,
	blockNotDispellable = true,
}