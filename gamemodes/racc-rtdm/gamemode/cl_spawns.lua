local lp = LocalPlayer
local curS = {}
local nl = Vector(0, 0, 0)

hook.Add("PostDrawOpaqueRenderables", "DrawSpawnsTest", function()
    if lp():GetNWBool("placing") then
        if lp():GetNWVector("firstpos") ~= nl and lp():GetNWVector("secondpos") == nl then
            local pos = lp():GetNWVector("firstpos")
            local pos2 = lp():GetEyeTrace().HitPos
            cam.Start3D2D(pos + Vector(0, 0, 20), Angle(0, 0, 0), 1)
            surface.SetDrawColor(team.GetColor(lp():GetNWInt("pos_team")))
            surface.DrawOutlinedRect(0, 0, pos2.x - pos.x, pos.y - pos2.y)
            cam.End3D2D()
        elseif lp():GetNWVector("firstpos") ~= nl and lp():GetNWVector("secondpos") ~= nl then
            local pos = lp():GetNWVector("firstpos")
            local pos2 = lp():GetNWVector("secondpos")
            cam.Start3D2D(pos + Vector(0, 0, 20), Angle(0, 0, 0), 1)
            surface.SetDrawColor(team.GetColor(lp():GetNWInt("pos_team")))
            surface.DrawOutlinedRect(0, 0, pos2.x - pos.x, pos.y - pos2.y)
            cam.End3D2D()
        end
    else
        return
    end
end)

hook.Add("PostDrawOpaqueRenderables", "DrawSpawns4Real", function()
    for k, v in next, curS do
        local tea = team.GetColor(tonumber(v[1]))
        local pos = v[2]
        local pos2 = v[3]
        cam.Start3D2D(pos + Vector(0, 0, 20), Angle(0, 0, 0), 1)
        surface.SetDrawColor(tea)
        surface.DrawOutlinedRect(0, 0, pos2.x - pos.x, pos.y - pos2.y)
        cam.End3D2D()
    end
end)

net.Receive("debug_showspawns", function()
    local tab = net.ReadTable()
    curS = tab
end)
