include("shared.lua")
include("cl_team_menu.lua")
include("cl_loadout_menu.lua")
include("cl_hud.lua")
include("cl_spawns.lua")

hook.Add("InitPostEntity", "rtdm_player_initiated", function()
    net.Start("rtdm_player_initiated")
    net.SendToServer()
end)

net.Receive("rtdm_player_initiated", function(len, ply)
    rtdm_team_select_screen()
end)

concommand.Add("rtdm_respawn", function()
    LocalPlayer():ConCommand("kill")
end)
