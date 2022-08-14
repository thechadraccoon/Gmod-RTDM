include("config.lua")

if rtdm_game_tickets == nil then
    rtdm_game_tickets = rtdm.config.ticketcount / 3
    SetGlobalInt("rtdm_tickets_team1tickets", rtdm.config.ticketcount)
    SetGlobalInt("rtdm_tickets_team2tickets", rtdm.config.ticketcount)
end

hook.Add("PlayerDeath", "rtdm_tickets", function(victim, inflictor, attacker)
    if attacker ~= victim then
        if attacker:Team() == 1 then
            SetGlobalInt("rtdm_tickets_team2tickets", GetGlobalInt("rtdm_tickets_team2tickets") - 1) -- if Att is from team 1 then remove one ticket from team 2.
        elseif attacker:Team() == 2 then
            SetGlobalInt("rtdm_tickets_team1tickets", GetGlobalInt("rtdm_tickets_team1tickets") - 1) -- if Att is from team 1 then remove one ticket from team 1.
        elseif attacker:Team() == 3 and vic:Team() == 3 then
            ply:SetNWInt("rtdm_ffa_kills", ply:GetNWInt("rtdm_ffa_kills") - 1) -- if Att & Vic are playing FFA then add one to Att's ffa kills
        else
            return
        end
    end
end)
