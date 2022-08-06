util.AddNetworkString( "rtdm_weapons" )
util.AddNetworkString( "rtdm_loadout" )

local main_weapons = { 
    { "SMG", "weapon_smg1", "models/weapons/w_smg1.mdl", "A fully automatic SMG."},
    { "Pulse Rifle", "weapon_ar2", "models/weapons/w_irifle.mdl", "Pulse Rifle. A fully automatic combine rifle."},
}

local side_weapons = {

    { "Pistol", "weapon_pistol", "models/weapons/w_pistol.mdl", "A pistol that goes pew pew."},
    { "Revolver", "weapon_357", "models/weapons/w_357.mdl", "A pistol that goes pow pow."},
    
}

local extra_weapons = {

    { "RPG", "weapon_rpg", "models/weapons/w_rocket_launcher.mdl", "Rocket Propelled Grenade Launcher."},
    { "StunStick", "weapon_stunstick", "models/weapons/w_stunbaton.mdl", "A stick to bash people with."},

}

net.Receive("rtdm_weapons", function( len, ply )
    net.Start("rtdm_weapons")
    net.WriteTable( main_weapons )
    net.WriteTable( side_weapons )
    net.WriteTable( extra_weapons)
    net.Send(ply)
end)

net.Receive("rtdm_loadout", function( len, ply )
    local Loadout = {}
    local pp = net.ReadString()
    local ps = net.ReadString()
    local pe = net.ReadString()
    Loadout[1] = pp
    Loadout[2] = ps
    Loadout[3] = pe

    local function writeloadout( pp, ps, pe )
        if file.Exists("rtdm/players/"..ply:SteamID64() , "DATA") then
            file.Write("rtdm/players/"..ply:SteamID64().."/loadout.json", util.TableToJSON( Loadout ))
        else
            file.CreateDir("rtdm/players/"..ply:SteamID64())
            file.Write("rtdm/players/"..ply:SteamID64().."/loadout.json", util.TableToJSON( Loadout ))
        end
    end

    if ply:GetNWBool("rtdm_team_switchin", true) then
        ply:SetNWString("rtdm_team_switchin", false)
        writeloadout( pp, ps, pe)
        ply:Spawn()
    else
        if ply:SetNWBool("rtdm_team_inout") then
            writeloadout( pp, ps, pe)
            ply:ChatPrint("Successfully updated loadout for next respawn!")
        else
            return
        end
    end

    if ply:GetNWBool("rtdm_team_switchin") then
        ply:Spawn()
    else
        return
    end
end)

function giveLoadout( ply )
	ply:StripWeapons()
    ply:StripAmmo()
    local Loadout = util.JSONToTable( file.Read("rtdm/players/"..ply:SteamID64().."/loadout.json", "DATA"))
    for i, v in next, Loadout do
        ply:Give( v )
    end
        ply:Give("weapon_fists")
    for k, v in pairs( ply:GetWeapons() ) do
        timer.Simple( 0, function()
            ply:GiveAmmo( v:Clip1() * 5 , v:GetPrimaryAmmoType(), true )
        end)
    end 
end