--[[--------------------------------------------------------------------
	Diplomancer
	Automatically sets your watched faction based on your location.
	Copyright (c) 2007-2012 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info9643-Diplomancer.html
	http://www.curse.com/addons/wow/diplomancer
----------------------------------------------------------------------]]

local LOCALE = GetLocale()
if LOCALE:match("^en") then return end

local _, Diplomancer = ...

--[[--------------------------------------------------------------------
	German | Deutsch
	Last updated: 2009-02-07 by paterbrown
----------------------------------------------------------------------]]

if LOCALE == "deDE" then Diplomancer.L = {

	["Default faction"] = "Standardfraktion",
	["Select a faction to watch when your current location doesn't have an associated faction."] = "Wähle eine Standardfraktion, welche angezeigt wird wenn dein Aufenthaltsort nicht mit einer Fraktion verknüpft ist.",

	["Reset"] = "Reset",
	["Reset your default faction preference to your race's faction."] = "Zurücksetzen der Standardfraktion auf deine Volksfraktion.",

	["Default to championed faction"] = "Verwenden Tragtenfraktion",
	["Use your currently championed faction as your default faction."] = "Verwenden die Tragtenfraktion als deine Standardfraktion.",

	["Ignore Exalted factions"] = "Ignoriere ehrfürchtige Fraktionen",
	["Don't watch factions with whom you have already attained Exalted reputation."] = "Zeigt Fraktionen mit ehrfürchtigem Ruf nicht mehr an.",

	["Announce watched faction"] = "Schalte Benachrichtigungen ein",
	["Show a message in the chat frame when your watched faction is changed."] = "Zeigt eine Meldung im Chatfenster wenn sich die angezeigte Fraktion ändert.",
	["Now watching %s."] = "Angezeigte %s.",

} return end

--[[--------------------------------------------------------------------
	Spanish | Español
	Last updated: 2011-02-28 by Akkorian
----------------------------------------------------------------------]]

if LOCALE == "esES" or LOCALE == "esMX" then Diplomancer.L = {

	["Default faction"] = "Facción predeterminado",
	["Select a faction to watch when your current location doesn't have an associated faction."] = "Seleccionar una facción para seguir, mientras estás en lugares sin facciones asociadas.",

	["Reset"] = "Restablecer",
	["Reset your default faction preference to your race's faction."] = "Restablecer tu facción predeterminado al facción de tu raza.",

	["Default to championed faction"] = "Utilizar facción abanderada",
	["Use your currently championed faction as your default faction."] = "Utilizar tu facción abanderada como tu facción predeterminado.",

	["Ignore Exalted factions"] = "Ignorar facciones Exaltados",
	["Don't watch factions with whom you have already attained Exalted reputation."] = "No seguir las facciones con las que ya ha alcanzado el nivel de Exaltado.",

	["Announce watched faction"] = "Anunciar facción seguido",
	["Show a message in the chat frame when your watched faction is changed."] = "Mostrar un mensaje en la ventana de chat cuando Diplomancer cambia tu facción seguido.",
	["Now watching %s."] = "Ahora siguiendo %s.",

} return end

--[[--------------------------------------------------------------------
	French | Français
	Last updated: 2010-08-05 by Akkorian
----------------------------------------------------------------------]]

if LOCALE == "frFR" then Diplomancer.L = {

	["Default faction"] = "Faction par défaut",
	["Select a faction to watch when your current location doesn't have an associated faction."] = "Sélectionnez une faction de regarder si votre position actuelle n'est pas une faction associée.",

	["Reset"] = "Remise",
	["Reset your default faction preference to your race's faction."] = "Réinitialiser votre préférence faction par défaut à la faction de votre course.",

	["Default to championed faction"] = "Par défaut à votre faction défendu",
	["Use your currently championed faction as your default faction."] = "Utiliser votre faction défendu que votre faction par défaut.",

	["Ignore Exalted factions"] = "Ignorer factions Exalté",
	["Don't watch factions with whom you have already attained Exalted reputation."] = "Ne pas regarder factions avec lesquelles vous avez déjà atteint debout Exalté.",

	["Announce watched faction"] = "Activer les notifications",
	["Show a message in the chat frame when your watched faction is changed."] = "Afficher un message dans le chat cadre lorsque vos modifications faction regardé.",
	["Now watching %s."] = "Maintenant regarder %s.",

} return end

--[[--------------------------------------------------------------------
	Italian | Italiano
	Last updated: 2012-07-10 by Phanx
----------------------------------------------------------------------]]

if LOCALE == "itIT" then Diplomancer.L = {

	["Default faction"] = "Fazione di default",
	["Select a faction to watch when your current location doesn't have an associated faction."] = "Seleziona una fazione per vedere se la posizione attuale non è una fazione associato.",

	["Reset"] = "Reimposta",
	["Reset your default faction preference to your race's faction."] = "Reimposta la tua preferenza fazione predefinito per la fazione di tua razza.",

	["Default to championed faction"] = "Usa fazione sponsorizzato",
	["Use your currently championed faction as your default faction."] = "Usa la tua fazione attualmente sponsorizzato la sua fazione di default.",

	["Ignore Exalted factions"] = "Ignora fazioni Osannato",
	["Don't watch factions with whom you have already attained Exalted reputation."] = "Non seguire le fazioni con cui avete raggiunto la reputazione Osannato.",

	["Announce watched faction"] = "Avvisi fazione seguirono",
	["Show a message in the chat frame when your watched faction is changed."] = "Mostra un messaggio nella finestra di chat quando la fazione seguita è cambiato.",
	["Now watching %s."] = "Ora seguendo %s.",

} return end

--[[--------------------------------------------------------------------
	Portuguese | Português
	Last updated: 2011-10-19 by Phanx
----------------------------------------------------------------------]]

if LOCALE == "ptBR" then Diplomancer.L = {

	["Default faction"] = "Facção padrão",
	["Select a faction to watch when your current location doesn't have an associated faction."] = "Selecione uma facção a seguir ao da sua localização actual não tem uma facção associados.",

	["Reset"] = "Restabelecer",
	["Reset your default faction preference to your race's faction."] = "Restabeleça a sua preferência de facção padrão para a sua facção raça.",

	["Default to championed faction"] = "Use facção patrocinado",
	["Use your currently championed faction as your default faction."] = "Use sua facção atualmente patrocinada como sua facção padrão.",

	["Ignore Exalted factions"] = "Ignore facções Exaltado",
	["Don't watch factions with whom you have already attained Exalted reputation."] = "Não siga as facções com quem você já alcançaram reputação Exaltado.",

	["Announce watched faction"] = "Anunciar facção seguido",
	["Show a message in the chat frame when your watched faction is changed."] = "Mostrar uma mensagem no quadro de bate-papo quando sua facção seguido é alterado.",
	["Now watching %s."] = "Agora seguintes %s.",

} return end

--[[--------------------------------------------------------------------
	Russian | Русский
	Last updated: 2011-03-15 by Akkorian
----------------------------------------------------------------------]]

if LOCALE == "ruRU" then Diplomancer.L = {

	["Default faction"] = "Стандартные фракция",
	["Select a faction to watch when your current location doesn't have an associated faction."] = "Выберите фракции следить за выполнением фракция, когда ни одна фракция связана с вашего текущего местоположения.",

	["Reset"] = "Сброс",
	["Reset your default faction preference to your race's faction."] = "Сброс стандартных фракции в фракцию вашей расы.",

	["Default to championed faction"] = "Отстаивал фракции",
	["Use your currently championed faction as your default faction."] = "Следуйте за выполнением вашей отстаивала фракция по умолчанию.",

	["Ignore Exalted factions"] = "Нет Превознесение фракций",
	["Don't watch factions with whom you have already attained Exalted reputation."] = "Не следить за выполнением фракциями, с которыми вы уже достигли Превознесение стоя.",

	["Announce watched faction"] = "Уведомлять на изменения",
	["Show a message in the chat frame when your watched faction is changed."] = "Уведомлять, когда вы будете следить за выполнением фракции.",
	["Now watching %s."] = "Теперь следующие за выполнением %s.",

} return end

--[[--------------------------------------------------------------------
	Korean | 한국어
	Last updated: 2011-03-03 by talkswind @ CurseForge
----------------------------------------------------------------------]]

if LOCALE == "koKR" then Diplomancer.L = {

	["Default faction"] = "기본 진영",
	["Select a faction to watch when your current location doesn't have an associated faction."] = "현재 위치가 관련된 진영이 없는 경우에 감시할 진영을 선택합니다.",

	["Default to championed faction"] = "옹호하고 있는 진영을 기본 진영으로",
	["Use your currently championed faction as your default faction."] = "현재 옹호하고 있는 진영을 기본 진영으로 사용합니다.",

	["Reset"] = "초기화",
	["Reset your default faction preference to your race's faction."] = "기본 선호 진영을 종족의 진영으로 초기화합니다. ",

	["Ignore Exalted factions"] = "확고한 동맹 진영 무시",
	["Don't watch factions with whom you have already attained Exalted reputation."] = "확고한 동맹 평판을 이미 달성한 진영은 감시하지 않습니다. ",

	["Announce watched faction"] = "감시 중인 진영 알림",
	["Show a message in the chat frame when your watched faction is changed."] = "감시 중인 진영이 변경된 경우에 대화창에 메시지를 보여줍니다.",
	["Now watching %s."] = "%s|1을;를; 지금 감시 중에 있습니다.",

} return end

--[[--------------------------------------------------------------------
	Simplified Chinese | 简体中文
	Last updated: 2010-08-05 by VENSTER
	Previous contributors: 急云@CWDG
----------------------------------------------------------------------]]

if LOCALE == "zhCN" then Diplomancer.L = {

	["Default faction"] = "缺省声望",
	["Select a faction to watch when your current location doesn't have an associated faction."] = "当目前所在区域没有对应声望时，选择监视的声望",

	["Reset"] = "重置",
	["Reset your default faction preference to your race's faction."] = "将你的缺省声望重置为种族声望",

--	["Default to championed faction"] = "",
--	["Use your currently championed faction as your default faction."] = "",

	["Ignore Exalted factions"] = "忽略已崇拜的声望",
	["Don't watch factions with whom you have already attained Exalted reputation."] = "选择是否忽略监视已经崇拜的声望",

	["Announce watched faction"] = "开启提示",
	["Show a message in the chat frame when your watched faction is changed."] = "选择是否显示声望监视状态变动",
--	["Now watching %s."] = "",

} return end

--[[--------------------------------------------------------------------
	Traditional Chinese | 正體中文
	Last updated: 2010-01-23 by 急云@CWDG
----------------------------------------------------------------------]]

if LOCALE == "zhTW" then Diplomancer.L = {

	["Default faction"] = "缺省聲望",
	["Select a faction to watch when your current location doesn't have an associated faction."] = "當目前所在區域沒有對應聲望時，選擇監視的聲望",

	["Reset"] = "重置",
	["Reset your default faction preference to your race's faction."] = "將你的缺省聲望重置為種族聲望",

--	["Default to championed faction"] = "",
--	["Use your currently championed faction as your default faction."] = "",

	["Ignore Exalted factions"] = "忽略已崇拜的聲望",
	["Don't watch factions with whom you have already attained Exalted reputation."] = "選擇是否忽略監視已經崇拜的聲望",

	["Announce watched faction"] = "開啟提示",
	["Show a message in the chat frame when your watched faction is changed."] = "選擇是否顯示聲望監視狀態變動",
--	["Now watching %s."] = "",

} return end