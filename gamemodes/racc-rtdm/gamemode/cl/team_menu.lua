function ctdm_team_select_screen()
    if IsValid(ctdm_teamscreen) then
        ctdm_teamscreen:Hide()
        ctdm_teamscreen:Show()
    else
        local ctdm_teamscreen = vgui.Create( "DFrame" )
        ctdm_teamscreen:SetPos( 25%, 15% ) 
        ctdm_teamscreen:SetSize( 40%, 40% ) 
        ctdm_teamscreen:SetTitle( "" ) 
        ctdm_teamscreen:SetVisible( true ) 
        ctdm_teamscreen:SetDraggable( false ) 
        ctdm_teamscreen:ShowCloseButton( false ) 
        ctdm_teamscreen:MakePopup()
        function ctdm_teamscreen:Paint( w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200, 255 ) ) -- Draw a white box instead of the ugly gray.
        end
        local joinblue = vgui.Create("DButton", ctdm_teamscreen)
            joinblue:SetText( "joinblue" )
            joinblue:SetTextColor( Color(255,255,255) )
            joinblue:SetPos( 30%, 30% )
            joinblue:SetSize( 100, 30 )
        function joinblue:Paint( w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 200, 250 ) ) -- Draw a blue button
        end
        joinblue.DoClick = function()
            net.Start("ctdm_jointeam")
            net.WriteString("3")
            net.SendToServer()
            ctdm_teamscreen:Hide()
            RunConsoleCommand("rtdm_loadout")
        end

        local joinred = vgui.Create("DButton", ctdm_teamscreen)
            joinred:SetText( "Join Red team" )
            joinred:SetTextColor( Color(255,255,255) )
            joinred:SetPos( 30%, 60%% )
            joinred:SetSize( 100, 30 )
        function joinred:Paint( w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 0, 0, 250 ) ) -- Draw a blue button
        end
        joinred.DoClick = function()
            net.Start("ctdm_jointeam")
            net.WriteString("2")
            net.SendToServer()
            ctdm_teamscreen:Hide()
            RunConsoleCommand("rtdm_loadout")
        end
    end
end