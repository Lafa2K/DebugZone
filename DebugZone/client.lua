local debugZoneEnabled = false
local Blips = {}
local lastZone = nil

local scumLevels = {
    [0] = "Very Rich Area",               -- SCUMMINESS_POSH
    [1] = "Upper Middle Class",               -- SCUMMINESS_NICE
    [2] = "Decent Area",      -- SCUMMINESS_ABOVE_AVERAGE
    [3] = "Lower Middle Class",      -- SCUMMINESS_BELOW_AVERAGE
    [4] = "Poor",               -- SCUMMINESS_CRAP
    [5] = "Very Poor"                -- SCUMMINESS_SCUM
}

local mapAreaHashes = {
    [-289320599] = "City",
    [2072609373] = "Countryside"
}
local areaNames = {
    AIRP = "Los Santos International Airport",
    ALAMO = "Alamo Sea",
    ALTA = "Alta",
    ARMYB = "Fort Zancudo",
    BANHAMC = "Banham Canyon Dr",
    BANNING = "Banning",
    BEACH = "Vespucci Beach",
    BHAMCA = "Banham Canyon",
    BRADP = "Braddock Pass",
    BRADT = "Braddock Tunnel",
    BURTON = "Burton",
    CALAFB = "Calafia Bridge",
    CANNY = "Raton Canyon",
    CCREAK = "Cassidy Creek",
    CHAMH = "Chamberlain Hills",
    CHIL = "Vinewood Hills",
    CHU = "Chumash",
    CMSW = "Chiliad Mountain State Wilderness",
    CYPRE = "Cypress Flats",
    DAVIS = "Davis",
    DELBE = "Del Perro Beach",
    DELPE = "Del Perro",
    DELSOL = "La Puerta",
    DESRT = "Grand Senora Desert",
    DOWNT = "Downtown",
    DTVINE = "Downtown Vinewood",
    EAST_V = "East Vinewood",
    EBURO = "El Burro Heights",
    ELGORL = "El Gordo Lighthouse",
    ELYSIAN = "Elysian Island",
    GALFISH = "Galilee",
    GOLF = "GWC and Golfing Society",
    GRAPES = "Grapeseed",
    GREATC = "Great Chaparral",
    HARMO = "Harmony",
    HAWICK = "Hawick",
    HORS = "Vinewood Racetrack",
    HUMLAB = "Humane Labs and Research",
    JAIL = "Bolingbroke Penitentiary",
    KOREAT = "Little Seoul",
    LACT = "Land Act Reservoir",
    LAGO = "Lago Zancudo",
    LDAM = "Land Act Dam",
    LEGSQU = "Legion Square",
    LMESA = "La Mesa",
    LOSPUER = "La Puerta",
    MIRR = "Mirror Park",
    MORN = "Morningwood",
    MOVIE = "Richards Majestic",
    MTCHIL = "Mount Chiliad",
    MTGORDO = "Mount Gordo",
    MTJOSE = "Mount Josiah",
    MURRI = "Murrieta Heights",
    NCHU = "North Chumash",
    NOOSE = "N.O.O.S.E",
    OCEANA = "Pacific Ocean",
    PALCOV = "Paleto Cove",
    PALETO = "Paleto Bay",
    PALFOR = "Paleto Forest",
    PALHIGH = "Palomino Highlands",
    PALMPOW = "Palmer-Taylor Power Station",
    PBLUFF = "Pacific Bluffs",
    PBOX = "Pillbox Hill",
    PROCOB = "Procopio Beach",
    RANCHO = "Rancho",
    RGLEN = "Richman Glen",
    RICHM = "Richman",
    ROCKF = "Rockford Hills",
    RTRAK = "Redwood Lights Track",
    SANAND = "San Andreas",
    SANCHIA = "San Chianski Mountain Range",
    SANDY = "Sandy Shores",
    SKID = "Mission Row",
    SLAB = "Stab City",
    STAD = "Maze Bank Arena",
    STRAW = "Strawberry",
    TATAMO = "Tataviam Mountains",
    TERMINA = "Terminal",
    TEXTI = "Textile City",
    TONGVAH = "Tongva Hills",
    TONGVAV = "Tongva Valley",
    VCANA = "Vespucci Canals",
    VESP = "Vespucci",
    VINE = "Vinewood",
    WINDF = "Ron Alternates Wind Farm",
    WVINE = "West Vinewood",
    ZANCUDO = "Zancudo River",
    ZP_ORT = "Port of South Los Santos",
    ZQ_UAR = "Davis Quartz"
}
function DrawZoneBox(bbmin, bbmax, color)
    DrawBox(bbmin.x, bbmin.y, bbmin.z, bbmax.x, bbmax.y, bbmax.z, color.r, color.g, color.b, 150)
end

function ClearBlips()
    if Blips and Blips.blipslist then
        for _, blip in ipairs(Blips.blipslist) do
            if DoesBlipExist(blip) then
                RemoveBlip(blip)
            end
        end
    end
    Blips = { name = "", blipslist = {} }
end


function HandleClear()
    debugZoneEnabled = false
    lastZone = nil
    print("Debug zones cleared and disabled.")
    ClearBlips()
    SetBigmapActive(false, false)
end
RegisterCommand("DebugZone", function(_, args)
    if #args == 0 then
        print("Please provide an argument. Usage: /DebugZone [all], /DebugZone clear, or /DebugZone [zonename]")
        return
    end

    if args[1] == "clear" then
        HandleClear()
        debugZoneEnabled = false
    elseif args[1] == "mylocation" or args[1] == "all" then
        ClearBlips()
        debugZoneEnabled = true
        SetBigmapActive(true, true)
        lastZone = args[1]
    else
        if lastZone == "all" then
            HandleClear() 
        end
        lastZone = args[1]
        debugZoneEnabled = true
        SetBigmapActive(true, true)
    end
end, false)


function DrawBlipsForZone(zone)
    local centerX = (zone.bbmin.x + zone.bbmax.x) / 2
    local centerY = (zone.bbmin.y + zone.bbmax.y) / 2
    local width = math.abs(zone.bbmax.x - zone.bbmin.x)
    local height = math.abs(zone.bbmax.y - zone.bbmin.y)

    local blip = AddBlipForArea(centerX, centerY, 0.0, width, height)
    SetBlipColour(blip, tonumber(zone.Hex))
    SetBlipAlpha(blip, 150)
    table.insert(Blips, blip)
end

RegisterCommand("DebugZone", function(_, args)
    if #args == 0 then
        print("Please provide an argument. Usage: /DebugZone [all], /DebugZone clear, or /DebugZone [zonename]")
    elseif args[1] == "clear" then
        HandleClear()
    elseif args[1] == "mylocation" then
        ClearBlips()
        SetBigmapActive(true, true)
        debugZoneEnabled = true
        lastZone = "mylocation"
    elseif args[1] == "all" then
        debugZoneEnabled = true
        lastZone = "all"
        SetBigmapActive(true, true)
    else
        if lastZone == "all" then
            HandleClear()
        end
        lastZone = args[1]
        debugZoneEnabled = true
        SetBigmapActive(true, true)
    end
end, false)

function GetScumLevelText(scumValue)
    return scumLevels[scumValue] or "Unknown"
end

function GetZoneAreaAtCoords(x, y, z)
    return mapAreaHashes[GetHashOfMapAreaAtCoords(x, y, z)] or "Unknown"
end

-- Corrigindo a função para usar 'ActualZone' corretamente
function GetAreaNameAtCoords(ActualZone)
    return areaNames[ActualZone] or "Unknown"
end

function DrawZoneName()
    local Ped = PlayerPedId()
    local PedCoords = GetEntityCoords(Ped)
    
    ZoneID = GetZoneAtCoords(PedCoords.x, PedCoords.y, PedCoords.z)
    
    ActualZone = GetNameOfZone(PedCoords.x, PedCoords.y, PedCoords.z)
    
    ActualScum = GetZoneScumminess(ZoneID)
  
    AreaText = GetZoneAreaAtCoords(PedCoords.x, PedCoords.y, PedCoords.z)
    
    AreanameText = GetAreaNameAtCoords(ActualZone)

    ScumText = GetScumLevelText(ActualScum)

    DebugDrawText2D(0.5, 0.05, 0.0, 0.0, 0.8, "~y~ZONE: ~b~" .. ActualZone, 55, 155, 55, 255)
    DebugDrawText2D(0.5, 0.10, 0.0, 0.0, 0.6, "ZONE VALUE: ~g~" .. ScumText, 255, 255, 255, 255)
    DebugDrawText2D(0.5, 0.15, 0.0, 0.0, 0.6, "AREA: ~g~" .. AreaText, 255, 255, 255, 255)
    DebugDrawText2D(0.5, 0.20, 0.0, 0.0, 0.6, "REAL AREA: ~g~" .. AreanameText, 255, 255, 255, 255)
end


function DebugDrawText2D(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(6)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width / 2, y - height / 2 + 0.005)
end

function GetPlayerZone()
    local Ped = PlayerPedId()
    local PedCoords = GetEntityCoords(Ped)
    return GetNameOfZone(PedCoords.x, PedCoords.y, PedCoords.z)
end

function DrawBoxEdges(bbmin, bbmax)
    local x1, y1, z1 = bbmin.x, bbmin.y, bbmin.z
    local x2, y2, z2 = bbmax.x, bbmin.y, bbmin.z
    local x3, y3, z3 = bbmax.x, bbmax.y, bbmin.z
    local x4, y4, z4 = bbmin.x, bbmax.y, bbmin.z
    local x5, y5, z5 = bbmin.x, bbmin.y, bbmax.z
    local x6, y6, z6 = bbmax.x, bbmin.y, bbmax.z
    local x7, y7, z7 = bbmax.x, bbmax.y, bbmax.z
    local x8, y8, z8 = bbmin.x, bbmax.y, bbmax.z

    DrawLine(x1, y1, z1, x2, y2, z2, 255, 0, 0, 255)
    DrawLine(x2, y2, z2, x3, y3, z3, 255, 0, 0, 255)
    DrawLine(x3, y3, z3, x4, y4, z4, 255, 0, 0, 255)
    DrawLine(x4, y4, z4, x1, y1, z1, 255, 0, 0, 255)
    
    DrawLine(x5, y5, z5, x6, y6, z6, 255, 0, 0, 255)
    DrawLine(x6, y6, z6, x7, y7, z7, 255, 0, 0, 255)
    DrawLine(x7, y7, z7, x8, y8, z8, 255, 0, 0, 255)
    DrawLine(x8, y8, z8, x5, y5, z5, 255, 0, 0, 255)
    
    DrawLine(x1, y1, z1, x5, y5, z5, 255, 0, 0, 255)
    DrawLine(x2, y2, z2, x6, y6, z6, 255, 0, 0, 255)
    DrawLine(x3, y3, z3, x7, y7, z7, 255, 0, 0, 255)
    DrawLine(x4, y4, z4, x8, y8, z8, 255, 0, 0, 255)
end

function DrawBlipsForZone(zone)
    if not Blips or Blips.name ~= lastZone then
        ClearBlips()

        Blips = { 
            name = lastZone,
            blipslist = {}
        }
    end

    local centerX = (zone.bbmin.x + zone.bbmax.x) / 2
    local centerY = (zone.bbmin.y + zone.bbmax.y) / 2
    local width = math.abs(zone.bbmax.x - zone.bbmin.x)
    local height = math.abs(zone.bbmax.y - zone.bbmin.y)

    local blip = AddBlipForArea(centerX, centerY, 0.0, width, height)
    SetBlipColour(blip, tonumber(zone.Hex))
    SetBlipAlpha(blip, 150)

    table.insert(Blips.blipslist, blip)
end
Citizen.CreateThread(function()
    local zonesDrawn = false 

    while true do
        Citizen.Wait(1)

        if debugZoneEnabled then
            SetBigmapActive(true, true)

            if Blips.name ~= lastZone then
                ClearBlips()
                Blips = { 
                    name = lastZone, 
                    blipslist = {} 
                }
                zonesDrawn = false
            end

            if lastZone == "all" then
                for _, zone in ipairs(zoneid) do
                    local bbmin = zone.bbmin
                    local bbmax = zone.bbmax
                    local color = { r = zone.R, g = zone.G, b = zone.B }

                    SetBackfaceculling(true)
                    DrawZoneBox(bbmin, bbmax, color)

                    if not zonesDrawn then
                        DrawBlipsForZone(zone)
                    end
                end
                zonesDrawn = true

            elseif lastZone == "mylocation" then
                local playerZone = GetPlayerZone()
                if playerZone ~= "" then
                    ClearBlips()
                    zonesDrawn = false
                    for _, zone in ipairs(zoneid) do
                        if string.lower(zone.zonename) == string.lower(playerZone) then
                            local bbmin = zone.bbmin
                            local bbmax = zone.bbmax
                            local color = { r = zone.R, g = zone.G, b = zone.B }

                            SetBackfaceculling(false)
                            DrawZoneBox(bbmin, bbmax, color)
                        DrawBlipsForZone(zone)
                        DrawBoxEdges(bbmin, bbmax)

                        end
                    end
                end

            elseif lastZone and lastZone ~= "all" then
                ClearBlips()
                zonesDrawn = false
                for _, zone in ipairs(zoneid) do
                    if string.lower(zone.zonename) == string.lower(lastZone) then
                        local bbmin = zone.bbmin
                        local bbmax = zone.bbmax
                        local color = { r = zone.R, g = zone.G, b = zone.B }

                        SetBackfaceculling(false)
                        DrawZoneBox(bbmin, bbmax, color)
                        DrawBoxEdges(bbmin, bbmax)
                        DrawBlipsForZone(zone)
                    end
                end
            end

            DrawZoneName()
        else
            zonesDrawn = false
        end
    end
end)

TriggerEvent('chat:addSuggestion', '/DebugZone', 'Draw zone locations', {
    { name = "all, zonename , mylocation, clear", help = "Examples:  /DebugZone all = show all zones (heavy cpu load) || /DebugZone chil = load only chil zone || /DebugZone mylocation = automatic update zones from my location || /DebugZone clear = to stop all" }
})
