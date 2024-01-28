UgDev.Accounts.Functions = { }

function UgDev.Accounts.Functions.CreateAccount(name, owner, money)
    local self      = { }
    self.Functions  = { }

    self.name       = name
    self.owner      = owner
    self.money      = money

    function self.Functions.GiveMoney(money)
        self.money = self.money + money
        self.Functions.SaveAccount()
        TriggerEvent('ug-accounts:GiveMoney', self.name, money)
    end

    function self.Functions.RemoveMoney(money)
        self.money = self.money - money
        self.Functions.SaveAccount()
        TriggerEvent('ug-accounts:RemoveMoney', self.name, money)
    end

    function self.Functions.SetMoney(money)
        self.money = money
        self.Functions.SaveAccount()
        TriggerEvent('ug-accounts:SetMoney', self.name, money)
    end

    function self.Functions.SaveAccount()
        if not self.owner then
			MySQL.update('UPDATE `accountsdata` SET `money` = ? WHERE `accountName` = ?', { 
                self.money, 
                self.name
            })
		else
			MySQL.update('UPDATE `accountsdata` SET `money` = ? WHERE `accountName` = ? AND `owner` = ?', {
                self.money, 
                self.name, 
                self.owner
            })
		end
		TriggerClientEvent('ug-accounts:SetMoney', -1, self.name, self.money)
    end
    return self
end