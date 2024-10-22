local coordsVisible = false
local coordsText = ""
local display = false

RegisterCommand("coords", function()
    coordsVisible = not coordsVisible
    display = not display
    if coordsVisible then
        SetNuiFocus(true, true)
        SendNUIMessage({ action = "showUI" })
        TriggerServerEvent('kw_coords:getDiscordAvatar')
    else
        SetNuiFocus(false, false)
        SendNUIMessage({ action = "hideUI" })
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if coordsVisible then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local heading = GetEntityHeading(playerPed)
            coordsText = string.format("x= %.2f y= %.2f z= %.2f h= %.2f", playerCoords.x, playerCoords.y, playerCoords.z, heading)
            SendNUIMessage({
                action = "updateCoords",
                coords = coordsText,
                vector3 = string.format("vector3(%.2f, %.2f, %.2f)", playerCoords.x, playerCoords.y, playerCoords.z),
                vector4 = string.format("vector4(%.2f, %.2f, %.2f, %.2f)", playerCoords.x, playerCoords.y, playerCoords.z, heading),
                heading = heading
            })
        end
    end
end)

RegisterNUICallback('coordsCopied', function(data, cb)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(data.message)
    DrawNotification(false, true)
    
    cb('ok')
end)

RegisterNetEvent('kw_coords:sendDiscordAvatar')
AddEventHandler('kw_coords:sendDiscordAvatar', function(avatarURL)
    SendNUIMessage({ action = 'updateAvatar', avatarURL = avatarURL })
end)

RegisterNUICallback("closeUI", function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "hideUI" })
    coordsVisible = false
    cb("ok")
end)