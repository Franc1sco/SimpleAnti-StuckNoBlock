/*  SM Anti-Stuck NoBlock
 *
 *  Copyright (C) 2017 Francisco 'Franc1sco' García
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */

#include <sourcemod>
#include <sdktools>

#define VERSION "1.1"

public Plugin:myinfo = 
{
	name = "SM Anti-Stuck NoBlock",
	author = "Franc1sco steam: franug",
	description = "give to all players a simple Anti-Stuck NoBlock",
	version = VERSION,
	url = "http://steamcommunity.com/id/franug"
};

new Handle:sm_noblock;

new bool:enable;

#define COLLISION_GROUP_PUSHAWAY            17
#define COLLISION_GROUP_PLAYER              5 

public OnPluginStart()
{
	HookEvent("player_spawn", OnSpawn);

	sm_noblock = CreateConVar("sm_antistucknoblock", "1", "Removes player vs. player stuck. 1 = enable, 0 = disable");
	CreateConVar("sm_antistucknoblock_version", VERSION, _, FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_DONTRECORD);

	HookConVarChange(sm_noblock, OnCVarChange);
}

public OnCVarChange(Handle:convar_hndl, const String:oldValue[], const String:newValue[])
{
	GetCVars();
}

public OnConfigsExecuted()
{
	GetCVars();
}

public OnSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	if(!enable)
		return;

	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	SetEntProp(client, Prop_Data, "m_CollisionGroup", COLLISION_GROUP_PUSHAWAY); 
}


// Get new values of cvars if they has being changed
public GetCVars()
{
	enable = GetConVarBool(sm_noblock);
	if(enable)
		EnableBlock();


	else
		DisableBlock();
}

EnableBlock()
{
  	for(new i=1; i <= MaxClients; i++)
		if (IsClientInGame(i) && IsPlayerAlive(i))
			SetEntProp(i, Prop_Data, "m_CollisionGroup", COLLISION_GROUP_PUSHAWAY);
}

DisableBlock()
{
  	for(new i=1; i <= MaxClients; i++)
		if (IsClientInGame(i) && IsPlayerAlive(i))
			SetEntProp(i, Prop_Data, "m_CollisionGroup", COLLISION_GROUP_PLAYER);
}
