local QBCore = exports['qb-core']:GetCoreObject()
local radiationZone = vector3(2500.0, 3500.0, 20.0) -- Coordinates of the radiation zone center
local radiationRadius = 100.0 -- Radius of the zone
local radiationDamage = 5 -- Damage per tick
local tickInterval = 5000 -- Time interval (ms) for applying damage
local requiredItem = "hazmat_suit" -- Item needed to avoid damage

-- Add a blip for the radiation zone
Citizen.CreateThread(function()
    local blip = AddBlipForRadius(radiationZone.x, radiationZone.y, radiationZone.z, radiationRadius)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 1) -- Red color for the danger zone
    SetBlipAlpha(blip, 128) -- Semi-transparent
    SetBlipAsShortRange(blip, true)

    local markerBlip = AddBlipForCoord(radiationZone.x, radiationZone.y, radiationZone.z)
    SetBlipSprite(markerBlip, 468) -- Use a radiation icon
    SetBlipDisplay(markerBlip, 4)
    SetBlipScale(markerBlip, 1.0)
    SetBlipColour(markerBlip, 1) -- Red color
    SetBlipAsShortRange(markerBlip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Radiation Zone")
    EndTextCommandSetBlipName(markerBlip)
end)

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local isInZone = #(playerCoords - radiationZone) <= radiationRadius

        if isInZone then
            -- Apply screen effects and check for required item
            StartScreenEffect("DrugsMichaelAliensFight", 0, true) -- Example effect
            PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", true) -- Warning sound

            QBCore.Functions.TriggerCallback('ox_inventory:Search', function(hasItem)
                if not hasItem then
                    -- Apply damage if the player doesn't have the required item
                    ApplyDamageToPed(playerPed, radiationDamage)
                    TriggerEvent('chat:addMessage', {
                        color = {255, 0, 0},
                        multiline = true,
                        args = {"Radiation", "You are taking damage! Find a hazmat suit."}
                    })
                else
                    -- Feedback for being protected
                    TriggerEvent('chat:addMessage', {
                        color = {0, 255, 0},
                        multiline = true,
                        args = {"Radiation", "Your hazmat suit is protecting you."}
                    })
                end
            end, requiredItem)
        else
            -- Stop the effect when leaving the zone
            StopScreenEffect("DrugsMichaelAliensFight")
        end

        Citizen.Wait(isInZone and tickInterval or 1000)
    end
end)

function ApplyDamageToPed(ped, damage)
    local currentHealth = GetEntityHealth(ped)
    SetEntityHealth(ped, currentHealth - damage)
end
