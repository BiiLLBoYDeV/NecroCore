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

if Script.EventCreator == 1 then
	--[[ LOCAL TABLE ]]--
	local eventCreate = {};
	local pSave = {};

  --[[ LOCAL FUNCTION || eventCommand ]]--
	local function eventCommand(event, player, command)
    if (player:GetGMRank() > 0) then
      if (command == Conf_EventCreatorCommand.c_1) then
        if (not eventCreate) then
          eventCreate = {
            map = 0,
            x = 0,
            y = 0,
            z = 0;
          };
        end
        --
        eventCreate.map = player:GetMapId(); eventCreate.x = player:GetX(); eventCreate.y = player:GetY(); eventCreate.z = player:GetZ();
        --
        player:SendNotification(Conf_EventCreatorText[Conf_EventCreatorConfig.lang].t_1);
        SendWorldMessage(player:GetName()..' ' ..Conf_EventCreatorText[Conf_EventCreatorConfig.lang].t_2);
        return false;

      elseif (command == Conf_EventCreatorCommand.c_2) then
        if eventCreate.x ~= 0 and eventCreate.y ~= 0 and eventCreate.z ~= 0 then
          eventCreate.map = 0; eventCreate.x = 0; eventCreate.y = 0; eventCreate.z = 0;
          --
					player:SendNotification(Conf_EventCreatorText[Conf_EventCreatorConfig.lang].t_3);
					SendWorldMessage(player:GetName()..' '..Conf_EventCreatorText[Conf_EventCreatorConfig.lang].t_4);
        else
          player:SendNotification(Conf_EventCreatorText[Conf_EventCreatorConfig.lang].t_5);
        end
        return false;
			end
    elseif (player:GetGMRank() >= 0 and player:IsInCombat() == false) then
      if (command == Conf_EventCreatorCommand.c_3) then
        if (not pSave[player:GetGUIDLow()]) then
          pSave[player:GetGUIDLow()] = {
            map = 0,
            x = 0,
            y = 0,
            z = 0;
           };
         end
         --
         if (not eventCreate) then
           eventCreate = {
             map = 0,
             x = 0,
             y = 0,
             z = 0;
           };
         end
         --
         if (eventCreate.x ~= 0 and eventCreate.y ~= 0 and eventCreate.z ~= 0) then
 					pSave[player:GetGUIDLow()].map = player:GetMapId();
 					pSave[player:GetGUIDLow()].x = player:GetX();
 					pSave[player:GetGUIDLow()].y = player:GetY();
 					pSave[player:GetGUIDLow()].z = player:GetZ();
          --
 					player:Teleport(eventCreate.map, eventCreate.x, eventCreate.y, eventCreate.z, 0);
 				else
 					player:SendNotification(Conf_EventCreatorText[Conf_EventCreatorConfig.lang].t_5);
 				end
 				return false;

      elseif (command == Conf_EventCreatorCommand.c_4) then
        if eventCreate.x ~= 0 and eventCreate.y ~= 0 and eventCreate.z ~= 0 then
					player:Teleport(pSave[player:GetGUIDLow()].map, pSave[player:GetGUIDLow()].x, pSave[player:GetGUIDLow()].y, pSave[player:GetGUIDLow()].z, 0);
				else
					player:SendNotification(Conf_EventCreatorText[Conf_EventCreatorConfig.lang].t_5);
				end
				return false;
      end
    end
  end
  RegisterPlayerEvent(42, eventCommand)
end
