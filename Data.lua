--[[------------------------------------------------------------
	Diplomancer
	Automatically watches the current area's faction.
	by Phanx < addons@phanx.net >
	Copyright ©2007–2009 Alyssa "Phanx" Kinley
	http://www.wowinterface.com/downloads/info9643-Diplomancer.html
	http://wow.curse.com/downloads/wow-addons/details/diplomancer.aspx

	This file provides mapping of zones and subzones to factions.
--------------------------------------------------------------]]
local zones = {
	["Ahn'Qiraj"]				= "Brood of Nozdormu",
	["Blackrock Depths"]		= "Thorium Brotherhood",
	["Dire Maul"]				= "Shen'dralar",
	["Eastern Plaguelands"]		= "Argent Dawn",
	["Gates of Ahn'Qiraj"]		= "Cenarion Circle",
	["Molten Core"]				= "Hydraxian Waterlords",
	["Moonglade"]				= "Cenarion Circle",
	["Ruins of Ahn'Qiraj"]		= "Cenarion Circle",
	["Scholomance"]				= "Argent Dawn",
	["Silithus"]				= "Cenarion Circle",
	["Stratholme"]				= "Argent Dawn",
	["Tanaris"]					= "Gadgetzan",
	["Western Plaguelands"]		= "Argent Dawn",
	["Winterspring"]			= "Everlook",
	["Zul'Gurub"]				= "Zandalar Tribe",

	["Auchenai Crypts"]			= "Lower City",
	["Black Temple"]			= "Ashtongue Deathsworn",
	["Caverns of Time"]			= "Keepers of Time",
	["Coilfang Reservoir"]		= "Cenarion Expedition",
	["Deadwind Pass"]			= "The Violet Eye",
	["Hyjal Summit"]			= "The Scale of the Sands",
	["Isle of Quel'Danas"]		= "Shattered Sun Offensive",
	["Karazhan"]				= "The Violet Eye",
	["Magisters' Terrace"]		= "Shattered Sun Offensive",
	["Mana-Tombs"]				= "The Consortium",
	["Netherstorm"]				= "The Consortium",
	["Old Hillsbrad Foothills"]	= "Keepers of Time",
	["Serpentshrine Cavern"]	= "Cenarion Expedition",
	["Sethekk Halls"]			= "Lower City",
	["Shadow Labyrinth"]		= "Lower City",
	["Shadowmoon Valley"]		= "Netherwing",
	["Shattrath City"]			= "The Sha'tar",
	["Sunwell Plateau"]			= "Shattered Sun Offensive",
	["Tempest Keep"]			= "The Sha'tar",
	["Terokkar Forest"]			= "Lower City",
	["The Arcatraz"]			= "The Sha'tar",
	["The Black Morass"]		= "Keepers of Time",
	["The Botanica"]			= "The Sha'tar",
	["The Eye"]					= "The Sha'tar",
	["The Mechanar"]			= "The Sha'tar",
	["The Slave Pens"]			= "Cenarion Expedition",
	["The Steamvault"]			= "Cenarion Expedition",
	["The Underbog"]			= "Cenarion Expedition",
	["Zangarmarsh"]				= "Cenarion Expedition",

	["Crystalsong Forest"]		= "Kirin Tor",
	["Dalaran"]					= "Kirin Tor",
	["Dragonblight"]			= "The Wyrmrest Accord",
	["Icecrown"]				= "Knights of the Ebon Blade",
	["The Storm Peaks"]			= "The Sons of Hodir",
	["Zul'Drak"]				= "Argent Crusade",
}

local subzones = {
	["Azshara"] = {
		["Bay of Storms"]		= "Hydraxian Waterlords",
		["Timbermaw Hold"]		= "Timbermaw Hold",
		["Ursolan"]				= "Timbermaw Hold",
	},
	["Blade's Edge Mountains"] = {
		["Evergrove"]			= "Cenarion Expedition",
		["Forge Camp: Terror"]	= "Ogri'la",
		["Forge Camp: Wrath"]	= "Ogri'la",
		["Ogri'la"]				= "Ogri'la",
		["Ruuan Weald"]			= "Cenarion Expedition",
		["Shartuul's Transporter"]	= "Ogri'la",
		["Vortex Pinnacle"]		= "Ogri'la",
	},
	["Borean Tundra"] = {
		["Amber Ledge"]			= "Kirin Tor",
		["D.E.H.T.A. Encampment"]= "Cenarion Expedition",
		["Kaskala"]				= "The Kalu'ak",
		["Njord's Breath Bay"]	= "The Kalu'ak",
		["Transitus Shield"]	= "Kirin Tor",
		["Unu'pe"]				= "The Kalu'ak",
	},
	["Crystalsong Forest"] = {
		-- Faction-specific, filled in later
	},
	["Dalaran"] = {
		-- Faction-specific, filled in later
	},
	["Desolace"] = {
		["Gelkis Village"]		= "Magram Clan Centaur",
		["Magram Village"]		= "Gelkis Clan Centaur",
	},
	["Dragonblight"] = {
		["Light's Trust"]		= "Argent Crusade",
		["Moa'ki Harbor"]		= "The Kalu'ak",
	},
	["Durotar"] = {
		-- Faction-specific, filled in later
	},
	["Eastern Plaguelands"] = {
		["Acherus: The Ebon Hold"]	= "Knights of the Ebon Blade",
	},
	["Felwood"] = {
		["Deadwood Village"]	= "Timbermaw Hold",
		["Felpaw Village"]		= "Timbermaw Hold",
		["Timbermaw Hold"]		= "Timbermaw Hold",
	},
	["Grizzly Hills"] = {
		-- Faction-specific, filled in later
	},
	["Hellfire Peninsula"] = {
		["Cenarion Post"]		= "Cenarion Circle",
		["Throne of Kil'jaeden"]= "Shattered Sun Offensive",
	},
	["Howling Fjord"] = {
		["Kamagua"]				= "The Kalu'ak",
	},
	["Icecrown"] = {
		["The Argent Vanguard"]	= "Argent Crusade",
		["Crusaders' Pinnacle"]	= "Argent Crusade",
	},
	["Nagrand"] = {
		["Aeris Landing"]		= "The Consortium",
		["Oshu'gun"]			= "The Consortium",
		["Spirit Fields"]		= "The Consortium",
	},
	["Netherstorm"] = {
		["Netherwing Ledge"]	= "Netherwing",
		["Tempest Keep"]		= "The Sha'tar",
	},
	["Searing Gorge"] = {
		["Thorium Point"]		= "Thorium Brotherhood",
	},
	["Shadowmoon Valley"] = {
		["Altar of Sha'tar"]	= "The Aldor",
		["Sanctum of the Stars"]= "The Scryers",
		["Warden's Cage"]		= "Ashtongue Deathsworn",
	},
	["Shattrath City"] = {
		["Aldor Rise"]			= "The Aldor",
		["Lower City"]			= "Lower City",
		["Scryer's Tier"]		= "The Scryers",
		["Shrine of Unending Light"]	= "The Aldor",
		["The Seer's Library"]	= "The Scryers",
	},
	["Sholazar Basin"] = {
		["Frenzyheart Hill"]	= "Frenzyheart Tribe",
		["Kartak's Hold"]		= "Frenzyheart Tribe",
		["Mistwhisper Refuge"]	= "The Oracles",
		["Rainspeaker Canopy"]	= "The Oracles",
		["Sparktouched Haven"]	= "The Oracles",
		["Spearborn Encampment"]= "Frenzyheart Tribe",
	},
	["Stranglethorn Vale"] = {
		["Booty Bay"]			= "Booty Bay",
		["Salty Sailor Tavern"]	= "Booty Bay",
		["Yojamba Isle"]		= "Zandalar Tribe",
		["Zul'Gurub"]			= "Zandalar Tribe",
	},
	["The Storm Peaks"] = {
		-- Faction-specific, filled in later
	},
	["Tanaris"] = {
		["Caverns of Time"]		= "Keepers of Time",
	},
	["The Barrens"] = {
		["Ratchet"]				= "Ratchet",
	},
	["Terokkar Forest"] = {
		["Blackwind Lake"]		= "Sha'tari Skyguard",
		["Blackwind Landing"]	= "Sha'tari Skyguard",
		["Blackwind Valley"]	= "Sha'tari Skyguard",
		["Lake Ere'noru"]		= "Sha'tari Skyguard",
		["Lower Veil Shil'ak"]	= "Sha'tari Skyguard",
		["Mana Tombs"]			= "The Consortium",
		["Skettis"]				= "Sha'tari Skyguard",
		["Terokk's Rest"]		= "Sha'tari Skyguard",
		["Upper Veil Shil'ak"]	= "Sha'tari Skyguard",
		["Veil Ala'rak"]		= "Sha'tari Skyguard",
		["Veil Harr'ik"]		= "Sha'tari Skyguard",
	},
	["Tirisfal Glades"] = {
		["The Bulwark"]			= "Argent Dawn",
	},
	["Winterspring"] = {
		["Frostfire Hot Springs"]= "Timbermaw Hold",
		["Timbermaw Post"]		= "Timbermaw Hold",
		["Winterfall Village"]	= "Timbermaw Hold",
	},
	["Zangarmarsh"] = {
		["Funggor Cavern"]		= "Sporeggar",
		["Quagg Ridge"]			= "Sporeggar",
		["Sporeggar"]			= "Sporeggar",
		["The Spawning Glen"]	= "Sporeggar",
	},
	["Zul'Drak"] = {
		["Ebon Watch"]			= "Knights of the Ebon Blade",
	},
}

local champions = {
	[GetSpellInfo(57819)]		= "Argent Crusade",
	[GetSpellInfo(57821)]		= "Kirin Tor",
	[GetSpellInfo(57820)]		= "Knights of the Ebon Blade",
	[GetSpellInfo(57822)]		= "The Wyrmrest Accord",
}

local races = {
	-- Faction-specific, filled in later
}

local _, race = UnitRace("player") -- arg2 is "Scourge" for Undead players
if race == "BloodElf" or race == "Orc" or race == "Tauren" or race == "Troll" or race == "Scourge" then
	races["BloodElf"]	= "Silvermoon City"
	races["Orc"]		= "Orgrimmar"
	races["Tauren"]		= "Thunder Bluff"
	races["Troll"]		= "Darkspear Trolls"
	races["Scourge"]	= "Undercity"

	zones["Alterac Valley"]		= "Frostwolf Clan"
	zones["Arathi Basin"]		= "The Defilers"
	zones["Durotar"]			= "Orgrimmar"
	zones["Mulgore"]			= "Thunder Bluff"
	zones["Orgrimmar"]			= "Orgrimmar"
	zones["The Barrens"]		= "Orgrimmar"
	zones["Thunder Bluff"]		= "Thunder Bluff"
	zones["Undercity"]			= "Undercity"
	zones["Warsong Gulch"]		= "Warsong Outriders"

	zones["Eversong Woods"]		= "Silvermoon City"
	zones["Ghostlands"]			= "Tranquillien"
	zones["Hellfire Peninsula"]	= "Thrallmar"
	zones["Hellfire Ramparts"]	= "Thrallmar"
	zones["Magtheridon's Lair"]	= "Thrallmar"
	zones["Nagrand"]			= "The Mag'har"
	zones["Silvermoon City"]	= "Silvermoon City"
	zones["The Blood Furnace"]	= "Thrallmar"
	zones["The Shattered Halls"]= "Thrallmar"

	zones["Borean Tundra"]		= "Warsong Offensive"
	zones["Grizzly Hills"]		= "Warsong Offensive"
	zones["Howling Fjord"]		= "The Hand of Vengeance"
	zones["Trial of the Crusader"]= "The Sunreavers"

	subzones["Durotar"]["Sen'jin Village"]				= "Darkspear Trolls"

	subzones["Hellfire Peninsula"]["Mag'har Grounds"]	= "The Mag'har"
	subzones["Hellfire Peninsula"]["Mag'har Post"]		= "The Mag'har"
	subzones["Zangarmarsh"]["Swamprat Post"]			= "Darkspear Trolls"
	subzones["Zangarmarsh"]["Zabra'jin"]				= "Darkspear Trolls"

	subzones["Borean Tundra"]["Taunka'le Village"]		= "The Taunka"
	subzones["Crystalsong Forest"]["Sunreaver's Command"]	= "The Sunreavers"
	subzones["Dalaran"]["Sunreaver's Sanctuary"]		= "The Sunreavers"
	subzones["Dalaran"]["The Filthy Animal"]			= "The Sunreavers"
	subzones["Dragonblight"]["Agmar's Hammer"]			= "Warsong Offensive"
	subzones["Dragonblight"]["Dragon's Fall"]			= "Warsong Offensive"
	subzones["Dragonblight"]["Venomspite"]				= "The Hand of Vengeance"
	subzones["Dragonblight"]["Westwind Refugee Camp"]	= "The Taunka"
	subzones["Grizzly Hills"]["Camp Oneqwah"]			= "The Taunka"
	subzones["Howling Fjord"]["Camp Winterhoof"]		= "The Taunka"
	subzones["Icecrown"]["Argent Pavilion"]				= "The Sunreavers"
	subzones["Icecrown"]["Argent Tournament Grounds"]	= "The Sunreavers"
	subzones["Icecrown"]["Orgrim's Hammer"]				= "Warsong Offensive"
	subzones["Icecrown"]["Silver Covenant Pavilion"]	= "The Sunreavers"
	subzones["Icecrown"]["Sunreaver Pavilion"]			= "The Sunreavers"
	subzones["Icecrown"]["The Alliance Valiants' Ring"]	= "The Sunreavers"
	subzones["Icecrown"]["The Argent Valiants' Ring"]	= "The Sunreavers"
	subzones["Icecrown"]["The Aspirants' Ring"]			= "The Sunreavers"
	subzones["Icecrown"]["The Horde Valiants' Ring"]	= "The Sunreavers"
	subzones["Icecrown"]["The Ring of Champions"]		= "The Sunreavers"
	subzones["The Storm Peaks"]["Camp Tunka'lo"]		= "Warsong Offensive"
	subzones["The Storm Peaks"]["Frostfloe Deep"]		= "Warsong Offensive"
	subzones["The Storm Peaks"]["Frosthowl Cavern"]		= "Warsong Offensive"
	subzones["The Storm Peaks"]["Gimorak's Den"]		= "Warsong Offensive"
	subzones["The Storm Peaks"]["Grom'arsh Crash-site"]	= "Warsong Offensive"
	subzones["The Storm Peaks"]["Howling Hollow"]		= "Warsong Offensive"
	subzones["The Storm Peaks"]["Temple of Life"]		= "Warsong Offensive"
	subzones["The Storm Peaks"]["The Plain of Echoes"]	= "Warsong Offensive"
else
	races["Draenei"]	= "Exodar"
	races["Dwarf"]		= "Ironforge"
	races["Gnome"]		= "Gnomeregan Exiles"
	races["Human"]		= "Stormwind City"
	races["NightElf"]	= "Darnassus"

	zones["Alterac Valley"]		= "Stormpike Guard"
	zones["Arathi Basin"]		= "The League of Arathor"
	zones["Darnassus"]			= "Darnassus"
	zones["Dun Morogh"]			= "Ironforge"
	zones["Elwynn Forest"]		= "Stormwind"
	zones["Ironforge"]			= "Ironforge"
	zones["Stormwind City"]		= "Stormwind"
	zones["Warsong Gulch"]		= "Silverwing Sentinels"

	zones["Azuremyst Isle"]		= "Exodar"
	zones["The Exodar"]			= "Exodar"
	zones["Hellfire Peninsula"]	= "Honor Hold"
	zones["Hellfire Ramparts"]	= "Honor Hold"
	zones["Magtheridon's Lair"]	= "Honor Hold"
	zones["Nagrand"]			= "Kurenai"
	zones["The Blood Furnace"]	= "Honor Hold"
	zones["The Shattered Halls"]= "Honor Hold"

	zones["Borean Tundra"]		= "Valiance Expedition"
	zones["Grizzly Hills"]		= "Valiance Expedition"
	zones["Howling Fjord"]		= "Valiance Expedition"
	zones["Trial of the Crusader"]="The Silver Covenant"

	subzones["Winterspring"]["Frostsaber Rock"]			= "Wintersaber Trainers"

	subzones["Hellfire Peninsula"]["Temple of Telhamat"]= "Kurenai"
	subzones["Zangarmarsh"]["Telredor"]					= "Exodar"

	subzones["Crystalsong Forest"]["Windrunner Overlook"]	= "The Silver Covenant"
	subzones["Dalaran"]["The Silver Enclave"]			= "The Silver Covenant"
	subzones["Dragonblight"]["Stars' Rest"]				= "Valiance Expedition"
	subzones["Dragonblight"]["Wintergarde Keep"]		= "Valiance Expedition"
	subzones["Icecrown"]["Argent Pavilion"]				= "The Silver Covenant"
	subzones["Icecrown"]["Argent Tournament Grounds"]	= "The Silver Covenant"
	subzones["Icecrown"]["Silver Covenant Pavilion"]	= "The Silver Covenant"
	subzones["Icecrown"]["Sunreaver Pavilion"]			= "The Silver Covenant"
	subzones["Icecrown"]["The Alliance Valiants' Ring"]	= "The Silver Covenant"
	subzones["Icecrown"]["The Argent Valiants' Ring"]	= "The Silver Covenant"
	subzones["Icecrown"]["The Aspirants' Ring"]			= "The Silver Covenant"
	subzones["Icecrown"]["The Horde Valiants' Ring"]	= "The Silver Covenant"
	subzones["Icecrown"]["The Ring of Champions"]		= "The Silver Covenant"
	subzones["Icecrown"]["The Skybreaker"]				= "Valiance Expedition"
	subzones["The Storm Peaks"]["Frosthold"]			= "The Frostborn"
	subzones["The Storm Peaks"]["Inventor's Library"]	= "The Frostborn"
	subzones["The Storm Peaks"]["Loken's Bargain"]		= "The Frostborn"
	subzones["The Storm Peaks"]["Mimir's Workshop"]		= "The Frostborn"
	subzones["The Storm Peaks"]["Narvir's Cradle"]		= "The Frostborn"
	subzones["The Storm Peaks"]["Nidavelir"]			= "The Frostborn"
	subzones["The Storm Peaks"]["Temple of Invention"]	= "The Frostborn"
	subzones["The Storm Peaks"]["Temple of Life"]		= "The Frostborn"
	subzones["The Storm Peaks"]["Temple of Order"]		= "The Frostborn"
	subzones["The Storm Peaks"]["Temple of Winter"]		= "The Frostborn"
	subzones["The Storm Peaks"]["The Foot Steppes"]		= "The Frostborn"
	subzones["The Storm Peaks"]["The Plain of Echoes"]	= "The Frostborn"
end

function Diplomancer:GetData()
	local locale = GetLocale()
	if locale == "enUS" or locale == "enGB" then
		return zones, subzones, champions, races[race]
	end

	local BF = LibStub and LibStub("LibBabble-Faction-3.0", true) and LibStub("LibBabble-Faction-3.0"):GetLookupTable()
	local BZ = LibStub and LibStub("LibBabble-Zone-3.0", true) and LibStub("LibBabble-Zone-3.0"):GetLookupTable()
	local SZ = DiplomancerSubzoneNames

	if not SZ then
		return print("|cff33ff99Diplomancer|r is not yet compatible with your locale, because it is missing the translated names of subzones. To find out how you can help fix this, please see the addon's download page!")
	elseif not BF or not BZ then
		return print("|cff33ff99Diplomancer|r requires the LibBabble-Faction-3.0 and LibBabble-Zone-3.0 libraries in order to work in your locale. For information on how to get these files, see the README file in the addon's folder.")
	end

	local missingSZ = {}

	local tzones = {}
	for k, v in pairs(zones) do
		tzones[BZ[k]] = BF[v]
	end
	
	local tzone
	local tsubzones = {}
	for k, v in pairs(subzones) do
		tzone = BZ[k]
		tsubzones[tzone] = {}
		for k2, v2 in pairs(v) do
			if SZ[k2] then
				tsubzones[tzone][SZ[k2]] = BF[v2]
			else
				tinsert(missingSZ, k2)
			end
		end
	end
	
	local tchampions = {}
	for k, v in pairs(champions) do
		tchampions[k] = BF[v]
	end

	for i, v in ipairs(missingSZ) do
		print("|cff33ff99Diplomancer|r: missing subzone translation for \"" .. v .. "\".")
	end

	return tzones, tsubzones, tchampions, BF[races[race]]
end