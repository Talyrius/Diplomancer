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

local ADDON_NAME, Diplomancer = ...

------------------------------------------------------------------------------------------------------------------------

Diplomancer.OptionsPanel = LibStub("PhanxConfig-OptionsPanel").CreateOptionsPanel(ADDON_NAME, nil, function(self)
  local L = Diplomancer.L
  local db = DiplomancerSettings
  local racialFaction = Diplomancer.racialFaction

  local factions, factionDisplayNames = {}, {}

  ----------------------------------------------------------------------------------------------------------------------

  local title, notes = self:CreateHeader(ADDON_NAME, true)

  local reset

  local default = self:CreateDropdown(L.DefaultFaction, L.DefaultFaction_Desc, factions)
  default:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 0, -8)
  default:SetWidth(270)
  function default:OnValueChanged(value)
    if value == racialFaction then
      db.defaultFaction = nil
      reset:Disable()
    else
      db.defaultFaction = Diplomancer:GetFactionIDFromName(factionDisplayNames[value] or value)
      reset:Enable()
    end
    Diplomancer:Update()
  end

  reset = self:CreateButton(L.Reset, L.Reset_Desc)
  reset:SetPoint("TOPLEFT", default.button, "TOPRIGHT", 8, 0)
  reset:SetPoint("BOTTOMLEFT", default.button, "BOTTOMRIGHT", 8, 0)
  reset:SetWidth(max(16 + reset:GetFontString():GetStringWidth(), 80))
  function reset:OnClick()
    self:Disable()
    db.defaultFaction = nil
    default:SetValue((Diplomancer:GetFactionNameFromID(racialFaction)))
    Diplomancer:Update()
  end

  local champion = self:CreateCheckbox(L.DefaultToChampioned, L.DefaultToChampioned_Desc)
  champion:SetPoint("TOPLEFT", default, "BOTTOMLEFT", 0, -10)
  function champion:OnValueChanged(value)
    db.defaultChampion = value
    Diplomancer:Update()
  end

  local exalted = self:CreateCheckbox(L.IgnoreExalted, L.IgnoreExalted_Desc)
  exalted:SetPoint("TOPLEFT", champion, "BOTTOMLEFT", 0, -8)
  function exalted:OnValueChanged(value)
    db.ignoreExalted = value
    Diplomancer:Update()
  end

  local announce = self:CreateCheckbox(L.Announce, L.Anounce_Desc)
  announce:SetPoint("TOPLEFT", exalted, "BOTTOMLEFT", 0, -8)
  function announce:OnValueChanged(value)
    db.verbose = value
  end

  ----------------------------------------------------------------------------------------------------------------------

  self.refresh = function()
    wipe(factions)
    Diplomancer:ExpandFactionHeaders()
    local curHeader
    for i = 1, GetNumFactions() do
      local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar,
        isHeader, isCollapsed, hasRep, isWatched, isChild, factionID = GetFactionInfo(i)
      if name == FACTION_INACTIVE then
        break
      end
      if isHeader and isChild then
        curHeader = name
      elseif curHeader and (isHeader or not isChild) then
        curHeader = nil
      end
      if (hasRep or not isHeader) and (standingID < 8 or not db.ignoreExalted) then
        if curHeader and factionID and GetFriendshipReputation(factionID) then
          local display = format("%s: %s", curHeader, name)
          factionDisplayNames[display] = name
          tinsert(factions, display)
        else
          tinsert(factions, name)
        end
      end
    end
    Diplomancer:RestoreFactionHeaders()
    sort(factions)

    local defaultValue = Diplomancer:GetFactionNameFromID(db.defaultFaction or racialFaction)
    default:SetValue(defaultValue)
    reset:SetEnabled(db.defaultFaction and db.defaultFaction ~= racialFaction)

    champion:SetValue(db.defaultChampion)
    exalted:SetValue(db.ignoreExalted)
    announce:SetValue(db.verbose)
  end
end)

------------------------------------------------------------------------------------------------------------------------

SLASH_DIPLOMANCER1 = "/diplomancer"
SLASH_DIPLOMANCER2 = "/dm"

SlashCmdList.DIPLOMANCER = function(cmd)
  cmd = strtrim(strlower(cmd or ""))

  if cmd == "" then
    InterfaceOptionsFrame_OpenToCategory(Diplomancer.OptionsPanel)
  elseif cmd == "debug" then
    Diplomancer.DEBUG = not Diplomancer.DEBUG
    Diplomancer:Print(format("Debugging %s on |cFFABB2BF%s|r.", Diplomancer.DEBUG and "|cFF98C379activated|r" or "|cFFE06C75deactivated|r", DEBUG_CHAT_FRAME and "DEBUG_CHAT_FRAME" or "ChatFrame3"))
  else
    Diplomancer:Print("Valid commands: |cFF98C379\"debug\"|r.")
  end
end

SLASH_WHERE_AM_I1 = "/whereami"
SLASH_WHERE_AM_I2 = "/wai"

SlashCmdList.WHERE_AM_I = function(cmd)
  cmd = strtrim(strlower(cmd or ""))

  local function printZoneNames()
    local mapID = C_Map.GetBestMapForUnit("player")
    local mapName = mapID and C_Map.GetMapInfo(mapID).name
    if mapName ~= GetRealZoneText() then
      Diplomancer:Print(format("Your current zone: |cFF98C379%q|r", GetRealZoneText()))
    end
    Diplomancer:Print(format("Your current subzone: |cFF98C379%q|r", GetSubZoneText()))
  end

  local descText, mapID, mapType
  if cmd == "subzone" then
    printZoneNames()
    return
  elseif cmd == "displayed" then
    descText = "Map API information for your displayed map location:"
    mapID = WorldMapFrame:GetMapID()
  elseif cmd == "parent" then
    descText = "Map API information for your current location's |cFFD19A66parentMapID|r:"
    mapID = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).parentMapID
  elseif type(tonumber(cmd)) == "number" then
    descText = "Map API information for the requested |cFFD19A66mapID|r:"
    mapID = tonumber(cmd)
  elseif cmd == "" then
    descText = "Map API information for your current location:"
    mapID = C_Map.GetBestMapForUnit("player")

    printZoneNames()
  else
    Diplomancer:Print("Valid commands: |cFF98C379\"subzone\"|r, |cFF98C379\"displayed\"|r, |cFF98C379\"parent\"|r, |cFFC678DDor |cFFD19A66mapID|r.")
    return
  end

  local mapArtID = mapID and C_Map.GetMapArtID(mapID)
  local mapInfo = mapID and C_Map.GetMapInfo(mapID)
  if mapInfo then
    for k, v in pairs(Enum.UIMapType) do
      if v == mapInfo.mapType then
        mapType = k
      end
    end
  end

  Diplomancer:Print(format("%s\n|cFFABB2BFname|r: |cFF98C379%q\n|cFFABB2BFmapType|r: |cFFD19A66%d |cFFC678DDor |cFF98C379%q\n|cFFABB2BFmapArtID|r: |cFFD19A66%d\n|cFFABB2BFmapID|r: |cFFD19A66%d\n|cFFABB2BFparentMapID|r: |cFFD19A66%d|r", descText, mapInfo.name, mapInfo.mapType, mapType, mapArtID, mapID, mapInfo.parentMapID))
end
