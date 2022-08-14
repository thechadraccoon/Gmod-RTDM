util.AddNetworkString("rtdm_weapons")
util.AddNetworkString("rtdm_loadout")
include("config.lua")

net.Receive("rtdm_weapons", function(len, ply)
    net.Start("rtdm_weapons")
    net.WriteTable(rtdm.config.loadout.main_weapons)
    net.WriteTable(rtdm.config.loadout.side_weapons)
    net.WriteTable(rtdm.config.loadout.extra_weapons)
    net.Send(ply)
end)

net.Receive("rtdm_loadout", function(len, ply)
    local Loadout = {}
    local pp = net.ReadString()
    local ps = net.ReadString()
    local pe = net.ReadString()
    Loadout[1] = pp
    Loadout[2] = ps
    Loadout[3] = pe

    local function writeloadout(pp, ps, pe)
        if file.Exists("rtdm/players/" .. ply:SteamID64(), "DATA") then
            file.Write("rtdm/players/" .. ply:SteamID64() .. "/loadout.json", util.TableToJSON(Loadout))
        else
            file.CreateDir("rtdm/players/" .. ply:SteamID64())
            file.Write("rtdm/players/" .. ply:SteamID64() .. "/loadout.json", util.TableToJSON(Loadout))
        end
    end

    if ply:GetNWBool("rtdm_team_switchin") then
        ply:SetNWString("rtdm_team_switchin", false)
        ply:SetNWBool("rtdm_team_playing", true)
        writeloadout(pp, ps, pe)
        ply:Spawn()
    else
        if ply:GetNWBool("rtdm_team_playing") then
            writeloadout(pp, ps, pe)
            ply:ChatPrint("Successfully updated loadout for next respawn!")
        else
            return
        end
    end
end)

function giveLoadout(ply)
    ply:StripWeapons()
    ply:StripAmmo()
    ply:Give("arccw_apex_melee_wrench")

    if not ply:IsBot() then
        Loadout = util.JSONToTable(file.Read("rtdm/players/" .. ply:SteamID64() .. "/loadout.json", "DATA"))
    end

    if ply:IsBot() then
        Loadout = {}
        Loadout[1] = rtdm.config.loadout.botprimary
        Loadout[2] = rtdm.config.loadout.botsecondary
        Loadout[3] = rtdm.config.loadout.botextra
    end

    for i, v in next, Loadout do
        ply:Give(v)
    end

    timer.Simple(.5, function()
        ply:SelectWeapon(Loadout[3])

        timer.Simple(.5, function()
            ply:SelectWeapon(Loadout[2])

            timer.Simple(.5, function()
                ply:SelectWeapon(Loadout[1])
            end)
        end)
    end)

    timer.Simple(2.5, function()
        for k, v in pairs(ply:GetWeapons()) do
            ply:SetAmmo(0, v:GetPrimaryAmmoType(), true)

            if v:GetClass() == Loadout[3] then
                ply:SetAmmo(v:Clip1() * 1, v:GetPrimaryAmmoType(), true)
            else
                ply:SetAmmo(v:Clip1() * 5, v:GetPrimaryAmmoType(), true)
            end
        end
    end)
end
