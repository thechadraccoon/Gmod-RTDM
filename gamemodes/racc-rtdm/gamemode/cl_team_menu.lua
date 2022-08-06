function rtdm_team_select_screen()

    local rtdm_teamscreen = vgui.Create( "DFrame" )
    rtdm_teamscreen:SetPos( (ScrW() / 100 ) * 37.5,  (ScrW() / 100 ) * 7) 
    rtdm_teamscreen:SetSize( (ScrW() / 100 ) * 25, (ScrH() / 100 ) * 75 ) 
    rtdm_teamscreen:SetTitle( "" ) 
    rtdm_teamscreen:SetVisible( true ) 
    rtdm_teamscreen:SetDraggable( false ) 
    rtdm_teamscreen:ShowCloseButton( false ) 
    rtdm_teamscreen:MakePopup()
    function rtdm_teamscreen:Paint( w, h )
        draw.RoundedBox( 0, 0, 0 , w, h, Color( 200, 200, 200, 0 ) ) -- Draw a white box instead of the ugly gray.
    end
    local top = vgui.Create("DFrame", rtdm_teamscreen)
        top:SetPos( 0, 0 )
        top:SetSize( rtdm_teamscreen:GetWide(), rtdm_teamscreen:GetTall() / 6 )
        top:SetTitle( "" )
        top:SetVisible( true ) 
        top:SetDraggable( false ) 
        top:ShowCloseButton( false ) 
    function top:Paint( w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 250 ) ) -- Draw a black box instead of the ugly gray.
        draw.DrawText( "Team Deathmatch", "Trebuchet24", w * .5, h * .25, Color( 255, 255, 255, 255), TEXT_ALIGN_CENTER )
        draw.DrawText( "Pick your team below!", "Trebuchet24", w * .5, h * .5, Color( 255, 255, 255, 255), TEXT_ALIGN_CENTER )
    end

    local joinblue = vgui.Create("DButton", rtdm_teamscreen)
        joinblue:SetText( "" )
        joinblue:SetTextColor( Color(255,255,255) )
        joinblue:SetPos( top:GetX(), top:GetY() + top:GetTall() )
        joinblue:SetSize( top:GetWide(), top:GetTall() * 1.5 )
    function joinblue:Paint( w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 150, 250 ) ) -- Draw a blue button
        draw.DrawText( "Blues", "Trebuchet24", w * .5, h * .5, Color( 255, 255, 255, 255), TEXT_ALIGN_CENTER )
    end
    joinblue.DoClick = function()
        net.Start("rtdm_team")
        net.WriteInt( 3, 4)
        net.SendToServer()
        rtdm_teamscreen:Remove()
    end

    local joinred = vgui.Create("DButton", rtdm_teamscreen)
        joinred:SetText( "" )
        joinred:SetTextColor( Color(255,255,255) )
        joinred:SetPos( joinblue:GetX(), joinblue:GetY() + joinblue:GetTall() )
        joinred:SetSize( joinblue:GetSize() )
    function joinred:Paint( w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 150, 0, 0, 250 ) ) -- Draw a red button
        draw.DrawText( "Reds", "Trebuchet24", w * .5, h * .5, Color( 255, 255, 255, 255), TEXT_ALIGN_CENTER )
    end
    joinred.DoClick = function()
        net.Start("rtdm_team")
        net.WriteInt( 2, 4)
        net.SendToServer()
        rtdm_teamscreen:Remove()
    end

    local joinspectators = vgui.Create("DButton", rtdm_teamscreen)
    joinspectators:SetText( "" )
    joinspectators:SetTextColor( Color(255,255,255) )
    joinspectators:SetPos( joinblue:GetX(), joinred:GetY() + joinred:GetTall() )
    joinspectators:SetSize( joinred:GetSize() )
    function joinspectators:Paint( w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 175, 175, 175, 250 ) ) -- Draw a gray button
        draw.DrawText( "Spectate", "Trebuchet24", w * .5, h * .5, Color( 255, 255, 255, 255), TEXT_ALIGN_CENTER )
    end
    joinspectators.DoClick = function()
        net.Start("rtdm_team")
        net.WriteInt( 1, 4)
        net.SendToServer()
        rtdm_teamscreen:Remove()
    end
end

net.Receive("rtdm_team", function( len, ply)
    RunConsoleCommand("rtdm_loadout")
end)

concommand.Add("rtdm_team", function()
    rtdm_team_select_screen()
end)