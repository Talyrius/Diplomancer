--[[--------------------------------------------------------------------
	Diplomancer
	Automatically sets your watched faction based on your location.
	by Phanx < addons@phanx.net >
	Copyright © 2007–2010 Phanx. Some rights reserved. See LICENSE.txt for details.
	http://www.wowinterface.com/downloads/info9643-Diplomancer.html
	http://wow.curse.com/downloads/wow-addons/details/diplomancer.aspx
----------------------------------------------------------------------]]

local ADDON_NAME, Diplomancer = ...
if not Diplomancer then Diplomancer = _G.Diplomancer end -- WoW China is still running 3.2
Diplomancer.L = Diplomancer.L or { }

------------------------------------------------------------------------

local db, onTaxi, taxiEnded, championFactions, championZones, racialFaction, subzoneFactions, zoneFactions
local L = setmetatable(Diplomancer.L, { __index = function(t, s) t[s] = s return s end })

------------------------------------------------------------------------

function Diplomancer:Debug(text, ...)
	if not text then return end
	if text:match("%%") then
		text = text:format(...)
	else
		text = string.join(", ", text, ...)
	end
	print( ("|cffff3399[DEBUG] Diplomancer:|r %s"):format(text) )
end

function Diplomancer:Print(text, ...)
	if not text then return end
	if text:match("%%") then
		text = text:format(...)
	else
		text = string.join(", ", text, ...)
	end
	print( ("|cff33ff99Diplomancer:|r %s"):format(text) )
end

------------------------------------------------------------------------

function Diplomancer:ADDON_LOADED(_, addon)
	if addon ~= ADDON_NAME then return end
	-- self:Debug("ADDON_LOADED", addon)

	if not DiplomancerSettings then
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
		-- returns true right after PLAYER_CONTROL_GAINED has fired.
		taxiEnded = false
	elseif UnitOnTaxi("player") then
		-- self:Debug("On taxi. Skipping update.")
		onTaxi = true
		return
	end

	local faction
	local zone = GetRealZoneText()

	-- self:Debug("Update", event, zone)

	local _, instanceType = IsInInstance()
	if instanceType == "party" then
		for buff, info in pairs(championFactions) do
			if UnitBuff("player", buff) then
				local instances = championZones[info[1]]
				if instances and instances[zone] then
					-- Championing this faction has a level requirement.
					if GetInstanceDifficulty() >= instances[zone] then
						faction = info[2]
						self:Debug("CHAMPION", faction)
						if db.defaultChampion then db.defaultFaction = faction end
					end
				elseif not instances and not championZones[70][zone] then
					-- Championing this faction doesn't have a level requirement,
					-- but Outland dungeons don't count, and WotLK dungeons are weird.
					local minDifficulty = instances[80][zone]
					if not minDifficulty or GetInstanceDifficulty() >= minDifficulty then
						faction = info[2]
						self:Debug("CHAMPION", faction)
						if db.defaultChampion then db.defaultFaction = faction end
					end
				end
				break
			end
		end
	end

	if not faction then
		local subzone = GetSubZoneText()
		faction = subzone and subzoneFactions[zone] and subzoneFactions[zone][subzone]
		-- if faction then self:Debug("SUBZONE", faction) end
	end

	if not faction then
		faction = zoneFactions[zone]
		-- if faction then self:Debug("ZONE", faction) end
	end

	if not faction and db.defaultChampion then
		for buff, info in pairs(championFactions) do
			if UnitBuff("player", buff) then
				faction = info[2]
				-- if faction self:Debug("DEFAULT CHAMPION", faction) end
				break
			end
		end
	end

	-- if not faction then self:Debug("RACE", racialFaction) end

	self:SetWatchedFactionByName(faction or db.defaultFaction or racialFaction, db.verbose)
end

Diplomancer.PLAYER_ENTERING_WORLD = Diplomancer.Update
Diplomancer.ZONE_CHANGED = Diplomancer.Update
Diplomancer.ZONE_CHANGED_INDOORS = Diplomancer.Update
Diplomancer.ZONE_CHANGED_NEW_AREA = Diplomancer.Update

------------------------------------------------------------------------

function Diplomancer:PLAYER_CONTROL_GAINED()
	-- self:Debug("PLAYER_CONTROL_GAINED")
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
	-- self:Debug("SetWatchedFactionByName: %s", name)

	self:ExpandFactionHeaders()

	for i = 1, GetNumFactions() do
		local faction, _, standing, _, _, _, _, _, _, _, _, watched = GetFactionInfo(i)
		if not watched and faction == name and (standing < 8 or not db.ignoreExalted) then
			SetWatchedFactionIndex(i)
			if verbose then
				self:Print("Now watching %s.", faction)
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

Diplomancer.frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
Diplomancer.frame:RegisterEvent("ADDON_LOADED")
Diplomancer.frame:SetScript("OnEvent", function(self, event, ...) return Diplomancer[event] and Diplomancer[event](Diplomancer, event, ...) end)

------------------------------------------------------------------------

Diplomancer.frame.name = GetAddOnInfo(ADDON_NAME, "Title")
Diplomancer.frame:Hide()
Diplomancer.frame:SetScript("OnShow", function(self)
	self.CreateCheckbox = LibStub("PhanxConfig-Checkbox").CreateCheckbox
	self.CreateScrollingDropdown = LibStub("PhanxConfig-ScrollingDropdown").CreateScrollingDropdown

	--------------------------------------------------------------------

	local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(self.name)

	local subtitle = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	subtitle:SetHeight(32)
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	subtitle:SetPoint("RIGHT", self, -32, 0)
	subtitle:SetNonSpaceWrap(true)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetJustifyV("TOP")
	subtitle:SetText(GetAddOnMetadata(ADDON_NAME, "Notes"))

	--------------------------------------------------------------------

	local factions = {}
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

	local reset

	local default = self:CreateScrollingDropdown(L["Default faction"], factions)
	default.desc = L["Select a faction to watch when your current location doesn't have an associated faction."]
	default:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -8)
	default:SetPoint("TOPRIGHT", subtitle, "BOTTOM", -8, -8)
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

	reset = CreateFrame("Button", nil, self)
	reset:SetText(L["Reset"])
	reset.desc = L["Reset your default faction to your race's faction."]

	reset:SetPoint("TOPLEFT", default.button, "TOPRIGHT", 8, 0)
	reset:SetPoint("BOTTOMLEFT", default.button, "BOTTOMRIGHT", 8, 0)
	reset:SetWidth(80)

	reset:SetNormalFontObject(GameFontNormalSmall)
	reset:SetDisabledFontObject(GameFontDisable)
	reset:SetHighlightFontObject(GameFontHighlightSmall)

	reset:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	reset:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	reset:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
	reset:SetDisabledTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
	reset:GetNormalTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	reset:GetPushedTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	reset:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	reset:GetDisabledTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	reset:GetHighlightTexture():SetBlendMode("ADD")

	reset:SetScript("OnEnter", function(self)
		if self.desc then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.desc, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end
	end)

	reset:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	reset:SetScript("OnClick", function( self )
		self:Disable()
		db.defaultFaction = nil
		default:SetValue( racialFaction )
		Diplomancer:Update()
	end)

	if not db.defaultFaction or db.defaultFaction == racialFaction then
		reset:Disable()
	else
		reset:Enable()
	end

	--------------------------------------------------------------------

	local champion = self:CreateCheckbox(L["Default to championed faction"])
	champion.desc = L["Use your currently championed faction as your default faction."]
	champion:SetPoint("TOPLEFT", default, "BOTTOMLEFT", 0, -10)
	champion:SetChecked(db.defaultChampion)
	champion.func = function(checked)
		db.defaultChampion = checked
		Diplomancer:Update()
	end

	--------------------------------------------------------------------

	local exalted = self:CreateCheckbox(L["Ignore exalted factions"])
	exalted.desc = L["Don't watch factions with whom you have already attained Exalted reputation."]
	exalted:SetPoint("TOPLEFT", champion, "BOTTOMLEFT", 0, -8)
	exalted:SetChecked(db.ignoreExalted)
	exalted.func = function(checked)
		db.ignoreExalted = checked
		Diplomancer:Update()
	end

	--------------------------------------------------------------------

	local announce = self:CreateCheckbox(L["Announce watched faction"])
	announce.desc = L["Show a message in the chat frame when your watched faction is changed."]
	announce:SetPoint("TOPLEFT", exalted, "BOTTOMLEFT", 0, -8)
	announce:SetChecked(db.verbose)
	announce.func = function(checked)
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

	self:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(Diplomancer.frame)
Diplomancer.aboutPanel = LibStub("LibAboutPanel").new(Diplomancer.frame.name, ADDON_NAME)

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