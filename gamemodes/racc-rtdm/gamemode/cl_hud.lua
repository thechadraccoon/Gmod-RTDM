rtdm_hud = {}

local rtdm_hud_hidestuff = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudCrosshair"] = false,
    ["CHudDamageIndicator"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["CHudSquadStatus"] = true,
    ["CHudPoisonDamageIndicator"] = true,
    ["CHudVehicle"] = true,
    ["CHudAmmo"] = true,
}

hook.Add("HUDShouldDraw", "HideHUD", function(name)
    if rtdm_hud_hidestuff[name] then return false end
end)

hook.Add("HUDDrawTargetID", "HidePlayerInfo", function() return false end)

hook.Add("HUDPaint", "HUDPaint_DrawABox", function()
    local ply = LocalPlayer()

    if (ply:Team() == 1) or (ply:Team() == 2) or (ply:Team() == 3) and ply:Alive() then
        if ply:GetObserverMode() == 0 then
            local hp = ply:Health()
            local armor = ply:Armor()

            if ply:GetActiveWeapon():IsValid() then
                local magammo = ply:GetActiveWeapon():Clip1()
                local ammo_res = ply:GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType()) - ply:GetActiveWeapon():GetMaxClip1()
            end

            local team2name = GetGlobalString("rtdm_team2name")
            local team3name = GetGlobalString("rtdm_team3name")
            --Text Color.
            color_white = Color(255, 255, 255)
            surface.SetTextColor(color_white)
            -- HP & Armor HUD Panel.
            --surface.SetDrawColor( 0, 0, 0, 255 )
            --surface.DrawRect( (ScrW() / 100 ) * 3, (ScrH() / 100) * 81.5, (ScrW() / 100 ) * 19, (ScrH() / 100) * 15 )
            -- Background HP Bar
            surface.SetDrawColor(25, 25, 25, 175)
            surface.DrawRect((ScrW() / 100) * 8.5, (ScrH() / 100) * 84, (ScrW() / 100) * 100 / 11, (ScrH() / 100) * 1)
            -- Red HP Bar
            surface.SetDrawColor(200, 0, 0, 250)
            surface.DrawRect((ScrW() / 100) * 8.5, (ScrH() / 100) * 84, (ScrW() / 100) * 100 / 11, (ScrH() / 100) * 1)
            -- HP:
            surface.SetFont("DermaLarge")
            surface.SetTextColor(25, 25, 25, 175)
            surface.SetTextPos((ScrW() / 100) * 3.6, (ScrH() / 100) * 83.1)
            surface.DrawText("Vitality: ")
            surface.SetFont("DermaLarge")
            surface.SetTextColor(color_white)
            surface.SetTextPos((ScrW() / 100) * 3.5, (ScrH() / 100) * 83)
            surface.DrawText("Vitality: ")
            -- HP%
            surface.SetFont("DermaLarge")
            surface.SetTextColor(25, 25, 25, 175)
            surface.SetTextPos((ScrW() / 100) * 18.1, (ScrH() / 100) * 83.1)
            surface.DrawText(hp .. "%")
            surface.SetFont("DermaLarge")
            surface.SetTextColor(color_white)
            surface.SetTextPos((ScrW() / 100) * 18, (ScrH() / 100) * 83)
            surface.DrawText(hp .. "%")
            -- Background Armor Bar
            surface.SetDrawColor(25, 25, 25, 175)
            surface.DrawRect((ScrW() / 100) * 8.5, (ScrH() / 100) * 87, (ScrW() / 100) * 100 / 11, (ScrH() / 100) * 1)
            -- Blue Armor Bar
            surface.SetDrawColor(0, 0, 200, 250)
            surface.DrawRect((ScrW() / 100) * 8.5, (ScrH() / 100) * 87, (ScrW() / 100) * armor / 11, (ScrH() / 100) * 1)
            -- Armor:
            surface.SetFont("DermaLarge")
            surface.SetTextColor(25, 25, 25, 175)
            surface.SetTextPos((ScrW() / 100) * 3.6, (ScrH() / 100) * 86.1)
            surface.DrawText("Armor: ")
            surface.SetFont("DermaLarge")
            surface.SetTextColor(color_white)
            surface.SetTextPos((ScrW() / 100) * 3.5, (ScrH() / 100) * 86)
            surface.DrawText("Armor: ")
            -- Armor%
            surface.SetFont("DermaLarge")
            surface.SetTextColor(25, 25, 25, 175)
            surface.SetTextPos((ScrW() / 100) * 18.1, (ScrH() / 100) * 86.1)
            surface.DrawText(armor .. "%")
            surface.SetFont("DermaLarge")
            surface.SetTextColor(color_white)
            surface.SetTextPos((ScrW() / 100) * 18, (ScrH() / 100) * 86)
            surface.DrawText(armor .. "%")
            --K:D 
            surface.SetFont("DermaLarge")
            surface.SetTextColor(25, 25, 25, 175)
            surface.SetTextPos((ScrW() / 100) * 3.6, (ScrH() / 100) * 89.1)
            surface.DrawText("Kills: " .. ply:Frags() .. " | Deaths: " .. ply:Deaths())
            surface.SetFont("DermaLarge")
            surface.SetTextColor(color_white)
            surface.SetTextPos((ScrW() / 100) * 3.5, (ScrH() / 100) * 89)
            surface.DrawText("Kills: " .. ply:Frags() .. " | Deaths: " .. ply:Deaths())
            -- team 1 name shadow
            surface.SetFont("DermaLarge")
            surface.SetTextPos((ScrW() / 100) * 5.1, (ScrH() / 100) * 92.1)
            surface.SetTextColor(25, 25, 25, 175)
            surface.DrawText(team.GetName(1))
            -- team 1 name
            surface.SetFont("DermaLarge")
            surface.SetTextPos((ScrW() / 100) * 5, (ScrH() / 100) * 92)
            surface.SetTextColor(team.GetColor(1))
            surface.DrawText(team.GetName(1))
            -- VS shadow
            surface.SetFont("DermaLarge")
            surface.SetTextPos((ScrW() / 100) * 11.6, (ScrH() / 100) * 92.1)
            surface.SetTextColor(25, 25, 25, 175)
            surface.DrawText("VS.")
            -- VS
            surface.SetFont("DermaLarge")
            surface.SetTextPos((ScrW() / 100) * 11.5, (ScrH() / 100) * 92)
            surface.SetTextColor(color_white)
            surface.DrawText("VS.")
            -- team 2 name shadow
            surface.SetFont("DermaLarge")
            surface.SetTextPos((ScrW() / 100) * 16.1, (ScrH() / 100) * 92.1)
            surface.SetTextColor(25, 25, 25, 175)
            surface.DrawText(team.GetName(2))
            -- team 2 name
            surface.SetFont("DermaLarge")
            surface.SetTextPos((ScrW() / 100) * 16, (ScrH() / 100) * 92)
            surface.SetTextColor(team.GetColor(2))
            surface.DrawText(team.GetName(2))

            -- Ammo stuff
            if ply:GetActiveWeapon() ~= NULL then
                if ply:GetActiveWeapon():Clip1() > 0 or ply:GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType()) > 0 then
                    surface.SetFont("DermaLarge")
                    surface.SetTextColor(25, 25, 25, 175)
                    surface.SetTextPos((ScrW() / 100) * 90.1, (ScrH() / 100) * 92.1)
                    surface.DrawText(ply:GetActiveWeapon():Clip1() .. " | " .. ply:GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType()))
                    surface.SetFont("DermaLarge")
                    surface.SetTextColor(color_white)
                    surface.SetTextPos((ScrW() / 100) * 90, (ScrH() / 100) * 92)
                    surface.DrawText(ply:GetActiveWeapon():Clip1() .. " | " .. ply:GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType()))
                end
            end

            if GetGlobalBool("rtdm_ffa") then
                surface.SetFont("DermaLarge")
                surface.SetTextPos((ScrW() / 100) * 3.6, (ScrH() / 100) * 92.1)
                surface.DrawText("FFA")
                surface.SetFont("DermaLarge")
                surface.SetTextPos((ScrW() / 100) * 3.5, (ScrH() / 100) * 92)
                surface.DrawText("FFA")
            else
                -------------
                -- Tickets --
                -------------
                if team2tickets == nil and team3tickets == nil then
                    team2tickets = 0
                    team3tickets = 0
                end

                -- team 1 ticket shadow
                surface.SetFont("DermaLarge")
                surface.SetTextPos((ScrW() / 100) * 37.6, (ScrH() / 100) * 2.1)
                surface.SetTextColor(25, 25, 25, 175)
                surface.DrawText(tostring(GetGlobalInt("rtdm_tickets_team1tickets")))
                -- team 1 ticket
                surface.SetFont("DermaLarge")
                surface.SetTextPos((ScrW() / 100) * 37.5, (ScrH() / 100) * 2)
                surface.SetTextColor(team.GetColor(1))
                surface.DrawText(tostring(GetGlobalInt("rtdm_tickets_team1tickets")))
                -- team 2 ticket shadow
                surface.SetFont("DermaLarge")
                surface.SetTextPos((ScrW() / 100) * 57.5, (ScrH() / 100) * 2)
                surface.SetTextColor(team.GetColor(2))
                surface.DrawText(tostring(GetGlobalInt("rtdm_tickets_team2tickets")))
                -- team 2 ticket
                surface.SetFont("DermaLarge")
                surface.SetTextPos((ScrW() / 100) * 57.6, (ScrH() / 100) * 2.1)
                surface.SetTextColor(25, 25, 25, 175)
                surface.DrawText(tostring(GetGlobalInt("rtdm_tickets_team2tickets")))
            end
        end
    end

    -----------
    -- TIMER --
    -----------
    surface.SetFont("DermaLarge")
    surface.SetTextPos((ScrW() / 100) * 47.6, (ScrH() / 100) * 2.1)
    surface.SetTextColor(25, 25, 25, 175)
    surface.DrawText(string.ToMinutesSeconds(tostring(GetGlobalInt("rtdm_game_timeleft"))))
    surface.SetFont("DermaLarge")
    surface.SetTextPos((ScrW() / 100) * 47.5, (ScrH() / 100) * 2)
    surface.SetTextColor(color_white)
    surface.DrawText(string.ToMinutesSeconds(tostring(GetGlobalInt("rtdm_game_timeleft"))))
end)
