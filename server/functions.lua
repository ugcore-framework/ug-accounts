UgDev.Functions = { }

function UgDev.Functions.GetAccount(name, owner)
    for i = 1, #UgDev.Accounts[name], 1 do
        if UgDev.Accounts[name][i].owner == owner then
            return UgDev.Accounts[name][i]
        end
    end
end

function UgDev.Functions.GetSharedAccount(name)
    return UgDev.SharedAccounts[name]
end

function UgDev.Functions.CreateSharedAccount(society, amount)
    if type(society) ~= 'table' or not society?.name or not society?.label then 
        return error('Invalid Society Values')
    end

    if not UgDev.SharedAccounts[society.name] then
        return UgDev.SharedAccounts[society.name]
    end

    local account = MySQL.insert.await('INSERT INTO `accounts` (name, label, shared) VALUES (?, ?, ?)', {
        society.name,
        society.label,
        1
    })

    local accountData = MySQL.insert.await('INSERT INTO `accountsdata` (accountName, money) VALUES (?, ?)', {
        society.name,
        amount or 0
    })

    if not account then
        return error('(Database): Error inserting a new society into the "accounts" table!')
    end

    if not accountData then
        return error('(Database): Error inserting a new society data into the "accountsdata" table!')
    end

    UgDev.SharedAccounts[society.name] = UgDev.Accounts.Functions.CreateAccount(society.name, nil, amount or 0)
    return UgDev.SharedAccounts[society.name]
end