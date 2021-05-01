local ind = {l = false, r = false}

Citizen.CreateThread(function()
	while true do
		local playerped = GetPlayerPed(-1)
		if(IsPedInAnyVehicle(playerped)) and not inMenu then
			local vehicle = GetVehiclePedIsIn(playerped, false)
			if vehicle and GetPedInVehicleSeat(vehicle, -1) == playerped and not inMenu then 
				local inMenu = IsPauseMenuActive()
				local sleep = true

				-- Lights
				_,feuPosition,feuRoute = GetVehicleLightsState(vehicle)
				if(feuPosition == 1 and feuRoute == 0) then
					SendNUIMessage({feuPosition = true})
				else
					SendNUIMessage({feuPosition = false})
				end
				if(feuPosition == 1 and feuRoute == 1) then
					SendNUIMessage({feuRoute = true})
				else
					SendNUIMessage({feuRoute = false})
				end

				-- Turn signal
				-- SetVehicleIndicatorLights (1 left -- 0 right)
				local VehIndicatorLight = GetVehicleIndicatorLights(GetVehiclePedIsUsing(PlayerPedId()))
				if IsControlJustPressed(1, 57) then 
					ind.l = not ind.l
					SetVehicleIndicatorLights(GetVehiclePedIsUsing(GetPlayerPed(-1)), 0, ind.l)
				end
				if IsControlJustPressed(1, 56) then 
					ind.r = not ind.r
					SetVehicleIndicatorLights(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1, ind.r)
				end

				if(VehIndicatorLight == 0) then SendNUIMessage({clignotantGauche = false, clignotantDroite = false}) elseif (VehIndicatorLight == 1) then SendNUIMessage({clignotantGauche = true,clignotantDroite = false}) elseif (VehIndicatorLight == 2) then SendNUIMessage({clignotantGauche = false, clignotantDroite = true}) elseif (VehIndicatorLight == 3) then SendNUIMessage({clignotantGauche = true,clignotantDroite = true}) end

			elseif GetPedInVehicleSeat(vehicle, -1) == false then
				SendNUIMessage({showhud = false})
			end
		elseif IsPedInAnyVehicle(playerped) == false then
			SendNUIMessage({showhud = false})
		end

		Citizen.Wait(300)

		if sleep then Citizen.Wait(2000) end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(20)
        local playerped = GetPlayerPed(-1)
        local inMenu = IsPauseMenuActive()
        local sleep = true

        if IsPedInAnyVehicle(playerped, false) and not inMenu then
            sleep = false
            Citizen.Wait(0)
            local vehicle = GetVehiclePedIsIn(playerped)
            local VehicleSpeed = math.ceil(GetEntitySpeed(vehicle) * 2.236936)
			local VehicleFuel = GetVehicleFuelLevel(vehicle)
            SendNUIMessage({
                showhud = true,
				showfuel = true,
                speed = VehicleSpeed,
                fuel = VehicleFuel,
            })
            Citizen.Wait(30)
        else 
            SendNUIMessage({showhud = false})
        end
        if sleep then Citizen.Wait(2000) end
    end
end)
