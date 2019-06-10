CMD:warn(playerid, params[])
{
	new targetid, reason[128];

	if (Players[playerid][pAdmin] < 1)
	{
	    return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "us[128]", targetid, reason))
	{
	    return SendSyntaxMessage(playerid, "/warn [playerid/name] [reason]");
	}
	else if (!IsPlayerConnected(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target doesn't exist.");
	}
	else
	{
	    SendFormatMessage(targetid, COLOR_RED, "Warning: %s", reason);
	    SendFormatMessage(playerid, COLOR_RED, "Warning to %s: %s", ReturnNameEx(targetid, 0), reason);
	}
	return 1;
}

CMD:kick(playerid, params[])
{
	new targetid, reason[128];

	if (Players[playerid][pAdmin] < 1 && Players[playerid][pSupporter] < 1 && Players[playerid][pVeteran] < 1)
	{
	    return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "us[128]", targetid, reason))
	{
	    return SendSyntaxMessage(playerid, "/kick [playerid/name] [reason]");
	}
	else if (!IsPlayerConnected(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target doesn't exist.");
	}
	else if (Players[targetid][pAdmin] > Players[playerid][pAdmin])
	{
	    return SendErrorMessage(playerid, "The specified target has a higher admin level.");
	}
	else
	{
	    AddPunishment(targetid, ReturnName(playerid), "Kick", reason);

		format(gExecute, sizeof(gExecute), "INSERT INTO rp_kicklogs (Admin, Player, Reason, Date) VALUES('%s', '%s', '%s', NOW())", ReturnName(playerid), ReturnName(targetid), mysql_escaped(reason));
		mysql_tquery(gConnection, gExecute);

  		SendFormatMessageToAll(COLOR_RED, "Admin: %s was kicked by %s, reason: \"%s\"", ReturnNameEx(targetid, 0), ReturnAdminName(playerid), reason);
		Dialog_Show(targetid, Kick, DIALOG_STYLE_MSGBOX, "{6688FF}You've been kicked!", "You have been kicked from the server.\n\nAdmin: %s\nReason: %s\nDate: %s\n\nSince this is only a kick, you may rejoin the server.\nPlease do not break any further rules or you may be banned.", "Close", "", ReturnAdminName(playerid), reason, GetDateAndTime());

	    KickPlayer(targetid);

	    new notereason[128];
        format(notereason, sizeof(notereason), "Kick: \"%s\"", reason );

        format(gExecute, sizeof(gExecute), "INSERT INTO rp_anotes (Player, Reason, Date, Issuer) VALUES(%i, '%s', NOW(), '%s')", Players[targetid][pID], mysql_escaped(notereason), ReturnAdminName(playerid));
	    mysql_tquery(gConnection, gExecute);
	}
	return 1;
}

CMD:ajail(playerid, params[])
{
	new targetid, minutes, reason[128];

	if (Players[playerid][pAdmin] < 1)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "uis[128]", targetid, minutes, reason))
	{
	    return SendSyntaxMessage(playerid, "/ajail [playerid/name] [minutes] [reason]");
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
	else if (minutes < 1)
	{
	    return SendErrorMessage(playerid, "The minutes can't be below 1 - use /unjail for that.");
	}
	else if (Players[playerid][pSupporter] > 0 && !Players[playerid][pAdmin] && (minutes < 1 || minutes > 120))
	{
		return SendErrorMessage(playerid, "The specified minute interval must be between 1 and 120.");
	}
	else if (Players[targetid][pAdmin] > Players[playerid][pAdmin])
	{
	    return SendErrorMessage(playerid, "The specified target has a higher admin level.");
	}
	else
	{
	    new
	        string[128];

		format(string, sizeof(string), "%s (%i minutes)", reason, minutes);
	    AddPunishment(targetid, ReturnName(playerid), "Admin Jail", string);

	    Players[targetid][pJailType] = 1;
	    Players[targetid][pJailTime] = minutes * 60;

		SendFormatMessageToAll(COLOR_RED, "Admin: %s was jailed by %s, reason: \"%s\"", ReturnNameEx(targetid, 0), ReturnAdminName(playerid), reason);
		Dialog_Show(targetid, Jailed, DIALOG_STYLE_MSGBOX, "{6688FF}You've been jailed!", "You have been sent to admin jail for %i minutes.\n\nAdmin: %s\nReason: %s\nDate: %s\n\nPlease avoid breaking rules to avoid being jailed.", "Close", "", minutes, ReturnAdminName(playerid), reason, GetDateAndTime());

		ResetPlayer(targetid);
        SpawnPlayerInJail(targetid);

        new notereason[128];
        format(notereason, sizeof(notereason), "Ajail: %i minutes for: \"%s\"", minutes, reason );

        format(gExecute, sizeof(gExecute), "INSERT INTO rp_anotes (Player, Reason, Date, Issuer) VALUES(%i, '%s', NOW(), '%s')", Players[targetid][pID], mysql_escaped(notereason), ReturnAdminName(playerid));
	    mysql_tquery(gConnection, gExecute);
	}
	return 1;
}

CMD:release(playerid, params[])
{
	return cmd_unjail(playerid, params);
}

CMD:unjail(playerid, params[])
{
	new targetid;

	if (Players[playerid][pAdmin] < 1)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "u", targetid))
	{
	    return SendSyntaxMessage(playerid, "/unjail [playerid/name]");
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
	else if (!Players[targetid][pJailType])
	{
	    return SendErrorMessage(playerid, "The specified target is not in jail.");
	}
	else
	{
	    Players[targetid][pJailTime] = 1;
	    SendFormatMessageToAll(COLOR_RED, "Admin: %s was released from jail by %s.", ReturnNameEx(targetid, 0), ReturnAdminName(playerid));
	}
	return 1;
}

CMD:slap(playerid, params[])
{
	new targetid, Float:x, Float:y, Float:z;

	if (Players[playerid][pAdmin] < 1)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "u", targetid))
	{
	    return SendSyntaxMessage(playerid, "/slap [playerid/name]");
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
	else if (Players[targetid][pAdmin] > Players[playerid][pAdmin])
	{
	    return SendErrorMessage(playerid, "The specified target has a higher admin level.");
	} else if(IsPlayerInAnyVehicle(targetid)) {
		return SendErrorMessage(playerid, "That user is in a vehicle.");
	}
	else
	{
	    GetPlayerPos(targetid, x, y, z);
	    SetPlayerPos(targetid, x, y, z + 5);

		PlayerPlaySound(targetid, 1130, 0.0, 0.0, 0.0);
	    SendAdminMessage(COLOR_RED, "Admin: %s was slapped by %s.", ReturnNameEx(targetid, 0), ReturnAdminName(playerid));
	}
	return 1;
}

CMD:mute(playerid, params[])
{
	new targetid;

	if (Players[playerid][pAdmin] < 1)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "u", targetid))
	{
	    return SendSyntaxMessage(playerid, "/mute [playerid/name]");
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
	else if (Players[targetid][pMuted])
	{
	    return SendErrorMessage(playerid, "The specified target is already muted. Use /unmute to unmute that player.");
	}
	else
	{
	    Players[targetid][pMuted] = 1;

	    SendAdminMessage(COLOR_RED, "Admin: %s was muted by %s.", ReturnNameEx(targetid, 0), ReturnAdminName(playerid));
	    SendInfoMessage(targetid, "You've been muted by an admin.");
	}
	return 1;
}

CMD:unmute(playerid, params[])
{
	new targetid;

	if (Players[playerid][pAdmin] < 1)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "u", targetid))
	{
	    return SendSyntaxMessage(playerid, "/unmute [playerid/name]");
	}
	else if (!IsPlayerConnected(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target doesn't exist.");
	}
	else if (!IsPlayerLoggedIn(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target is not logged in yet.");
	}
	else if (!Players[targetid][pMuted])
	{
	    return SendErrorMessage(playerid, "The specified target is not muted.");
	}
	else if (IsPlayerNPC(targetid))
	{
	    return SendErrorMessage(playerid, "You cannot use this command on a NPC.");
	}
	else
	{
	    Players[targetid][pMuted] = 0;

	    SendAdminMessage(COLOR_RED, "Admin: %s was unmuted by %s.", ReturnNameEx(targetid, 0), ReturnAdminName(playerid));
	    SendInfoMessage(targetid, "You've been unmuted by an admin.");
	}
	return 1;
}

CMD:freeze(playerid, params[])
{
	new targetid;

	if (Players[playerid][pAdmin] < 1)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "u", targetid))
	{
	    return SendSyntaxMessage(playerid, "/freeze [playerid/name]");
	}
	else if (!IsPlayerConnected(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target doesn't exist.");
	}
	else if (IsPlayerNPC(targetid))
	{
	    return SendErrorMessage(playerid, "You cannot use this command on a NPC.");
	}
	else
	{
	    TogglePlayerControllable(targetid, false);

	    SendAdminMessage(COLOR_RED, "Admin: %s was frozen by %s.", ReturnNameEx(targetid, 0), ReturnAdminName(playerid));
	    SendInfoMessage(targetid, "You've been frozen by an admin.");
	}
	return 1;
}

CMD:unfreeze(playerid, params[])
{
	new targetid;

	if (Players[playerid][pAdmin] < 1)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "u", targetid))
	{
	    return SendSyntaxMessage(playerid, "/unfreeze [playerid/name]");
	}
	else if (!IsPlayerConnected(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target doesn't exist.");
	}
	else
	{
	    TogglePlayerControllable(targetid, true);

	    SendAdminMessage(COLOR_RED, "Admin: %s was unfrozen by %s.", ReturnNameEx(targetid, 0), ReturnAdminName(playerid));
	    SendInfoMessage(targetid, "You've been unfrozen by an admin.");
	}
	return 1;
}

CMD:ban(playerid, params[])
{
	new targetid, reason[128];

	if (Players[playerid][pAdmin] < 1)
	{
	    return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "us[128]", targetid, reason))
	{
	    return SendSyntaxMessage(playerid, "/ban [playerid/name] [reason]");
	}
	else if (!IsPlayerConnected(targetid))
	{
	    return SendErrorMessage(playerid, "The specified target doesn't exist.");
	}
	else if (Players[targetid][pAdmin])
	{
	    return SendErrorMessage(playerid, "You cannot ban another administrator.");
	}
	else
	{
	    AddToBlacklist(targetid, ReturnName(playerid), reason);

		SendFormatMessageToAll(COLOR_RED, "Admin: %s was banned by %s, reason: \"%s\"", ReturnNameEx(targetid, 0), ReturnAdminName(playerid), reason);
		Dialog_Show(targetid, Kick, DIALOG_STYLE_MSGBOX, "{6688FF}You've been banned!", "You have been banned from the server.\n\nAdmin: %s\nReason: %s\nDate: %s\n\nYou can appeal this ban on our website at %s.", "Close", "", ReturnAdminName(playerid), reason, GetDateAndTime(), SERVER_WEBSITE);

		new notereason[128];
        format(notereason, sizeof(notereason), "Ban: \"%s\"", reason );

        format(gExecute, sizeof(gExecute), "INSERT INTO rp_anotes (Player, Reason, Date, Issuer) VALUES(%i, '%s', NOW(), '%s')", Players[targetid][pID], mysql_escaped(notereason), ReturnAdminName(playerid));
	    mysql_tquery(gConnection, gExecute);
	}
	return 1;
}

CMD:unban(playerid, params[])
{
	if (Players[playerid][pAdmin] < 2)
	{
	    return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else
	{
		ShowBanList(playerid);
	}
	return 1;
}
