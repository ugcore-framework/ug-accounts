local UgCore = exports['ug-core']:GetCore()

UgCore.Callbacks.CreateCallback('ug-accounts:GetAccount', function (source, cb, name, owner)
    cb(UgDev.Functions.GetAccount(name, owner))
end)

UgCore.Callbacks.CreateCallback('ug-accounts:GetSharedAccount', function (source, cb, name)
    cb(UgDev.Functions.GetSharedAccount(name))
end)