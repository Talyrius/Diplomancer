--[[--------------------------------------------------------------------
	Diplomancer
	Automatically watches the faction associated with your current location.
	by Phanx < addons@phanx.net >
	Copyright © 2007-2008 Alyssa S. Kinley, a.k.a. Phanx
	See included README for license terms and additional information.
----------------------------------------------------------------------]]

Diplomancer = CreateFrame("Frame")
Diplomancer.version = tonumber(GetAddOnMetadata("Diplomancer", "Version"))
Diplomancer:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, ...)	end end)
Diplomancer:RegisterEvent("PLAYER_ENTERING_WORLD")

local Diplomancer = Diplomancer
local db, zones, subzones, racial, onTaxi

local L = setmetatable(DiplomancerLocals or {}, { __index = function(t, k) rawset(t, k, k) return k end })
if DiplomancerLocals then DiplomancerLocals = nil end

local function Print(text)
	ChatFrame1:AddMessage("|cff33ff99Diplomancer:|r "..text)
end

local function Debug(text)
	ChatFrame1:AddMessage("|cffff3399[DEBUG] Diplomancer:|r "..text)
end

--[[------------------------------------------------------------
	Initialize
--------------------------------------------------------------]]
function Diplomancer:PLAYER_ENTERING_WORLD()
	zones, subzones, racial = self:GetData()
	racial = racial[UnitRace("player")]

	local defaults = {
		default = nil, -- custom faction to fallback to; default = racial
		exalted = nil, -- ignore factions already at Exalted; default = no
		verbose = nil, -- print messages when changing factions; default = no
		version = self.version,
	}
	if not DiplomancerSettings then
		DiplomancerSettings = defaults
	elseif DiplomancerSettings.version ~= self.version then
		local temp = defaults
		for k, v in pairs(DiplomancerSettings) do
			if defaults[k] then
				temp[k] = v
			end
		end
		temp.version = self.version
		DiplomancerSettings = temp
	end
	db = DiplomancerSettings

	if UnitOnTaxi("player") then
		onTaxi = true
	else
		self:Update()
	end

	self:RegisterEvent("ZONE_CHANGED")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("PLAYER_CONTROL_LOST")
	self:RegisterEvent("PLAYER_CONTROL_GAINED")

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self.PLAYER_ENTERING_WORLD = nil
end

--[[------------------------------------------------------------
	Check taxi status
--------------------------------------------------------------]]
function Diplomancer:PLAYER_CONTROL_LOST()
	-- Debug("Control lost")
	if UnitOnTaxi("player") then
		-- Debug("Taxi ride started")
		onTaxi = true
	end
end

function Diplomancer:PLAYER_CONTROL_GAINED()
	-- Debug("Control gained")
	if onTaxi then
		-- Debug("Taxi ride ended")
		onTaxi = false
		self:Update()
	end
end

--[[------------------------------------------------------------
	Update watched faction for the current zone
--------------------------------------------------------------]]
function Diplomancer:ZONE_CHANGED()
	-- Debug("Subzone changed")
	self:Update()
end

function Diplomancer:ZONE_CHANGED_NEW_AREA()
	-- Debug("Zone changed")
	self:Update()
end

function Diplomancer:Update()
	if onTaxi then
		-- Debug("On taxi; skipping update")
		return
	end

	local zone, subzone = GetRealZoneText(), GetSubZoneText()
	-- Debug("zone = "..zone.."; subzone = "..subzone)

	local faction
	if subzones[zone] and subzones[zone][subzone] then
		faction = subzones[zone][subzone]
		-- Debug("Setting watch on "..faction.." (subzone)")
	elseif zones[zone] then
		faction = zones[zone]
		-- Debug("Setting watch on "..faction.." (zone)")
	elseif db.default then
		faction = db.default
		-- Debug("Setting watch on "..faction.." (default)")
	else
		faction = racial
		-- Debug("Setting watch on "..faction.." (racial)")
	end

	if faction ~= tostring(GetWatchedFactionInfo()) then
		self:SetWatchedFactionByName(faction)
	end
end

--[[------------------------------------------------------------
	Set watched faction by name
	Arguments:
		faction	- exact faction name to set (case sensitive)
	Returns:
		set		- whether or not faction was found and set
		faction	- name of faction set (nil if none)
--------------------------------------------------------------]]
function Diplomancer:SetWatchedFactionByName(name)
	if name == nil or type(name) ~= "string" or name == "" then return end

	self:ExpandFactionHeaders()
	
	local faction, _, standing
	for i = 1, GetNumFactions() do
		faction, _, standing = GetFactionInfo(i)
		if faction == name and (standing < 8 or not db.ignoreExalted) then
			SetWatchedFactionIndex(i)
			if db.verbose then
				Print("Now watching "..faction..".")
			end
			return true, name
		end
	end

	return false
end

--[[------------------------------------------------------------
	Get faction name from search term
	Arguments:
		search	- partial faction name to match on
	Returns:
		found	- whether or not a matching faction was found
		faction	- name of faction found (nil if none)
--------------------------------------------------------------]]
function Diplomancer:FindFactionName(search)
	if not search or not type(search) == "string" or search == "" then return end
	search = search:lower()

	self:ExpandFactionHeaders()

	local name
	for i = 1, GetNumFactions() do
		name = GetFactionInfo(i)
		if name:lower():find(search) then
			return true, name
		end
	end

	return false
end

--[[------------------------------------------------------------
	Expand active faction headers
--------------------------------------------------------------]]
function Diplomancer:ExpandFactionHeaders()
	local name, isHeader, isCollapsed
	local n = GetNumFactions()
	for i = 0, n, 1 do
		name, _, _, _, _, _, _, _, isHeader, isCollapsed = GetFactionInfo(i)
		if isHeader then
			if isCollapsed and name ~= "Inactive" then
				ExpandFactionHeader(i)
				n = GetNumFactions()
				i = 0
			elseif name == "Inactive" then
			--	@DEV: don't collapse anymore, it's annoying if I'm trying to look at the window
			--	CollapseFactionHeader(i)
				break
			end
		end
	end
end

--[[------------------------------------------------------------
	Handle slash commands
--------------------------------------------------------------]]

local options = {
	[L["default"]] = "SetDefault",
	[L["exalted"]] = "ToggleExalted",
	[L["verbose"]] = "ToggleVerbose",
}

SLASH_DIPLOMANCER1 = "/diplomancer"
SLASH_DIPLOMANCER2 = "/dm"
SlashCmdList.DIPLOMANCER = function(input)
	local cmd, etc = string.match(input, "^%s*(%S+)%s*(.*)$")
	local func = cmd and options[cmd]
	if Diplomancer[func] then return Diplomancer[func](Diplomancer, etc) end
	Print(L["Automatic location-based faction watching"])
	DEFAULT_CHAT_FRAME:AddMessage(L["Use /diplomancer or /dm with the following commands:"])
	DEFAULT_CHAT_FRAME:AddMessage("   "..L["default"].." - "..L["set a default faction"])
	DEFAULT_CHAT_FRAME:AddMessage("   "..L["exalted"].." - "..L["ignore factions you're already Exalted with"])
	DEFAULT_CHAT_FRAME:AddMessage("   "..L["verbose"].." - "..L["print a message when changing watched factions"])
end

function Diplomancer:SetDefault(str)
	if str and str:len() > 0 then
		str = string.lower(str)
		if str == L["none"] or str == L["reset"] then
			Print(L["Default faction reset to racial faction."])
			db.default = nil
			self:Update()
		else
			local found, faction = self:FindFactionName(str)
			if found then
				db.default = faction
				Print(L["Default faction set to \"%s\"."], faction)
				self:Update()
			else
				Print(L["Could not find a faction matching \"%s\"."], str)
			end
		end
	else
		Print(string.format(L["Default faction currently set to \"%s\"."], db.default or racial))
	end
end

function Diplomancer:ToggleExalted()
	if not db.ignoreExalted then
		db.ignoreExalted = true
		Print(L["Now ignoring factions you're already Exalted with."])
	else
		db.ignoreExalted = false
		Print(L["No longer ignoring factions you're already Exalted with."])
	end
end

function Diplomancer:ToggleVerbose()
	if not db.verbose then
		db.verbose = true
		Print(L["Now printing messages when changing watched factions."])
	else
		db.verbose = false
		Print(L["No longer printing messages when changing watched factions."])
	end
end