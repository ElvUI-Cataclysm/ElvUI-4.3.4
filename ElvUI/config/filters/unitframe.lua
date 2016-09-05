local E, L, V, P, G, _ = unpack(select(2, ...));

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

local function DefaultsID(spellID, priorityOverride)
	return {["enable"] = true, ["spellID"] = spellID, ["priority"] = priorityOverride or 0};
end
G.unitframe.aurafilters = {};

G.unitframe.aurafilters["CCDebuffs"] = {
	["type"] = "Whitelist",
	["spells"] = {
	-- Death Knight
		[SpellName(47476)] = Defaults(), -- Strangulate
		[SpellName(49203)] = Defaults(), -- Hungering Cold
	-- Druid
		[SpellName(339)] = Defaults(), -- Entangling Roots
		[SpellName(2637)] = Defaults(), -- Hibernate
		[SpellName(80964)] = Defaults(), -- Skull Bash
		[SpellName(78675)] = Defaults(), -- Solar Beam
		[SpellName(33786)] = Defaults(), -- Cyclone
	-- Hunter
		[SpellName(1513)] = Defaults(), -- Scare Beast
		[SpellName(3355)] = Defaults(), -- Freezing Trap Effect
		[SpellName(19503)] = Defaults(), -- Scatter Shot
		[SpellName(34490)] = Defaults(), -- Silence Shot
	-- Mage
		[SpellName(122)] = Defaults(), -- Frost Nova
		[SpellName(18469)] = Defaults(), -- Silenced - Improved Counterspell
		[SpellName(31661)] = Defaults(), -- Dragon's Breath
		[SpellName(55080)] = Defaults(), -- Shattered Barrier
		[SpellName(61305)] = Defaults(), -- Polymorph
		[SpellName(82691)] = Defaults(), -- Ring of Frost
	-- Paladin
		[SpellName(853)] = Defaults(), -- Hammer of Justice
		[SpellName(10326)] = Defaults(), -- Turn Evil
		[SpellName(20066)] = Defaults(), -- Repentance
	-- Priest
		[SpellName(605)] = Defaults(), -- Mind Control
		[SpellName(8122)] = Defaults(), -- Psychic Scream
		[SpellName(9484)] = Defaults(), -- Shackle Undead
		[SpellName(15487)] = Defaults(), -- Silence
		[SpellName(64044)] = Defaults(), -- Psychic Horror
	-- Rogue
		[SpellName(1776)] = Defaults(), -- Gouge
		[SpellName(2094)] = Defaults(), -- Blind
		[SpellName(6770)] = Defaults(), -- Sap
		[SpellName(18425)] = Defaults(), -- Silenced - Improved Kick
	-- Shaman
		[SpellName(3600)] = Defaults(), -- Earthbind
		[SpellName(8056)] = Defaults(), -- Frost Shock
		[SpellName(39796)] = Defaults(), -- Stoneclaw Stun
		[SpellName(51514)] = Defaults(), -- Hex
		[SpellName(63685)] = Defaults(), -- Freeze
	-- Warlock
		[SpellName(710)] = Defaults(), -- Banish
		[SpellName(5484)] = Defaults(), -- Howl of Terror
		[SpellName(5782)] = Defaults(), -- Fear
		[SpellName(6358)] = Defaults(), -- Seduction
		[SpellName(6789)] = Defaults(), -- Death Coil
		[SpellName(89605)] = Defaults(), -- Aura of Foreboding
		[SpellName(30283)] = Defaults(), -- Shadowfury
	-- Warrior
		[SpellName(12809)] = Defaults(), -- Concussion Blow
		[SpellName(20511)] = Defaults(), -- Intimidating Shout
	-- Racial
		[SpellName(25046)] = Defaults(), -- Arcane Torrent
		[SpellName(20549)] = Defaults(), -- War Stomp
	-- The Lich King
		[SpellName(73787)] = Defaults() -- Necrotic Plague
	}
};

G.unitframe.aurafilters["TurtleBuffs"] = {
	["type"] = "Whitelist",
	["spells"] = {
	-- Mage
		[SpellName(45438)] = Defaults(5), -- Ice Block
	-- Death Knight
		[SpellName(48707)] = Defaults(5), -- Anti-Magic Shield
		[SpellName(48792)] = Defaults(), -- Firmness of ice
		[SpellName(49039)] = Defaults(), -- Degeneration
		[SpellName(50461)] = Defaults(), -- Anti-Magic Zone
		[SpellName(55233)] = Defaults(), -- Vampiric Blood
	-- Priest
		[SpellName(33206)] = Defaults(3), -- Pain Suppression
		[SpellName(47585)] = Defaults(5), -- Dispersion
		[SpellName(47788)] = Defaults(), -- Guardian Spirit
		[SpellName(62618)] = Defaults(), -- Power Word: Barrier
	-- Druid
		[SpellName(22812)] = Defaults(2), -- Barkskin
		[SpellName(61336)] = Defaults(), -- Survival Instinct
	-- Hunter
		[SpellName(19263)] = Defaults(5), -- Deterrence
		[SpellName(53480)] = Defaults(), -- Roar of sacrifice
	-- Rogue
		[SpellName(5277)] = Defaults(5), -- Evasion
		[SpellName(31224)] = Defaults(), -- Cloak of Shadows
		[SpellName(45182)] = Defaults(), -- Cheating death
	-- Shaman
		[SpellName(30823)] = Defaults(), -- Shamanistic Rage
	-- Paladin
		[SpellName(498)] = Defaults(2), -- Divine protection
		[SpellName(642)] = Defaults(5), -- Divine shield
		[SpellName(1022)] = Defaults(5), -- Hand Protection
		[SpellName(1038)] = Defaults(5), -- Hand of Salvation
		[SpellName(1044)] = Defaults(5), -- Hand of Freedom
		[SpellName(6940)] = Defaults(), -- Hand of Sacrifice
		[SpellName(31821)] = Defaults(3), -- Aura Mastery
		[SpellName(70940)] = Defaults(3), -- Divine Guardian
	-- Warrior
		[SpellName(871)] = Defaults(3), -- Shield Wall
		[SpellName(55694)] = Defaults() -- Enraged Regeneration
	}
};

G.unitframe.aurafilters["PlayerBuffs"] = {
	["type"] = "Whitelist",
	["spells"] = {
	-- Mage
		[SpellName(12042)] = Defaults(), -- Arcane Power
		[SpellName(12051)] = Defaults(), -- Evocation
		[SpellName(12472)] = Defaults(), -- Steel blood
		[SpellName(32612)] = Defaults(), -- Invisibility
		[SpellName(45438)] = Defaults(), -- Ice Block
	-- Death Knight
		[SpellName(48707)] = Defaults(), -- Anti-Magic shell
		[SpellName(48792)] = Defaults(), -- Firmness of ice
		[SpellName(49016)] = Defaults(), -- Hysteria
		[SpellName(49039)] = Defaults(), -- Degeneration
		[SpellName(49222)] = Defaults(), -- Bone shield
		[SpellName(50461)] = Defaults(), -- Anti-Magic Zone
		[SpellName(51271)] = Defaults(), -- Unbreakable armor
		[SpellName(55233)] = Defaults(), -- Vampiric Blood
	-- Priest
		[SpellName(6346)] = Defaults(), -- Fear Ward
		[SpellName(10060)] = Defaults(), -- Power Infusion
		[SpellName(27827)] = Defaults(), -- Spirit of Redemption
		[SpellName(33206)] = Defaults(), -- Pain Suppression
		[SpellName(47585)] = Defaults(), -- Dispersion
		[SpellName(47788)] = Defaults(), -- Guardian spirit
	-- Warlock
	
	-- Druid
	
	-- Hunter
	
	-- Rogue
	
	-- Shaman
		[SpellName(2825)] = Defaults(), -- Bloodlust
		[SpellName(8178)] = Defaults(), -- Grounding Totem Effect
		[SpellName(16166)] = Defaults(), -- Elemental Mastery
		[SpellName(16188)] = Defaults(), -- Nature's Swiftness
		[SpellName(16191)] = Defaults(), -- Mana Tide Totem
		[SpellName(30823)] = Defaults(), -- Shamanistic Rage
		[SpellName(32182)] = Defaults(), -- Heroism
		[SpellName(58875)] = Defaults(), -- Spirit Walk
	-- Paladin
	
	-- Warrior
	
	-- Racial
		[SpellName(20594)] = Defaults(), -- Stone shape
		[SpellName(59545)] = Defaults(), -- Gift of the naaru
		[SpellName(20572)] = Defaults(), -- Blood Fury
		[SpellName(26297)] = Defaults() -- Berserk
	}
};

G.unitframe.aurafilters["Blacklist"] = {
	["type"] = "Blacklist",
	["spells"] = {
		[SpellName(69127)] = Defaults(), -- Chill of the Throne
	-- Blood Princes
		[SpellName(71911)] = Defaults(), -- Shadow resonance
	-- Festergut
		[SpellName(70852)] = Defaults(), -- The viscous muck
		[SpellName(72144)] = Defaults(), -- Flex orange infection
		[SpellName(73034)] = Defaults(), -- Infected rot spores
	-- Rotface
		[SpellName(72145)] = Defaults(), -- Flex green contagion
	-- Putricide
		[SpellName(72511)] = Defaults(), -- Mutation
	-- Spells
		[SpellName(8733)] = Defaults(), -- Blessing of Blackfathom
		[SpellName(57724)] = Defaults(), -- Sated
		[SpellName(25771)] = Defaults(), -- Forbearance
		[SpellName(57723)] = Defaults(), -- Exhaustion
		[SpellName(36032)] = Defaults(), -- Arcane blast
		[SpellName(58539)] = Defaults(), -- Watchers corpse
		[SpellName(26013)] = Defaults(), -- Deserter
		[SpellName(6788)] = Defaults(), -- Weakended soul
		[SpellName(71041)] = Defaults(), -- Dungeon deserter
		[SpellName(41425)] = Defaults(), -- Hypothermia
		[SpellName(55711)] = Defaults(), -- Weakened Heart
		[SpellName(8326)] = Defaults(), -- Ghost
		[SpellName(23445)] = Defaults(), -- Evil twin
		[SpellName(24755)] = Defaults(), -- Trick or Treat
		[SpellName(25163)] = Defaults(), -- Oozeling Disgusting Aura
		[SpellName(80354)] = Defaults(), -- Timewarp
		[SpellName(95809)] = Defaults(), -- Insanity
		[SpellName(95223)] = Defaults() -- Group Res
	}
};

G.unitframe.aurafilters["Whitelist"] = {
	["type"] = "Whitelist",
	["spells"] = {
		[SpellName(1022)] = Defaults(), -- Hand protection
		[SpellName(1490)] = Defaults(), -- Curse of the elements
		[SpellName(2825)] = Defaults(), -- Bloodlust
		[SpellName(12051)] = Defaults(), -- Evocation
		[SpellName(18708)] = Defaults(), -- Fel Domination
		[SpellName(22812)] = Defaults(), -- Barkskin
		[SpellName(29166)] = Defaults(), -- Innervate
		[SpellName(31821)] = Defaults(), -- Aura Mastery
		[SpellName(32182)] = Defaults(), -- Heroism
		[SpellName(33206)] = Defaults(), -- Pain Suppression
		[SpellName(47788)] = Defaults(), -- Guardian Spirit
		[SpellName(54428)] = Defaults(), -- Divine Plea
		[SpellName(90355)] = Defaults(), -- Ancient Hysteria
		[SpellName(80353)] = Defaults(), -- Time Warp
	-- Turtling abilities
		[SpellName(871)] = Defaults(), -- Shield Wall
		[SpellName(19263)] = Defaults(), -- Deterrence
		[SpellName(31224)] = Defaults(), -- Cloak of Shadows
		[SpellName(48707)] = Defaults(), -- Anti-Magic Shell
		[SpellName(47585)] = Defaults(), -- Dispersion
	-- Imm
		[SpellName(642)] = Defaults(), -- Divine shield
		[SpellName(45438)] = Defaults(), -- Ice Block
		[SpellName(96694)] = Defaults(), -- Reflective Shield
	-- Offensive Shit
		[SpellName(31884)] = Defaults(), -- Avenging Wrath
		[SpellName(34471)] = Defaults(), -- The Beast Within
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
		[SpellName(27808)] = Defaults(), -- Ice blast
		[SpellName(28408)] = Defaults(), -- Chains Kel'Thuzad
		[SpellName(32407)] = Defaults(), -- Strange Aura
	-- Ulduar
		[SpellName(66313)] = Defaults(), -- Fire bomb
		[SpellName(63134)] = Defaults(), -- Sara Blessing
		[SpellName(62717)] = Defaults(), -- Slag Pot
		[SpellName(63018)] = Defaults(), -- Searing Light
		[SpellName(64233)] = Defaults(), -- Gravity Bomb
		[SpellName(63495)] = Defaults(), -- Static Disruption
	-- Trial of the Crusader
		[SpellName(66406)] = Defaults(), -- Snobolled!
		[SpellName(67574)] = Defaults(), -- Pursued by Anub'arak
		[SpellName(68509)] = Defaults(), -- Penetrating Cold
		[SpellName(67651)] = Defaults(), -- Arctic Breath
		[SpellName(68127)] = Defaults(), -- Flame Legion
		[SpellName(67049)] = Defaults(), -- Incinerate Flesh
		[SpellName(66869)] = Defaults(), -- Burning Bile
		[SpellName(66823)] = Defaults(), -- Paralytic Toxin
	-- Icecrown Citadel
		[SpellName(71224)] = Defaults(), -- Mutated Infection
		[SpellName(71822)] = Defaults(), -- Shadow Resonance
		[SpellName(70447)] = Defaults(), -- Isolation of Volatile Ooze
		[SpellName(72293)] = Defaults(), -- Mark of the Fallen Champion
		[SpellName(72448)] = Defaults(), -- Rune of Blood
		[SpellName(71473)] = Defaults(), -- Essence of the Blood Queen
		[SpellName(71624)] = Defaults(), -- Mad Attack
		[SpellName(70923)] = Defaults(), -- Uncontrollable Frenzy
		[SpellName(70588)] = Defaults(), -- Suppression
		[SpellName(71738)] = Defaults(), -- Corrosion
		[SpellName(71733)] = Defaults(), -- Acid Burst
		[SpellName(72108)] = Defaults(), -- Death and Decay
		[SpellName(71289)] = Defaults(), -- Dominate Mind
		[SpellName(69762)] = Defaults(), -- Unchained Magic
		[SpellName(69651)] = Defaults(), -- Wounding Strike
		[SpellName(69065)] = Defaults(), -- Impaled
		[SpellName(71218)] = Defaults(), -- Vile Gas
		[SpellName(72442)] = Defaults(), -- Boiling Blood
		[SpellName(72769)] = Defaults(), -- Scent of Blood
		[SpellName(69279)] = Defaults(), -- Gas Spore
		[SpellName(70949)] = Defaults(), -- Essence of the Blood Queen
		[SpellName(72151)] = Defaults(), -- Frenzied Bloodthirst
		[SpellName(71474)] = Defaults(), -- Frenzied Bloodthirst
		[SpellName(71340)] = Defaults(), -- Pact of the Darkfallen
		[SpellName(72985)] = Defaults(), -- Swarming Shadows
		[SpellName(71267)] = Defaults(), -- Swarming Shadows
		[SpellName(71264)] = Defaults(), -- Swarming Shadows
		[SpellName(71807)] = Defaults(), -- Glittering Sparks
		[SpellName(70873)] = Defaults(), -- Emerald Vigor
		[SpellName(71283)] = Defaults(), -- Gut Spray
		[SpellName(69766)] = Defaults(), -- Instability
		[SpellName(70126)] = Defaults(), -- Ice Patch
		[SpellName(70157)] = Defaults(), -- Ice Tomb
		[SpellName(71056)] = Defaults(), -- Frost Breath
		[SpellName(70106)] = Defaults(), -- Chilled to the Bone
		[SpellName(70128)] = Defaults(), -- Mystic Buffet
		[SpellName(73785)] = Defaults(), -- Necrotic Plague
		[SpellName(73779)] = Defaults(), -- Infest
		[SpellName(73800)] = Defaults(), -- Soul Shriek
		[SpellName(73797)] = Defaults(), -- Soul Reaper
		[SpellName(73708)] = Defaults(), -- Desecration
		[SpellName(74322)] = Defaults(), -- Harvested Soul
	-- The Ruby ​​Sanctum
		[SpellName(74502)] = Defaults(), -- Enervating Brand
		[SpellName(75887)] = Defaults(), -- Blazing Aura
		[SpellName(74562)] = Defaults(), -- Fiery Combustion
		[SpellName(74567)] = Defaults(), -- Mark of Combustion
		[SpellName(74792)] = Defaults(), -- Soul Consumption
		[SpellName(74795)] = Defaults(), -- Mark of Consumption
	--Cataclysm
	--Blackwing Descent
		--Magmaw
		[SpellName(91911)] = Defaults(), -- Constricting Chains
		[SpellName(94679)] = Defaults(), -- Parasitic Infection
		[SpellName(94617)] = Defaults(), -- Mangle
		[SpellName(78199)] = Defaults(), -- Sweltering Armor
		--Omintron Defense System
		[SpellName(91433)] = Defaults(), -- Lightning Conductor
		[SpellName(91521)] = Defaults(), -- Incineration Security Measure
		[SpellName(80094)] = Defaults(), -- Fixate 
		--Maloriak
		[SpellName(77699)] = Defaults(), -- Flash Freeze
		[SpellName(77760)] = Defaults(), -- Biting Chill
		--Atramedes
		[SpellName(92423)] = Defaults(), -- Searing Flame
		[SpellName(92485)] = Defaults(), -- Roaring Flame
		[SpellName(92407)] = Defaults(), -- Sonic Breath
		--Chimaeron
		[SpellName(82881)] = Defaults(), -- Break
		[SpellName(89084)] = Defaults(), -- Low Health
		--Sinestra
		[SpellName(92956)] = Defaults(), -- Wrack
	--The Bastion of Twilight
		--Valiona & Theralion
		[SpellName(92878)] = Defaults(), -- Blackout
		[SpellName(86840)] = Defaults(), -- Devouring Flames
		[SpellName(95639)] = Defaults(), -- Engulfing Magic
		[SpellName(92886)] = Defaults(), -- Twilight Zone
		[SpellName(88518)] = Defaults(), -- Twilight Meteorite
		--Halfus Wyrmbreaker
		[SpellName(39171)] = Defaults(), -- Malevolent Strikes
		--Twilight Ascendant Council
		[SpellName(92511)] = Defaults(), -- Hydro Lance
		[SpellName(82762)] = Defaults(), -- Waterlogged
		[SpellName(92505)] = Defaults(), -- Frozen
		[SpellName(92518)] = Defaults(), -- Flame Torrent
		[SpellName(83099)] = Defaults(), -- Lightning Rod
		[SpellName(92075)] = Defaults(), -- Gravity Core
		[SpellName(92488)] = Defaults(), -- Gravity Crush
		--Cho'gall
		[SpellName(86028)] = Defaults(), -- Cho's Blast
		[SpellName(86029)] = Defaults(), -- Gall's Blast
	--Throne of the Four Winds
		--Conclave of Wind
			--Nezir <Lord of the North Wind>
			[SpellName(93131)] = Defaults(), -- Ice Patch
			--Anshal <Lord of the West Wind>
			[SpellName(86206)] = Defaults(), -- Soothing Breeze
			[SpellName(93122)] = Defaults(), -- Toxic Spores
			--Rohash <Lord of the East Wind>
			[SpellName(93058)] = Defaults(), -- Slicing Gale
		--Al'Akir
		[SpellName(93260)] = Defaults(), -- Ice Storm
		[SpellName(93295)] = Defaults(), -- Lightning Rod
		
	--Firelands	
		--Beth'tilac
		[SpellName(99506)] = Defaults(), -- Widows Kiss
		--Alysrazor
		[SpellName(101296)] = Defaults(), -- Fiero Blast
		[SpellName(100723)] = Defaults(), -- Gushing Wound
		--Shannox
		[SpellName(99837)] = Defaults(), -- Crystal Prison
		[SpellName(99937)] = Defaults(), -- Jagged Tear
		--Baleroc
		[SpellName(99403)] = Defaults(), -- Tormented
		[SpellName(99256)] = Defaults(), -- Torment
		--Majordomo Staghelm
		[SpellName(98450)] = Defaults(), -- Searing Seeds
		[SpellName(98565)] = Defaults(), -- Burning Orb
		--Ragnaros
		[SpellName(99399)] = Defaults(), -- Burning Wound
		--Trash
		[SpellName(99532)] = Defaults(), -- Melt Armor	

	--Baradin Hold
		--Occu'thar
		[SpellName(96913)] = Defaults(), -- Searing Shadows
		--Alizabal
		[SpellName(104936)] = Defaults(), -- Skewer
	--Dragon Soul
	    --Morchok
		[SpellName(103541)] = Defaults(), -- Safe
		[SpellName(103536)] = Defaults(), -- Warning
		[SpellName(103534)] = Defaults(), -- Danger
		[SpellName(108570)] = Defaults(), -- Black Blood of the Earth
		--Warlord Zon'ozz
		[SpellName(103434)] = Defaults(), -- Disrupting Shadows
		--Yor'sahj the Unsleeping
		[SpellName(105171)] = Defaults(), -- Deep Corruption
		--Hagara the Stormbinder
		[SpellName(105465)] = Defaults(), -- Lighting Storm
		[SpellName(104451)] = Defaults(), -- Ice Tomb
		[SpellName(109325)] = Defaults(), -- Frostflake
		[SpellName(105289)] = Defaults(), -- Shattered Ice
		[SpellName(105285)] = Defaults(), -- Target
		--Ultraxion
		[SpellName(109075)] = Defaults(), -- Fading Light
		--Warmaster Blackhorn
		[SpellName(108043)] = Defaults(), -- Sunder Armor
		[SpellName(107558)] = Defaults(), -- Degeneration
		[SpellName(107567)] = Defaults(), -- Brutal Strike
		[SpellName(108046)] = Defaults(), -- Shockwave
		--Spine of Deathwing
		[SpellName(105479)] = Defaults(), -- Searing Plasma
		[SpellName(105490)] = Defaults(), -- Fiery Grip
		[SpellName(106199)] = Defaults(), -- Blood Corruption: Death
		--Madness of Deathwing
		[SpellName(105841)] = Defaults(), -- Degenerative Bite
		[SpellName(106385)] = Defaults(), -- Crush
		[SpellName(106730)] = Defaults(), -- Tetanus
		[SpellName(106444)] = Defaults(), -- Impale
		[SpellName(106794)] = Defaults(), -- Shrapnel (target)
	-- Different
		[SpellName(67479)] = Defaults() -- Annoying
	}
};

--Spells that we want to show the duration backwards
E.ReverseTimer = {
	[92956] = true, -- Sinestra (Wrack)
	[89435] = true, -- Sinestra (Wrack)
	[92955] = true, -- Sinestra (Wrack)
	[89421] = true, -- Sinestra (Wrack)
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

G.unitframe.buffwatch = { -- Indicator Buffs
	PRIEST = {
		[6788] = ClassBuff(6788, "TOPLEFT", {1, 0, 0}, true), -- Weakened Soul
		[10060] = ClassBuff(10060 , "RIGHT", {227/255, 23/255, 13/255}), -- Power Infusion
		[48066] = ClassBuff(48066, "BOTTOMRIGHT", {0.81, 0.85, 0.1}, true), -- Power Word: Shield
		[48068] = ClassBuff(48068, "BOTTOMLEFT", {0.4, 0.7, 0.2}), -- Renew
		[48111] = ClassBuff(48111, "TOPRIGHT", {0.2, 0.7, 0.2}), -- Prayer of Mending
	},
	DRUID = {
		[48441] = ClassBuff(48441, "TOPRIGHT", {0.8, 0.4, 0.8}), -- Rejuvenation
		[48443] = ClassBuff(48443, "BOTTOMLEFT", {0.2, 0.8, 0.2}), -- Regrowth
		[48451] = ClassBuff(48451, "TOPLEFT", {0.4, 0.8, 0.2}), -- Lifebloom
		[53251] = ClassBuff(53251, "BOTTOMRIGHT", {0.8, 0.4, 0}), -- Wild Growth
	},
	PALADIN = {
		[1038] = ClassBuff(1038, "BOTTOMRIGHT", {238/255, 201/255, 0}, true), -- Hand of Salvation
		[1044] = ClassBuff(1044, "BOTTOMRIGHT", {221/255, 117/255, 0}, true), -- Hand of Freedom
		[6940] = ClassBuff(6940, "BOTTOMRIGHT", {227/255, 23/255, 13/255}, true), -- Hand of Sacrafice
		[10278] = ClassBuff(10278, "BOTTOMRIGHT", {0.2, 0.2, 1}, true), -- Hand of Protection
		[53563] = ClassBuff(53563, "TOPLEFT", {0.7, 0.3, 0.7}), -- Beacon of Light
		[53601] = ClassBuff(53601, "TOPRIGHT", {0.4, 0.7, 0.2}), -- Sacred Shield
	},
	SHAMAN = {
		[16237] = ClassBuff(16237, "BOTTOMLEFT", {0.4, 0.7, 0.2}), -- Ancestral Fortitude
		[49284] = ClassBuff(49284, "TOPRIGHT", {0.2, 0.7, 0.2}), -- Earth Shield
		[52000] = ClassBuff(52000, "BOTTOMRIGHT", {0.7, 0.4, 0}), -- Earth Life
		[61301] = ClassBuff(61301, "TOPLEFT", {0.7, 0.3, 0.7}), -- Riptide
	},
	ROGUE = {
		[57933] = ClassBuff(57933, "TOPRIGHT", {227/255, 23/255, 13/255}), -- Tricks of the Trade
	},
	MAGE = {
		[54646] = ClassBuff(54646, "TOPRIGHT", {0.2, 0.2, 1}), -- Focus Magic
	},
	WARRIOR = {
		[3411] = ClassBuff(3411, "TOPRIGHT", {227/255, 23/255, 13/255}), -- Intervene
		[59665] = ClassBuff(59665, "TOPLEFT", {0.2, 0.2, 1}), -- Vigilance
	},
	DEATHKNIGHT = {
		[49016] = ClassBuff(49016, "TOPRIGHT", {227/255, 23/255, 13/255}) -- Hysteria
	},
	HUNTER = {}
};

P["unitframe"]["filters"] = {
	["buffwatch"] = {}
};

G.unitframe.ChannelTicks = { -- Ticks
	-- Warlock
	[SpellName(1120)] = 5, -- "Drain Soul"
	[SpellName(689)] = 5, -- "Drain Life"
	[SpellName(5740)] = 4, -- "Rain of Fire"
	[SpellName(755)] = 10, -- "Health Funnel"
	-- Druid
	[SpellName(44203)] = 4, -- "Tranquility"
	[SpellName(16914)] = 10, -- "Hurricane"
	-- Priest
	[SpellName(15407)] = 3, -- "Mind Flay"
	[SpellName(48045)] = 5, -- "Mind Sear"
	[SpellName(47540)] = 3, -- "Penance"
	[SpellName(64901)] = 4, -- "Hymn of Hope"
	[SpellName(64843)] = 4, -- "Divine Hymn"
	-- Mage
	[SpellName(5143)] = 5, -- "Arcane Missiles"
	[SpellName(10)] = 8, -- "Blizzard"
	[SpellName(12051)] = 4 -- "Evocation"
};

G.unitframe.AuraBarColors = {
	[SpellName(2825)] = {r = 250/255, g = 146/255, b = 27/255}, -- Bloodlust
	[SpellName(32182)] = {r = 250/255, g = 146/255, b = 27/255}, -- Heroism
	[SpellName(90355)] = {r = 250/255, g = 146/255, b = 27/255}, -- Ancient Hysteria
	[SpellName(80353)] = {r = 250/255, g = 146/255, b = 27/255} -- Time Warp
};

G.unitframe.InvalidSpells = {
	
};

G.unitframe.DebuffHighlightColors = {
	[SpellName(25771)] = {enable = false, style = "FILL", color = { r = 0.85, g = 0, b = 0, a = 0.85 }}
};

G.oldBuffWatch = {
	PRIEST = {
		ClassBuff(6788, "TOPLEFT", {1, 0, 0}, true), -- Weakened Soul
		ClassBuff(10060 , "RIGHT", {227/255, 23/255, 13/255}), -- Power Infusion
		ClassBuff(48066, "BOTTOMRIGHT", {0.81, 0.85, 0.1}, true), -- Power Word: Shield
		ClassBuff(48068, "BOTTOMLEFT", {0.4, 0.7, 0.2}), -- Renew
		ClassBuff(48111, "TOPRIGHT", {0.2, 0.7, 0.2}), -- Prayer of Mending
	},
	DRUID = {
		ClassBuff(48441, "TOPRIGHT", {0.8, 0.4, 0.8}), -- Rejuvenation
		ClassBuff(48443, "BOTTOMLEFT", {0.2, 0.8, 0.2}), -- Regrowth
		ClassBuff(48451, "TOPLEFT", {0.4, 0.8, 0.2}), -- Lifebloom
		ClassBuff(53251, "BOTTOMRIGHT", {0.8, 0.4, 0}), -- Wild Growth
	},
	PALADIN = {
		ClassBuff(1038, "BOTTOMRIGHT", {238/255, 201/255, 0}, true), -- Hand of Salvation
		ClassBuff(1044, "BOTTOMRIGHT", {221/255, 117/255, 0}, true), -- Hand of Freedom
		ClassBuff(6940, "BOTTOMRIGHT", {227/255, 23/255, 13/255}, true), -- Hand of Sacrafice
		ClassBuff(10278, "BOTTOMRIGHT", {0.2, 0.2, 1}, true), -- Hand of Protection
		ClassBuff(53563, "TOPLEFT", {0.7, 0.3, 0.7}), -- Beacon of Light
		ClassBuff(53601, "TOPRIGHT", {0.4, 0.7, 0.2}), -- Sacred Shield
	},
	SHAMAN = {
		ClassBuff(16237, "BOTTOMLEFT", {0.4, 0.7, 0.2}), -- Ancestral Fortitude
		ClassBuff(49284, "TOPRIGHT", {0.2, 0.7, 0.2}), -- Earth Shield
		ClassBuff(52000, "BOTTOMRIGHT", {0.7, 0.4, 0}), -- Earth Life
		ClassBuff(61301, "TOPLEFT", {0.7, 0.3, 0.7}), -- Riptide
	},
	ROGUE = {
		ClassBuff(57933, "TOPRIGHT", {227/255, 23/255, 13/255}), -- Tricks of the Trade
	},
	MAGE = {
		ClassBuff(54646, "TOPRIGHT", {0.2, 0.2, 1}), -- Focus Magic
	},
	WARRIOR = {
		ClassBuff(3411, "TOPRIGHT", {227/255, 23/255, 13/255}), -- Intervene
		ClassBuff(59665, "TOPLEFT", {0.2, 0.2, 1}), -- Vigilance
	},
	DEATHKNIGHT = {
		ClassBuff(49016, "TOPRIGHT", {227/255, 23/255, 13/255}) -- Hysteria
	}
};