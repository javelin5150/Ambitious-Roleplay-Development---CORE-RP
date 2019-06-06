CMD:reports(playerid, params[])
{
    if (Players[playerid][pAdmin] < 1)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else
	{
		new success = ListReports(playerid);

		if (!success)
		{
		    return SendErrorMessage(playerid, "There are no reports in the queue.");
	    }
	}
	return 1;
}

CMD:spec(playerid, params[])
{
	new targetid;

	if (Players[playerid][pAdmin] < 1)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (!strcmp(params, "off", true))
	{
	    if (IsPlayerSpectating(playerid))
		{
		    SpectatePlayer(playerid, INVALID_PLAYER_ID);
		    SendInfoMessage(playerid, "You have turned off spectator mode.");
		}
		else
		{
		    SendErrorMessage(playerid, "You are not spectating.");
	    }
	}
	else if (sscanf(params, "u", targetid))
	{
	    return SendSyntaxMessage(playerid, "/spec [playerid/name]");
	}
	else if (!IsPlayerConnected(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target doesn't exist.");
	}
	else if (!IsPlayerLoggedIn(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target is not logged in yet.");
	}
	else if (targetid == playerid)
	{
	    return SendErrorMessage(playerid, "You can't spectate yourself.");
	}
	else
	{
	    if (Players[targetid][pAdmin] >= 6)
		{
		    SendInfoMessage(targetid, "%s is now spectating you.", ReturnNameEx(playerid, 0));
	    }
	    if (!IsPlayerSpectating(playerid))
	    {
         	SavePositionAndHealth(playerid);
	    }
		SpectatePlayer(playerid, targetid);
		SendInfoMessage(playerid, "You are now watching %s (use \"/spec off\" to disable).", ReturnNameEx(targetid, 0));

		new log[128];
		format(log, sizeof(log), "%s has started spectating %s", ReturnName(playerid), ReturnName(targetid));
		CreateLog("admin", log);
	}
	return 1;
}

CMD:anote(playerid, params[])
{
	new targetid, reason[128];

	if (Players[playerid][pAdmin] < 1)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "us[128]", targetid, reason))
	{
		return SendSyntaxMessage(playerid, "/anote [playerid/name] [text]");
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
	else
	{
		new notereason[128];
        format(notereason, sizeof(notereason), "Anote: \"%s\"", reason );

        format(gExecute, sizeof(gExecute), "INSERT INTO rp_anotes (Player, PlayerName, Reason, Date, IssuerID, Issuer) VALUES(%i, '%s', '%s', NOW(), %i, '%s')", Players[targetid][pID], ReturnName(targetid), mysql_escaped(notereason), Players[playerid][pID], ReturnName(playerid));
	    mysql_tquery(gConnection, gExecute);

	    SendInfoMessage(playerid, "You have added an admin note to %s.", ReturnName(targetid));
		SendInfoMessage(playerid, "Anote: \"%s\"", reason);

		new log[128];
		format(log, sizeof(log), "%s has added an admin note to %s: %s", ReturnName(playerid), ReturnName(targetid), reason);
		CreateLog("admin", log);
	}
	return 1;
}

CMD:anotes(playerid, params[])
{
	new targetid;

	if (Players[playerid][pAdmin] < 1)
	{
		return SendErrorMessage(playerid, "You are nott privileged to use this command.");
	}
	else if (sscanf(params, "u", targetid))
	{
		return SendSyntaxMessage(playerid, "/anotes [playerid/name]");
	}
	else
	{
		ShowANoteList(targetid, playerid);
	}
	return 1;
}

CMD:deathlogs(playerid, params[])
{
	if (Players[playerid][pAdmin] < 1)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else
	{
		ShowDeathLogs(playerid);
	}
	return 1;
}

CMD:banlogs(playerid, params[])
{
	if (Players[playerid][pAdmin] < 2)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else
	{
		ShowBanLogs(playerid);
	}
	return 1;
}

CMD:checkbank(playerid, params[])
{
	new targetid;

	if (Players[playerid][pAdmin] < 2)
		return SendErrorMessage(playerid, "You are not privileged to use this command.");

	if (sscanf(params, "u", targetid))
		return SendSyntaxMessage(playerid, "/checkbank [playerid/name]");

	if (!IsPlayerConnected(targetid))
		return SendErrorMessage(playerid, "The specified target doesn't exist.");

	if (Players[targetid][pAdmin] > Players[playerid][pAdmin])
		return SendErrorMessage(playerid, "The specified target has a higher admin level.");

	CheckBank(playerid,targetid);

	new log[128];
	format(log, sizeof(log), "%s has checked %s's bank", ReturnName(playerid), ReturnName(targetid));
	CreateLog("admin", log);

	return 1;
}

CMD:revive(playerid, params[])
{
	new targetid;

	if (Players[playerid][pAdmin] < 1)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "u", targetid))
	{
	    return SendSyntaxMessage(playerid, "/revive [playerid/name]");
	}
	else if (!IsPlayerConnected(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target doesn't exist.");
	}
	else if (!IsPlayerLoggedIn(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target is not logged in yet.");
	}
	else if (Players[targetid][pDeathState] != DEATH_STATE_INJURED)
	{
	    return SendErrorMessage(playerid, "The specified target is not injured.");
	}
	else
	{
		DestroyDynamic3DTextLabel(Players[targetid][pInjuredText]);
		Players[targetid][pInjuredText] = INVALID_3DTEXT_ID;

		Players[targetid][pDeathState] = DEATH_STATE_NONE;
        Players[targetid][pBleeding] = 0;
        Players[targetid][pBrokenLeg] = 0;

	    SetPlayerHealth(targetid, 100);
	    ResetLastShots(targetid);

		ClearAnimations(targetid, 1);
		TogglePlayerControllable(targetid, 1);

	    SendInfoMessage(playerid, "You have revived %s.", ReturnNameEx(targetid, 0));
	    SendInfoMessage(targetid, "%s has revived you. You are no longer injured!", ReturnNameEx(playerid, 0));

	    new log[128];
		format(log, sizeof(log), "%s has revived %s", ReturnName(playerid), ReturnName(targetid));
		CreateLog("admin", log);

	}
	return 1;
}

CMD:aheal(playerid, params[])
{
	new targetid;

	if (Players[playerid][pAdmin] < 2)
		return SendErrorMessage(playerid, "You are not privileged to use this command.");

	if (sscanf(params,"u",targetid))
		return SendSyntaxMessage(playerid, "/aheal [playerid/name]");

	if (!IsPlayerConnected(targetid))
		return SendErrorMessage(playerid, "The specified target doesn't exist.");

	if (!IsPlayerLoggedIn(targetid))
		return SendErrorMessage(playerid, "The specified target is not logged in yet.");

	if (Players[playerid][pDeathState] == DEATH_STATE_INJURED)
	{
		DestroyDynamic3DTextLabel(Players[targetid][pInjuredText]);

		Players[targetid][pDeathState] = DEATH_STATE_NONE;
		Players[targetid][pInjuredText] = INVALID_3DTEXT_ID;
        Players[targetid][pBleeding] = 0;
        Players[targetid][pBrokenLeg] = 0;

	    SetPlayerHealth(targetid, 100);
	    ResetLastShots(targetid);

		ClearAnimations(targetid, 1);
		TogglePlayerControllable(targetid, 1);

	    SendInfoMessage(playerid, "You have revived %s.", ReturnNameEx(targetid, 0));
	    SendInfoMessage(targetid, "%s has revived you. You are no longer injured!", ReturnNameEx(playerid, 0));

	    AdminDutyMessage(COLOR_RED, "Admin: %s has revived %s.", ReturnNameEx(playerid), ReturnNameEx(targetid));
	}
	else 
	{
		SetPlayerHealth(targetid, 100);
		Players[targetid][pBleeding] = 0;
		Players[targetid][pBrokenLeg] = 0;

		SendInfoMessage(playerid, "You have healed %s.", ReturnNameEx(targetid, 0));
		SendInfoMessage(targetid, "%s has healed you.", ReturnNameEx(playerid, 0));

		AdminDutyMessage(COLOR_RED, "Admin: %s has healed %s.", ReturnNameEx(playerid), ReturnNameEx(targetid));

		new log[128];
		format(log, sizeof(log), "%s has healed %s", ReturnName(playerid), ReturnName(targetid));
		CreateLog("admin", log);

	}
	return 1;
}

CMD:jetpack(playerid, params[])
{
    if (Players[playerid][pAdmin] < 2)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (!Players[playerid][pAdminDuty])
	{
	    return SendErrorMessage(playerid, "You must be on admin duty to use this command.");
	}
	else
	{
	    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
	    SendInfoMessage(playerid, "You have spawned yourself a jetpack!");

	    new log[128];
		format(log, sizeof(log), "%s has spawned a jetpack", ReturnName(playerid));
		CreateLog("admin", log);
	}
	return 1;
}

CMD:cleartickets(playerid, params[])
{
	new targetid;

	if (Players[playerid][pAdmin] < 5)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "u", targetid))
	{
	    return SendSyntaxMessage(playerid, "/cleartickets [playerid/name]");
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
	    format(gExecute, sizeof(gExecute), "DELETE FROM rp_tickets WHERE Player = %i", Players[targetid][pID]);
	    mysql_tquery(gConnection, gExecute);

	    SendAdminMessage(COLOR_RED, "Admin: %s has cleared %s's tickets.", ReturnNameEx(playerid, 0), ReturnNameEx(targetid, 0));

	    new log[128];
		format(log, sizeof(log), "%s has cleared %s's tickets", ReturnName(playerid), ReturnName(targetid));
		CreateLog("admin", log);
	}
	return 1;
}

CMD:adminheal(playerid, params[])
{
	new targetid;

	if (Players[playerid][pAdmin] < 2)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "u", targetid))
	{
	    return SendSyntaxMessage(playerid, "/adminheal [playerid/name]");
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
	    SetPlayerHealth(targetid, 100);

	    Players[targetid][pBleeding] = 0;
	    Players[targetid][pBrokenLeg] = 0;

	    SendInfoMessage(playerid, "You have healed %s.", ReturnNameEx(targetid, 0));
	    SendInfoMessage(targetid, "You have been healed by %s.", ReturnNameEx(playerid, 0));
	}
	return 1;
}

CMD:check(playerid, params[])
{
	new targetid;

	if (Players[playerid][pAdmin] < 2)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "u", targetid))
	{
	    return SendSyntaxMessage(playerid, "/check [playerid/name]");
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
	else
	{
		ShowStatsForPlayer(targetid, playerid);

		new log[128];
		format(log, sizeof(log), "%s has checked %s's stats", ReturnName(playerid), ReturnName(targetid));
		CreateLog("admin", log);
	}
	return 1;
}

CMD:removeitem(playerid, params[])
{
	new targetid, index;

	if (Players[playerid][pAdmin] < 2)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "u", targetid))
	{
	    return SendSyntaxMessage(playerid, "/removeitem [playerid/name]");
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
	else
	{
	    gListString[0] = 0;

	    for (new i = 0; i < MAX_INVENTORY_ITEMS; i ++)
		{
	        if (Inventory[targetid][i][invExists])
	        {
	            format(gListString, sizeof(gListString), "%s\n* %s", gListString, GetFullItemName(targetid, i));
	            gListedItems[playerid][index++] = i;
			}
		}
		if (index)
		{
		    Players[playerid][pTarget] = targetid;
			Dialog_Show(playerid, RemoveItems, DIALOG_STYLE_LIST, "{6688FF}List of items", gListString, "Remove", "Close");
		}
		else
		{
		    SendErrorMessage(playerid, "The specified target doesn't have any items.");
		}
	}
	return 1;
}

CMD:listitems(playerid, params[])
{
	new targetid, index;

	if (Players[playerid][pAdmin] < 2)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "u", targetid))
	{
	    return SendSyntaxMessage(playerid, "/listitems [playerid/name]");
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
	else
	{
	    gListString[0] = 0;

	    for (new i = 0; i < MAX_INVENTORY_ITEMS; i ++)
		{
	        if (Inventory[targetid][i][invExists])
	        {
	            format(gListString, sizeof(gListString), "%s\n* %s", gListString, GetFullItemName(targetid, i));
	            gListedItems[playerid][index++] = i;
			}
		}
		if (index)
		{
			Dialog_Show(playerid, ListItems, DIALOG_STYLE_LIST, "{6688FF}List of items", gListString, "Close", "");
		}
		else
		{
		    SendErrorMessage(playerid, "The specified target doesn't have any items.");
		}
	}
	return 1;
}
