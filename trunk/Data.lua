--[[--------------------------------------------------------------------
	Diplomancer
	Automatically sets your watched faction based on your location.
	by Phanx < addons@phanx.net >
	Copyright ©2007–2009 Alyssa "Phanx" Kinley
	http://www.wowinterface.com/downloads/info9643-Diplomancer.html
	http://wow.curse.com/downloads/wow-addons/details/diplomancer.aspx
----------------------------------------------------------------------]]

local Horde, Alliance
do
	local _, race = UnitRace("player") -- arg2 is "Scourge" for Undead players
	if race == "BloodElf" or race == "Orc" or race == "Scourge" or race == "Tauren" or race == "Troll" then
		Horde = true
	else
		Alliance = true
	end
end

------------------------------------------------------------------------

local CF = {
	[GetSpellInfo(57819)] = "Argent Crusade",
	[GetSpellInfo(57821)] = "Kirin Tor",
	[GetSpellInfo(57820)] = "Knights of the Ebon Blade",
	[GetSpellInfo(57822)] = "The Wyrmrest Accord",
}

local CZ = {
	["Halls of Lightning"]    = true,
	["Halls of Reflection"]   = true,
	["Pit of Saron"]          = true,
	["Stratholme Past"]       = true,
	["The Oculus"]            = true,
	["The Forge of Souls"]    = true,
	["Trial of the Champion"] = true,
	["Utgarde Pinnacle"]      = true,
}

------------------------------------------------------------------------

local RF = {
	["BloodElf"] = "Silvermoon City",
	["Draenei"]  = "Exodar",
	["Dwarf"]    = "Ironforge",
	["Gnome"]    = "Gnomeregan Exiles",
	["Human"]    = "Stormwind City",
	["NightElf"] = "Darnassus",
	["Orc"]      = "Orgrimmar",
	["Tauren"]   = "Thunder Bluff",
	["Troll"]    = "Darkspear Trolls",
	["Scourge"]  = "Undercity",
}

------------------------------------------------------------------------

local ZF = {
	["Ahn'Qiraj"]					= "Brood of Nozdormu",
	["Alterac Valley"]				= Horde and "Frostwolf Clan" or "Stormpike Guard",
	["Arathi Basin"]				= Horde and "The Defilers" or "The League of Arathor",
	["Auchenai Crypts"]				= "Lower City",
	["Azuremyst Isle"]				= Alliance and "Exodar",
	["Black Temple"]				= "Ashtongue Deathsworn",
	["Blackrock Depths"]			= "Thorium Brotherhood",
	["Borean Tundra"]				= Horde and "Warsong Offensive" or "Valiance Expedition",
	["Caverns of Time"]				= "Keepers of Time",
	["Coilfang Reservoir"]			= "Cenarion Expedition",
	["Crystalsong Forest"]			= "Kirin Tor",
	["Dalaran"]						= "Kirin Tor",
	["Darnassus"]					= Alliance and "Darnassus",
	["Dire Maul"]					= "Shen'dralar",
	["Deadwind Pass"]				= "The Violet Eye",
	["Dragonblight"]				= "The Wyrmrest Accord",
	["Dun Morogh"]					= Alliance and "Ironforge",
	["Durotar"]						= Horde and "Orgrimmar",
	["Eastern Plaguelands"]			= "Argent Dawn",
	["Elwynn Forest"]				= Alliance and "Stormwind",
	["Eversong Woods"]				= Horde and "Silvermoon City",
	["Gates of Ahn'Qiraj"]			= "Cenarion Circle",
	["Ghostlands"]					= Horde and "Tranquillien",
	["Grizzly Hills"]				= Horde and "Warsong Offensive" or "Valiance Expedition",
	["Halls of Reflection"]			= Horde and "The Sunreavers" or "The Silver Covenant",
	["Hellfire Peninsula"]			= Horde and "Thrallmar" or "Honor Hold",
	["Hellfire Ramparts"]			= Horde and "Thrallmar" or "Honor Hold",
	["Howling Fjord"]				= Horde and "The Hand of Vengeance" or "Valiance Expedition",
	["Hyjal Summit"]				= "The Scale of the Sands",
	["Icecrown"]					= "Knights of the Ebon Blade",
	["Ironforge"]					= Alliance and "Ironforge",
	["Isle of Quel'Danas"]			= "Shattered Sun Offensive",
	["Karazhan"]					= "The Violet Eye",
	["Magisters' Terrace"]			= "Shattered Sun Offensive",
	["Magtheridon's Lair"]			= Horde and "Thrallmar" or "Honor Hold",
	["Mana-Tombs"]					= "The Consortium",
	["Molten Core"]					= "Hydraxian Waterlords",
	["Moonglade"]					= "Cenarion Circle",
	["Mulgore"]						= Horde and "Thunder Bluff",
	["Nagrand"]						= Horde and "The Mag'har" or "Kurenai",
	["Netherstorm"]					= "The Consortium",
	["Old Hillsbrad Foothills"]		= "Keepers of Time",
	["Orgrimmar"]					= Horde and "Orgrimmar",
	["Pit of Saron"]				= Horde and "The Sunreavers" or "The Silver Covenant",
	["Ruins of Ahn'Qiraj"]			= "Cenarion Circle",
	["Scholomance"]					= "Argent Dawn",
	["Serpentshrine Cavern"]		= "Cenarion Expedition",
	["Sethekk Halls"]				= "Lower City",
	["Shadow Labyrinth"]			= "Lower City",
	["Shadowmoon Valley"]			= "Netherwing",
	["Shattrath City"]				= "The Sha'tar",
	["Silithus"]					= "Cenarion Circle",
	["Silvermoon City"]				= Horde and "Silvermoon City",
	["Stormwind City"]				= Alliance and "Stormwind",
	["Stratholme"]					= "Argent Dawn",
	["Sunwell Plateau"]				= "Shattered Sun Offensive",
	["Tanaris"]						= "Gadgetzan",
	["Tempest Keep"]				= "The Sha'tar",
	["Terokkar Forest"]				= "Lower City",
	["The Arcatraz"]				= "The Sha'tar",
	["The Barrens"]					= Horde and "Orgrimmar",
	["The Black Morass"]			= "Keepers of Time",
	["The Blood Furnace"]			= Horde and "Thrallmar" or "Honor Hold",
	["The Botanica"]				= "The Sha'tar",
	["The Exodar"]					= Alliance and "Exodar",
	["The Eye"]						= "The Sha'tar",
	["The Forge of Souls"]			= Horde and "The Sunreavers" or "The Silver Covenant",
	["The Mechanar"]				= "The Sha'tar",
	["The Shattered Halls"]			= Horde and "Thrallmar" or "Honor Hold",
	["The Slave Pens"]				= "Cenarion Expedition",
	["The Steamvault"]				= "Cenarion Expedition",
	["The Storm Peaks"]				= "The Sons of Hodir",
	["The Underbog"]				= "Cenarion Expedition",
	["Thunder Bluff"]				= Horde and "Thunder Bluff",
	["Trial of the Crusader"]		= Horde and "The Sunreavers" or "The Silver Covenant",
	["Undercity"]					= Horde and "Undercity",
	["Warsong Gulch"]				= Horde and "Warsong Outriders" or "Silverwing Sentinels",
	["Western Plaguelands"]			= "Argent Dawn",
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
		["Taunka'le Village"]		= Horde and "The Taunka",
		["Transitus Shield"]		= "Kirin Tor",
		["Unu'pe"]					= "The Kalu'ak",
	},
	["Crystalsong Forest"] = {
		["Sunreaver's Command"]		= Horde and "The Sunreavers",
		["Windrunner Overlook"]		= Alliance and "The Silver Covenant",
	},
	["Dalaran"] = {
		["Sunreaver's Sanctuary"]	= Horde and "The Sunreavers",
		["The Filthy Animal"]		= Horde and "The Sunreavers",
		["The Silver Enclave"]		= Alliance and "The Silver Covenant",
	},
	["Desolace"] = {
		["Gelkis Village"]			= "Magram Clan Centaur",
		["Magram Village"]			= "Gelkis Clan Centaur",
	},
	["Dragonblight"] = {
		["Light's Trust"]			= "Argent Crusade",
		["Moa'ki Harbor"]			= "The Kalu'ak",
		["Agmar's Hammer"]			= Horde and "Warsong Offensive",
		["Dragon's Fall"]			= Horde and "Warsong Offensive",
		["Stars' Rest"]				= Alliance and "Valiance Expedition",
		["Venomspite"]				= Horde and "The Hand of Vengeance",
		["Westwind Refugee Camp"]	= Horde and "The Taunka",
		["Wintergarde Keep"]		= Alliance and "Valiance Expedition",
	},
	["Durotar"] = {
		["Sen'jin Village"]			= Horde and "Darkspear Trolls",
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
		["Camp Oneqwah"]			= Horde and "The Taunka",
	},
	["Hellfire Peninsula"] = {
		["Cenarion Post"]			= "Cenarion Circle",
		["Mag'har Grounds"]			= Horde and "The Mag'har",
		["Mag'har Post"]			= Horde and "The Mag'har",
		["Temple of Telhamat"]		= Alliance and "Kurenai",
		["Throne of Kil'jaeden"]	= "Shattered Sun Offensive",
	},
	["Howling Fjord"] = {
		["Camp Winterhoof"]			= Horde and "The Taunka",
		["Kamagua"]					= "The Kalu'ak",
	},
	["Icecrown"] = {
		["The Argent Vanguard"]			= "Argent Crusade",
		["Crusaders' Pinnacle"]			= "Argent Crusade",
		["Argent Pavilion"]				= Horde and "The Sunreavers" or "The Silver Covenant",
		["Argent Tournament Grounds"]	= Horde and "The Sunreavers" or "The Silver Covenant",
		["Orgrim's Hammer"]				= Horde and "Warsong Offensive",
		["Silver Covenant Pavilion"]	= Horde and "The Sunreavers" or "The Silver Covenant",
		["Sunreaver Pavilion"]			= Horde and "The Sunreavers" or "The Silver Covenant",
		["The Alliance Valiants' Ring"]	= Horde and "The Sunreavers" or "The Silver Covenant",
		["The Argent Valiants' Ring"]	= Horde and "The Sunreavers" or "The Silver Covenant",
		["The Aspirants' Ring"]			= Horde and "The Sunreavers" or "The Silver Covenant",
		["The Horde Valiants' Ring"]	= Horde and "The Sunreavers" or "The Silver Covenant",
		["The Ring of Champions"]		= Horde and "The Sunreavers" or "The Silver Covenant",
		["The Skybreaker"]				= Alliance and "Valiance Expedition",
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
		["Camp Tunka'lo"]			= Horde and "Warsong Offensive",
		["Frostfloe Deep"]			= Horde and "Warsong Offensive",
		["Frosthold"]				= Alliance and "The Frostborn",
		["Frosthowl Cavern"]		= Horde and "Warsong Offensive",
		["Gimorak's Den"]			= Horde and "Warsong Offensive",
		["Grom'arsh Crash-site"]	= Horde and "Warsong Offensive",
		["Inventor's Library"]		= Alliance and "The Frostborn",
		["Howling Hollow"]			= Horde and "Warsong Offensive",
		["Loken's Bargain"]			= Alliance and "The Frostborn",
		["Mimir's Workshop"]		= Alliance and "The Frostborn",
		["Narvir's Cradle"]			= Alliance and "The Frostborn",
		["Nidavelir"]				= Alliance and "The Frostborn",
		["Temple of Invention"]		= Alliance and "The Frostborn",
		["Temple of Life"]			= Horde and "Warsong Offensive" or "The Frostborn",
		["Temple of Order"]			= Alliance and "The Frostborn",
		["Temple of Winter"]		= Alliance and "The Frostborn",
		["The Foot Steppes"]		= Alliance and "The Frostborn",
		["The Plain of Echoes"]		= Horde and "Warsong Offensive" or "The Frostborn",
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
	["Winterspring"] = {
		["Frostfire Hot Springs"]	= "Timbermaw Hold",
		["Frostsaber Rock"]			= Alliance and "Wintersaber Trainers",
		["Timbermaw Post"]			= "Timbermaw Hold",
		["Winterfall Village"]		= "Timbermaw Hold",
	},
	["Zangarmarsh"] = {
		["Funggor Cavern"]			= "Sporeggar",
		["Quagg Ridge"]				= "Sporeggar",
		["Sporeggar"]				= "Sporeggar",
		["Swamprat Post"]			= Horde and "Darkspear Trolls",
		["Telredor"]				= Alliance and "Exodar",
		["The Spawning Glen"]		= "Sporeggar",
		["Zabra'jin"]				= Horde and "Darkspear Trolls",
	},
	["Zul'Drak"] = {
		["Ebon Watch"]				= "Knights of the Ebon Blade",
	},
}

------------------------------------------------------------------------

local _, Diplomancer = ...
function Diplomancer:LocalizeData()
	-- self:Debug("LocalizeData")

	if GetLocale():match("^en") then
		self.championFactions = CF
		self.championZones = CZ
		self.racialFaction = RF[race]
		self.subzoneFactions = SF
		self.zoneFactions = ZF
	else
		local BF = LibStub and LibStub("LibBabble-Faction-3.0", true) and LibStub("LibBabble-Faction-3.0"):GetLookupTable()
		local BZ = LibStub and LibStub("LibBabble-Zone-3.0", true) and LibStub("LibBabble-Zone-3.0"):GetLookupTable()

		local SZ = self.SubzoneNames

		if not SZ then
			return print("|cff33ff99Diplomancer|r is not yet compatible with your locale, because it is missing the translated names of subzones. To find out how you can help, see the addon's download page or the README file in the addon's folder.")
		elseif not BF or not BZ then
			return print("|cff33ff99Diplomancer|r requires the LibBabble-Faction-3.0 and LibBabble-Zone-3.0 libraries in order to work in your locale. For instructions on how to get these libraries, see the README file in the addon's folder.")
		end

		self.championFactions = { }
		for aura, faction in pairs(CF) do
			self.championFactions[aura] = BF[faction]
		end

		self.championZones = { }
		for zone in pairs(CZ) do
			self.championZones[BZ[zone]] = true
		end

		self.subzoneFactions = { }
		for zone, subzones in pairs(SF) do
			self.subzoneFactions[BZ[zone]] = { }
			for subzone, faction in pairs(subzones) do
				if SZ[subzone] then
					self.subzoneFactions[BZ[zone]][SZ[subzone]] = BF[faction]
				else
					print(("|cff33ff99Diplomancer:|r No translation found for subzone %s in zone %s."):format(subzone, zone))
				end
			end
		end

		self.zoneFactions = { }
		for zone, faction in pairs(ZF) do
			self.zoneFactions[BZ[zone]] = BF[faction]
		end
	end

	self.LocalizeData = nil
end

------------------------------------------------------------------------