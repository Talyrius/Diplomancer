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
	local isAlliance = not isHorde

------------------------------------------------------------------------

local CF = {
	[93830] = { 15, "Bilgewater Cartel" },
	[93827] = { 15, "Darkspear Trolls" },
	[93806] = { 15, "Darnassus" },
	[93811] = { 15, "Exodar" },
	[93816] = { 15, "Gilneas" },
	[93821] = { 15, "Gnomeregan" },
	[93806] = { 15, "Gnomeregan" },
	[93805] = { 15, "Ironforge" },
	[93825] = { 15, "Orgrimmar" },
	[93828] = { 15, "Silvermoon City" },
	[93795] = { 15, "Stormwind" },
	[94463] = { 15, "Thunder Bluff" },
	[94462] = { 15, "Undercity" },

	[57819] = { 80, "Argent Crusade" },
	[57821] = { 80, "Kirin Tor" },
	[57820] = { 80, "Knights of the Ebon Blade" },
	[57822] = { 80, "The Wyrmrest Accord" },

	[94158] = { 85, "Dragonmaw Clan" },
	[93339] = { 85, "The Earthen Ring" },
	[93341] = { 85, "Guardians of Hyjal" },
	[93337] = { 85, "Ramkahen" },
	[93374] = { 85, "Therazane" },
	[93368] = { 85, "Wildhammer Clan" },
}

local CZ = {
	[70] = {
		-- This list exists because we need to exclude Outland dungeons
		-- when championing a home city faction.
		["Auchenai Crypts"]			= true,
		["Hellfire Ramparts"]		= true,
		["Magisters' Terrace"]		= true,
		["Mana-Tombs"]				= true,
		["Old Hillsbrad Foothills"]	= true,
		["Sethekk Halls"]			= true,
		["Shadow Labyrinth"]		= true,
		["The Arcatraz"]			= true,
		["The Black Morass"]		= true,
		["The Blood Furnace"]		= true,
		["The Botanica"]			= true,
		["The Mechanar"]			= true,
		["The Shattered Halls"]		= true,
		["The Slave Pens"]			= true,
		["The Steamvault"]			= true,
		["The Underbog"]			= true,
	},
	[80] = {
		["Ahn'kahet: The Old Kingdom"] = 2, -- Heroic only
		["Azjol-Nerub"]                = 2,
		["The Culling of Stratholme"]  = 1, -- Normal and Heroic
		["Drak'Tharon Keep"]           = 2,
		["Gundrak"]                    = 2,
		["Halls of Lightning"]         = 1,
		["Halls of Reflection"]        = 1,
		["Halls of Stone"]             = 2,
		["Pit of Saron"]               = 1,
		["The Nexus"]                  = 2,
		["The Oculus"]                 = 1,
		["The Forge of Souls"]         = 1,
		["The Violet Hold"]            = 2,
		["Trial of the Champion"]      = 1,
		["Utgarde Keep"]               = 2,
		["Utgarde Pinnacle"]           = 1,
	},
	[85] = {
		["Blackrock Caverns"]			= 2,
		["Deadmines"]					= 2,
		["Grim Batol"]					= 1,
		["Halls of Origination"]		= 1,
		["Lost City of the Tol'vir"]	= 1,
		["Shadowfang Keep"]				= 2,
		["The Stonecore"]				= 1,
		["The Vortex Pinnacle"]			= 1,
		["Throne of the Tides"]			= 2,
		["Zul'Aman"]					= 1,
		["Zul'Gurub"]					= 1,
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
	["Tauren"]   = "Thunder Bluff",
	["Troll"]    = "Darkspear Trolls",
	["Scourge"]  = "Undercity",
	["Worgen"]   = "Gilneas",
}

------------------------------------------------------------------------

local ZF = {
	["Ahn'Qiraj"]					= "Brood of Nozdormu",
	["Ahn'Qiraj: The Fallen Kingdom"]	= "Brood of Nozdormu",
	["Alterac Valley"]				= isHorde and "Frostwolf Clan" or "Stormpike Guard",
	["Arathi Basin"]				= isHorde and "The Defilers" or "The League of Arathor",
	["Arathi Highlands"]			= isHorde and "Undercity" or "Stormwind",
	["Ashenvale"]					= isHorde and "Warsong Offensive" or "Darnassus",
	["Auchenai Crypts"]				= "Lower City",
	["Azshara"]						= isHorde and "Bilgewater Cartel" or nil,
	["Azuremyst Isle"]				= isAlliance and "Exodar" or nil,
	["Baradin Hold"]				= isHorde and "Hellscream's Reach" or "Baradin's Wardens",
	["Black Temple"]				= "Ashtongue Deathsworn",
	["Blackrock Depths"]			= "Thorium Brotherhood",
	["Bloodmyst Isle"]				= isAlliance and "Exodar" or nil,
	["Borean Tundra"]				= isHorde and "Warsong Offensive" or "Valiance Expedition",
	["Caverns of Time"]				= "Keepers of Time",
	["Coilfang Reservoir"]			= "Cenarion Expedition",
	["Crystalsong Forest"]			= "Kirin Tor",
	["Dalaran"]						= "Kirin Tor",
	["Darkshore"]					= isAlliance and "Darnassus" or nil,
	["Darnassus"]					= isAlliance and "Darnassus" or nil,
	["Deepholm"]					= "The Earthen Ring",
	["Dire Maul"]					= "Shen'dralar",
	["Deadwind Pass"]				= "The Violet Eye",
	["Dragonblight"]				= "The Wyrmrest Accord",
	["Dun Morogh"]					= isAlliance and "Ironforge" or nil,
	["Durotar"]						= isHorde and "Orgrimmar" or nil,
	["Eastern Plaguelands"]			= "Argent Dawn",
	["Elwynn Forest"]				= isAlliance and "Stormwind" or nil,
	["Eversong Woods"]				= isHorde and "Silvermoon City" or nil,
	["Feralas"]						= isHorde and "Thunder Bluff" or "Darnassus",
	["Firelands"]					= "Avengers of Hyjal",
	["Gates of Ahn'Qiraj"]			= "Cenarion Circle",
	["Ghostlands"]					= isHorde and "Tranquillien" or nil,
	["Gilneas"]						= isAlliance and "Gilneas" or nil,
	["Gilneas City"]				= isAlliance and "Gilneas" or nil,
	["Grizzly Hills"]				= isHorde and "Warsong Offensive" or "Valiance Expedition",
	["Halls of Reflection"]			= isHorde and "The Sunreavers" or "The Silver Covenant",
	["Hellfire Peninsula"]			= isHorde and "Thrallmar" or "Honor Hold",
	["Hellfire Ramparts"]			= isHorde and "Thrallmar" or "Honor Hold",
	["Howling Fjord"]				= isHorde and "The Hand of Vengeance" or "Valiance Expedition",
	["Hyjal Summit"]				= "The Scale of the Sands",
	["Icecrown"]					= "Knights of the Ebon Blade",
	["Icecrown Citadel"]            = "The Ashen Verdict",
	["Ironforge"]					= isAlliance and "Ironforge" or nil,
	["Isle of Quel'Danas"]			= "Shattered Sun Offensive",
	["Karazhan"]					= "The Violet Eye",
	["Kezan"]						= isHorde and "Bilgewater Cartel" or nil,
	["Loch Modan"]					= isAlliance and "Ironforge" or nil,
	["Magisters' Terrace"]			= "Shattered Sun Offensive",
	["Magtheridon's Lair"]			= isHorde and "Thrallmar" or "Honor Hold",
	["Mana-Tombs"]					= "The Consortium",
	["Molten Core"]					= "Hydraxian Waterlords",
	["Molten Front"]				= "Guardians of Hyjal",
	["Moonglade"]					= "Cenarion Circle",
	["Mount Hyjal"]					= "Guardians of Hyjal",
	["Mulgore"]						= isHorde and "Thunder Bluff" or nil,
	["Nagrand"]						= isHorde and "The Mag'har" or "Kurenai",
	["Netherstorm"]					= "The Consortium",
	["Northern Barrens"]			= isHorde and "Orgrimmar" or "Ratchet",
	["Old Hillsbrad Foothills"]		= "Keepers of Time",
	["Orgrimmar"]					= isHorde and "Orgrimmar" or nil,
	["Pit of Saron"]				= isHorde and "The Sunreavers" or "The Silver Covenant",
	["Ruins of Gilneas"]			= isAlliance and "Gilneas" or nil,
	["Ruins of Ahn'Qiraj"]			= "Cenarion Circle",
	["Scholomance"]					= "Argent Dawn",
	["Serpentshrine Cavern"]		= "Cenarion Expedition",
	["Sethekk Halls"]				= "Lower City",
	["Shadow Labyrinth"]			= "Lower City",
	["Shadowmoon Valley"]			= "Netherwing",
	["Shattrath City"]				= "The Sha'tar",
	["Silithus"]					= "Cenarion Circle",
	["Silvermoon City"]				= isHorde and "Silvermoon City" or nil,
	["Silverpine Forest"]           = isHorde and "Undercity" or nil,
	["Southern Barrens"]			= isHorde and "Orgrimmar" or "Stormwind",
	["Stonetalon Mountains"]		= isHorde and "Orgrimmar" or "Darnassus",
	["Stormwind City"]				= isAlliance and "Stormwind" or nil,
	["Stratholme"]					= "Argent Dawn",
	["Sunwell Plateau"]				= "Shattered Sun Offensive",
	["Tanaris"]						= "Gadgetzan",
	["Teldrassil"]					= isAlliance and "Darnassus" or nil,
	["Tempest Keep"]				= "The Sha'tar",
	["Terokkar Forest"]				= "Lower City",
	["The Arcatraz"]				= "The Sha'tar",
	["The Black Morass"]			= "Keepers of Time",
	["The Blood Furnace"]			= isHorde and "Thrallmar" or "Honor Hold",
	["The Botanica"]				= "The Sha'tar",
	["The Exodar"]					= isAlliance and "Exodar" or nil,
	["The Eye"]						= "The Sha'tar",
	["The Forge of Souls"]			= isHorde and "The Sunreavers" or "The Silver Covenant",
	["The Lost Isles"]				= isHorde and "Bilgewater Cartel" or nil,
	["The Maelstrom"]				= "The Earthen Ring",
	["The Mechanar"]				= "The Sha'tar",
	["The Shattered Halls"]			= isHorde and "Thrallmar" or "Honor Hold",
	["The Slave Pens"]				= "Cenarion Expedition",
	["The Steamvault"]				= "Cenarion Expedition",
	["The Stonecore"]				= "The Earthen Ring",
	["The Storm Peaks"]				= "The Sons of Hodir",
	["The Underbog"]				= "Cenarion Expedition",
	["The Veiled Sea"]				= isAlliance and "Darnassus" or nil,
	["Thousand Needles"]			= isHorde and "Bilgewater Cartel" or "Gnomeregan",
	["Thunder Bluff"]				= isHorde and "Thunder Bluff" or nil,
	["Tirisfal Glades"]             = isHorde and "Undercity" or nil,
	["Tol Barad"]					= isHorde and "Hellscream's Reach" or "Baradin's Wardens",
	["Tol Barad Peninsula"]			= isHorde and "Hellscream's Reach" or "Baradin's Wardens",
	["Trial of the Crusader"]		= isHorde and "The Sunreavers" or "The Silver Covenant",
	["Twilight Highlands"]			= isHorde and "Dragonmaw Clan" or "Wildhammer Clan",
	["Uldum"]						= "Ramkahen",
	["Undercity"]					= isHorde and "Undercity" or nil,
	["Warsong Gulch"]				= isHorde and "Warsong Outriders" or "Silverwing Sentinels",
	["Western Plaguelands"]			= "Argent Crusade",
	["Wetlands"]					= isAlliance and "Ironforge" or nil,
	["Winterspring"]				= "Everlook",
	["Zangarmarsh"]					= "Cenarion Expedition",
	["Zul'Drak"]					= "Argent Crusade",
}

------------------------------------------------------------------------

local SF = {
	["Blade's Edge Mountains"] = {
		["Evergrove"]				= "Cenarion Expedition",
		["Forge Camp: Terror"]		= "Ogri'la",
		["Forge Camp: Wrath"]		= "Ogri'la",
		["Ogri'la"]					= "Ogri'la",
		["Ruuan Weald"]				= "Cenarion Expedition",
		["Shartuul's Transporter"]	= "Ogri'la",
		["Vortex Pinnacle"]			= "Ogri'la",
	},
	["Borean Tundra"] = {
		["Amber Ledge"]				= "Kirin Tor",
		["D.E.H.T.A. Encampment"]	= "Cenarion Expedition",
		["Kaskala"]					= "The Kalu'ak",
		["Njord's Breath Bay"]		= "The Kalu'ak",
		["Taunka'le Village"]		= isHorde and "The Taunka" or nil,
		["Transitus Shield"]		= "Kirin Tor",
		["Unu'pe"]					= "The Kalu'ak",
	},
	["Crystalsong Forest"] = {
		["Sunreaver's Command"]		= isHorde and "The Sunreavers" or nil,
		["Windrunner's Overlook"]	= isAlliance and "The Silver Covenant" or nil,
	},
	["Dalaran"] = {
		["Sunreaver's Sanctuary"]	= isHorde and "The Sunreavers" or nil,
		["The Filthy Animal"]		= isHorde and "The Sunreavers" or nil,
		["The Silver Enclave"]		= isAlliance and "The Silver Covenant" or nil,
	},
	["Deepholm"] = {
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
	["Dragonblight"] = {
		["Light's Trust"]			= "Argent Crusade",
		["Moa'ki Harbor"]			= "The Kalu'ak",
		["Agmar's Hammer"]			= isHorde and "Warsong Offensive" or nil,
		["Dragon's Fall"]			= isHorde and "Warsong Offensive" or nil,
		["Stars' Rest"]				= isAlliance and "Valiance Expedition" or nil,
		["Venomspite"]				= isHorde and "The Hand of Vengeance" or nil,
		["Westwind Refugee Camp"]	= isHorde and "The Taunka" or nil,
		["Wintergarde Keep"]		= isAlliance and "Valiance Expedition" or nil,
	},
	["Durotar"] = { -- TODO: update
		["Sen'jin Village"]			= isHorde and "Darkspear Trolls" or nil,
	},
	["Eastern Plaguelands"] = { -- TODO: update
		["Acherus: The Ebon Hold"]	= "Knights of the Ebon Blade",
	},
	["Felwood"] = { -- TODO: update
		["Deadwood Village"]		= "Timbermaw Hold",
		["Felpaw Village"]			= "Timbermaw Hold",
		["Timbermaw Hold"]			= "Timbermaw Hold",
	},
	["Grizzly Hills"] = {
		["Camp Oneqwah"]			= isHorde and "The Taunka" or nil,
	},
	["Hellfire Peninsula"] = {
		["Cenarion Post"]			= "Cenarion Expedition",
		["Mag'har Grounds"]			= isHorde and "The Mag'har" or nil,
		["Mag'har Post"]			= isHorde and "The Mag'har" or nil,
		["Temple of Telhamat"]		= isAlliance and "Kurenai" or nil,
		["Throne of Kil'jaeden"]	= "Shattered Sun Offensive",
	},
	["Hillsbrad Foothills"] = {
		["Durnholde Keep"]			= "Ravenholdt",
	},
	["Howling Fjord"] = {
		["Camp Winterhoof"]			  = isHorde and "The Taunka" or nil,
		["Explorers' League Outpost"] = isAlliance and "Explorers' League" or nil,
		["Kamagua"]					  = "The Kalu'ak",
		["Steel Gate"]				  = isAlliance and "Explorers' League" or nil,
	},
	["Icecrown"] = {
		["The Argent Vanguard"]			    = "Argent Crusade",
		["Crusaders' Pinnacle"]			    = "Argent Crusade",
		["Argent Pavilion"]				    = isHorde and "The Sunreavers" or "The Silver Covenant",
		["Argent Tournament Grounds"]	    = isHorde and "The Sunreavers" or "The Silver Covenant",
		["Orgrim's Hammer"]				    = isHorde and "Warsong Offensive" or nil,
		["Scourgeholme"]                    = "Argent Crusade",
		["Silver Covenant Pavilion"]	    = isHorde and "The Sunreavers" or "The Silver Covenant",
		["Sunreaver Pavilion"]			    = isHorde and "The Sunreavers" or "The Silver Covenant",
		["The Alliance Valiants' Ring"]		= isHorde and "The Sunreavers" or "The Silver Covenant",
		["The Argent Valiants' Ring"]	    = isHorde and "The Sunreavers" or "The Silver Covenant",
		["The Aspirants' Ring"]			    = isHorde and "The Sunreavers" or "The Silver Covenant",
		["The Breach"]                      = "Argent Crusade",
		["The Horde Valiants' Ring"]	    = isHorde and "The Sunreavers" or "The Silver Covenant",
		["The Pit of Fiends"]               = "Argent Crusade",
		["The Ring of Champions"]		    = isHorde and "The Sunreavers" or "The Silver Covenant",
		["The Skybreaker"]				    = isAlliance and "Valiance Expedition" or nil,
		["Valley of Echoes"]                = "Argent Crusade",
	},
	["Nagrand"] = {
		["Aeris Landing"]			= "The Consortium",
		["Oshu'gun"]				= "The Consortium",
		["Spirit Fields"]			= "The Consortium",
	},
	["Netherstorm"] = {
		["Netherwing Ledge"]		= "Netherwing",
		["Tempest Keep"]			= "The Sha'tar",
	},
	["Searing Gorge"] = {
		["Thorium Point"]			= "Thorium Brotherhood",
	},
	["Shadowmoon Valley"] = {
		["Altar of Sha'tar"]		= "The Aldor",
		["Sanctum of the Stars"]	= "The Scryers",
		["Warden's Cage"]			= "Ashtongue Deathsworn",
	},
	["Shattrath City"] = {
		["Aldor Rise"]				= "The Aldor",
		["Lower City"]				= "Lower City",
		["Scryer's Tier"]			= "The Scryers",
		["Shrine of Unending Light"]= "The Aldor",
		["The Seer's Library"]		= "The Scryers",
	},
	["Sholazar Basin"] = {
		["Frenzyheart Hill"]		= "Frenzyheart Tribe",
		["Kartak's Hold"]			= "Frenzyheart Tribe",
		["Mistwhisper Refuge"]		= "The Oracles",
		["Rainspeaker Canopy"]		= "The Oracles",
		["Sparktouched Haven"]		= "The Oracles",
		["Spearborn Encampment"]	= "Frenzyheart Tribe",
	},
	["Southern Barrens"] = {
		["Bael Modan"]				= isHorde and "Thunder Bluff" or "Ironforge",
		["Bael Modan Excavation"]	= isHorde and "Thunder Bluff" or "Ironforge",
		["Bael'dun Keep"]			= isHorde and "Thunder Bluff" or "Ironforge",
		["Firestone Point"]			= "The Earthen Ring",
		["Frazzlecraz Motherlode"]	= isAlliance and "Ironforge" or nil,
		["Ruins of Taurajo"]		= isHorde and "Thunder Bluff" or nil,
		["Spearhead"]				= isHorde and "Thunder Bluff" or nil,
		["Twinbraid's Patrol"]		= isAlliance and "Ironforge" or nil,
		["Vendetta Point"]			= isHorde and "Thunder Bluff" or nil,
	},
	["Stranglethorn Vale"] = { -- TODO: update
		["Booty Bay"]				= "Booty Bay",
		["The Salty Sailor Tavern"]	= "Booty Bay",
	},
	["The Storm Peaks"] = {
		["Camp Tunka'lo"]			= isHorde and "Warsong Offensive" or nil,
		["Frostfloe Deep"]			= isHorde and "Warsong Offensive" or nil,
		["Frosthold"]				= isAlliance and "The Frostborn" or nil,
		["Frosthowl Cavern"]		= isHorde and "Warsong Offensive" or nil,
		["Gimorak's Den"]			= isHorde and "Warsong Offensive" or nil,
		["Grom'arsh Crash-Site"]	= isHorde and "Warsong Offensive" or nil,
		["Inventor's Library"]		= isAlliance and "The Frostborn" or nil,
		["Loken's Bargain"]			= isAlliance and "The Frostborn" or nil,
		["Mimir's Workshop"]		= isAlliance and "The Frostborn" or nil,
		["Narvir's Cradle"]			= isAlliance and "The Frostborn" or nil,
		["Nidavelir"]				= isAlliance and "The Frostborn" or nil,
		["Plain of Echoes"]			= isHorde and "Warsong Offensive" or "The Frostborn",
		["Temple of Invention"]		= isAlliance and "The Frostborn" or nil,
		["Temple of Life"]			= isHorde and "Warsong Offensive" or "The Frostborn",
		["Temple of Order"]			= isAlliance and "The Frostborn" or nil,
		["Temple of Winter"]		= isAlliance and "The Frostborn" or nil,
		["The Foot Steppes"]		= isAlliance and "The Frostborn" or nil,
		["The Howling Hollow"]		= isHorde and "Warsong Offensive" or nil,
	},
	["Tanaris"] = { -- TODO: update
		["Caverns of Time"]			= "Keepers of Time",
	},
	["The Barrens"] = { -- TODO: update
		["Ratchet"]					= "Ratchet",
	},
	["Terokkar Forest"] = {
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
	["Tirisfal Glades"] = { -- TODO: update
		["The Bulwark"]				= "Argent Dawn",
	},
	["Thousand Needles"] = {
		["Arikara's Needle"]		= isHorde and "Thunder Bluff" or "Darnassus",
		["Darkcloud Pinnacle"]		= isHorde and "Thunder Bluff" or "Darnassus",
		["Freewind Post"]			= isHorde and "Thunder Bluff" or "Darnassus",
	},
	["Twilight Highlands"] = {
		["Dragonmaw Pass"]			= isHorde and "Bilgewater Cartel" or nil,
		["Highbank"]				= isHorde and "Bilgewater Cartel" or "Stormwind",
		["Iso'rath"]				= "The Earthen Ring",
		["Obsidian Forest"]			= isAlliance and "Stormwind" or nil,
		["Ring of the Elements"]	= "The Earthen Ring",
		["Ruins of Drakgor"]		= "The Earthen Ring",
		["The Krazzworks"]			= isHorde and "Bilgewater Cartel" or nil,
		["The Maw of Madness"]		= "The Earthen Ring",
		["Victor's Point"]			= isAlliance and "Stormwind" or nil,
	},
	["Western Plaguelands"] = { -- TODO: update
		["Andorhal"]				= isAlliance and "Stormwind" or "Undercity",
		["Chillwind Camp"]			= isAlliance and "Stormwind" or nil,
		["Sorrow Hill"]				= isAlliance and "Stormwind" or nil,
		["Uther's Tomb"]			= isAlliance and "Stormwind" or nil,
	},
	["Wetlands"] = { -- TODO: update
		["Direforge Hill"]			= isAlliance and "Darnassus" or nil,
		["Greenwarden's Grove"]		= isAlliance and "Darnassus" or nil,
		["Menethil Harbor"]			= isAlliance and "Stormwind" or nil,
		["The Green Belt"]			= isAlliance and "Darnassus" or nil,
	},
	["Winterspring"] = { -- TODO: update
		["Frostfire Hot Springs"]	= "Timbermaw Hold",
		["Frostsaber Rock"]			= isAlliance and "Wintersaber Trainers" or nil,
		["Timbermaw Hold"]			= "Timbermaw Hold",
		["Timbermaw Post"]			= "Timbermaw Hold",
		["Winterfall Village"]		= "Timbermaw Hold",
	},
	["Zangarmarsh"] = {
		["Funggor Cavern"]			= "Sporeggar",
		["Quagg Ridge"]				= "Sporeggar",
		["Sporeggar"]				= "Sporeggar",
		["Swamprat Post"]			= isHorde and "Darkspear Trolls" or nil,
		["Telredor"]				= isAlliance and "Exodar" or nil,
		["The Spawning Glen"]		= "Sporeggar",
		["Zabra'jin"]				= isHorde and "Darkspear Trolls" or nil,
	},
	["Zul'Drak"] = {
		["Ebon Watch"]				= "Knights of the Ebon Blade",
	},
}

------------------------------------------------------------------------

	if GetLocale():match("^en") then
		self.championFactions = CF
		self.championZones = CZ
		self.racialFaction = RF[race]
		self.subzoneFactions = SF
		self.zoneFactions = ZF
	else
		local BF = LibStub and LibStub("LibBabble-Faction-3.0", true) and LibStub("LibBabble-Faction-3.0"):GetLookupTable()
		local BS = LibStub and LibStub("LibBabble-SubZone-3.0", true) and LibStub("LibBabble-SubZone-3.0"):GetUnstrictLookupTable()
		local BZ = LibStub and LibStub("LibBabble-Zone-3.0", true) and LibStub("LibBabble-Zone-3.0"):GetLookupTable()

		if not BF or not BS or not BZ then
			print("|cff33ff99Diplomancer|r is not yet compatible with your language. See the download page for more information.")
		end

		self.championFactions = { }
		for buff, data in pairs(CF) do
			self.championFactions[GetSpellInfo(buff)] = { data[1], BF[data[2]] }
		end

		self.championZones = { }
		for level, data in pairs(CZ) do
			self.championZones[level] = { }
			for zone, info in pairs(data) do
				self.championZones[level][BZ[zone]] = info
			end
		end

		self.racialFaction = BF[RF[race]]

		self.subzoneFactions = { }
		for zone, subzones in pairs(SF) do
			self.subzoneFactions[BZ[zone]] = { }
			for subzone, faction in pairs(subzones) do
				if BS[subzone] then
					self.subzoneFactions[BZ[zone]][BS[subzone]] = BF[faction]
				else
					-- print("|cff33ff99Diplomancer:|r missing subzone", zone, "==>", subzone)
				end
			end
		end

		self.zoneFactions = { }
		for zone, faction in pairs(ZF) do
			self.zoneFactions[BZ[zone]] = BF[faction]
		end
	end

	self.localized = true
end

------------------------------------------------------------------------