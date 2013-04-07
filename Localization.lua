--[[--------------------------------------------------------------------
	Diplomancer
	Automatically sets your watched faction based on your location.
	Copyright (c) 2007-2013 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info9643-Diplomancer.html
	http://www.curse.com/addons/wow/diplomancer
----------------------------------------------------------------------]]

local _, Diplomancer = ...

local L = {}
Diplomancer.L = L

local LOCALE = GetLocale()

L.DefaultFaction = "Default faction"
L.DefaultFaction_Desc = "Choose which faction to watch in areas without an associated faction."
L.Reset = "Reset"
L.Reset_Desc = "Reset your default faction to your racial faction."
L.DefaultToChampioned = "Default to championed faction"
L.DefaultToChampioned_Desc = "Use your currently championed faction as your default faction."
L.IgnoreExalted = "Ignore Exalted factions"
L.IgnoreExalted_Desc = "Don't watch factions with whom you've already reached Exalted standing."
L.Announce = "Announce watched faction"
L.Announce_Desc = "Show a message in your chat frame when Diplomancer changes your watched faction."
L.NowWatching = "Now watching %s."

--[[--------------------------------------------------------------------
	German
	Last updated 2013-03-16 by CanRanBan
	Previous contributors: paterbrown
----------------------------------------------------------------------]]

if LOCALE == "deDE" then
	L.Announce = "Schalte Benachrichtigungen ein"
	L.Announce_Desc = "Zeigt eine Meldung im Chatfenster, wenn sich die angezeigte Fraktion ändert."
	L.DefaultFaction = "Standardfraktion"
	L.DefaultFaction_Desc = "Wähle eine Standardfraktion, welche angezeigt wird, wenn dein Aufenthaltsort nicht mit einer Fraktion verknüpft ist."
	L.DefaultToChampioned = "Verwenden Tragtenfraktion"
	L.DefaultToChampioned_Desc = "Verwenden die Tragtenfraktion als deine Standardfraktion."
	L.IgnoreExalted = "Ignoriere ehrfürchtige Fraktionen"
	L.IgnoreExalted_Desc = "Zeigt Fraktionen mit ehrfürchtigem Ruf nicht mehr an."
	L.NowWatching = "Angezeigte %s."
	L.Reset = "Reset"
	L.Reset_Desc = "Zurücksetzen der Standardfraktion auf deine Volksfraktion."
return end

--[[--------------------------------------------------------------------
	Spanish
	Last updated 2011-02-28 by Akkorian
----------------------------------------------------------------------]]

if LOCALE == "esES" or LOCALE == "esMX" then
	L.Announce = "Anunciar facción seguido"
	L.Announce_Desc = "Mostrar un mensaje en la ventana de chat cuando Diplomancer cambia tu facción seguido."
	L.DefaultFaction = "Facción predeterminado"
	L.DefaultFaction_Desc = "Seleccionar una facción para seguir en lugares sin facciones asociadas."
	L.DefaultToChampioned = "Utilizar facción abanderada"
	L.DefaultToChampioned_Desc = "Utilizar tu facción abanderada como tu facción predeterminado."
	L.IgnoreExalted = "Ignorar facciones Exaltados"
	L.IgnoreExalted_Desc = "No seguir las facciones con las que ya ha alcanzado el nivel de Exaltado."
	L.NowWatching = "Ahora siguiendo %s."
	L.Reset = "Restablecer"
	L.Reset_Desc = "Restablecer tu facción predeterminado al facción de tu raza."
return end

--[[--------------------------------------------------------------------
	French
	Last updated 2012-10-15 by L0relei
----------------------------------------------------------------------]]

if LOCALE == "frFR" then
	L.Announce = "Annoncer la faction surveillée"
	L.Announce_Desc = "Afficher un message dans la fenêtre de discussion lorsque la faction surveillée change."
	L.DefaultFaction = "Faction par défaut"
	L.DefaultFaction_Desc = "Sélectionnez une faction à surveiller si votre position actuelle n'a pas de faction associée."
	L.DefaultToChampioned = "Faction défendue par défaut"
	L.DefaultToChampioned_Desc = "Utiliser la faction actuellement défendue en tant que faction par défaut."
	L.IgnoreExalted = "Ignorer les factions Exalté"
	L.IgnoreExalted_Desc = "Ne pas surveiller les factions avec lesquelles vous êtes déjà Exalté."
	L.NowWatching = "Surveiller à présent %s."
	L.Reset = "RàZ"
	L.Reset_Desc = "Réinitialiser votre faction par défaut à la faction de votre race."
return end

--[[--------------------------------------------------------------------
	Italian
	Last updated 2012-07-10 by Phanx
----------------------------------------------------------------------]]

if LOCALE == "itIT" then
	L.Announce = "Avvisi fazione seguirono"
	L.Announce_Desc = "Mostra un messaggio nella finestra di chat quando la fazione seguita è cambiato."
	L.DefaultFaction = "Fazione di default"
	L.DefaultFaction_Desc = "Seleziona una fazione per vedere se la posizione attuale non è una fazione associato."
	L.DefaultToChampioned = "Usa fazione sponsorizzato"
	L.DefaultToChampioned_Desc = "Usa la tua fazione attualmente sponsorizzato la sua fazione di default."
	L.IgnoreExalted = "Ignora fazioni Osannato"
	L.IgnoreExalted_Desc = "Non seguire le fazioni con cui avete raggiunto la reputazione Osannato."
	L.NowWatching = "Ora seguendo %s."
	L.Reset = "Reimposta"
	L.Reset_Desc = "Reimposta la tua preferenza fazione predefinito per la fazione di tua razza."
return end

--[[--------------------------------------------------------------------
	Portuguese
	Last updated 2011-10-19 by Phanx
----------------------------------------------------------------------]]

if LOCALE == "ptBR" or LOCALE == "ptPT" then
	L.Announce = "Anunciar facção seguido"
	L.Announce_Desc = "Mostrar uma mensagem no quadro de bate-papo quando sua facção seguido é alterado."
	L.DefaultFaction = "Facção padrão"
	L.DefaultFaction_Desc = "Selecione uma facção a seguir ao da sua localização actual não tem uma facção associados."
	L.DefaultToChampioned = "Usar facção patrocinado"
	L.DefaultToChampioned_Desc = "Usar sua facção atualmente patrocinada como sua facção padrão."
	L.IgnoreExalted = "Ignorar facções Exaltado"
	L.IgnoreExalted_Desc = "Não siga as facções com quem você já alcançaram reputação Exaltado."
	L.NowWatching = "Agora seguintes %s."
	L.Reset = "Restabelecer"
	L.Reset_Desc = "Restabeleça a sua preferência de facção padrão para a sua facção raça."
return end

--[[--------------------------------------------------------------------
	Russian
	Last updated 2011-03-15 by Phanx
----------------------------------------------------------------------]]

if LOCALE == "ruRU" then
	L.Announce = "Уведомлять на изменения"
	L.Announce_Desc = "Уведомлять, когда вы будете следить за выполнением фракции."
	L.DefaultFaction = "Стандартные фракция"
	L.DefaultFaction_Desc = "Выберите фракции следить за выполнением фракция, когда ни одна фракция связана с вашего текущего местоположения."
	L.DefaultToChampioned = "Отстаивал фракции"
	L.DefaultToChampioned_Desc = "Следуйте за выполнением вашей отстаивала фракция по умолчанию."
	L.IgnoreExalted = "Нет Превознесение фракций"
	L.IgnoreExalted_Desc = "Не следить за выполнением фракциями, с которыми вы уже достигли Превознесение стоя."
	L.NowWatching = "Теперь следующие за выполнением %s."
	L.Reset = "Сброс"
	L.Reset_Desc = "Сброс стандартных фракции в фракцию вашей расы."
return end

--[[--------------------------------------------------------------------
	Korean
	Last updated: 2011-03-03 by talkswind
----------------------------------------------------------------------]]

if LOCALE == "koKR" then
	L.Announce = "감시 중인 진영 알림"
	L.Announce_Desc = "감시 중인 진영이 변경된 경우에 대화창에 메시지를 보여줍니다."
	L.DefaultFaction = "기본 진영"
	L.DefaultFaction_Desc = "현재 위치가 관련된 진영이 없는 경우에 감시할 진영을 선택합니다."
	L.DefaultToChampioned = "옹호하고 있는 진영을 기본 진영으로"
	L.DefaultToChampioned_Desc = "현재 옹호하고 있는 진영을 기본 진영으로 사용합니다."
	L.IgnoreExalted = "확고한 동맹 진영 무시"
	L.IgnoreExalted_Desc = "확고한 동맹 평판을 이미 달성한 진영은 감시하지 않습니다."
	L.NowWatching = "%s|1을;를; 지금 감시 중에 있습니다."
	L.Reset = "초기화"
	L.Reset_Desc = "기본 선호 진영을 종족의 진영으로 초기화합니다."
return end

--[[--------------------------------------------------------------------
	Simplified Chinese
	Last updated 2010-08-05 by VENSTER
	Previous contributors: 急云@CWDG
----------------------------------------------------------------------]]

if LOCALE == "zhCN" then
	L.Announce = "开启提示"
	L.Announce_Desc = "选择是否显示声望监视状态变动"
	L.DefaultFaction = "缺省声望"
	L.DefaultFaction_Desc = "当目前所在区域没有对应声望时，选择监视的声望"
--	L.DefaultToChampioned = "Default to championed faction"
--	L.DefaultToChampioned_Desc = "Use your currently championed faction as your default faction."
	L.IgnoreExalted = "忽略已崇拜的声望"
	L.IgnoreExalted_Desc = "选择是否忽略监视已经崇拜的声望"
--	L.NowWatching = "Now watching %s."
	L.Reset = "重置"
	L.Reset_Desc = "将你的缺省声望重置为种族声望"
return end

--[[--------------------------------------------------------------------
	Traditional Chinese
	Last updated 2010-01-23 by 急云@CWDG
----------------------------------------------------------------------]]

if LOCALE == "zhTW" then
	L.Announce = "開啟提示"
	L.Announce_Desc = "選擇是否顯示聲望監視狀態變動"
	L.DefaultFaction = "缺省聲望"
	L.DefaultFaction_Desc = "當目前所在區域沒有對應聲望時，選擇監視的聲望"
--	L.DefaultToChampioned = "Default to championed faction"
--	L.DefaultToChampioned_Desc = "Use your currently championed faction as your default faction."
	L.IgnoreExalted = "忽略已崇拜的聲望"
	L.IgnoreExalted_Desc = "選擇是否忽略監視已經崇拜的聲望"
--	L.NowWatching = "Now watching %s."
	L.Reset = "重置"
	L.Reset_Desc = "將你的缺省聲望重置為種族聲望"
return end