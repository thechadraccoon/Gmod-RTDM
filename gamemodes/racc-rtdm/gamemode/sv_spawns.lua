if not file.Exists("rtdm/spawns", "DATA") then
    file.CreateDir("rtdm/spawns")
end

if not file.Exists("rtdm/spawns/" .. game.GetMap() .. ".txt", "DATA") then
    file.Write("rtdm/spawns/" .. game.GetMap() .. ".txt")
end

CreateConVar("rtdm_showspawns", "1", FCVAR_ARCHIVE, "0 = off, 1 = everyone, 2 = admins only, 3 = superadmins only")
util.AddNetworkString("debug_showspawns")
local curSpawns = {}
local nl = Vector(0, 0, 0)

function StartPlacement(ply)
    for k, v in next, player.GetAll() do
        if v:GetNWBool("placing") then
            ply:ChatPrint(v:Nick() .. " is already using spawn placement mode.")

            return
        end
    end

    ply:GodEnable()
    ply.OldWeps = {}

    for k, v in next, ply:GetWeapons() do
        table.insert(ply.OldWeps, v:GetClass())
    end

    ply:StripWeapons()
    ply:SetMoveType(MOVETYPE_NOCLIP)
    ply:ChatPrint("You are now in spawn placement mode. To exit, press alt.")
    ply:SetNWBool("placing", true)
end

function refreshspawns()
    local toApply = {}
    local fi = file.Read("rtdm/spawns/" .. game.GetMap() .. ".txt", "DATA")
    local exp = string.Explode("\n", fi)

    for k, v in next, exp do
        local toAdd = util.JSONToTable(v)
        table.insert(toApply, toAdd)
    end

    curSpawns = toApply
    local num = GetConVar("rtdm_showspawns"):GetInt()

    if num == 1 then
        net.Start("debug_showspawns")
        net.WriteTable(curSpawns)
        net.Broadcast()
    elseif num == 2 then
        for k, v in next, player.GetAll() do
            if ply:IsAdmin() then
                net.Start("debug_showspawns")
                net.WriteTable(curSpawns)
                net.Send(ply)
            end
        end
    elseif num == 3 then
        for k, v in next, player.GetAll() do
            if ply:IsSuperAdmin() then
                net.Start("debug_showspawns")
                net.WriteTable(curSpawns)
                net.Send(ply)
            end
        end
    end
end

function StopPlacement(ply)
    if not ply:GetNWBool("placing") then return end
    ply:GodDisable()
    ply:SetMoveType(MOVETYPE_WALK)

    for k, v in next, ply.OldWeps do
        ply:Give(v)
    end

    ply:ChatPrint("Observer mode exited.")
    ply:SetNWBool("placing", false)
    ply:SetNWVector("firstpos", nl)
    ply:SetNWVector("secondpos", nl)
    ply:SetNWInt("pos_team", 0)
    ply.selectteam = nil
    ply.confirming = false
end

function confirmpos(ply, point1, point2, t)
    ply:ChatPrint("Press ENTER to confirm these spawn positions, press BACKSPACE to cancel.")

    hook.Add("PlayerButtonDown", "confirm", function(ply, key)
        if ply.confirming and ply:GetNWBool("placing") then
            if key == KEY_ENTER then
                file.Append("rtdm/spawns/" .. game.GetMap() .. ".txt", util.TableToJSON({t, point1, point2}) .. "\n")

                ply:ChatPrint("Points saved!")
                refreshspawns()
                ply:SetNWVector("firstpos", nl)
                ply:SetNWVector("secondpos", nl)
                ply:SetNWInt("pos_team", 0)
                ply.selectteam = nil
                ply.confirming = false
                ply:SendLua([[surface.PlaySound( "garrysmod/ui_click.wav" )]])
            elseif key == KEY_BACKSPACE then
                ply:ChatPrint("Canceled point creation. Saved points cleared.")
                ply:SetNWVector("firstpos", nl)
                ply:SetNWVector("secondpos", nl)
                ply:SetNWInt("pos_team", 0)
                ply.selectteam = nil
                ply.confirming = false
                ply:SendLua([[surface.PlaySound( "garrysmod/ui_click.wav" )]])
            end
        end
    end)
end

hook.Add("PlayerButtonDown", "placement", function(ply, key)
    if (not ply.selectteam) and ply:GetNWBool("placing") then
        if key == MOUSE_LEFT then
            local pos = ply:GetEyeTrace().HitPos

            if ply:GetNWVector("firstpos") == nl and ply:GetNWVector("secondpos") == nl then
                if pos then
                    ply:SetNWVector("firstpos", pos)
                    ply:SendLua([[surface.PlaySound( "garrysmod/ui_click.wav" )]])
                end
            elseif ply:GetNWVector("firstpos") ~= nl and ply:GetNWVector("secondpos") == nl then
                if pos then
                    ply:SetNWVector("secondpos", pos)
                    ply:SendLua([[surface.PlaySound( "garrysmod/ui_click.wav" )]])
                    ply.selectteam = true
                    ply:ChatPrint("Press 1 for red team spawn, or 2 for blue team spawn")
                end
            end
        elseif key == MOUSE_RIGHT then
            if ply:GetNWVector("firstpos") ~= nl and ply:GetNWVector("secondpos") == nl then
                ply:SetNWVector("firstpos", nl)
                ply:ChatPrint("Undone location")
                ply:SendLua([[surface.PlaySound( "garrysmod/ui_click.wav" )]])
            end
        elseif key == KEY_LALT then
            StopPlacement(ply)
            ply:SendLua([[surface.PlaySound( "garrysmod/ui_click.wav" )]])
        end
    elseif ply.selectteam and ply:GetNWBool("placing") then
        if key == KEY_1 then
            local k = 1
            confirmpos(ply, ply:GetNWVector("firstpos"), ply:GetNWVector("secondpos"), 1)
            ply.confirming = true
            ply:SendLua([[surface.PlaySound( "garrysmod/ui_click.wav" )]])
            ply.selectteam = nil
            ply:SetNWInt("pos_team", 1)
        elseif key == KEY_2 then
            local k = 2
            confirmpos(ply, ply:GetNWVector("firstpos"), ply:GetNWVector("secondpos"), 2)
            ply.confirming = true
            ply:SendLua([[surface.PlaySound( "garrysmod/ui_click.wav" )]])
            ply.selectteam = nil
            ply:SetNWInt("pos_team", 2)
        elseif key == MOUSE_RIGHT then
            ply:SetNWVector("secondpos", nl)
            ply.selectteam = false
            ply:ChatPrint("Undone location")
            ply:SendLua([[surface.PlaySound( "garrysmod/ui_click.wav" )]])
        end
    end
end)

hook.Add("PlayerSpawn", "OverrideSpawnLocations", function(ply)
    local availablespawns = false

    for k, v in next, curSpawns do
        if v[1] == ply:Team() then
            availablespawns = true
            break
        end
    end

    if availablespawns == true then
        local tabspawns = {}

        for k, v in next, curSpawns do
            if v[1] == ply:Team() then
                table.insert(tabspawns, v)
            end
        end

        local tospawn = table.Random(tabspawns)
        local bound1 = tospawn[2]
        local bound2 = tospawn[3]
        local locationx = math.random(bound1.x, bound2.x)
        local locationy = math.random(bound1.y, bound2.y)
        local z = bound1.z + 5
        local vec = Vector(locationx, locationy, z)

        while true do
            local en = ents.FindInSphere(vec, 40)
            local safe = true

            for k, v in next, en do
                if IsValid(v) and v:IsPlayer() then
                    safe = false
                    locationx = math.random(bound1.x, bound2.x)
                    locationy = math.random(bound1.y, bound2.y)
                    vec = Vector(locationx, locationy, z)
                    break
                end
            end

            if safe then
                ply:SetPos(vec)
                break
            end
        end
    end
end)

concommand.Add("debug_showspawns", function(ply)
    local num = GetConVar("rtdm_showspawns"):GetInt()

    if num == 1 then
        net.Start("debug_showspawns")
        net.WriteTable(curSpawns)
        net.Send(ply)
    elseif num == 2 then
        if ply:IsAdmin() then
            net.Start("debug_showspawns")
            net.WriteTable(curSpawns)
            net.Send(ply)
        end
    elseif num == 3 then
        if ply:IsSuperAdmin() then
            net.Start("debug_showspawns")
            net.WriteTable(curSpawns)
            net.Send(ply)
        end
    end
end)

concommand.Add("rtdm_placespawns", function(ply)
    if ply:Alive() and IsValid(ply) then
        if ply:IsSuperAdmin() then
            StartPlacement(ply)
        end
    end
end)

hook.Add("PlayerSpawn", "SendSpawns", function(ply)
    if ply:GetNWBool("placing") then
        StopPlacement(ply)
    end

    local num = GetConVar("rtdm_showspawns"):GetInt()

    if num == 1 then
        net.Start("debug_showspawns")
        net.WriteTable(curSpawns)
        net.Send(ply)
    elseif num == 2 then
        if ply:IsAdmin() then
            net.Start("debug_showspawns")
            net.WriteTable(curSpawns)
            net.Send(ply)
        end
    elseif num == 3 then
        if ply:IsSuperAdmin() then
            net.Start("debug_showspawns")
            net.WriteTable(curSpawns)
            net.Send(ply)
        end
    end
end)

hook.Add("PlayerDeath", "wtf", function(ply)
    if ply:GetNWBool("placing") then
        StopPlacement(ply)
    end
end)

refreshspawns()
