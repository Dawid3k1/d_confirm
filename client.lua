local ConfirmMenuResult = nil
local CurrentConfirmMenu = nil
local Menu = false

exports('OpenConfirmMenu', function(data, cb)
    while CurrentConfirmMenu ~= nil do
        Menu = true
        Wait(100)
    end
    if Menu then
        Wait(250)
        Menu = false
    end
    CurrentConfirmMenu = data
    ConfirmMenuResult = promise.new()
    SendNUIMessage({
        action = 'OpenCofirmMenu',
        data = {
            title = data.title,
            desc = data.desc,
            btnCancel = (data.btnCancel and data.btnCancel or 'Nie'),
            btnConfirm = (data.btnConfirm and data.btnConfirm or 'Tak'),
        }
    })
    SetNuiFocus(true, true)
    cb(Citizen.Await(ConfirmMenuResult))
end)

RegisterNUICallback('ConfirmMenuResult', function(data)
    ConfirmMenuResult:resolve(data.result)
    CurrentConfirmMenu = nil
    SetNuiFocus(false, false)
end)

RegisterNetEvent('otworzmenu', function()
    exports['d_confirm']:OpenConfirmMenu({
		title = 'Czy chcesz kontyunować?',
        desc = 'Tej akcji nie da się cofnąć, czy jesteś pewny?'
	}, function(callback)
		if callback then
			ESX.ShowNotification('Testowa notifykacja')
		end
	end)
end)

RegisterCommand('davidmenu:open', function()
    TriggerEvent('otworzmenu')
end)