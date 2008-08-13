--[[--------------------------------------------------------------------
	Diplomancer: automatic location-based faction watch
	by Phanx < addons AT phanx net >
	Based upon Smart Faction Watch by Charnow
	See included README.TXT for license and additional information.
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
		default = nil,
		verbose = nil,
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
		if not db.verbose then
			Print("Now watching "..faction..".")
		end
	end
end

--[[------------------------------------------------------------
	Set watched faction by name
	Arguments:
		faction	- exact faction name to set (not case sensitive)
	Returns:
		set		- whether or not faction was found and set
		faction	- name of faction set (nil if none)
--------------------------------------------------------------]]
function Diplomancer:SetWatchedFactionByName(name)
	if name == nil or type(name) ~= "string" or name == "" then return end
	name = name:lower()

	local set, faction = false

	self:ExpandFactionHeaders()

	for i = 1, GetNumFactions() do
		if GetFactionInfo(i):lower() == name then
			SetWatchedFactionIndex(i)
			set, faction = true, name
		end
	end

	return set, faction
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

	local found, faction = false

	self:ExpandFactionHeaders()

	local name
	for i = 1, GetNumFactions() do
		name = GetFactionInfo(i)
		if name:lower():find(search) then
			found, faction = true, name
		end
	end

	return found, faction
end

--[[------------------------------------------------------------
	Expand active faction headers and collapse Inactive header
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
	[L["default"]] = "SetDefaultFaction",
	[L["verbose"]] = "ToggleVerboseMode",
}

SLASH_DIPLOMANCER1 = "/diplomancer"
SLASH_DIPLOMANCER2 = "/dm"
SlashCmdList.DIPLOMANCER = function(input)
	local cmd, etc = string.match(input, "^%s*(%S+)%s*(.*)$")
	local func = cmd and options[cmd]
	if Diplomancer[func] then return Diplomancer[func](Diplomancer, etc) end
	Print(L["Automatic location-based faction watching"])
	DEFAULT_CHAT_FRAME:AddMessage(L["Use /diplomancer or /dm with the following commands:"])
	DEFAULT_CHAT_FRAME:AddMessage("   "..L["default"].." - "..L["set your default faction"])
	DEFAULT_CHAT_FRAME:AddMessage("   "..L["verbose"].." - "..L["print a message when changing factions"])
end

function Diplomancer:SetDefaultFaction(str)
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

function Diplomancer:ToggleVerboseMode()
	db.verbose = not db.verbose
	if db.verbose then
		Print(L["Verbose mode enabled."])
	else
		Print(L["Verbose mode disabled."])
	end
end