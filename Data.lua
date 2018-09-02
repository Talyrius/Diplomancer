--[[--------------------------------------------------------------------------------------------------------------------
  Diplomancer — Changes your watched faction reputation based on your current location.
  Copyright © 2007-2018 Phanx <addons@phanx.net>, Talyrius <contact@talyrius.net>. All rights reserved.
  See the accompanying LICENSE file for more information.

  Authorized distributions:
    https://github.com/Talyrius/Diplomancer
    https://wow.curseforge.com/projects/diplomancer
    https://www.curseforge.com/wow/addons/diplomancer
    https://www.wowinterface.com/downloads/info9643-Diplomancer.html
--]]--------------------------------------------------------------------------------------------------------------------

local _, Diplomancer = ...

function Diplomancer:LocalizeData()
  if self.localized then return end
  -- self:Debug("LocalizeData")

  local H = UnitFactionGroup("player") == "Horde"
  local A = UnitFactionGroup("player") == "Alliance"

  ----------------------------------------------------------------------------------------------------------------------

  local F = { -- mapping table for sanity
    ["Aeda Brightdawn"]                   = 1740, -- Barracks Bodyguards
    ["Akule Riverhorn"]                   = 2099, -- Fisherfriends
    ["Alliance Vanguard"]                 = 1037,
    ["Arakkoa Outcasts"]                  = 1515,
    ["Argent Crusade"]                    = 1106,
    ["Argent Dawn"]                       =  529,
    ["Argussian Reach"]                   = 2170,
    ["Armies of Legionfall"]              = 2045,
    ["Army of the Light"]                 = 2165,
    ["Ashtongue Deathsworn"]              = 1012,
    ["Avengers of Hyjal"]                 = 1204,
    ["Baradin's Wardens"]                 = 1177,
    ["Barracks Bodyguards"]               = 1735,
    ["Bilgewater Cartel"]                 = 1133,
    ["Bizmo's Brawlpub (Season 1)"]       = 1419,
    ["Bizmo's Brawlpub (Season 2)"]       = 1691,
    ["Bizmo's Brawlpub"]                  = 2011,
    ["Bloodsail Buccaneers"]              =   87,
    ["Booty Bay"]                         =   21,
    ["Brawl'gar Arena (Season 1)"]        = 1374,
    ["Brawl'gar Arena (Season 2)"]        = 1690,
    ["Brawl'gar Arena"]                   = 2010,
    ["Brood of Nozdormu"]                 =  910,
    ["Cenarion Circle"]                   =  609,
    ["Cenarion Expedition"]               =  942,
    ["Chee Chee"]                         = 1277, -- The Tillers
    ["Chromie"]                           = 2135,
    ["Conjurer Margoss"]                  = 1975,
    ["Corbyn"]                            = 2100, -- Fisherfriends
    ["Council of Exarchs"]                = 1731,
    ["Court of Farondis"]                 = 1900,
    ["Darkmoon Faire"]                    =  909,
    ["Darkspear Rebellion"]               = 1440,
    ["Darkspear Trolls"]                  =  530,
    ["Darnassus"]                         =   69,
    ["Defender Illona"]                   = 1738, -- Barracks Bodyguards
    ["Delvar Ironfist"]                   = 1733, -- Barracks Bodyguards
    ["Dominance Offensive"]               = 1375,
    ["Dragonmaw Clan"]                    = 1172,
    ["Dreamweavers"]                      = 1883,
    ["Ella"]                              = 1275, -- The Tillers
    ["Emperor Shaohao"]                   = 1492,
    ["Everlook"]                          =  577,
    ["Exodar"]                            =  930,
    ["Explorers' League"]                 = 1068,
    ["Farmer Fung"]                       = 1283, -- The Tillers
    ["Fish Fellreed"]                     = 1282, -- The Tillers
    ["Forest Hozen"]                      = 1228,
    ["Frenzyheart Tribe"]                 = 1104,
    ["Frostwolf Clan"]                    =  729,
    ["Frostwolf Orcs"]                    = 1445,
    ["Gadgetzan"]                         =  369,
    ["Gelkis Clan Centaur"]               =   92,
    ["Gilneas"]                           = 1134,
    ["Gina Mudclaw"]                      = 1281, -- The Tillers
    ["Gnomeregan"]                        =   54,
    ["Golden Lotus"]                      = 1269,
    ["Guardians of Hyjal"]                = 1158,
    ["Hand of the Prophet"]               = 1847,
    ["Haohan Mudclaw"]                    = 1279, -- The Tillers
    ["Hellscream's Reach"]                = 1178,
    ["Highmountain Tribe"]                = 1828,
    ["Honor Hold"]                        =  946,
    ["Horde Expedition"]                  = 1052,
    ["Huojin Pandaren"]                   = 1352,
    ["Hydraxian Waterlords"]              =  749,
    ["Ilyssia of the Waters"]             = 2097, -- Fisherfriends
    ["Impus"]                             = 2102, -- Fisherfriends
    ["Ironforge"]                         =   47,
    ["Jogu the Drunk"]                    = 1273, -- The Tillers
    ["Keeper Raynae"]                     = 2098, -- Fisherfriends
    ["Keepers of Time"]                   =  989,
    ["Kirin Tor Offensive"]               = 1387,
    ["Kirin Tor"]                         = 1090,
    ["Knights of the Ebon Blade"]         = 1098,
    ["Kurenai"]                           =  978,
    ["Laughing Skull Orcs"]               = 1708,
    ["Leorajh"]                           = 1741,
    ["Lower City"]                        = 1011,
    ["Magram Clan Centaur"]               =   93,
    ["Nat Pagle"]                         = 1358, -- The Tilers
    ["Netherwing"]                        = 1015,
    ["Nomi"]                              = 1357,
    ["Ogri'la"]                           = 1038,
    ["Old Hillpaw"]                       = 1276,
    ["Operation: Shieldwall"]             = 1376,
    ["Order of the Awakened"]             = 1849,
    ["Order of the Cloud Serpent"]        = 1271,
    ["Orgrimmar"]                         =   76,
    ["Pearlfin Jinyu"]                    = 1242,
    ["Ramkahen"]                          = 1173,
    ["Ratchet"]                           =  470,
    ["Ravenholdt"]                        =  349,
    ["Sha'leth"]                          = 2101, -- Fisherfriends
    ["Sha'tari Defense"]                  = 1710,
    ["Sha'tari Skyguard"]                 = 1031,
    ["Shado-Pan Assault"]                 = 1435,
    ["Shado-Pan"]                         = 1270,
    ["Shadowmoon Exiles"]                 = 1520,
    ["Shang Xi's Academy"]                = 1216,
    ["Shattered Sun Offensive"]           = 1077,
    ["Shen'dralar"]                       =  809,
    ["Sho"]                               = 1278, -- The Tillers
    ["Silvermoon City"]                   =  911,
    ["Silverwing Sentinels"]              =  890,
    ["Sporeggar"]                         =  970,
    ["Steamwheedle Draenor Expedition"]   = 1732,
    ["Steamwheedle Preservation Society"] = 1711,
    ["Stormpike Guard"]                   =  730,
    ["Stormwind"]                         =   72,
    ["Sunreaver Onslaught"]               = 1388,
    ["Syndicate"]                         =   70,
    ["Talon's Vengeance"]                 = 2018,
    ["Talonpriest Ishaal"]                = 1737, -- Barracks Bodyguards
    ["The Aldor"]                         =  932,
    ["The Anglers"]                       = 1302,
    ["The Ashen Verdict"]                 = 1156,
    ["The August Celestials"]             = 1341,
    ["The Black Prince"]                  = 1359,
    ["The Consortium"]                    =  933,
    ["The Defilers"]                      =  510,
    ["The Earthen Ring"]                  = 1135,
    ["The Frostborn"]                     = 1126,
    ["The Hand of Vengeance"]             = 1067,
    ["The Kalu'ak"]                       = 1073,
    ["The Klaxxi"]                        = 1337,
    ["The League of Arathor"]             =  509,
    ["The Lorewalkers"]                   = 1345,
    ["The Mag'har"]                       =  941,
    ["The Nightfallen"]                   = 1859,
    ["The Oracles"]                       = 1105,
    ["The Saberstalkers"]                 = 1850,
    ["The Scale of the Sands"]            =  990,
    ["The Scryers"]                       =  934,
    ["The Sha'tar"]                       =  935,
    ["The Silver Covenant"]               = 1094,
    ["The Sons of Hodir"]                 = 1119,
    ["The Sunreavers"]                    = 1124,
    ["The Taunka"]                        = 1064,
    ["The Tillers"]                       = 1272,
    ["The Violet Eye"]                    =  967,
    ["The Wardens"]                       = 1894,
    ["The Wyrmrest Accord"]               = 1091,
    ["Therazane"]                         = 1171,
    ["Thorium Brotherhood"]               =   59,
    ["Thrallmar"]                         =  947,
    ["Thunder Bluff"]                     =   81,
    ["Timbermaw Hold"]                    =  576,
    ["Tina Mudclaw"]                      = 1280,
    ["Tormmok"]                           = 1736, -- Barracks Bodyguards
    ["Tranquillien"]                      =  922,
    ["Tushui Pandaren"]                   = 1353,
    ["Undercity"]                         =   68,
    ["Valarjar"]                          = 1948,
    ["Valiance Expedition"]               = 1050,
    ["Vivianne"]                          = 1739, -- Barracks Bodyguards
    ["Vol'jin's Headhunters"]             = 1848,
    ["Vol'jin's Spear"]                   = 1681,
    ["Warsong Offensive"]                 = 1085,
    ["Warsong Outriders"]                 =  889,
    ["Wildhammer Clan"]                   = 1174,
    ["Wintersaber Trainers"]              =  589,
    ["Wrynn's Vanguard"]                  = 1682,
    ["Zandalar Tribe"]                    =  270,
  }

  setmetatable(F, { __index = function(F, faction) -- for debugging
    print("|cffffd000Diplomancer:|r Missing faction ID for", faction)
    F[faction] = false
    return false
  end })

  ----------------------------------------------------------------------------------------------------------------------

  local _, race = UnitRace("player") -- arg2 is "Scourge" for Undead players

  do
    self.racialFaction =
    race == "BloodElf" and F["Silvermoon City"]
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
  end

  ----------------------------------------------------------------------------------------------------------------------

  self.championFactions = {
    [ 93830] = { 15, F["Bilgewater Cartel"] },
    [ 93827] = { 15, F["Darkspear Trolls"] },
    [ 93806] = { 15, F["Darnassus"] },
    [ 93811] = { 15, F["Exodar"] },
    [ 93816] = { 15, F["Gilneas"] },
    [ 93821] = { 15, F["Gnomeregan"] },
    [126436] = { 15, F["Huojin Pandaren"] },
    [ 93805] = { 15, F["Ironforge"] },
    [ 93825] = { 15, F["Orgrimmar"] },
    [ 93828] = { 15, F["Silvermoon City"] },
    [ 93795] = { 15, F["Stormwind"] },
    [ 94463] = { 15, F["Thunder Bluff"] },
    [126434] = { 15, F["Tushui Pandaren"] },
    [ 94462] = { 15, F["Undercity"] },

    [ 57819] = { 80, F["Argent Crusade"] },
    [ 57821] = { 80, F["Kirin Tor"] },
    [ 57820] = { 80, F["Knights of the Ebon Blade"] },
    [ 57822] = { 80, F["The Wyrmrest Accord"] },

    [ 94158] = { 85, F["Dragonmaw Clan"] },
    [ 93339] = { 85, F["The Earthen Ring"] },
    [ 93341] = { 85, F["Guardians of Hyjal"] },
    [ 93337] = { 85, F["Ramkahen"] },
    [ 93347] = { 85, F["Therazane"] },
    [ 93368] = { 85, F["Wildhammer Clan"] },
  }

  self.championZones = {
    [ 70] = {
      -- This list is necessary to exclude Outland dungeons
      -- when championing a home city faction.
      [ 256] = true, -- Auchenai Crypts, Floor 1
      [ 257] = true, -- Auchenai Crypts, Floor 2
      [ 347] = true, -- Hellfire Ramparts
      [ 348] = true, -- Magisters' Terrace, Floor 1
      [ 349] = true, -- Magisters' Terrace, Floor 2
      [ 272] = true, -- Mana-Tombs
      [ 274] = true, -- Old Hillsbrad Foothills
      [ 258] = true, -- Sethekk Halls, Floor 1
      [ 259] = true, -- Sethekk Halls, Floor 2
      [ 260] = true, -- Shadow Labyrinth
      [ 269] = true, -- The Arcatraz, Floor 1
      [ 270] = true, -- The Arcatraz, Floor 2
      [ 271] = true, -- The Arcatraz, Floor 3
      [ 273] = true, -- The Black Morass
      [ 261] = true, -- The Blood Furnace
      [ 266] = true, -- The Botanica
      [ 267] = true, -- The Mechanar, Floor 1
      [ 268] = true, -- The Mechanar, Floor 2
      [ 246] = true, -- The Shattered Halls
      [ 265] = true, -- The Slave Pens
      [ 263] = true, -- The Steamvault, Floor 1
      [ 264] = true, -- The Steamvault, Floor 2
      [ 262] = true, -- The Underbog
    },
    [ 80] = {
      -- 23: Mythic only
      --  2: Heroic only
      --  1: Normal, Heroic, and Mythic
      [ 132] =    2, -- Ahn'kahet: The Old Kingdom
      [ 157] =    2, -- Azjol-Nerub, Floor 1
      [ 158] =    2, -- Azjol-Nerub, Floor 2
      [ 159] =    2, -- Azjol-Nerub, Floor 3
      [ 160] =    2, -- Drak'Tharon Keep, Floor 1
      [ 161] =    2, -- Drak'Tharon Keep, Floor 2
      [ 153] =    2, -- Gundrak, Floor 0
      [ 154] =    2, -- Gundrak, Floor 1
      [ 138] =    1, -- Halls of Lightning, Floor 1
      [ 139] =    1, -- Halls of Lightning, Floor 2
      [ 185] =    1, -- Halls of Reflection
      [ 140] =    2, -- Halls of Stone
      [ 184] =    1, -- Pit of Saron
      [ 130] =    1, -- The Culling of Stratholme, Floor 0
      [ 131] =    1, -- The Culling of Stratholme, Floor 1
      [ 183] =    1, -- The Forge of Souls
      [ 129] =    2, -- The Nexus
      [ 142] =    1, -- The Oculus, Floor 0
      [ 143] =    1, -- The Oculus, Floor 1
      [ 144] =    1, -- The Oculus, Floor 2
      [ 145] =    1, -- The Oculus, Floor 3
      [ 146] =    1, -- The Oculus, Floor 4
      [ 168] =    2, -- The Violet Hold
      [ 171] =    1, -- Trial of the Champion
      [ 133] =    2, -- Utgarde Keep, Floor 1
      [ 134] =    2, -- Utgarde Keep, Floor 2
      [ 135] =    2, -- Utgarde Keep, Floor 3
      [ 136] =    1, -- Utgarde Pinnacle, Floor 1
      [ 137] =    1, -- Utgarde Pinnacle, Floor 2
    },
    [ 85] = {
      [ 283] =    2, -- Blackrock Caverns, Floor 1
      [ 284] =    2, -- Blackrock Caverns, Floor 2
      [ 401] =    2, -- End Time, Floor 0
      [ 402] =    2, -- End Time, Floor 1
      [ 403] =    2, -- End Time, Floor 2
      [ 404] =    2, -- End Time, Floor 3
      [ 405] =    2, -- End Time, Floor 4
      [ 406] =    2, -- End Time, Floor 5
      [ 293] =    1, -- Grim Batol
      [ 297] =    1, -- Halls of Origination, Floor 1
      [ 298] =    1, -- Halls of Origination, Floor 2
      [ 299] =    1, -- Halls of Origination, Floor 3
      [ 399] =    2, -- Hour of Twilight, Floor 0
      [ 400] =    2, -- Hour of Twilight, Floor 1
      [ 277] =    1, -- Lost City of the Tol'vir
      [ 310] =    2, -- Shadowfang Keep, Floor 1
      [ 311] =    2, -- Shadowfang Keep, Floor 2
      [ 312] =    2, -- Shadowfang Keep, Floor 3
      [ 313] =    2, -- Shadowfang Keep, Floor 4
      [ 314] =    2, -- Shadowfang Keep, Floor 5
      [ 315] =    2, -- Shadowfang Keep, Floor 6
      [ 316] =    2, -- Shadowfang Keep, Floor 7
      [ 291] =    2, -- The Deadmines, Floor 1
      [ 292] =    2, -- The Deadmines, Floor 2
      [ 324] =    1, -- The Stonecore
      [ 325] =    1, -- The Vortex Pinnacle
      [ 322] =    2, -- Throne of the Tides, Floor 1
      [ 323] =    2, -- Throne of the Tides, Floor 2
      [ 398] =    2, -- Well of Eternity
      [ 333] =    1, -- Zul'Aman
      [ 337] =    1, -- Zul'Gurub
    },
    [ 90] = {
      [ 437] =    2, -- Gate of the Setting Sun, Floor 1
      [ 438] =    2, -- Gate of the Setting Sun, Floor 2
      [ 453] =    1, -- Mogu'Shan Palace, Floor 1
      [ 454] =    1, -- Mogu'Shan Palace, Floor 2
      [ 455] =    1, -- Mogu'Shan Palace, Floor 3
      [ 431] =    2, -- Scarlet Halls, Floor 1
      [ 432] =    2, -- Scarlet Halls, Floor 2
      [ 435] =    2, -- Scarlet Monastery, Floor 1
      [ 436] =    2, -- Scarlet Monastery, Floor 2
      [ 476] =    2, -- Scholomance, Floor 1
      [ 477] =    2, -- Scholomance, Floor 2
      [ 478] =    2, -- Scholomance, Floor 3
      [ 479] =    2, -- Scholomance, Floor 4
      [ 443] =    1, -- Shado-pan Monastery, Floor 0
      [ 444] =    1, -- Shado-pan Monastery, Floor 1
      [ 445] =    1, -- Shado-pan Monastery, Floor 2
      [ 446] =    1, -- Shado-pan Monastery, Floor 3
      [ 457] =    2, -- Siege of Niuzao Temple, Floor 0
      [ 458] =    2, -- Siege of Niuzao Temple, Floor 1
      [ 459] =    2, -- Siege of Niuzao Temple, Floor 2
      [ 439] =    1, -- Stormstout Brewery, Floor 1
      [ 440] =    1, -- Stormstout Brewery, Floor 2
      [ 441] =    1, -- Stormstout Brewery, Floor 3
      [ 442] =    1, -- Stormstout Brewery, Floor 4
      [ 429] =    1, -- Temple of the Jade Serpent, Floor 1
      [ 430] =    1, -- Temple of the Jade Serpent, Floor 2
    },
    [100] = {
      [ 593] =    1, -- Auchindoun
      [ 573] =    1, -- Bloodmaul Slag Mines
      [ 606] =    1, -- Grimrail Depot, Floor 1
      [ 607] =    1, -- Grimrail Depot, Floor 2
      [ 608] =    1, -- Grimrail Depot, Floor 3
      [ 609] =    1, -- Grimrail Depot, Floor 4
      [ 595] =    1, -- Iron Docks
      [ 574] =    1, -- Shadowmoon Burial Grounds, Floor 1
      [ 575] =    1, -- Shadowmoon Burial Grounds, Floor 2
      [ 576] =    1, -- Shadowmoon Burial Grounds, Floor 3
      [ 601] =    1, -- Skyreach, Floor 1
      [ 602] =    1, -- Skyreach, Floor 2
      [ 620] =    1, -- The Everbloom, Floor 0
      [ 621] =    1, -- The Everbloom, Floor 1
      [ 616] =    1, -- Upper Blackrock Spire, Floor 1
      [ 617] =    1, -- Upper Blackrock Spire, Floor 2
      [ 618] =    1, -- Upper Blackrock Spire, Floor 3
    },
    [110] = {
      [ 751] =    1, -- Black Rook Hold, Floor 1
      [ 752] =    1, -- Black Rook Hold, Floor 2
      [ 753] =    1, -- Black Rook Hold, Floor 3
      [ 754] =    1, -- Black Rook Hold, Floor 4
      [ 755] =    1, -- Black Rook Hold, Floor 5
      [ 756] =    1, -- Black Rook Hold, Floor 6
      [ 845] =    2, -- Cathedral of Eternal Night, Floor 1
      [ 846] =    2, -- Cathedral of Eternal Night, Floor 2
      [ 847] =    2, -- Cathedral of Eternal Night, Floor 3
      [ 848] =    2, -- Cathedral of Eternal Night, Floor 4
      [ 849] =    2, -- Cathedral of Eternal Night, Floor 5
      [ 761] =   23, -- Court of Stars, Floor 0
      [ 762] =   23, -- Court of Stars, Floor 1
      [ 763] =   23, -- Court of Stars, Floor 2
      [ 733] =    1, -- Darkheart Thicket
      [ 713] =    1, -- Eye of Azshara
      [ 703] =    1, -- Halls of Valor, Floor 0
      [ 704] =    1, -- Halls of Valor, Floor 1
      [ 705] =    1, -- Halls of Valor, Floor 2
      [ 706] =    1, -- Maw of Souls, Floor 0
      [ 707] =    1, -- Maw of Souls, Floor 1
      [ 708] =    1, -- Maw of Souls, Floor 2
      [ 731] =    1, -- Neltharion's Lair
      [ 809] =    2, -- Return to Karazhan, Floor 1
      [ 810] =    2, -- Return to Karazhan, Floor 2
      [ 811] =    2, -- Return to Karazhan, Floor 3
      [ 812] =    2, -- Return to Karazhan, Floor 4
      [ 813] =    2, -- Return to Karazhan, Floor 5
      [ 814] =    2, -- Return to Karazhan, Floor 6
      [ 815] =    2, -- Return to Karazhan, Floor 7
      [ 816] =    2, -- Return to Karazhan, Floor 8
      [ 817] =    2, -- Return to Karazhan, Floor 9
      [ 818] =    2, -- Return to Karazhan, Floor 10
      [ 819] =    2, -- Return to Karazhan, Floor 11
      [ 820] =    2, -- Return to Karazhan, Floor 12
      [ 821] =    2, -- Return to Karazhan, Floor 13
      [ 822] =    2, -- Return to Karazhan, Floor 14
      [ 749] =   23, -- The Arcway
      [ 903] =    2, -- The Seat of the Triumvirate
      [ 710] =    1, -- Vault of the Wardens, Floor 1
      [ 711] =    1, -- Vault of the Wardens, Floor 2
      [ 712] =    1, -- Vault of the Wardens, Floor 3
      [ 732] =    1, -- Violet Hold
    },
  }

  ----------------------------------------------------------------------------------------------------------------------

  self.zoneFactions = {
    -- Abyssal Depths
    [ 204] = F["The Earthen Ring"],
    -- Ahn'kahet: The Old Kingdom
    [ 132] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    -- Ahn'Qiraj
    [ 319] = F["Brood of Nozdormu"],
    [ 320] = F["Brood of Nozdormu"],
    [ 321] = F["Brood of Nozdormu"],
    -- Ahn'Qiraj: The Fallen Kingdom
    [ 327] = F["Brood of Nozdormu"],
    -- Alterac Valley
    [  91] = H and F["Frostwolf Clan"] or A and F["Stormpike Guard"],
    -- Antoran Wastes
    [ 885] = F["Army of the Light"],
    -- Arathi Basin
    [  93] = H and F["The Defilers"] or A and F["The League of Arathor"],
    [ 837] = H and F["The Defilers"] or A and F["The League of Arathor"],
    [ 844] = H and F["The Defilers"] or A and F["The League of Arathor"],
    -- Arathi Highlands
    [  14] = H and F["Orgrimmar"] or A and F["Stormwind"],
    [ 906] = H and F["Orgrimmar"] or A and F["Stormwind"],
    [ 943] = H and F["Orgrimmar"] or A and F["Stormwind"],
    -- Ashenvale
    [  63] = H and F["Warsong Offensive"] or A and F["Darnassus"],
    -- Ashran
    [ 588] = H and F["Vol'jin's Spear"] or A and F["Wrynn's Vanguard"],
    -- Auchenai Crypts
    [ 256] = F["Lower City"],
    [ 257] = F["Lower City"],
    -- Auchindoun
    [ 593] = H and F["Laughing Skull Orcs"] or A and F["Sha'tari Defense"],
    -- Azjol-Nerub
    [ 157] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    [ 158] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    [ 159] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    -- Azshara
    [  76] = H and F["Bilgewater Cartel"],
    [ 697] = H and F["Bilgewater Cartel"],
    -- Azsuna
    [ 630] = F["Court of Farondis"],
    [ 867] = F["Court of Farondis"],
    -- Azuremyst Isle
    [  97] = A and F["Exodar"],
    [ 776] = A and F["Exodar"],
    [ 891] = A and F["Exodar"],
    [ 892] = A and F["Exodar"],
    [ 893] = A and F["Exodar"],
    [ 894] = A and F["Exodar"],
    -- Baradin Hold
    [ 282] = H and F["Hellscream's Reach"] or A and F["Baradin's Wardens"],
    -- Black Temple
    [ 339] = F["Ashtongue Deathsworn"],
    [ 340] = F["Ashtongue Deathsworn"],
    [ 341] = F["Ashtongue Deathsworn"],
    [ 342] = F["Ashtongue Deathsworn"],
    [ 343] = F["Ashtongue Deathsworn"],
    [ 344] = F["Ashtongue Deathsworn"],
    [ 345] = F["Ashtongue Deathsworn"],
    [ 346] = F["Ashtongue Deathsworn"],
    [ 490] = F["Ashtongue Deathsworn"],
    [ 491] = F["Ashtongue Deathsworn"],
    [ 492] = F["Ashtongue Deathsworn"],
    [ 493] = F["Ashtongue Deathsworn"],
    [ 494] = F["Ashtongue Deathsworn"],
    [ 495] = F["Ashtongue Deathsworn"],
    [ 496] = F["Ashtongue Deathsworn"],
    [ 497] = F["Ashtongue Deathsworn"],
    [ 759] = F["Ashtongue Deathsworn"],
    -- Blackrock Depths
    [ 242] = F["Thorium Brotherhood"],
    [ 243] = F["Thorium Brotherhood"],
    -- Bloodmaul Slag Mines
    [ 573] = F["Steamwheedle Preservation Society"],
    -- Bloodmyst Isle
    [ 106] = A and F["Exodar"],
    -- Borean Tundra
    [ 114] = H and F["Warsong Offensive"] or A and F["Valiance Expedition"],
    -- Brawl'gar Arena
    [ 503] = H and F["Brawl'gar Arena"],
    -- Broken Shore
    [ 646] = F["Armies of Legionfall"],
    [ 676] = F["Armies of Legionfall"],
    -- Camp Narache
    [ 462] = H and F["Thunder Bluff"],
    -- Coldridge Valley
    [ 427] = A and F["Ironforge"],
    [ 834] = A and F["Ironforge"],
    -- Crystalsong Forest
    [ 127] = F["Kirin Tor"],
    -- Dalaran (Broken Isles)
    [ 625] = F["Kirin Tor"],
    [ 626] = F["Kirin Tor"],
    [ 627] = F["Kirin Tor"],
    [ 628] = F["Kirin Tor"],
    [ 629] = F["Kirin Tor"],
    -- Dalaran (Eastern Kingdoms) [SCENARIO (Quest: In the Blink of an Eye)]
    [ 501] = F["Kirin Tor"],
    [ 502] = F["Kirin Tor"],
    -- Dalaran (Northrend)
    [ 125] = F["Kirin Tor"],
    [ 126] = F["Kirin Tor"],
    -- Darkmoon Island
    [ 407] = F["Darkmoon Faire"],
    [ 408] = F["Darkmoon Faire"],
    -- Darkshore
    [  62] = A and F["Darnassus"],
    -- Darnassus
    [  89] = A and F["Darnassus"],
    -- Deepholm
    [ 207] = F["The Earthen Ring"],
    -- Dire Maul
    [ 234] = F["Shen'dralar"],
    [ 235] = F["Shen'dralar"],
    [ 236] = F["Shen'dralar"],
    [ 237] = F["Shen'dralar"],
    [ 238] = F["Shen'dralar"],
    [ 239] = F["Shen'dralar"],
    [ 240] = F["Shen'dralar"],
    -- Deadwind Pass
    [  42] = F["The Violet Eye"],
    -- Deathknell
    [ 465] = H and F["Undercity"],
    -- Dragonblight
    [ 115] = F["The Wyrmrest Accord"],
    -- Drak'Tharon Keep
    [ 160] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    [ 161] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    -- Dread Wastes
    [ 422] = F["The Klaxxi"],
    -- Dun Morogh
    [  27] = A and F["Ironforge"],
    [ 523] = A and F["Ironforge"],
    -- Durotar
    [   1] = H and F["Orgrimmar"],
    -- Eastern Plaguelands
    [  23] = F["Argent Dawn"],
    -- Echo Isles
    [ 463] = H and F["Darkspear Trolls"],
    -- Elwynn Forest
    [  37] = A and F["Stormwind"],
    -- Eversong Woods
    [  94] = H and F["Silvermoon City"],
    -- Eye of Azshara
    [ 713] = F["The Wardens"],
    [ 790] = F["The Wardens"],
    -- Feralas
    [  69] = H and F["Thunder Bluff"] or A and F["Darnassus"],
    -- Firelands
    [ 367] = F["Avengers of Hyjal"],
    [ 368] = F["Avengers of Hyjal"],
    [ 369] = F["Avengers of Hyjal"],
    [ 738] = F["Avengers of Hyjal"],
    -- Frostfire Ridge
    [ 525] = H and F["Frostwolf Orcs"],
    -- Ghostlands
    [  95] = H and F["Tranquillien"],
    -- Gilneas
    [ 179] = A and F["Gilneas"],
    -- Gilneas City
    [ 202] = A and F["Gilneas"],
    -- Gilneas Island
    [ 938] = A and F["Gilneas"],
    -- Gloaming Reef [SCENARIO (Quest: Fish Frenzy)]
    [ 758] = F["Nat Pagle"],
    -- Greater Invasion Point: Inquisitor Meto
    [ 930] = F["Army of the Light"],
    -- Greater Invasion Point: Matron Folnuna
    [ 929] = F["Army of the Light"],
    -- Greater Invasion Point: Mistress Alluradel
    [ 928] = F["Army of the Light"],
    -- Greater Invasion Point: Occularus
    [ 932] = F["Army of the Light"],
    -- Greater Invasion Point: Pit Lord Vilemus
    [ 927] = F["Army of the Light"],
    -- Greater Invasion Point: Sotanathor
    [ 931] = F["Army of the Light"],
    -- Grimrail Depot
    [ 606] = H and F["Frostwolf Orcs"] or A and F["Council of Exarchs"],
    [ 607] = H and F["Frostwolf Orcs"] or A and F["Council of Exarchs"],
    [ 608] = H and F["Frostwolf Orcs"] or A and F["Council of Exarchs"],
    [ 609] = H and F["Frostwolf Orcs"] or A and F["Council of Exarchs"],
    -- Grizzly Hills
    [ 116] = H and F["Warsong Offensive"] or A and F["Valiance Expedition"],
    -- Gundrak
    [ 153] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    [ 154] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    -- Hall of the Guardian
    [ 734] = F["Kirin Tor"],
    [ 735] = F["Kirin Tor"],
    -- Halls of Lightning
    [ 138] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    [ 139] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    -- Halls of Reflection
    [ 185] = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
    -- Halls of Stone
    [ 140] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    -- Hellfire Peninsula
    [ 100] = H and F["Thrallmar"] or A and F["Honor Hold"],
    -- Hellfire Ramparts
    [ 347] = H and F["Thrallmar"] or A and F["Honor Hold"],
    -- Highmountain
    [ 650] = F["Highmountain Tribe"],
    [ 869] = F["Highmountain Tribe"],
    [ 870] = F["Highmountain Tribe"],
    -- Hillsbrad Foothills
    [  25] = H and F["Undercity"] or A and F["Stormwind"],
    -- Hillsbrad Foothills (Southshore vs. Tarren Mill)
    [ 623] = H and F["Undercity"] or A and F["Stormwind"],
    -- Howling Fjord
    [ 117] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    -- Hyjal Summit
    [ 329] = F["The Scale of the Sands"],
    -- Icecrown
    [ 118] = F["Knights of the Ebon Blade"],
    -- Icecrown Citadel
    [ 186] = F["The Ashen Verdict"],
    [ 187] = F["The Ashen Verdict"],
    [ 188] = F["The Ashen Verdict"],
    [ 189] = F["The Ashen Verdict"],
    [ 190] = F["The Ashen Verdict"],
    [ 191] = F["The Ashen Verdict"],
    [ 192] = F["The Ashen Verdict"],
    [ 193] = F["The Ashen Verdict"],
    [ 698] = F["The Ashen Verdict"],
    [ 699] = F["The Ashen Verdict"],
    [ 700] = F["The Ashen Verdict"],
    [ 701] = F["The Ashen Verdict"],
    -- Invasion Point: Aurinor
    [ 921] = F["Army of the Light"],
    -- Invasion Point: Bonich
    [ 922] = F["Army of the Light"],
    -- Invasion Point: Cen'gar
    [ 923] = F["Army of the Light"],
    -- Invasion Point: Naigtal
    [ 924] = F["Army of the Light"],
    -- Invasion Point: Sangua
    [ 925] = F["Army of the Light"],
    -- Invasion Point: Val
    [ 926] = F["Army of the Light"],
    -- Iron Docks
    [ 595] = H and F["Frostwolf Orcs"] or A and F["Council of Exarchs"],
    -- Ironforge
    [  87] = A and F["Ironforge"],
    -- Isle of Quel'Danas
    [ 122] = F["Shattered Sun Offensive"],
    -- Isle of Thunder
    [ 504] = H and F["Sunreaver Onslaught"] or A and F["Kirin Tor Offensive"],
    [ 516] = H and F["Sunreaver Onslaught"] or A and F["Kirin Tor Offensive"],
    -- Karazhan
    [ 350] = F["The Violet Eye"],
    [ 351] = F["The Violet Eye"],
    [ 352] = F["The Violet Eye"],
    [ 353] = F["The Violet Eye"],
    [ 354] = F["The Violet Eye"],
    [ 355] = F["The Violet Eye"],
    [ 356] = F["The Violet Eye"],
    [ 357] = F["The Violet Eye"],
    [ 358] = F["The Violet Eye"],
    [ 359] = F["The Violet Eye"],
    [ 360] = F["The Violet Eye"],
    [ 361] = F["The Violet Eye"],
    [ 362] = F["The Violet Eye"],
    [ 363] = F["The Violet Eye"],
    [ 364] = F["The Violet Eye"],
    [ 365] = F["The Violet Eye"],
    [ 366] = F["The Violet Eye"],
    [ 794] = F["The Violet Eye"],
    [ 795] = F["The Violet Eye"],
    [ 796] = F["The Violet Eye"],
    [ 797] = F["The Violet Eye"],
    [ 809] = F["The Violet Eye"],
    [ 810] = F["The Violet Eye"],
    [ 811] = F["The Violet Eye"],
    [ 812] = F["The Violet Eye"],
    [ 813] = F["The Violet Eye"],
    [ 814] = F["The Violet Eye"],
    [ 815] = F["The Violet Eye"],
    [ 816] = F["The Violet Eye"],
    [ 817] = F["The Violet Eye"],
    [ 818] = F["The Violet Eye"],
    [ 819] = F["The Violet Eye"],
    [ 820] = F["The Violet Eye"],
    [ 821] = F["The Violet Eye"],
    [ 822] = F["The Violet Eye"],
    -- Kelp'thar Forest
    [ 201] = F["The Earthen Ring"],
    -- Kezan
    [ 194] = H and F["Bilgewater Cartel"],
    -- Krasarang Wilds
    [ 418] = F["The Anglers"],
    [ 486] = F["The Anglers"],
    [ 498] = F["The Anglers"],
    -- Krokuun
    [ 830] = F["Army of the Light"],
    -- Loch Modan
    [  48] = A and F["Ironforge"],
    -- Mac'Aree
    [ 882] = F["Argussian Reach"],
    -- Magisters' Terrace
    [ 348] = F["Shattered Sun Offensive"],
    [ 349] = F["Shattered Sun Offensive"],
    -- Magtheridon's Lair
    [ 331] = H and F["Thrallmar"] or A and F["Honor Hold"],
    -- Mana-Tombs
    [ 272] = F["The Consortium"],
    -- Molten Core
    [ 232] = F["Hydraxian Waterlords"],
    -- Molten Front
    [ 338] = F["Guardians of Hyjal"],
    -- Moonglade
    [  80] = F["Cenarion Circle"],
    -- Mount Hyjal
    [ 198] = F["Guardians of Hyjal"],
    -- Mulgore
    [   7] = H and F["Thunder Bluff"],
    -- Nagrand (Draenor)
    [ 550] = F["Steamwheedle Preservation Society"],
    -- Nagrand (Outland)
    [ 107] = H and F["The Mag'har"] or A and F["Kurenai"],
    -- Netherstorm
    [ 109] = F["The Consortium"],
    -- New Tinkertown
    [ 469] = A and F["Gnomeregan"],
    -- Northern Barrens
    [  10] = H and F["Orgrimmar"] or A and F["Ratchet"],
    -- Northshire
    [ 425] = A and F["Stormwind"],
    -- Old Hillsbrad Foothills
    [ 274] = F["Keepers of Time"],
    -- Orgrimmar
    [  85] = H and F["Orgrimmar"],
    [  86] = H and F["Orgrimmar"],
    -- Pit of Saron
    [ 184] = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
    [ 823] = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
    -- Redridge Mountains
    [  49] = A and F["Stormwind"],
    -- Ruins of Ahn'Qiraj
    [ 247] = F["Cenarion Circle"],
    -- Ruins of Gilneas
    [ 217] = H and F["Undercity"] or A and F["Gilneas"],
    -- Ruins of Gilneas City
    [ 218] = H and F["Undercity"] or A and F["Gilneas"],
    -- Scholomance
    [ 476] = F["Argent Dawn"],
    [ 477] = F["Argent Dawn"],
    [ 478] = F["Argent Dawn"],
    [ 479] = F["Argent Dawn"],
    -- ScholomanceOLD
    [ 306] = F["Argent Dawn"],
    [ 307] = F["Argent Dawn"],
    [ 308] = F["Argent Dawn"],
    [ 309] = F["Argent Dawn"],
    -- Serpentshrine Cavern
    [ 332] = F["Cenarion Expedition"],
    -- Sethekk Halls
    [ 258] = F["Lower City"],
    [ 259] = F["Lower City"],
    -- Shadow Labyrinth
    [ 260] = F["Lower City"],
    -- Shadowglen
    [ 460] = F["Darnassus"],
    -- Shadowmoon Burial Grounds
    [ 574] = H and F["Frostwolf Orcs"] or A and F["Council of Exarchs"],
    [ 575] = H and F["Frostwolf Orcs"] or A and F["Council of Exarchs"],
    [ 576] = H and F["Frostwolf Orcs"] or A and F["Council of Exarchs"],
    -- Shadowmoon Valley (Draenor)
    [ 539] = A and F["Council of Exarchs"],
    -- Shadowmoon Valley (Outland)
    [ 104] = F["Netherwing"],
    -- Shattrath City (Draenor)
    [ 594] = H and F["Frostwolf Orcs"] or A and F["Council of Exarchs"],
    -- Shattrath City (Outland)
    [ 111] = F["The Sha'tar"],
    -- Shimmering Expanse
    [ 205] = F["The Earthen Ring"],
    -- Sholazar Basin
    [ 119] = { [F["Frenzyheart Tribe"]] = true, [F["The Oracles"]] = true },
    -- Silithus
    [  81] = F["Cenarion Circle"],
    -- Silvermoon City
    [ 110] = H and F["Silvermoon City"],
    -- Silverpine Forest
    [  21] = H and F["Undercity"] or A and F["Gilneas"],
    -- Skyreach
    [ 601] = F["Arakkoa Outcasts"],
    [ 602] = F["Arakkoa Outcasts"],
    -- Southern Barrens
    [ 199] = H and F["Orgrimmar"] or A and F["Stormwind"],
    -- Spires of Arak
    [ 542] = F["Arakkoa Outcasts"],
    -- Stonetalon Mountains
    [  65] = H and F["Orgrimmar"] or A and F["Darnassus"],
    -- Stormheim
    [ 634] = F["Valarjar"],
    [ 696] = F["Valarjar"],
    [ 865] = F["Valarjar"],
    [ 866] = F["Valarjar"],
    -- Stormshield
    [ 622] = H and F["Vol'jin's Spear"] or A and F["Wrynn's Vanguard"],
    -- Stormwind City
    [  84] = A and F["Stormwind"],
    -- Stratholme
    [ 317] = F["Argent Dawn"],
    [ 318] = F["Argent Dawn"],
    [ 827] = F["Argent Dawn"],
    -- Sunwell Plateau
    [ 335] = F["Shattered Sun Offensive"],
    [ 336] = F["Shattered Sun Offensive"],
    -- Suramar
    [ 680] = F["The Nightfallen"],
    -- Talador
    [ 535] = H and F["Frostwolf Orcs"] or A and F["Council of Exarchs"],
    -- Tanaan Jungle
    [ 534] = H and F["Vol'jin's Headhunters"] or A and F["Hand of the Prophet"],
    [ 577] = H and F["Vol'jin's Headhunters"] or A and F["Hand of the Prophet"],
    -- Tanaris
    [  71] = F["Gadgetzan"],
    -- Teldrassil
    [  57] = A and F["Darnassus"],
    -- Tempest Keep
    [ 334] = F["The Sha'tar"],
    -- Terokkar Forest
    [ 108] = F["Lower City"],
    -- The Arcatraz
    [ 269] = F["The Sha'tar"],
    [ 270] = F["The Sha'tar"],
    [ 271] = F["The Sha'tar"],
    -- The Black Morass
    [ 273] = F["Keepers of Time"],
    -- The Blood Furnace
    [ 261] = H and F["Thrallmar"] or A and F["Honor Hold"],
    -- The Botanica
    [ 266] = F["The Sha'tar"],
    -- The Culling of Stratholme
    [ 130] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    [ 131] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    -- The Deaths of Chromie
    [ 897] = F["Chromie"],
    [ 898] = F["Chromie"],
    [ 899] = F["Chromie"],
    [ 900] = F["Chromie"],
    [ 901] = F["Chromie"],
    [ 902] = F["Chromie"],
    -- The Dreamgrove
    [ 747] = F["Cenarion Circle"],
    -- The Forge of Souls
    [ 183] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    -- The Everbloom
    [ 620] = H and F["Laughing Skull Orcs"] or A and F["Sha'tari Defense"],
    [ 621] = H and F["Laughing Skull Orcs"] or A and F["Sha'tari Defense"],
    -- The Exodar
    [ 103] = A and F["Exodar"],
    [ 775] = A and F["Exodar"],
    -- The Forge of Souls
    [ 183] = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
    -- The Jade Forest
    [ 371] = H and F["Forest Hozen"] or A and F["Pearlfin Jinyu"],
    [ 448] = H and F["Forest Hozen"] or A and F["Pearlfin Jinyu"],
    -- The Lost Isles
    [ 174] = H and F["Bilgewater Cartel"],
    -- The Maelstrom
    [ 276] = F["The Earthen Ring"],
    [ 725] = F["The Earthen Ring"],
    [ 839] = F["The Earthen Ring"],
    -- The Maelstrom (The Heart of Azeroth)
    [ 726] = F["The Earthen Ring"],
    -- The Mechanar
    [ 267] = F["The Sha'tar"],
    [ 268] = F["The Sha'tar"],
    -- The Nexus
    [ 129] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    [ 370] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    -- The Oculus
    [ 142] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    [ 143] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    [ 144] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    [ 145] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    [ 146] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    [ 799] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    [ 800] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    [ 801] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    [ 802] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    [ 803] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    -- The Shattered Halls
    [ 246] = H and F["Thrallmar"] or A and F["Honor Hold"],
    -- The Slave Pens
    [ 265] = F["Cenarion Expedition"],
    -- The Steamvault
    [ 263] = F["Cenarion Expedition"],
    [ 264] = F["Cenarion Expedition"],
    -- The Stonecore
    [ 324] = F["The Earthen Ring"],
    -- The Storm Peaks
    [ 120] = F["The Sons of Hodir"],
    -- The Underbog
    [ 262] = F["Cenarion Expedition"],
    -- The Violet Hold (Broken Isles)
    [ 723] = F["Kirin Tor"],
    -- The Violet Hold (Northrend)
    [ 168] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    -- The Wandering Isle
    [ 378] = F["Shang Xi's Academy"],
    [ 709] = F["Shang Xi's Academy"],
    -- Thousand Needles
    [  64] = H and F["Bilgewater Cartel"] or A and F["Gnomeregan"],
    -- Throne of the Four Winds [SCENARIO (Quest: Gathering of the Storms)]
    [ 857] = F["The Earthen Ring"],
    -- Throne of Thunder
    [ 508] = F["Shado-Pan Assault"],
    [ 509] = F["Shado-Pan Assault"],
    [ 510] = F["Shado-Pan Assault"],
    [ 511] = F["Shado-Pan Assault"],
    [ 512] = F["Shado-Pan Assault"],
    [ 513] = F["Shado-Pan Assault"],
    [ 514] = F["Shado-Pan Assault"],
    [ 515] = F["Shado-Pan Assault"],
    -- Thunder Bluff
    [  88] = H and F["Thunder Bluff"],
    -- Thunder King's Citadel [SCENARIO (Quest: Treasures of the Thunder King)]
    [ 518] = H and F["Sunreaver Onslaught"] or A and F["Kirin Tor Offensive"],
    -- Thunder Totem
    [ 750] = F["Highmountain Tribe"],
    -- Timeless Isle
    [ 554] = F["Emperor Shaohao"],
    -- Tirisfal Glades
    [  18] = H and F["Undercity"],
    -- Tol Barad
    [ 244] = H and F["Hellscream's Reach"] or A and F["Baradin's Wardens"],
    [ 773] = H and F["Hellscream's Reach"] or A and F["Baradin's Wardens"],
    [ 774] = H and F["Hellscream's Reach"] or A and F["Baradin's Wardens"],
    -- Tol Barad Peninsula
    [ 245] = H and F["Hellscream's Reach"] or A and F["Baradin's Wardens"],
    -- Townlong Steppes
    [ 388] = F["Shado-Pan"],
    -- Trial of the Champion
    [ 171] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    -- Trial of the Crusader
    [ 172] = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
    [ 173] = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
    -- Twilight Highlands
    [ 241] = H and F["Dragonmaw Clan"] or A and F["Wildhammer Clan"],
    -- Uldum
    [ 249] = F["Ramkahen"],
    -- Undercity
    [  90] = H and F["Undercity"],
    -- Upper Blackrock Spire
    [ 616] = F["Steamwheedle Preservation Society"],
    [ 617] = F["Steamwheedle Preservation Society"],
    [ 618] = F["Steamwheedle Preservation Society"],
    -- Utgarde Keep
    [ 133] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    [ 134] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    [ 135] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    -- Utgarde Pinnacle
    [ 136] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    [ 137] = H and F["The Hand of Vengeance"] or A and F["Valiance Expedition"],
    -- Val'sharah
    [ 641] = F["Dreamweavers"],
    [ 868] = F["Dreamweavers"],
    -- Vale of Eternal Blossoms
    [ 390] = F["Golden Lotus"],
    [ 520] = F["Golden Lotus"],
    [ 521] = F["Golden Lotus"],
    -- Valley of the Four Winds
    [ 376] = F["The Tillers"],
    -- Valley of Trials
    [ 461] = H and F["Orgrimmar"],
    -- Warsong Gulch
    [  92] = H and F["Warsong Outriders"] or A and F["Silverwing Sentinels"],
    [ 859] = H and F["Warsong Outriders"] or A and F["Silverwing Sentinels"],
    -- Warspear
    [ 624] = H and F["Vol'jin's Spear"] or A and F["Wrynn's Vanguard"],
    -- Well of Eternity
    [ 398] = A and F["Darnassus"],
    -- Western Plaguelands
    [  22] = F["Argent Crusade"],
    -- Wetlands
    [  56] = A and F["Ironforge"],
    -- Winterspring
    [  83] = F["Everlook"],
    -- Zangarmarsh
    [ 102] = F["Cenarion Expedition"],
    -- Zul'Drak
    [ 121] = F["Argent Crusade"],
    -- Zul'Gurub
    [ 233] = F["Zandalar Tribe"],
    [ 337] = F["Zandalar Tribe"],
  }

  ----------------------------------------------------------------------------------------------------------------------

  self.subzoneFactions = {
    -- Arathi Highlands
    [  14] = {
      ["Faldir's Cove"]                  = F["Booty Bay"],
      ["Galen's Fall"]                   = F["Undercity"],
      ["Northfold Manor"]                = F["Ravenholdt"],
      ["Stromgarde Keep"]                = F["Ravenholdt"],
      ["The Drowned Reef"]               = F["Booty Bay"],
    },
    [ 906] = function(self) self.subzoneFactions[906] = self.subzoneFactions[14] end,
    [ 943] = function(self) self.subzoneFactions[943] = self.subzoneFactions[14] end,
    -- Azsuna
    [ 630] = {
      ["Isle of the Watchers"]           = F["The Wardens"],
      ["Wardens' Redoubt"]               = F["The Wardens"],
      ["Watchers' Aerie"]                = F["The Wardens"],
    },
    [ 867] = function(self) self.subzoneFactions[867] = self.subzoneFactions[630] end,
    -- Blade's Edge Mountains
    [ 105] = {
      ["Evergrove"]                      = F["Cenarion Expedition"],
      ["Ruuan Weald"]                    = F["Cenarion Expedition"],
      ["Forge Camp: Terror"]             = F["Ogri'la"],
      ["Forge Camp: Wrath"]              = F["Ogri'la"],
      ["Furywing's Perch"]               = F["Ogri'la"],
      ["Obsidia's Perch"]                = F["Ogri'la"],
      ["Ogri'la"]                        = F["Ogri'la"],
      ["Rivendark's Perch"]              = F["Ogri'la"],
      ["Shartuul's Transporter"]         = F["Ogri'la"],
      ["Skyguard Outpost"]               = F["Sha'tari Skyguard"],
      ["Vortex Pinnacle"]                = F["Ogri'la"],
      ["Vortex Summit"]                  = F["Ogri'la"],
    },
    -- Borean Tundra
    [ 114] = {
      ["D.E.H.T.A. Encampment"]          = F["Cenarion Expedition"],
      ["Amber Ledge"]                    = F["Kirin Tor"],
      ["Transitus Shield"]               = F["Kirin Tor"],
      ["Kaskala"]                        = F["The Kalu'ak"],
      ["Njord's Breath Bay"]             = F["The Kalu'ak"],
      ["Unu'pe"]                         = F["The Kalu'ak"],
      ["Taunka'le Village"]              = H and F["The Taunka"],
    },
    -- Crystalsong Forest
    [ 127] = {
      ["Sunreaver's Command"]            = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
      ["Windrunner's Overlook"]          = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
    },
    -- Dalaran (Broken Isles)
    [ 625] = {
      ["A Hero's Welcome"]               = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
      ["Greyfang Enclave"]               = H and F["Undercity"] or A and F["Gilneas"],
      ["Margoss's Retreat"]              = F["Conjurer Margoss"],
      ["The Beer Garden"]                = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
      ["The Filthy Animal"]              = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
      ["Windrunner's Sanctuary"]         = H and F["Undercity"] or A and F["Gilneas"],
    },
    [ 626] = function(self) self.subzoneFactions[626] = self.subzoneFactions[625] end,
    [ 627] = function(self) self.subzoneFactions[627] = self.subzoneFactions[625] end,
    [ 628] = function(self) self.subzoneFactions[628] = self.subzoneFactions[625] end,
    [ 629] = function(self) self.subzoneFactions[629] = self.subzoneFactions[625] end,
    -- Dalaran (Northrend)
    [ 125] = {
      ["A Hero's Welcome"]               = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
      ["Sunreaver's Sanctuary"]          = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
      ["The Beer Garden"]                = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
      ["The Filthy Animal"]              = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
      ["The Silver Enclave"]             = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
    },
    [ 126] = function(self) self.subzoneFactions[126] = self.subzoneFactions[125] end,
    -- Dalaran (Eastern Kingdoms) [SCENARIO (Quest: In the Blink of an Eye)]
    [ 501] = function(self) self.subzoneFactions[501] = self.subzoneFactions[125] end,
    [ 502] = function(self) self.subzoneFactions[502] = self.subzoneFactions[125] end,
    -- Deadwind Pass
    [  42] = { -- TODO: update
    },
    -- Deepholm
    [ 207] = {
      ["Crimson Expanse"]                = F["Therazane"],
      ["Crumbling Depths"]               = F["Therazane"],
      ["Fungal Deep"]                    = F["Therazane"],
      ["Halcyon Egress"]                 = F["Therazane"],
      ["Lorthuna's Gate"]                = F["Therazane"],
      ["Shuddering Spires"]              = F["Therazane"],
      ["The Pale Roost"]                 = F["Therazane"],
      ["Therazane's Throne"]             = F["Therazane"],
      ["Twilight Precipice"]             = F["Therazane"],
      ["Verlok Stand"]                   = F["Therazane"],
    },
    -- Deeprun Tram
    [ 499] = {
      ["Bizmo's Brawlpub"]               = A and F["Bizmo's Brawlpub"],
    },
    [ 500] = function(self) self.subzoneFactions[500] = self.subzoneFactions[499] end,
    -- Desolace
    [  66] = { -- TODO: update
    },
    -- Dragonblight
    [ 115] = {
      ["Light's Trust"]                  = F["Argent Crusade"],
      ["Moa'ki Harbor"]                  = F["The Kalu'ak"],
      ["Agmar's Hammer"]                 = H and F["Warsong Offensive"],
      ["Dragon's Fall"]                  = H and F["Warsong Offensive"],
      ["Venomspite"]                     = H and F["The Hand of Vengeance"],
      ["Westwind Refugee Camp"]          = H and F["The Taunka"],
      ["Stars' Rest"]                    = A and F["Valiance Expedition"],
      ["Wintergarde Keep"]               = A and F["Valiance Expedition"],
    },
    -- Dread Wastes
    [ 422] = {
      ["Lonesome Cove"]                  = F["The Anglers"],
      ["Shelf of Mazu"]                  = F["The Anglers"],
      ["Soggy's Gamble"]                 = F["The Anglers"],
      ["Wreck of the Mist-Hopper"]       = F["The Anglers"],
    },
    -- Durotar
    [   1] = { -- TODO: update
      ["Sen'jin Village"]                = H and F["Darkspear Trolls"],
    },
    -- Eastern Plaguelands
    [  23] = { -- TODO: update
      ["Acherus: The Ebon Hold"]         = F["Knights of the Ebon Blade"],
    },
    -- Felwood
    [  77] = { -- TODO: update
      ["Deadwood Village"]               = F["Timbermaw Hold"],
      ["Felpaw Village"]                 = F["Timbermaw Hold"],
      ["Timbermaw Hold"]                 = F["Timbermaw Hold"],
    },
    -- Gorgrond
    [ 543] = {
      ["Broken Horn Village"]            = H and F["Laughing Skull Orcs"],
      ["Deadmeat's House of Meat"]       = H and F["Laughing Skull Orcs"],
      ["Everbloom Wilds"]                = H and F["Laughing Skull Orcs"],
      ["The Pit"]                        = H and F["Laughing Skull Orcs"],
    },
    -- Grizzly Hills
    [ 116] = { -- TODO: add Alliance areas?
      ["Camp Oneqwah"]                   = H and F["The Taunka"],
    },
    -- Hellfire Peninsula
    [ 100] = {
      ["Cenarion Post"]                  = F["Cenarion Expedition"],
      ["Throne of Kil'jaeden"]           = F["Shattered Sun Offensive"],
      ["Mag'har Grounds"]                = H and F["The Mag'har"],
      ["Mag'har Post"]                   = H and F["The Mag'har"],
      ["Temple of Telhamat"]             = A and F["Kurenai"],
    },
    -- Highmountain
    [ 650] = {
      ["Cordana's Apex"]                 = H and F["Undercity"] or A and F["Gilneas"],
      ["Nightwatcher's Perch"]           = H and F["Undercity"] or A and F["Gilneas"],
      ["Sylvan Falls"]                   = F["Talon's Vengeance"],
    },
    [ 869] = function(self) self.subzoneFactions[869] = self.subzoneFactions[650] end,
    [ 870] = function(self) self.subzoneFactions[870] = self.subzoneFactions[650] end,
    -- Hillsbrad Foothills
    [  25] = {
      ["Alterac Mountains"]              = H and F["Frostwolf Clan"] or A and F["Stormpike Guard"],
      ["Alterac Valley"]                 = H and F["Frostwolf Clan"] or A and F["Stormpike Guard"],
      ["Azurelode Mine"]                 = A and F["Stormwind"],
      ["Corrahn's Dagger"]               = H and F["Frostwolf Clan"] or A and F["Stormpike Guard"],
      ["Dalaran Crater"]                 = F["Kirin Tor"],
      ["Gavin's Naze"]                   = H and F["Frostwolf Clan"] or A and F["Stormpike Guard"],
      ["Purgation Isle"]                 = H and F["Frostwolf Clan"] or A and F["Stormpike Guard"],
      ["Ravenholdt Manor"]               = F["Ravenholdt"],
      ["Sofera's Naze"]                  = A and F["Stormwind"],
      ["Strahnbrad"]                     = F["Ravenholdt"],
      ["The Headland"]                   = H and F["Frostwolf Clan"] or A and F["Stormpike Guard"],
    },
    -- Hillsbrad Foothills (Southshore vs. Tarren Mill)
    [ 623] = function(self) self.subzoneFactions[623] = self.subzoneFactions[25] end,
    -- Howling Fjord
    [ 117] = {
      ["Kamagua"]                        = F["The Kalu'ak"],
      ["Camp Winterhoof"]                = H and F["The Taunka"],
      ["Explorers' League Outpost"]      = A and F["Explorers' League"],
      ["Steel Gate"]                     = A and F["Explorers' League"],
    },
    -- Icecrown
    [ 118] = {
      ["The Argent Vanguard"]            = F["Argent Crusade"],
      ["Crusaders' Pinnacle"]            = F["Argent Crusade"],
      ["Scourgeholme"]                   = F["Argent Crusade"],
      ["The Breach"]                     = F["Argent Crusade"],
      ["The Pit of Fiends"]              = F["Argent Crusade"],
      ["Valley of Echoes"]               = F["Argent Crusade"],
      ["Orgrim's Hammer"]                = H and F["Warsong Offensive"],
      ["The Skybreaker"]                 = A and F["Valiance Expedition"],
      ["Argent Pavilion"]                = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
      ["Argent Tournament Grounds"]      = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
      ["Silver Covenant Pavilion"]       = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
      ["Sunreaver Pavilion"]             = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
      ["The Alliance Valiants' Ring"]    = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
      ["The Argent Valiants' Ring"]      = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
      ["The Aspirants' Ring"]            = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
      ["The Horde Valiants' Ring"]       = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
      ["The Ring of Champions"]          = H and F["The Sunreavers"] or A and F["The Silver Covenant"],
    },
    -- Krasarang Wilds
    [ 418] = {
      ["Angkhal Pavilion"]               = F["The August Celestials"],
      ["Cradle of Chi-Ji"]               = F["The August Celestials"],
      ["Dome Balrissa"]                  = F["The August Celestials"],
      ["Pedestal of Hope"]               = F["The August Celestials"],
      ["Temple of the Red Crane"]        = F["The August Celestials"],
      ["Dawnchaser Retreat"]             = H and F["Thunder Bluff"],
      ["Thunder Cleft"]                  = H and F["Thunder Bluff"],
      ["Sentinel Basecamp"]              = A and F["Darnassus"],
      ["Bilgewater Beach"]               = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
      ["Blacksand Spillway"]             = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
      ["Domination Point"]               = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
      ["Lion's Landing"]                 = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
      ["Oregrind's Dig"]                 = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
      ["Quickchop's Lumber Farm"]        = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
      ["Ruins of Ogudei"]                = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
      ["Sparkrocket Outpost"]            = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
      ["The Boiling Crustacean"]         = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
      ["The Skyfire"]                    = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
      ["The Southern Isles"]             = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
      -- Faction ships don't have a subzone name
      [""]                               = H and F["Dominance Offensive"] or A and F["Operation: Shieldwall"],
    },
    [ 486] = function(self) self.subzoneFactions[486] = self.subzoneFactions[418] end,
    [ 498] = function(self) self.subzoneFactions[498] = self.subzoneFactions[418] end,
    -- Krokuun
    [ 830] = {
      ["Krokul Hovel"]                   = F["Argussian Reach"],
      ["Petrified Forest"]               = F["Argussian Reach"],
    },
    -- Kun-Lai Summit
    [ 379] = {
      ["Gate of the August Celestials"]  = F["The August Celestials"],
      ["Temple of the White Tiger"]      = F["The August Celestials"],
      ["Firebough Nook"]                 = F["Shado-Pan"],
      ["Serpent's Spine"]                = F["Shado-Pan"],
      ["Shado-Li Basin"]                 = F["Shado-Pan"],
      ["Shado-Pan Fallback"]             = F["Shado-Pan"],
      ["Shado-Pan Monastery"]            = F["Shado-Pan"],
      ["The Ox Gate"]                    = F["Shado-Pan"],
      ["Winter's Blossom"]               = F["Shado-Pan"],
    },
    -- Mac'Aree
    [ 882] = {
      ["The Vindicaar"]                  = F["Army of the Light"],
    },
    -- Nagrand (Outland)
    [ 107] = {
      ["Aeris Landing"]                  = F["The Consortium"],
      ["Oshu'gun"]                       = F["The Consortium"],
      ["Spirit Fields"]                  = F["The Consortium"],
    },
    -- Netherstorm
    [ 109] = {
      ["Netherwing Ledge"]               = F["Netherwing"],
      ["Tempest Keep"]                   = F["The Sha'tar"],
    },
    -- Searing Gorge
    [  32] = {
      ["Thorium Point"]                  = F["Thorium Brotherhood"],
    },
    -- Shadowmoon Valley (Outland)
    [ 104] = {
      ["Altar of Sha'tar"]               = F["The Aldor"],
      ["Sanctum of the Stars"]           = F["The Scryers"],
      ["Warden's Cage"]                  = F["Ashtongue Deathsworn"],
    },
    -- Shattrath City (Outland)
    [ 111] = {
      ["Lower City"]                     = F["Lower City"],
      ["Aldor Rise"]                     = F["The Aldor"],
      ["Shrine of Unending Light"]       = F["The Aldor"],
      ["Scryer's Tier"]                  = F["The Scryers"],
      ["The Seer's Library"]             = F["The Scryers"],
    },
    -- Sholazar Basin
    [ 119] = {
      ["Frenzyheart Hill"]               = F["Frenzyheart Tribe"],
      ["Kartak's Hold"]                  = F["Frenzyheart Tribe"],
      ["Spearborn Encampment"]           = F["Frenzyheart Tribe"],
      ["Mistwhisper Refuge"]             = F["The Oracles"],
      ["Rainspeaker Canopy"]             = F["The Oracles"],
      ["Sparktouched Haven"]             = F["The Oracles"],
    },
    -- Southern Barrens
    [ 199] = {
      ["Firestone Point"]                = F["The Earthen Ring"],
      ["Ruins of Taurajo"]               = H and F["Thunder Bluff"],
      ["Spearhead"]                      = H and F["Thunder Bluff"],
      ["Vendetta Point"]                 = H and F["Thunder Bluff"],
      ["Bael Modan"]                     = H and F["Thunder Bluff"] or A and F["Ironforge"],
      ["Bael Modan Excavation"]          = H and F["Thunder Bluff"] or A and F["Ironforge"],
      ["Bael'dun Keep"]                  = H and F["Thunder Bluff"] or A and F["Ironforge"],
      ["Frazzlecraz Motherlode"]         = A and F["Ironforge"],
      ["Twinbraid's Patrol"]             = A and F["Ironforge"],
    },
    -- Spires of Arak
    [ 542] = {
      ["Pillars of Fate"]                = A and F["Council of Exarchs"],
    },
    -- Stranglethorn Vale
    [ 224] = { -- TODO: update
      ["Booty Bay"]                      = F["Booty Bay"],
      ["The Salty Sailor Tavern"]        = F["Booty Bay"],
    },
    -- Storm Peaks
    [ 120] = {
      ["Camp Tunka'lo"]                  = H and F["Warsong Offensive"],
      ["Frostfloe Deep"]                 = H and F["Warsong Offensive"],
      ["Frosthowl Cavern"]               = H and F["Warsong Offensive"],
      ["Gimorak's Den"]                  = H and F["Warsong Offensive"],
      ["Grom'arsh Crash-Site"]           = H and F["Warsong Offensive"],
      ["The Howling Hollow"]             = H and F["Warsong Offensive"],
      ["Plain of Echoes"]                = H and F["Warsong Offensive"] or A and F["The Frostborn"],
      ["Temple of Life"]                 = H and F["Warsong Offensive"] or A and F["The Frostborn"],
      ["Frosthold"]                      = A and F["The Frostborn"],
      ["Inventor's Library"]             = A and F["The Frostborn"],
      ["Loken's Bargain"]                = A and F["The Frostborn"],
      ["Mimir's Workshop"]               = A and F["The Frostborn"],
      ["Narvir's Cradle"]                = A and F["The Frostborn"],
      ["Nidavelir"]                      = A and F["The Frostborn"],
      ["Temple of Invention"]            = A and F["The Frostborn"],
      ["Temple of Order"]                = A and F["The Frostborn"],
      ["Temple of Winter"]               = A and F["The Frostborn"],
      ["The Foot Steppes"]               = A and F["The Frostborn"],
    },
    -- Stormheim
    [ 634] = {
      ["Blackhawk's Bulwark"]            = H and F["Undercity"] or A and F["Gilneas"],
      ["Cove of Nashal"]                 = H and F["Undercity"] or A and F["Gilneas"],
      ["Cullen's Post"]                  = H and F["Undercity"] or A and F["Gilneas"],
      ["Dreadwake's Landing"]            = H and F["Undercity"] or A and F["Gilneas"],
      ["Forsaken Foothold"]              = H and F["Undercity"] or A and F["Gilneas"],
      ["Greymane's Offensive"]           = H and F["Undercity"] or A and F["Gilneas"],
      ["Greywatch"]                      = H and F["Undercity"] or A and F["Gilneas"],
      ["Lorna's Watch"]                  = H and F["Undercity"] or A and F["Gilneas"],
      ["Ranger's Foothold"]              = H and F["Undercity"] or A and F["Gilneas"],
      ["Skyfire Triage Camp"]            = H and F["Undercity"] or A and F["Gilneas"],
      ["The King's Fang"]                = H and F["Undercity"] or A and F["Gilneas"],
      ["The Oblivion"]                   = H and F["Undercity"] or A and F["Gilneas"],
      ["Weeping Bluffs"]                 = H and F["Undercity"] or A and F["Gilneas"],
      ["Whisperwind's Citadel"]          = H and F["Undercity"] or A and F["Gilneas"],
    },
    [ 696] = function(self) self.subzoneFactions[696] = self.subzoneFactions[634] end,
    [ 865] = function(self) self.subzoneFactions[865] = self.subzoneFactions[634] end,
    [ 866] = function(self) self.subzoneFactions[866] = self.subzoneFactions[634] end,
    -- Talador
    [ 535] = {
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
    [ 534] = {
      ["Aktar's Post"]                   = F["Arakkoa Outcasts"],
      ["Fang'rila"]                      = F["The Saberstalkers"],
      ["Blackfang Challenge Arena"]      = F["The Saberstalkers"],
      ["Rangari Refuge"]                 = H and F["Laughing Skull Orcs"] or A and F["Sha'tari Defense"],
    },
    [ 577] = function(self) self.subzoneFactions[577] = self.subzoneFactions[534] end,
    -- Tanaris
    [  71] = { -- TODO: update
      ["Caverns of Time"]                = F["Keepers of Time"],
    },
    -- Terokkar Forest
    [ 108] = {
      ["Mana Tombs"]                     = F["The Consortium"],
      ["Blackwind Lake"]                 = F["Sha'tari Skyguard"],
      ["Blackwind Landing"]              = F["Sha'tari Skyguard"],
      ["Blackwind Valley"]               = F["Sha'tari Skyguard"],
      ["Lake Ere'Noru"]                  = F["Sha'tari Skyguard"],
      ["Lower Veil Shil'ak"]             = F["Sha'tari Skyguard"],
      ["Skettis"]                        = F["Sha'tari Skyguard"],
      ["Terokk's Rest"]                  = F["Sha'tari Skyguard"],
      ["Upper Veil Shil'ak"]             = F["Sha'tari Skyguard"],
      ["Veil Ala'rak"]                   = F["Sha'tari Skyguard"],
      ["Veil Harr'ik"]                   = F["Sha'tari Skyguard"],
    },
    -- The Jade Forest
    [ 371] = {
      ["Fountain of the Everseeing"]     = F["The August Celestials"],
      ["Jade Temple Grounds"]            = F["The August Celestials"],
      ["Temple of the Jade Serpent"]     = F["The August Celestials"],
      ["Terrace of the Twin Dragons"]    = F["The August Celestials"],
      ["The Heart of Jade"]              = F["The August Celestials"],
      ["The Scrollkeeper's Sanctum"]     = F["The August Celestials"],
      ["Mistveil Sea"]                   = F["Order of the Cloud Serpent"],
      ["Oona Kagu"]                      = F["Order of the Cloud Serpent"],
      ["Serpent's Heart"]                = F["Order of the Cloud Serpent"],
      ["Serpent's Overlook"]             = F["Order of the Cloud Serpent"],
      ["The Arboretum"]                  = F["Order of the Cloud Serpent"],
      ["The Widow's Wail"]               = F["Order of the Cloud Serpent"],
      ["Windward Isle"]                  = F["Order of the Cloud Serpent"],
    },
    [ 448] = function(self) self.subzoneFactions[448] = self.subzoneFactions[371] end,
    -- The Veiled Stair
    [ 433] = {
      ["Tavern in the Mists"]            = F["The Black Prince"],
    },
    -- Thousand Needles
    [  64] = {
      ["Arikara's Needle"]               = H and F["Thunder Bluff"] or A and F["Darnassus"],
      ["Darkcloud Pinnacle"]             = H and F["Thunder Bluff"] or A and F["Darnassus"],
      ["Freewind Post"]                  = H and F["Thunder Bluff"] or A and F["Darnassus"],
    },
    -- Tirisfal Glades
    [  18] = { -- TODO: update
      ["The Bulwark"]                    = F["Argent Dawn"],
    },
    -- Townlong Steppes
    [ 388] = {
      ["Niuzao Temple"]                  = F["The August Celestials"],
    },
    -- Twilight Highlands
    [ 241] = {
      ["Iso'rath"]                       = F["The Earthen Ring"],
      ["Ring of the Elements"]           = F["The Earthen Ring"],
      ["Ruins of Drakgor"]               = F["The Earthen Ring"],
      ["The Maw of Madness"]             = F["The Earthen Ring"],
      ["Dragonmaw Pass"]                 = H and F["Bilgewater Cartel"],
      ["The Krazzworks"]                 = H and F["Bilgewater Cartel"],
      ["Highbank"]                       = H and F["Bilgewater Cartel"] or A and F["Stormwind"],
      ["Obsidian Forest"]                = A and F["Stormwind"],
      ["Victor's Point"]                 = A and F["Stormwind"],
    },
    -- Val'sharah
    [ 641] = {
      ["Darkfollow's Spire"]             = H and F["Undercity"] or A and F["Gilneas"],
      ["Starstalker's Point"]            = H and F["Undercity"] or A and F["Gilneas"],
    },
    [ 868] = function(self) self.subzoneFactions[868] = self.subzoneFactions[641] end,
    -- Vale of Eternal Blossoms
    [ 390] = {
      [""]                               = F["The August Celestials"],
      ["Gate of the Setting Sun"]        = F["Shado-Pan"],
      ["Mogu'shan Palace"]               = F["The August Celestials"],
      ["Seat of Knowledge"]              = F["The Lorewalkers"],
      ["Serpent's Spine"]                = F["Shado-Pan"],
      -- Shrine of Seven Stars
      ["Chamber of Enlightenment"]       = F["The August Celestials"],
      ["Chamber of Reflection"]          = F["The August Celestials"],
      ["Ethereal Corridor"]              = F["The August Celestials"],
      ["Path of Serenity"]               = F["The August Celestials"],
      ["The Celestial Vault"]            = F["The August Celestials"],
      ["The Emperor's Step"]             = F["The August Celestials"],
      ["The Golden Lantern"]             = F["The August Celestials"],
      ["The Imperial Exchange"]          = F["The August Celestials"],
      ["The Star's Bazaar"]              = F["The August Celestials"],
      ["The Summer Terrace"]             = F["The August Celestials"],
      -- Shrine of Two Moons
      ["Chamber of Masters"]             = F["The August Celestials"],
      ["Chamber of Wisdom"]              = F["The August Celestials"],
      ["Hall of Secrets"]                = F["The August Celestials"],
      ["Hall of Tranquility"]            = F["The August Celestials"],
      ["Hall of the Crescent Moon"]      = F["The August Celestials"],
      ["Summer's Rest"]                  = F["The August Celestials"],
      ["The Golden Terrace"]             = F["The August Celestials"],
      ["The Imperial Mercantile"]        = F["The August Celestials"],
      ["The Jade Vaults"]                = F["The August Celestials"],
      ["The Keggary"]                    = F["The August Celestials"],
    },
    [ 520] = function(self) self.subzoneFactions[520] = self.subzoneFactions[390] end,
    [ 521] = function(self) self.subzoneFactions[521] = self.subzoneFactions[390] end,
    -- Valley of the Four Winds
    [ 376] = {
      ["Serpent's Spine"]                = F["Shado-Pan"],
    },
    -- Western Plaguelands
    [  22] = { -- TODO: update
      ["Andorhal"]                       = A and F["Stormwind"] or F["Undercity"],
      ["Chillwind Camp"]                 = A and F["Stormwind"],
      ["Sorrow Hill"]                    = A and F["Stormwind"],
      ["Uther's Tomb"]                   = A and F["Stormwind"],
    },
    -- Wetlands
    [  56] = { -- TODO: update
      ["Direforge Hill"]                 = A and F["Darnassus"],
      ["Greenwarden's Grove"]            = A and F["Darnassus"],
      ["Menethil Harbor"]                = A and F["Stormwind"],
      ["The Green Belt"]                 = A and F["Darnassus"],
    },
    -- Winterspring
    [  83] = { -- TODO: update
      ["Frostfire Hot Springs"]          = F["Timbermaw Hold"],
      ["Timbermaw Hold"]                 = F["Timbermaw Hold"],
      ["Timbermaw Post"]                 = F["Timbermaw Hold"],
      ["Winterfall Village"]             = F["Timbermaw Hold"],
      ["Frostsaber Rock"]                = A and F["Wintersaber Trainers"],
    },
    -- Zangarmarsh
    [ 102] = {
      ["Funggor Cavern"]                 = F["Sporeggar"],
      ["Quagg Ridge"]                    = F["Sporeggar"],
      ["Sporeggar"]                      = F["Sporeggar"],
      ["The Spawning Glen"]              = F["Sporeggar"],
      ["Swamprat Post"]                  = H and F["Darkspear Trolls"],
      ["Zabra'jin"]                      = H and F["Darkspear Trolls"],
      ["Telredor"]                       = A and F["Exodar"],
    },
    -- Zul'Drak
    [ 121] = {
      ["Ebon Watch"]                     = F["Knights of the Ebon Blade"],
    },
  }

  ----------------------------------------------------------------------------------------------------------------------

  -- Remove faction-related false values
  for zone, faction in pairs(self.zoneFactions) do
    if not faction then
      self.zoneFactions[zone] = nil
    end
  end
  for zone, f in pairs(self.subzoneFactions) do
    if type(f) == "function" then
      self.subzoneFactions[zone](self)
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
