--[[--------------------------------------------------------------------
	Diplomancer
	Automatically sets your watched faction based on your location.
	Copyright (c) 2007-2012 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info9643-Diplomancer.html
	http://www.curse.com/addons/wow/diplomancer
----------------------------------------------------------------------]]

local ADDON_NAME, Diplomancer = ...
_G.Diplomancer = Diplomancer

local db, onTaxi, taxiEnded, championFactions, championZones, racialFaction, subzoneFactions, zoneFactions

------------------------------------------------------------------------

if not Diplomancer.L then
	Diplomancer.L = {}
end

local L = setmetatable(Diplomancer.L, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

------------------------------------------------------------------------

function Diplomancer:Debug(text, ...)
	--do return end
	if text then
		if text:match("%%[dfqsx%d%.]") then
			print("|cffff9999Diplomancer:|r", format(text, ...))
		else
			print("|cffff9999Diplomancer:|r", text, tostringall(...))
		end
	end
end

function Diplomancer:Print(text, ...)
	if text then
		if text:match("%%[dfqs%d%.]") then
			print("|cffffcc00Diplomancer:|r", format(text, ...))
		else
			print("|cffffcc00Diplomancer:|r", text, tostringall(...))
		end
	end
end

------------------------------------------------------------------------

function Diplomancer:ADDON_LOADED(_, addon)
	if addon ~= ADDON_NAME then return end
	self:Debug("ADDON_LOADED", addon)

	if not DiplomancerSettings then
		self:Debug("No saved settings found!")
		DiplomancerSettings = {}
	end
	db = DiplomancerSettings

	self.frame:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil

	if IsLoggedIn() then
		self:PLAYER_LOGIN()
	else
		self.frame:RegisterEvent("PLAYER_LOGIN")
	end
end

------------------------------------------------------------------------

function Diplomancer:PLAYER_LOGIN()
	self:Debug("PLAYER_LOGIN")

	self:LocalizeData()
	if not self.localized then return end

	championFactions = self.championFactions
	championZones = self.championZones
	racialFaction = self.racialFaction
	subzoneFactions = self.subzoneFactions
	zoneFactions = self.zoneFactions

	self.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	self.frame:RegisterEvent("ZONE_CHANGED")
	self.frame:RegisterEvent("ZONE_CHANGED_INDOORS")
	self.frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

	self.frame:RegisterEvent("PLAYER_CONTROL_GAINED")

	self.frame:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil

	if UnitOnTaxi("player") then
		onTaxi = true
	else
		self:Update()
	end
end

------------------------------------------------------------------------

function Diplomancer:Update(event)
	if taxiEnded then
		-- This is a hack to work around the fact that UnitOnTaxi still
		-- returns true during the PLAYER_CONTROL_GAINED event.
		taxiEnded = false
	elseif UnitOnTaxi("player") then
		self:Debug("On taxi. Skipping update.")
		onTaxi = true
		return
	end

	local faction
	local zone = GetCurrentMapAreaID()
	self:Debug("Update", event, zone)

	local tabardFaction, tabardLevel = self:GetChampionedFaction()
	if tabardFaction then
		local _, instanceType = IsInInstance()
		if instanceType == "party" then
			self:Debug("Wearing tabard for:", tabardFaction)
			local instances = championZones[tabardLevel]
			if instances and instances[zone] then
				-- Championing this faction has a level requirement.
				if GetInstanceDifficulty() >= instances[zone] then
					faction = tabardFaction
					self:Debug("CHAMPION", faction)
					if db.defaultChampion then
						db.defaultFaction = faction
					end
					if self:SetWatchedFactionByName(faction, db.verbose) then
						return
					end
				end
			elseif not instances and not championZones[70][zone] then
				-- Championing this faction doesn't have a level requirement,
				-- but Outland dungeons don't count, and WotLK dungeons are weird.
				local minDifficulty = instances[80][zone]
				if not minDifficulty or GetInstanceDifficulty() >= minDifficulty then
					faction = tabardFaction
					self:Debug("CHAMPION", faction)
					if db.defaultChampion then
						db.defaultFaction = faction
					end
					if self:SetWatchedFactionByName(faction, db.verbose) then
						return
					end
				end
			end
		end
	end

	local subzone = GetSubZoneText()
	if strlen(subzone) == 0 then
		subzone = nil
	end
	self:Debug("Checking subzone:", subzone or "nil")
	if subzone then
		faction = subzoneFactions[zone] and subzoneFactions[zone][subzone]
		if faction then
			self:Debug("SUBZONE", faction)
			if self:SetWatchedFactionByName(faction, db.verbose) then
				return
			end
		end
	end

	self:Debug("Checking zone:", zone, GetRealZoneText())
	faction = zoneFactions[zone]
	if faction then
		self:Debug("ZONE", faction)
		if self:SetWatchedFactionByName(faction, db.verbose) then
			return
		end
	end

	if tabardFaction and db.defaultChampion then
		faction = tabardFaction
		if faction then
			self:Debug("DEFAULT CHAMPION", faction)
			if self:SetWatchedFactionByName(faction, db.verbose) then
				return
			end
		end
	end

	faction = db.defaultFaction or racialFaction
	self:Debug(db.defaultFaction and "DEFAULT" or "RACE", faction)
	if not self:SetWatchedFactionByName(faction, db.verbose) then
		self:Debug("NONE")
		SetWatchedFactionIndex(0)
	end
end

Diplomancer.PLAYER_ENTERING_WORLD = Diplomancer.Update
Diplomancer.ZONE_CHANGED = Diplomancer.Update
Diplomancer.ZONE_CHANGED_INDOORS = Diplomancer.Update
Diplomancer.ZONE_CHANGED_NEW_AREA = Diplomancer.Update

------------------------------------------------------------------------

function Diplomancer:PLAYER_CONTROL_GAINED()
	self:Debug("PLAYER_CONTROL_GAINED")
	if onTaxi then
		onTaxi = false
		taxiEnded = true
		self:Update()
	end
end

------------------------------------------------------------------------

function Diplomancer:PLAYER_ENTERING_WORLD()
	-- self:Debug("PLAYER_ENTERING_WORLD")
	local _, instanceType = IsInInstance()
	if instanceType == "party" then
		self.frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
	else
		self.frame:UnregisterEvent("UNIT_INVENTORY_CHANGED")
	end
	self:Update()
end

------------------------------------------------------------------------

function Diplomancer:UNIT_INVENTORY_CHANGED(unit)
	if unit == "player" then
		-- self:Debug("UNIT_INVENTORY_CHANGED")
		self:Update()
	end
end

------------------------------------------------------------------------

function Diplomancer:SetWatchedFactionByName(name, verbose)
	if type(name) ~= "string" or name:len() == 0 then return end
	self:Debug("SetWatchedFactionByName: %s", name)

	self:ExpandFactionHeaders()

	for i = 1, GetNumFactions() do
		local faction, _, standing, _, _, _, _, _, _, _, _, watched = GetFactionInfo(i)
		--self:Debug("GetFactionInfo", i, faction, standing, watched)
		if faction == name then
			self:Debug("Found faction:", faction, standing, watched)
			if (standing < 8 or not db.ignoreExalted) then
				if not watched then
					SetWatchedFactionIndex(i)
					if verbose then
						self:Print(L["Now watching %s."], faction)
					end
				end
				return true, name
			else
				break
			end
		end
	end

	self:RestoreFactionHeaders()
end

------------------------------------------------------------------------

function Diplomancer:GetFactionNameMatch(text)
	if type(text) == "string" and strlen(text) > 0 then
		text = strlower(text)

		self:ExpandFactionHeaders()

		local faction
		for i = 1, GetNumFactions() do
			faction = GetFactionInfo(i)
			if gsub(strlower(faction), "'", ""):match(text) then
				return faction
			end
		end
	end
end

------------------------------------------------------------------------

function Diplomancer:GetChampionedFaction()
	local CF = self.championFactions
	for i = 1, 40 do
		local _, _, _, _, _, _, _, _, _, _, id = UnitBuff("player", i)
		if not id then
			return
		end
		local data = CF[id]
		if data then
			local faction, level = data[2], data[1]
			self:Debug("GetChampionedFaction:", tostring(faction), tostring(level))
			return faction, level
		end
	end
	self:Debug("GetChampionedFaction:", "none")
end

------------------------------------------------------------------------

local FACTION_INACTIVE = FACTION_INACTIVE
local factionHeaderState = {}

function Diplomancer:ExpandFactionHeaders()
	local n = GetNumFactions()
	for i = 1, n do
		local name, _, _, _, _, _, _, _, isHeader, isCollapsed = GetFactionInfo(i)
		if isHeader then
			if isCollapsed and name ~= FACTION_INACTIVE then
				factionHeaderState[name] = true
				ExpandFactionHeader(i)
				n = GetNumFactions()
			elseif name == L["Inactive"] then
				if not ReputationFrame:IsShown() then
					CollapseFactionHeader(i)
				end
				break
			end
		end
	end
end

function Diplomancer:RestoreFactionHeaders()
	local n = GetNumFactions()
	for i = 1, n do
		local name, _, _, _, _, _, _, _, isHeader, isCollapsed = GetFactionInfo(i)
		if isHeader and not isCollapsed and factionHeaderState[name] then
			CollapseFactionHeader(i)
			n = GetNumFactions()
		end
	end
end