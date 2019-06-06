Dialog:PhoneMenu(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		switch (listitem)
		{
			case 0:
			{
				Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "Please specify the number you would like to call:", "Call", "Cancel");
			}
			case 1:
			{
				Dialog_Show(playerid, PhoneSMS, DIALOG_STYLE_INPUT, "{6688FF}SMS Number", "Please specify the number you would like to SMS:", "Call", "Cancel");
			}
			case 2:
			{
				ListContacts(playerid);
			}
			case 3:
			{
				SendErrorMessage(playerid, "This feature is still being developed.");
			}
			case 4:
			{
				CheckBank(playerid,playerid);
			}
			case 5:
			{
				Dialog_Show(playerid, PhoneSettings, DIALOG_STYLE_LIST, "{6688FF}Phone Settings", "Power %s\nSound Off", "Select", "Cancel", (Players[playerid][pPhoneOff]) ? ("Off") : ("On"));
			}
		}
	}
	return 1;
}

Dialog:PhoneSettings(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		switch (listitem)
		{
			case 0:
			{
				if (Players[playerid][pPhoneOff] == 0)
					Players[playerid][pPhoneOff] = 1;
				else
					Players[playerid][pPhoneOff] = 0;
			}
		}
	}
	return 1;
}

Dialog:PhoneSMS(playerid, response, listitem, inputtext[])
{
	new number;

	if (response)
	{
		if (sscanf(inputtext, "i", number))
		{
			return Dialog_Show(playerid, PhoneSMS, DIALOG_STYLE_INPUT, "{6688FF}SMS Number", "Please specify the number you would like to SMS:", "Call", "Cancel");
		}
		else if (Players[playerid][pPhone] == number)
		{
			return Dialog_Show(playerid, PhoneSMS, DIALOG_STYLE_INPUT, "{6688FF}SMS Number", "You can't text your own number.\n\nPlease specify the number you would like to SMS:", "Call", "Cancel");
		}
		else if (number < 1)
		{
			return Dialog_Show(playerid, PhoneSMS, DIALOG_STYLE_INPUT, "{6688FF}SMS Number", "Please specify the number you would like to SMS:", "Call", "Cancel");
		}
		else
		{
			new strHead[64];
			format(strHead, sizeof(strHead), "{6688FF}SMS to %i", number);

			Players[playerid][pPhoneSMS] = number;

			Dialog_Show(playerid, PhoneSMStext, DIALOG_STYLE_INPUT, strHead, "Please type your message:", "Send", "Cancel");
		}
	}
	return 1;
}

Dialog:PhoneSMStext(playerid, response, listitem, inputtext[])
{
	new text[512];
	new number = Players[playerid][pPhoneSMS];
	new strHead[64];
	if (response)
	{
		format(strHead, sizeof(strHead), "{6688FF}SMS to %i", number);

		if (sscanf(inputtext, "s[512]", text))
		{
			Dialog_Show(playerid, PhoneSMStext, DIALOG_STYLE_INPUT, strHead, "Please type your message:", "Send", "Cancel");
		}
		else
		{
			SendTextMessage(playerid, number, text);
		}
	}
	return 1;
}

Dialog:PhoneCall(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new number;

		if (sscanf(inputtext, "i", number))
		{
			return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "Please specify the number you would like to call:", "Call", "Cancel");
		}
		else if (Players[playerid][pCalling] > 0)
		{
			return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "You are already on a call. Use {6688FF}/hangup{FFFFFF} to end it.\n\nPlease specify the number you would like to call:", "Call", "Cancel");
		}
		else if (Players[playerid][pPhone] == number)
		{
			return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "You can't dial your own number.\n\nPlease specify the number you would like to call:", "Call", "Cancel");
		}
		else if (number < 1)
		{
			return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "You have entered an invalid phone number.\n\nPlease specify the number you would like to call:", "Call", "Cancel");
		}
		else
		{
			CallNumber(playerid, number);
		}
	}
	return 1;
}
Dialog:PhoneCallPP(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new number, payphone = GetClosestPayphone(playerid);

		if (sscanf(inputtext, "i", number))
		{
			return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "Please specify the number you would like to call:", "Call", "Cancel");
		}
		else if (Players[playerid][pCalling] > 0)
		{
			return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "You are already on a call. Use {6688FF}/hangup{FFFFFF} to end it.\n\nPlease specify the number you would like to call:", "Call", "Cancel");
		}
		else if (Players[playerid][pPhone] == number)
		{
			return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "You can't dial your own number.\n\nPlease specify the number you would like to call:", "Call", "Cancel");
		}
		else if (number < 1)
		{
			return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "You have entered an invalid phone number.\n\nPlease specify the number you would like to call:", "Call", "Cancel");
		}
		else if (IsValidPayphoneID(payphone) && number == Payphones[payphone][phNumber])
		{
			return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "You can't call this number as it belongs to this payphone.\n\nPlease specify the number you would like to call:", "Call", "Cancel");
		}
		else if (IsValidPayphoneID(payphone) && (Payphones[payphone][phOccupied] || Payphones[payphone][phCaller] != INVALID_PLAYER_ID))
		{
			return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "This payphone is already in use.\n\nPlease specify the number you would like to call:", "Call", "Cancel");
		}
		else
		{
			CallNumber(playerid, number, payphone);
		}
	}
	return 1;
}