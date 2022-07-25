--------------------------------------------
-- Let's start by initiating the gamemode --
--------------------------------------------4
-- Send these lua files to client.
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl/loadout_menu.lua")
AddCSLuaFile("cl/team_menu.lua")
AddCSLuaFile("shared.lua")
-- Load these serverside.
include("shared.lua")
include("team_handler.lua")
include("loadout_handler.lua")
-- Document network messages
util.AddNetworkString("rtdm_player_initiated")
util.AddNetworkString("rtdm_jointeam")
util.AddNetworkString("rtdm_chatmessage")
-- Create the Variables for the gamemode
CreateConVar("rtdm_ffa", 0, FCVAR_PROTECTED, "Make the game FFA?", 0, 1)

-- Read convars and SetBooleans globaly
if GetConVar("rtdm_ffa") == 0 then
    SetGlobalBool("rtdm_ffa", false)
else
    SetGlobalBool("rtdm_ffa", true)
end

-- When we know the player has fully loaded welcome them to the server.
net.Receive("rtdm_player_initiated", function(len, ply)
    net.Start("rtdm_player_initiated")
    net.Send(ply)
end)

ents.GetAll():Remove()


function GM:PlayerInitialSpawn( ply )

    ply:ConCommand( "cw_customhud 0" )
	ply:ConCommand( "cw_customhud_ammo 0" )
	ply:ConCommand( "cw_crosshair 1" )
	ply:ConCommand( "cw_blur_reload 0" )
	ply:ConCommand( "cw_blur_customize 0" )
	ply:ConCommand( "cw_blur_aim_telescopic 0" )
	ply:ConCommand( "cw_simple_telescopics 1" )
	ply:ConCommand( "cw_customhud_ammo 1" )
	ply:ConCommand( "cw_laser_quality 1" )
	ply:ConCommand( "cw_alternative_vm_pos 0" )
	ply:ConCommand( "cl_deathview 0" )

    ply:SetTeam( 1 )
	ply:Spectate( OBS_MODE_ROAMING )

end

function GM:PlayerDisconnected( ply )
end

function GM:PlayerShouldTakeDamage( ply, attacker )
	if( GetGlobalBool("rtdm_ffa") == 1 ) then
		return true
	end
	
	if ply and attacker and ply ~= NULL and attacker ~= NULL then
		if IsValid( attacker ) and IsValid( ply ) and attacker:IsPlayer() and ply:IsPlayer() then
			if ply and attacker and ply:Team() ~= nil and attacker:Team() ~= nil then
				if( GetGlobalBool("rtdm_ffa") == 0 and ply:Team() == attacker:Team() ) then
					return false
				end
			end
		end
	end
	
	return true
end



function GM:PlayerSpawn( ply )

	if( ply:Team() == 0 ) then
		ply:Spectate( OBS_MODE_IN_EYE )
		SetupSpectator( ply )
		return
	end
	
	ply:AllowFlashlight( true )
	
	self.BaseClass:PlayerSpawn( ply )
	
		local playermodels = {
		"models/player/group03/male_01.mdl",
		"models/player/group03/male_02.mdl",
		"models/player/group03/male_03.mdl",
		"models/player/group03/male_04.mdl",
		"models/player/group03/male_05.mdl",
        "models/player/group03/male_06.mdl",
		"models/player/group03/male_07.mdl",
		"models/player/group03/male_08.mdl",
		"models/player/group03/male_09.mdl"
		}
        ply:SetModel(table.Random(playermodels))

	ply:SetPlayerColor( col[ply:Team()] )
	giveLoadout( ply )

    ply:SetJumpPower( 170 ) -- Decreased Jump hight due to jumping bastards.
	
	ply:SetWalkSpeed( defaultWalkSpeed )
	ply:SetRunSpeed( defaultRunSpeed )

	if GetGlobalBool( "RoundFinished" ) then
		ply:SetWalkSpeed( 200 )
		ply:SetRunSpeed( 360 )
	end

	timer.Simple( 1, function()
		if ply:IsPlayer() then
			for k, v in pairs( ply:GetWeapons() ) do
				local x = v:GetPrimaryAmmoType()
				local y = v:Clip1()
				local give = true
				
				if give == true then
					ply:GiveAmmo( ( y * 5 ), x, true )
				end
			end
		end
	end )
	
	ply:SetColor( Color( 255, 255, 255, 200 ) )
	ply:SetRenderMode( RENDERMODE_TRANSALPHA )
	ply:SetNoCollideWithTeammates( true )
	end )
	
	if GetGlobalBool( "RoundFinished" ) then
		timer.Simple( 0, function()
			ply:StripWeapons()
			ply:Give( "weapon_crowbar" )
		end )
	end
end

function GM:PlayerDeath( vic, inf, att )
	if( vic:IsValid() and att:IsValid() and att:IsPlayer() ) then
		if( vic == att ) then
			return
		end
		vic:SetFOV( 0, 0 )
		net.Start( "tdm_deathnotice" )
			net.WriteEntity( vic )
			net.WriteString( att.LastUsedWep )
			net.WriteEntity( att )
			net.WriteString( tostring( vic:LastHitGroup() == HITGROUP_HEAD ) )
		net.Broadcast()
    end
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	if hitgroup == HITGROUP_HEAD then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 1.5 )
		end
	elseif hitgroup == HITGROUP_CHEST then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 1 )
		end
	elseif hitgroup == HITGROUP_STOMACH then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 1 )
		end
	elseif hitgroup == HITGROUP_LEFTARM then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 0.9 )
		end
	elseif hitgroup == HITGROUP_RIGHTARM then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 0.9 )
		end
	elseif hitgroup == HITGROUP_LEFTLEG then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 0.8 )
		end
	elseif hitgroup == HITGROUP_RIGHTLEG then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 0.8 )
		end
	else
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 1 )
		end
	end
end

function GM:EntityTakeDamage( ply, dmginfo )
	if( ply.spawning ) then
		local dmg = dmginfo:GetDamage()
		if dmginfo:GetAttacker() and dmginfo:GetAttacker() ~= NULL and dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():Team() ~= ply:Team() then
			dmginfo:GetAttacker():TakeDamage( dmg )
			dmginfo:GetAttacker():ChatPrint( "Don't shoot people in spawn protection!" )
		end
		dmginfo:ScaleDamage( 0 )
		return dmginfo
	end
	
	if( dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker().spawning ) then
		dmginfo:GetAttacker().spawning = false
		return dmginfo
	end
	
    return dmginfo
end

function GM:GetFallDamage( ply, speed )
	speed = speed - 580
	return ( speed * ( 100 / ( 1024 - 580 ) ) )
end