AddEventHandler('onResourceStart', function (resourceName)
    if resourceName == GetCurrentResourceName() then
        -- Accounts --
        local accounts = MySQL.query.await('SELECT * FROM `accounts` LEFT JOIN `accountsdata` ON accounts.name = accountsdata.accountName UNION SELECT * FROM `accounts` RIGHT JOIN `accountsdata` ON accounts.name = accountsdata.accountName')
        local newAccounts = { }
        for _, v in pairs(accounts) do
            if v.shared == 0 then
                if not UgDev.Accounts[v.name] then
                    UgDev.AccountsIndex[#UgDev.AccountsIndex + 1] = v.name
                    UgDev.Accounts[v.name] = { }
                end
                UgDev.Accounts[v.name][#UgDev.Accounts[v.name] + 1] = UgDev.Accounts.Functions.CreateAccount(v.name, v.owner, v.money)
            else
                if v.money then
					UgDev.SharedAccounts[v.name] = UgDev.Accounts.Functions.CreateAccount(v.name, nil, v.money)
				else
					newAccounts[#newAccounts + 1] = {
                        v.name, 
                        0
                    }
				end
            end
        end
        GlobalState.SharedAccounts = UgDev.SharedAccounts

        if next(newAccounts) then
            MySQL.prepare('INSERT INTO `accountsdata` (accountName, money) VALUES (?, ?)', newAccounts)
            for _, v in pairs(newAccounts) do
                UgDev.SharedAccounts[v] = UgDev.Accounts.Functions.CreateAccount(v, nil, 0)
            end
            GlobalState.SharedAccounts = UgDev.SharedAccounts
        end
    end
end)

AddEventHandler('ug-core:PlayerLoaded', function (source, player)
    local accounts = { }

    for i = 1, #UgDev.AccountsIndex, 1 do
        local name = UgDev.AccountsIndex[i]
        local account = UgDev.Functions.GetAccount(name, player.identifier)
        if not account then
            MySQL.insert('INSERT INTO `accountsdata` (accountName, money, owner) VALUES (?, ?, ?)', {
                name,
                0,
                player.identifier
            })
            account = UgDev.Accounts.Functions.CreateAccount(name, player.identifier, 0)
            UgDev.Accounts[name][#UgDev.Accounts[name] + 1] = account
        end
        accounts[#accounts + 1] = account
    end

    player.Functions.SetData('addonAccounts', accounts)
end)

RegisterNetEvent('ug-accounts:RefreshAccounts', function ()
    local result = MySQL.query.await('SELECT * FROM `accounts`')
    for _, v in pairs(result) do
        local name      = v.name
        local label     = v.label
        local shared    = v.shared

        local result2 = MySQL.query.await('SELECT * FROM `accountsdata` WHERE `accountName` = ?', { name })

        if shared == 0 then
            UgDev.AccountsIndex[#UgDev.AccountsIndex + 1] = name
            UgDev.Accounts[name] = { }
            for _, v2 in pairs(result2) do
                local account = UgDev.Accounts.Functions.CreateAccount(name, v2.owner, v2.money)
                UgDev.Accounts[name] = account
            end
        else
            local money = nil
            if #result2 == 0 then
                MySQL.insert('INSERT INTO addon_account_data (account_name, money, owner) VALUES (?, ?, ?)', { 
                    name, 
                    0, 
                    NULL 
                })
                money = 0
            else
                money = result2[1].money
            end

            local account = UgDev.Accounts.Functions.CreateAddonAccount(name, nil, money)
            UgDev.SharedAccounts[name] = account
        end
    end
end)