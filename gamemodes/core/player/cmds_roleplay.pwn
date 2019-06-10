CMD:me(playerid, params[])
{
    if (isnull(params))
	{
	    return SendSyntaxMessage(playerid, "/me (action text)");
	}
	else if (Players[playerid][pMuted])
	{
	    return SendErrorMessage(playerid, "You cannot use this command since you're muted.");
	}
	SendDistanceMessage(playerid, 20.0, COLOR_PURPLE, "* %s %s", ReturnNameEx(playerid), params);

	new log[128];
	format(log, sizeof(log), "(/me) %s %s", ReturnName(playerid), params);
	CreateLog("local", log);

	foreach (new i : Player)
	{
		if (Players[i][pBigEars])
		{
			SendSplitMessage(i, COLOR_PURPLE, "* %s %s", ReturnNameEx(playerid), params);
		}
	}

	return 1;
}

CMD:my(playerid, params[])
{
	if (isnull(params))
		return SendSyntaxMessage(playerid, "/my [action]");

	if (Players[playerid][pMuted])
		return SendErrorMessage(playerid, "You cannot use this command since you're muted.");

	SendDistanceMessage(playerid, 20.0, COLOR_PURPLE, "* %s's %s", ReturnNameEx(playerid), params);

	new log[128];
	format(log, sizeof(log), "(/my) %s's %s", ReturnName(playerid), params);
	CreateLog("local", log);

	foreach (new i : Player)
	{
		if (Players[i][pBigEars])
		{
			SendSplitMessage(i, COLOR_PURPLE, "* %s's %s", ReturnNameEx(playerid), params);
		}
	}
	return 1;
}

CMD:do(playerid, params[])
{
    if (isnull(params))
	{
	    return SendSyntaxMessage(playerid, "/do [description]");
	}
	else if (Players[playerid][pMuted])
	{
	    return SendErrorMessage(playerid, "You cannot use this command since you're muted.");
	}
	SendDistanceMessage(playerid, 20.0, COLOR_PURPLE, "* %s (( %s ))", params, ReturnNameEx(playerid));

	new log[128];
	format(log, sizeof(log), "(/do) %s (( %s ))", params, ReturnName(playerid));
	CreateLog("local", log);

	foreach (new i : Player)
	{
		if (Players[i][pBigEars])
		{
			SendSplitMessage(i, COLOR_PURPLE, "* %s (( %s ))", params, ReturnNameEx(playerid));
		}
	}

	return 1;
}

CMD:ame(playerid, params[])
{
    if (isnull(params))
	{
	    return SendSyntaxMessage(playerid, "/ame [action]");
	}
	else if (Players[playerid][pMuted])
	{
	    return SendErrorMessage(playerid, "You cannot use this command since you're muted.");
	}
	ShowActionBubble(playerid, "** %s %s", ReturnNameEx(playerid), params);
	SendSplitMessage(playerid, COLOR_PURPLE, "> %s %s", ReturnNameEx(playerid), params);

	new log[128];
	format(log, sizeof(log), "(/ame) %s %s", ReturnName(playerid), params);
	CreateLog("local", log);

	return 1;
}

CMD:amy(playerid, params[])
{
	if (isnull(params))
		return SendSyntaxMessage(playerid, "/amy [action]");

	if (Players[playerid][pMuted])
		return SendErrorMessage(playerid, "You cannot use this command since you're muted.");

	ShowActionBubble(playerid, "** %s's %s", ReturnNameEx(playerid), params);
	SendSplitMessage(playerid, COLOR_PURPLE, "> %s's %s", ReturnNameEx(playerid), params);

	new log[128];
	format(log, sizeof(log), "(/amy) %s %s", ReturnName(playerid), params);
	CreateLog("local", log);

	return 1;
}

CMD:ado(playerid, params[])
{
    if (isnull(params))
	{
	    return SendSyntaxMessage(playerid, "/ado (action text)");
	}
	else if (Players[playerid][pMuted])
	{
	    return SendErrorMessage(playerid, "You cannot use this command since you're muted.");
	}
	ShowActionBubble(playerid, "** %s (( %s ))", params, ReturnNameEx(playerid));
	SendSplitMessage(playerid, COLOR_PURPLE, "> %s (( %s ))", params, ReturnNameEx(playerid));

	new log[128];
	format(log, sizeof(log), "(/ado) %s (( %s ))", params, ReturnName(playerid));
	CreateLog("local", log);

	return 1;
}