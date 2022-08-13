net.Receive("rtdm_weapons", function(len, ply)
    local option = {}
    local sprimary = "None"
    local ssecondary = "None"
    local sextra = "None"
    local Primarytabactive = true
    local Secondarytabactive = false
    local Extratabactive = false
    local primaryequip = "arccw_apex_melee_wrench"
    local secondaryequip = "arccw_apex_melee_wrench"
    local extraequip = "arccw_apex_melee_wrench"
    local main = vgui.Create("DFrame")
    main:SetSize(ScrW() / 4 * 3, ScrH() / 4 * 3)
    main:SetTitle("")
    main:Center()
    main:ShowCloseButton(false)
    main:MakePopup()

    -- 'function Frame:Paint( w, h )' works too
    main.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(75, 75, 75, 250)) -- Draw a black box instead of the ugly grey window
    end

    local GridSizeW = (main:GetWide() / 100) * 65
    local GridSizeH = (main:GetTall() / 100) * 10
    local gridhost = vgui.Create("DScrollPanel", main)
    gridhost:SetSize(GridSizeW, GridSizeH)
    gridhost:Dock(LEFT)
    local GridSizeW = gridhost:GetWide()
    local GridSizeH = main:GetTall()
    Primaries = vgui.Create("DGrid", gridhost)
    Primaries:SetPos((gridhost:GetWide() / 100) * 0, (main:GetTall() / 100) * 10)
    Primaries:SetCols(6)
    Primaries:SetColWide(GridSizeW / 6)
    Primaries:SetRowHeight(GridSizeH / 5)
    Primaries:SetSize(GridSizeW, GridSizeH)

    for i, v in next, net.ReadTable() do
        option[v[2]] = vgui.Create("SpawnIcon", gridhost) -- SpawnIcon
        option[v[2]]:SetSize(Primaries:GetWide() / Primaries:GetCols(), Primaries:GetRowHeight())
        option[v[2]]:SetModel(v[3]) -- Model we want for this spawn icon

        option[v[2]].DoClick = function()
            surface.PlaySound("buttons/button15.wav")
            sprimary = v[1]
            primaryequip = tostring(v[2])
            mainselectedlabel:SetText("Main Weapon Selected: " .. v[1])
            mainselectedlabel:SizeToContents()
            weapondesc:SetText(v[4])
            weapondesc:SizeToContents()
        end

        Primaries:AddItem(option[v[2]])
    end

    Secondaries = vgui.Create("DGrid", gridhost)
    Secondaries:SetPos(Primaries:GetPos())
    Secondaries:SetCols(Primaries:GetCols())
    Secondaries:SetColWide(Primaries:GetColWide())
    Secondaries:SetRowHeight(Primaries:GetRowHeight())
    Secondaries:SetSize(Primaries:GetSize())
    Secondaries:Hide()

    for i, v in next, net.ReadTable() do
        option[v[2]] = vgui.Create("SpawnIcon", gridhost) -- SpawnIcon
        option[v[2]]:SetSize(Secondaries:GetWide() / Secondaries:GetCols(), Secondaries:GetRowHeight())
        option[v[2]]:SetModel(v[3]) -- Model we want for this spawn icon

        option[v[2]].DoClick = function()
            surface.PlaySound("buttons/button15.wav")
            ssecondary = v[1]
            secondaryequip = tostring(v[2])
            secselectedlabel:SetText("Secondary Weapon Selected: " .. v[1])
            secselectedlabel:SizeToContents()
            weapondesc:SetText(v[4])
            weapondesc:SizeToContents()
        end

        Secondaries:AddItem(option[v[2]])
    end

    Extras = vgui.Create("DGrid", gridhost)
    Extras:SetPos(Secondaries:GetPos())
    Extras:SetCols(Secondaries:GetCols())
    Extras:SetColWide(Secondaries:GetColWide())
    Extras:SetRowHeight(Secondaries:GetColWide())
    Extras:SetSize(Secondaries:GetSize())
    Extras:Hide()

    for i, v in next, net.ReadTable() do
        option[v[2]] = vgui.Create("SpawnIcon", gridhost) -- SpawnIcon
        option[v[2]]:SetSize(Extras:GetWide() / Extras:GetCols(), Extras:GetRowHeight())
        option[v[2]]:SetModel(v[3]) -- Model we want for this spawn icon

        option[v[2]].DoClick = function()
            surface.PlaySound("buttons/button15.wav")
            sextra = v[1]
            extraequip = tostring(v[2])
            extraselectedlabel:SetText("Extra Selected: " .. v[1])
            extraselectedlabel:SizeToContents()
            weapondesc:SetText(v[4])
            weapondesc:SizeToContents()
        end

        Extras:AddItem(option[v[2]])
    end

    tabs = vgui.Create("DFrame", main)
    tabs:SetSize(main:GetWide(), (main:GetTall() / 100) * 10)
    tabs:SetPos(0, (main:GetTall() / 100) * 0)
    local PrimaryTab = vgui.Create("DButton", tabs)
    PrimaryTab:SetText("")
    PrimaryTab:SetPos(0, 0)
    PrimaryTab:SetSize(tabs:GetWide() / 3, tabs:GetTall())

    PrimaryTab.DoClick = function()
        Primaries:Show()
        Secondaries:Hide()
        Extras:Hide()
        Primarytabactive = true
        Secondarytabactive = false
        Extratabactive = false
    end

    function PrimaryTab:Think()
        if Primarytabactive then
            function PrimaryTab:PaintOver(w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 250)) -- Draw a gray button
                draw.DrawText("Primary", "Trebuchet24", w * .5, h * .35, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
            end
        else
            function PrimaryTab:PaintOver(w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 250)) -- Draw a red button
                draw.DrawText("Primary", "Trebuchet24", w * .5, h * .35, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
            end
        end
    end

    local SecondaryTab = vgui.Create("DButton", tabs)
    SecondaryTab:SetText("Secondary")
    SecondaryTab:SetPos(tabs:GetWide() / 3, 0)
    SecondaryTab:SetSize(tabs:GetWide() / 3, tabs:GetTall())

    SecondaryTab.DoClick = function()
        Primaries:Hide()
        Secondaries:Show()
        Extras:Hide()
        Primarytabactive = false
        Secondarytabactive = true
        Extratabactive = false
    end

    function SecondaryTab:Think()
        if Secondarytabactive then
            function SecondaryTab:PaintOver(w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 250)) -- Draw a gray button
                draw.DrawText("Secondary", "Trebuchet24", w * .5, h * .35, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
            end
        else
            function SecondaryTab:PaintOver(w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 250)) -- Draw a red button
                draw.DrawText("Secondary", "Trebuchet24", w * .5, h * .35, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
            end
        end
    end

    local ExtraTab = vgui.Create("DButton", tabs)
    ExtraTab:SetText("Extra")
    ExtraTab:SetPos((tabs:GetWide() / 3) * 2, 0)
    ExtraTab:SetSize(tabs:GetWide() / 3, tabs:GetTall())

    ExtraTab.DoClick = function()
        Primaries:Hide()
        Secondaries:Hide()
        Extras:Show()
        Primarytabactive = false
        Secondarytabactive = false
        Extratabactive = true
    end

    function ExtraTab:Think()
        if Extratabactive then
            function ExtraTab:PaintOver(w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 250)) -- Draw a gray button
                draw.DrawText("Extras", "Trebuchet24", w * .5, h * .35, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
            end
        else
            function ExtraTab:PaintOver(w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 250)) -- Draw a red button
                draw.DrawText("Extras", "Trebuchet24", w * .5, h * .35, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
            end
        end
    end

    local CancelButton = vgui.Create("DButton", main)
    CancelButton:SetPos((main:GetWide() / 100) * 65.4, (main:GetTall() / 100) * 90)
    CancelButton:SetSize((main:GetWide() / 100) * 34.6, (main:GetTall() / 100) * 10)

    CancelButton.DoClick = function()
        if LocalPlayer():GetNWBool("rtdm_team_switchin") then
            net.Start("rtdm_loadout")
            net.WriteString(primaryequip)
            net.WriteString(secondaryequip)
            net.WriteString(extraequip)
            net.SendToServer()
            main:Remove()
        else
            main:Remove()
        end
    end

    function CancelButton:Think()
        if CancelButton:IsHovered() then
            function CancelButton:PaintOver(w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 250)) -- Draw a gray button
                draw.DrawText("Cancel", "Trebuchet24", w * .5, h * .35, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
            end
        else
            function CancelButton:PaintOver(w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 250)) -- Draw a red button
                draw.DrawText("Cancel", "Trebuchet24", w * .5, h * .35, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
            end
        end
    end

    local DoneButton = vgui.Create("DButton", main)
    DoneButton:SetPos(CancelButton:GetX(), CancelButton:GetY() - (main:GetTall() / 100) * 10)
    DoneButton:SetSize(CancelButton:GetSize())

    DoneButton.DoClick = function()
        net.Start("rtdm_loadout")
        net.WriteString(primaryequip)
        net.WriteString(secondaryequip)
        net.WriteString(extraequip)
        net.SendToServer()
        main:Remove()
    end

    function DoneButton:Think()
        if DoneButton:IsHovered() then
            function DoneButton:PaintOver(w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 250)) -- Draw a gray button

                if LocalPlayer():GetNWString("rtdm_team_switchin") then
                    draw.DrawText("Spawn!", "Trebuchet24", w * .5, h * .35, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
                else
                    draw.DrawText("Change Loadout!", "Trebuchet24", w * .5, h * .35, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
                end
            end
        else
            function DoneButton:PaintOver(w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 250)) -- Draw a red button

                if LocalPlayer():GetNWString("rtdm_team_switchin") then
                    draw.DrawText("Spawn!", "Trebuchet24", w * .5, h * .35, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
                else
                    draw.DrawText("Change Loadout!", "Trebuchet24", w * .5, h * .35, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
                end
            end
        end
    end

    weapondesc = vgui.Create("DLabel", main)
    weapondesc:SetText("")
    weapondesc:SetPos(GridSizeW + ((main:GetWide() / 100) * 10), (main:GetTall() / 100) * 15)
    weapondesc:SizeToContents()
    mainselectedlabel = vgui.Create("DLabel", main)
    mainselectedlabel:SetText("Main Weapon Selected: " .. sprimary)
    mainselectedlabel:SetPos(GridSizeW + ((main:GetWide() / 100) * 10), weapondesc:GetY() + weapondesc:GetTall() + (main:GetTall() / 100) * 5)
    mainselectedlabel:SizeToContents()
    secselectedlabel = vgui.Create("DLabel", main)
    secselectedlabel:SetText("Secondary Weapon Selected: " .. ssecondary)
    secselectedlabel:SetPos(GridSizeW + ((main:GetWide() / 100) * 10), mainselectedlabel:GetY() + mainselectedlabel:GetTall())
    secselectedlabel:SizeToContents()
    extraselectedlabel = vgui.Create("DLabel", main)
    extraselectedlabel:SetText("Extra Selected: " .. sextra)
    extraselectedlabel:SetPos(GridSizeW + ((main:GetWide() / 100) * 10), secselectedlabel:GetY() + secselectedlabel:GetTall())
    extraselectedlabel:SizeToContents()
end)

concommand.Add("rtdm_loadout", function()
    net.Start("rtdm_weapons")
    net.SendToServer()
end)
