util.AddNetworkString( "rtdm_weapons" )

local main_weapons = {
    { "M4A1", "wf_wpn_ar02", "models/weapons/rifleman/ar02/worldmodel.mdl"}
}

local side_weapons = {
    { "Mini-Uzi", "wf_wpn_smg02", "models/weapons/rifleman/ar02/worldmodel.mdl"}
}

local extra_weapons = {
    { "Fists", "weapon_fists", "models/weapons/c_arms_citizen.mdl"}
}

net.Receive("rtdm_weapons", function( ply ) 
    net.Start("rtdm_weapons")
    net.WriteBool("false")
    net.WriteTable(main_weapons)
    net.WriteTable(side_weapons)
    net.WriteTable(extra_weapons)
    net.Send(ply)
end)