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



--[[ Verification Modules Active ]]--
require('modules_active');
if (Script.Mod_EventCreator == 1)then

	--[[

		DEBUT DU SCRIPT

	]]--

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
					if (string.upper(command) == 'EVENT CREATE') then
						-- On ajoute les coordonées lors de la creation de l'Event
				    eventCreate.map = player:GetMapId(); eventCreate.x = player:GetX(); eventCreate.y = player:GetY(); eventCreate.z = player:GetZ();
						-- On envoie un message à tout les joueurs
						player:SendNotification('Event créé avec succés!');
						SendWorldMessage(player:GetName()..' viens de créer un event, si vous souhaitez y participer : .event join\nPour sortir de l\'event un simple .event leave vous permet de vous téléporter à votre ancienne localisation.');
						return false;

					-- Vérification de la commande entrée
					elseif (string.upper(command) == 'EVENT DELETE') then
						-- On vérifie que l'event a bien était créé
						if eventCreate.x ~= 0 and eventCreate.y ~= 0 and eventCreate.z ~= 0 then
							-- On supprime les coordonées lors de la destruction de l'Event
							eventCreate.map = 0; eventCreate.x = 0; eventCreate.y = 0; eventCreate.z = 0;
							player:SendNotification('Event supprimé avec succés!');
			        SendWorldMessage(player:GetName()..' viens de créer son event, vous ne pouvez plus y participer!');
						else
							player:SendNotification('Aucun event n\'as été créé pour le moment!');
						end
						return false;
					end
				end

				-- Vérification des rangs || Hors Combats
				if (player:GetGMRank() >= 0 and player:IsInCombat() == false) then
					-- Vérification de la commande entrée
					if (string.upper(command) == 'EVENT JOIN') then
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
				        	player:SendNotification('Aucun event n\'as été créé pour le moment!');
				      	end
				      	return false;

					-- Vérification de la commande entrée
					elseif (string.upper(command) == 'EVENT LEAVE') then
						-- On vérifie que l'event a bien était créé
						if eventCreate.x ~= 0 and eventCreate.y ~= 0 and eventCreate.z ~= 0 then
							-- On téléporte le joueur à l'ancienne coordonée
							 player:Teleport(pSave[player:GetGUIDLow()].map, pSave[player:GetGUIDLow()].x, pSave[player:GetGUIDLow()].y, pSave[player:GetGUIDLow()].z, 0);
						else
							player:SendNotification('Aucun Event n\'as été créé pour le moment!');
						end
						return false;
					end
				end
			end

		--[[

			Event Command

		]]--
			RegisterPlayerEvent(42, eventCommand);

	--[[

		FIN DU SCRIPT

	]]--
end
