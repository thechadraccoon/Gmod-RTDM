util.AddNetworkString("rtdm_team")

net.Receive("rtdm_team", function( len, ply )
    local rtdm_curteam = ply:Team()
    local rtdm_nextteam = net.ReadInt( 4 )

    local function makespec( ply )
        ply:SetTeam(rtdm_nextteam)
        ply:StripWeapons()
        ply:Spectate( OBS_MODE_ROAMING )
        ply:SetNWBool("rtdm_team_playing", false)
    end

    if rtdm_curteam ~= rtdm_nextteam then
        if rtdm_nextteam ~= 1 then
--        true = in false = out
            if ply:GetNWBool("rtdm_team_playing") then
                ply:SetNWBool("rtdm_team_switcher", true)
                ply:SetNWInt("rtdm_team_switch_id", rtdm_nextteam)
                ply:Spawn()
            else
                ply:SetNWBool("rtdm_team_switchin", true)
                ply:SetNWInt("rtdm_team_switchin_id", rtdm_nextteam)
                net.Start("rtdm_team")
                net.Send(ply)
            end
        else
            makespec(ply)
        end
    else
        if rtdm_curteam == 1 then
            return
        else
            ply:ChatPrint("You're already on that team!")
        end
    end

end)

hook.Add("PlayerSpawn", "rtdm_teamswitch", function( ply )
    if ply:GetNWBool("rtdm_team_switcher") then
        ply:SetTeam( ply:GetNWInt("rtdm_team_switch_id", rtdm_nextteam) )
        ply:SetNWBool("rtdm_team_switcher", false)
        ply:ChatPrint("You have been swapped into the "..team.GetName( ply:Team() ).." team!")
    elseif not ply:GetNWBool("rtdm_team_playing") then
        ply:SetNWBool("rtdm_team_playing", true)
        ply:SetTeam( ply:GetNWInt("rtdm_team_switch_id", rtdm_nextteam) )
        ply:ChatPrint("You have been assigned into the "..team.GetName( ply:Team() ).." team!")
    else
        return
    end
end)