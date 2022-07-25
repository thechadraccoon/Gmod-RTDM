util.AddNetworkString( "rtdm_weapons" )
util.AddNetworkString( "rtdm_loadout" )

local main_weapons = {
    { "SMG", "weapon_smg", "models/weapons/rifleman/ar02/worldmodel.mdl"}
}

local side_weapons = {
    { "Pistol", "weapon_pistol", "models/weapons/rifleman/ar02/worldmodel.mdl"}
}

local extra_weapons = {
    { "Fists", "weapon_fists", "models/weapons/c_arms_citizen.mdl"}
}

net.Receive("rtdm_weapons", function( ply ) 
    net.Start("rtdm_weapons")
    net.WriteTable(main_weapons)
    net.WriteTable(side_weapons)
    net.WriteTable(extra_weapons)
    net.Send(ply)
end)

rtdm_loadout_changelist = {}

net.Receive("rtdm_loadout", function(ply)
    net.Start("rtdm_chatmessage")
    if rtdm_loadout_changelist[ply:SteamID64()] then
        table.RemoveByValue(rtdm_loadout_changelist, ply:SteamID64())
        table.Insert(rtdm_loadout_changelist, ply:SteamID64())
        loadout[ ply ] = {
            p = net.ReadString(),
            s = net.ReadString(),
            e = net.ReadString()
        }
        net.WriteString("Successfully updated loadout for next spawn!")
    else
        table.Insert(rtdm_loadout_changelist, ply:SteamID64())
        loadout[ ply ] = {
            p = net.ReadString(),
            s = net.ReadString(),
            e = net.ReadString()
        }
        net.WriteString("Successfully updated loadout for next spawn!")
    end
    net.Send(ply)

    
end)

hook.Add("PlayerDeath", "rtdm_loadout_switcher", function(victim, inflictor, attacker)
    if rtdm_loadout_changelist[ply:SteamID64()] then
        local p = net.ReadString() -- primary
	    local s = net.ReadString() -- secondary
	    local e = net.ReadString() -- extra
        loadout[ ply ] = {
            p = p,
            s = s,
            e = e
        }
        table.RemoveByValue(rtdm_loadout_changelist, ply:SteamID64())
    else
        return
    end
end)

function giveLoadout( ply )
	ply:StripWeapons()
    local loadout = loadout[ply]
    ply:Give( loadout.p )
	ply:Give( loadout.s )
    ply:Give( loadout.e )
end

hook.Add("PlayerDisconnected", "rtdm_loadout_cleanup", function(ply)
    if rtdm_loadout_changelist[ply:SteamID64()] then
        table.RemoveByValue(rtdm_loadout_changelist, ply:SteamID64())
    end
end)