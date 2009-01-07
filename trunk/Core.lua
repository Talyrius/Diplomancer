--[[--------------------------------------------------------------------
	Diplomancer
	Automatically sets your watched faction based on your location.
	by Phanx < addons@phanx.net >
	Copyright © 2007-2008 Alyssa S. Kinley, a.k.a. Phanx
	See included README for license terms and additional information.
----------------------------------------------------------------------]]

local Diplomancer = CreateFrame("Frame", "Diplomancer")
Diplomancer.version = tonumber(GetAddOnMetadata("Diplomancer", "Version"))
Diplomancer:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, ...)	end end)
Diplomancer:RegisterEvent("PLAYER_ENTERING_WORLD")

local db, zones, subzones, champions, racial, onTaxi

local L = setmetatable(DIPLOMANCER_STRINGS or {}, { __index = function(t, k) rawset(t, k, k) return k end })
if DIPLOMANCER_STRINGS then DIPLOMANCER_STRINGS = nil end

local function Print(text)
	print("|cff33ff99Diplomancer:|r "..text)
end

local function Debug(text)
	print("|cffff3399[DEBUG] Diplomancer:|r "..text)
end

--[[------------------------------------------------------------
	Initialize
--------------------------------------------------------------]]
function Diplomancer:PLAYER_ENTERING_WORLD()
	zones, subzones, champions, racial = self:GetData()

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

	self:RegisterEvent("PLAYER_CONTROL_LOST")
	self:RegisterEvent("PLAYER_CONTROL_GAINED")
	self:RegisterEvent("ZONE_CHANGED")
	self:RegisterEvent("ZONE_CHANGED_INDOORS")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self.PLAYER_ENTERING_WORLD = nil
end

--[[------------------------------------------------------------
	Check taxi status
--------------------------------------------------------------]]
function Diplomancer:PLAYER_CONTROL_LOST()
	--Debug("Control lost")
	if UnitOnTaxi("player") then
		--Debug("Taxi ride started")
		onTaxi = true
	end
end

function Diplomancer:PLAYER_CONTROL_GAINED()
	--Debug("Control gained")
	if onTaxi then
		--Debug("Taxi ride ended")
		onTaxi = false
		self:Update()
	end
end

--[[------------------------------------------------------------
	Update watched faction for the current zone
--------------------------------------------------------------]]
function Diplomancer:ZONE_CHANGED()
	--Debug("Subzone changed")
	self:Update()
end

function Diplomancer:ZONE_CHANGED_INDOORS()
	--Debug("Zone changed (indoors)")
	self:Update()
end

function Diplomancer:ZONE_CHANGED_NEW_AREA()
	--Debug("Zone changed")
	self:Update()
end

function Diplomancer:Update()
	if onTaxi then
		--Debug("On taxi; skipping update")
		return
	end

	local zone, subzone = GetRealZoneText(), GetSubZoneText()
	--Debug("zone = "..zone.."; subzone = "..subzone)

	local faction
	if subzones[zone] and subzones[zone][subzone] then
		faction = subzones[zone][subzone]
		--Debug("Setting watch on "..faction.." (subzone)")
	elseif zones[zone] then
		faction = zones[zone]
		--Debug("Setting watch on "..faction.." (zone)")
	elseif db.default then
		faction = db.default
		--Debug("Setting watch on "..faction.." (default)")
	else
		faction = racial
		--Debug("Setting watch on "..faction.." (racial)")
	end

	if UnitLevel("player") == 80 then
		local _, instance = IsInInstance()
		--Debug("UnitLevel 80, IsInInstance " .. instance)
		if instance and instance == "party" then
			for aura, champion in pairs(champions) do
				if UnitAura("player", aura) then
					--Debug("Setting watch on " .. champion .. " (champion)")
					faction = champion
					break
				end
			end
		end
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
		search - partial faction name to match on
	Returns:
		found - whether or not a matching faction was found
		faction - name of faction found (nil if none)
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
	local name, isHeader, isCollapsed, _
	local n = GetNumFactions()
	for i = 1, n do
		name, _, _, _, _, _, _, _, isHeader, isCollapsed = GetFactionInfo(i)
		if isHeader then
			if isCollapsed and name ~= L["Inactive"] then
				ExpandFactionHeader(i)
				n = GetNumFactions()
				i = 1
			elseif name == L["Inactive"] then
				if not ReputationFrame:IsShown() then
					CollapseFactionHeader(i)
				end
				break
			end
		end
	end
end

--[[------------------------------------------------------------
	Options
	Widget creation adapted from Tekkub's tekKonfig libraries
--------------------------------------------------------------]]

local f = CreateFrame("Frame", nil, UIOptionsContainer)
f.name = "Diplomancer"
f:Hide()
f:SetScript("OnShow", function()
	local title = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(f.name)

	local subtitle = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	subtitle:SetHeight(32)
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	subtitle:SetPoint("RIGHT", f, -32, 0)
	subtitle:SetNonSpaceWrap(true)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetJustifyV("TOP")
	subtitle:SetText(GetAddOnMetadata("Diplomancer", "Notes"))

	local function OnEnter(self)
		if self.tiptext then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tiptext, nil, nil, nil, nil, true)
		end
	end

	local function OnLeave()
		GameTooltip:Hide()
	end

	local reset

	local defaultlabel = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	defaultlabel:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -8)
	defaultlabel:SetText(L["Default Faction"])

	local default = CreateFrame("Frame", "DiplomancerDropdown", f)
	default.tiptext = L["Select a faction to watch when your current location doesn't have an associated faction."]
	default:SetPoint("TOPLEFT", defaultlabel, "BOTTOMLEFT", -12, -2)
	default:SetWidth(199)
	default:SetHeight(32)
	default:EnableMouse(true)
	default:SetScript("OnEnter", OnEnter)
	default:SetScript("OnLeave", OnLeave)
	default:SetScript("OnHide", function() CloseDropDownMenus() end)

	local ltex = default:CreateTexture("DiplomancerDropdownLeft", "ARTWORK")
	ltex:SetPoint("TOPLEFT", 0, 17)
	ltex:SetWidth(25)
	ltex:SetHeight(64)
	ltex:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
	ltex:SetTexCoord(0, 0.1953125, 0, 1)

	local mtex = default:CreateTexture(nil, "ARTWORK")
	mtex:SetPoint("LEFT", ltex, "RIGHT")
	mtex:SetWidth(165)
	mtex:SetHeight(64)
	mtex:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
	mtex:SetTexCoord(0.1953125, 0.8046875, 0, 1)

	local rtex = default:CreateTexture(nil, "ARTWORK")
	rtex:SetPoint("LEFT", mtex, "RIGHT")
	rtex:SetWidth(25)
	rtex:SetHeight(64)
	rtex:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
	rtex:SetTexCoord(0.8046875, 1, 0, 1)

	local defaulttext = default:CreateFontString("DiplomancerDropdownText", "ARTWORK", "GameFontHighlightSmall")
	defaulttext:SetPoint("RIGHT", rtex, -43, 2)
	defaulttext:SetWidth(0)
	defaulttext:SetHeight(10)
	defaulttext:SetJustifyH("RIGHT")
	defaulttext:SetText(db.default or racial)

	local button = CreateFrame("Button", nil, default)
	button:SetWidth(24)
	button:SetHeight(24)
	button:SetPoint("TOPRIGHT", rtex, -16, -18)
	button:SetScript("OnClick", function(self)
		ToggleDropDownMenu(nil, nil, default)
		PlaySound("igMainMenuOptionCheckBoxOn")
	end)

	button:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
	button:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
	button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	button:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
	button:GetHighlightTexture():SetBlendMode("ADD")

	local info = UIDropDownMenu_CreateInfo()
	local function AddItem(text, value, func, checked, disabled)
		info.text = text
		info.value = value
		info.func = func
		info.checked = checked
		info.disabled = disabled
		UIDropDownMenu_AddButton(info)
	end

	local function Dropdown_OnClick()
		if this.value == racial then reset:Disable() else reset:Enable() end
		UIDropDownMenu_SetSelectedValue(default, this.value)
		defaulttext:SetText(this.value)
		db.default = this.value
		Diplomancer:Update()
	end

	UIDropDownMenu_Initialize(default, function()
		local factions = {}
		Diplomancer:ExpandFactionHeaders()
		for i = 1, GetNumFactions() do
			local name, _, _, _, _, _, _, _, isHeader = GetFactionInfo(i)
			if name == L["Inactive"] then
				break
			end
			if not isHeader then
				table.insert(factions, name)
			end
		end
		table.sort(factions)

		local selected = db.default or racial

		for i, faction in ipairs(factions) do
			AddItem(faction, faction, Dropdown_OnClick, faction == selected)
		end
	end)

	UIDropDownMenu_SetSelectedValue(default, db.default)

	reset = CreateFrame("Button", nil, f)
	reset.tiptext = L["Reset your default faction preference to your race's faction"]
	reset:SetText(L["Reset"])
	reset:SetPoint("LEFT", button, "RIGHT", 8, 0)
	reset:SetWidth(80)
	reset:SetHeight(22)

	reset:SetDisabledFontObject(GameFontDisable)
	reset:SetHighlightFontObject(GameFontHighlightSmall)
	if IS_WRATH_BUILD then reset:SetNormalFontObject(GameFontNormalSmall) else reset:SetTextFontObject(GameFontNormalSmall) end

	reset:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	reset:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	reset:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
	reset:SetDisabledTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
	reset:GetNormalTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	reset:GetPushedTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	reset:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	reset:GetDisabledTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	reset:GetHighlightTexture():SetBlendMode("ADD")

	reset:SetScript("OnEnter", OnEnter)
	reset:SetScript("OnLeave", OnLeave)

	if db.default == nil then reset:Disable() else reset:Enable() end

	local function CreateCheckbox(parent, text, size)
		local check = CreateFrame("CheckButton", nil, parent)
		check:SetWidth(size or 26)
		check:SetHeight(size or 26)

		check:SetHitRectInsets(0, -100, 0, 0)

		check:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
		check:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
		check:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
		check:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
		check:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")

		check:SetScript("OnEnter", OnEnter)
		check:SetScript("OnLeave", OnLeave)

		local label = check:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		label:SetPoint("LEFT", check, "RIGHT", 0, 1)
		label:SetText(text)

		return check, label
	end

	local exalted = CreateCheckbox(f, L["Ignore Exalted Factions"])
	exalted.tiptext = L["Don't watch factions you've already acheived Exalted standing with."]
	exalted:SetPoint("TOPLEFT", default, "BOTTOMLEFT", 2, -8)
	exalted:SetScript("OnClick", function(self)
		PlaySound(self:GetChecked() and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		db.ignoreExalted = self:GetChecked() and true or false
		Diplomancer:Update()
	end)
	exalted:SetChecked(db.ignoreExalted)

	local verbose = CreateCheckbox(f, L["Enable Notifications"])
	verbose.tiptext = L["Show a message in the chat frame when your watched faction changes."]
	verbose:SetPoint("TOPLEFT", exalted, "BOTTOMLEFT", 2, -8)
	verbose:SetScript("OnClick", function(self)
		PlaySound(self:GetChecked() and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		db.verbose = self:GetChecked() and true or false
	end)
	verbose:SetChecked(db.verbose)

	if LibStub and LibStub("tekKonfig-AboutPanel", true) then
		LibStub("tekKonfig-AboutPanel").new("Diplomancer", f.name)
	end

	f:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(f)

Diplomancer.configpanel = f

SLASH_DIPLOMANCER1 = "/diplomancer"
SLASH_DIPLOMANCER2 = "/dm"
SlashCmdList.DIPLOMANCER = function()
	InterfaceOptionsFrame_OpenToCategory(f)
end