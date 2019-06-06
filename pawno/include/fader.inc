// Emmet's simple screen fader

enum e_fadeInfo {
	PlayerText:e_fadeBox,
	e_fadeActive,
	e_fadeInit,
	e_fadeExtra,
	e_fadeColor,
	e_fadeTimer,
	e_fadeStep
};

static
	s_FadeData[MAX_PLAYERS][e_fadeInfo];

forward OnPlayerFadeComplete(playerid, extraid);

stock FadeScreenForPlayer(playerid, extraid, color = 0x000000FF, speed = 25)
{
	if (!s_FadeData[playerid][e_fadeInit])
	{
		s_FadeData[playerid][e_fadeBox] = CreatePlayerTextDraw(playerid, 0.0000, 0.0000, "_");
		s_FadeData[playerid][e_fadeInit] = 1;

		PlayerTextDrawFont(playerid, s_FadeData[playerid][e_fadeBox], 1);
		PlayerTextDrawLetterSize(playerid, s_FadeData[playerid][e_fadeBox], 0.500000, 50.000000);
		PlayerTextDrawUseBox(playerid, s_FadeData[playerid][e_fadeBox], 1);
		PlayerTextDrawTextSize(playerid, s_FadeData[playerid][e_fadeBox], 640.000000, 30.000000);
	}
	if (s_FadeData[playerid][e_fadeActive])
	{
	    KillTimer(s_FadeData[playerid][e_fadeTimer]);
	}
    PlayerTextDrawBoxColor(playerid, s_FadeData[playerid][e_fadeBox], color & ~0xFF);
	PlayerTextDrawShow(playerid, s_FadeData[playerid][e_fadeBox]);

	s_FadeData[playerid][e_fadeActive] = 1;
    s_FadeData[playerid][e_fadeColor] = 0;
    s_FadeData[playerid][e_fadeExtra] = extraid;
    s_FadeData[playerid][e_fadeStep] = 0;
	s_FadeData[playerid][e_fadeTimer] = SetTimerEx("FadeTimer", 100, true, "ddd", playerid, color, speed);
	return 1;
}

stock StopScreenFade(playerid)
{
	PlayerTextDrawHide(playerid, s_FadeData[playerid][e_fadeBox]);
	KillTimer(s_FadeData[playerid][e_fadeTimer]);

	s_FadeData[playerid][e_fadeActive] = 0;
	s_FadeData[playerid][e_fadeColor] = 0;
	s_FadeData[playerid][e_fadeStep] = 0;
	s_FadeData[playerid][e_fadeExtra] = 0;
	return 1;
}

forward FadeTimer(playerid, color, speed);
public FadeTimer(playerid, color, speed)
{
	new
	    extraid = s_FadeData[playerid][e_fadeExtra];

	s_FadeData[playerid][e_fadeStep] += speed;
    s_FadeData[playerid][e_fadeColor] = color + s_FadeData[playerid][e_fadeStep];

 	if (s_FadeData[playerid][e_fadeStep] >= 255)
 	{
 	    KillTimer(s_FadeData[playerid][e_fadeTimer]);

		CallLocalFunction("OnPlayerFadeComplete", "ii", playerid, extraid);
		StopScreenFade(playerid);
 	}
 	else
 	{
 	    PlayerTextDrawHide(playerid, s_FadeData[playerid][e_fadeBox]);
 		PlayerTextDrawBoxColor(playerid, s_FadeData[playerid][e_fadeBox], s_FadeData[playerid][e_fadeColor]);
 		PlayerTextDrawShow(playerid, s_FadeData[playerid][e_fadeBox]);
	}
 	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	StopScreenFade(playerid);

	s_FadeData[playerid][e_fadeInit] = 0;

	#if defined SF_OnPlayerDisconnect
	    return SF_OnPlayerDisconnect(playerid, reason);
	#else
	    return 1;
	#endif
}

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect SF_OnPlayerDisconnect

#if defined SF_OnPlayerDisconnect
	forward SF_OnPlayerDisconnect(playerid, reason);
#endif

