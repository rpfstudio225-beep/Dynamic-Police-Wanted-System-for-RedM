Config = Config or {}   -- <--- FIX 1: Schutz, damit Config nie überschrieben wird

local function DrawWantedText(text)
    SetTextScale(0.5, 0.5)
    SetTextFontForCurrentCommand(6)
    SetTextCentre(true)
    SetTextDropshadow(1, 1, 1, 0, 255)

    local vt = CreateVarString(10, "LITERAL_STRING", text)
    DisplayText(vt, 0.50, 0.06)
end

-- HUD Jail Timer
Citizen.CreateThread(function()
    while true do
        Wait(0)    
        if jailEnd then
            local rem = math.floor((jailEnd - GetGameTimer())/1000)
            if rem>0 then
                DrawWantedText("~w~You must be free in: "..rem.." s")
                TriggerEvent("vorp:NotifyTop",  "~e~Jailed for long time")
                DoScreenFadeIn(1000)
                IsScreenFadedIn()
                DisplayRadar(true)
            end
        end
    end
end)

function ScreenFade()
    DoScreenFadeOut(1000)
    repeat Wait(0) until IsScreenFadedOut()
    DisplayRadar(false)
end
---------------------------------------------------------------------
-- client/main.lua – Kill-Trigger, Waves, Lasso-Arrest, Manhunt
---------------------------------------------------------------------

local activePolice = {}
local policeBlips = {}

local activeHorses = {}
local horseOfPed = {}
local horseDespawnTimers = {}

local EventActive = false
local EventCooldown = false
local ManhuntActive = false
local CurrentWave = 0

local CurrentCityKey = nil
local CurrentCityConfig = nil
local JailCityConfig = nil

local WantedLevel = 0
local WantedTimer = 0
local WantedBlip = nil
local WantedText = ""

local ArrestHandled = false
local LowHealthJailTriggered = false

---------------------------------------------------------------------
-- DEBUG
---------------------------------------------------------------------
local function Debug(...)
    if Config.Debug then
        print("^3[Police]^0", ...)
    end
end

---------------------------------------------------------------------
-- CITY HELPER
---------------------------------------------------------------------
local function ResetCity()
    CurrentCityKey = nil
    CurrentCityConfig = nil
end

local function GetCityForCoords(coords)
    for key, city in pairs(Config.Cities) do
        if city.ZoneCenter and city.ZoneRadius then
            local dist = #(coords - city.ZoneCenter)
            if dist <= city.ZoneRadius then
                return key, city
            end
        end
    end
    return nil, nil
end

---------------------------------------------------------------------
-- WANTED HUD
---------------------------------------------------------------------
local function DrawWantedText(text)
    SetTextScale(0.6, 0.6)
    SetTextColor(255, 40, 40, 220)
    SetTextFontForCurrentCommand(0)
    SetTextCentre(true)
    SetTextDropshadow(2, 0, 0, 0, 255)

    local vt = CreateVarString(10, "LITERAL_STRING", text)
    DisplayText(vt, 0.50, 0.05)
end

Citizen.CreateThread(function()
    while true do
        Wait(10000)
        if Config.UseWanted and WantedLevel > 5 and WantedText ~= "" then
        end
    end
end)

local function UpdateSheriffBlip()
    if WantedBlip and DoesBlipExist(WantedBlip) then
        RemoveBlip(WantedBlip)
        WantedBlip = nil
    end

    if WantedLevel <= 0 then
        WantedText = ""
        return
    end

    local style = "BLIP_STYLE_LAW_UNALERTED"
    if WantedLevel == 2 then style = "BLIP_STYLE_LAW_ALERTED" end
    if WantedLevel >= 3 then style = "BLIP_STYLE_LAW_SEARCH" end

    WantedBlip = Citizen.InvokeNative(
        0x23F74C2FDA6E7C61,
        GetHashKey(style),
        PlayerPedId()
    )
    SetBlipScale(WantedBlip, 0.8)

end

local function SetWantedLevel(level)
    if not Config.UseWanted then return end

    level = math.max(0, math.min(5, level))
    WantedLevel = level
    WantedTimer = GetGameTimer()

    WantedText = Config.WantedTexts[level] or ""
    UpdateSheriffBlip()
end

---------------------------------------------------------------------
-- SPAWN HELPERS
---------------------------------------------------------------------
local function SpawnPed(model, coords, heading)
    local hash = GetHashKey(model)

    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(10)
    end

    local ped = Citizen.InvokeNative(
        0xD49F9B0955C367DE,
        hash,
        coords.x, coords.y, coords.z,
        heading,
        true, false, false, false
    )

    Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
    return ped
end

local function CleanupPolice(rem)
    Debug("CLEANUP Polizei & Pferde")

    for _, ped in ipairs(activePolice) do
        local blip = policeBlips[ped]
        if blip and DoesBlipExist(blip) then RemoveBlip(blip) end
        if DoesEntityExist(ped) then DeleteEntity(ped) end
    end

    for _, horse in ipairs(activeHorses) do
        if DoesEntityExist(horse) then DeleteEntity(horse) end
    end

    activePolice = {}
    policeBlips = {}
    activeHorses = {}
    horseOfPed = {}
    horseDespawnTimers = {}
end

---------------------------------------------------------------------
-- EVENT ENDE
---------------------------------------------------------------------
local function EndPoliceEvent()
    Debug("Event endet ? Cooldown")

    CleanupPolice()
    EventActive = false
    ManhuntActive = false
    CurrentWave = 0
    ArrestHandled = false
    LowHealthJailTriggered = false
    jailEnd = nil
    SetWantedLevel(0)
    ResetCity()
    JailCityConfig = nil

    EventCooldown = true

    Citizen.CreateThread(function()
        Wait(30000)
        EventCooldown = false
        Debug("Cooldown vorbei, Event wieder möglich")
    end)
end

---------------------------------------------------------------------
-- START WELLE
---------------------------------------------------------------------
local function StartPoliceEvent(cityKey, city)

    if EventActive or ManhuntActive or EventCooldown then return end
    if not cityKey or not city then return end

    CurrentCityKey = cityKey
    CurrentCityConfig = city
    JailCityConfig = city
    LowHealthJailTriggered = false

    Debug("Starte Polizeievent in Stadt: " .. (city.Name or cityKey) .. " ? Welle 1")

    EventActive = true
    ManhuntActive = false
    CurrentWave = 1
    ArrestHandled = false

    SetWantedLevel(1)
    local p = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("police:spawn_units", CurrentCityKey, CurrentWave, p)

    TriggerEvent("bln_notify:send", {
    title = "~#3c9ce6~You are wanted by the Sheriff!~e~",
    description = (WantedText),
    icon = "warning",
    placement = "middle-left",
    duration = 10000,
    progress = {
    enabled = true,
    type = 'circle',
    color = '#ffcc00'
    },
    keyActions = {
    ['E'] = "accept",
    ['F6'] = "decline"
    }
    })
end

local function StartNextWave()

    if not EventActive or not CurrentCityConfig then return end

    local maxWaves = CurrentCityConfig.MaxWaves or 5
    if CurrentWave >= maxWaves then
        Debug("Letzte Welle erledigt ? EVENT ENDE")
        EndPoliceEvent()
        return
    end

    CurrentWave = CurrentWave + 1
    Debug("Starte Welle " .. CurrentWave)

    local delay = CurrentCityConfig.DelayBetweenWaves or 1500

    Citizen.CreateThread(function()
        Wait(delay)
        if EventActive and not ManhuntActive and CurrentCityKey then
            TriggerServerEvent("police:spawn_units", CurrentCityKey, CurrentWave)
        end
    end)

    TriggerEvent("bln_notify:send", {
    title = "~#f73434~You are must wanted!~e~",
    description = (WantedText),
    icon = "warning",
    placement = "middle-left",
    duration = 10000,
    progress = {
    enabled = true,
    type = 'circle',
    color = '#ffcc00'
    },
    keyActions = {
    ['E'] = "accept",
    ['F6'] = "decline"
    }
    })
end

---------------------------------------------------------------------
-- START MANHUNT
---------------------------------------------------------------------
local function StartManhunt()

    TriggerEvent("bln_notify:send", {
    title = "~#f73434~You are wanted by the Marchal!~e~",
    description = (WantedText),
    icon = "cross",
    placement = "middle-left",
    duration = 10000,
    progress = {
        enabled = true,
        type = 'circle',
        color = '#ffcc00'
    },
    keyActions = {
        ['E'] = "accept",
        ['F6'] = "decline"
    }
    })

    if ManhuntActive or not CurrentCityConfig or not CurrentCityKey then return end

    Debug("MANHUNT startet in Stadt: " .. (CurrentCityConfig.Name or CurrentCityKey))

    ManhuntActive = true
    EventActive = false

    SetWantedLevel(5)
    CleanupPolice()

    for i = 1, (CurrentCityConfig.ManhuntNPCCount or 5) do
        local p = GetEntityCoords(PlayerPedId())
        TriggerServerEvent("police:spawn_manhunt_unit", CurrentCityKey, p)
    end
end

---------------------------------------------------------------------
-- TOTEN-PRÜFUNG
---------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(1000)

        if (#activePolice > 0) and (EventActive or ManhuntActive) then
            local allDead = true

            for _, ped in ipairs(activePolice) do
                if DoesEntityExist(ped) and not IsEntityDead(ped) then
                    allDead = false
                end
            end

            if allDead then
                if ManhuntActive then
                    Debug("Alle Reiter tot ? EVENT ENDE")
                    EndPoliceEvent()
                elseif EventActive then
                    StartNextWave()
                end
            end
        end
    end
end)

---------------------------------------------------------------------
-- SPIELER TOD
---------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(300)
        local ply = PlayerPedId()

        if (EventActive or ManhuntActive) and IsEntityDead(ply) then
            if EventActive and CurrentWave == 1 then
                Debug("Spieler tot in Welle 1 ? EVENT ENDE")
                EndPoliceEvent()
            else
                Debug("Spieler tot (Fallback außerhalb Welle 1) ? EVENT ENDE")
                EndPoliceEvent()
            end
        end
    end
end)

---------------------------------------------------------------------
-- LOW-HEALTH JAIL
---------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(2000)

        if not (EventActive or ManhuntActive) then
            goto continue
        end

        local player = PlayerPedId()
        if not player or player == 0 or not DoesEntityExist(player) then
            goto continue
        end

        local inJailMode = false
        if ManhuntActive then
            inJailMode = true
        elseif EventActive and CurrentWave and CurrentWave >= 2 then
            inJailMode = true
        end

        if not inJailMode then
            goto continue
        end

        if LowHealthJailTriggered then
            goto continue
        end

        local hp = GetEntityHealth(player)
        local maxHp = GetEntityMaxHealth(player)
        if maxHp <= 0 then
            goto continue
        end

        local pct = hp / maxHp

        -- FIX 2 – Threshold immer gültig  
        local threshold = tonumber(Config.LowHealthThreshold) or 0.18

        if pct <= threshold then
            LowHealthJailTriggered = true

            if not IsEntityDead(player) then
                local safeHp = math.floor(maxHp * (threshold + 0.05))
                if safeHp < 1 then safeHp = 1 end
                SetEntityHealth(player, safeHp)
            end

            local city = JailCityConfig or CurrentCityConfig

            local jailSeconds = 0
            if ManhuntActive then
                jailSeconds = (Config.JailTimes and Config.JailTimes.ManhuntJail)
                    or (Config.JailTimeSeconds)
                    or 480
            else
                jailSeconds = (Config.JailTimes and Config.JailTimes.Wave2PlusJail)
                    or (Config.JailTimeSeconds)
                    or 360
            end

            Debug(string.format("Low HP (%.2f) ? Jail für %d Sekunden", pct, jailSeconds))

            local jail = city and city.JailCoords or vector4(-271.67, 807.16, 119.37, 33.04)
            local rel = city and city.JailReleaseCoords or vector4(-275.96, 808.79, 119.38, 205.24)

            CleanupPolice()

            ScreenFade()
            Wait(4000)
            ClearPedTasksImmediately(player)
            SetEntityCoords(player, jail.x, jail.y, jail.z)
            SetEntityHeading(player, jail.w)

            local endT = GetGameTimer() + jailSeconds * 1000
            jailEnd = endT

            while GetGameTimer() < endT do
                Wait(400)
            end

            ClearPedTasksImmediately(player)
            SetEntityCoords(player, rel.x, rel.y, rel.z)
            SetEntityHeading(player, rel.w)

            Debug("Jail durch Low HP vorbei ? Spieler freigelassen & Event beendet")
            EndPoliceEvent()
        end

        ::continue::
    end
end)

---------------------------------------------------------------------
-- SPIELER FLIEHT ? MANHUNT
---------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(1000)

        if EventActive and not ManhuntActive and CurrentCityConfig and CurrentCityConfig.ZoneCenter then
            local dist = #(GetEntityCoords(PlayerPedId()) - CurrentCityConfig.ZoneCenter)
            local trig = CurrentCityConfig.ManhuntTriggerDistance or 80.0
            if dist > trig then
                Debug("Spieler flieht aus Zone ? MANHUNT")
                StartManhunt()
            end
        end
    end
end)

---------------------------------------------------------------------
-- WANTED SINKT
---------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(1000)

        if Config.UseWanted and WantedLevel > 0 then
            local seen = false

            for _, ped in ipairs(activePolice) do
                if DoesEntityExist(ped)
                and not IsEntityDead(ped)
                and HasEntityClearLosToEntity(ped, PlayerPedId(), 17)
                then
                    seen = true
                end
            end

            if seen then
                WantedTimer = GetGameTimer()
            else
                local dropTime = (Config.WantedDropTime or 60) * 1000
                if GetGameTimer() - WantedTimer > dropTime then
                    SetWantedLevel(WantedLevel - 1)
                end
            end
        end
    end
end)

---------------------------------------------------------------------
-- CLIENT-SPAWN DER WAVES
---------------------------------------------------------------------
RegisterNetEvent("police:spawn_unit_client")
AddEventHandler("police:spawn_unit_client", function(cityKey, model, spawn, wave)
                    
    local city = Config.Cities[cityKey]
    if not city then return end

    local ped = SpawnPed(
        model,
        vector3(spawn.x, spawn.y, spawn.z + 1.0),
        spawn.w
    )

    table.insert(activePolice, ped)

    local style = city.EnemyBlipStyle or "BLIP_STYLE_ENEMY"
    local scale = city.EnemyBlipScale or 0.25

    local blip = Citizen.InvokeNative(
        0x23F74C2FDA6E7C61,
        GetHashKey(style),
        ped
    )
    SetBlipScale(blip, scale)
    policeBlips[ped] = blip

    AddRelationshipGroup("POLICE_AI")
    SetPedRelationshipGroupHash(ped, GetHashKey("POLICE_AI"))
    SetRelationshipBetweenGroups(5, "POLICE_AI", "PLAYER")
    SetRelationshipBetweenGroups(5, "PLAYER", "POLICE_AI")

    SetPedKeepTask(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    RemoveAllPedWeapons(ped)

    -------------------------------------------------
    -- WELLE 1 ? Festnahme mit einfachem TACKLE
    -------------------------------------------------
    if wave == 1 and city.UseLassoInWave1 then
        -- Welle 1: keine Waffen, nur Verfolgung + Tackling + Jail
        SetPedCombatMovement(ped, 0)
        SetPedCombatRange(ped, 0)
        SetPedAccuracy(ped, 0)

        Citizen.CreateThread(function()
            local hasGoTask = false
            local tackled   = false

            Debug("Welle 1: Tackle-Thread gestartet")

            while DoesEntityExist(ped)
            and not IsEntityDead(ped)
            and EventActive
            and CurrentWave == 1 do

                local player = PlayerPedId()
                local pC = GetEntityCoords(player)
                local eC = GetEntityCoords(ped)
                local dist = #(eC - pC)

                local startRunDist = 3.0   -- ab hier rennt er los
                local tackleDist   = 2.0   -- ab hier wird getackelt

                if not tackled then
                    -- NPC bekommt EIN Follow-Task und behält den
                    if dist > tackleDist then
                        if not hasGoTask then
                            ClearPedTasks(ped)
                            TaskGoToEntity(ped, player, -1, 1.5, 2.4, 0, 0)
                            hasGoTask = true
                            Debug("Welle 1: NPC verfolgt Spieler (dist=" .. string.format("%.2f", dist) .. ")")
                        end
                    else
                        -------------------------------------------------
                        -- TACKLE + Spieler fällt um
                        -------------------------------------------------
                        tackled = true
                        hasGoTask = false

                        Debug("Welle 1: NPC tackelt Spieler")

                        ClearPedTasks(ped)

                        -- Anim versuchen zu laden, aber wenn sie fehlt,
                        -- funktioniert der Arrest trotzdem
                        local dict = "melee@grapple@streamed_core"
                        RequestAnimDict(dict)
                        local waitT = GetGameTimer() + 1000
                        while not HasAnimDictLoaded(dict) and GetGameTimer() < waitT do
                            Wait(10)
                        end

                        if HasAnimDictLoaded(dict) then
                            TaskPlayAnim(
                                ped,
                                dict,
                                "grapple_attempt_a",
                                4.0, -4.0, 900,
                                0, 0.0, false, 0, false
                            )
                        end

                        -- Spieler stolpert / fällt
                        SetPedToRagdoll(player, 1500, 2000, 0, false, false, false)

                        Wait(1100)

                        -------------------------------------------------
                        -- Jail nach Tackle
                        -------------------------------------------------
                        local jail = city.JailCoords or vector4(-271.67, 807.16, 119.37, 33.04)

                        ScreenFade()
                        Wait(4000)

                        CleanupPolice()
                        ClearPedTasksImmediately(player)

                        SetEntityCoords(player, jail.x, jail.y, jail.z)
                        SetEntityHeading(player, jail.w)

                        Debug("Welle 1: Spieler nach Tackle ins Jail teleportiert")

                        EventActive   = false
                        ManhuntActive = false

                        Citizen.CreateThread(function()
                            local jailSeconds = (Config.JailTimes and Config.JailTimes.Wave1Arrest)
                                or (Config.JailTimeSeconds)
                                or 300

                            local endT = GetGameTimer() + jailSeconds * 1000
                            jailEnd = endT

                            while GetGameTimer() < endT do
                                Wait(400)
                            end

                            local r = city.JailReleaseCoords or vector4(-275.96, 808.79, 119.38, 205.24)
                            SetEntityCoords(player, r.x, r.y, r.z)
                            SetEntityHeading(player, r.w)

                            Debug("Welle 1: Haftende (Tackle) ? Event beendet")
                            EndPoliceEvent()
                        end)

                        return
                    end
                end

                Wait(200)
            end
        end)

    else
        -------------------------------------------------
        -- WELLE 2+  (UNVERÄNDERT)
        -------------------------------------------------
        local accBoost = (wave - 1) * 5
        local baseAcc = city.PedAccuracy or 60
        local accuracy = math.min(100, baseAcc + accBoost)

        GiveWeaponToPed(
            ped,
            city.PedWeapon or `WEAPON_REVOLVER_CATTLEMAN`,
            city.WeaponAmmo or 200,
            true,
            true
        )

        SetPedCombatMovement(ped, city.PedCombatMovement or 2)
        SetPedCombatRange(ped, city.PedCombatRange or 2)
        SetPedCombatAbility(ped, city.PedCombatAbility or 2)
        SetPedAccuracy(ped, accuracy)

        Citizen.CreateThread(function()
            while DoesEntityExist(ped) do
                if IsEntityDead(ped) then return end
                TaskCombatPed(ped, PlayerPedId(), 0, 16)
                Wait(800)
            end
        end)
    end
end)

---------------------------------------------------------------------
-- MANHUNT REITER
---------------------------------------------------------------------
RegisterNetEvent("police:spawn_manhunt_unit_client")
AddEventHandler("police:spawn_manhunt_unit_client", function(cityKey, model, horseModel, spawn)

    local city = Config.Cities[cityKey]
    if not city then return end

    local horse = SpawnPed(
        horseModel or city.ManhuntHorse or "a_c_horse_americanstandardbred_black",
        vector3(spawn.x, spawn.y, spawn.z),
        spawn.w
    )
    Citizen.InvokeNative(0x283978A15512B2FE, horse, true)
    Wait(400)
    table.insert(activeHorses, horse)

    local ped = SpawnPed(
        model,
        vector3(spawn.x, spawn.y, spawn.z + 1.0),
        spawn.w
    )
    Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
    Wait(200)

    Citizen.InvokeNative(0x028F76B6E78246EB, ped, horse, -1, true)
    TaskMountAnimal(ped, horse, -1, -1, 2.0, 1, 0, 0)

    table.insert(activePolice, ped)
    horseOfPed[ped] = horse

    local style = city.EnemyBlipStyle or "BLIP_STYLE_ENEMY"
    local scale = city.EnemyBlipScale or 0.25

    local blip = Citizen.InvokeNative(
        0x23F74C2FDA6E7C61,
        GetHashKey(style),
        ped
    )
    SetBlipScale(blip, scale)
    policeBlips[ped] = blip

    GiveWeaponToPed(ped, city.PedWeapon or `WEAPON_REVOLVER_CATTLEMAN`, city.WeaponAmmo or 200, true, true)

    AddRelationshipGroup("POLICE_AI")
    SetPedRelationshipGroupHash(ped, GetHashKey("POLICE_AI"))
    SetRelationshipBetweenGroups(5,"POLICE_AI","PLAYER")
    SetRelationshipBetweenGroups(5,"PLAYER","POLICE_AI")

    SetPedCombatMovement(ped, city.PedCombatMovement or 2)
    SetPedCombatRange(ped, city.PedCombatRange or 2)
    SetPedCombatAbility(ped, city.PedCombatAbility or 2)
    SetPedAccuracy(ped, city.PedAccuracy or 80)
    SetPedKeepTask(ped,true)
    SetBlockingOfNonTemporaryEvents(ped,true)

    Citizen.CreateThread(function()
        while DoesEntityExist(ped) do
            if IsEntityDead(ped) then
                local horse = horseOfPed[ped]
                if horse and DoesEntityExist(horse) then
                    TaskSmartFleePed(horse, PlayerPedId(), 200.0, -1, 0, 3.0)
                    local despawnAfter = 20000 + math.random(5000)
                    horseDespawnTimers[horse] = true
                    Citizen.CreateThread(function()
                        Wait(despawnAfter)
                        if horseDespawnTimers[horse] then
                            if DoesEntityExist(horse) then
                                DeleteEntity(horse)
                            end
                            horseDespawnTimers[horse] = nil
                        end
                    end)
                end
                return
            end

            TaskCombatPed(ped, PlayerPedId(), 0, 16)
            Wait(800)
        end
    end)
end)

---------------------------------------------------------------------
-- NPC-KILL-TRIGGER
---------------------------------------------------------------------
local handledDeadPeds = {}
local AllowedCitiesForKillTrigger = {
    valentine = true,
    rhodes    = true,
    saintdenis = true,
    annesburg  = true,
}

Citizen.CreateThread(function()
    Wait(8000)

    while true do
        Wait(800)

        if EventActive or ManhuntActive or EventCooldown then
            goto continue
        end

        local player = PlayerPedId()
        if not player or player == 0 or not DoesEntityExist(player) then
            goto continue
        end

        local pCoords = GetEntityCoords(player)
        local cityKey, city = GetCityForCoords(pCoords)
        if not (cityKey and AllowedCitiesForKillTrigger[cityKey]) then
            goto continue
        end

        local handle, ped = FindFirstPed()
        local success

        if handle ~= -1 then
            repeat
                if DoesEntityExist(ped)
                and not IsPedAPlayer(ped)
                and IsPedHuman(ped)
                and IsEntityDead(ped)
                and not handledDeadPeds[ped]
                then
                    handledDeadPeds[ped] = true

                    local killer = GetPedSourceOfDeath(ped)
                    local cause  = GetPedCauseOfDeath(ped)

                    if not killer or killer == 0 or not DoesEntityExist(killer) then goto continue_ped end
                    if cause == 0 then goto continue_ped end
                    if killer ~= player then goto continue_ped end
                    if cause == `WEAPON_UNARMED` then goto continue_ped end

                    Debug("NPC durch Spieler getötet ? starte Polizeievent in Stadt: " .. cityKey)
                    StartPoliceEvent(cityKey, city)
                end

                ::continue_ped::
                success, ped = FindNextPed(handle)
            until not success

            EndFindPed(handle)
        end

        ::continue::
    end
end)

---------------------------------------------------------------------
-- LASSO-ARREST (DEAKTIVIERT)
---------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(1000)
    end
end)
