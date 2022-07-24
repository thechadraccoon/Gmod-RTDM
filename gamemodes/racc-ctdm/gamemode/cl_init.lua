include("shared.lua")
include("cl/teamscreen.lua")
include("cl/loadout.lua")

hook.Add("InitPostEntity", "rtdm_player_initiated", function()
    net.Start("rtdm_player_initiated")
    net.SendToServer()
end)

net.Receive("rtdm_player_initiated", function(len, ply)
    if GetGlobalBool("rtdm_ffa") then
        title = "Free for all"
    else
        title = "Team Death Match"
    end

    team_select_screen(title)
end)

net.Receive("rtdm_chatmessage", function()
    local rtdm_default_chat_color = Color(200, 200, 200)
    local rtdm_messagetype = net.ReadString()

    if rtdm_messagetype == "rtdm_teams_changed" then
        chat.AddText(rtdm_default_chat_color, "You've been added to the", Color(GetTeamColor(ply:Team())), team.GetName(ply:Team()), rtdm_default_chat_color, "team.")
    elseif rtdm_messagetype == "rtdm_teams_alreadyqueued" then
        chat.AddText(rtdm_default_chat_color, "You've already been added to the queue to join that team!")
    elseif rtdm_messagetype == "rtdm_teams_alreadyin" then
        chat.AddText(rtdm_default_chat_color, "You're already part of this team.")
    else
        chat.AddText(rtdm_default_chat_color, net.ReadString())
    end
end)