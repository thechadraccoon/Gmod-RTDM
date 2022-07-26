﻿--------------------------------------------
-- Let's start by initiating the gamemode --
--------------------------------------------4
-- Send these lua files to client.
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_loadout_menu.lua")
AddCSLuaFile("cl_team_menu.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_spawns.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("config.lua")
-- Load these serverside.
include("shared.lua")
include("sv_team_handler.lua")
include("sv_loadout_handler.lua")
include("sv_map_cleaner.lua")
include("sv_chat_messages.lua")
include("sv_tickets.lua")
include("sv_spawns.lua")
include("config.lua")
-- Document network messages
util.AddNetworkString("rtdm_player_initiated")
util.AddNetworkString("rtdm_chatmessage")
util.AddNetworkString("rtdm_game_sync_tickets")
util.AddNetworkString("rtdm_game_sync_timeleft")

if not timer.Exists("rtdm_game_timeleft") then
    SetGlobalBool("rtdm_ffa", rtdm.config.ffa)
    SetGlobalBool("GameEnding", false)

    timer.Create("rtdm_game_timeleft", 1, rtdm.config.gametime, function()
        if timer.RepsLeft("rtdm_game_timeleft") == 0 and GetGlobalBool("GameEnding") ~= true then
            timer.Create("rtdm_game_timeleft", 1, rtdm.config.matchendtime, function()
                SetGlobalInt("rtdm_game_timeleft", timer.RepsLeft("rtdm_game_timeleft"))

                if timer.RepsLeft("rtdm_game_timeleft") <= 0 and GetGlobalBool("GameEnding") then
                    if rtdm_mapvote ~= true then
                        rtdm_mapvote = true

                        for i, ply in ipairs(player.GetAll()) do
                            ply:ChatPrint("Map Vote!")
                        end

                        SolidMapVote.start()
                    end
                end
            end)

            SetGlobalBool("GameEnding", true)

            for i, ply in ipairs(player.GetAll()) do
                if ply:Team() ~= 0 then
                    ply:StripWeapons()
                    ply:Give(rtdm.config.loadout.enroundweapon)
                end
            end
        end

        SetGlobalInt("rtdm_game_timeleft", timer.RepsLeft("rtdm_game_timeleft"))

        if GetGlobalInt("rtdm_game_timeleft") == 5 and GetGlobalBool("GameEnding") ~= true then
            timer.Create("rtdm_game_ending", 1, 5, function()
                for i, ply in ipairs(player.GetAll()) do
                    ply:PrintMessage(4, "Match ending in " .. GetGlobalInt("rtdm_game_timeleft") .. "!")
                end
            end)
        end
    end)
end

local playermodels = {"models/player/group01/male_01.mdl", "models/player/group01/male_02.mdl", "models/player/group01/male_03.mdl", "models/player/group01/male_04.mdl", "models/player/group01/male_05.mdl", "models/player/group01/male_06.mdl", "models/player/group01/male_07.mdl", "models/player/group01/male_08.mdl", "models/player/group01/male_09.mdl", "models/player/group02/male_02.mdl", "models/player/group02/male_04.mdl", "models/player/group02/male_06.mdl", "models/player/group02/male_08.mdl", "models/player/group03/male_01.mdl", "models/player/group03/male_02.mdl", "models/player/group03/male_03.mdl", "models/player/group03/male_04.mdl", "models/player/group03/male_05.mdl", "models/player/group03/male_06.mdl", "models/player/group03/male_07.mdl", "models/player/group03/male_08.mdl", "models/player/group03/male_09.mdl"}

-- When we know the player has fully loaded start client stuff.
net.Receive("rtdm_player_initiated", function(len, ply)
    net.Start("rtdm_player_initiated")
    net.Send(ply)
end)

function GM:PlayerInitialSpawn(ply)
    ply:SetTeam(0)
    ply:Spectate(OBS_MODE_ROAMING)
    ply:SetNWInt("rtdm_team_switch_id", 1)
    ply:SetNWBool("rtdm_team_playing", false)
    ply:SetNWBool("rtdm_team_switcher", false)
    ply:GetNWBool("rtdm_team_switchin", true)

    if ply:IsBot() then
        ply:SetTeam(1)
        self.BaseClass:PlayerSpawn(ply)

        return
    end

    if file.Exists("rtdm/players/" .. ply:SteamID64(), "DATA") then
        file.Write("rtdm/players/" .. ply:SteamID64() .. "/loadout.json", "")
    else
        file.CreateDir("rtdm/players/" .. ply:SteamID64())
        file.Write("rtdm/players/" .. ply:SteamID64() .. "/loadout.json", "")
    end

    net.Start("rtdm_game_sync_timeleft")
    net.WriteString(timer.RepsLeft("rtdm_game_timeleft"))
    net.Send(ply)
    ply:ConCommand("arccw_automaticreload", 1)
end

function GM:PlayerDisconnected(ply)
end

function GM:PlayerShouldTakeDamage(ply, attacker)
    if attacker:IsPlayer() then
        if ply:IsValid() and attacker:IsValid() then
            if ply:Team() == attacker:Team() then
                return false
            else
                return true
            end
        else
            return false
        end
    else
        return false
    end
end

function GM:PlayerSpawn(ply)
    ply:AllowFlashlight(true)
    ply:SetPlayerColor(team.GetColor(ply:Team()):ToVector())
    ply:SetJumpPower(170) -- Decreased Jump hight due to jumping bastards.
    ply:SetWalkSpeed(200)
    ply:SetRunSpeed(300)

    if GetGlobalBool("GameEnded") then
        ply:SetWalkSpeed(200)
        ply:SetRunSpeed(360)
    end

    ply:SetColor(Color(255, 255, 255, 200))
    ply:SetRenderMode(RENDERMODE_TRANSCOLOR)
    ply:SetNoCollideWithTeammates(true)

    timer.Simple(5, function()
        ply:SetColor(Color(255, 255, 255, 255))
        ply:SetRenderMode(RENDERMODE_TRANSCOLOR)
        ply.spawning = false
    end)

    if ply:Team() ~= 0 then
        if not GetGlobalBool("GameEnding") then
            giveLoadout(ply)
        end

        if GetGlobalBool("GameEnding") then
            ply:StripWeapons()
            ply:Give(rtdm.config.loadout.enroundweapon)
        end

        ply:UnSpectate()

        if ply:Team() == 1 then
            ply:SetModel(rtdm.config.team1plymdl)
            ply:SetSkin(rtdm.config.team1plymldskin)
        end

        if ply:Team() == 2 then
            ply:SetModel(rtdm.config.team2plymdl)
            ply:SetSkin(rtdm.config.team2plymldskin)
        end

        if ply:Team() == 3 then
            ply:SetModel(table.Random(playermodels))
        end

        ply:SetupHands()
        ply.spawning = true
    else
        ply:StripWeapons()
        ply:Spectate(OBS_MODE_ROAMING)
    end
end

function GM:CanPlayerSuicide(ply)
    if ply:Team() ~= 0 then
        timer.Create(ply:SteamID64() .. "suicide", 1, rtdm.config.suicidetimer, function()
            if timer.RepsLeft(ply:SteamID64() .. "suicide") == 0 then
                ply:PrintMessage(4, "You've been respawned.")

                if ply:Team() == 1 then
                    SetGlobalInt("rtdm_tickets_team1tickets", GetGlobalInt("rtdm_tickets_team1tickets") - 1)
                elseif ply:Team() == 2 then
                    SetGlobalInt("rtdm_tickets_team2tickets", GetGlobalInt("rtdm_tickets_team2tickets") - 1)
                end

                ply:Spawn()
            else
                ply:PrintMessage(4, "You'll be respawned in " .. timer.RepsLeft(ply:SteamID64() .. "suicide") .. ".")
            end
        end)
    end

    return false
end

function GM:PlayerDeath(vic, inf, att)
    if vic:IsValid() and att:IsValid() and att:IsPlayer() then
        if vic == att then return end

        for k, v in pairs(att:GetWeapons()) do
            att:GiveAmmo(v:Clip1() * 1, v:GetPrimaryAmmoType(), true)
        end

        vic:SetFOV(0, 0)
    end
end

function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)
    if hitgroup == HITGROUP_HEAD then
        if IsValid(ply) then
            dmginfo:ScaleDamage(1.5)
        end
    elseif hitgroup == HITGROUP_CHEST then
        if IsValid(ply) then
            dmginfo:ScaleDamage(1)
        end
    elseif hitgroup == HITGROUP_STOMACH then
        if IsValid(ply) then
            dmginfo:ScaleDamage(1)
        end
    elseif hitgroup == HITGROUP_LEFTARM then
        if IsValid(ply) then
            dmginfo:ScaleDamage(0.9)
        end
    elseif hitgroup == HITGROUP_RIGHTARM then
        if IsValid(ply) then
            dmginfo:ScaleDamage(0.9)
        end
    elseif hitgroup == HITGROUP_LEFTLEG then
        if IsValid(ply) then
            dmginfo:ScaleDamage(0.8)
        end
    elseif hitgroup == HITGROUP_RIGHTLEG then
        if IsValid(ply) then
            dmginfo:ScaleDamage(0.8)
        end
    else
        if IsValid(ply) then
            dmginfo:ScaleDamage(1)
        end
    end
end

function GM:EntityTakeDamage(ply, dmginfo)
    if ply.spawning then
        local dmg = dmginfo:GetDamage()

        if dmginfo:GetAttacker() and dmginfo:GetAttacker() ~= NULL and dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():Team() ~= ply:Team() then
            dmginfo:GetAttacker():TakeDamage(dmg)
            dmginfo:GetAttacker():ChatPrint("This player is spawn protected.")
        end

        dmginfo:ScaleDamage(0)

        return dmginfo
    end

    if dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker().spawning then
        dmginfo:GetAttacker().spawning = false

        return dmginfo
    end

    return dmginfo
end

function GM:GetFallDamage(ply, speed)
    speed = speed - 580

    return speed * (100 / (1024 - 580))
end

function GM:PlayerSetHandsModel(ply, ent)
    local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
    local info = player_manager.TranslatePlayerHands(simplemodel)

    if info then
        ent:SetModel(info.model)
        ent:SetSkin(info.skin)
        ent:SetBodyGroups(info.body)
    end
end

function GM:PlayerUse(ply, ent)
    if ent:GetClass() == "func_door_*" then return true end
    if ent:GetClass() == "func_door" then return true end

    return false
end

function GM:ShowHelp(ply)
    ply:ChatPrint("To show this message, press F1.")
    ply:ChatPrint("To change teams, press F2.")
    ply:ChatPrint("To change loadout, press F3.")
end

function GM:ShowTeam(ply)
    ply:ConCommand("rtdm_team")
end

function GM:ShowSpare1(ply)
    ply:ConCommand("rtdm_loadout")
end

hook.Add("PlayerUse", "some_unique_name2", function(ply, ent)
    print(ply, ent)
end)
