function rtdm_team_select_screen()
    local rtdm_teamscreen = vgui.Create("DFrame")
    rtdm_teamscreen:SetPos((ScrW() / 100) * 37.5, (ScrW() / 100) * 7)
    rtdm_teamscreen:SetSize((ScrW() / 100) * 25, (ScrH() / 100) * 75)
    rtdm_teamscreen:SetTitle("")
    rtdm_teamscreen:SetVisible(true)
    rtdm_teamscreen:SetDraggable(false)
    rtdm_teamscreen:ShowCloseButton(false)
    rtdm_teamscreen:MakePopup()

    function rtdm_teamscreen:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(200, 200, 200, 0)) -- Draw a white box instead of the ugly gray.
    end

    local top = vgui.Create("DFrame", rtdm_teamscreen)
    top:SetPos(0, 0)
    top:SetSize(rtdm_teamscreen:GetWide(), rtdm_teamscreen:GetTall() / 6)
    top:SetTitle("")
    top:SetVisible(true)
    top:SetDraggable(false)
    top:ShowCloseButton(false)

    function top:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 250)) -- Draw a black box instead of the ugly gray.
        draw.DrawText("Team Deathmatch", "Trebuchet24", w * .5, h * .25, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        draw.DrawText("Pick your team below!", "Trebuchet24", w * .5, h * .5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end

    local join2 = vgui.Create("DButton", rtdm_teamscreen)
    join2:SetText("")
    join2:SetTextColor(Color(255, 255, 255))
    join2:SetPos(top:GetX(), top:GetY() + top:GetTall())
    join2:SetSize(top:GetWide(), top:GetTall() * 1.5)

    function join2:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, rtdm.config.team2color) -- Draw a blue button
        draw.DrawText(team.GetName(2), "Trebuchet24", w * .5, h * .5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end

    join2.DoClick = function()
        net.Start("rtdm_team")
        net.WriteInt(2, 4)
        net.SendToServer()
        rtdm_teamscreen:Remove()
    end

    local join3 = vgui.Create("DButton", rtdm_teamscreen)
    join3:SetText("")
    join3:SetTextColor(Color(255, 255, 255))
    join3:SetPos(join2:GetX(), join2:GetY() + join2:GetTall())
    join3:SetSize(join2:GetSize())

    function join3:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, rtdm.config.team3color) -- Draw a red button
        draw.DrawText(team.GetName(3), "Trebuchet24", w * .5, h * .5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end

    join3.DoClick = function()
        net.Start("rtdm_team")
        net.WriteInt(3, 4)
        net.SendToServer()
        rtdm_teamscreen:Remove()
    end

    local joinspectators = vgui.Create("DButton", rtdm_teamscreen)
    joinspectators:SetText("")
    joinspectators:SetTextColor(Color(255, 255, 255))
    joinspectators:SetPos(join3:GetX(), join3:GetY() + join3:GetTall())
    joinspectators:SetSize(join3:GetSize())

    function joinspectators:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(175, 175, 175, 250)) -- Draw a gray button
        draw.DrawText("Spectate", "Trebuchet24", w * .5, h * .5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end

    joinspectators.DoClick = function()
        net.Start("rtdm_team")
        net.WriteInt(1, 4)
        net.SendToServer()
        rtdm_teamscreen:Remove()
    end

    local CloseButton = vgui.Create("DButton", rtdm_teamscreen)
    CloseButton:SetText("")
    CloseButton:SetTextColor(Color(255, 255, 255))
    CloseButton:SetPos(top:GetWide() - (top:GetWide() / 20), 0)
    CloseButton:SetSize(top:GetWide() / 20, top:GetTall() / 4)

    function CloseButton:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(200, 200, 200, 0)) -- Draw a gray button
        draw.DrawText("X", "Trebuchet24", w * .5, h * .15, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end

    CloseButton.DoClick = function()
        rtdm_teamscreen:Remove()
    end
end

net.Receive("rtdm_team", function(len, ply)
    RunConsoleCommand("rtdm_loadout")
end)

concommand.Add("rtdm_team", function()
    rtdm_team_select_screen()
end)
