--[[--------------------------------------------------------------------
	Diplomancer
	Automatically sets your watched faction based on your location.
	by Phanx < addons@phanx.net >
	Copyright © 2007–2010 Phanx. Some rights reserved. See LICENSE.txt for details.
	http://www.wowinterface.com/downloads/info9643-Diplomancer.html
	http://wow.curse.com/downloads/wow-addons/details/diplomancer.aspx
----------------------------------------------------------------------]]

local _, race = UnitRace("player") -- arg2 is "Scourge" for Undead players
local isHorde = race == "BloodElf" or race == "Goblin" or race == "Orc" or race == "Scourge" or race == "Tauren" or race == "Troll"
local isAlliance = race == "Draenei" or race == "Dwarf" or race == "Gnome" or race == "Human" or race == "NightElf" or race == "Worgen"

------------------------------------------------------------------------

local CF = {
	[93830] = { 15, "Bilgewater Cartel" },
	[93827] = { 15, "Darkspear Trolls" },
	[93806] = { 15, "Darnassus" },
	[93811] = { 15, "Exodus" },
	[93816] = { 15, "Gilneas" },
	[93821] = { 15, "Gnomeregan" },
	[93806] = { 15, "Gnomeregan" },
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
	[93341] = { 85, "Guardians of Hyjal" },
	[93337] = { 85, "Ramkahen" },
	[93339] = { 85, "The Earthen Ring" },
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
		["Stratholme Past"]            = 1,
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
	["Alterac Valley"]				= isHorde and "Frostwolf Clan" or "Stormpike Guard",
	["Arathi Basin"]				= isHorde and "The Defilers" or "The League of Arathor",
	["Auchenai Crypts"]				= "Lower City",
	["Azuremyst Isle"]				= isAlliance and "Exodar",
	["Black Temple"]				= "Ashtongue Deathsworn",
	["Blackrock Depths"]			= "Thorium Brotherhood",
	["Bloodmyst Isle"]				= isAlliance and "Exodar",
	["Borean Tundra"]				= isHorde and "Warsong Offensive" or "Valiance Expedition",
	["Caverns of Time"]				= "Keepers of Time",
	["Coilfang Reservoir"]			= "Cenarion Expedition",
	["Crystalsong Forest"]			= "Kirin Tor",
	["Dalaran"]						= "Kirin Tor",
	["Darkshore"]					= isAlliance and "Darnassus",
	["Darnassus"]					= isAlliance and "Darnassus",
	["Deepholm"]					= "The Earthen Ring",
	["Dire Maul"]					= "Shen'dralar",
	["Deadwind Pass"]				= "The Violet Eye",
	["Dragonblight"]				= "The Wyrmrest Accord",
	["Dun Morogh"]					= isAlliance and "Ironforge",
	["Durotar"]						= isHorde and "Orgrimmar",
	["Eastern Plaguelands"]			= "Argent Dawn",
	["Elwynn Forest"]				= isAlliance and "Stormwind",
	["Eversong Woods"]				= isHorde and "Silvermoon City",
	["Gates of Ahn'Qiraj"]			= "Cenarion Circle",
	["Ghostlands"]					= isHorde and "Tranquillien",
	["Gilneas"]						= isAlliance and "Gilneas",
	["Grizzly Hills"]				= isHorde and "Warsong Offensive" or "Valiance Expedition",
	["Halls of Reflection"]			= isHorde and "The Sunreavers" or "The Silver Covenant",
	["Hellfire Peninsula"]			= isHorde and "Thrallmar" or "Honor Hold",
	["Hellfire Ramparts"]			= isHorde and "Thrallmar" or "Honor Hold",
	["Howling Fjord"]				= isHorde and "The Hand of Vengeance" or "Valiance Expedition",
	["Hyjal Summit"]				= "The Scale of the Sands",
	["Icecrown"]					= "Knights of the Ebon Blade",
	["Icecrown Citadel"]            = "The Ashen Verdict",
	["Ironforge"]					= isAlliance and "Ironforge",
	["Isle of Quel'Danas"]			= "Shattered Sun Offensive",
	["Karazhan"]					= "The Violet Eye",
	["Kezan"]						= isHorde and "Bilgewater Cartel",
	["Loch Modan"]					= isAlliance and "Ironforge",
	["Magisters' Terrace"]			= "Shattered Sun Offensive",
	["Magtheridon's Lair"]			= isHorde and "Thrallmar" or "Honor Hold",
	["Mana-Tombs"]					= "The Consortium",
	["Molten Core"]					= "Hydraxian Waterlords",
	["Moonglade"]					= "Cenarion Circle",
	["Mulgore"]						= isHorde and "Thunder Bluff",
	["Nagrand"]						= isHorde and "The Mag'har" or "Kurenai",
	["Netherstorm"]					= "The Consortium",
	["Old Hillsbrad Foothills"]		= "Keepers of Time",
	["Orgrimmar"]					= isHorde and "Orgrimmar",
	["Pit of Saron"]				= isHorde and "The Sunreavers" or "The Silver Covenant",
	["Ruins of Ahn'Qiraj"]			= "Cenarion Circle",
	["Scholomance"]					= "Argent Dawn",
	["Serpentshrine Cavern"]		= "Cenarion Expedition",
	["Sethekk Halls"]				= "Lower City",
	["Shadow Labyrinth"]			= "Lower City",
	["Shadowmoon Valley"]			= "Netherwing",
	["Shattrath City"]				= "The Sha'tar",
	["Silithus"]					= "Cenarion Circle",
	["Silvermoon City"]				= isHorde and "Silvermoon City",
	["Stormwind City"]				= isAlliance and "Stormwind",
	["Stratholme"]					= "Argent Dawn",
	["Sunwell Plateau"]				= "Shattered Sun Offensive",
	["Tanaris"]						= "Gadgetzan",
	["Teldrassil"]					= isAlliance and "Darnassus",
	["Tempest Keep"]				= "The Sha'tar",
	["Terokkar Forest"]				= "Lower City",
	["The Arcatraz"]				= "The Sha'tar",
	["The Barrens"]					= isHorde and "Orgrimmar",
	["The Black Morass"]			= "Keepers of Time",
	["The Blood Furnace"]			= isHorde and "Thrallmar" or "Honor Hold",
	["The Botanica"]				= "The Sha'tar",
	["The Exodar"]					= isAlliance and "Exodar",
	["The Eye"]						= "The Sha'tar",
	["The Forge of Souls"]			= isHorde and "The Sunreavers" or "The Silver Covenant",
	["The Mechanar"]				= "The Sha'tar",
	["The Shattered Halls"]			= isHorde and "Thrallmar" or "Honor Hold",
	["Silverpine Forest"]           = isHorde and "Undercity",
	["The Slave Pens"]				= "Cenarion Expedition",
	["The Steamvault"]				= "Cenarion Expedition",
	["The Stonecore"]				= "The Earthen Ring",
	["The Storm Peaks"]				= "The Sons of Hodir",
	["The Underbog"]				= "Cenarion Expedition",
	["Thunder Bluff"]				= isHorde and "Thunder Bluff",
	["Tirisfal Glades"]             = isHorde and "Undercity",
	["Trial of the Crusader"]		= isHorde and "The Sunreavers" or "The Silver Covenant",
	["Twilight Highlands"]			= isHorde and "Dragonmaw Clan" or "Wildhammer Clan",
	["Uldum"]						= "Ramkahen",
	["Undercity"]					= isHorde and "Undercity",
	["Warsong Gulch"]				= isHorde and "Warsong Outriders" or "Silverwing Sentinels",
	["Western Plaguelands"]			= "Argent Dawn",
	["Wetlands"]					= isAlliance and "Ironforge",
	["Winterspring"]				= "Everlook",
	["Zangarmarsh"]					= "Cenarion Expedition",
	["Zul'Drak"]					= "Argent Crusade",
	["Zul'Gurub"]					= "Zandalar Tribe",
}

------------------------------------------------------------------------

local SF = {
	["Azshara"] = {
		["Bay of Storms"]			= "Hydraxian Waterlords",
		["Timbermaw Hold"]			= "Timbermaw Hold",
		["Ursolan"]					= "Timbermaw Hold",
	},
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
		["Taunka'le Village"]		= isHorde and "The Taunka",
		["Transitus Shield"]		= "Kirin Tor",
		["Unu'pe"]					= "The Kalu'ak",
	},
	["Crystalsong Forest"] = {
		["Sunreaver's Command"]		= isHorde and "The Sunreavers",
		["Windrunner's Overlook"]	= isAlliance and "The Silver Covenant",
	},
	["Dalaran"] = {
		["Sunreaver's Sanctuary"]	= isHorde and "The Sunreavers",
		["The Filthy Animal"]		= isHorde and "The Sunreavers",
		["The Silver Enclave"]		= isAlliance and "The Silver Covenant",
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
	["Desolace"] = {
		["Gelkis Village"]			= "Magram Clan Centaur",
		["Magram Village"]			= "Gelkis Clan Centaur",
	},
	["Dragonblight"] = {
		["Light's Trust"]			= "Argent Crusade",
		["Moa'ki Harbor"]			= "The Kalu'ak",
		["Agmar's Hammer"]			= isHorde and "Warsong Offensive",
		["Dragon's Fall"]			= isHorde and "Warsong Offensive",
		["Stars' Rest"]				= isAlliance and "Valiance Expedition",
		["Venomspite"]				= isHorde and "The Hand of Vengeance",
		["Westwind Refugee Camp"]	= isHorde and "The Taunka",
		["Wintergarde Keep"]		= isAlliance and "Valiance Expedition",
	},
	["Durotar"] = {
		["Sen'jin Village"]			= isHorde and "Darkspear Trolls",
	},
	["Eastern Plaguelands"] = {
		["Acherus: The Ebon Hold"]	= "Knights of the Ebon Blade",
	},
	["Felwood"] = {
		["Deadwood Village"]		= "Timbermaw Hold",
		["Felpaw Village"]			= "Timbermaw Hold",
		["Timbermaw Hold"]			= "Timbermaw Hold",
	},
	["Grizzly Hills"] = {
		["Camp Oneqwah"]			= isHorde and "The Taunka",
	},
	["Hellfire Peninsula"] = {
		["Cenarion Post"]			= "Cenarion Expedition",
		["Mag'har Grounds"]			= isHorde and "The Mag'har",
		["Mag'har Post"]			= isHorde and "The Mag'har",
		["Temple of Telhamat"]		= isAlliance and "Kurenai",
		["Throne of Kil'jaeden"]	= "Shattered Sun Offensive",
	},
	["Hillsbrad Foothills"] = {
		["Durnholde Keep"]			= "Ravenholdt",
	},
	["Howling Fjord"] = {
		["Camp Winterhoof"]			  = isHorde and "The Taunka",
		["Explorers' League Outpost"] = isAlliance and "Explorers' League",
		["Kamagua"]					  = "The Kalu'ak",
		["Steel Gate"]				  = isAlliance and "Explorers' League",
	},
	["Icecrown"] = {
		["The Argent Vanguard"]			    = "Argent Crusade",
		["Crusaders' Pinnacle"]			    = "Argent Crusade",
		["Argent Pavilion"]				    = isHorde and "The Sunreavers" or "The Silver Covenant",
		["Argent Tournament Grounds"]	    = isHorde and "The Sunreavers" or "The Silver Covenant",
		["Orgrim's Hammer"]				    = isHorde and "Warsong Offensive",
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
		["The Skybreaker"]				    = isAlliance and "Valiance Expedition",
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
	["Stranglethorn Vale"] = {
		["Booty Bay"]				= "Booty Bay",
		["Salty Sailor Tavern"]		= "Booty Bay",
		["Yojamba Isle"]			= "Zandalar Tribe",
		["Zul'Gurub"]				= "Zandalar Tribe",
	},
	["The Storm Peaks"] = {
		["Camp Tunka'lo"]			= isHorde and "Warsong Offensive",
		["Frostfloe Deep"]			= isHorde and "Warsong Offensive",
		["Frosthold"]				= isAlliance and "The Frostborn",
		["Frosthowl Cavern"]		= isHorde and "Warsong Offensive",
		["Gimorak's Den"]			= isHorde and "Warsong Offensive",
		["Grom'arsh Crash-site"]	= isHorde and "Warsong Offensive",
		["Inventor's Library"]		= isAlliance and "The Frostborn",
		["Howling Hollow"]			= isHorde and "Warsong Offensive",
		["Loken's Bargain"]			= isAlliance and "The Frostborn",
		["Mimir's Workshop"]		= isAlliance and "The Frostborn",
		["Narvir's Cradle"]			= isAlliance and "The Frostborn",
		["Nidavelir"]				= isAlliance and "The Frostborn",
		["Plain of Echoes"]			= isHorde and "Warsong Offensive" or "The Frostborn",
		["Temple of Invention"]		= isAlliance and "The Frostborn",
		["Temple of Life"]			= isHorde and "Warsong Offensive" or "The Frostborn",
		["Temple of Order"]			= isAlliance and "The Frostborn",
		["Temple of Winter"]		= isAlliance and "The Frostborn",
		["The Foot Steppes"]		= isAlliance and "The Frostborn",
	},
	["Tanaris"] = {
		["Caverns of Time"]			= "Keepers of Time",
	},
	["The Barrens"] = {
		["Ratchet"]					= "Ratchet",
	},
	["Terokkar Forest"] = {
		["Blackwind Lake"]			= "Sha'tari Skyguard",
		["Blackwind Landing"]		= "Sha'tari Skyguard",
		["Blackwind Valley"]		= "Sha'tari Skyguard",
		["Lake Ere'noru"]			= "Sha'tari Skyguard",
		["Lower Veil Shil'ak"]		= "Sha'tari Skyguard",
		["Mana Tombs"]				= "The Consortium",
		["Skettis"]					= "Sha'tari Skyguard",
		["Terokk's Rest"]			= "Sha'tari Skyguard",
		["Upper Veil Shil'ak"]		= "Sha'tari Skyguard",
		["Veil Ala'rak"]			= "Sha'tari Skyguard",
		["Veil Harr'ik"]			= "Sha'tari Skyguard",
	},
	["Tirisfal Glades"] = {
		["The Bulwark"]				= "Argent Dawn",
	},
	["Twilight Highlands"] = {
		["Dragonmaw Pass"]			= isHorde and "Bilgewater Cartel",
		["Highbank"]				= isAlliance and "Stormwind",
		["Iso'rath"]				= "The Earthen Ring",
		["Obsidian Forest"]			= isAlliance and "Stormwind",
		["Ring of the Elements"]	= "The Earthen Ring",
		["Ruins of Drakgor"]		= "The Earthen Ring",
		["The Krazzwerks"]			= isHorde and "Bilgewater Cartel",
		["The Maw of Madness"]		= "The Earthen Ring",
		["Victor's Point"]			= isAlliance and "Stormwind",
	},
	["Wetlands"] = {
		["Direforge Hill"]			= isAlliance and "Darnassus",
		["Greenwarden's Grove"]		= isAlliance and "Darnassus",
		["Menethil Harbor"]			= isAlliance and "Stormwind",
		["The Green Belt"]			= isAlliance and "Darnassus",
	},
	["Winterspring"] = {
		["Frostfire Hot Springs"]	= "Timbermaw Hold",
		["Frostsaber Rock"]			= isAlliance and "Wintersaber Trainers",
		["Timbermaw Post"]			= "Timbermaw Hold",
		["Winterfall Village"]		= "Timbermaw Hold",
	},
	["Zangarmarsh"] = {
		["Funggor Cavern"]			= "Sporeggar",
		["Quagg Ridge"]				= "Sporeggar",
		["Sporeggar"]				= "Sporeggar",
		["Swamprat Post"]			= isHorde and "Darkspear Trolls",
		["Telredor"]				= isAlliance and "Exodar",
		["The Spawning Glen"]		= "Sporeggar",
		["Zabra'jin"]				= isHorde and "Darkspear Trolls",
	},
	["Zul'Drak"] = {
		["Ebon Watch"]				= "Knights of the Ebon Blade",
	},
}

------------------------------------------------------------------------

local _, Diplomancer = ...
if not Diplomancer then Diplomancer = _G.Diplomancer end -- WoW China is still running 3.2

function Diplomancer:LocalizeData()
	if self.localized then return end
	-- self:Debug("LocalizeData")

	if GetLocale():match("^en") then
		self.championFactions = CF
		self.championZones = CZ
		self.racialFaction = RF[race]
		self.subzoneFactions = SF
		self.zoneFactions = ZF
	else
		local BF = LibStub and LibStub("LibBabble-Faction-3.0", true) and LibStub("LibBabble-Faction-3.0"):GetLookupTable()
		local BS = LibStub and LibStub("LibBabble-SubZone-3.0", true) and LibStub("LibBabble-SubZone-3.0"):GetLookupTable()
		local BZ = LibStub and LibStub("LibBabble-Zone-3.0", true) and LibStub("LibBabble-Zone-3.0"):GetLookupTable()

		if not BF or not BS or not BZ then
			return print("|cff33ff99Diplomancer|r requires the LibBabble-Faction-3.0 and LibBabble-Zone-3.0 libraries in order to work in your locale. For instructions on how to get these libraries, see the README file in the addon's folder.")
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

		self.subzoneFactions = { }
		for zone, subzones in pairs(SF) do
			self.subzoneFactions[BZ[zone]] = { }
			for subzone, faction in pairs(subzones) do
				if BS[subzone] then
					self.subzoneFactions[BZ[zone]][BS[subzone]] = BF[faction]
				else
					print("|cff33ff99Diplomancer:|r No translation found for subzone", subzone, "in zone", zone)
				end
			end
		end

		self.zoneFactions = { }
		for zone, faction in pairs(ZF) do
			self.zoneFactions[BZ[zone]] = BF[faction]
		end
	end

	CF, CZ, RF, SF, ZF = nil, nil, nil, nil, nil

	self.localized = true
end

------------------------------------------------------------------------