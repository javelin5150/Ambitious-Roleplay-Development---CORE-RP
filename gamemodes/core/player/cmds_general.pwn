CMD:help(playerid, params[])
{
	/*new
	    string[128] = "List of Commands\nAnimation List\nFAQ and Guide";

	if (Players[playerid][pAdmin] > 0)
	{
	    strcat(string, "\nAdmin Help");
	}
	if (Players[playerid][pHelper] > 0)
	{
	    strcat(string, "\nTester Help");
	}
	if (Players[playerid][pFactionID] > 0)
	{
	    strcat(string, "\nFaction Help");
	}
	Dialog_Show(playerid, HelpMenu, DIALOG_STYLE_LIST, "{6688FF}Help Menu", string, "Select", "Cancel");*/

	// Dialogs? Who needs that?

	if (isnull(params))
	{
	    SendSyntaxMessage(playerid, "/help (type)");
	    SendClientMessage(playerid, COLOR_LIGHTGREY, "Types: general, chat, job, property, vehicle, faction, supporter, admin");
		return 1;
	}
	else if (!strcmp(params, "general", true))
	{
	    SendClientMessage(playerid, COLOR_GREY, "-------------------------------------------------------------------------------------------------------------------------------------");
        SendClientMessage(playerid, COLOR_GREY, "General:{FFFFFF} /stats, /settings, /items, /weapons, /accessories, /payment, /flush, /helpme.");
        SendClientMessage(playerid, COLOR_GREY, "General:{FFFFFF} /changepass, /clearcp, /bank, /paused, /lastactive, /admins, /supporters, /vwreset.");
        SendClientMessage(playerid, COLOR_GREY, "General:{FFFFFF} /phone, /answer, /hangup, /(show)licenses, /factions, /animations, /(calc)ulate.");
        SendClientMessage(playerid, COLOR_GREY, "General:{FFFFFF} /pay, /guide, /time, /remote, /chatstyle, /greet, /pickup, /mostplayers.");
        SendClientMessage(playerid, COLOR_GREY, "General:{FFFFFF} /donatorinfo, /changename, /servertime, /charity, /onduty");
        SendClientMessage(playerid, COLOR_GREY, "-------------------------------------------------------------------------------------------------------------------------------------");
	}
	else if (!strcmp(params, "chat", true))
	{
	    SendClientMessage(playerid, COLOR_GREY, "------------------------------------------------------------------------------------------------------------------------------------");
        SendClientMessage(playerid, COLOR_GREY, "Chatting:{FFFFFF} /b, /pm, /(l)ow, /(s)hout, /me, /do, /ame, /ado, /(w)hisper, /(d)oor(s)hout.");
        SendClientMessage(playerid, COLOR_GREY, "Chatting:{FFFFFF} /talk, /r, /(c)ar(w)hisper.");
        SendClientMessage(playerid, COLOR_GREY, "------------------------------------------------------------------------------------------------------------------------------------");
	}
	else if (!strcmp(params, "job", true))
	{
	    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------------------------------------");
        SendClientMessage(playerid, COLOR_GREY, "Jobs:{FFFFFF} /load, /work, /jobhelp, /quitjob.");
        SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------------------------------------");
	}
	else if (!strcmp(params, "property", true))
	{
	    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------------------------------------");
        SendClientMessage(playerid, COLOR_GREY, "Properties:{FFFFFF} /house, /company, /rent, /unrent, /listassets.");
        SendClientMessage(playerid, COLOR_GREY, "Properties:{FFFFFF} If you would like another interior for any your properties,");
        SendClientMessage(playerid, COLOR_GREY, "Properties:{FFFFFF} make a /report and an admin will look into it as soon as possible.");
        SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------------------------------------");
	}
	else if (!strcmp(params, "vehicle", true))
	{
	    SendClientMessage(playerid, COLOR_GREY, "---------------------------------------------------------------------------------------------------------");
        SendClientMessage(playerid, COLOR_GREY, "Vehicles:{FFFFFF} /(v)ehicle, /engine, /windows, /lights, /boot/trunk, /hood/bonnet, /lock.");
        SendClientMessage(playerid, COLOR_GREY, "Vehicles:{FFFFFF} /refuel.");
        SendClientMessage(playerid, COLOR_GREY, "---------------------------------------------------------------------------------------------------------");
	}
	else if (!strcmp(params, "faction", true))
	{
	    if (Players[playerid][pFaction] != INVALID_ID || Players[playerid][pFactionMod])
	    {
		    SendClientMessage(playerid, COLOR_GREY, "-------------------------------------------------------------------------------------------------------------------------------------------");
		    
		    if (Players[playerid][pFactionMod])
		    {
		        SendClientMessage(playerid, COLOR_GREY, "Faction:{FFFFFF} /fc, /addfaction, /setfaction, /editfaction, /deletefaction, /factions, /setfactionmod.");
		    }
		    SendClientMessage(playerid, COLOR_GREY, "Faction:{FFFFFF} /(r)adio, /(d)ept(r)adio, /(f)action, /roster, /resign, /setrank, /facinvite, /fackick.");
		    SendClientMessage(playerid, COLOR_GREY, "Faction:{FFFFFF} /facduty, /facleadership, /ofackick.");

		    switch (GetPlayerFactionType(playerid))
		    {
		        case FACTION_LEO:
		        {
					SendClientMessage(playerid, COLOR_GREY, "Faction:{FFFFFF} /arrest, /mdc, /ticket, /siren, /acceptcall, /confiscate, /kickdoor, /deploy, /undeploy.");
		            SendClientMessage(playerid, COLOR_GREY, "Faction:{FFFFFF} /(m)egaphone, /taser, /cuff, /uncuff, /callsign, /impound, /issuelicense, /revokelicense.");
		            SendClientMessage(playerid, COLOR_GREY, "Faction:{FFFFFF} /apb, /apblist.");
				}
				case FACTION_MEDICAL:
				{
				    SendClientMessage(playerid, COLOR_GREY, "Faction:{FFFFFF} /damages, /loadpatient, /acceptcall, /deliverpatients, /deploy, /undeploy, /(m)egaphone.");
				    SendClientMessage(playerid, COLOR_GREY, "Faction:{FFFFFF} /siren, /callsign.");
				}
				case FACTION_GOVERNMENT:
				{
				    SendClientMessage(playerid, COLOR_GREY, "Faction:{FFFFFF} /taxrate, /vault.");
				}
				case FACTION_ILLEGAL:
				{
				    //SendClientMessage(playerid, COLOR_GREY, "Faction:{FFFFFF} /orderpackage, /locatepackage, /spray.");
				    SendClientMessage(playerid, COLOR_GREY, "Faction:{FFFFFF} /craft, /spray.");
				}
				case FACTION_NEWS:
				{
				    SendClientMessage(playerid, COLOR_GREY, "Faction:{FFFFFF} /addtosession, /removefromsession, /quitsession, /ses");
				}
			}
		    SendClientMessage(playerid, COLOR_GREY, "-------------------------------------------------------------------------------------------------------------------------------------------");
	    }
	    else
	    {
	        SendErrorMessage(playerid, "You need to be in a faction to see the commands.");
		}
	}
	else if (!strcmp(params, "supporter", true))
	{
	    if (Players[playerid][pSupporter] > 0)
	    {
     		SendClientMessage(playerid, COLOR_GREY, "--------------------------------------------------------------------------------------------------------------------------");
    		SendClientMessage(playerid, COLOR_GREY, "Supporter:{FFFFFF} /(s)taff(c)hat, /sduty, /listhelp, /answerhelp, /declinehelp, /kick.");
			SendClientMessage(playerid, COLOR_GREY, "Head Supporter:{FFFFFF} /setsupporter, /osetsupporter.");
	    	SendClientMessage(playerid, COLOR_GREY, "--------------------------------------------------------------------------------------------------------------------------");
	    }
	    else
	    {
	        SendErrorMessage(playerid, "You need to be a Supporter to see the commands.");
		}
	}
	else if (!strcmp(params, "admin", true))
	{
	    if (Players[playerid][pAdmin] > 0)
	    {
	        SendClientMessage(playerid, COLOR_GREY, "---------------------------------------------------------------------------------------------------------------------------------------------");

        	if (Players[playerid][pAdmin] >= 1)
			{
				SendClientMessage(playerid, COLOR_GREY, "Level 1:{FFFFFF} /(a)dmin, /kick, /spec, /ajail, /unjail, /mute, /unmute, /freeze, /unfreeze, /reports.");
				SendClientMessage(playerid, COLOR_GREY, "Level 1:{FFFFFF} /aduty, /adminname, /warn, /slap, /afkkick, /ban, /goto, /get, /sendto /saveplayers.");
				SendClientMessage(playerid, COLOR_GREY, "Level 1:{FFFFFF} /tp, /anote, /anotes, /deathlogs, /vinfo, /masked, /savepos, /loadpos, /revive.");
			}
            if (Players[playerid][pAdmin] >= 2)
			{
				SendClientMessage(playerid, COLOR_GREY, "Level 2:{FFFFFF} /unban, /sendspawn, /setskin, /jetpack, /listitems, /sethealth, /setarmor, /banlogs.");
				SendClientMessage(playerid, COLOR_GREY, "Level 2:{FFFFFF} /tp, /setint, /setworld, /gotocoords, /vgoto, /vget, /vputseat, /check, /auncuff.");
				SendClientMessage(playerid, COLOR_GREY, "Level 2:{FFFFFF} /togbleeding, /togbrokenleg, /adminheal, /listguns, /removeitem, /checkbank, /aheal.");
				SendClientMessage(playerid, COLOR_GREY, "Level 2:{FFFFFF} /anote, /anotes, /deathlogs, /ahide, /vrespawn, /vfrespawn.");
			}
			if (Players[playerid][pAdmin] >= 3)
			{
				SendClientMessage(playerid, COLOR_GREY, "Level 3:{FFFFFF} /vspawn, /vdestroy, /vrepair, /vrefuel, /vrefuelall, /destroystero.");
				SendClientMessage(playerid, COLOR_GREY, "Level 3:{FFFFFF} /setweather, /offlineban, /offlinejail, /banip, /unbanip, /togooc, /clearinventory.");
				SendClientMessage(playerid, COLOR_GREY, "Level 3:{FFFFFF} /alock, /aflush, /addnos, /disarm, /getip, /aliases.");
			}
			if (Players[playerid][pAdmin] >= 4)
			{
				SendClientMessage(playerid, COLOR_GREY, "Level 4:{FFFFFF} /setname, /adeleteitem, /acleartrunk, /alistassets /adeleteitem.");
				SendClientMessage(playerid, COLOR_GREY, "Level 4:{FFFFFF} /listnamechanges, /setsupporter, /osetsupporter.");
			}
			if (Players[playerid][pAdmin] >= 5)
			{
				SendClientMessage(playerid, COLOR_GREY, "Level 5:{FFFFFF} /(l)ead(a)dmin, /dynamichelp, /vsave, /vblacklist, /vsethealth, /setbankmoney, /setstat, /givemoney.");
				SendClientMessage(playerid, COLOR_GREY, "Level 5:{FFFFFF} /cleartickets, /givenamechanges, /addownedcar, /setfactionmod, /setdrunk, /restart.");
				SendClientMessage(playerid, COLOR_GREY, "Level 5:{FFFFFF} /adeletedrops, /adeleteblood, /adeleteshells, /setadmin, /osetadmin, /setdrunk, /setmapper.");
			}
			if (Players[playerid][pAdmin] >= 6)
			{
			    SendClientMessage(playerid, COLOR_GREY, "Level 6:{FFFFFF} /spawnitem, /setweapon, /setstaff, /setveteran, /setdamages, /setdonator");
			}

			SendClientMessage(playerid, COLOR_GREY, "---------------------------------------------------------------------------------------------------------------------------------------------");
	    }
	    else
	    {
	        SendErrorMessage(playerid, "You need to be an admin to see the commands.");
		}
	}
	return 1;
}

CMD:report(playerid, params[])
{
	if ((gettime() - Players[playerid][pLastReport]) < REPORT_WAIT_TIME)
	{
	    return SendErrorMessage(playerid, "You must wait %i seconds to make a report again.", REPORT_WAIT_TIME - (gettime() - Players[playerid][pLastReport]));
	}
	else if (GetNextReportID() == INVALID_ID)
	{
		return SendErrorMessage(playerid, "The report queue is full right now!");
	}
	else if (isnull(params))
	{
	    return SendSyntaxMessage(playerid, "/report [ID] (reason)");
	}
	else
	{
		AddReportToQueue(playerid, params);

		Players[playerid][pLastReport] = gettime();
	 	SendInfoMessage(playerid, "You have sent a report to the queue. Please wait for assistance.");

	 	new log[128];
		format(log, sizeof(log), "(/report) %s: %s", ReturnName(playerid), params);
		CreateLog("admin", log);
	}
	return 1;
}

CMD:stats(playerid, params[])
{
	ShowStatsForPlayer(playerid, playerid);
	return 1;
}

CMD:vw(playerid, params[])
{
	return cmd_virtual(playerid, params);
}

CMD:virtual(playerid, params[])
{
	SendFormatMessage(playerid, COLOR_SAMP, "Virtual World: %i", GetPlayerVirtualWorld(playerid));
	return 1;
}

CMD:flush(playerid, params[])
{
	FlushChatForPlayer(playerid);
	return 1;
}
