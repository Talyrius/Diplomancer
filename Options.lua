--[[--------------------------------------------------------------------
	Diplomancer
	Automatically sets your watched faction based on your location.
	Copyright (c) 2007-2013 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info9643-Diplomancer.html
	http://www.curse.com/addons/wow/diplomancer
----------------------------------------------------------------------]]

local ADDON_NAME, Diplomancer = ...
local L = Diplomancer.L

------------------------------------------------------------------------

Diplomancer.OptionsPanel = LibStub("PhanxConfig-OptionsPanel").CreateOptionsPanel(ADDON_NAME, nil, function(self)
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
	default.OnValueChanged = function(self, value)
		if value == racialFaction then
			db.defaultFaction = nil
			reset:Disable()
		else
			db.defaultFaction = Diplomancer:GetFactionIDFromName(factionDisplayNames[value] or value)
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
		default:SetValue(Diplomancer:GetFactionNameFromID(racialFaction))
		Diplomancer:Update()
	end)

	--------------------------------------------------------------------

	local champion = CreateCheckbox(self, L["Default to championed faction"], L["Use your currently championed faction as your default faction."])
	champion:SetPoint("TOPLEFT", default, "BOTTOMLEFT", 0, -10)
	champion.OnValueChanged = function(self, value)
		db.defaultChampion = value
		Diplomancer:Update()
	end

	--------------------------------------------------------------------

	local exalted = CreateCheckbox(self, L["Ignore Exalted factions"], L["Don't watch factions with whom you have already attained Exalted reputation."])
	exalted:SetPoint("TOPLEFT", champion, "BOTTOMLEFT", 0, -8)
	exalted.OnValueChanged = function(self, value)
		db.ignoreExalted = value
		Diplomancer:Update()
	end

	--------------------------------------------------------------------

	local announce = CreateCheckbox(self, L["Announce watched faction"], L["Show a message in the chat frame when your watched faction is changed."])
	announce:SetPoint("TOPLEFT", exalted, "BOTTOMLEFT", 0, -8)
	announce.OnValueChanged = function(self, value)
		db.verbose = value
	end

	--------------------------------------------------------------------

	self.refresh = function()
		wipe(factions)
		Diplomancer:ExpandFactionHeaders()
		local curHeader
		for i = 1, GetNumFactions() do
			local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar,
				isHeader, isCollapsed, hasRep, isWatched, isChild, factionID = GetFactionInfo(i)
			if name == FACTION_INACTIVE then
				break
			end
			if isHeader and isChild then
				curHeader = name
			elseif curHeader and (isHeader or not isChild) then
				curHeader = nil
			end
			if (hasRep or not isHeader) and (standingID < 8 or not db.ignoreExalted) then
				if factionID and GetFriendshipReputation(factionID) then
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

		local defaultValue = Diplomancer:GetFactionNameFromID(db.defaultFaction or racialFaction)
		default:SetValue(defaultValue)
		reset:SetEnabled(db.defaultFaction and db.defaultFaction ~= racialFaction)

		champion:SetValue(db.defaultChampion)
		exalted:SetValue(db.ignoreExalted)
		announce:SetValue(db.verbose)
	end
end)

Diplomancer.AboutPanel = LibStub("LibAboutPanel").new(ADDON_NAME, ADDON_NAME)

------------------------------------------------------------------------

SLASH_DIPLOMANCER1 = "/diplomancer"
SLASH_DIPLOMANCER2 = "/dm"

SlashCmdList.DIPLOMANCER = function(text)
	InterfaceOptionsFrame_OpenToCategory(Diplomancer.OptionsPanel)
end