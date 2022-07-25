rtdm_joinblue = {}
rtdm_joinred = {}

hook.Add("PlayerDeath", "rtdm_deathteamswitcher", function(victim, inflictor, attacker)
    if tojoinred[victim:SteamID64()] then
        victim:SetTeam(2)
        net.Start("rtdm_chatmessage")
        net.WriteString("rtdm_teams_changed")
        net.Send(victim)
    elseif tojoinblue[victim:SteamID64()] then
        victim:SetTeam(3)
        net.Start("rtdm_chatmessage")
        net.WriteString("rtdm_teams_changed")
        net.Send(victim)
    else
        print("guh, this nigga ain't supposed to be hooked in rtdm_deathteamswitcher")
    end
end)

net.Receive("rtdm_jointeam", function(ply)
    local rtdm_curteam = net.ReadString()
    local rtdm_nextteam = net.ReadString()

    local function rtdm_teams_queued()
        net.Start("rtdm_chatmessage")
        net.WriteString("rtdm_teams_queued")
        net.WriteColor(GetTeamColor(rtdm_nextteam))
        net.Send(ply)
    end

    local function rtdm_teams_alreadyin()
        net.Start("rtdm_chatmessage")
        net.WriteString("rtdm_teams_alreadyin")
        net.Send(ply)
    end

    local function rtdm_teams_alreadyqueuedfor()
        net.Start("rtdm_chatmessage")
        net.WriteString("rtdm_teams_alreadyqueued")
        net.Send(ply)
    end

    local function rtdm_teams_queue_handler()-- Checks that it's worth processing a change in the player's team. Tells them when they're retarded.
        if rtdm_curteam ~= 2 and rtdm_nextteam == 2 then
            if tojoinblue[ply:SteamID64()] then
                table.RemoveByValue(tojoinblue, ply:SteamID64())
                table.insert(tojoinblue, ply:SteamID64())
                rtdm_teams_queued(ply)
            elseif tojoinred[ply:SteamID64()] then
                rtdm_teams_alreadyqueuedfor(ply)
            else
                table.insert(tojoinred, ply:SteamID64())
                rtdm_teams_queued(ply)
            end
        elseif rtdm_curteam ~= 3 and rtdm_nextteam == 3 then
            if tojoinred[ply:SteamID64()] then
                table.RemoveByValue(tojoinred, ply:SteamID64())
                table.insert(tojoinblue, ply:SteamID64())
                rtdm_teams_queued(ply)
            elseif tojoinblue[ply:SteamID64()] then
                rtdm_teams_alreadyqueuedfor(ply)
            else
                table.insert(tojoinblue, ply:SteamID64())
                rtdm_teams_queued(ply)
            end
        else
            rtdm_teams_alreadyin(ply)
        end
    end

    local function rtdm_teams_ffa()-- Checks that it's worth processing a change in the player's team. Tells them when they're retarded.
        if rtdm_curteam ~= 4 and rtdm_nextteam == 4 then
            ply:SetTeam(4)
        elseif rtdm_curteam ~= 1 and rtdm_nextteam == 1 then
            ply:SetTeam(1)
            ply:StripWeapons()
            ply:Spectate( OBS_MODE_ROAMING )
        else
            rtdm_teams_alreadyin(ply)
        end
    end

    if GetGlobalBool("rtdm_ffa") == false then
        rtdm_teams_queue_handler( rtdm_curteam, rtdm_nextteam, ply )
    else
        rtdm_teams_ffa( rtdm_curteam, rtdm_nextteam, ply )
    end
end)