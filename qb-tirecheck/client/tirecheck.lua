local QBCore = exports['qb-core']:GetCoreObject()

function IsVehicleTireDamaged(vehicle)
    for i = 0, 5 do
        if IsVehicleTyreBurst(vehicle, i, false) then
            return true
        end
    end
    return false
end

local lastNotificationTime = 0
local notificationCooldown = 10000

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle ~= 0 and IsPedInAnyVehicle(ped, false) then
            if IsVehicleTireDamaged(vehicle) then
                SetVehicleEngineOn(vehicle, false, true, true)
                TaskVehicleTempAction(ped, vehicle, 27, 1000)
                
                local currentTime = GetGameTimer()
                if currentTime - lastNotificationTime >= notificationCooldown then
                    QBCore.Functions.Notify("Una rueda está pinchada, el vehículo se ha detenido.", "error")
                    lastNotificationTime = currentTime
                end
            end
        end
        Wait(1000)
    end
end)
