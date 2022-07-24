--------------------------------------------
-- Let's start by initiating the gamemode --
--------------------------------------------4
-- Send these lua files to client.
AddCSLuaFile("cl_init.lua")
AddCSLuaFile(file.Find("cl/*.lua", "LUA"))
AddCSLuaFile("shared.lua")
-- Load these serverside.
include("shared.lua")
include("sv_teamshandler.lua")
-- Document network messages
util.AddNetworkString("rtdm_player_initiated")
util.AddNetworkString("rtdm_jointeam")
util.AddNetworkString("rtdm_chatmessage")
-- Create the Variables for the gamemode
CreateConVar("rtdm_ffa", 0, FCVAR_PROTECTED, "Make the game FFA?", 0, 1)

-- Read convars and SetBooleans globaly
if GetConVar("rtdm_ffa") == 0 then
    SetGlobalBool("rtdm_ffa", false)
else
    SetGlobalBool("rtdm_ffa", false)
end

-- When we know the player has fully loaded welcome them to the server.
net.Receive("rtdm_player_initiated", function(len, ply)
    local rtdm_welcome_msg = "Welcome to"
    net.Start("rtdm_chatmessage")
    net.WriteString("rtdm_welcome_msg")
    net.WriteString(rtdm_welcome_msg)
    net.Send(ply)
    net.Start("rtdm_player_initiated")
    net.Send(ply)
end)

ents.GetAll():Remove()