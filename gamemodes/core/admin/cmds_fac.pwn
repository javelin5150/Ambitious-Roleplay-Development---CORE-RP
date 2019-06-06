CMD:resetordertime(playerid, params[])
{
	new targetid;

	if (Players[playerid][pAdmin] < 5)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "u", targetid))
	{
	    return SendSyntaxMessage(playerid, "/resetordertime [playerid/name]");
	}
	else if (!IsPlayerConnected(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target doesn't exist.");
	}
	else if (!IsPlayerLoggedIn(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target is not logged in yet.");
	}
	else
	{
		Players[targetid][pPackageTime] = 0;
	    SendInfoMessage(playerid, "You have reset %s's package order time. They can now /orderpackage again.", ReturnNameEx(targetid, 0));
	}
	return 1;
}

CMD:copfix(playerid,params[])
{
	new targetid;

	if(Players[playerid][pAdmin] < 2)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params,"u",targetid))
	{
		return SendSyntaxMessage(playerid, "/copfix [playerid/name]");
	}
	else if (GetPlayerFactionType(targetid) != FACTION_LEO)
	{
		return SendErrorMessage(playerid, "The specified target is not in a law enforcement faction.");
	}
	else if (!IsPlayerConnected(targetid))
	{
		return SendErrorMessage(playerid, "The specified target doesn't exist.");
	}
	else if (IsPlayerNPC(targetid))
	{
		return SendErrorMessage(playerid,"You cannot use this command on a NPC.");
	}
	else if (!IsPlayerLoggedIn(targetid))
	{
		return SendErrorMessage(playerid,"The specified target is not logged in yet.");
	}
	else
	{
		if(Players[playerid][pAdmin] < 6)
		{
			SendAdminMessage(COLOR_RED, "Admin: %s has copfixed %s.", ReturnNameEx(playerid), ReturnNameEx(targetid));
		}
		ShowLockerMenu(targetid);
		SendInfoMessage(targetid,"%s has copfixed you.",ReturnNameEx(playerid));
		SendInfoMessage(playerid,"You have copfixed %s.",ReturnNameEx(targetid));

		new log[128];
		format(log, sizeof(log), "%s has copfixed %s", ReturnName(playerid), ReturnName(targetid));
		CreateLog("admin", log);
	}
	return 1;
}