------------------------------------------------------------------------

local ADDON_NAME, Diplomancer = ...
Diplomancer.L = Diplomancer.L or { }

------------------------------------------------------------------------

local db, onTaxi, taxiEnded, championFactions, championZones, racialFaction, subzoneFactions, zoneFactions
local L = setmetatable(Diplomancer.L, { __index = function(t, s) t[s] = s return s end })

------------------------------------------------------------------------

function Diplomancer:Debug(text, ...)
	if ... then
		if text:match("%%") then
			text = text:format(...)
		else
			text = string.join(", ", text, ...)
		end
	end
	print(("|cffff3399[DEBUG] Diplomancer:|r %s"):format(text))
end

function Diplomancer:Print(text, ...)
	if ... then
		if text:match("%%") then
			text = text:format(...)
		else
			text = string.join(", ", text, ...)
		end
	end
	print(("|cffff3399Diplomancer:|r %s"):format(text))
end

------------------------------------------------------------------------

function Diplomancer:ADDON_LOADED(addon)
	if addon ~= ADDON_NAME then return end
	-- self:Debug("ADDON_LOADED", addon)

	-- local defaultDB = {
	-- 	defaultFaction (string)
	--	ignoreExalted  (boolean)
	--	verbose        (boolean)
	-- }

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

function Diplomancer:Update()
	-- self:Debug("Update")

	if taxiEnded then
		-- This is a hack to work around the fact that UnitOnTaxi still returns true right after PLAYER_CONTROL_GAINED has fired.
		taxiEnded = false
	elseif UnitOnTaxi("player") then
		-- self:Debug("On taxi. Skipping update.")
		onTaxi = true
		return
	end

	local faction
	local zone = GetRealZoneText()

	if championZones[zone] and select(2, IsInInstance()) == "party" then
		for k, v in pairs(championFactions) do
			if UnitBuff("player", k) then
				faction = v
				break
			end
		end
	end

	if not faction then
		local subzone = GetSubZoneText()
		faction = subzone and subzoneFactions[zone] and subzoneFactions[zone][subzone]
	end

	if not faction then
		faction = zoneFactions[zone]
	end

	self:SetWatchedFactionByName(faction or db.defaultFaction or racialFaction, db.verbose)
end

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

local factionHeaderStatus = { }
function Diplomancer:SetWatchedFactionByName(faction, verbose)
	if type(faction) ~= "string" or faction:len() == 0 then return end

	self:ExpandFactionHeaders()

	local faction, standing, _
	for i = 1, GetNumFactions() do
		faction, _, standing = GetFactionInfo(i)
		if faction == name and (standing < 8 or not db.ignoreExalted) then
			SetWatchedFactionIndex(i)
			if db.verbose then
				self:Print("Now watching %s.", faction)
			end
			return true, name
		end
	end

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
			if faction:lower():match(text) then
				return faction
			end
		end
	end
end

------------------------------------------------------------------------

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

------------------------------------------------------------------------

Diplomancer.frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
Diplomancer.frame:RegisterEvent("ADDON_LOADED")
Diplomancer.frame:SetScript("OnEvent", function(self, event, ...) return Diplomancer[event] and Diplomancer[event](Diplomancer, ...) end)

------------------------------------------------------------------------

Diplomancer.frame.name = GetAddOnInfo(ADDON_NAME, "Title")
Diplomancer.frame:Hide()
Diplomancer.frame:SetScript("OnShow", function(self)
	local title, subtitle, defaultLabel, defaultDropdown, ltex, mtex, rtex, defaultButton, exaltedCheckbox, verboseCheckbox

	--------------------------------------------------------------------

	title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(self.name)

	subtitle = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	subtitle:SetHeight(32)
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	subtitle:SetPoint("RIGHT", f, -32, 0)
	subtitle:SetNonSpaceWrap(true)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetJustifyV("TOP")
	subtitle:SetText(GetAddOnMetadata(ADDON_NAME, "Notes"))

	--------------------------------------------------------------------

	local function Widget_OnEnter(self)
		if self.desc then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:AddLine(self.name, 1, 0.8, 0)
			GameTooltip:AddLine(self.desc, 1, 1, 1)
		end
	end

	local function Widget_OnLeave()
		GameTooltip:Hide()
	end

	--------------------------------------------------------------------

	defaultLabel = self:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	defaultLabel:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -8)
	defaultLabel:SetText(L["Default faction"])

	defaultDropdown = CreateFrame("Frame", "DiplomancerDefaultFactionDropdown", self)
	defaultDropdown:SetPoint("TOPLEFT", defaultlabel, "BOTTOMLEFT", 0, -2)
	defaultDropdown:SetWidth(199)
	defaultDropdown:SetHeight(32)
	defaultDropdown:EnableMouse(true)

	defaultDropdown:SetScript("OnEnter", Widget_OnEnter)
	defaultDropdown:SetScript("OnLeave", Widget_OnLeave)
	defaultDropdown:SetScript("OnHide", function() CloseDropDownMenus() end)

	defaultDropdown.desc = L["Select a faction to watch when your current location doesn't have an associated faction."]

	ltex = defaultDropdown:CreateTexture("DiplomancerDropdownLeft", "ARTWORK")
	ltex:SetPoint("TOPLEFT", 0, 17)
	ltex:SetWidth(25)
	ltex:SetHeight(64)
	ltex:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
	ltex:SetTexCoord(0, 0.1953125, 0, 1)

	mtex = defaultDropdown:CreateTexture(nil, "ARTWORK")
	mtex:SetPoint("LEFT", ltex, "RIGHT")
	mtex:SetWidth(165)
	mtex:SetHeight(64)
	mtex:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
	mtex:SetTexCoord(0.1953125, 0.8046875, 0, 1)

	rtex = defaultDropdown:CreateTexture(nil, "ARTWORK")
	rtex:SetPoint("LEFT", mtex, "RIGHT")
	rtex:SetWidth(25)
	rtex:SetHeight(64)
	rtex:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
	rtex:SetTexCoord(0.8046875, 1, 0, 1)

	defaultDropdown.text = defaultDropdown:CreateFontString("DiplomancerDropdownText", "ARTWORK", "GameFontHighlightSmall")
	defaultDropdown.text:SetPoint("RIGHT", rtex, -43, 2)
	defaultDropdown.text:SetWidth(0)
	defaultDropdown.text:SetHeight(10)
	defaultDropdown.text:SetJustifyH("RIGHT")
	defaultDropdown.text:SetText(db.defaultFaction or racialFaction)

	defaultDropdown.button = CreateFrame("Button", nil, default)
	defaultDropdown.button:SetPoint("TOPRIGHT", rtex, -16, -18)
	defaultDropdown.button:SetWidth(24)
	defaultDropdown.button:SetHeight(24)

	defaultDropdown.button:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
	defaultDropdown.button:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
	defaultDropdown.button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	defaultDropdown.button:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
	defaultDropdown.button:GetHighlightTexture():SetBlendMode("ADD")

	defaultDropdown.button:SetScript("OnEnter", Widget_OnEnter)
	defaultDropdown.button:SetScript("OnLeave", Widget_OnLeave)
	defaultDropdown.button:SetScript("OnClick", function(self)
		ToggleDropDownMenu(nil, nil, defaultDropdown)
		PlaySound("igMainMenuOptionCheckBoxOn")
	end)

	local function Dropdown_OnClick(self)
		self = self or this

		if self.value == racialFaction then
			reset:Disable()
		else
			reset:Enable()
		end

		UIDropDownMenu_SetSelectedValue(defaultDropdown, self.value)
		defaultDropdown.text:SetText(self.value)

		db.defaultFaction = self.value
		Diplomancer:Update()
	end

	local info = UIDropDownMenu_CreateInfo()
	local function AddItem(text, value, func, checked, disabled)
		info.text = text
		info.value = value
		info.func = func
		info.checked = checked
		info.disabled = disabled
		UIDropDownMenu_AddButton(info)
	end

	local factions = { }
	UIDropDownMenu_Initialize(defaultDropdown, function()
		wipe(factions)
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

		local selected = db.defaultFaction or racialFaction

		for i, faction in ipairs(factions) do
			AddItem(faction, faction, Dropdown_OnClick, faction == selected)
		end
	end)

	UIDropDownMenu_SetSelectedValue(defaultDropdown, db.defaultFaction or racialFaction)

	--------------------------------------------------------------------

	defaultButton = CreateFrame("Button", nil, self)
	defaultButton:SetText(L["Reset"])
	defaultButton:SetPoint("LEFT", defaultDropdown.button, "RIGHT", 8, 0)
	defaultButton:SetWidth(80)
	defaultButton:SetHeight(22)

	defaultButton:SetNormalFontObject(GameFontNormalSmall)
	defaultButton:SetDisabledFontObject(GameFontDisable)
	defaultButton:SetHighlightFontObject(GameFontHighlightSmall)

	defaultButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	defaultButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	defaultButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
	defaultButton:SetDisabledTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
	defaultButton:GetNormalTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	defaultButton:GetPushedTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	defaultButton:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	defaultButton:GetDisabledTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	defaultButton:GetHighlightTexture():SetBlendMode("ADD")

	defaultButton:SetScript("OnEnter", Widget_OnEnter)
	defaultButton:SetScript("OnLeave", Widget_OnLeave)

	defaultButton.desc = L["Reset your default faction to your race's faction."]

	if not db.defaultFaction then
		defaultButton:Disable()
	else
		defaultButton:Enable()
	end

	--------------------------------------------------------------------

	local function Checkbox_OnClick(self)
		local checked = self:GetChecked() == 1
		PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		if self.func then
			self.func(checked)
		end
	end

	function self:CreateCheckbox(name, size)
		local check = CreateFrame("CheckButton", nil, self)
		check:SetWidth(size or 26)
		check:SetHeight(size or 26)

		check:SetHitRectInsets(0, -100, 0, 0)

		check:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
		check:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
		check:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
		check:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
		check:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")

		check:SetScript("OnEnter", Widget_OnEnter)
		check:SetScript("OnLeave", Widget_OnLeave)
		check:SetScript("OnClick", Checkbox_OnClick)

		local label = check:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		label:SetPoint("LEFT", check, "RIGHT", 0, 1)
		label:SetText(name)
		check.label = label

		return check
	end

	--------------------------------------------------------------------

	exaltedCheckbox = self:CreateCheckbox(L["Ignore exalted factions"])
	exaltedCheckbox:SetPoint("TOPLEFT", default, "BOTTOMLEFT", 0, -16)
	exaltedCheckbox:SetChecked(db.ignoreExalted)
	exaltedCheckbox.desc = L["With this option enabled, Diplomancer will not watch factions you have already attained Exalted status with."]
	exaltedCheckbox.func = function(checked)
		db.ignoreExalted = checked
		Diplomancer:Update()
	end

	--------------------------------------------------------------------

	verboseCheckbox = self:CreateCheckbox(L["Announce watched faction"])
	verboseCheckbox:SetPoint("TOPLEFT", exalted, "BOTTOMLEFT", 0, -16)
	verboseCheckbox:SetChecked(db.verbose)
	verboseCheckbox.desc = L["With this option enabled, Diplomancer will add a message to your chat frame when changing your watched faction."]
	verboseCheckbox.func = function(checked)
		db.verbose = checked
	end

	--------------------------------------------------------------------

	self:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(Diplomancer.frame)
LibStub("LibAboutPanel").new(Diplomancer.frame.name, ADDON_NAME)

------------------------------------------------------------------------

SLASH_DIPLOMANCER1 = "/diplomancer"
SLASH_DIPLOMANCER2 = "/dm"

SlashCmdList.DIPLOMANCER = function(text)
	if text and text:len() > 0 then
		local cmd, arg = text:match("^%s*(%w+)%s*(.*)$")
		if type(db[cmd]) == "boolean" then
			db[cmd] = not db[cmd]
			return Diplomancer:Update()
		elseif cmd == "default" then
			local faction = Diplomancer:GetFactionNameMatch(arg)
			if faction then
				db.default = faction
				return Diplomancer:Update()
			end
		end
	end
	InterfaceOptionsFrame_OpenToCategory(Diplomancer.frame)
end

------------------------------------------------------------------------

_G.Diplomancer = Diplomancer

------------------------------------------------------------------------