--[[--------------------------------------------------------------------
	Diplomancer
	Automatically sets your watched faction based on your location.
	Copyright (c) 2007-2015 Phanx <addons@phanx.net>. All rights reserved.
	http://www.wowinterface.com/downloads/info9643-Diplomancer.html
	http://www.curse.com/addons/wow/diplomancer
	https://github.com/Phanx/Diplomancer
----------------------------------------------------------------------]]

local ADDON_NAME, Diplomancer = ...

------------------------------------------------------------------------

Diplomancer.OptionsPanel = LibStub("PhanxConfig-OptionsPanel").CreateOptionsPanel(ADDON_NAME, nil, function(self)
	local L = Diplomancer.L
	local db = DiplomancerSettings
	local racialFaction = Diplomancer.racialFaction

	local factions, factionDisplayNames = {}, {}

	--------------------------------------------------------------------

	local title, notes = self:CreateHeader(ADDON_NAME, true)

	local reset

	local default = self:CreateDropdown(L.DefaultFaction, L.DefaultFaction_Desc, factions)
	default:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 0, -8)
	default:SetWidth(270)
	function default:OnValueChanged(value)
		if value == racialFaction then
			db.defaultFaction = nil
			reset:Disable()
		else
			db.defaultFaction = Diplomancer:GetFactionIDFromName(factionDisplayNames[value] or value)
			reset:Enable()
		end
		Diplomancer:Update()
	end

	reset = self:CreateButton(L.Reset, L.Reset_Desc)
	reset:SetPoint("TOPLEFT", default.button, "TOPRIGHT", 8, 0)
	reset:SetPoint("BOTTOMLEFT", default.button, "BOTTOMRIGHT", 8, 0)
	reset:SetWidth(max(16 + reset:GetFontString():GetStringWidth(), 80))
	function reset:OnClick()
		self:Disable()
		db.defaultFaction = nil
		local defaultName = 
		default:SetValue((Diplomancer:GetFactionNameFromID(racialFaction)))
		Diplomancer:Update()
	end

	local champion = self:CreateCheckbox(L.DefaultToChampioned, L.DefaultToChampioned_Desc)
	champion:SetPoint("TOPLEFT", default, "BOTTOMLEFT", 0, -10)
	function champion:OnValueChanged(value)
		db.defaultChampion = value
		Diplomancer:Update()
	end

	local exalted = self:CreateCheckbox(L.IgnoreExalted, L.IgnoreExalted_Desc)
	exalted:SetPoint("TOPLEFT", champion, "BOTTOMLEFT", 0, -8)
	function exalted:OnValueChanged(value)
		db.ignoreExalted = value
		Diplomancer:Update()
	end

	local announce = self:CreateCheckbox(L.Announce, L.Anounce_Desc)
	announce:SetPoint("TOPLEFT", exalted, "BOTTOMLEFT", 0, -8)
	function announce:OnValueChanged(value)
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

------------------------------------------------------------------------

SLASH_DIPLOMANCER1 = "/diplomancer"
SLASH_DIPLOMANCER2 = "/dm"

SlashCmdList.DIPLOMANCER = function()
	InterfaceOptionsFrame_OpenToCategory(Diplomancer.OptionsPanel)
end