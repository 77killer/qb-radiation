local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('ox_inventory:Search', function(source, cb, itemName)
    local Player = QBCore.Functions.GetPlayer(source)
    local inventory = exports.ox_inventory:Search(source, 'count', itemName)

    if inventory and inventory > 0 then
        cb(true)
    else
        cb(false)
    end
end)
