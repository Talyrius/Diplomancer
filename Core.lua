--[[--------------------------------------------------------------------
	Diplomancer
	Automatically sets your watched faction based on your location.
	Copyright (c) 2007-2015 Phanx <addons@phanx.net>. All rights reserved.
	http://www.wowinterface.com/downloads/info9643-Diplomancer.html
	http://www.curse.com/addons/wow/diplomancer
	https://github.com/Phanx/Diplomancer
----------------------------------------------------------------------]]

local ADDON_NAME, Diplomancer = ...
local L = Diplomancer.L

local db, onTaxi, tabard
local championFactions, championZones, racialFaction, subzoneFactions, zoneFactions

_G.Diplomancer = Diplomancer

------------------------------------------------------------------------

local DEBUG = false
function Diplomancer:Debug(text, ...)
	if text then
		if text:match("%%[dfqsx%d%.]") then
			(DEBUG_CHAT_FRAME or ChatFrame3):AddMessage("|cffff9999Diplomancer:|r " .. format(text, ...))
		else
			(DEBUG_CHAT_FRAME or ChatFrame3):AddMessage("|cffff9999Diplomancer:|r " .. strjoin(" ", text, tostringall(...)))
		end
	end
end

function Diplomancer:Print(text, ...)
	if text then
		if text:match("%%[dfqs%d%.]") then
			DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Diplomancer:|r " .. format(text, ...))
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Diplomancer:|r " .. strjoin(" ", text, tostringall(...)))
		end
	end
end

------------------------------------------------------------------------

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("ADDON_LOADED")
EventFrame:SetScript("OnEvent", function(self, event, ...) return Diplomancer[event] and Diplomancer[event](Diplomancer, event, ...) end)
Diplomancer.EventFrame = EventFrame

------------------------------------------------------------------------

function Diplomancer:ADDON_LOADED(_, addon)
	if addon ~= ADDON_NAME then return end
	if DEBUG then self:Debug("ADDON_LOADED", addon) end

	if not DiplomancerSettings then
		if DEBUG then self:Debug("No saved settings found!") end
		DiplomancerSettings = {}
	end
	db = DiplomancerSettings

	if type(db.defaultFaction) == "string" then
		db.defaultFaction = self:GetFactionIDFromName(db, defaultFaction)
	end

	EventFrame:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil

	if IsLoggedIn() then
		self:PLAYER_LOGIN()
	else
		EventFrame:RegisterEvent("PLAYER_LOGIN")
	end
end

------------------------------------------------------------------------

function Diplomancer:PLAYER_LOGIN()
	if DEBUG then self:Debug("PLAYER_LOGIN") end

	self:LocalizeData()
	if not self.localized then return end

	championFactions = self.championFactions
	championZones = self.championZones
	racialFaction = self.racialFaction
	subzoneFactions = self.subzoneFactions
	zoneFactions = self.zoneFactions

	EventFrame:RegisterEvent("ACTIONBAR_UPDATE_USABLE")
	EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	EventFrame:RegisterEvent("UNIT_INVENTORY_CHANGED")
	EventFrame:RegisterEvent("ZONE_CHANGED")
	EventFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
	EventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

	EventFrame:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil

	if UnitOnTaxi("player") then
		onTaxi = true
	else
		self:Update()
	end
end

------------------------------------------------------------------------

function Diplomancer:GetCurrentMapAreaID()
	if WorldMapFrame:IsShown() then
		local viewing = GetCurrentMapAreaID()
		SetMapToCurrentZone()
		local current = GetCurrentMapAreaID()
		SetMapByID(viewing)
		return current
	end
	return GetCurrentMapAreaID()
end

function Diplomancer:Update(event)
	if onTaxi then
		if DEBUG then self:Debug("On taxi. Skipping update.") end
		return
	end

	if WorldMapFrame:IsShown() then
		-- Don't update while the map is open?
		return
	end

	local faction
	local zone = self:GetCurrentMapAreaID()
	if DEBUG then self:Debug("Update", event, zone) end

	local tabardFaction, tabardLevel = self:GetChampionedFaction()
	if tabardFaction then
		local _, instanceType = IsInInstance()
		if instanceType == "party" then
			if DEBUG then self:Debug("Wearing tabard for:", tabardFaction) end
			local instances = championZones[tabardLevel]
			if instances and instances[zone] then
				-- Championing this faction has a level requirement.
				if GetDungeonDifficultyID() >= instances[zone] then
					faction = tabardFaction
					if DEBUG then self:Debug("CHAMPION", faction) end
					if db.defaultChampion then
						db.defaultFaction = faction
					end
					if self:SetWatchedFactionByID(faction, db.verbose) then
						return
					end
				end
			elseif not instances and not championZones[70][zone] then
				-- Championing this faction doesn't have a level requirement,
				-- but Outland dungeons don't count, and WotLK/Cataclysm dungeons are weird.
				local minDifficulty = championZones[85][zone] or championZones[80][zone]
				if not minDifficulty or GetDungeonDifficultyID() >= minDifficulty then
					faction = tabardFaction
					if DEBUG then self:Debug("CHAMPION", faction) end
					if db.defaultChampion then
						db.defaultFaction = faction
					end
					if self:SetWatchedFactionByID(faction, db.verbose) then
						return
					end
				end
			end
		end
	end

	local subzone = GetSubZoneText()
	if DEBUG then self:Debug("Checking subzone:", strlen(subzone) > 0 and subzone or "nil") end
	if subzone then
		faction = subzoneFactions[zone] and subzoneFactions[zone][subzone]
		if faction then
			if DEBUG then self:Debug("SUBZONE", faction) end
			if self:SetWatchedFactionByID(faction, db.verbose) then
				return
			end
		end
	end

	if DEBUG then self:Debug("Checking zone:", zone, GetRealZoneText()) end
	faction = zoneFactions[zone]
	if faction then
		if DEBUG then self:Debug("ZONE", faction) end
		if self:SetWatchedFactionByID(faction, db.verbose) then
			return
		end
	end

	if tabardFaction and db.defaultChampion then
		faction = tabardFaction
		if faction then
			if DEBUG then self:Debug("DEFAULT CHAMPION", faction) end
			if self:SetWatchedFactionByID(faction, db.verbose) then
				return
			end
		end
	end

	faction = db.defaultFaction or racialFaction
	if DEBUG then self:Debug(db.defaultFaction and "DEFAULT" or "RACE", faction) end
	if not self:SetWatchedFactionByID(faction, db.verbose) then
		if DEBUG then self:Debug("NONE") end
		SetWatchedFactionIndex(0)
	end
end

------------------------------------------------------------------------

do
	local running

	local function DelayedUpdate()
		running = nil
		Diplomancer:Update("DelayedUpdate")
	end

	local function DelayUpdate()
		if not running then
			C_Timer.After(0.5, DelayedUpdate)
			running = true
		end
	end

	Diplomancer.PLAYER_ENTERING_WORLD = DelayUpdate
	Diplomancer.ZONE_CHANGED = DelayUpdate
	Diplomancer.ZONE_CHANGED_INDOORS = DelayUpdate
	Diplomancer.ZONE_CHANGED_NEW_AREA = DelayUpdate
end

------------------------------------------------------------------------

function Diplomancer:ACTIONBAR_UPDATE_USABLE()
	local nowTaxi = UnitOnTaxi("player")
	if nowTaxi == onTaxi then return end
	if DEBUG then self:Debug("ACTIONBAR_UPDATE_USABLE", onTaxi, "=>", nowTaxi) end
	onTaxi = nowTaxi
	if not onTaxi then
		self:Update()
	end
end

------------------------------------------------------------------------

-- local INVSLOT_TABARD = GetInventorySlotInfo("TabardSlot")

function Diplomancer:UNIT_INVENTORY_CHANGED(_, unit)
	if unit == "player" then
		if DEBUG then self:Debug("UNIT_INVENTORY_CHANGED") end
		local new = GetInventoryItemID(unit, INVSLOT_TABARD)
		if DEBUG then self:Debug("Current", new and GetItemInfo(new) or "none", "Previous", tabard and GetItemInfo(tabard) or "none") end
		if new ~= tabard then
			tabard = new
			self:Update()
		end
	end
end

------------------------------------------------------------------------

function Diplomancer:PickBestFaction(factions)
	if DEBUG then
		local str = ""
		for id in pairs(factions) do
			str = str .. " " .. id
		end
		self:Debug("PickBestFaction:", str)
	end
	local bestStandingID, bestFactionID = -1
	self:ExpandFactionHeaders()
	for i = 1, GetNumFactions() do
		local _, _, standingID, _, _, _, _, _, _, _, _, isWatched, _, factionID = GetFactionInfo(i)
		if factions[factionID] and standingID > bestStandingID then
			bestFactionID = factionID
			bestStandingID = standingID
		end
	end
	self:RestoreFactionHeaders()
	return bestFactionID
end

function Diplomancer:SetWatchedFactionByID(id, verbose)
	if type(id) == "table" then
		return self:SetWatchedFactionByID(self:PickBestFaction(id))
	end
	if type(id) ~= "number" then return end
	if DEBUG then self:Debug("SetWatchedFactionByID:", id) end
	self:ExpandFactionHeaders()
	for i = 1, GetNumFactions() do
		local name, _, standingID, _, _, _, _, _, _, _, _, isWatched, _, factionID = GetFactionInfo(i)
		--if DEBUG then self:Debug("GetFactionInfo", i, factionID, name, standingID, isWatched) end
		if factionID == id then
			if DEBUG then self:Debug("Found faction:", name, standingID, isWatched) end
			if (standingID < 8 or not db.ignoreExalted) then
				if not isWatched then
					SetWatchedFactionIndex(i)
					if verbose then
						self:Print(L.NowWatching, name)
					end
				end
				self:RestoreFactionHeaders()
				return name, id
			else
				break
			end
		end
	end
	self:RestoreFactionHeaders()
end

------------------------------------------------------------------------

function Diplomancer:GetChampionedFaction()
	for i = 1, 40 do
		local _, _, _, _, _, _, _, _, _, _, id = UnitBuff("player", i)
		if not id then
			break
		end
		local data = championFactions[id]
		if data then
			local faction, level = data[2], data[1]
			if DEBUG then self:Debug("GetChampionedFaction:", tostring(faction), tostring(level)) end
			return faction, level
		end
	end
	if DEBUG then self:Debug("GetChampionedFaction:", "none") end
end

------------------------------------------------------------------------

function Diplomancer:GetFactionIDFromName(search)
	if DEBUG then self:Debug("GetFactionIDFromName", search) end
	local result1, result2
	if not search then
		return
	end
	search = gsub(strlower(tostring(search)), "['%s%-]", "")
	if strlen(search) < 1 then
		return
	end

	self:ExpandFactionHeaders()
	for i = 1, GetNumFactions() do
		local name, _, _, _, _, _, _, _, _, _, _, _, _, factionID = GetFactionInfo(i)
		local text = gsub(strlower(tostring(name)), "['%s%-]", "")
		if strmatch(text, search) then
			self:RestoreFactionHeaders()
			return factionID, name
		end
	end
	self:RestoreFactionHeaders()
end

function Diplomancer:GetFactionNameFromID(search)
	if DEBUG then self:Debug("GetFactionNameFromID", search) end
	if search and type(search) ~= "number" then
		search = tonumber(search)
	end
	if not search then
		return
	end

	self:ExpandFactionHeaders()
	for i = 1, GetNumFactions() do
		local name, _, _, _, _, _, _, _, _, _, _, _, _, factionID = GetFactionInfo(i)
		if factionID == search then
			self:RestoreFactionHeaders()
			return name, factionID
		end
	end
	self:RestoreFactionHeaders()
end

------------------------------------------------------------------------

local GetNumFactions, GetFactionInfo, ExpandFactionHeader, CollapseFactionHeader = GetNumFactions, GetFactionInfo, ExpandFactionHeader, CollapseFactionHeader
local wasCollapsed = {}

function Diplomancer:ExpandFactionHeaders()
	if DEBUG then self:Debug("ExpandFactionHeaders") end
	local i = 1
	while i <= GetNumFactions() do
		local name, _, _, _, _, _, _, _, isHeader, isCollapsed = GetFactionInfo(i)
		if isHeader then
			wasCollapsed[name] = isCollapsed
			if name == FACTION_INACTIVE then
				if not isCollapsed then
					CollapseFactionHeader(i)
				end
				break
			elseif isCollapsed then
				ExpandFactionHeader(i)
			end
		end
		i = i + 1
	end
end

function Diplomancer:RestoreFactionHeaders()
	if DEBUG then self:Debug("RestoreFactionHeaders") end
	local i = 1
	while i <= GetNumFactions() do
		local name, _, _, _, _, _, _, _, isHeader, isCollapsed = GetFactionInfo(i)
		if isHeader then
			if isCollapsed and not wasCollapsed[name] then
				ExpandFactionHeader(i)
			elseif wasCollapsed[name] and not isCollapsed then
				CollapseFactionHeader(i)
			end
		end
		i = i + 1
	end
	wipe(wasCollapsed)
end