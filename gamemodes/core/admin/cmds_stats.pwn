CMD:setskin(playerid, params[])
{
	new targetid, skin;

	if (Players[playerid][pAdmin] < 2)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "ui", targetid, skin))
	{
	    return SendSyntaxMessage(playerid, "/setskin [playerid/name] [skin]");
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
	else if (!IsValidSkin(skin))
	{
	    return SendErrorMessage(playerid, "You have entered an invalid skin.");
	}
	else
	{
	    Players[targetid][pSkin] = skin;

	    SetPlayerSkin(targetid, Players[targetid][pSkin]);
     	AttachObjectsToPlayer(targetid);

	    SendInfoMessage(playerid, "You have changed %s's skin to %i.", ReturnNameEx(targetid, 0), skin);
	    SendInfoMessage(targetid, "%s has provided you with a new skin (%i).", ReturnNameEx(playerid, 0), skin);
	}
	return 1;
}