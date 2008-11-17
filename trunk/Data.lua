--[[------------------------------------------------------------
	Diplomancer
	Automatically watches the current area's faction.
	by Phanx < addons@phanx.net >
	http://www.wowinterface.com/downloads/info9643-Diplomancer.html
	Copyright � 2007�2008 Alyssa S. Kinley, a.k.a Phanx
	See included README for license terms and additional information.

	This file provides area-faction mapping data.
--------------------------------------------------------------]]
local data = {
	zones = {
		["Ahn'Qiraj"]				= "Brood of Nozdormu",
		["Blackrock Depths"]		= "Thorium Brotherhood",
		["Dire Maul"]				= "Shen'dralar",
		["Eastern Plaguelands"]		= "Argent Dawn",
		["Gates of Ahn'Qiraj"]		= "Cenarion Circle",
		["Molten Core"]			= "Hydraxian Waterlords",
		["Moonglade"]				= "Cenarion Circle",
		["Naxxramas"]				= "Argent Dawn",
		["Ruins of Ahn'Qiraj"]		= "Cenarion Circle",
		["Scholomance"]			= "Argent Dawn",
		["Silithus"]				= "Cenarion Circle",
		["Stratholme"]				= "Argent Dawn",
		["Tanaris"]				= "Gadgetzan",
		["Western Plaguelands"]		= "Argent Dawn",
		["Winterspring"]			= "Everlook",
		["Zul'Gurub"]				= "Zandalar Tribe",

		["Auchenai Crypts"]			= "Lower City",
		["Black Temple"]			= "Ashtongue Deathsworn",
		["Coilfang Reservoir"]		= "Cenarion Expedition",
		["Deadwind Pass"]			= "The Violet Eye",
		["Hyjal Summit"]			= "The Scale of the Sands",
		["Isle of Quel'Danas"]		= "Shattered Sun Offensive",
		["Karazhan"]				= "The Violet Eye",
		["Magisters' Terrace"]		= "Shattered Sun Offensive",
		["Mana-Tombs"]				= "The Consortium",
		["Netherstorm"]			= "The Consortium",
		["Old Hillsbrad Foothills"]	= "Keepers of Time",
		["Quel'Danas"]				= "Shattered Sun Offensive",
		["Serpentshrine Cavern"]		= "Cenarion Expedition",
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
		["The Caverns of Time"]		= "Keepers of Time",
		["The Eye"]				= "The Sha'tar",
		["The Mechanar"]			= "The Sha'tar",
		["The Seer's Library"]		= "The Scryers",
		["The Slave Pens"]			= "Cenarion Expedition",
		["The Steamvault"]			= "Cenarion Expedition",
		["The Underbog"]			= "Cenarion Expedition",
		["Zangarmarsh"]			= "Cenarion Expedition",

	--	["Borean Tundra"]			= "",
		["Crystalsong Forest"]		= "Kirin Tor",
		["Dalaran"]				= "Kirin Tor",
		["Dragonblight"]			= "The Wyrmrest Accord",
	--	["Grizzly Hills"]			= "",
	--	["Howling Fjord"]			= "",
		["Icecrown"]				= "Argent Crusade",
	--	["Sholazar Basin"]			= "",
		["The Storm Peaks"]			= "Sons of Hodir",
	--	["Wintergasp"]				= "",
		["Zul'Drak"]				= "Argent Crusade",
	},
	subzones = {
		["Azshara"] = {
			["Bay of Storms"]		= "Hydraxian Waterlords",
			["Timbermaw Hold"]		= "Timbermaw Hold",
			["Ursolan"]			= "Timbermaw Hold",
		},
		["Blade's Edge Mountains"] = {
			["Evergrove"]			= "Cenarion Expedition",
			["Forge Camp: Terror"]	= "Ogri'la",
			["Forge Camp: Wrath"]	= "Ogri'la",
			["Ogri'la"]			= "Ogri'la",
			["Shartuul's Transporter"]	= "Ogri'la",
			["Vortex Pinnacle"]		= "Ogri'la",
		},
		["Borean Tundra"] = {
			["Amber Ledge"]		= "Kirin Tor",
			["D.E.H.T.A. Encampment"]	= "Cenarion Expedition",
			["Transitus Shield"]	= "Kirin Tor",
			["Unu'pe"]			= "The Kalu'ak",
		},
		["Dalaran"] = {
			-- Faction-specific, filled in later
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
		},
		["Grizzly Hills"] = {
			-- Faction-specific, filled in later
		},
		["Hellfire Peninsula"] = {
			["Cenarion Post"]		= "Cenarion Circle",
			["Throne of Kil'jaeden"]	= "Shattered Sun Offensive",
		},
		["Howling Fjord"] = {
			["Kamagua"]			= "The Kalu'ak",
		},
		["Icecrown"] = {
			-- Faction-specific, filled in later
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
			["Netherwing Field"]	= "Netherwing",
			["Sanctum of the Stars"]	= "The Scryers",
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
			["Rainspeaker Canopy"]	= "The Oracles",
			["Sparktouched Haven"]	= "The Oracles",
		},
		["Stranglethorn Vale"] = {
			["Booty Bay"]			= "Booty Bay",
			["Salty Sailor Tavern"]	= "Booty Bay",
			["Yojamaba Isle"]		= "Zandalar Tribe",
			["Zul'Gurub"]			= "Zandalar Tribe",
		},
		["Storm Peaks"] = {
			-- Faction-specific, filled in later
		},
		["Tanaris"] = {
			["Caverns of Time"]		= "Keepers of Time",
		},
		["The Barrens"] = {
			["Ratchet"]			= "Ratchet",
		},
		["Terokkar Forest"] = {
			["Blackwind Lake"]		= "Sha'tari Skyguard",
			["Blackwind Landing"]	= "Sha'tari Skyguard",
			["Blackwind Valley"]	= "Sha'tari Skyguard",
			["Lake Ere'nom"]		= "Sha'tari Skyguard",
			["Lower Veil Shil'ak"]	= "Sha'tari Skyguard",
			["Mana Tombs"]			= "The Consortium",
			["Skettis"]			= "Sha'tari Skyguard",
			["Terokk's Rest"]		= "Sha'tari Skyguard",
			["Upper Veil Shil'ak"]	= "Sha'tari Skyguard",
			["Veil Ala'rak"]		= "Sha'tari Skyguard",
			["Veil Harr'ik"]		= "Sha'tari Skyguard",
		},
		["Tirisfal Glades"] = {
			["The Bulwark"]		= "Argent Dawn",
		},
		["Winterspring"] = {
			["Frostfire Hot Springs"]= "Timbermaw Hold",
			["Timbermaw Post"]		= "Timbermaw Hold",
			["Winterfall Village"]	= "Timbermaw Hold",
		},
		["Zangarmarsh"] = {
			["Funggor Cavern"]		= "Sporeggar",
			["Quagg Ridge"]		= "Sporeggar",
			["Sporeggar"]			= "Sporeggar",
			["The Spawning Glen"]	= "Sporeggar",
		},
		["Zul'Drak"] = {
			["Ebon Watch"]			= "Knights of the Ebon Blade",
		},
	},
	races = {
		-- Faction-specific, filled in later
	}
}

local race = select(2, UnitRace("player")) -- arg2 is "Scourge" for Undead players

if race == "BloodElf" or race == "Orc" or race == "Tauren" or race == "Troll" or race == "Scourge" then
	data.races["Blood Elf"]	= "Silvermoon City"
	data.races["Orc"]		= "Orgrimmar"
	data.races["Tauren"]	= "Thunder Bluff"
	data.races["Troll"]		= "Darkspear Trolls"
	data.races["Undead"]	= "Undercity"

	data.zones["Alterac Valley"]		= "Frostwolf Clan"
	data.zones["Arathi Basin"]		= "The Defilers"
	data.zones["Orgrimmar"]			= "Orgrimmar"
	data.zones["Thunder Bluff"]		= "Thunder Bluff"
	data.zones["Undercity"]			= "Undercity"
	data.zones["Warsong Gulch"]		= "Warsong Outriders"

	data.zones["Ghostlands"]			= "Tranquillien"
	data.zones["Hellfire Peninsula"]	= "Thrallmar"
	data.zones["Hellfire Ramparts"]	= "Thrallmar"
	data.zones["Magtheridon's Lair"]	= "Thrallmar"
	data.zones["Nagrand"]			= "The Mag'har"
	data.zones["Silvermoon City"]		= "Silvermoon City"
	data.zones["The Blood Furnace"]	= "Thrallmar"
	data.zones["The Shattered Halls"]	= "Thrallmar"

	data.zones["Borean Tundra"]		= "Warsong Offensive"
	data.zones["Howling Fjord"]		= "The Hand of Vengeance"

	data.subzones["Durotar"]["Sen'jin Village"]				= "Darkspear Trolls"

	data.subzones["Hellfire Peninsula"]["Mag'har Grounds"]		= "The Mag'har"
	data.subzones["Hellfire Peninsula"]["Mag'har Post"]		= "The Mag'har"
	data.subzones["Zangarmarsh"]["Swamprat Post"]			= "Darkspear Trolls"
	data.subzones["Zangarmarsh"]["Zabra'jin"]				= "Darkspear Trolls"

	data.subzones["Borean Tundra"]["Taunka'le Village"]		= "The Taunka"
	data.subzones["Crystalsong Forest"]["Sunreaver's Command"]	= "The Sunreavers"
	data.subzones["Dalaran"]["Sunreaver's Sanctuary"]			= "The Sunreavers"
	data.subzones["Dragonblight"]["Agmar's Hammer"]			= "Warsong Offensive"
	data.subzones["Dragonblight"]["Dragon's Fall"]			= "Warsong Offensive"
	data.subzones["Dragonblight"]["Venomspite"]				= "The Hand of Vengeance"
	data.subzones["Dragonblight"]["Westwind Refugee Camp"]		= "The Taunka"
	data.subzones["Grizzly Hills"]["Camp Oneqwah"]			= "The Taunka"
	data.subzones["Grizzly Hills"]["Conquest Hold"]			= "Warsong Offensive"
	data.subzones["Howling Fjord"]["Camp Winterhoof"]			= "The Taunka"
	data.subzones["Icecrown"]["Orgrim's Hammer"]				= "Warsong Offensive"
	data.subzones["Storm Peaks"]["Camp Tunka'lo"]			= "The Taunka"
else
	data.races["Draenei"]	= "Exodar"
	data.races["Dwarf"]		= "Ironforge"
	data.races["Gnome"]		= "Gnomeregan Exiles"
	data.races["Human"]		= "Stormwind City"
	data.races["Night Elf"]	= "Darnassus"

	data.zones["Alterac Valley"]		= "Stormpike Guard"
	data.zones["Arathi Basin"]		= "The League of Arathor"
	data.zones["Darnassus"]			= "Darnassus"
	data.zones["Dun Morogh"]			= "Ironforge",
	data.zones["Ironforge"]			= "Ironforge"
	data.zones["Stormwind City"]		= "Stormwind"
	data.zones["Warsong Gulch"]		= "Silverwing Sentinels"

	data.zones["Exodar"]			= "Exodar"
	data.zones["Hellfire Peninsula"]	= "Honor Hold"
	data.zones["Hellfire Ramparts"]	= "Honor Hold"
	data.zones["Magtheridon's Lair"]	= "Honor Hold"
	data.zones["Nagrand"]			= "Kurenai"
	data.zones["The Blood Furnace"]	= "Honor Hold"
	data.zones["The Shattered Halls"]	= "Honor Hold"

	data.zones["Borean Tundra"]		= "Valiance Expedition"
	data.zones["Howling Fjord"]		= "Valiance Expedition"

	data.subzones["Winterspring"]["Frostsaber Rock"]			= "Wintersaber Trainers"

	data.subzones["Hellfire Peninsula"]["Temple of Telhamat"]	= "Kurenai"
	data.subzones["Zangarmarsh"]["Telredor"]				= "Exodar"

	data.subzones["Crystalsong Forest"]["Windrunner Overlook"]	= "The Silver Covenant"
	data.subzones["Dalaran"]["The Silver Enclave"]			= "The Silver Covenant"
	data.subzones["Dragonblight"]["Stars' Rest"]				= "Valiance Expedition"
	data.subzones["Dragonblight"]["Wintergarde Keep"]			= "Valiance Expedition"
	data.subzones["Grizzly Hills"]["Amberpine Lodge"]			= "Valiance Expedition"
	data.subzones["Grizzly Hills"]["Prospector's Point"]		= "Valiance Expedition"
	data.subzones["Grizzly Hills"]["Westfall Brigade Encampment"]= "Valiance Expedition"
	data.subzones["Icecrown"]["The Skybreaker"]				= "Valiance Expedition"
	data.subzones["Storm Peaks"]["Frosthold"]				= "Explorers' League"
end

function Diplomancer:GetData()
	local locale = GetLocale()
	if locale == "enUS" or locale == "enGB" then
		return data.zones, data.subzones, data.races
	end

	local BF = LibStub and LibStub("LibBabble-Factions-3.0", true) and LibStub("LibBabble-Factions-3.0"):GetLookupTable()
	local BR = LibStub and LibStub("LibBabble-Race-3.0", true) and LibStub("LibBabble-Race-3.0"):GetLookupTable()
	local BZ = LibStub and LibStub("LibBabble-Zone-3.0", true) and LibStub("LibBabble-Zone-3.0"):GetLookupTable()
	local SZ = DiplomancerSubzones

	if not SZ then
		return DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99Diplomancer|r is not yet compatible with your language. For information on how you can help, see the README file in the addon folder.")
	elseif not BF and BR and BZ then
		return DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99Diplomancer|r requires the LibBabble-Faction-3.0, LibBabble-Race-3.0, and LibBabble-Zone-3.0 libraries to work in your language. For information on how to get these files, see the README file in the addon folder.")
	end

	local tz = {}
	for zone, faction in pairs(data.zones) do
		tz[BZ[zone]] = BF[faction]
	end
	local ts = {}
	local z
	for zone, subzones in pairs(data.subzones) do
		z = BZ[zone]
		ts[z] = {}
		for subzone, faction in pairs(data.subzones) do
			if SZ[subzone] then
				ts[z][SZ[subzone]] = BF[faction]
			end
		end
	end
	local tr = {}
	for race, faction in pairs(data.races) do
		tr[BR[race]] = BF[faction]
	end
	return tz, ts, tr
end