local debugZoneEnabled = false
local Blips = {}

RegisterCommand("DebugZone", function()
    debugZoneEnabled = not debugZoneEnabled
    if debugZoneEnabled then
        print("Debug zones enabled")
    else
       print("Debug zones disabled")
    end
end, false)

function DebugDrawText2D(x,y,width,height,scale,text,r,g,b,a)
    SetTextFont(6)
    SetTextProportional(0)
    SetTextScale(scale,scale)
    SetTextColour(r,g,b,a)
    SetTextDropShadow(0,0,0,0,255)
    SetTextEdge(1,0,0,0,255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x-width/2,y-height/2+0.005)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if debugZoneEnabled then
            SetBigmapActive(true, true)
                local Ped = PlayerPedId()
                local PedCoords = GetEntityCoords(Ped)
                local ActualZone = GetNameOfZone(PedCoords["x"],PedCoords["y"],PedCoords["z"])
                DebugDrawText2D(0.5, 0.05, 0.0, 0.0, 0.8, "~y~ZONE: ~b~" .. ActualZone, 55, 155, 55, 255)
                
            for index, zone in ipairs(zoneid) do
                local bbmin = zone.bbmin
                local bbmax = zone.bbmax
                local color = { r = zone.R, g = zone.G, b = zone.B }
                
                
                
                DrawBox(bbmin.x, bbmin.y, bbmin.z, bbmax.x, bbmax.y, bbmax.z, color.r, color.g, color.b, 150)


                if not Blips[index] then
                    
                    local centerX = (bbmin.x + bbmax.x) / 2
                    local centerY = (bbmin.y + bbmax.y) / 2

                    local width = math.abs(bbmax.x - bbmin.x)
                    local height = math.abs(bbmax.y - bbmin.y)
                    Blips[index] = AddBlipForArea(centerX, centerY, 0.0, width, height)
                    SetBlipColour(Blips[index], tonumber(zone.Hex))
                    SetBlipAlpha(Blips[index], 150)
                end
            end
        else
            for index in ipairs(Blips) do
                if DoesBlipExist(Blips[index]) then
                    RemoveBlip(Blips[index])
                    Blips[index] = nil
                end
            end
            SetBigmapActive(false, false)
        end
    end
end)
