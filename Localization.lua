--[[--------------------------------------------------------------------
	Translations for Diplomancer
----------------------------------------------------------------------]]

local LOCALE = GetLocale()
if LOCALE:match("^en") then return end

local _, Diplomancer = ...
if not Diplomancer then -- WoW China is still running 3.2
	Diplomancer = { }
	_G.Diplomancer = Diplomancer
end
Diplomancer.L = { }

--[[--------------------------------------------------------------------
	deDE | German | Deutsch
	Contributors: paterbrown
	Last updated: 2009-02-07
----------------------------------------------------------------------]]

if LOCALE == "deDE" then

L["Default Faction"] = "Standardfraktion"
L["Select a faction to watch when your current location doesn't have an associated faction."] = "Wähle eine Standardfraktion, welche angezeigt wird wenn dein Aufenthaltsort nicht mit einer Fraktion verknüpft ist."

L["Reset"] = "Reset"
L["Reset your default faction preference to your race's faction."] = "Zurücksetzen der Standardfraktion auf deine Volksfraktion."

L["Ignore Exalted Factions"] = "Ignoriere ehrfürchtige Fraktionen"
L["Don't watch factions you've already acheived Exalted standing with."] = "Zeigt Fraktionen mit ehrfürchtigem Ruf nicht mehr an."

L["Enable Notifications"] = "Schalte Benachrichtigungen ein"
L["Show a message in the chat frame when your watched faction changes."] = "Zeigt eine Meldung im Chatfenster wenn sich die angezeigte Fraktion ändert."

end

--[[--------------------------------------------------------------------
	esES | Spanish | Español
	Contributors: Phanx
	Last updated: 2010-09-07
----------------------------------------------------------------------]]

if LOCALE == "esES" or LOCALE == "esMX" then

L["Default Faction"] = "Facción Predeterminado"
L["Select a faction to watch when your current location doesn't have an associated faction."] = "Seleccione una de las facciones a vigilar cuando su ubicación actual no tiene una facción asociada."

L["Reset"] = "Restablecer"
L["Reset your default faction preference to your race's faction."] = "Restablecer su preferencia por defecto a la facción de la facción de tu raza."

L["Ignore Exalted Factions"] = "Ignorar Facciones Exaltados"
L["Don't watch factions you've already acheived Exalted standing with."] = "No vea las facciones con las que ya hemos logrado la reputación de Exaltado."

L["Enable Notifications"] = "Habilitar las Notificaciones"
L["Show a message in the chat frame when your watched faction changes."] = "Mostrar un mensaje en el marco del chat al cambiar tu facción seguimientos."

end

--[[--------------------------------------------------------------------
	frFR | French | Français
	Contributors: ???
	Last updated: YYYY-MM-DD
----------------------------------------------------------------------]]

if LOCALE == "frFR" then

-- L["Default Faction"] = ""
-- L["Select a faction to watch when your current location doesn't have an associated faction."] = ""

-- L["Reset"] = ""
-- L["Reset your default faction preference to your race's faction."] = ""

-- L["Ignore Exalted Factions"] = ""
-- L["Don't watch factions you've already acheived Exalted standing with."] = ""

-- L["Enable Notifications"] = ""
-- L["Show a message in the chat frame when your watched faction changes."] = ""

end

--[[--------------------------------------------------------------------
	ruRU | Russian | Русский
	Contributors: ???
	Last updated: YYYY-MM-DD
----------------------------------------------------------------------]]

if LOCALE == "ruRU" then

-- L["Default Faction"] = ""
-- L["Select a faction to watch when your current location doesn't have an associated faction."] = ""

-- L["Reset"] = ""
-- L["Reset your default faction preference to your race's faction."] = ""

-- L["Ignore Exalted Factions"] = ""
-- L["Don't watch factions you've already acheived Exalted standing with."] = ""

-- L["Enable Notifications"] = ""
-- L["Show a message in the chat frame when your watched faction changes."] = ""

end

--[[--------------------------------------------------------------------
	koKR | Korean | 한국어
	Contributors: ???
	Last updated: YYYY-MM-DD
----------------------------------------------------------------------]]

if LOCALE == "koKR" then

-- L["Default Faction"] = ""
-- L["Select a faction to watch when your current location doesn't have an associated faction."] = ""

-- L["Reset"] = ""
-- L["Reset your default faction preference to your race's faction."] = ""

-- L["Ignore Exalted Factions"] = ""
-- L["Don't watch factions you've already acheived Exalted standing with."] = ""

-- L["Enable Notifications"] = ""
-- L["Show a message in the chat frame when your watched faction changes."] = ""

end

--[[--------------------------------------------------------------------
	zhCN | Simplified Chinese | 简体中文
	Contributors: VENSTER, 急云@CWDG
	Last updated: 2010-08-05
----------------------------------------------------------------------]]

if LOCALE == "zhCN" then

L["Default Faction"] = "缺省声望"
L["Select a faction to watch when your current location doesn't have an associated faction."] = "当目前所在区域没有对应声望时，选择监视的声望"

L["Reset"] = "重置"
L["Reset your default faction preference to your race's faction."] = "将你的缺省声望重置为种族声望"

L["Ignore Exalted Factions"] = "忽略已崇拜的声望"
L["Don't watch factions you've already acheived Exalted standing with."] = "选择是否忽略监视已经崇拜的声望"

L["Enable Notifications"] = "开启提示"
L["Show a message in the chat frame when your watched faction changes."] = "选择是否显示声望监视状态变动"

end

--[[--------------------------------------------------------------------
	zhTW | Traditional Chinese | 正體中文
	Contributors: 急云@CWDG
	Last updated: 2010-01-23
----------------------------------------------------------------------]]

if LOCALE == "zhTW" then

L["Default Faction"] = "缺省聲望"
L["Select a faction to watch when your current location doesn't have an associated faction."] = "當目前所在區域沒有對應聲望時，選擇監視的聲望"

L["Reset"] = "重置"
L["Reset your default faction preference to your race's faction."] = "將你的缺省聲望重置為種族聲望"

L["Ignore Exalted Factions"] = "忽略已崇拜的聲望"
L["Don't watch factions you've already acheived Exalted standing with."] = "選擇是否忽略監視已經崇拜的聲望"

L["Enable Notifications"] = "開啟提示"
L["Show a message in the chat frame when your watched faction changes."] = "選擇是否顯示聲望監視狀態變動"

end
