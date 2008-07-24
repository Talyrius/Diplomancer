--[[--------------------------------------------------------------------
	Diplomancer: automatic location-based faction watch
	by Phanx < addons AT phanx net >
	Based upon Smart Faction Watch by Charnow

	DO NOT include this addon in compilations or otherwise
	redistribute it without my express prior consent.

	Feel free to distribute modified versions of this addon in
	any way you wish, AFTER you have changed the name of the
	addon to something that does not include the name of this
	addon, or my name.
----------------------------------------------------------------------]]

Diplomancer = CreateFrame("Frame")
Diplomancer.version = tonumber(GetAddOnMetadata("Diplomancer", "Version"))

local Diplomancer = Diplomancer
local db, zones, subzones, races, inactive, initialized, racialFaction, onTaxi

local function print(text)
	ChatFrame1:AddMessage("|cff33ff99Diplomancer:|r "..text)
end

local function debug(text)
	ChatFrame1:AddMessage("|cffff3399[DEBUG] Diplomancer:|r "..text)
end

Diplomancer:SetScript("OnEvent", function(self, event, ...)
	if self[event] then
		self[event](self, ...)
	else
		self:UnregisterEvent(event)
		error("no handler found for event "..event)
	end
end)

Diplomancer:RegisterEvent("PLAYER_LOGIN")

--[[------------------------------------------------------------
	Initialize
--------------------------------------------------------------]]
function Diplomancer:PLAYER_LOGIN()
	zones, subzones, races = self:GetData()

	racialFaction = races[UnitRace("player")]

	if not DiplomancerSettings then
		DiplomancerSettings = {
			default = nil,
			verbose = nil,
			version = self.version,
		}
	end
	db = DiplomancerSettings

	self:RegisterEvent("ZONE_CHANGED")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("PLAYER_CONTROL_LOST")
	self:RegisterEvent("PLAYER_CONTROL_GAINED")

	if UnitOnTaxi("player") then
		onTaxi = true
	else
		self:Update()
	end
end

--[[------------------------------------------------------------
	Check taxi status
--------------------------------------------------------------]]
function Diplomancer:PLAYER_CONTROL_LOST()
	-- debug("lost control")
	if UnitOnTaxi("player") then
		-- debug("starting taxi ride")
		onTaxi = true
	end
end

function Diplomancer:PLAYER_CONTROL_GAINED()
	-- debug("gained control")
	if onTaxi then
		-- debug("ending taxi ride")
		onTaxi = false
		self:Update()
	end
end

--[[------------------------------------------------------------
	Update watched faction for the current zone
--------------------------------------------------------------]]
function Diplomancer:ZONE_CHANGED()
	-- debug("changed subzone")
	self:Update()
end

function Diplomancer:ZONE_CHANGED_NEW_AREA()
	-- debug("changed zone")
	self:Update()
end

function Diplomancer:Update()
	if onTaxi then
		-- debug("skipping update while on taxi")
		return
	end

	local zone, subzone = GetRealZoneText(), GetSubZoneText()
	-- debug("zone = "..zone.."; subzone = "..subzone)

	if subzones[zone] and subzones[zone][subzone] then
		faction = subzones[zone][subzone]
		-- debug("setting watch on "..faction.." (subzone)")
	elseif zones[zone] then
		faction = zones[zone]
		-- debug("setting watch on "..faction.." (zone)")
	elseif db.default then
		faction = db.default
		-- debug("setting watch on "..faction.." (default)")
	else
		faction = racialFaction
		-- debug("setting watch on "..faction.." (racial)")
	end

	if faction ~= tostring(GetWatchedFactionInfo()) then
		self:SetWatchedFactionByName(faction)
		if not db.verbose then
			print("Now watching "..faction..".")
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
		name, _, _, _, _, _, _, _, isHeader, isCollapsed, _ = GetFactionInfo(i)
		if isHeader then
			if isCollapsed and name ~= "Inactive" then
				ExpandFactionHeader(i)
				n = GetNumFactions()
				i = 0
			elseif name == "Inactive" then
				CollapseFactionHeader(i)
				break
			end
		end
	end
end

--[[------------------------------------------------------------
	Handle slash commands
--------------------------------------------------------------]]

SLASH_DIPLOMANCER1 = "/diplomancer"
SLASH_DIPLOMANCER2 = "/dm"
SlashCmdList.DIPLOMANCER = function(input)
	local cmd, args = string.match(input, "^%s*(%S+)%s*(.*)$")
	local handler = cmd and Diplomancer["CMD_"..cmd:upper()]
	-- debug("cmd = "..cmd.."; args = "..(args or "nil").."; handler "..(handler and "found" or "not found"))
	if handler then
		handler(Diplomancer, args)
	else
		print("Automatic zone-based faction watch")
		ChatFrame1:AddMessage("   Use |cffffff99/diplomancer|r or |cffffff99/dm|r with the following commands:")
		ChatFrame1:AddMessage("   - |cffff9933d|r|cffffff99efault|r - set your default faction")
		ChatFrame1:AddMessage("   - |cffff9933v|r|cffffff99erbose|r - print a message when changing factions")
	end
end

function Diplomancer:CMD_DEFAULT(input)
	if input and input:len() > 0 then
		if string.lower(input) == "none" then
			print("Default faction reset to racial faction.")
			db.default = nil
			self:Update()
		else
			local found, faction = self:FindFactionName(input)
			if found then
				print("Default faction set to \""..faction.."\".")
				db.default = faction
				self:Update()
			else
				print("Could not find a faction matching \""..input.."\".")
			end
		end
	else
		print("Default faction currently set to \""..(db.default or racialFaction).."\".")
	end
end
Diplomancer.CMD_D = Diplomancer.CMD_DEFAULT

function Diplomancer:CMD_VERBOSE(input)
	if input ~= nil and (input == "on" or input == "true" or input == "1") then
		db.verbose = true
	elseif input ~= nil and (input == "off" or input == "false" or input == "0") then
		db.verbose = false
	else
		db.verbose = not db.verbose
	end
	if db.verbose then
		print("Verbose mode enabled.")
	else
		print("Verbose mode disabled.")
	end
end
Diplomancer.CMD_V = Diplomancer.CMD_VERBOSE