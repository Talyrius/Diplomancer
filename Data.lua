--[[------------------------------------------------------------
	Zone-faction mapping data for Diplomancer
--------------------------------------------------------------]]
local data = {
	zones = {
		["Ahn'Qiraj"]				= "Brood of Nozdormu",
		["Auchenai Crypts"]			= "Lower City",
		["Black Temple"]			= "Ashtongue Deathsworn",
		["Blackrock Depths"]		= "Thorium Brotherhood",
		["Coilfang Reservoir"]		= "Cenarion Expedition",
		["Deadwind Pass"]			= "The Violet Eye",
		["Dire Maul"]				= "Shen'dralar",
		["Eastern Plaguelands"]		= "Argent Dawn",
		["Gates of Ahn'Qiraj"]		= "Cenarion Circle",
		["Ghostlands"]				= "Tranquillien",
		["Hyjal Summit"]			= "The Scale of the Sands",
		["Isle of Quel'Danas"]		= "Shattered Sun Offensive",
		["Karazhan"]				= "The Violet Eye",
		["Magisters' Terrace"]		= "Shattered Sun Offensive",
		["Mana-Tombs"]				= "The Consortium",
		["Molten Core"]			= "Hydraxian Waterlords",
		["Moonglade"]				= "Cenarion Circle",
		["Naxxramas"]				= "Argent Dawn",
		["Netherstorm"]			= "The Consortium",
		["Old Hillsbrad Foothills"]	= "Keepers of Time",
		["Quel'Danas"]				= "Shattered Sun Offensive",
		["Ruins of Ahn'Qiraj"]		= "Cenarion Circle",
		["Scholomance"]			= "Argent Dawn",
		["Serpentshrine Cavern"]		= "Cenarion Expedition",
		["Sethekk Halls"]			= "Lower City",
		["Shadow Labyrinth"]		= "Lower City",
		["Shadowmoon Valley"]		= "Netherwing",
		["Shattrath City"]			= "The Sha'tar",
		["Silithus"]				= "Cenarion Circle",
		["Stratholme"]				= "Argent Dawn",
		["Sunwell Plateau"]			= "Shattered Sun Offensive",
		["Tanaris"]				= "Gadgetzan",
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
		["Western Plaguelands"]		= "Argent Dawn",
		["Winterspring"]			= "Everlook",
		["Zangarmarsh"]			= "Cenarion Expedition",
		["Zul'Gurub"]				= "Zandalar Tribe",
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
		["Durotar"] = {
			["Sen'jin Village"]		= "Darkspear Trolls",
		},
		["Felwood"] = {
			["Deadwood Village"]	= "Timbermaw Hold",
			["Felpaw Village"]		= "Timbermaw Hold",
		},
		["Hellfire Peninsula"] = {
			["Cenarion Post"]		= "Cenarion Circle",
			["Mag'har Grounds"]		= "The Mag'har",
			["Mag'har Post"]		= "The Mag'har",
			["Temple of Telhamat"]	= "Kurenai",
			["Throne of Kil'jaeden"]	= "Shattered Sun Offensive",
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
		["Stranglethorn Vale"] = {
			["Booty Bay"]			= "Booty Bay",
			["Salty Sailor Tavern"]	= "Booty Bay",
			["Yojamaba Isle"]		= "Zandalar Tribe",
			["Zul'Gurub"]			= "Zandalar Tribe",
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
			["Swamprat Post"]		= "Darkspear Trolls",
			["The Spawning Glen"]	= "Sporeggar",
		}
	},
	races = {
	}
}

local race = select(2, UnitRace("player")) -- arg2 is "Scourge" for Undead players

if race == "Blood Elf" or race == "Orc" or race == "Tauren" or race == "Troll" or race == "Scourge" then
	data.races["Blood Elf"]	= "Silvermoon City"
	data.races["Orc"]		= "Orgrimmar"
	data.races["Tauren"]		= "Thunder Bluff"
	data.races["Troll"]		= "Darkspear Trolls"
	data.races["Undead"]		= "Undercity"

	data.zones["Alterac Valley"]		= "Frostwolf Clan"
	data.zones["Arathi Basin"]		= "The Defilers"
	data.zones["Hellfire Peninsula"]	= "Thrallmar"
	data.zones["Hellfire Ramparts"]	= "Thrallmar"
	data.zones["Magtheridon's Lair"]	= "Thrallmar"
	data.zones["Nagrand"]			= "The Mag'har"
	data.zones["Orgrimmar"]			= "Orgrimmar"
	data.zones["Silvermoon City"]		= "Silvermoon City"
	data.zones["The Blood Furnace"]	= "Thrallmar"
	data.zones["The Hinterlands"]		= "Revantusk Trolls"
	data.zones["The Shattered Halls"]	= "Thrallmar"
	data.zones["Thunder Bluff"]		= "Thunder Bluff"
	data.zones["Undercity"]			= "Undercity"
	data.zones["Warsong Gulch"]		= "Warsong Outriders"

	data.subzones["Zangarmarsh"]["Zabra'jin"]	= "Darkspear Trolls"
else
	data.races["Draenei"]	= "Exodar"
	data.races["Dwarf"]		= "Ironforge"
	data.races["Gnome"]		= "Gnomeregan Exiles"
	data.races["Human"]		= "Stormwind City"
	data.races["Night Elf"]	= "Darnassus"

	data.zones["Alterac Valley"]		= "Stormpike Guard"
	data.zones["Arathi Basin"]		= "The League of Arathor"
	data.zones["Darnassus"]			= "Darnassus"
	data.zones["Exodar"]				= "Exodar"
	data.zones["Hellfire Peninsula"]	= "Honor Hold"
	data.zones["Hellfire Ramparts"]	= "Honor Hold"
	data.zones["Ironforge"]			= "Ironforge"
	data.zones["Magtheridon's Lair"]	= "Honor Hold"
	data.zones["Nagrand"]			= "Kurenai"
	data.zones["Stormwind City"]		= "Stormwind"
	data.zones["The Blood Furnace"]	= "Honor Hold"
	data.zones["The Shattered Halls"]	= "Honor Hold"
	data.zones["Warsong Gulch"]		= "Silverwing Sentinels"

	data.subzones["Winterspring"]["Frostsaber Rock"]	= "Wintersaber Trainers"
	data.subzones["Zangarmarsh"]["Telredor"]			= "Exodar"
end

function Diplomancer:GetData()
	return data.zones, data.subzones, data.races
end