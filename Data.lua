--[[--------------------------------------------------------------------
	Diplomancer
	Automatically sets your watched faction based on your location.
	Copyright (c) 2007-2012 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info9643-Diplomancer.html
	http://www.curse.com/addons/wow/diplomancer
----------------------------------------------------------------------]]

local _, Diplomancer = ...

function Diplomancer:LocalizeData()
	if self.localized then return end
	-- self:Debug("LocalizeData")

	local _, race = UnitRace("player") -- arg2 is "Scourge" for Undead players

	local isHorde = UnitFactionGroup("player") == "Horde"
	local isAlliance = UnitFactionGroup("player") == "Alliance"

------------------------------------------------------------------------

local CF = {
	[93830]  = { 15, "Bilgewater Cartel" },
	[93827]  = { 15, "Darkspear Trolls" },
	[93806]  = { 15, "Darnassus" },
	[93811]  = { 15, "Exodar" },
	[93816]  = { 15, "Gilneas" },
	[93821]  = { 15, "Gnomeregan" },
	[93806]  = { 15, "Gnomeregan" },
	[126436] = { 15, "Huojin Pandaren" },
	[93805]  = { 15, "Ironforge" },
	[93825]  = { 15, "Orgrimmar" },
	[93828]  = { 15, "Silvermoon City" },
	[93795]  = { 15, "Stormwind" },
	[94463]  = { 15, "Thunder Bluff" },
	[126434] = { 15, "Tushui Pandaren" },
	[94462]  = { 15, "Undercity" },

	[57819]  = { 80, "Argent Crusade" },
	[57821]  = { 80, "Kirin Tor" },
	[57820]  = { 80, "Knights of the Ebon Blade" },
	[57822]  = { 80, "The Wyrmrest Accord" },

	[94158]  = { 85, "Dragonmaw Clan" },
	[93339]  = { 85, "The Earthen Ring" },
	[93341]  = { 85, "Guardians of Hyjal" },
	[93337]  = { 85, "Ramkahen" },
	[93347]  = { 85, "Therazane" },
	[93368]  = { 85, "Wildhammer Clan" },
}

local CZ = {
	[70] = {
		-- This list is necessary to exclude Outland dungeons
		-- when championing a home city faction.
		[722] = true, -- Auchenai Crypts
		[797] = true, -- Hellfire Ramparts
		[798] = true, -- Magisters' Terrace
		[732] = true, -- Mana-Tombs
		[734] = true, -- Old Hillsbrad Foothills
		[723] = true, -- Sethekk Halls
		[724] = true, -- Shadow Labyrinth
		[731] = true, -- The Arcatraz
		[733] = true, -- The Black Morass
		[725] = true, -- The Blood Furnace
		[729] = true, -- The Botanica
		[730] = true, -- The Mechanar
		[710] = true, -- The Shattered Halls
		[728] = true, -- The Slave Pens
		[727] = true, -- The Steamvault
		[726] = true, -- The Underbog
	},
	[80] = {
		-- 2: Heroic only
		-- 1: Normal and Heroic
		[522] = 2, -- Ahn'kahet: The Old Kingdom
		[533] = 2, -- Azjol-Nerub
		[534] = 2, -- Drak'Tharon Keep
		[530] = 2, -- Gundrak
		[525] = 1, -- Halls of Lightning
		[603] = 1, -- Halls of Reflection
		[526] = 2, -- Halls of Stone
		[602] = 1, -- Pit of Saron
		[521] = 1, -- The Culling of Stratholme
		[601] = 1, -- The Forge of Souls
		[520] = 2, -- The Nexus
		[528] = 1, -- The Oculus
		[536] = 2, -- The Violet Hold
		[542] = 1, -- Trial of the Champion
		[523] = 2, -- Utgarde Keep
		[524] = 1, -- Utgarde Pinnacle
	},
	[85] = {
		-- 2: Heroic only
		-- 1: Normal and Heroic
		[753] = 2, -- Blackrock Caverns
		[820] = 2, -- End Time
		[757] = 1, -- Grim Batol
		[759] = 1, -- Halls of Origination
		[819] = 2, -- Hour of Twilight
		[747] = 1, -- Lost City of the Tol'vir
		[764] = 2, -- Shadowfang Keep
		[756] = 2, -- The Deadmines
		[768] = 1, -- The Stonecore
		[769] = 1, -- The Vortex Pinnacle
		[767] = 2, -- Throne of the Tides
		[816] = 2, -- Well of Eternity
		[781] = 1, -- Zul'Aman
		[793] = 1, -- Zul'Gurub
	},
}

------------------------------------------------------------------------

local RF = {
	["BloodElf"] = "Silvermoon City",
	["Draenei"]  = "Exodar",
	["Dwarf"]    = "Ironforge",
	["Gnome"]    = "Gnomeregan Exiles",
	["Goblin"]   = "Bilgewater Cartel",
	["Human"]    = "Stormwind City",
	["NightElf"] = "Darnassus",
	["Orc"]      = "Orgrimmar",
	["Pandaren"] = isHorde and "Huojin Pandaren" or isAlliance and "Tushui Pandaren" or "Shang Xi's Academy",
	["Tauren"]   = "Thunder Bluff",
	["Troll"]    = "Darkspear Trolls",
	["Scourge"]  = "Undercity",
	["Worgen"]   = "Gilneas",
}

------------------------------------------------------------------------

local ZF = {
-- Abyssal Depths
	[614] = "The Earthen Ring",
-- Ahn'Qiraj: The Fallen Kingdom
	[772] = "Brood of Nozdormu",
-- Alterac Valley
	[401] = isHorde and "Frostwolf Clan" or isAlliance and "Stormpike Guard",
-- Arathi Basin
	[461] = isHorde and "The Defilers" or isAlliance and "The League of Arathor",
-- Arathi Highlands
	[16]  = isHorde and "Undercity" or isAlliance and "Stormwind",
-- Ashenvale
	[43]  = isHorde and "Warsong Offensive" or isAlliance and "Darnassus",
-- Auchenai Crypts
	[722] = "Lower City",
-- Azshara
	[181] = isHorde and "Bilgewater Cartel",
-- Azuremyst Isle
	[464] = isAlliance and "Exodar",
-- Baradin Hold
	[752] = isHorde and "Hellscream's Reach" or isAlliance and "Baradin's Wardens",
-- Black Temple
	[769] = "Ashtongue Deathsworn",
-- Blackrock Depths
	[704] = "Thorium Brotherhood",
-- Bloodmyst Isle
	[476] = isAlliance and "Exodar",
-- Borean Tundra
	[486] = isHorde and "Warsong Offensive" or isAlliance and "Valiance Expedition",
-- Camp Narache
	[890] = isHorde and "Thunder Bluff",
-- Coldridge Valley
	[866] = isAlliance and "Irongforge",
-- Crystalsong Forest
	[510] = "Kirin Tor",
-- Dalaran
	[504] = "Kirin Tor",
-- Darkmoon Faire
	[823] = "Darkmoon Faire",
-- Darkshore
	[42]  = isAlliance and "Darnassus",
-- Darnassus
	[381] = isAlliance and "Darnassus",
-- Deepholm
	[640] = "The Earthen Ring",
-- Dire Maul
	[699] = "Shen'dralar",
-- Deadwind Pass
	[32]  = "The Violet Eye",
-- Deathknell
	[892] = isHorde and "Undercity",
-- Dragonblight
	[488] = "The Wyrmrest Accord",
-- Dread Wastes
	[858] = "The Klaxxi",
-- Dun Morogh
	[27]  = isAlliance and "Ironforge",
-- Durotar
	[4]   = isHorde and "Orgrimmar",
-- Eastern Plaguelands
	[23]  = "Argent Dawn",
-- Echo Isles
	[891] = isHorde and "Darkspear Trolls",
-- Elwynn Forest
	[30]  = isAlliance and "Stormwind",
-- Eversong Woods
	[462] = isHorde and "Silvermoon City",
-- Feralas
	[121] = isHorde and "Thunder Bluff" or isAlliance and "Darnassus",
-- Firelands
	[800] = "Avengers of Hyjal",
-- Ghostlands
	[463] = isHorde and "Tranquillien",
-- Gilneas
	["545"] = isAlliance and "Gilneas",
-- Gilneas City
	["611"] = isAlliance and "Gilneas",
-- Grizzly Hills
	[490] = isHorde and "Warsong Offensive" or isAlliance and "Valiance Expedition",
-- Halls of Reflection
	[525] = isHorde and "The Sunreavers" or isAlliance and "The Silver Covenant",
-- Hellfire Peninsula
	[465] = isHorde and "Thrallmar" or isAlliance and "Honor Hold",
-- Hellfire Ramparts
	[797] = isHorde and "Thrallmar" or isAlliance and "Honor Hold",
-- Howling Fjord
	[491] = isHorde and "The Hand of Vengeance" or isAlliance and "Valiance Expedition",
-- Hyjal Summit
	[775] = "The Scale of the Sands",
-- Icecrown
	[492] = "Knights of the Ebon Blade",
-- Icecrown Citadel
	[604] = "The Ashen Verdict",
-- Ironforge
	[341] = isAlliance and "Ironforge",
-- Isle of Quel'Danas
	[499] = "Shattered Sun Offensive",
-- Karazhan
	[799] = "The Violet Eye",
-- Kelp'thar Forest
	[610] = "The Earthen Ring",
-- Kezan
	[605] = isHorde and "Bilgewater Cartel",
-- Loch Modan
	[35]  = isAlliance and "Ironforge",
-- Magisters' Terrace
	[798] = "Shattered Sun Offensive",
-- Magtheridon's Lair
	[779] = isHorde and "Thrallmar" or isAlliance and "Honor Hold",
-- Mana-Tombs
	[732] = "The Consortium",
-- Molten Core
	[696] = "Hydraxian Waterlords",
-- Molten Front
	[795] = "Guardians of Hyjal",
-- Moonglade
	[241] = "Cenarion Circle",
-- Mount Hyjal
	[606] = "Guardians of Hyjal",
-- Mulgore
	[9]   = isHorde and "Thunder Bluff",
-- Nagrand
	[477] = isHorde and "The Mag'har" or isAlliance and "Kurenai",
-- Netherstorm
	[479] = "The Consortium",
-- New Tinkertown
	[895] = isAlliance and "Gnomeregan",
-- Northern Barrens
	[11]  = isHorde and "Orgrimmar" or isAlliance and "Ratchet",
-- Northshire
	[864] = isAlliance and "Stormwind",
-- Old Hillsbrad Foothills
	[734] = "Keepers of Time",
-- Orgrimmar
	[321] = isHorde and "Orgrimmar",
-- Pit of Saron
	[602] = isHorde and "The Sunreavers" or isAlliance and "The Silver Covenant",
-- Redridge Mountains
	[36] = isAlliance and "Stormwind",
-- Ruins of Gilneas
	[684] = isAlliance and "Gilneas",
-- Ruins of Gilneas City
	[685] = isAlliance and "Gilneas",
-- Ruins of Ahn'Qiraj
	[717] = "Cenarion Circle",
-- Scholomance
	[763] = "Argent Dawn",
-- Serpentshrine Cavern
	[780] = "Cenarion Expedition",
-- Sethekk Halls
	[723] = "Lower City",
-- Shadow Labyrinth
	[724] = "Lower City",
-- Shadowglen
	[888] = "Shadowglen",
-- Shadowmoon Valley
	[473] = "Netherwing",
-- Shattrath City
	[481] = "The Sha'tar",
-- Shimmering Expanse
	[615] = "The Earthen Ring",
-- Silithus
	[261] = "Cenarion Circle",
-- Silvermoon City
	[480] = isHorde and "Silvermoon City",
-- Silverpine Forest
	[21]  = isHorde and "Undercity",
-- Southern Barrens
	[607] = isHorde and "Orgrimmar" or isAlliance and "Stormwind",
-- Stonetalon Mountains
	[81]  = isHorde and "Orgrimmar" or isAlliance and "Darnassus",
-- Stormwind City
	[301] = isAlliance and "Stormwind",
-- Stratholme
	[765] = "Argent Dawn",
-- Sunwell Plateau
	[789] = "Shattered Sun Offensive",
-- Tanaris
	[161] = "Gadgetzan",
-- Teldrassil
	[41]  = isAlliance and "Darnassus",
-- Tempest Keep
	[""] = "The Sha'tar",
-- Temple of Ahn'Qiraj
	[766] = "Brood of Nozdormu",
-- Terokkar Forest
	[478] = "Lower City",
-- The Arcatraz
	[731] = "The Sha'tar",
-- The Black Morass
	[733] = "Keepers of Time",
-- The Blood Furnace
	[725] = isHorde and "Thrallmar" or isAlliance and "Honor Hold",
-- The Botanica
	[729] = "The Sha'tar",
-- The Exodar
	[471] = isAlliance and "Exodar",
-- The Eye
	[782] = "The Sha'tar",
-- The Forge of Souls
	[601] = isHorde and "The Sunreavers" or isAlliance and "The Silver Covenant",
-- The Jade Forest
	[806] = isHorde and "Forest Hozen" or isAlliance and "Pearlfin Jinyu",
-- The Lost Isles
	[544] = isHorde and "Bilgewater Cartel",
-- The Maelstrom
	[737] = "The Earthen Ring", -- TODO: Remove the continent, maybe?
	[751] = "The Earthen Ring",
-- The Mechanar
	[730] = "The Sha'tar",
-- The Shattered Halls
	[710] = isHorde and "Thrallmar" or isAlliance and "Honor Hold",
-- The Slave Pens
	[728] = "Cenarion Expedition",
-- The Steamvault
	[727] = "Cenarion Expedition",
-- The Stonecore
	[768] = "The Earthen Ring",
-- The Storm Peaks
	[495] = "The Sons of Hodir",
-- The Underbog
	[726] = "Cenarion Expedition",
-- The Wandering Isle
	[808] = "Shang Xi's Academy",
-- Thousand Needles
	[61]  = isHorde and "Bilgewater Cartel" or isAlliance and "Gnomeregan",
-- Thunder Bluff
	[362] = isHorde and "Thunder Bluff",
-- Tirisfal Glades
	[20]  = isHorde and "Undercity",
-- Tol Barad
	[708] = isHorde and "Hellscream's Reach" or isAlliance and "Baradin's Wardens",
-- Tol Barad Peninsula
	[709] = isHorde and "Hellscream's Reach" or isAlliance and "Baradin's Wardens",
-- Townlong Steppes
	[810] = "Shado-Pan",
-- Trial of the Crusader
	[543] = isHorde and "The Sunreavers" or isAlliance and "The Silver Covenant",
-- Twilight Highlands
	[700] = isHorde and "Dragonmaw Clan" or isAlliance and "Wildhammer Clan",
-- Uldum
	[720] = "Ramkahen",
-- Undercity
	[382] = isHorde and "Undercity",
-- Vale of Eternal Blossoms
	[811] = "Golden Lotus",
-- Valley of Trials
	[889] = isHorde and "Orgrimmar",
-- Warsong Gulch
	[443] = isHorde and "Warsong Outriders" or isAlliance and "Silverwing Sentinels",
-- Western Plaguelands
	[22]  = "Argent Crusade",
-- Wetlands
	[40]  = isAlliance and "Ironforge",
-- Winterspring
	[281] = "Everlook",
-- Zangarmarsh
	[467] = "Cenarion Expedition",
-- Zul'Drak
	[496] = "Argent Crusade",

-- Dread Wastes
--	[858] = "",
-- Krasarang Wilds
--	[857] = "",
-- Kun-Lai Summit
--	[809] = "",
-- The Jade Forest
--	[806] = "",
-- Townlong Steppes
--	[810] = "",
-- Vale of Eternal Blossoms
--	[811] = "",
-- Valley of the Four Winds
--	[807] = "",
}

------------------------------------------------------------------------

local SF = {
	-- Blade's Edge Mountains
	[475] = {
		["Evergrove"]				= "Cenarion Expedition",
		["Forge Camp: Terror"]		= "Ogri'la",
		["Forge Camp: Wrath"]		= "Ogri'la",
		["Ogri'la"]					= "Ogri'la",
		["Ruuan Weald"]				= "Cenarion Expedition",
		["Shartuul's Transporter"]	= "Ogri'la",
		["Vortex Pinnacle"]			= "Ogri'la",
	},
	-- Borean Tundra
	[486] = {
		["Amber Ledge"]				= "Kirin Tor",
		["D.E.H.T.A. Encampment"]	= "Cenarion Expedition",
		["Kaskala"]					= "The Kalu'ak",
		["Njord's Breath Bay"]		= "The Kalu'ak",
		["Taunka'le Village"]		= isHorde and "The Taunka",
		["Transitus Shield"]		= "Kirin Tor",
		["Unu'pe"]					= "The Kalu'ak",
	},
	-- Crystalsong Forest
	[510] = {
		["Sunreaver's Command"]		= isHorde and "The Sunreavers",
		["Windrunner's Overlook"]	= isAlliance and "The Silver Covenant",
	},
	-- Dalaran
	[504] = {
		["Sunreaver's Sanctuary"]	= isHorde and "The Sunreavers",
		["The Filthy Animal"]		= isHorde and "The Sunreavers",
		["The Silver Enclave"]		= isAlliance and "The Silver Covenant",
	},
	-- Deepholm
	[640] = {
		["Crimson Expanse"]			= "Therazane",
		["Crumbling Depths"]		= "Therazane",
		["Fungal Deep"]				= "Therazane",
		["Halcyon Egress"]			= "Therazane",
		["Lorthuna's Gate"]			= "Therazane",
		["Shuddering Spires"]		= "Therazane",
		["The Pale Roost"]			= "Therazane",
		["Therazane's Throne"]		= "Therazane",
		["Twilight Precipice"]		= "Therazane",
		["Verlok Stand"]			= "Therazane",
	},
	-- Dragonblight
	[488] = {
		["Light's Trust"]			= "Argent Crusade",
		["Moa'ki Harbor"]			= "The Kalu'ak",
		["Agmar's Hammer"]			= isHorde and "Warsong Offensive",
		["Dragon's Fall"]			= isHorde and "Warsong Offensive",
		["Stars' Rest"]				= isAlliance and "Valiance Expedition",
		["Venomspite"]				= isHorde and "The Hand of Vengeance",
		["Westwind Refugee Camp"]	= isHorde and "The Taunka",
		["Wintergarde Keep"]		= isAlliance and "Valiance Expedition",
	},
	-- Dread Wastes
	[858] = {
		["Lonesome Cove"] = "The Anglers",
		["Shelf of Mazu"] = "The Anglers",
		["Soggy's Gamble"] = "The Anglers",
		["Wreck of the Mist-Hopper"] = "The Anglers",
	},
	-- Durotar
	[4]  = { -- TODO: update
		["Sen'jin Village"]			= isHorde and "Darkspear Trolls",
	},
	-- Eastern Plaguelands
	[23]  = { -- TODO: update
		["Acherus: The Ebon Hold"]	= "Knights of the Ebon Blade",
	},
	-- Felwood
	[182] = { -- TODO: update
		["Deadwood Village"]		= "Timbermaw Hold",
		["Felpaw Village"]			= "Timbermaw Hold",
		["Timbermaw Hold"]			= "Timbermaw Hold",
	},
	-- Grizzly Hills
	[490] = {
		["Camp Oneqwah"]			= isHorde and "The Taunka",
	},
	-- Hellfire Peninsula
	[465] = {
		["Cenarion Post"]			= "Cenarion Expedition",
		["Mag'har Grounds"]			= isHorde and "The Mag'har",
		["Mag'har Post"]			= isHorde and "The Mag'har",
		["Temple of Telhamat"]		= isAlliance and "Kurenai",
		["Throne of Kil'jaeden"]	= "Shattered Sun Offensive",
	},
	-- Hillsbrad Foothills
	[24]  = {
		["Durnholde Keep"]			= "Ravenholdt",
	},
	-- Howling Fjord
	[491] = {
		["Camp Winterhoof"]			  = isHorde and "The Taunka",
		["Explorers' League Outpost"] = isAlliance and "Explorers' League",
		["Kamagua"]					  = "The Kalu'ak",
		["Steel Gate"]				  = isAlliance and "Explorers' League",
	},
	-- Icecrown
	[492] = {
		["The Argent Vanguard"]			    = "Argent Crusade",
		["Crusaders' Pinnacle"]			    = "Argent Crusade",
		["Argent Pavilion"]				    = isHorde and "The Sunreavers" or isAlliance and "The Silver Covenant",
		["Argent Tournament Grounds"]	    = isHorde and "The Sunreavers" or isAlliance and "The Silver Covenant",
		["Orgrim's Hammer"]				    = isHorde and "Warsong Offensive",
		["Scourgeholme"]                    = "Argent Crusade",
		["Silver Covenant Pavilion"]	    = isHorde and "The Sunreavers" or isAlliance and "The Silver Covenant",
		["Sunreaver Pavilion"]			    = isHorde and "The Sunreavers" or isAlliance and "The Silver Covenant",
		["The Alliance Valiants' Ring"]		= isHorde and "The Sunreavers" or isAlliance and "The Silver Covenant",
		["The Argent Valiants' Ring"]	    = isHorde and "The Sunreavers" or isAlliance and "The Silver Covenant",
		["The Aspirants' Ring"]			    = isHorde and "The Sunreavers" or isAlliance and "The Silver Covenant",
		["The Breach"]                      = "Argent Crusade",
		["The Horde Valiants' Ring"]	    = isHorde and "The Sunreavers" or isAlliance and "The Silver Covenant",
		["The Pit of Fiends"]               = "Argent Crusade",
		["The Ring of Champions"]		    = isHorde and "The Sunreavers" or isAlliance and "The Silver Covenant",
		["The Skybreaker"]				    = isAlliance and "Valiance Expedition",
		["Valley of Echoes"]                = "Argent Crusade",
	},
	-- Krasarang Wilds
	[857] = {
		[""] = "The Anglers",
		["Angkhal Pavilion"] = "The August Celestials",
		["Anglers Expedition"] = "The Anglers",
		["Anglers Wharf"] = "The Anglers",
		["Cradle of Chi-Ji"] = "The August Celestials",
		["Dojani River"] = "The Anglers",
		["Dome Balrissa"] = "The August Celestials",
		["Narsong Trench"] = "The Anglers",
		["Pedestal of Hope"] = "The August Celestials",
		["Sandy Shallows"] = "The Anglers",
		["Sarjun Depths"] = "The Anglers",
		["Temple of the Red Crane"] = "The August Celestials",
	},
	-- Kun-Lai Summit
	[809] = {
		["Firebough Nook"] = "Shado-Pan",
		["Gate of the August Celestials"] = "The August Celestials",
		["Serpent's Spine"] = "Shado-Pan",
		["Shado-Li Basin"] = "Shado-Pan",
		["Shado-Pan Fallback"] = "Shado-Pan",
		["Shado-Pan Monastery"] = "Shado-Pan",
		["Temple of the White Tiger"] = "The August Celestials",
		["The Ox Gate"] = "Shado-Pan",
		["Winter's Blossom"] = "Shado-Pan",
	},
	-- Nagrand
	[477] = {
		["Aeris Landing"]			= "The Consortium",
		["Oshu'gun"]				= "The Consortium",
		["Spirit Fields"]			= "The Consortium",
	},
	-- Netherstorm
	[479] = {
		["Netherwing Ledge"]		= "Netherwing",
		["Tempest Keep"]			= "The Sha'tar",
	},
	-- Searing Gorge
	[28]  = {
		["Thorium Point"]			= "Thorium Brotherhood",
	},
	-- Shadowmoon Valley
	[473] = {
		["Altar of Sha'tar"]		= "The Aldor",
		["Sanctum of the Stars"]	= "The Scryers",
		["Warden's Cage"]			= "Ashtongue Deathsworn",
	},
	-- Shattrath City
	[481] = {
		["Aldor Rise"]				= "The Aldor",
		["Lower City"]				= "Lower City",
		["Scryer's Tier"]			= "The Scryers",
		["Shrine of Unending Light"]= "The Aldor",
		["The Seer's Library"]		= "The Scryers",
	},
	-- Sholazar Basin
	[493] = {
		["Frenzyheart Hill"]		= "Frenzyheart Tribe",
		["Kartak's Hold"]			= "Frenzyheart Tribe",
		["Mistwhisper Refuge"]		= "The Oracles",
		["Rainspeaker Canopy"]		= "The Oracles",
		["Sparktouched Haven"]		= "The Oracles",
		["Spearborn Encampment"]	= "Frenzyheart Tribe",
	},
	-- Southern Barrens
	[607] = {
		["Bael Modan"]				= isHorde and "Thunder Bluff" or isAlliance and "Ironforge",
		["Bael Modan Excavation"]	= isHorde and "Thunder Bluff" or isAlliance and "Ironforge",
		["Bael'dun Keep"]			= isHorde and "Thunder Bluff" or isAlliance and "Ironforge",
		["Firestone Point"]			= "The Earthen Ring",
		["Frazzlecraz Motherlode"]	= isAlliance and "Ironforge",
		["Ruins of Taurajo"]		= isHorde and "Thunder Bluff",
		["Spearhead"]				= isHorde and "Thunder Bluff",
		["Twinbraid's Patrol"]		= isAlliance and "Ironforge",
		["Vendetta Point"]			= isHorde and "Thunder Bluff",
	},
	-- Stranglethorn Vale
	[689] = { -- TODO: update
		["Booty Bay"]				= "Booty Bay",
		["The Salty Sailor Tavern"]	= "Booty Bay",
	},
	-- Storm Peaks
	[495] = {
		["Camp Tunka'lo"]			= isHorde and "Warsong Offensive",
		["Frostfloe Deep"]			= isHorde and "Warsong Offensive",
		["Frosthold"]				= isAlliance and "The Frostborn",
		["Frosthowl Cavern"]		= isHorde and "Warsong Offensive",
		["Gimorak's Den"]			= isHorde and "Warsong Offensive",
		["Grom'arsh Crash-Site"]	= isHorde and "Warsong Offensive",
		["Inventor's Library"]		= isAlliance and "The Frostborn",
		["Loken's Bargain"]			= isAlliance and "The Frostborn",
		["Mimir's Workshop"]		= isAlliance and "The Frostborn",
		["Narvir's Cradle"]			= isAlliance and "The Frostborn",
		["Nidavelir"]				= isAlliance and "The Frostborn",
		["Plain of Echoes"]			= isHorde and "Warsong Offensive" or isAlliance and "The Frostborn",
		["Temple of Invention"]		= isAlliance and "The Frostborn",
		["Temple of Life"]			= isHorde and "Warsong Offensive" or isAlliance and "The Frostborn",
		["Temple of Order"]			= isAlliance and "The Frostborn",
		["Temple of Winter"]		= isAlliance and "The Frostborn",
		["The Foot Steppes"]		= isAlliance and "The Frostborn",
		["The Howling Hollow"]		= isHorde and "Warsong Offensive",
	},
	-- Tanaris
	[161] = { -- TODO: update
		["Caverns of Time"]			= "Keepers of Time",
	},
	-- Terokkar Forest
	[478] = {
		["Blackwind Lake"]			= "Sha'tari Skyguard",
		["Blackwind Landing"]		= "Sha'tari Skyguard",
		["Blackwind Valley"]		= "Sha'tari Skyguard",
		["Lake Ere'Noru"]			= "Sha'tari Skyguard",
		["Lower Veil Shil'ak"]		= "Sha'tari Skyguard",
		["Mana Tombs"]				= "The Consortium",
		["Skettis"]					= "Sha'tari Skyguard",
		["Terokk's Rest"]			= "Sha'tari Skyguard",
		["Upper Veil Shil'ak"]		= "Sha'tari Skyguard",
		["Veil Ala'rak"]			= "Sha'tari Skyguard",
		["Veil Harr'ik"]			= "Sha'tari Skyguard",
	},
	-- The Jade Forest
	[806] = {
		["Fountain of the Everseeing"] = "The August Celestials",
		["Jade Temple Grounds"] = "The August Celestials",
		["Mistveil Sea"] = "Order of the Cloud Serpent",
		["Serpent's Heart"] = "The August Celestials",
		["Serpent's Overlook"] = "The August Celestials",
		["Temple of the Jade Serpent"] = "The August Celestials",
		["Terrace of the Twin Dragons"] = "The August Celestials",
		["The Arboretum"] = "Order of the Cloud Serpent",
		["The Heart of Jade"] = "The August Celestials",
		["The Scrollkeeper's Sanctum"] = "The August Celestials",
		["Windward Isle"] = "Order of the Cloud Serpent",
	},
	-- The Veiled Stair
	[873] = {
		["Tavern in the Mists"] = "The Black Prince",
	},
	-- Thousand Needles
	[61]  = {
		["Arikara's Needle"]		= isHorde and "Thunder Bluff" or isAlliance and "Darnassus",
		["Darkcloud Pinnacle"]		= isHorde and "Thunder Bluff" or isAlliance and "Darnassus",
		["Freewind Post"]			= isHorde and "Thunder Bluff" or isAlliance and "Darnassus",
	},
	-- Tirisfal Glades
	[20]  = { -- TODO: update
		["The Bulwark"]				= "Argent Dawn",
	},
	-- Townlong Steppes
	[810] = {
		["Niuzao Temple"] = "The August Celestials",
	},
	-- Twilight Highlands
	[700] = {
		["Dragonmaw Pass"]			= isHorde and "Bilgewater Cartel",
		["Highbank"]				= isHorde and "Bilgewater Cartel" or isAlliance and "Stormwind",
		["Iso'rath"]				= "The Earthen Ring",
		["Obsidian Forest"]			= isAlliance and "Stormwind",
		["Ring of the Elements"]	= "The Earthen Ring",
		["Ruins of Drakgor"]		= "The Earthen Ring",
		["The Krazzworks"]			= isHorde and "Bilgewater Cartel",
		["The Maw of Madness"]		= "The Earthen Ring",
		["Victor's Point"]			= isAlliance and "Stormwind",
	},
	-- Vale of Eternal Blossoms
	[811] = {
		["Chamber of Enlightenment"] = isAlliance and "The August Celestials",
		["Chamber of Masters"] = isHorde and "The August Celestials",
		["Chamber of Reflection"] = isAlliance and "The August Celestials",
		["Chamber of Wisdom"] = isHorde and "The August Celestials",
		["Ethereal Corridor"] = isAlliance and "The August Celestials",
		["Hall of Secrets"] = isHorde and "The August Celestials",
		["Hall of the Crescent Moon"] = isHorde and "The August Celestials",
		["Hall of Tranquillity"] = isHorde and "The August Celestials",
		["Path of Serenity"] = isAlliance and "The August Celestials",
		["Seat of Knowledge"] = "The Lorewalkers",
		["Summer's Rest"] = isHorde and "The August Celestials",
		["The Celestial Vault"] = isAlliance and "The August Celestials",
		["The Emperor's Step"] = isAlliance and "The August Celestials",
		["The Golden Lantern"] = isAlliance and "The August Celestials",
		["The Golden Terrace"] = isHorde and "The August Celestials",
		["The Imperial Exchange"] = isAlliance and "The August Celestials",
		["The Imperial Mercantile"] = isHorde and "The August Celestials",
		["The Jade Vaults"] = isHorde and "The August Celestials",
		["The Keggary"] = isHorde and "The August Celestials",
		["The Star's Bazaar"] = isAlliance and "The August Celestials",
		["The Summer Terrace"] = isAlliance and "The August Celestials",
	},
	-- Valley of the Four Winds
	[807] = {
		["Cattail Lake"] = "The Tillers",
		["Sunsong Ranch"] = "The Tillers",
		["The Heartland"] = "The Tillers",
	},
	-- Western Plaguelands
	[22]  = { -- TODO: update
		["Andorhal"]				= isAlliance and "Stormwind" or "Undercity",
		["Chillwind Camp"]			= isAlliance and "Stormwind",
		["Sorrow Hill"]				= isAlliance and "Stormwind",
		["Uther's Tomb"]			= isAlliance and "Stormwind",
	},
	-- Wetlands
	[40]  = { -- TODO: update
		["Direforge Hill"]			= isAlliance and "Darnassus",
		["Greenwarden's Grove"]		= isAlliance and "Darnassus",
		["Menethil Harbor"]			= isAlliance and "Stormwind",
		["The Green Belt"]			= isAlliance and "Darnassus",
	},
	-- Winterspring
	[281] = { -- TODO: update
		["Frostfire Hot Springs"]	= "Timbermaw Hold",
		["Frostsaber Rock"]			= isAlliance and "Wintersaber Trainers",
		["Timbermaw Hold"]			= "Timbermaw Hold",
		["Timbermaw Post"]			= "Timbermaw Hold",
		["Winterfall Village"]		= "Timbermaw Hold",
	},
	-- Zangarmarsh
	[467] = {
		["Funggor Cavern"]			= "Sporeggar",
		["Quagg Ridge"]				= "Sporeggar",
		["Sporeggar"]				= "Sporeggar",
		["Swamprat Post"]			= isHorde and "Darkspear Trolls",
		["Telredor"]				= isAlliance and "Exodar",
		["The Spawning Glen"]		= "Sporeggar",
		["Zabra'jin"]				= isHorde and "Darkspear Trolls",
	},
	-- Zul'Drak
	[496] = {
		["Ebon Watch"]				= "Knights of the Ebon Blade",
	},
}

------------------------------------------------------------------------

	-- Remove faction-related false values
	for zone, faction in pairs(ZF) do
		if not faction then
			ZF[zone] = nil
		end
	end
	for zone, t in pairs(SF) do
		for subzone, faction in pairs(t) do
			if not faction then
				t[subzone] = nil
			end
		end
	end

	if GetLocale():match("^en") then
		self.championFactions = CF
		self.championZones = CZ
		self.racialFaction = RF[race]
		self.subzoneFactions = SF
		self.zoneFactions = ZF
	else
		local BF = LibStub and LibStub("LibBabble-Faction-3.0", true) and LibStub("LibBabble-Faction-3.0"):GetUnstrictLookupTable()
		local BS = LibStub and LibStub("LibBabble-SubZone-3.0", true) and LibStub("LibBabble-SubZone-3.0"):GetUnstrictLookupTable()

		if not BF or not BS then
			print("|cff33ff99Diplomancer|r is not yet compatible with your language. See the download page for more information.")
		end

		self.championFactions = { }
		for buff, data in pairs(CF) do
			self.championFactions[buff] = { data[1], BF[data[2]] }
		end

		self.championZones = { }
		for level, data in pairs(CZ) do
			self.championZones[level] = { }
			for zone, info in pairs(data) do
				self.championZones[level][zone] = info
			end
		end

		self.racialFaction = BF[RF[race]]

		self.subzoneFactions = { }
		for zone, subzones in pairs(SF) do
			self.subzoneFactions[zone] = { }
			for subzone, faction in pairs(subzones) do
				if faction and BS[subzone] then
					self.subzoneFactions[zone][BS[subzone]] = BF[faction]
				elseif faction and faction == "" then
					self.subzoneFactions[zone][subzone] = BF[faction]
				else
					-- print("|cff33ff99Diplomancer:|r missing subzone", zone, "==>", subzone)
				end
			end
		end

		self.zoneFactions = { }
		for zone, faction in pairs(ZF) do
			if faction then
				self.zoneFactions[zone] = BF[faction]
			end
		end
	end

	self.localized = true
end