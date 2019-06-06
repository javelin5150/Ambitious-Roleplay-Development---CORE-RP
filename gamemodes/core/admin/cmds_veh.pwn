CMD:vrespawn(playerid, params[])
{
    if (Players[playerid][pAdmin] < 2)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else
	{
	    if (IsPlayerInAnyVehicle(playerid))
	        Dialog_Show(playerid, VehicleRespawn, DIALOG_STYLE_LIST, "{6688FF}Respawn vehicles", "Current vehicle\nAll vehicles\nNearby vehicles", "Select", "Cancel");

		else
			Dialog_Show(playerid, VehicleRespawn, DIALOG_STYLE_LIST, "{6688FF}Respawn vehicles", "All vehicles\nNearby vehicles", "Select", "Cancel");
	}
	return 1;
}

CMD:fvrespawn(playerid, params[])
{
	new faction;

	if (Players[playerid][pAdmin] < 2 && !Players[playerid][pFactionMod])
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "i", faction))
	{
	    return SendSyntaxMessage(playerid, "/deletefaction (faction ID)");
	}
	else if (!IsValidFactionID(faction))
	{
	    return SendErrorMessage(playerid, "You have specified an invalid faction ID.");
	}
	else
	{
		foreach (new i : Player)
		{
		    if (GetPlayerFactionID(i) == faction)
			{
		        SendInfoMessage(i, "You have been kicked from your faction due to deletion.");
		        ResetFactionInfo(i);
			}
		}
		ClearFactionGates(faction);
		ClearFactionVehicles(faction);

		format(gExecute, sizeof(gExecute), "DELETE FROM rp_factions WHERE `fcID` = %i", Factions[faction][fcID]);
	    mysql_tquery(gConnection, gExecute);

	    format(gExecute, sizeof(gExecute), "UPDATE rp_accounts SET FactionID = 0 WHERE FactionID = %i", Factions[faction][fcID]);
	    mysql_tquery(gConnection, gExecute);

		ResetFaction(faction);
	    SendAdminMessage(COLOR_RED, "Admin: %s has deleted faction %i.", ReturnNameEx(playerid, 0), faction);
	}
	return 1;
}
