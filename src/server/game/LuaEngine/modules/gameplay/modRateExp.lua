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

if (Script.ModExp == 1) then

	local m_exp = {};

	local function OnConnect(event, player)
		local pGuid = player:GetGUIDLow()
		if not(m_exp[pGuid])then
			m_exp[pGuid] = {
				mod_exp = 1;
			}
		end
		local GetRateExp = CharDBQuery('SELECT rate FROM '..Conf_modRateExpConfig.db..'.'..Conf_modRateExpConfig.table..' WHERE guid = '..pGuid..';')
		if GetRateExp ~= nil then
			m_exp[pGuid].mod_exp = GetRateExp:GetUInt32(0)
		else
			local AddRateExp = CharDBQuery('INSERT INTO '..Conf_modRateExpConfig.db..'.'..Conf_modRateExpConfig.table..' (guid, rate) VALUES ('..pGuid..', 1);')
			m_exp[pGuid].mod_exp = 1
		end
	end
	RegisterPlayerEvent(3, OnConnect)

	local function OnDisconnect(event, player)
		local pGuid = player:GetGUIDLow()
		if not(m_exp[pGuid])then
			m_exp[pGuid] = {
				mod_exp = 1;
			}
		end
		local SaveRateExp = CharDBQuery('UPDATE '..Conf_modRateExpConfig.db..'.'..Conf_modRateExpConfig.table..' SET rate = '..m_exp[pGuid].mod_exp..' WHERE guid = '..pGuid..';')
	end
	RegisterPlayerEvent(4, OnDisconnect)

	local function OnReceiveExp(event, player, amount, victim)
		local pGuid = player:GetGUIDLow()
		if not(m_exp[pGuid])then
			m_exp[pGuid] = {
				mod_exp = 1;
			}
		end

		return amount * m_exp[pGuid].mod_exp
	end
	RegisterPlayerEvent(12, OnReceiveExp)

	local function GetAllPlayerExp(event)
		for i, player in ipairs(GetPlayersInWorld()) do
			OnConnect(event, player)
		end
	end
	RegisterServerEvent(33, GetAllPlayerExp)

	local function SaveAllPlayerExp(event)
		for i, player in ipairs(GetPlayersInWorld()) do
			OnDisconnect(event, player)
		end
	end
	RegisterServerEvent(16, SaveAllPlayerExp)

	--[[

	NPC SECTION

	]]--

	local NpcEntry = 45000;
	local function OnGossipHello(event, player, object)
		player:GossipClearMenu()
		player:GossipSetText(Conf_modRateExpText[Conf_modRateExpConfig.lang].t_1)
		player:GossipMenuAddItem(4, Conf_modRateExpText[Conf_modRateExpConfig.lang].t_2..' 1', 1, 100)
		player:GossipMenuAddItem(4, Conf_modRateExpText[Conf_modRateExpConfig.lang].t_2..' 2', 1, 101)
		player:GossipMenuAddItem(4, Conf_modRateExpText[Conf_modRateExpConfig.lang].t_2..' 3', 1, 102)

		player:GossipSendMenu(0x7FFFFFFF, object)
	end
	RegisterCreatureGossipEvent(NpcEntry, 1, OnGossipHello)

	local function OnGossipSelect(event, player, object, sender, intid, code, menu_id)
		local pGuid = player:GetGUIDLow()
		if not(m_exp[pGuid])then
			m_exp[pGuid] = {
				mod_exp = 1;
			}
		end
		--
		if intid == 100 then
			m_exp[pGuid].mod_exp = 1;
			player:SendNotification(Conf_modRateExpText[Conf_modRateExpConfig.lang].t_3..' x1.')
			player:GossipComplete()
		elseif intid == 101 then
			m_exp[pGuid].mod_exp = 2;
			player:SendNotification(Conf_modRateExpText[Conf_modRateExpConfig.lang].t_3..' x2.')
			player:GossipComplete()
		elseif intid == 102 then
			m_exp[pGuid].mod_exp = 3;
			player:SendNotification(Conf_modRateExpText[Conf_modRateExpConfig.lang].t_3..' x3.')
			player:GossipComplete()
		end
		OnDisconnect(event, player)
	end
	RegisterCreatureGossipEvent(NpcEntry, 2, OnGossipSelect)
end
