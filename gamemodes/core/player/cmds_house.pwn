CMD:heal(playerid, params[])
{
	if (GetClosestFridge(playerid, 2.0) == INVALID_ID)
		return SendErrorMessage(playerid, "You are not near a fridge.");

	FridgeCheck(playerid);
	return 1;
}