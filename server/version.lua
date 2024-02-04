function CheckVersion()
    local updatePath = 'https://raw.githubusercontent.com/ugcore-framework/ug-admin/main/version.json'
    PerformHttpRequest(updatePath, function (status, body, headers, errorData)
        local data = json.decode(body)
        local currentVersion = json.decode(LoadResourceFile(GetCurrentResourceName(), 'version.json'))
        local currentVersion = localData.Version

        if not data or not currentVersion then
            print('^7[ug-admin]: ====================================')
            print('^7[ug-admin]: ^1Error on getting the updates!^7')
            print('^7[ug-admin]: ^1Please try updating the framework to make this working again.^7')
            print('^7[ug-admin]: ^1If you updated and it\'s still not working, then maybe it\'s an API problem, and you must wait.^7')
	        print('^7[ug-admin]: ====================================')
        elseif type(currentVersion) ~= 'number' or type(data.Version) ~= 'number' then
            print('^7[ug-admin]: ====================================')
            print('^7[ug-admin]: ^1Detected Broked Version Checker!^7')
            print('^7[ug-admin]: ^1Your version is not a valid number.^7')
            print('^7[ug-admin]: ^1Please try updating the framework to make this working again.^7')
            print('^7[ug-admin]: ====================================')
        elseif tonumber(currentVersion) > tonumber(data.Version) then
            print('^7[ug-admin]: ====================================')
            print('^7[ug-admin]: ^1Detected Broked Version Checker!^7')
            print('^7[ug-admin]: ^1Your version is greater than the most recently updated version.^7')
            print('^7[ug-admin]: ^1Please try updating the framework to make this working again.^7')
	        print('^7[ug-admin]: ====================================')
        elseif currentVersion ~= data.Version and tonumber(currentVersion) < tonumber(data.Version) then
            print('^7[ug-admin]: ====================================')
            print('^7[ug-admin]: ^3New Update Found!^7')
            print('^7[ug-admin]: ^3Your Version: ^1' .. currentVersion .. '^7')
            print('^7[ug-admin]: ^3New Version: ^2' .. data.Version .. '^7')
            print('^7[ug-admin]: ^3Changelogs: ^2' .. data.Changelogs .. '^7')
            print('^7[ug-admin]: ')
            print('^7[ug-admin]: ^3Update here:')
            print('^7[ug-admin]: ^3https://github.com/ugcore-framework/ug-admin/releases')
	        print('^7[ug-admin]: ====================================')
        end
    end, 'GET')
end

MySQL.ready(function ()
    Wait(2500)
    CheckVersion()
end)