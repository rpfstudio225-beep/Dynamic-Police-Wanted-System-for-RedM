-- server main (three-point spawn: 50/30/20)

local function Debug(...)
    if Config and Config.Debug then
        print("^3[Police-Server]^0", ...)
    end
end

-- Helper: sort spawnpoints by distance to player
local function GetSortedSpawns(list, playerCoords)
    if not playerCoords then return nil end
    local sorted = {}
    for _, sp in ipairs(list) do
        local d = #(vector3(sp.x, sp.y, sp.z) - playerCoords)
        sorted[#sorted + 1] = { spawn = sp, dist = d }
    end
    table.sort(sorted, function(a, b)
        return a.dist < b.dist
    end)
    return sorted
end

-- Wellen (zu Fuß)
RegisterNetEvent("police:spawn_units")
AddEventHandler("police:spawn_units", function(cityKey, wave, playerCoords)
    local src = source
    local city = Config.Cities[cityKey]
    if not city then return end

    local list = city["SpawnPointsWave" .. tostring(wave)]
    if not list or #list == 0 then
        Debug(("Keine SpawnPoints für Stadt %s / Welle %s gefunden"):format(cityKey, tostring(wave)))
        return
    end

    -- Anzahl NPCs über Config steuerbar
    local npcCount
    if city.WaveReinforcements and city.WaveReinforcements[wave] then
        npcCount = city.WaveReinforcements[wave]
    else
        local minN = city.MinNPCPerWave or 3
        local maxN = city.MaxNPCPerWave or 5
        if maxN < minN then maxN = minN end
        npcCount = math.random(minN, maxN)
    end

    -- Wenn wir Spielerkoordinaten haben, nutzen wir 3 Spawnpunkte (50/30/20)
    if playerCoords then
        local sorted = GetSortedSpawns(list, playerCoords)
        if sorted and #sorted > 0 then
            local sp1 = sorted[1].spawn
            local sp2 = (#sorted >= 2 and sorted[2].spawn) or sp1
            local sp3 = (#sorted >= 3 and sorted[3].spawn) or sp2

            -- Verteilung: 50% / 30% / 20%
            local n1 = math.floor(npcCount * 0.5)
            local n2 = math.floor(npcCount * 0.3)
            local n3 = npcCount - n1 - n2

            local function spawnAt(spawn, count)
                for i = 1, count do
                    local model
                    if city.PoliceModels and #city.PoliceModels > 0 then
                        model = city.PoliceModels[math.random(1, #city.PoliceModels)]
                    else
                        model = "cs_sheriffowens"
                    end
                    TriggerClientEvent("police:spawn_unit_client", src, cityKey, model, spawn, wave)
                end
            end

            if n1 > 0 then spawnAt(sp1, n1) end
            if n2 > 0 then spawnAt(sp2, n2) end
            if n3 > 0 then spawnAt(sp3, n3) end

            return
        end
    end

    -- Fallback: kein playerCoords oder Sortierung fehlgeschlagen -> alter Random-Spawn
    for i = 1, npcCount do
        local spawn = list[math.random(1, #list)]
        local model
        if city.PoliceModels and #city.PoliceModels > 0 then
            model = city.PoliceModels[math.random(1, #city.PoliceModels)]
        else
            model = "cs_sheriffowens"
        end
        TriggerClientEvent("police:spawn_unit_client", src, cityKey, model, spawn, wave)
    end
end)

-- Manhunt (Reiter)
RegisterNetEvent("police:spawn_manhunt_unit")
AddEventHandler("police:spawn_manhunt_unit", function(cityKey, playerCoords)
    local src = source
    local city = Config.Cities[cityKey]
    if not city then return end

    local list = city.SpawnPointsManhunt
    if not list or #list == 0 then
        Debug(("Keine Manhunt-SpawnPoints für Stadt %s gefunden"):format(cityKey))
        return
    end

    local spawn

    if playerCoords then
        local sorted = GetSortedSpawns(list, playerCoords)
        if sorted and #sorted > 0 then
            spawn = sorted[1].spawn
        end
    end

    if not spawn then
        spawn = list[math.random(1, #list)]
    end

    local model
    if city.ManhuntModels and #city.ManhuntModels > 0 then
        model = city.ManhuntModels[math.random(1, #city.ManhuntModels)]
    else
        model = "msp_gang3_males_01"
    end

    local horse = city.ManhuntHorse or "a_c_horse_americanstandardbred_black"

    TriggerClientEvent("police:spawn_manhunt_unit_client", src, cityKey, model, horse, spawn)
end)
