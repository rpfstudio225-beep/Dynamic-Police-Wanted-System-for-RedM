---------------------------------------------------------
-- POLICE CONFIG  NPC-Kill Trigger, Waves, Lasso, Manhunt
---------------------------------------------------------

Config = {}

Config.Debug = true                 -- Aktiviert Debug-Ausgaben in der Konsole (für Fehleranalyse)
--Config.Jail = true                 -- Aktiviert Debug-Ausgaben in der Konsole (für Fehleranalyse)
Config.UseWanted = true             -- Wanted-System ein-/ausschalten
Config.WantedDropTime = 40          -- Zeit (Sekunden), bis der Wanted-Level automatisch sinkt



-- Schwelle (0.0–1.0), ab der der Spieler in Welle 2+ / Manhunt ins Jail kommt
Config.LowHealthThreshold = 0.20

-- Jail-Zeiten in Sekunden
Config.JailTimes = {
    Wave1Arrest    = 4 * 60,  -- Lasso/Nahkampf-Arrest in Welle 1
    Wave2PlusJail  = 6 * 60,  -- Welle 2+ (Low HP)
    ManhuntJail    = 8 * 60,  -- Manhunt (Low HP)
}

Config.WantedTexts = {
    [1] = "~#FF6B68~YOU ARE THE WANTED LEVEL ~e~1 ",             -- Wanted-Stufe 1 Anzeige
    [2] = "~#FF6B68~YOU ARE THE WANTED LEVEL ~e~2 ",            -- Wanted-Stufe 2 Anzeige
    [3] = "~#FF6B68~YOU ARE THE WANTED LEVEL ~e~3 ",           -- Wanted-Stufe 3 Anzeige
    [4] = "~#FF6B68~YOU ARE THE WANTED LEVEL ~e~4 ",          -- Wanted-Stufe 4 Anzeige
    [5] = "~#FF6B68~YOU ARE THE MUST WANTED ~e~MANHUNT!", -- Höchste Stufe + Manhunt aktiviert
}

---------------------------------------------------------
-- STÄDTE
---------------------------------------------------------

Config.Cities = {

    valentine = {
        Name = "Valentine",          -- Anzeigename der Stadt

        ZoneCenter = vector3(-281.01, 719.24, 114.49), -- Mittelpunkt des Einsatzgebietes
        ZoneRadius = 200.0,          -- Radius (Meter), in dem der Wanted-Trigger aktiv ist
        ManhuntTriggerDistance = 180.0, -- Distanz, ab der Manhunt aktiviert wird

        UseLassoInWave1 = true,      -- Welle 1: NPCs benutzen nur Lasso

        JailCoords = vector4(-271.67, 807.16, 119.37, 33.04),  -- Gefängnis-Position (Teleport beim Arrest)
        JailReleaseCoords = vector4(-275.96, 808.79, 119.38, 205.24), -- Position beim Entlassen

        MaxWaves = 8,                -- Maximale Anzahl an Gegner-Wellen
        DelayBetweenWaves = 1000,    -- Zeit zwischen den Wellen (Millisekunden)

        MinNPCPerWave = 3,           -- Minimum NPCs pro Welle
        MaxNPCPerWave = 8,           -- Maximum NPCs pro Welle

        PedWeapon = `WEAPON_REVOLVER_CATTLEMAN`, -- Waffe der Gegner
        WeaponAmmo = 250,            -- Munition der NPCs

        PedAccuracy = 65,            -- Schussgenauigkeit (0100)
        PedCombatRange = 0,          -- Kampfverhalten (Distanz)
        PedCombatMovement = 3,       -- Bewegungsverhalten im Kampf
        PedCombatAbility = 2,        -- allgemeine Kampffähigkeit

        EnemyBlipStyle = "BLIP_STYLE_ENEMY", -- Stil der Radar-Markierung
        EnemyBlipScale = 0.25,       -- Größe des Blips

        PoliceModels = {             -- Polizeimodelle für normale Wellen
            "cs_sheriffowens",
            "cs_valsheriff",
            "cs_strsheriff_01",
        },

        ManhuntModels = {            -- Modelle für Manhunt-Einheiten
            "msp_gang3_males_01",
            "cs_mp_sherifffreeman",
            "cs_sherifffreeman",
        },

        ManhuntHorse = "a_c_horse_americanstandardbred_black", -- Pferd der Manhunt-Reiter
        WaveReinforcements = {
            [1] = 10,   -- Welle 1
            [2] = 4,   -- Welle 2
            [3] = 5,   -- Welle 3
            [4] = 6,   -- Welle 4
            [5] = 7,   -- Welle 5
            [6] = 8,   -- Welle 6
            [7] = 5,   -- Welle 7 (Manhunt)
            [8] = 6,   -- Welle 8 (Manhunt)
        },

        ManhuntNPCCount = 5,

        -- Spawnpunkte: der nächstgelegene zum Spieler wird genutzt
        SpawnPointsWave1 = {
            vector4(-239.63, 789.32, 120.15, 267.85),
            vector4(-297.79, 829.33, 119.94, 66.28),
            vector4(-337.28, 825.68, 117.38, 155.2),
            vector4(-365.4, 731.03, 116.19, 272.88),
            vector4(-341.36, 676.57, 116.18, 129.67),
            vector4(-258.61, 594.25, 109.67, 305.67),

            vector4(-142.71, 668.37, 115.33, 328.79),
            vector4(-178.32, 722.1, 119.77, 13.75),
            vector4(-199.29, 764.57, 120.1, 359.74),

        },

        SpawnPointsWave2 = {
            vector4(-239.63, 789.32, 120.15, 267.85),
            vector4(-297.79, 829.33, 119.94, 66.28),
            vector4(-337.28, 825.68, 117.38, 155.2),
            vector4(-365.4, 731.03, 116.19, 272.88),
            vector4(-341.36, 676.57, 116.18, 129.67),
            vector4(-258.61, 594.25, 109.67, 305.67),

            vector4(-142.71, 668.37, 115.33, 328.79),
            vector4(-178.32, 722.1, 119.77, 13.75),
            vector4(-199.29, 764.57, 120.1, 359.74),

        },

        SpawnPointsWave3 = {
            vector4(-239.63, 789.32, 120.15, 267.85),
            vector4(-297.79, 829.33, 119.94, 66.28),
            vector4(-337.28, 825.68, 117.38, 155.2),
            vector4(-365.4, 731.03, 116.19, 272.88),
            vector4(-341.36, 676.57, 116.18, 129.67),
            vector4(-258.61, 594.25, 109.67, 305.67),

            vector4(-142.71, 668.37, 115.33, 328.79),
            vector4(-178.32, 722.1, 119.77, 13.75),
            vector4(-199.29, 764.57, 120.1, 359.74),

        },

        SpawnPointsWave4 = {
            vector4(-239.63, 789.32, 120.15, 267.85),
            vector4(-297.79, 829.33, 119.94, 66.28),
            vector4(-337.28, 825.68, 117.38, 155.2),
            vector4(-365.4, 731.03, 116.19, 272.88),
            vector4(-341.36, 676.57, 116.18, 129.67),
            vector4(-258.61, 594.25, 109.67, 305.67),

            vector4(-142.71, 668.37, 115.33, 328.79),
            vector4(-178.32, 722.1, 119.77, 13.75),
            vector4(-199.29, 764.57, 120.1, 359.74),

        },

        SpawnPointsWave5 = {
            vector4(-239.63, 789.32, 120.15, 267.85),
            vector4(-297.79, 829.33, 119.94, 66.28),
            vector4(-337.28, 825.68, 117.38, 155.2),
            vector4(-365.4, 731.03, 116.19, 272.88),
            vector4(-341.36, 676.57, 116.18, 129.67),
            vector4(-258.61, 594.25, 109.67, 305.67),

            vector4(-142.71, 668.37, 115.33, 328.79),
            vector4(-178.32, 722.1, 119.77, 13.75),
            vector4(-199.29, 764.57, 120.1, 359.74),

        },

        SpawnPointsWave6 = {
            vector4(-239.63, 789.32, 120.15, 267.85),
            vector4(-297.79, 829.33, 119.94, 66.28),
            vector4(-337.28, 825.68, 117.38, 155.2),
            vector4(-365.4, 731.03, 116.19, 272.88),
            vector4(-341.36, 676.57, 116.18, 129.67),
            vector4(-258.61, 594.25, 109.67, 305.67),

            vector4(-142.71, 668.37, 115.33, 328.79),
            vector4(-178.32, 722.1, 119.77, 13.75),
            vector4(-199.29, 764.57, 120.1, 359.74),

        },

        SpawnPointsWave7 = {
            vector4(-239.63, 789.32, 120.15, 267.85),
            vector4(-297.79, 829.33, 119.94, 66.28),
            vector4(-337.28, 825.68, 117.38, 155.2),
            vector4(-365.4, 731.03, 116.19, 272.88),
            vector4(-341.36, 676.57, 116.18, 129.67),
            vector4(-258.61, 594.25, 109.67, 305.67),

            vector4(-142.71, 668.37, 115.33, 328.79),
            vector4(-178.32, 722.1, 119.77, 13.75),
            vector4(-199.29, 764.57, 120.1, 359.74),

        },

        SpawnPointsWave8 = {
            vector4(-239.63, 789.32, 120.15, 267.85),
            vector4(-297.79, 829.33, 119.94, 66.28),
            vector4(-337.28, 825.68, 117.38, 155.2),
            vector4(-365.4, 731.03, 116.19, 272.88),
            vector4(-341.36, 676.57, 116.18, 129.67),
            vector4(-258.61, 594.25, 109.67, 305.67),

            vector4(-142.71, 668.37, 115.33, 328.79),
            vector4(-178.32, 722.1, 119.77, 13.75),
            vector4(-199.29, 764.57, 120.1, 359.74),

        },

        SpawnPointsManhunt = {
            vector4(-220.43, 643.78, 113.1, 223.84),
            vector4(-287.45, 709.6, 114.08, 206.2),
            vector4(-318.13, 835.14, 118.86, 355.16),
        },

        SpawnPointsManhunt = {
            vector4(-220.43, 643.78, 113.1, 223.84),
            vector4(-287.45, 709.6, 114.08, 206.2),
            vector4(-318.13, 835.14, 118.86, 355.16),
        },

    },

    ---------------------------------------------------------
    -- RHODES
    ---------------------------------------------------------

    rhodes = {
        Name = "Rhodes",

        ZoneCenter = vector3(1335.42, -1313.9, 76.75),
        ZoneRadius = 200.0,
        ManhuntTriggerDistance = 180.0,

        UseLassoInWave1 = true,      -- Welle 1: NPCs benutzen nur Lasso

        JailCoords = vector4(2502.22, -1306.7, 48.95, 265.51),  -- Gefängnis-Position (Teleport beim Arrest)
        JailReleaseCoords = vector4(2517.18, -1308.81, 48.94, 270.99), -- Position beim Entlassen


        MaxWaves = 5,                -- Maximal 5 Wellen
        DelayBetweenWaves = 1500,    -- Zeit zwischen Wellen in ms

        MinNPCPerWave = 3,
        MaxNPCPerWave = 5,

        PedWeapon = `WEAPON_REVOLVER_CATTLEMAN`,
        WeaponAmmo = 250,

        PedAccuracy = 65,
        PedCombatRange = 2,
        PedCombatMovement = 2,
        PedCombatAbility = 2,

        EnemyBlipStyle = "BLIP_STYLE_ENEMY",
        EnemyBlipScale = 0.25,

        PoliceModels = {
            "cs_valsheriff",     -- Standard-Polizei-NPCs
        },

        ManhuntModels = {
            "cs_mp_sherifffreeman",     -- Spezielle Manhunt-NPCs
        },

        ManhuntHorse = "a_c_horse_ardennes_strawberryroan", -- Pferd für Manhunt
        WaveReinforcements = {
            [1] = 10,   -- Welle 1
            [2] = 4,   -- Welle 2
            [3] = 5,   -- Welle 3
            [4] = 6,   -- Welle 4
            [5] = 7,   -- Welle 5
            [6] = 8,   -- Welle 6
            [7] = 5,   -- Welle 7 (Manhunt)
            [8] = 6,   -- Welle 8 (Manhunt)
        },

        ManhuntNPCCount = 5,

        SpawnPointsWave1 = {
            vector4(1328.62, -1357.82, 78.73, 96.17),
            vector4(1200.56, -1292.67, 76.48, 42.89),
            vector4(1267.51, -1211.13, 81.71, 116.01),
            vector4(1338.81, -1265.29, 77.66, 233.37),
            vector4(1394.8, -1296.45, 77.51, 188.39),
            vector4(1443.8, -1340.84, 80.33, 235.24),
            vector4(1390.41, -1429.36, 79.59, 168.98),
            vector4(1305.59, -1397.98, 76.51, 91.75),


        },

        SpawnPointsWave2 = {
            vector4(1328.62, -1357.82, 78.73, 96.17),
            vector4(1200.56, -1292.67, 76.48, 42.89),
            vector4(1267.51, -1211.13, 81.71, 116.01),
            vector4(1338.81, -1265.29, 77.66, 233.37),
            vector4(1394.8, -1296.45, 77.51, 188.39),
            vector4(1443.8, -1340.84, 80.33, 235.24),
            vector4(1390.41, -1429.36, 79.59, 168.98),
            vector4(1305.59, -1397.98, 76.51, 91.75),
        },

        SpawnPointsWave3 = {
            vector4(1328.62, -1357.82, 78.73, 96.17),
            vector4(1200.56, -1292.67, 76.48, 42.89),
            vector4(1267.51, -1211.13, 81.71, 116.01),
            vector4(1338.81, -1265.29, 77.66, 233.37),
            vector4(1394.8, -1296.45, 77.51, 188.39),
            vector4(1443.8, -1340.84, 80.33, 235.24),
            vector4(1390.41, -1429.36, 79.59, 168.98),
            vector4(1305.59, -1397.98, 76.51, 91.75),
        },

        SpawnPointsWave4 = {
            vector4(1328.62, -1357.82, 78.73, 96.17),
            vector4(1200.56, -1292.67, 76.48, 42.89),
            vector4(1267.51, -1211.13, 81.71, 116.01),
            vector4(1338.81, -1265.29, 77.66, 233.37),
            vector4(1394.8, -1296.45, 77.51, 188.39),
            vector4(1443.8, -1340.84, 80.33, 235.24),
            vector4(1390.41, -1429.36, 79.59, 168.98),
            vector4(1305.59, -1397.98, 76.51, 91.75),

        },

        SpawnPointsWave5 = {
            vector4(1328.62, -1357.82, 78.73, 96.17),
            vector4(1200.56, -1292.67, 76.48, 42.89),
            vector4(1267.51, -1211.13, 81.71, 116.01),
            vector4(1338.81, -1265.29, 77.66, 233.37),
            vector4(1394.8, -1296.45, 77.51, 188.39),
            vector4(1443.8, -1340.84, 80.33, 235.24),
            vector4(1390.41, -1429.36, 79.59, 168.98),
            vector4(1305.59, -1397.98, 76.51, 91.75),
        },

        SpawnPointsManhunt = {
            vector4(1341.21, -1345.71, 77.87, 250.83),
            vector4(1304.28, -1286.27, 75.75, 13.61),
        },
    },

    ---------------------------------------------------------
    -- Saint Denis
    ---------------------------------------------------------

    saintdenis = {
        Name = "Saint Denis",

        ZoneCenter = vector3(2612.82, -1270.17, 52.7),
        ZoneRadius = 400.0,
        ManhuntTriggerDistance = 380.0,

        UseLassoInWave1 = true,      -- Welle 1: NPCs benutzen nur Lasso

        JailCoords = vector4(2502.22, -1306.7, 48.95, 265.51),  -- Gefängnis-Position (Teleport beim Arrest)
        JailReleaseCoords = vector4(2517.18, -1308.81, 48.94, 270.99), -- Position beim Entlassen


        MaxWaves = 8,                -- Maximal 5 Wellen
        DelayBetweenWaves = 1000,    -- Zeit zwischen Wellen in ms

        MinNPCPerWave = 3,
        MaxNPCPerWave = 10,

        PedWeapon = `WEAPON_REVOLVER_CATTLEMAN`,
        WeaponAmmo = 250,

        PedAccuracy = 65,
        PedCombatRange = 2,
        PedCombatMovement = 2,
        PedCombatAbility = 2,

        EnemyBlipStyle = "BLIP_STYLE_ENEMY",
        EnemyBlipScale = 0.25,

        PoliceModels = {
            "msp_gang3_males_01",     -- Standard-Polizei-NPCs
        },

        ManhuntModels = {
            "msp_gang3_males_01",     -- Spezielle Manhunt-NPCs
        },

        ManhuntHorse = "a_c_horse_ardennes_strawberryroan", -- Pferd für Manhunt
        WaveReinforcements = {
            [1] = 10,   -- Welle 1
            [2] = 6,   -- Welle 2
            [3] = 7,   -- Welle 3
            [4] = 8,   -- Welle 4
            [5] = 9,   -- Welle 5
            [6] = 10,   -- Welle 6
            [7] = 10,   -- Welle 7 (Manhunt)
            [8] = 10,   -- Welle 8 (Manhunt)
        },

        ManhuntNPCCount = 10,

        SpawnPointsWave1 = {
            vector4(2894.06, -1152.33, 46.15, 183.05),
            vector4(2872.13, -1299.02, 45.87, 136.67),
            vector4(2778.96, -1409.29, 45.98, 135.29),
            vector4(2664.61, -1480.16, 45.84, 87.04),

            vector4(2578.98, -1483.68, 46.07, 70.7),
            vector4(2414.94, -1505.37, 45.89, 103.5),
            vector4(2308.85, -1409.14, 45.53, 97.45),
            vector4(2355.4, -1313.01, 45.33, 341.86),

            vector4(2305.11, -1181.72, 42.93, 277.19),
            vector4(2433.65, -1130.41, 47.7, 180.05),
            vector4(2669.48, -1091.44, 48.45, 276.82),
            vector4(2801.87, -1103.75, 46.26, 259.79),

            vector4(2732.89, -1258.45, 49.77, 147.19),
            vector4(2575.0, -1338.55, 47.53, 55.44),
            vector4(2521.79, -1239.5, 50.06, 267.4),
            vector4(2688.62, -1122.89, 50.71, 278.62),



        },

        SpawnPointsWave2 = {
            vector4(2894.06, -1152.33, 46.15, 183.05),
            vector4(2872.13, -1299.02, 45.87, 136.67),
            vector4(2778.96, -1409.29, 45.98, 135.29),
            vector4(2664.61, -1480.16, 45.84, 87.04),

            vector4(2578.98, -1483.68, 46.07, 70.7),
            vector4(2414.94, -1505.37, 45.89, 103.5),
            vector4(2308.85, -1409.14, 45.53, 97.45),
            vector4(2355.4, -1313.01, 45.33, 341.86),

            vector4(2305.11, -1181.72, 42.93, 277.19),
            vector4(2433.65, -1130.41, 47.7, 180.05),
            vector4(2669.48, -1091.44, 48.45, 276.82),
            vector4(2801.87, -1103.75, 46.26, 259.79),

            vector4(2732.89, -1258.45, 49.77, 147.19),
            vector4(2575.0, -1338.55, 47.53, 55.44),
            vector4(2521.79, -1239.5, 50.06, 267.4),
            vector4(2688.62, -1122.89, 50.71, 278.62),
        },

        SpawnPointsWave3 = {
            vector4(2894.06, -1152.33, 46.15, 183.05),
            vector4(2872.13, -1299.02, 45.87, 136.67),
            vector4(2778.96, -1409.29, 45.98, 135.29),
            vector4(2664.61, -1480.16, 45.84, 87.04),

            vector4(2578.98, -1483.68, 46.07, 70.7),
            vector4(2414.94, -1505.37, 45.89, 103.5),
            vector4(2308.85, -1409.14, 45.53, 97.45),
            vector4(2355.4, -1313.01, 45.33, 341.86),

            vector4(2305.11, -1181.72, 42.93, 277.19),
            vector4(2433.65, -1130.41, 47.7, 180.05),
            vector4(2669.48, -1091.44, 48.45, 276.82),
            vector4(2801.87, -1103.75, 46.26, 259.79),

            vector4(2732.89, -1258.45, 49.77, 147.19),
            vector4(2575.0, -1338.55, 47.53, 55.44),
            vector4(2521.79, -1239.5, 50.06, 267.4),
            vector4(2688.62, -1122.89, 50.71, 278.62),
        },

        SpawnPointsWave4 = {
            vector4(2894.06, -1152.33, 46.15, 183.05),
            vector4(2872.13, -1299.02, 45.87, 136.67),
            vector4(2778.96, -1409.29, 45.98, 135.29),
            vector4(2664.61, -1480.16, 45.84, 87.04),

            vector4(2578.98, -1483.68, 46.07, 70.7),
            vector4(2414.94, -1505.37, 45.89, 103.5),
            vector4(2308.85, -1409.14, 45.53, 97.45),
            vector4(2355.4, -1313.01, 45.33, 341.86),

            vector4(2305.11, -1181.72, 42.93, 277.19),
            vector4(2433.65, -1130.41, 47.7, 180.05),
            vector4(2669.48, -1091.44, 48.45, 276.82),
            vector4(2801.87, -1103.75, 46.26, 259.79),

            vector4(2732.89, -1258.45, 49.77, 147.19),
            vector4(2575.0, -1338.55, 47.53, 55.44),
            vector4(2521.79, -1239.5, 50.06, 267.4),
            vector4(2688.62, -1122.89, 50.71, 278.62),
        },

        SpawnPointsWave5 = {
            vector4(2894.06, -1152.33, 46.15, 183.05),
            vector4(2872.13, -1299.02, 45.87, 136.67),
            vector4(2778.96, -1409.29, 45.98, 135.29),
            vector4(2664.61, -1480.16, 45.84, 87.04),

            vector4(2578.98, -1483.68, 46.07, 70.7),
            vector4(2414.94, -1505.37, 45.89, 103.5),
            vector4(2308.85, -1409.14, 45.53, 97.45),
            vector4(2355.4, -1313.01, 45.33, 341.86),

            vector4(2305.11, -1181.72, 42.93, 277.19),
            vector4(2433.65, -1130.41, 47.7, 180.05),
            vector4(2669.48, -1091.44, 48.45, 276.82),
            vector4(2801.87, -1103.75, 46.26, 259.79),

            vector4(2732.89, -1258.45, 49.77, 147.19),
            vector4(2575.0, -1338.55, 47.53, 55.44),
            vector4(2521.79, -1239.5, 50.06, 267.4),
            vector4(2688.62, -1122.89, 50.71, 278.62),
        },

        SpawnPointsManhunt = {
            vector4(2825.33, -1079.54, 45.37, 0.01),
            vector4(2665.14, -1137.64, 50.99, 3.3),
            vector4(2409.84, -1149.65, 46.77, 353.02),
            vector4(2469.09, -1472.15, 46.15, 0.51),

        },
    },

    ---------------------------------------------------------
    -- Annesburg
    ---------------------------------------------------------

    annesburg = {
        Name = "Annesburg",

        ZoneCenter = vector3(2909.13, 1333.43, 48.16),
        ZoneRadius = 200.0,
        ManhuntTriggerDistance = 180.0,

        UseLassoInWave1 = true,      -- Welle 1: NPCs benutzen nur Lasso

        JailCoords = vector4(2903.21, 1314.64, 44.93, 300.19),  -- Gefängnis-Position (Teleport beim Arrest)
        JailReleaseCoords = vector4(2905.44, 1314.32, 44.94, 235.3), -- Position beim Entlassen


        MaxWaves = 5,                -- Maximal 5 Wellen
        DelayBetweenWaves = 1500,    -- Zeit zwischen Wellen in ms

        MinNPCPerWave = 3,
        MaxNPCPerWave = 5,

        PedWeapon = `WEAPON_REVOLVER_CATTLEMAN`,
        WeaponAmmo = 250,

        PedAccuracy = 65,
        PedCombatRange = 2,
        PedCombatMovement = 2,
        PedCombatAbility = 2,

        EnemyBlipStyle = "BLIP_STYLE_ENEMY",
        EnemyBlipScale = 0.25,

        PoliceModels = {
            "cs_valsheriff",     -- Standard-Polizei-NPCs
        },

        ManhuntModels = {
            "cs_mp_sherifffreeman",     -- Spezielle Manhunt-NPCs
        },

        ManhuntHorse = "a_c_horse_ardennes_strawberryroan", -- Pferd für Manhunt
        WaveReinforcements = {
            [1] = 8,   -- Welle 1
            [2] = 4,   -- Welle 2
            [3] = 5,   -- Welle 3
            [4] = 6,   -- Welle 4
            [5] = 7,   -- Welle 5
            [6] = 8,   -- Welle 6
            [7] = 5,   -- Welle 7 (Manhunt)
            [8] = 6,   -- Welle 8 (Manhunt)
        },

        ManhuntNPCCount = 3,

        SpawnPointsWave1 = {
            vector4(2987.16, 1381.04, 43.76, 117.18),
            vector4(2977.38, 1332.01, 43.77, 164.95),
            vector4(2969.17, 1290.47, 43.85, 169.33),
            vector4(2924.17, 1239.14, 44.39, 56.97),

            vector4(2865.65, 1380.45, 66.13, 148.58),
            vector4(2851.1, 1329.01, 64.01, 209.2),
            vector4(2854.71, 1399.62, 68.86, 274.96),


        },

        SpawnPointsWave2 = {
            vector4(2987.16, 1381.04, 43.76, 117.18),
            vector4(2977.38, 1332.01, 43.77, 164.95),
            vector4(2969.17, 1290.47, 43.85, 169.33),
            vector4(2924.17, 1239.14, 44.39, 56.97),

            vector4(2865.65, 1380.45, 66.13, 148.58),
            vector4(2851.1, 1329.01, 64.01, 209.2),
            vector4(2854.71, 1399.62, 68.86, 274.96),
        },

        SpawnPointsWave3 = {
            vector4(2987.16, 1381.04, 43.76, 117.18),
            vector4(2977.38, 1332.01, 43.77, 164.95),
            vector4(2969.17, 1290.47, 43.85, 169.33),
            vector4(2924.17, 1239.14, 44.39, 56.97),

            vector4(2865.65, 1380.45, 66.13, 148.58),
            vector4(2851.1, 1329.01, 64.01, 209.2),
            vector4(2854.71, 1399.62, 68.86, 274.96),
        },

        SpawnPointsWave4 = {
            vector4(2987.16, 1381.04, 43.76, 117.18),
            vector4(2977.38, 1332.01, 43.77, 164.95),
            vector4(2969.17, 1290.47, 43.85, 169.33),
            vector4(2924.17, 1239.14, 44.39, 56.97),

            vector4(2865.65, 1380.45, 66.13, 148.58),
            vector4(2851.1, 1329.01, 64.01, 209.2),
            vector4(2854.71, 1399.62, 68.86, 274.96),
        },

        SpawnPointsWave5 = {
            vector4(2987.16, 1381.04, 43.76, 117.18),
            vector4(2977.38, 1332.01, 43.77, 164.95),
            vector4(2969.17, 1290.47, 43.85, 169.33),
            vector4(2924.17, 1239.14, 44.39, 56.97),

            vector4(2865.65, 1380.45, 66.13, 148.58),
            vector4(2851.1, 1329.01, 64.01, 209.2),
            vector4(2854.71, 1399.62, 68.86, 274.96),
        },

        SpawnPointsManhunt = {
            vector4(2850.42, 1408.04, 68.58, 355.41),
            vector4(2931.9, 1326.56, 44.07, 351.66),
        },
    },


}
