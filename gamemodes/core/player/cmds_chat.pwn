CMD:s(playerid, params[])
{
	if (isnull(params))
	{
	    return SendSyntaxMessage(playerid, "/s [shout text]");
	}
	else if (Players[playerid][pMuted])
	{
	    return SendErrorMessage(playerid, "You cannot use this command since you're muted.");
	}
	SendDistanceMessage(playerid, 30.0, COLOR_WHITE, "%s shouts: %s", ReturnNameEx(playerid), params);

	new text[128];
    format(text,sizeof(text),"%s shouts: %s", ReturnNameEx(playerid), params);
    AddChatLog(playerid, "/s", text);

    new log[128];
	format(log, sizeof(log), "(/s) %s shouts: %s", ReturnName(playerid), params);
	CreateLog("local", log);

	foreach (new i : Player)
	{
		if (Players[i][pBigEars])
		{
			SendSplitMessage(i, COLOR_WHITE, "%s shouts: %s", ReturnNameEx(playerid), params);
		}
	}

	return 1;
}

CMD:b(playerid, params[])
{
	if (isnull(params))
	{
	    return SendSyntaxMessage(playerid, "/b [local OOC]");
	}
	else if (Players[playerid][pMuted])
	{
	    return SendErrorMessage(playerid, "You cannot use this command since you're muted.");
	}
	if (Players[playerid][pAdminDuty] > 0)
	{
	    //SendDistanceMessage(playerid, 20.0, COLOR_LIGHTGREY, "(( [%i] {%06x}%s{CFCFCF} says: %s ))", playerid, GetPlayerColor(playerid) >>> 8, ReturnNameEx(playerid), params);
	    SendDistanceMessage(playerid, 20.0, COLOR_LIGHTGREY, "(( [%i] {E8AF0E}%s{CFCFCF} says: %s ))", playerid, ReturnAdminName(playerid), params);

	    new log[128];
		format(log, sizeof(log), "(/b-aduty) %s says: %s", ReturnName(playerid), params);
		CreateLog("local", log);
	}
	else
	{
		SendDistanceMessage(playerid, 20.0, COLOR_LIGHTGREY, "(( [%i] %s says: %s ))", playerid, ReturnNameEx(playerid, 0), params);

		new text[128];
	    format(text,sizeof(text),"(( [%i] %s says: %s ))", playerid, ReturnNameEx(playerid, 0), params);
	    AddChatLog(playerid, "/b", text);

	    new log[128];
		format(log, sizeof(log), "(/b) %s says: %s", ReturnName(playerid), params);
		CreateLog("local", log);

		foreach (new i : Player)
		{
			if (Players[i][pBigEars])
			{
				SendSplitMessage(i, COLOR_LIGHTGREY, "(( [%i] %s says: %s ))", playerid, ReturnNameEx(playerid, 0), params);
			}
		}

	}
	return 1;
}

CMD:carwhisper(playerid, params[])
{
	return cmd_cw(playerid, params);
}

CMD:cw(playerid, params[])
{
	if (isnull(params))
	{
	    return SendSyntaxMessage(playerid, "/(c)ar(w)hisper [text]");
	}
	else if (!IsWindowedVehicle(GetPlayerVehicleID(playerid)))
	{
	    return SendErrorMessage(playerid, "You need to be in a vehicle with windows.");
	}
	else
	{
	    SendVehicleMessage(GetPlayerVehicleID(playerid), COLOR_YELLOW, "%s whispers: %s", ReturnNameEx(playerid), params);

	    new log[128];
		format(log, sizeof(log), "(/cw) %s whispers: %s", ReturnName(playerid), params);
		CreateLog("local", log);

		foreach (new i : Player)
		{
			if (Players[i][pBigEars])
			{
				SendSplitMessage(i, COLOR_YELLOW, "%s whispers: %s", ReturnNameEx(playerid), params);
			}
		}

	}
	return 1;
}

CMD:doorshout(playerid, params[])
{
	return cmd_ds(playerid, params);
}

CMD:ds(playerid, params[])
{
	new house = GetNearbyHouse(playerid);

	if (isnull(params))
	{
	    return SendSyntaxMessage(playerid, "/(d)oor(s)hout [shout text]");
	}
	else if (Players[playerid][pMuted])
	{
	    return SendErrorMessage(playerid, "You cannot use this command since you're muted.");
	}
	else if (house == INVALID_ID)
	{
	    return SendErrorMessage(playerid, "There is no house nearby.");
	}
	else
	{
		if ((house = GetClosestHouse(playerid)) != INVALID_ID)
		{
			foreach (new i : Player)
			{
				if (GetCurrentHouse(i) == house)
				{
				    SendSplitMessage(i, COLOR_WHITE, "%s shouts: %s" , ReturnNameEx(playerid), params);
				}
			}
		}
		else if ((house = GetCurrentHouse(playerid)) != INVALID_ID)
		{
			foreach (new i : Player)
			{
				if (GetClosestHouse(i) == house)
				{
				    SendSplitMessage(i, COLOR_WHITE, "%s shouts: %s" , ReturnNameEx(playerid), params);
				}
			}
		}
		SendDistanceMessage(playerid, 30.0, COLOR_WHITE, "%s shouts: %s", ReturnNameEx(playerid), params);

		new log[128];
		format(log, sizeof(log), "(/ds) %s shouts: %s", ReturnName(playerid), params);
		CreateLog("local", log);

		foreach (new i : Player)
		{
			if (Players[i][pBigEars])
			{
				SendSplitMessage(i, COLOR_WHITE, "%s shouts: %s", ReturnNameEx(playerid), params);
			}
		}

	}
	return 1;
}

CMD:l(playerid, params[])
{
	return cmd_local(playerid,params);
}

CMD:local(playerid, params[])
{
	if (isnull(params))
		return SendSyntaxMessage(playerid, "/(l)ocal [local chat]");

	if (Players[playerid][pMuted])
		return SendErrorMessage(playerid, "You cannot use this command since you're muted.");

	SendDistanceMessage(playerid, 20.0, COLOR_WHITE, "%s says: %s", ReturnNameEx(playerid), params);

	new log[128];
	format(log, sizeof(log), "(/l) %s says: %s", ReturnName(playerid), params);
	CreateLog("local", log);

	foreach (new i : Player)
	{
		if (Players[i][pBigEars])
		{
			SendSplitMessage(i, COLOR_WHITE, "%s says: %s", ReturnNameEx(playerid), params);
		}
	}

	return 1;
}

CMD:low(playerid, params[])
{
	if (isnull(params))
	{
	    return SendSyntaxMessage(playerid, "/low [low chat]");
	}
	else if (Players[playerid][pMuted])
	{
	    return SendErrorMessage(playerid, "You cannot use this command since you're muted.");
	}
	else
	{
		SendDistanceMessage(playerid, 5.0, COLOR_LIGHTGREY, "%s says [low]: %s", ReturnNameEx(playerid), params);
		new log[128];
		format(log, sizeof(log), "(/low) %s says: %s", ReturnName(playerid), params);
		CreateLog("local", log);

		foreach (new i : Player)
		{
			if (Players[i][pBigEars])
			{
				SendSplitMessage(i, COLOR_LIGHTGREY, "%s says [low]: %s", ReturnNameEx(playerid), params);
			}
		}
	}
	return 1;
}
