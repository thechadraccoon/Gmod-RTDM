hook.Add( "PlayerSay", "tdm_say", function( ply, text, bTeam )

    local howweapons = {
            "how do i switch weapons",
            "switch weapons",
            "change weapons",
            "change weapon",
            "switch weapon",
            "change loadout",
            "switch loadout",
            "different weapons"
    }

    local howteams = {
        "how do i switch teams",
        "switch teams",
        "change team"
    }

    local racc = {
		"racc can you",
		"racc can i",
		"racc may i",
		"racc is it okay if",
		"racc is it okay",
		"racc pls",
		"racc plz",
		"racc could you",
		"racc please",
		"racc i need",
		"racc help me",
		"racc would you",
		"racc will you",
		}

        if( text:lower() == "!team" ) then
            ply:ConCommand( "rtdm_team" )
        elseif( text:lower() == "!loadout" ) then
            ply:ConCommand( "rtdm_loadout" )
        end

        for k, v in next, howweapons do
            if string.find( text:lower(), v ) then
                timer.Simple(0, function() 
                    ply:ChatPrint("To change your loadout, press F2." )
                end)
                break
            end
        end

        for k, v in next, howteams do
            if string.find( text:lower(), v ) then
                timer.Simple(0, function() 
                    ply:ChatPrint("To change your team, press F1." )
                end)
                break
            end
        end

        for k, v in next, racc do
            if string.find( text:lower(), v ) then
                timer.Simple(0, function() 
                    ply:ChatPrint("No." )
                end)
                break
            end
        end

    return
end)