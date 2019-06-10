CMD:tp(playerid, params[])
{
    if (Players[playerid][pAdmin] < 1)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else
	{
	    Dialog_Show(playerid, Teleport, DIALOG_STYLE_LIST, "{6688FF}Teleports", "Teleport List\nStatic Buildings\nInteriors", "Select", "Cancel");
	}
	return 1;
}

CMD:goto(playerid, params[])
{
	new targetid;

	if (Players[playerid][pAdmin] < 1)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "u", targetid))
	{
	    return SendSyntaxMessage(playerid, "/goto [playerid/name]");
	}
	else if (!IsPlayerConnected(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target doesn't exist.");
	}
	else if (!IsPlayerLoggedIn(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target is not logged in yet.");
	}
	else if (!IsPlayerSpawned(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target is not spawned.");
	}
	else if (!Players[targetid][pSetupInfo])
	{
	    return SendErrorMessage(playerid, "The specified target is setting up their character.");
	}
	else if (Players[targetid][pSpectate] != INVALID_PLAYER_ID)
	{
		return SendErrorMessage(playerid, "The specified target is currently spectating.");
	}
	else
	{
	    TeleportToPlayer(playerid, targetid);
	    SendInfoMessage(playerid, "You have warped to %s's location.", ReturnNameEx(targetid, 0));
	}
	return 1;
}

CMD:get(playerid, params[])
{
	new targetid;

	if (Players[playerid][pAdmin] < 1)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "u", targetid))
	{
	    return SendSyntaxMessage(playerid, "/get [playerid/name]");
	}
	else if (!IsPlayerConnected(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target doesn't exist.");
	}
	else if (IsPlayerNPC(targetid))
	{
	    return SendErrorMessage(playerid, "You cannot use this command on a NPC.");
	}
	else if (!IsPlayerLoggedIn(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target is not logged in yet.");
	}
	else if (!IsPlayerSpawned(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target is not spawned.");
	}
	else if (Players[targetid][pAdmin] > Players[playerid][pAdmin])
	{
	    return SendErrorMessage(playerid, "The specified target has a higher admin level.");
	}
	else
	{
	    TeleportToPlayer(targetid, playerid);
	    SendInfoMessage(playerid, "You have warped %s to your location.", ReturnNameEx(targetid, 0));
	}
	return 1;
}

CMD:sendspawn(playerid, params[])
{
	new targetid;

	if (Players[playerid][pAdmin] < 2)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "u", targetid))
	{
	    return SendSyntaxMessage(playerid, "/sendspawn [playerid/name]");
	}
	else if (!IsPlayerConnected(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target doesn't exist.");
	}
	else if (!IsPlayerLoggedIn(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target is not logged in yet.");
	}
	else if (Players[targetid][pJailType] != 0)
	{
	    return SendErrorMessage(playerid, "The specified target is currently in jail.");
	}
	else if (!IsPlayerSpawned(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target is not spawned.");
	}
	else
	{
	    SendToDefaultSpawn(targetid);
	    SendInfoMessage(playerid, "You have sent %s to the default spawn.", ReturnNameEx(targetid, 0));
	    SendInfoMessage(targetid, "You have been sent to the default spawn.");
	}
	return 1;
}

CMD:setworld(playerid, params[])
{
	new targetid, vw;

	if (Players[playerid][pAdmin] < 2)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "ui", targetid, vw))
	{
	    return SendSyntaxMessage(playerid, "/setworld [playerid/name] [virtual]");
	}
	else if (!IsPlayerConnected(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target doesn't exist.");
	}
	else if (IsPlayerNPC(targetid))
	{
	    return SendErrorMessage(playerid, "You cannot use this command on a NPC.");
	}
	else if (!IsPlayerLoggedIn(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target is not logged in yet.");
	}
	else if (!IsPlayerSpawned(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target is not spawned.");
	}
	else
	{
	    SetPlayerVirtualWorld(targetid, vw);
	    SendInfoMessage(playerid, "You have set %s's virtual world to %i.", ReturnNameEx(targetid, 0), vw);
	}
	return 1;
}

CMD:setint(playerid, params[])
{
	new targetid, interior;

	if (Players[playerid][pAdmin] < 2)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "ui", targetid, interior))
	{
	    return SendSyntaxMessage(playerid, "/setint [playerid/name] [interior]");
	}
	else if (!IsPlayerConnected(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target doesn't exist.");
	}
	else if (IsPlayerNPC(targetid))
	{
	    return SendErrorMessage(playerid, "You cannot use this command on a NPC.");
	}
	else if (!IsPlayerLoggedIn(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target is not logged in yet.");
	}
	else if (!IsPlayerSpawned(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target is not spawned.");
	}
	else
	{
	    SetPlayerInterior(targetid, interior);
	    SendInfoMessage(playerid, "You have set %s's interior to %i.", ReturnNameEx(targetid, 0), interior);
	}
	return 1;
}

CMD:gotocoords(playerid, params[])
{
	new Float:fX, Float:fY, Float:fZ, interior;

	// remove commas so we can copy paste coords without removing commas.
	for (new i = 0, l = strlen(params); i < l; i ++) {
	    if (params[i] == ',') {
			strdel(params, i, i + 1);
		}
	}

	if (Players[playerid][pAdmin] < 2)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "fffI(0)", fX, fY, fZ, interior))
	{
	    return SendSyntaxMessage(playerid, "/gotocoords (x) (y) (z) [interior]");
	}
	else
	{
	    SetPlayerPos(playerid, fX, fY, fZ);
	    SetPlayerInterior(playerid, interior);

	    SetCameraBehindPlayer(playerid);
	    SendInfoMessage(playerid, "You have teleported to %.4f, %.4f, %.4f (interior: %i).", fX, fY, fZ, interior);
	}
	return 1;
}

CMD:vgoto(playerid, params[])
{
	new vehicleid;

	if (Players[playerid][pAdmin] < 2)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "i", vehicleid))
	{
	    return SendSyntaxMessage(playerid, "/vgoto (vehicle)");
	}
	else if (!IsValidVehicle(vehicleid))
	{
	    return SendErrorMessage(playerid, "The specified vehicle doesn't exist.");
	}
	else
	{
	    new
			Float:x,
			Float:y,
			Float:z;

	    GetVehiclePos(vehicleid, x, y, z);
		SetPlayerPos(playerid, x, y, z + 2);

		SetPlayerInterior(playerid, 0);
	    SetPlayerVirtualWorld(playerid, GetVehicleVirtualWorld(vehicleid));

	    SendInfoMessage(playerid, "You have warped to vehicle %i.", vehicleid);
	}
	return 1;
}

CMD:vget(playerid, params[])
{
	new vehicleid;

	if (Players[playerid][pAdmin] < 2)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "i", vehicleid))
	{
	    return SendSyntaxMessage(playerid, "/vget (vehicle)");
	}
	else if (!IsValidVehicle(vehicleid))
	{
	    return SendErrorMessage(playerid, "The specified vehicle doesn't exist.");
	}
	else
	{
	    new
			Float:x,
			Float:y,
			Float:z;

	    GetPlayerPos(playerid, x, y, z);
		SetVehiclePos(vehicleid, x, y, z);

	    SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
	    LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));

	    SendInfoMessage(playerid, "You have warped vehicle %i to your position.", vehicleid);
	}
	return 1;
}
CMD:sendto(playerid, params[])
{
   	new playerb;
	if(Players[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	if(sscanf(params,"us[32]", playerb, params))
	{
	    SendClientMessage(playerid, COLOR_WHITE, "[Usage]: /sendto [playerid] [place]");
	    SendClientMessage(playerid, COLOR_GREY, "PLACES: ls | sf | lv");
	    return 1;
	}
	if(!IsPlayerLoggedIn(playerb)) return SendClientMessage(playerid, COLOR_GREY, "Invalid player id.");
    if(!strcmp(params, "ls", true))
	{
	    SetPlayerInterior(playerb, 0);
	    SetPlayerVirtualWorld(playerb, 0);
	    SetPlayerPos(playerb,1529.6,-1691.2,13.3);
	    SendClientMessage(playerb, COLOR_WHITE, " You have been teleported to Los Santos.");
	}
	else if(!strcmp(params, "sf", true))
	{
	    SetPlayerInterior(playerb, 0);
	    SetPlayerVirtualWorld(playerb, 0);
	    SetPlayerPos(playerb,-2015.261108, 154.379516, 27.687500);
	    SendClientMessage(playerb, COLOR_WHITE, " You have been teleported to San Fierro.");
	}
	else if(!strcmp(params, "lv", true))
	{
	    SetPlayerInterior(playerb, 0);
	    SetPlayerVirtualWorld(playerb, 0);
	    SetPlayerPos(playerid,1699.2,1435.1, 10.7);
	    SendClientMessage(playerb, COLOR_WHITE, " You have been teleported to Las Venturas.");
	}
	return 1;
}
