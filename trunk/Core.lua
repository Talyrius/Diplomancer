--[[--------------------------------------------------------------------
	Diplomancer
	Automatically sets your watched faction based on your location.
	Copyright (c) 2007-2012 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info9643-Diplomancer.html
	http://www.curse.com/addons/wow/diplomancer
----------------------------------------------------------------------]]

local ADDON_NAME, Diplomancer = ...
Diplomancer.L = Diplomancer.L or { }

------------------------------------------------------------------------

local db, onTaxi, taxiEnded, championFactions, championZones, racialFaction, subzoneFactions, zoneFactions
local L = setmetatable(Diplomancer.L, { __index = function(t, s) t[s] = s return s end })

------------------------------------------------------------------------
DEBUG_CHAT_FRAME = ChatFrame4
function Diplomancer:Debug(text, ...)
	if not text then return end
	if text:match("%%[dfsx%d%.$]") then
		(DEBUG_CHAT_FRAME or DEFAULT_CHAT_FRAME):AddMessage( "|cffff3399Diplomancer:|r " .. text:format(...) )
	else
		(DEBUG_CHAT_FRAME or DEFAULT_CHAT_FRAME):AddMessage( "|cffff3399Diplomancer:|r " .. text, ... )
	end
end

function Diplomancer:Print(text, ...)
	if not text then return end
	if text:match("%%[dfs%d%.]") then
		print( "|cff33ff99Diplomancer:|r", text:format(...) )
	else
		print( "|cff33ff99Diplomancer:|r", text, ... )
	end
end

------------------------------------------------------------------------

function Diplomancer:ADDON_LOADED(_, addon)
	if addon ~= ADDON_NAME then return end
	-- self:Debug("ADDON_LOADED", addon)

	if not DiplomancerSettings then
		self:Debug("No saved settings found!")
		DiplomancerSettings = { }
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
	-- self:Debug("PLAYER_LOGIN")

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
			self:Debug("Wearing tabard for", tabardFaction)
			local instances = championZones[tabardLevel]
			if instances and instances[zone] then
				-- Championing this faction has a level requirement.
				if GetInstanceDifficulty() >= instances[zone] then
					faction = tabardFaction
					self:Debug("CHAMPION", faction)
					if db.defaultChampion then
						db.defaultFaction = faction
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
				end
			end
		end
	end

	if not faction then
		local subzone = GetSubZoneText()
		self:Debug("Checking subzone", subzone)
		faction = subzone and subzoneFactions[zone] and subzoneFactions[zone][subzone]
		if faction then
			self:Debug("SUBZONE", faction)
		end
	end

	if not faction then
		self:Debug("Checking zone", zone, GetRealZoneText())
		faction = zoneFactions[zone]
		if faction then
			self:Debug("ZONE", faction)
		end
	end

	if not faction and tabardFaction and db.defaultChampion then
		faction = tabardFaction
		self:Debug("DEFAULT CHAMPION", faction)
	end

	if not faction then
		faction = db.defaultFaction or racialFaction
		self:Debug(db.defaultFaction and "DEFAULT" or "RACE", faction)
	end

	self:SetWatchedFactionByName(faction, db.verbose)
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
	if select(2, IsInInstance()) == "party" then
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
		if not watched and faction == name and (standing < 8 or not db.ignoreExalted) then
			SetWatchedFactionIndex(i)
			if verbose then
				self:Print(L["Now watching %s."], faction)
			end
			return true, name
		end
	end

	self:RestoreFactionHeaders()

	return false
end

------------------------------------------------------------------------

function Diplomancer:GetFactionNameMatch(text)
	if type(text) == "string" and text:len() > 0 then
		text = text:lower()

		self:ExpandFactionHeaders()

		local faction
		for i = 1, GetNumFactions() do
			faction = GetFactionInfo(i)
			if faction:lower():gsub("'", ""):match(text) then
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
		if CF[id] then
			return CF[id][2], CF[id][1]
		end
	end
end

------------------------------------------------------------------------

local FACTION_INACTIVE = FACTION_INACTIVE
local factionHeaderState = { }

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

------------------------------------------------------------------------

Diplomancer.frame = LibStub("PhanxConfig-OptionsPanel").CreateOptionsPanel(ADDON_NAME)

Diplomancer.frame:RegisterEvent("ADDON_LOADED")
Diplomancer.frame:SetScript("OnEvent", function(self, event, ...) return Diplomancer[event] and Diplomancer[event](Diplomancer, event, ...) end)

Diplomancer.frame.runOnce = function(self)
	local CreateCheckbox = LibStub("PhanxConfig-Checkbox").CreateCheckbox

	--------------------------------------------------------------------

	local title, notes = LibStub("PhanxConfig-Header").CreateHeader(self, ADDON_NAME, GetAddOnMetadata(ADDON_NAME, "Notes"))

	--------------------------------------------------------------------

	local factions = { }

	local reset

	local default = LibStub("PhanxConfig-ScrollingDropdown").CreateScrollingDropdown(self, L["Default faction"], factions,
		L["Select a faction to watch when your current location doesn't have an associated faction."])
	default:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 0, -8)
	default:SetWidth(270)
	default:SetValue(db.defaultFaction or racialFaction)
	default.OnValueChanged = function(self, value)
		if value == racialFaction then
			db.defaultFaction = nil
			reset:Disable()
		else
			db.defaultFaction = value
			reset:Enable()
		end
		Diplomancer:Update()
	end

	--------------------------------------------------------------------

	reset = LibStub("PhanxConfig-Button").CreateButton(self, L["Reset"], L["Reset your default faction preference to your race's faction."])
	reset:SetPoint("TOPLEFT", default.button, "TOPRIGHT", 8, 0)
	reset:SetPoint("BOTTOMLEFT", default.button, "BOTTOMRIGHT", 8, 0)
	reset:SetWidth(math.max(16 + reset:GetFontString():GetStringWidth(), 80))
	reset:SetScript("OnClick", function(self)
		self:Disable()
		db.defaultFaction = nil
		default:SetValue(racialFaction)
		Diplomancer:Update()
	end)

	--------------------------------------------------------------------

	local champion = CreateCheckbox(self, L["Default to championed faction"], L["Use your currently championed faction as your default faction."])
	champion:SetPoint("TOPLEFT", default, "BOTTOMLEFT", 0, -10)
	champion.OnClick = function(self, checked)
		db.defaultChampion = checked
		Diplomancer:Update()
	end

	--------------------------------------------------------------------

	local exalted = CreateCheckbox(self, L["Ignore Exalted factions"], L["Don't watch factions with whom you have already attained Exalted reputation."])
	exalted:SetPoint("TOPLEFT", champion, "BOTTOMLEFT", 0, -8)
	exalted.OnClick = function(self, checked)
		db.ignoreExalted = checked
		Diplomancer:Update()
	end

	--------------------------------------------------------------------

	local announce = CreateCheckbox(self, L["Announce watched faction"], L["Show a message in the chat frame when your watched faction is changed."])
	announce:SetPoint("TOPLEFT", exalted, "BOTTOMLEFT", 0, -8)
	announce.OnClick = function(self, checked)
		db.verbose = checked
	end

	--------------------------------------------------------------------

	self.refresh = function()
		wipe(factions)
		Diplomancer:ExpandFactionHeaders()
		for i = 1, GetNumFactions() do
			local name, _, standing, _, _, _, _, _, isHeader = GetFactionInfo(i)
			if name == L["Inactive"] then
				break
			end
			if not isHeader and ( standing < 8 or not db.ignoreExalted ) then
				table.insert(factions, name)
			end
		end
		Diplomancer:RestoreFactionHeaders()
		table.sort(factions)

		default:SetValue(db.defaultFaction or racialFaction)
		if not db.defaultFaction or db.defaultFaction == racialFaction then
			reset:Disable()
		else
			reset:Enable()
		end

		champion:SetChecked(db.defaultChampion)
		exalted:SetChecked(db.ignoreExalted)
		announce:SetChecked(db.verbose)
	end
end

Diplomancer.aboutPanel = LibStub("LibAboutPanel").new(ADDON_NAME, ADDON_NAME)

------------------------------------------------------------------------

SLASH_DIPLOMANCER1 = "/diplomancer"
SLASH_DIPLOMANCER2 = "/dm"

SlashCmdList.DIPLOMANCER = function( text )
	if text and string.len( text ) > 0 then
		local cmd, arg = string.match( string.lower( text ), "^%s*(%w+)%s*(.*)$" )
		if cmd == "default" then
			local faction = Diplomancer:GetFactionNameMatch( arg )
			if faction then
				db.default = faction
				return Diplomancer:Update()
			end
		else
			for k, v in pairs( db ) do
				if string.lower( k ) == cmd and type( v ) == "boolean" then
					db[ k ] = not db[ k ]
					return Diplomancer:Update()
				end
			end
		end
	end
	InterfaceOptionsFrame_OpenToCategory( Diplomancer.aboutPanel )
	InterfaceOptionsFrame_OpenToCategory( Diplomancer.frame )
end

------------------------------------------------------------------------

_G.Diplomancer = Diplomancer

------------------------------------------------------------------------