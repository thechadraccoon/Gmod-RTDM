include("config.lua")

if rtdm_game_tickets == nil then
    rtdm_game_tickets = rtdm.config.ticketcount / 3
    rtdm_game_tickets_team_2 = rtdm.config.ticketcount
    rtdm_game_tickets_team_3 = rtdm.config.ticketcount
end

hook.Add("PlayerDeath", "rtdm_tickets", function(victim, inflictor, attacker)
    if attacker ~= victim then
        if attacker:Team() == 2 then
            rtdm_game_tickets_team_3 = rtdm_game_tickets_team_3 - 1 -- if Att is from team 2 then remove one ticket from team 3.
        elseif attacker:Team() == 3 then
            rtdm_game_tickets_team_2 = rtdm_game_tickets_team_2 - 1 -- if Att is from team 3 then remove one ticket from team 2.
        elseif attacker:Team() == 4 and vic:Team() == 4 then
            ply:SetNWInt("rtdm_ffa_kills", ply:GetNWInt("rtdm_ffa_kills") - 1) -- if Att & Vic are playing FFA then add one to Att's ffa kills
        else
            return
        end
    end
end)

function rtdm_game_sync_tickets()
    net.Start("rtdm_game_sync_tickets")
    net.WriteString(rtdm_game_tickets_team_2)
    net.WriteString(rtdm_game_tickets_team_3)
    net.Broadcast()
end
