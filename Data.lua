--[[--------------------------------------------------------------------
	Diplomancer
	Automatically sets your watched faction based on your location.
	Copyright (c) 2007-2016 Phanx <addons@phanx.net>. All rights reserved.
	http://www.wowinterface.com/downloads/info9643-Diplomancer.html
	http://www.curse.com/addons/wow/diplomancer
	https://github.com/Phanx/Diplomancer
----------------------------------------------------------------------]]

local _, Diplomancer = ...

function Diplomancer:LocalizeData()
	if self.localized then return end
	-- self:Debug("LocalizeData")

	local H = UnitFactionGroup("player") == "Horde"
	local A = UnitFactionGroup("player") == "Alliance"

------------------------------------------------------------------------

local F = { -- mapping table for sanity
	["Aeda Brightdawn"] = 1740, -- Barracks Bodyguards
	["Alliance Vanguard"] = 1037,
	["Arakkoa Outcasts"] = 1515,
	["Argent Crusade"] = 1106,
	["Argent Dawn"] = 529,
	["Ashtongue Deathsworn"] = 1012,
	["Avengers of Hyjal"] = 1204,
	["Baradin's Wardens"] = 1177,
	["Barracks Bodyguards"] = 1735,
	["Bilgewater Cartel"] = 1133,
	["Bizmo's Brawlpub (Season 1)"] = 1419,
	["Bizmo's Brawlpub"] = 1691,
	["Bloodsail Buccaneers"] = 87,
	["Booty Bay"] = 21,
	["Brawl'gar Arena (Season 1)"] = 1374,
	["Brawl'gar Arena"] = 1690,
	["Brood of Nozdormu"] = 910,
	["Cenarion Circle"] = 609,
	["Cenarion Expedition"] = 942,
	["Chee Chee"] = 1277, -- The Tillers
	["Council of Exarchs"] = 1731,
	["Court of Farondis"] = 1900,
	["Darkmoon Faire"] = 909,
	["Darkspear Rebellion"] = 1440,
	["Darkspear Trolls"] = 530,
	["Darnassus"] = 69,
	["Defender Illona"] = 1738, -- Barracks Bodyguards
	["Delvar Ironfist"] = 1733, -- Barracks Bodyguards
	["Dominance Offensive"] = 1375,
	["Dragonmaw Clan"] = 1172,
	["Dreamweavers"] = 1883,
	["Ella"] = 1275, -- The Tillers
	["Emperor Shaohao"] = 1492,
	["Everlook"] = 577,
	["Exodar"] = 930,
	["Explorers' League"] = 1068,
	["Farmer Fung"] = 1283, -- The Tillers
	["Fish Fellreed"] = 1282, -- The Tillers
	["Forest Hozen"] = 1228,
	["Frenzyheart Tribe"] = 1104,
	["Frostwolf Clan"] = 729,
	["Frostwolf Orcs"] = 1445,
	["Gadgetzan"] = 369,
	["Gelkis Clan Centaur"] = 92,
	["Gilneas"] = 1134,
	["Gina Mudclaw"] = 1281, -- The Tillers
	["Gnomeregan"] = 54,
	["Golden Lotus"] = 1269,
	["Guardians of Hyjal"] = 1158,
	["Hand of the Prophet"] = 1847,
	["Haohan Mudclaw"] = 1279, -- The Tillers
	["Hellscream's Reach"] = 1178,
	["Highmountain Tribe"] = 1828,
	["Honor Hold"] = 946,
	["Horde Expedition"] = 1052,
	["Huojin Pandaren"] = 1352,
	["Hydraxian Waterlords"] = 749,
	["Ironforge"] = 47,
	["Jogu the Drunk"] = 1273, -- The Tillers
	["Keepers of Time"] = 989,
	["Kirin Tor Offensive"] = 1387,
	["Kirin Tor"] = 1090,
	["Knights of the Ebon Blade"] = 1098,
	["Kurenai"] = 978,
	["Laughing Skull Orcs"] = 1708,
	["Leorajh"] = 1741,
	["Lower City"] = 1011,
	["Magram Clan Centaur"] = 93,
	["Nat Pagle"] = 1358, -- The Tilers
	["Netherwing"] = 1015,
	["Nomi"] = 1357,
	["Ogri'la"] = 1038,
	["Old Hillpaw"] = 1276,
	["Operation: Shieldwall"] = 1376,
	["Order of the Awakened"] = 1849,
	["Order of the Cloud Serpent"] = 1271,
	["Orgrimmar"] = 76,
	["Pearlfin Jinyu"] = 1242,
	["Ramkahen"] = 1173,
	["Ratchet"] = 470,
	["Ravenholdt"] = 349,
	["Sha'tari Defense"] = 1710,
	["Sha'tari Skyguard"] = 1031,
	["Shado-Pan Assault"] = 1435,
	["Shado-Pan"] = 1270,
	["Shadowmoon Exiles"] = 1520,
	["Shang Xi's Academy"] = 1216,
	["Shattered Sun Offensive"] = 1077,
	["Shen'dralar"] = 809,
	["Sho"] = 1278, -- The Tillers
	["Silvermoon City"] = 911,
	["Silverwing Sentinels"] = 890,
	["Sporeggar"] = 970,
	["Steamwheedle Draenor Expedition"] = 1732,
	["Steamwheedle Preservation Society"] = 1711,
	["Stormpike Guard"] = 730,
	["Stormwind"] = 72,
	["Sunreaver Onslaught"] = 1388,
	["Syndicate"] = 70,
	["Talonpriest Ishaal"] = 1737, -- Barracks Bodyguards
	["The Aldor"] = 932,
	["The Anglers"] = 1302,
	["The Ashen Verdict"] = 1156,
	["The August Celestials"] = 1341,
	["The Black Prince"] = 1359,
	["The Consortium"] = 933,
	["The Defilers"] = 510,
	["The Earthen Ring"] = 1135,
	["The Frostborn"] = 1126,
	["The Hand of Vengeance"] = 1067,
	["The Kalu'ak"] = 1073,
	["The Klaxxi"] = 1337,
	["The League of Arathor"] = 509,
	["The Lorewalkers"] = 1345,
	["The Mag'har"] = 941,
	["The Nightfallen"] = 1859,
	["The Oracles"] = 1105,
	["The Saberstalkers"] = 1850,
	["The Scale of the Sands"] = 990,
	["The Scryers"] = 934,
	["The Sha'tar"] = 935,
	["The Silver Covenant"] = 1094,
	["The Sons of Hodir"] = 1119,
	["The Sunreavers"] = 1124,
	["The Taunka"] = 1064,
	["The Tillers"] = 1272,
	["The Violet Eye"] = 967,
	["The Wardens"] = 1894,
	["The Wyrmrest Accord"] = 1091,
	["Therazane"] = 1171,
	["Thorium Brotherhood"] = 59,
	["Thrallmar"] = 947,
	["Thunder Bluff"] = 81,
	["Timbermaw Hold"] = 576,
	["Tina Mudclaw"] = 1280,
	["Tormmok"] = 1736, -- Barracks Bodyguards
	["Tranquillien"] = 922,
	["Tushui Pandaren"] = 1353,
	["Undercity"] = 68,
	["Valarjar"] = 1948,
	["Valiance Expedition"] = 1050,
	["Vivianne"] = 1739, -- Barracks Bodyguards
	["Vol'jin's Headhunters"] = 1848,
	["Vol'jin's Spear"] = 1681,
	["Warsong Offensive"] = 1085,
	["Warsong Outriders"] = 889,
	["Wildhammer Clan"] = 1174,
	["Wintersaber Trainers"] = 589,
	["Wrynn's Vanguard"] = 1682,
	["Zandalar Tribe"] = 270,
}

setmetatable(F, { __index = function(F, faction) -- for debugging
	print("|cffffd000Diplomancer:|r Missing faction ID for", faction)
	F[faction] = false
	return false
end })

------------------------------------------------------------------------

local _, race = UnitRace("player") -- arg2 is "Scourge" for Undead players

self.racialFaction = race == "BloodElf" and F["Silvermoon City"]
	or race == "Draenei" and F["Exodar"]
	or race == "Dwarf" and F["Ironforge"]
	or race == "Gnome" and F["Gnomeregan"]
	or race == "Goblin" and F["Bilgewater Cartel"]
	or race == "Human" and F["Stormwind"]
	or race == "NightElf" and F["Darnassus"]
	or race == "Orc" and F["Orgrimmar"]
	or race == "Pandaren" and (H and F["Huojin Pandaren"] or A and F["Tushui Pandaren"] or F["Shang Xi's Academy"])
	or race == "Tauren" and F["Thunder Bluff"]
	or race == "Troll" and F["Darkspear Trolls"]
	or race == "Scourge" and F["Undercity"]
	or race == "Worgen" and F["Gilneas"]

------------------------------------------------------------------------

self.championFactions = {
	[93830]  = { 15, F["Bilgewater Cartel"] },
	[93827]  = { 15, F["Darkspear Trolls"] },
	[93806]  = { 15, F["Darnassus"] },
	[93811]  = { 15, F["Exodar"] },
	[93816]  = { 15, F["Gilneas"] },
	[93821]  = { 15, F["Gnomeregan"] },
	[126436] = { 15, F["Huojin Pandaren"] },
	[93805]  = { 15, F["Ironforge"] },
	[93825]  = { 15, F["Orgrimmar"] },
	[93828]  = { 15, F["Silvermoon City"] },
	[93795]  = { 15, F["Stormwind"] },
	[94463]  = { 15, F["Thunder Bluff"] },
	[126434] = { 15, F["Tushui Pandaren"] },
	[94462]  = { 15, F["Undercity"] },

	[57819]  = { 80, F["Argent Crusade"] },
	[57821]  = { 80, F["Kirin Tor"] },
	[57820]  = { 80, F["Knights of the Ebon Blade"] },
	[57822]  = { 80, F["The Wyrmrest Accord"] },

	[94158]  = { 85, F["Dragonmaw Clan"] },
	[93339]  = { 85, F["The Earthen Ring"] },
	[93341]  = { 85, F["Guardians of Hyjal"] },
	[93337]  = { 85, F["Ramkahen"] },
	[93347]  = { 85, F["Therazane"] },
	[93368]  = { 85, F["Wildhammer Clan"] },
}

self.championZones = {
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
		-- 23: Mythic only
		--  2: Heroic only
		--  1: Normal, Heroic, and Mythic
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
	[90] = {
		[875] = 2, -- Gate of the Setting Sun
		[885] = 1, -- Mogu'Shan Palace
		[871] = 2, -- Scarlet Halls
		[874] = 2, -- Scarlet Monastery
		[898] = 2, -- Scholomance
		[877] = 1, -- Shado-pan Monastery
		[887] = 2, -- Siege of Niuzao Temple
		[876] = 1, -- Stormstout Brewery
		[867] = 1, -- Temple of the Jade Serpent
	},
	[100] = {
		[ 984] = 1, -- Auchindoun
		[ 964] = 1, -- Bloodmaul Slag Mines
		[ 993] = 1, -- Grimrail Depot
		[ 987] = 1, -- Iron Docks
		[ 969] = 1, -- Shadowmoon Burial Grounds
		[ 989] = 1, -- Skyreach
		[1008] = 1, -- The Everbloom
		[ 995] = 1, -- Upper Blackrock Spire
	},
	[110] = {
		[1081] =  1, -- Black Rook Hold
		[1087] = 23, -- Court of Stars
		[1067] =  1, -- Darkheart Thicket
		[1046] =  1, -- Eye of Azshara
		[1041] =  1, -- Halls of Valor
		[1042] =  1, -- Maw of Souls
		[1065] =  1, -- Neltharion's Lair
		[1079] = 23, -- The Arcway
		[1045] =  1, -- Vault of the Wardens
		[1066] =  1, -- Violet Hold
	},
}

------------------------------------------------------------------------

self.zoneFactions = {
-- Abyssal Depths
	[614] = F["The Earthen Ring"],
-- Ahn'kahet: The Old Kingdom
	[524] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
-- Ahn'Qiraj: The Fallen Kingdom
	[772] = F["Brood of Nozdormu"],
-- Alterac Valley
	[401] = H and F["Frostwolf Clan"] or A and F["Stormpike Guard"],
-- Arathi Basin
	[461] = H and F["The Defilers"] or A and F["The League of Arathor"],
-- Arathi Highlands
	[16]  = H and F["Orgrimmar"] or A and F["Stormwind"],
-- Ashenvale
	[43]  = H and F["Warsong Offensive"] or A and F["Darnassus"],
-- Ashran
	[6941] = H and F["Vol'jin's Spear"] or A and F["Wrynn's Vanguard"],
-- Auchenai Crypts
	[722] = F["Lower City"],
-- Auchindoun
	[984] = H and F["Laughing Skull Orcs"] or A and F["Sha'tari Defense"],
-- Azjol-Nerub
	[524] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
-- Azshara
	[181] = H and F["Bilgewater Cartel"],
-- Azsuna
	[1015] = F["Court of Farondis"],
-- Azuremyst Isle
	[464] = A and F["Exodar"],
-- Baradin Hold
	[752] = H and F["Hellscream's Reach"] or A and F["Baradin's Wardens"],
-- Black Temple
	[796] = F["Ashtongue Deathsworn"],
-- Blackrock Depths
	[704] = F["Thorium Brotherhood"],
-- Bloodmaul Slag Mines
	[964] = F["Steamwheedle Preservation Society"],
-- Bloodmyst Isle
	[476] = A and F["Exodar"],
-- Borean Tundra
	[486] = H and F["Warsong Offensive"] or A and F["Valiance Expedition"],
-- Brawl'gar Arena
	[925] = H and F["Brawl'gar Arena"],
-- Camp Narache
	[890] = H and F["Thunder Bluff"],
-- Coldridge Valley
	[866] = A and F["Ironforge"],
-- Crystalsong Forest
	[510] = F["Kirin Tor"],
-- Dalaran (Broken Isles)
	[1014] = F["Kirin Tor"],
-- Dalaran (Northrend)
	[504] = F["Kirin Tor"],
-- Darkmoon Faire
	[823] = F["Darkmoon Faire"],
-- Darkshore
	[42]  = A and F["Darnassus"],
-- Darnassus
	[381] = A and F["Darnassus"],
-- Deepholm
	[640] = F["The Earthen Ring"],
-- Dire Maul
	[699] = F["Shen'dralar"],
-- Deadwind Pass
	[32]  = F["The Violet Eye"],
-- Deathknell
	[892] = H and F["Undercity"],
-- Dragonblight
	[488] = F["The Wyrmrest Accord"],
-- Drak'Tharon Keep
	[524] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
-- Dread Wastes
	[858] = F["The Klaxxi"],
-- Dun Morogh
	[27]  = A and F["Ironforge"],
-- Durotar
	[4]   = H and F["Orgrimmar"],
-- Eastern Plaguelands
	[23]  = F["Argent Dawn"],
-- Echo Isles
	[891] = H and F["Darkspear Trolls"],
-- Elwynn Forest
	[30]  = A and F["Stormwind"],
-- Eversong Woods
	[462] = H and F["Silvermoon City"],
-- Eye of Azshara
	[1096] = F["The Wardens"],
-- Feralas
	[121] = H and F["Thunder Bluff"] or A and F["Darnassus"],
-- Firelands
	[800] = F["Avengers of Hyjal"],
-- Frostfire Ridge
	[941] = H and F["Frostwolf Orcs"],
-- Ghostlands
	[463] = H and F["Tranquillien"],
-- Gilneas
	["545"] = A and F["Gilneas"],
-- Gilneas City
	["611"] = A and F["Gilneas"],
-- Grimrail Depot
	[993] = H and F["Frostwolf Orcs"] or A and F["Council of Exarchs"],
-- Grizzly Hills
	[490] = H and F["Warsong Offensive"] or A and F["Valiance Expedition"],
-- Gundrak
	[524] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
-- Hall of the Guardian
	[1068] = F["Kirin Tor"],
-- Halls of Lightning
	[524] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
-- Halls of Reflection
	[525] = H and F["The Sunreavers"] or A and F["The Silver Covenant"], -- NEEDS CHECK
-- Halls of Stone
	[524] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
-- Hellfire Peninsula
	[465] = H and F["Thrallmar"] or A and F["Honor Hold"],
-- Hellfire Ramparts
	[797] = H and F["Thrallmar"] or A and F["Honor Hold"],
-- Highmountain
	[1024] = F["Highmountain Tribe"],
-- Hillsbrad Foothills
	[24] = H and F["Undercity"],
-- Howling Fjord
	[491] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
-- Hyjal Summit
	[775] = F["The Scale of the Sands"],
-- Icecrown
	[492] = F["Knights of the Ebon Blade"],
-- Icecrown Citadel
	[604] = F["The Ashen Verdict"],
-- Iron Docks
	[987] = H and F["Frostwolf Orcs"] or A and F["Council of Exarchs"],
-- Ironforge
	[341] = A and F["Ironforge"],
-- Isle of Quel'Danas
	[499] = F["Shattered Sun Offensive"],
-- Isle of Thunder
	[928] = H and F["Sunreaver Onslaught"] or A and F["Kirin Tor Offensive"],
-- Karazhan
	[799] = F["The Violet Eye"],
-- Kelp'thar Forest
	[610] = F["The Earthen Ring"],
-- Kezan
	[605] = H and F["Bilgewater Cartel"],
-- Krasarang Wilds
	[857] = F["The Anglers"],
-- Loch Modan
	[35]  = A and F["Ironforge"],
-- Magisters' Terrace
	[798] = F["Shattered Sun Offensive"],
-- Magtheridon's Lair
	[779] = H and F["Thrallmar"] or A and F["Honor Hold"],
-- Mana-Tombs
	[732] = F["The Consortium"],
-- Molten Core
	[696] = F["Hydraxian Waterlords"],
-- Molten Front
	[795] = F["Guardians of Hyjal"],
-- Moonglade
	[241] = F["Cenarion Circle"],
-- Mount Hyjal
	[606] = F["Guardians of Hyjal"],
-- Mulgore
	[9]   = H and F["Thunder Bluff"],
-- Nagrand (Draenor)
	[950] = F["Steamwheedle Preservation Society"],
-- Nagrand (Outland)
	[477] = H and F["The Mag'har"] or A and F["Kurenai"],
-- Netherstorm
	[479] = F["The Consortium"],
-- New Tinkertown
	[895] = A and F["Gnomeregan"],
-- Northern Barrens
	[11]  = H and F["Orgrimmar"] or A and F["Ratchet"],
-- Northshire
	[864] = A and F["Stormwind"],
-- Old Hillsbrad Foothills
	[734] = F["Keepers of Time"],
-- Orgrimmar
	[321] = H and F["Orgrimmar"],
-- Pit of Saron
	[602] = H and F["The Sunreavers"] or A and F["The Silver Covenant"], -- NEEDS CHECK
-- Redridge Mountains
	[36] = A and F["Stormwind"],
-- Ruins of Gilneas
	[684] = H and F["Undercity"] or A and F["Gilneas"],
-- Ruins of Gilneas City
	[685] = H and F["Undercity"] or A and F["Gilneas"],
-- Ruins of Ahn'Qiraj
	[717] = F["Cenarion Circle"],
-- Scholomance
	[763] = F["Argent Dawn"],
-- Serpentshrine Cavern
	[780] = F["Cenarion Expedition"],
-- Sethekk Halls
	[723] = F["Lower City"],
-- Shadow Labyrinth
	[724] = F["Lower City"],
-- Shadowglen
	[888] = F["Darnassus"],
-- Shadowmoon Burial Grounds
	[969] = H and F["Frostwolf Orcs"] or A and F["Council of Exarchs"],
-- Shadowmoon Valley (Draenor)
	[947] = A and F["Council of Exarchs"],
-- Shadowmoon Valley (Outland)
	[473] = F["Netherwing"],
-- Shattrath City
	[481] = F["The Sha'tar"],
-- Shimmering Expanse
	[615] = F["The Earthen Ring"],
-- Sholazar Basin
	[493] = { [F["Frenzyheart Tribe"]] = true, [F["The Oracles"]] = true },
-- Shrine of Seven Stars
	[905] = A and F["The August Celestials"],
-- Shrine of Two Moons
	[903] = H and F["The August Celestials"],
-- Silithus
	[261] = F["Cenarion Circle"],
-- Silvermoon City
	[480] = H and F["Silvermoon City"],
-- Silverpine Forest
	[21]  = H and F["Undercity"] or A and F["Gilneas"],
-- Skyreach
	[989] = F["Arakkoa Outcasts"],
-- Southern Barrens
	[607] = H and F["Orgrimmar"] or A and F["Stormwind"],
-- Spires of Arak
	[948] = F["Arakkoa Outcasts"],
-- Stonetalon Mountains
	[81]  = H and F["Orgrimmar"] or A and F["Darnassus"],
-- Stormheim
	[1017] = F["Valarjar"],
-- Stormshield
	[7332] = H and F["Vol'jin's Spear"] or A and F["Wrynn's Vanguard"],
-- Stormwind City
	[301] = A and F["Stormwind"],
-- Stratholme
	[765] = F["Argent Dawn"],
-- Sunwell Plateau
	[789] = F["Shattered Sun Offensive"],
-- Suramar
	[1033] = F["The Nightfallen"],
-- Talador
	[946] = H and F["Frostwolf Orcs"] or A and F["Council of Exarchs"],
-- Tanaan Jungle
	[945] = H and F["Vol'jin's Headhunters"] or A and F["Hand of the Prophet"],
-- Tanaris
	[161] = F["Gadgetzan"],
-- Teldrassil
	[41]  = A and F["Darnassus"],
-- Tempest Keep
--	[""] = F["The Sha'tar"],
-- Temple of Ahn'Qiraj
	[766] = F["Brood of Nozdormu"],
-- Terokkar Forest
	[478] = F["Lower City"],
-- The Arcatraz
	[731] = F["The Sha'tar"],
-- The Black Morass
	[733] = F["Keepers of Time"],
-- The Blood Furnace
	[725] = H and F["Thrallmar"] or A and F["Honor Hold"],
-- The Botanica
	[729] = F["The Sha'tar"],
-- The Culling of Stratholme
	[524] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
-- The Dreamgrove
	[1077] = F["Cenarion Circle"],
-- The Forge of Souls
	[524] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
-- The Everbloom
	[1008] = H and F["Laughing Skull Orcs"] or A and F["Sha'tari Defense"],
-- The Exodar
	[471] = A and F["Exodar"],
-- The Eye
	[782] = F["The Sha'tar"],
-- The Forge of Souls
	[601] = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
-- The Jade Forest
	[806] = H and F["Forest Hozen"] or A and F["Pearlfin Jinyu"],
-- The Lost Isles
	[544] = H and F["Bilgewater Cartel"],
-- The Maelstrom
	[737] = F["The Earthen Ring"],
-- The Maelstrom (The Heart of Azeroth)
	[1057] = F["The Earthen Ring"],
-- The Mechanar
	[730] = F["The Sha'tar"],
-- The Nexus
	[524] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
-- The Oculus
	[524] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
-- The Shattered Halls
	[710] = H and F["Thrallmar"] or A and F["Honor Hold"],
-- The Slave Pens
	[728] = F["Cenarion Expedition"],
-- The Steamvault
	[727] = F["Cenarion Expedition"],
-- The Stonecore
	[768] = F["The Earthen Ring"],
-- The Storm Peaks
	[495] = F["The Sons of Hodir"],
-- The Underbog
	[726] = F["Cenarion Expedition"],
-- The Violet Hold
	[524] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
-- The Wandering Isle
	[808] = F["Shang Xi's Academy"],
-- Thousand Needles
	[61]  = H and F["Bilgewater Cartel"] or A and F["Gnomeregan"],
-- Throne of Thunder
	[930] = F["Shado-Pan Assault"],
-- Thunder Bluff
	[362] = H and F["Thunder Bluff"],
-- Thunder Totem
	[1080] = F["Highmountain Tribe"],
-- Timeless Isle
	[951] = F["Emperor Shaohao"],
-- Tirisfal Glades
	[20]  = H and F["Undercity"],
-- Tol Barad
	[708] = H and F["Hellscream's Reach"] or A and F["Baradin's Wardens"],
-- Tol Barad Peninsula
	[709] = H and F["Hellscream's Reach"] or A and F["Baradin's Wardens"],
-- Townlong Steppes
	[810] = F["Shado-Pan"],
-- Trial of the Champion
	[524] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
-- Trial of the Crusader
	[543] = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
-- Troves of the Thunder King [SCENARIO]
	[6716] = H and F["Sunreaver Onslaught"] or A and F["Kirin Tor Offensive"],
-- Twilight Highlands
	[700] = H and F["Dragonmaw Clan"] or A and F["Wildhammer Clan"],
-- Uldum
	[720] = F["Ramkahen"],
-- Undercity
	[382] = H and F["Undercity"],
-- Upper Blackrock Spire
	[995] = F["Steamwheedle Preservation Society"],
-- Utgarde Keep
	[523] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
-- Utgarde Pinnacle
	[524] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
-- Val'sharah
	[1018] = F["Dreamweavers"],
-- Vale of Eternal Blossoms
	[811] = F["Golden Lotus"],
-- Valley of the Four Winds
	[807] = F["The Tillers"],
-- Valley of Trials
	[889] = H and F["Orgrimmar"],
-- Warsong Gulch
	[443] = H and F["Warsong Outriders"] or A and F["Silverwing Sentinels"],
-- Warspear
	[7333] = H and F["Vol'jin's Spear"] or A and F["Wrynn's Vanguard"],
-- Western Plaguelands
	[22]  = F["Argent Crusade"],
-- Wetlands
	[40]  = A and F["Ironforge"],
-- Winterspring
	[281] = F["Everlook"],
-- Zangarmarsh
	[467] = F["Cenarion Expedition"],
-- Zul'Drak
	[496] = F["Argent Crusade"],
}

------------------------------------------------------------------------

self.subzoneFactions = {
	-- Arathi Highlands
	[16] = {
		["Faldir's Cove"]             = F["Booty Bay"],
		["Galen's Fall"]              = F["Undercity"],
		["Northfold Manor"]           = F["Ravenholdt"],
		["Stromgarde Keep"]           = F["Ravenholdt"],
		["The Drowned Reef"]          = F["Booty Bay"],
	},
	-- Azsuna
	[1015] = {
		["Isle of the Watchers"]      = F["The Wardens"],
		["Wardens' Redoubt"]          = F["The Wardens"],
		["Watchers' Aerie"]           = F["The Wardens"],
	},
	-- Blade's Edge Mountains
	[475] = {
		["Evergrove"]                 = F["Cenarion Expedition"],
		["Ruuan Weald"]               = F["Cenarion Expedition"],
		["Forge Camp: Terror"]        = F["Ogri'la"],
		["Forge Camp: Wrath"]         = F["Ogri'la"],
		["Furywing's Perch"]          = F["Ogri'la"],
		["Obsidia's Perch"]           = F["Ogri'la"],
		["Ogri'la"]                   = F["Ogri'la"],
		["Rivendark's Perch"]         = F["Ogri'la"],
		["Shartuul's Transporter"]    = F["Ogri'la"],
		["Skyguard Outpost"]          = F["Sha'tari Skyguard"],
		["Vortex Pinnacle"]           = F["Ogri'la"],
		["Vortex Summit"]             = F["Ogri'la"],
	},
	-- Borean Tundra
	[486] = {
		["D.E.H.T.A. Encampment"]     = F["Cenarion Expedition"],
		["Amber Ledge"]               = F["Kirin Tor"],
		["Transitus Shield"]          = F["Kirin Tor"],
		["Kaskala"]                   = F["The Kalu'ak"],
		["Njord's Breath Bay"]        = F["The Kalu'ak"],
		["Unu'pe"]                    = F["The Kalu'ak"],
		["Taunka'le Village"]         = H and F["The Taunka"],
	},
	-- Crystalsong Forest
	[510] = {
		["Sunreaver's Command"]       = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["Windrunner's Overlook"]     = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
	},
	-- Dalaran (Broken Isles)
	[1014] = {
		["A Hero's Welcome"]          = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["Greyfang Enclave"]          = H and F["Undercity"] or A and F["Gilneas"],
		["The Beer Garden"]           = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["The Filthy Animal"]         = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["Windrunner's Sanctuary"]    = H and F["Undercity"] or A and F["Gilneas"],
	},
	-- Dalaran (Northrend)
	[504] = {
		["A Hero's Welcome"]          = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["Sunreaver's Sanctuary"]     = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["The Beer Garden"]           = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["The Filthy Animal"]         = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["The Silver Enclave"]        = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
	},
	-- Deadwind Pass
	[32] = { -- Quest: In the Blink of an Eye
		["A Hero's Welcome"]           = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["Antonidas Memorial"]         = F["Kirin Tor"],
		["Archmage Vargoth's Retreat"] = F["Kirin Tor"],
		["Barbershop"]                 = F["Kirin Tor"],
		["Cartier & Co. Fine Jewelry"] = F["Kirin Tor"],
		["Chamber of the Guardian"]    = F["Kirin Tor"],
		["Curiosities & Moore"]        = F["Kirin Tor"],
		["Dalaran Merchant's Bank"]    = F["Kirin Tor"],
		["Dalaran Visitor Center"]     = F["Kirin Tor"],
		["Dalaran"]                    = F["Kirin Tor"],
		["First to Your Aid"]          = F["Kirin Tor"],
		["Forge of Fate"]              = F["Kirin Tor"],
		["Glorious Goods"]             = F["Kirin Tor"],
		["Krasus' Landing"]            = F["Kirin Tor"],
		["Langrom's Leather & Links"]  = F["Kirin Tor"],
		["Legendary Leathers"]         = F["Kirin Tor"],
		["Like Clockwork"]             = F["Kirin Tor"],
		["Magical Menagerie"]          = F["Kirin Tor"],
		["Magus Commerce Exchange"]    = F["Kirin Tor"],
		["One More Glass"]             = F["Kirin Tor"],
		["Photonic Playground"]        = F["Kirin Tor"],
		["Simply Enchanting"]          = F["Kirin Tor"],
		["Spire of the Guardian"]      = F["Kirin Tor"],
		["Sunreaver's Sanctuary"]      = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["Talismanic Textiles"]        = F["Kirin Tor"],
		["Tanks for Everything"]       = F["Kirin Tor"],
		["The Agronomical Apothecary"] = F["Kirin Tor"],
		["The Arsenal Absolute"]       = F["Kirin Tor"],
		["The Bank of Dalaran"]        = F["Kirin Tor"],
		["The Beer Garden"]            = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["The Eventide"]               = F["Kirin Tor"],
		["The Filthy Animal"]          = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["The Hunter's Reach"]         = F["Kirin Tor"],
		["The Legerdemain Lounge"]     = F["Kirin Tor"],
		["The Militant Mystic"]        = F["Kirin Tor"],
		["The Purple Parlor"]          = F["Kirin Tor"],
		["The Scribe's Sacellum"]      = F["Kirin Tor"],
		["The Silver Enclave"]         = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["The Threads of Fate"]        = F["Kirin Tor"],
		["The Violet Citadel"]         = F["Kirin Tor"],
		["The Violet Gate"]            = F["Kirin Tor"],
		["The Violet Hold"]            = F["Kirin Tor"],
		["The Wonderworks"]            = F["Kirin Tor"],
		["Things of the Past"]         = F["Kirin Tor"],
	},
	-- Deepholm
	[640] = {
		["Crimson Expanse"]           = F["Therazane"],
		["Crumbling Depths"]          = F["Therazane"],
		["Fungal Deep"]               = F["Therazane"],
		["Halcyon Egress"]            = F["Therazane"],
		["Lorthuna's Gate"]           = F["Therazane"],
		["Shuddering Spires"]         = F["Therazane"],
		["The Pale Roost"]            = F["Therazane"],
		["Therazane's Throne"]        = F["Therazane"],
		["Twilight Precipice"]        = F["Therazane"],
		["Verlok Stand"]              = F["Therazane"],
	},
	-- Deeprun Tram
	[922] = {
		["Bizmo's Brawlpub"]          = A and F["Bizmo's Brawlpub"],
	},
	-- Dragonblight
	[488] = {
		["Light's Trust"]             = F["Argent Crusade"],
		["Moa'ki Harbor"]             = F["The Kalu'ak"],
		["Agmar's Hammer"]            = H and F["Warsong Offensive"],
		["Dragon's Fall"]             = H and F["Warsong Offensive"],
		["Venomspite"]                = H and F["The Hand of Vengeance"],
		["Westwind Refugee Camp"]     = H and F["The Taunka"],
		["Stars' Rest"]               = A and F["Valiance Expedition"],
		["Wintergarde Keep"]          = A and F["Valiance Expedition"],
	},
	-- Dread Wastes
	[858] = {
		["Lonesome Cove"]             = F["The Anglers"],
		["Shelf of Mazu"]             = F["The Anglers"],
		["Soggy's Gamble"]            = F["The Anglers"],
		["Wreck of the Mist-Hopper"]  = F["The Anglers"],
	},
	-- Durotar
	[4]  = { -- TODO: update
		["Sen'jin Village"]           = H and F["Darkspear Trolls"],
	},
	-- Eastern Plaguelands
	[23]  = { -- TODO: update
		["Acherus: The Ebon Hold"]    = F["Knights of the Ebon Blade"],
	},
	-- Felwood
	[182] = { -- TODO: update
		["Deadwood Village"]          = F["Timbermaw Hold"],
		["Felpaw Village"]            = F["Timbermaw Hold"],
		["Timbermaw Hold"]            = F["Timbermaw Hold"],
	},
	-- Gorgrond
	[949] = {
		["Broken Horn Village"]       = H and F["Laughing Skull Orcs"],
		["Deadmeat's House of Meat"]  = H and F["Laughing Skull Orcs"],
		["Everbloom Wilds"]           = H and F["Laughing Skull Orcs"],
		["The Pit"]                   = H and F["Laughing Skull Orcs"],
	},
	-- Grizzly Hills
	[490] = { -- TODO: add Alliance areas?
		["Camp Oneqwah"]             = H and F["The Taunka"],
	},
	-- Hellfire Peninsula
	[465] = {
		["Cenarion Post"]             = F["Cenarion Expedition"],
		["Throne of Kil'jaeden"]      = F["Shattered Sun Offensive"],
		["Mag'har Grounds"]           = H and F["The Mag'har"],
		["Mag'har Post"]              = H and F["The Mag'har"],
		["Temple of Telhamat"]        = A and F["Kurenai"],
	},
	-- Highmountain
	[1024] = {
		["Cordana's Apex"]            = H and F["Undercity"] or A and F["Gilneas"],
		["Nightwatcher's Perch"]      = H and F["Undercity"] or A and F["Gilneas"],
	},
	-- Hillsbrad Foothills
	[24]  = {
		["Alterac Mountains"]         = H and F["Frostwolf Clan"] or A and F["Stormpike Guard"],
		["Alterac Valley"]            = H and F["Frostwolf Clan"] or A and F["Stormpike Guard"],
		["Azurelode Mine"]            = A and F["Stormwind"],
		["Corrahn's Dagger"]          = H and F["Frostwolf Clan"] or A and F["Stormpike Guard"],
		["Dalaran Crater"]            = F["Kirin Tor"],
		["Gavin's Naze"]              = H and F["Frostwolf Clan"] or A and F["Stormpike Guard"],
		["Purgation Isle"]            = H and F["Frostwolf Clan"] or A and F["Stormpike Guard"],
		["Ravenholdt Manor"]          = F["Ravenholdt"],
		["Sofera's Naze"]             = A and F["Stormwind"],
		["Strahnbrad"]                = F["Ravenholdt"],
		["The Headland"]              = H and F["Frostwolf Clan"] or A and F["Stormpike Guard"],
	},
	-- Howling Fjord
	[491] = {
		["Kamagua"]					      = F["The Kalu'ak"],
		["Camp Winterhoof"]			   = H and F["The Taunka"],
		["Explorers' League Outpost"] = A and F["Explorers' League"],
		["Steel Gate"]				      = A and F["Explorers' League"],
	},
	-- Icecrown
	[492] = {
		["The Argent Vanguard"]         = F["Argent Crusade"],
		["Crusaders' Pinnacle"]         = F["Argent Crusade"],
		["Scourgeholme"]                = F["Argent Crusade"],
		["The Breach"]                  = F["Argent Crusade"],
		["The Pit of Fiends"]           = F["Argent Crusade"],
		["Valley of Echoes"]            = F["Argent Crusade"],
		["Orgrim's Hammer"]             = H and F["Warsong Offensive"],
		["The Skybreaker"]              = A and F["Valiance Expedition"],
		["Argent Pavilion"]             = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["Argent Tournament Grounds"]   = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["Silver Covenant Pavilion"]    = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["Sunreaver Pavilion"]          = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["The Alliance Valiants' Ring"] = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["The Argent Valiants' Ring"]   = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["The Aspirants' Ring"]         = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["The Horde Valiants' Ring"]    = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
		["The Ring of Champions"]       = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
	},
	-- Krasarang Wilds
	[857] = {
		["Angkhal Pavilion"]         = F["The August Celestials"],
		["Cradle of Chi-Ji"]         = F["The August Celestials"],
		["Dome Balrissa"]            = F["The August Celestials"],
		["Pedestal of Hope"]         = F["The August Celestials"],
		["Temple of the Red Crane"]  = F["The August Celestials"],
		["Dawnchaser Retreat"]       = H and F["Thunder Bluff"],
		["Thunder Cleft"]            = H and F["Thunder Bluff"],
		["Sentinel Basecamp"]        = A and F["Darnassus"],
		["Bilgewater Beach"]         = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
		["Blacksand Spillway"]       = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
		["Domination Point"]         = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
		["Lion's Landing"]           = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
		["Ogregrind's Dig"]          = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
		["Quickchop's Lumber Farm"]  = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
		["Ruins of Ogudei"]          = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
		["Sparkrocket Outpost"]      = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
		["The Boiling Crustacean"]   = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
		["The Skyfire"]              = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
		["The Southern Isles"]       = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
		-- Faction ships don't have a subzone name
		[""]                         = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
	},
	-- Kun-Lai Summit
	[809] = {
		["Gate of the August Celestials"] = F["The August Celestials"],
		["Temple of the White Tiger"]     = F["The August Celestials"],
		["Firebough Nook"]           = F["Shado-Pan"],
		["Serpent's Spine"]          = F["Shado-Pan"],
		["Shado-Li Basin"]           = F["Shado-Pan"],
		["Shado-Pan Fallback"]       = F["Shado-Pan"],
		["Shado-Pan Monastery"]      = F["Shado-Pan"],
		["The Ox Gate"]              = F["Shado-Pan"],
		["Winter's Blossom"]         = F["Shado-Pan"],
	},
	-- Nagrand
	[477] = {
		["Aeris Landing"]            = F["The Consortium"],
		["Oshu'gun"]                 = F["The Consortium"],
		["Spirit Fields"]            = F["The Consortium"],
	},
	-- Netherstorm
	[479] = {
		["Netherwing Ledge"]         = F["Netherwing"],
		["Tempest Keep"]             = F["The Sha'tar"],
	},
	-- Searing Gorge
	[28]  = {
		["Thorium Point"]            = F["Thorium Brotherhood"],
	},
	-- Shadowmoon Valley
	[473] = {
		["Altar of Sha'tar"]         = F["The Aldor"],
		["Sanctum of the Stars"]     = F["The Scryers"],
		["Warden's Cage"]            = F["Ashtongue Deathsworn"],
	},
	-- Shattrath City
	[481] = {
		["Lower City"]               = F["Lower City"],
		["Aldor Rise"]               = F["The Aldor"],
		["Shrine of Unending Light"] = F["The Aldor"],
		["Scryer's Tier"]            = F["The Scryers"],
		["The Seer's Library"]       = F["The Scryers"],
	},
	-- Sholazar Basin
	[493] = {
		["Frenzyheart Hill"]        = F["Frenzyheart Tribe"],
		["Kartak's Hold"]           = F["Frenzyheart Tribe"],
		["Spearborn Encampment"]    = F["Frenzyheart Tribe"],
		["Mistwhisper Refuge"]      = F["The Oracles"],
		["Rainspeaker Canopy"]      = F["The Oracles"],
		["Sparktouched Haven"]      = F["The Oracles"],
	},
	-- Southern Barrens
	[607] = {
		["Firestone Point"]         = F["The Earthen Ring"],
		["Ruins of Taurajo"]        = H and F["Thunder Bluff"],
		["Spearhead"]               = H and F["Thunder Bluff"],
		["Vendetta Point"]          = H and F["Thunder Bluff"],
		["Bael Modan"]              = H and F["Thunder Bluff"] or A and F["Ironforge"],
		["Bael Modan Excavation"]   = H and F["Thunder Bluff"] or A and F["Ironforge"],
		["Bael'dun Keep"]           = H and F["Thunder Bluff"] or A and F["Ironforge"],
		["Frazzlecraz Motherlode"]  = A and F["Ironforge"],
		["Twinbraid's Patrol"]      = A and F["Ironforge"],
	},
	-- Spires of Arak
	[948] = {
		["Pillars of Fate"]         = A and F["Council of Exarchs"],
	},
	-- Stranglethorn Vale
	[689] = { -- TODO: update
		["Booty Bay"]               = F["Booty Bay"],
		["The Salty Sailor Tavern"] = F["Booty Bay"],
	},
	-- Storm Peaks
	[495] = {
		["Camp Tunka'lo"]           = H and F["Warsong Offensive"],
		["Frostfloe Deep"]          = H and F["Warsong Offensive"],
		["Frosthowl Cavern"]        = H and F["Warsong Offensive"],
		["Gimorak's Den"]           = H and F["Warsong Offensive"],
		["Grom'arsh Crash-Site"]    = H and F["Warsong Offensive"],
		["The Howling Hollow"]      = H and F["Warsong Offensive"],
		["Plain of Echoes"]         = H and F["Warsong Offensive"] or A and F["The Frostborn"],
		["Temple of Life"]          = H and F["Warsong Offensive"] or A and F["The Frostborn"],
		["Frosthold"]               = A and F["The Frostborn"],
		["Inventor's Library"]      = A and F["The Frostborn"],
		["Loken's Bargain"]         = A and F["The Frostborn"],
		["Mimir's Workshop"]        = A and F["The Frostborn"],
		["Narvir's Cradle"]         = A and F["The Frostborn"],
		["Nidavelir"]               = A and F["The Frostborn"],
		["Temple of Invention"]     = A and F["The Frostborn"],
		["Temple of Order"]         = A and F["The Frostborn"],
		["Temple of Winter"]        = A and F["The Frostborn"],
		["The Foot Steppes"]        = A and F["The Frostborn"],
	},
	-- Stormheim
	[1017] = {
		["Blackhawk's Bulwark"]     = H and F["Undercity"] or A and F["Gilneas"],
		["Cove of Nashal"]          = H and F["Undercity"] or A and F["Gilneas"],
		["Cullen's Post"]           = H and F["Undercity"] or A and F["Gilneas"],
		["Dreadwake's Landing"]     = H and F["Undercity"] or A and F["Gilneas"],
		["Forsaken Foothold"]       = H and F["Undercity"] or A and F["Gilneas"],
		["Greymane's Offensive"]    = H and F["Undercity"] or A and F["Gilneas"],
		["Greywatch"]               = H and F["Undercity"] or A and F["Gilneas"],
		["Lorna's Watch"]           = H and F["Undercity"] or A and F["Gilneas"],
		["Ranger's Foothold"]       = H and F["Undercity"] or A and F["Gilneas"],
		["Skyfire Triage Camp"]     = H and F["Undercity"] or A and F["Gilneas"],
		["The Oblivion"]            = H and F["Undercity"] or A and F["Gilneas"],
		["Weeping Bluffs"]          = H and F["Undercity"] or A and F["Gilneas"],
		["Whisperwind's Citadel"]   = H and F["Undercity"] or A and F["Gilneas"],
	},
	-- Talador
	[946] = {
		["Terokkar Refuge"]                = F["Arakkoa Outcasts"],
		["Veil Shadar"]                    = F["Arakkoa Outcasts"],
		-- Bladefury Hold
		["Bladefury's Command"]            = A and F["Sha'tari Defense"],
		["The Path of Glory"]              = A and F["Sha'tari Defense"],
		-- Shattrath City
		["Arch of Sha'tar"]                = A and F["Sha'tari Defense"],
		["Beacon of Sha'tar"]              = A and F["Sha'tari Defense"],
		["Caverns of Time"]                = A and F["Sha'tari Defense"],
		["Garden of K'ure"]                = A and F["Sha'tari Defense"],
		["Runeworkers of Shattrath"]       = A and F["Sha'tari Defense"],
		["Sha'tar Way Station"]            = A and F["Sha'tari Defense"],
		["Sha'tari Anchorage"]             = A and F["Sha'tari Defense"],
		["Sha'tari Market District"]       = A and F["Sha'tari Defense"],
		["Sha'tari Skymesa"]               = A and F["Sha'tari Defense"],
		["Shattrath City Center"]          = A and F["Sha'tari Defense"],
		["Shattrath City"]                 = A and F["Sha'tari Defense"],
		["Shattrath Commons"]              = A and F["Sha'tari Defense"],
		["Shattrath Overlook"]             = A and F["Sha'tari Defense"],
		["Shattrath Port Authority"]       = A and F["Sha'tari Defense"],
		["Shattrath Residential District"] = A and F["Sha'tari Defense"],
		["Skymesa Great Hall"]             = A and F["Sha'tari Defense"],
		["Skymesa Palisade"]               = A and F["Sha'tari Defense"],
		["Skymesa Ritual Chamber"]         = A and F["Sha'tari Defense"],
		["Spire of Light"]                 = A and F["Sha'tari Defense"],
	},
	-- Tanaan Jungle
	[945] = {
		["Aktar's Post"]              = F["Arakkoa Outcasts"],
		["Fang'rila"]                 = F["The Saberstalkers"],
		["Blackfang Challenge Arena"] = F["The Saberstalkers"],
		["Rangari Refuge"]            = H and F["Laughing Skull Orcs"] or A and F["Sha'tari Defense"],
	},
	-- Tanaris
	[161] = { -- TODO: update
		["Caverns of Time"]         = F["Keepers of Time"],
	},
	-- Terokkar Forest
	[478] = {
		["Mana Tombs"]              = F["The Consortium"],
		["Blackwind Lake"]          = F["Sha'tari Skyguard"],
		["Blackwind Landing"]       = F["Sha'tari Skyguard"],
		["Blackwind Valley"]        = F["Sha'tari Skyguard"],
		["Lake Ere'Noru"]           = F["Sha'tari Skyguard"],
		["Lower Veil Shil'ak"]      = F["Sha'tari Skyguard"],
		["Skettis"]                 = F["Sha'tari Skyguard"],
		["Terokk's Rest"]           = F["Sha'tari Skyguard"],
		["Upper Veil Shil'ak"]      = F["Sha'tari Skyguard"],
		["Veil Ala'rak"]            = F["Sha'tari Skyguard"],
		["Veil Harr'ik"]            = F["Sha'tari Skyguard"],
	},
	-- The Jade Forest
	[806] = {
		["Fountain of the Everseeing"]  = F["The August Celestials"],
		["Jade Temple Grounds"]         = F["The August Celestials"],
		["Temple of the Jade Serpent"]  = F["The August Celestials"],
		["Terrace of the Twin Dragons"] = F["The August Celestials"],
		["The Heart of Jade"]           = F["The August Celestials"],
		["The Scrollkeeper's Sanctum"]  = F["The August Celestials"],
		["Mistveil Sea"]                = F["Order of the Cloud Serpent"],
		["Oona Kagu"]                   = F["Order of the Cloud Serpent"],
		["Serpent's Heart"]             = F["Order of the Cloud Serpent"],
		["Serpent's Overlook"]          = F["Order of the Cloud Serpent"],
		["The Arboretum"]               = F["Order of the Cloud Serpent"],
		["The Widow's Wail"]            = F["Order of the Cloud Serpent"],
		["Windward Isle"]               = F["Order of the Cloud Serpent"],
	},
	-- The Veiled Stair
	[873] = {
		["Tavern in the Mists"]      = F["The Black Prince"],
	},
	-- Thousand Needles
	[61]  = {
		["Arikara's Needle"]         = H and F["Thunder Bluff"] or A and F["Darnassus"],
		["Darkcloud Pinnacle"]       = H and F["Thunder Bluff"] or A and F["Darnassus"],
		["Freewind Post"]            = H and F["Thunder Bluff"] or A and F["Darnassus"],
	},
	-- Tirisfal Glades
	[20]  = { -- TODO: update
		["The Bulwark"]              = F["Argent Dawn"],
	},
	-- Townlong Steppes
	[810] = {
		["Niuzao Temple"]            = F["The August Celestials"],
	},
	-- Twilight Highlands
	[700] = {
		["Iso'rath"]                 = F["The Earthen Ring"],
		["Ring of the Elements"]     = F["The Earthen Ring"],
		["Ruins of Drakgor"]         = F["The Earthen Ring"],
		["The Maw of Madness"]       = F["The Earthen Ring"],
		["Dragonmaw Pass"]           = H and F["Bilgewater Cartel"],
		["The Krazzworks"]           = H and F["Bilgewater Cartel"],
		["Highbank"]                 = H and F["Bilgewater Cartel"] or A and F["Stormwind"],
		["Obsidian Forest"]          = A and F["Stormwind"],
		["Victor's Point"]           = A and F["Stormwind"],
	},
	-- Val'sharah
	[1018] = {
		["Darkfollow's Spire"]       = H and F["Undercity"] or A and F["Gilneas"],
		["Starstalker's Point"]      = H and F["Undercity"] or A and F["Gilneas"],
	},
	-- Vale of Eternal Blossoms
	[811] = {
		["Gate of the Setting Sun"]  = F["Shado-Pan"],
		["Serpent's Spine"]          = F["Shado-Pan"],
		[""]                         = F["The August Celestials"], -- NEEDS VERIFICATION
		["Mogu'shan Palace"]         = F["The August Celestials"],
		["Seat of Knowledge"]        = F["The Lorewalkers"],
		["The Golden Terrace"]       = H and F["The August Celestials"],
		["The Summer Terrace"]       = A and F["The August Celestials"],
	},
	-- Valley of the Four Winds
	[807] = {
		["Serpent's Spine"]          = F["Shado-Pan"],
	},
	-- Western Plaguelands
	[22]  = { -- TODO: update
		["Andorhal"]                 = A and F["Stormwind"] or F["Undercity"],
		["Chillwind Camp"]           = A and F["Stormwind"],
		["Sorrow Hill"]              = A and F["Stormwind"],
		["Uther's Tomb"]             = A and F["Stormwind"],
	},
	-- Wetlands
	[40]  = { -- TODO: update
		["Direforge Hill"]           = A and F["Darnassus"],
		["Greenwarden's Grove"]      = A and F["Darnassus"],
		["Menethil Harbor"]          = A and F["Stormwind"],
		["The Green Belt"]           = A and F["Darnassus"],
	},
	-- Winterspring
	[281] = { -- TODO: update
		["Frostfire Hot Springs"]    = F["Timbermaw Hold"],
		["Timbermaw Hold"]           = F["Timbermaw Hold"],
		["Timbermaw Post"]           = F["Timbermaw Hold"],
		["Winterfall Village"]       = F["Timbermaw Hold"],
		["Frostsaber Rock"]          = A and F["Wintersaber Trainers"],
	},
	-- Zangarmarsh
	[467] = {
		["Funggor Cavern"]           = F["Sporeggar"],
		["Quagg Ridge"]              = F["Sporeggar"],
		["Sporeggar"]                = F["Sporeggar"],
		["The Spawning Glen"]        = F["Sporeggar"],
		["Swamprat Post"]            = H and F["Darkspear Trolls"],
		["Zabra'jin"]                = H and F["Darkspear Trolls"],
		["Telredor"]                 = A and F["Exodar"],
	},
	-- Zul'Drak
	[496] = {
		["Ebon Watch"]               = F["Knights of the Ebon Blade"],
	},
}

------------------------------------------------------------------------

	-- Remove faction-related false values
	for zone, faction in pairs(self.zoneFactions) do
		if not faction then
			self.zoneFactions[zone] = nil
		end
	end
	for zone, t in pairs(self.subzoneFactions) do
		if type(t) ~= "table" then
			print("BAD DATA IN SUBZONE FACTIONS:", zone, tostring(t))
		else
			for subzone, faction in pairs(t) do
				if not faction then
					t[subzone] = nil
				end
			end
		end
	end

	if not GetLocale():match("^en") then
		local BS = LibStub and LibStub("LibBabble-SubZone-3.0", true) and LibStub("LibBabble-SubZone-3.0"):GetUnstrictLookupTable()
		if BS then
			local SF = {}
			for zone, subzones in pairs(self.subzoneFactions) do
				SF[zone] = {}
				for subzone, faction in pairs(subzones) do
					if faction and BS[subzone] then
						SF[zone][BS[subzone]] = faction
					elseif faction and faction == "" then
						SF[zone][subzone] = faction
					else
						-- print("|cff33ff99Diplomancer:|r LBSZ is missing subzone", zone, "==>", subzone)
					end
				end
			end
			self.subzoneFactions = SF
		else
			print("|cff33ff99Diplomancer|r is running without subzone detection, because the LibBabble-SubZone-3.0 library does not yet provide subzone names for your language. See the download page for more information!")
		end
	end

	self.localized = true
end
