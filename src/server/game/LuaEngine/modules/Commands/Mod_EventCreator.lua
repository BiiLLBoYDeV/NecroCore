--[[##
## _|      _|                                            _|_|_|
## _|_|    _|    _|_|      _|_|_|  _|  _|_|    _|_|    _|          _|_|    _|  _|_|    _|_|
## _|  _|  _|  _|_|_|_|  _|        _|_|      _|    _|  _|        _|    _|  _|_|      _|_|_|_|
## _|    _|_|  _|        _|        _|        _|    _|  _|        _|    _|  _|        _|
## _|      _|    _|_|_|    _|_|_|  _|          _|_|      _|_|_|    _|_|    _|          _|_|_|
##                                              https://github.com/necromancers-dev/NecroCore
##
## -| Support NecroCore |- paypal.me/Necromancers
## -| Debug NecroCore   |- debug.arcanic.eu
## -| Contributors      |- Necromancers, Hidoyatmz, Rochet2, BillBoy
##
##
##]]--

--[[
	.event create 	|- Pour créer un point d'event pour vos joueurs
	.event delete 	|- Pour supprimer le point d'event

	.event join			|- Téléporte le personnage au point d'event (peu être utilisés par les joueurs)
	.event leave		|- Téléporte le personnage à son point de départ
]]--

	--[[

		Require List

	]]--
		--[[

			Verification Modules Active

		]]--
			require('modules_active');

			--[[

				Generation du .ext

			]]--
				if (Script.Mod_EventCreator == 1)then
					local confFilesName = 'Conf_EventCreator';
					local confFiles = io.open('./lua_scripts/'..confFilesName..'.ext', 'r');
					if (not confFiles) then
						local confFiles = io.open('./lua_scripts/'..confFilesName..'.ext', 'a');
						confFiles:write('-- ## -| Support NecroCore |- paypal.me/Necromancers', '\n');
						confFiles:write('-- ## -| Debug NecroCore   |- debug.arcanic.eu', '\n\n');
						-- -- -- -- -- -- -- -- -- --
						confFiles:write('local Language = {', '\n');
						confFiles:write('  -- Create Event Success', '\n');
						confFiles:write('    [1] = \'Event créé avec succés!\',', '\n\n');
						confFiles:write('  -- Event Create announce to all player]]', '\n');
						confFiles:write('    [2] = \'viens de créer un event, si vous souhaitez y participer : .event join\\nPour sortir de l\\\'event un simple .event leave vous permet de vous téléporter à votre ancienne localisation.\',', '\n\n');
						confFiles:write('  -- Delete Event Succes]]', '\n');
						confFiles:write('    [3] = \'Event supprimé avec succés!\',', '\n\n');
						confFiles:write('  -- Event delete announce to all player]]', '\n');
						confFiles:write('    [4] = \'viens de supprimer son event, vous ne pouvez plus y participer!\',', '\n\n');
						confFiles:write('  -- No Event created', '\n');
						confFiles:write('    [5] = \'Aucun event n\\\'as été créé pour le moment!\';', '\n');
						confFiles:write('};', '\n\n');
						-- -- -- -- -- -- -- -- -- --
						confFiles:write('local Commands = {', '\n');
						confFiles:write('    [1] = \'event create\',', '\n');
						confFiles:write('    [2] = \'event delete\',', '\n');
						confFiles:write('    [3] = \'event join\',', '\n');
						confFiles:write('    [4] = \'event leave\';', '\n');
						confFiles:write('};', '\n\n');
						confFiles:flush();
						-- -- -- -- -- -- -- -- -- --
					end
					-- Require ConfFiles --
					if (confFiles) or (not confFiles) then
						require(confFilesName);
					end
				end
				if (Script.Mod_EventCreator == 0) then
					local confFilesName = 'Conf_EventCreator';
					os.remove('./lua_scripts/'..confFilesName..'.ext');
				end

	if (Script.Mod_EventCreator == 1)then
		--[[

			Locale Variable

		]]--
			local eventCreate = {};
			local pSave = {};

		--[[

			Event Command

		]]--
			local function eventCommand(event, player, command)
				-- Vérification des rangs || Hors Combats
				if (player:GetGMRank() > 0 and player:IsInCombat() == false) then
					-- Vérification de l'existence du Tableau
					if (not eventCreate) then eventCreate = {map = 0, x = 0, y = 0, z = 0;}; end
					-- Vérification de la commande entrée
					if (string.upper(command) == Commands[1]) then
						-- On ajoute les coordonées lors de la creation de l'Event
						eventCreate.map = player:GetMapId(); eventCreate.x = player:GetX(); eventCreate.y = player:GetY(); eventCreate.z = player:GetZ();
						-- On envoie un message à tout les joueurs
						player:SendNotification(Language[1]);
						SendWorldMessage(player:GetName()..' '..Language[2]);
						return false;

					-- Vérification de la commande entrée
					elseif (string.upper(command) == Commands[2]) then
						-- On vérifie que l'event a bien était créé
						if eventCreate.x ~= 0 and eventCreate.y ~= 0 and eventCreate.z ~= 0 then
							-- On supprime les coordonées lors de la destruction de l'Event
							eventCreate.map = 0; eventCreate.x = 0; eventCreate.y = 0; eventCreate.z = 0;
							player:SendNotification(Language[3]);
							SendWorldMessage(player:GetName()..' '..Language[4]);
						else
							player:SendNotification(Language[5]);
						end
						return false;
					end
				end

				-- Vérification des rangs || Hors Combats
				if (player:GetGMRank() >= 0 and player:IsInCombat() == false) then
					-- Vérification de la commande entrée
					if (string.upper(command) == Commands[3]) then
						-- Vérification de l'existence du Tableau
						if (not pSave[player:GetGUIDLow()]) then pSave[player:GetGUIDLow()] = {map = 0, x = 0, y = 0, z = 0;}; end
								if (not eventCreate) then eventCreate = {map = 0, x = 0, y = 0, z = 0;}; end
								-- Si un event est créé alors..
								if (eventCreate.x ~= 0 and eventCreate.y ~= 0 and eventCreate.z ~= 0) then
									-- On ajoute les anciennes coordonées du joueur
									pSave[player:GetGUIDLow()].map = player:GetMapId();
									pSave[player:GetGUIDLow()].x = player:GetX();
									pSave[player:GetGUIDLow()].y = player:GetY();
									pSave[player:GetGUIDLow()].z = player:GetZ();
									-- Puis on le téléporte
									player:Teleport(eventCreate.map, eventCreate.x, eventCreate.y, eventCreate.z, 0);
								else
									player:SendNotification(Language[5]);
								end
								return false;

					-- Vérification de la commande entrée
					elseif (string.upper(command) == Commands[4]) then
						-- On vérifie que l'event a bien était créé
						if eventCreate.x ~= 0 and eventCreate.y ~= 0 and eventCreate.z ~= 0 then
							-- On téléporte le joueur à l'ancienne coordonée
							 player:Teleport(pSave[player:GetGUIDLow()].map, pSave[player:GetGUIDLow()].x, pSave[player:GetGUIDLow()].y, pSave[player:GetGUIDLow()].z, 0);
						else
							player:SendNotification(Language[5]);
						end
						return false;
					end
				end
			end
	end
