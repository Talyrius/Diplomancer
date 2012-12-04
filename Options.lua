--[[--------------------------------------------------------------------
	Diplomancer
	Automatically sets your watched faction based on your location.
	Copyright (c) 2007-2012 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info9643-Diplomancer.html
	http://www.curse.com/addons/wow/diplomancer
----------------------------------------------------------------------]]

local ADDON_NAME, Diplomancer = ...
local L = Diplomancer.L

------------------------------------------------------------------------

Diplomancer.frame = LibStub("PhanxConfig-OptionsPanel").CreateOptionsPanel(ADDON_NAME)

Diplomancer.frame:RegisterEvent("ADDON_LOADED")
Diplomancer.frame:SetScript("OnEvent", function(self, event, ...) return Diplomancer[event] and Diplomancer[event](Diplomancer, event, ...) end)

Diplomancer.frame.runOnce = function(self)
	local db = DiplomancerSettings
	local racialFaction = Diplomancer.racialFaction

	local CreateCheckbox = LibStub("PhanxConfig-Checkbox").CreateCheckbox

	--------------------------------------------------------------------

	local title, notes = LibStub("PhanxConfig-Header").CreateHeader(self, ADDON_NAME, GetAddOnMetadata(ADDON_NAME, "Notes"))

	--------------------------------------------------------------------

	local factions, factionDisplayNames = {}, {}

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
			db.defaultFaction = factionDisplayNames[value] or value
			reset:Enable()
		end
		Diplomancer:Update()
	end

	--------------------------------------------------------------------

	reset = LibStub("PhanxConfig-Button").CreateButton(self, L["Reset"], L["Reset your default faction preference to your race's faction."])
	reset:SetPoint("TOPLEFT", default.button, "TOPRIGHT", 8, 0)
	reset:SetPoint("BOTTOMLEFT", default.button, "BOTTOMRIGHT", 8, 0)
	reset:SetWidth(max(16 + reset:GetFontString():GetStringWidth(), 80))
	reset:SetScript("OnClick", function(self)
		self:Disable()
		db.defaultFaction = nil
		default:SetValue(racialFaction)
		Diplomancer:Update()
	end)

	--------------------------------------------------------------------

	local champion = CreateCheckbox(self, L["Default to championed faction"], L["Use your currently championed faction as your default faction."])
	champion:SetPoint("TOPLEFT", default, "BOTTOMLEFT", 0, -10)
	champion.OnValueChanged = function(self, checked)
		db.defaultChampion = checked
		Diplomancer:Update()
	end

	--------------------------------------------------------------------

	local exalted = CreateCheckbox(self, L["Ignore Exalted factions"], L["Don't watch factions with whom you have already attained Exalted reputation."])
	exalted:SetPoint("TOPLEFT", champion, "BOTTOMLEFT", 0, -8)
	exalted.OnValueChanged = function(self, checked)
		db.ignoreExalted = checked
		Diplomancer:Update()
	end

	--------------------------------------------------------------------

	local announce = CreateCheckbox(self, L["Announce watched faction"], L["Show a message in the chat frame when your watched faction is changed."])
	announce:SetPoint("TOPLEFT", exalted, "BOTTOMLEFT", 0, -8)
	announce.OnValueChanged = function(self, checked)
		db.verbose = checked
	end

	--------------------------------------------------------------------

	self.refresh = function()
		wipe(factions)
		Diplomancer:ExpandFactionHeaders()
		local curHeader
		for i = 1, GetNumFactions() do
			local name, _, standing, _, _, _, _, _, isHeader, _, hasRep, _, isChild = GetFactionInfo(i)
			if name == L["Inactive"] then
				break
			end
			if isHeader and hasRep then
				curHeader = name
			elseif curHeader and (isHeader or not isChild) then
				curHeader = nil
			end
			if (hasRep or not isHeader) and (standing < 8 or not db.ignoreExalted) then
				if curHeader then
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

		default:SetValue(db.defaultFaction or racialFaction)
		default:SetEnabled(db.defaultFaction and db.defaultFaction ~= racialFaction)

		champion:SetValue(db.defaultChampion)
		exalted:SetValue(db.ignoreExalted)
		announce:SetValue(db.verbose)
	end
end

Diplomancer.aboutPanel = LibStub("LibAboutPanel").new(ADDON_NAME, ADDON_NAME)

------------------------------------------------------------------------

SLASH_DIPLOMANCER1 = "/diplomancer"
SLASH_DIPLOMANCER2 = "/dm"

SlashCmdList.DIPLOMANCER = function(text)
	if text and strlen(text) > 0 then
		local cmd, arg = strmatch(strlower(strtrim(text)), "^(%w+)%s*(.*)$")
		if cmd == "default" then
			local faction = Diplomancer:GetFactionNameMatch(arg)
			if faction then
				DiplomancerSettings.default = faction
				return Diplomancer:Update()
			end
		else
			local db = DiplomancerSettings
			for k, v in pairs(db) do
				if strlower(k) == cmd and type(v) == "boolean" then
					db[k] = not db[k]
					return Diplomancer:Update()
				end
			end
		end
	end
	InterfaceOptionsFrame_OpenToCategory(Diplomancer.aboutPanel)
	InterfaceOptionsFrame_OpenToCategory(Diplomancer.frame)
end