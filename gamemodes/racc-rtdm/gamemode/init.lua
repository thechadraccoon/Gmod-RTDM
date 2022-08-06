--------------------------------------------
-- Let's start by initiating the gamemode --
--------------------------------------------4
-- Send these lua files to client.
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_loadout_menu.lua")
AddCSLuaFile("cl_team_menu.lua")
AddCSLuaFile("shared.lua")
-- Load these serverside.
include("shared.lua")
include("sv_team_handler.lua")
include("sv_loadout_handler.lua")
include("sv_map_cleaner.lua")
include("sv_chat_messages.lua")
include("sv_debug.lua")
-- Document network messages
util.AddNetworkString("rtdm_player_initiated")
util.AddNetworkString("rtdm_chatmessage")

local playermodels = {
	"models/player/group01/male_01.mdl",
	"models/player/group01/male_02.mdl",
	"models/player/group01/male_03.mdl",
	"models/player/group01/male_04.mdl",
	"models/player/group01/male_05.mdl",
	"models/player/group01/male_06.mdl",
	"models/player/group01/male_07.mdl",
	"models/player/group01/male_08.mdl",
	"models/player/group01/male_09.mdl",
	"models/player/group02/male_02.mdl",
	"models/player/group02/male_04.mdl",
	"models/player/group02/male_06.mdl",
	"models/player/group02/male_08.mdl",
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

-- When we know the player has fully loaded start client stuff.
net.Receive("rtdm_player_initiated", function(len, ply)
    net.Start("rtdm_player_initiated")
    net.Send(ply)
end)

function GM:PlayerInitialSpawn( ply )

	ply:SetTeam( 1 )
	ply:Spectate( OBS_MODE_ROAMING )
	ply:SetNWBool("rtdm_team_playing", false)
	ply:SetNWInt("rtdm_team_switch_id", 1)

	if file.Exists("rtdm/players/"..ply:SteamID64() , "DATA") then
		if file.Exists("rtdm/players/"..ply:SteamID64().."/loadout.json", "DATA") then
			return
		else
			file.Write("rtdm/players/"..ply:SteamID64().."/loadout.json", "")
		end
	else
		file.CreateDir("rtdm/players/"..ply:SteamID64())
		file.Write("rtdm/players/"..ply:SteamID64().."/loadout.json", "")
	end

end

function GM:PlayerDisconnected( ply )
end

function GM:PlayerShouldTakeDamage( ply, attacker )
	if ply:IsValid() then
		if attacker:IsValid() then
			if ply:Team() == attacker:Team() then
				return false
			else
				return true
			end
		else
			return
		end
	else
		return
	end
end

function GM:PlayerSpawn( ply )
	
	ply:AllowFlashlight( true )
	
	ply:SetPlayerColor( team.GetColor( ply:Team()):ToVector() )

    ply:SetJumpPower( 170 ) -- Decreased Jump hight due to jumping bastards.
	
	ply:SetWalkSpeed( 200 )
	ply:SetRunSpeed( 300 )

	if GetGlobalBool( "RoundFinished" ) then
		ply:SetWalkSpeed( 200 )
		ply:SetRunSpeed( 360 )
	end
	
	ply:SetColor( Color( 255, 255, 255, 200 ) )
	ply:SetRenderMode( RENDERMODE_TRANSCOLOR )
	ply:SetNoCollideWithTeammates( true )
	timer.Simple(5, function()
		ply:SetColor( Color( 255, 255, 255, 255 ) )
		ply:SetRenderMode( RENDERMODE_TRANSCOLOR )
	end)


	if ( ply:Team() ~= 1 ) then
		giveLoadout( ply )
		ply:UnSpectate()
		ply:SetModel(table.Random(playermodels))
		ply:SetupHands()
	else
		ply:StripWeapons()
        ply:Spectate( OBS_MODE_ROAMING )
	end

end

function GM:PlayerDeath( vic, inf, att )
	if( vic:IsValid() and att:IsValid() and att:IsPlayer() ) then
		if( vic == att ) then
			return
		end
		
		for k, v in pairs(att:GetWeapons()) do 
			att:GiveAmmo( v:Clip1() * 1 , v:GetPrimaryAmmoType(), true )
		end
		
		vic:SetFOV( 0, 0 )
		--[[net.Start( "tdm_deathnotice" )
			net.WriteEntity( vic )
			net.WriteString( att.LastUsedWep )
			net.WriteEntity( att )
			net.WriteString( tostring( vic:LastHitGroup() == HITGROUP_HEAD ) )
		net.Broadcast()]]--
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

function GM:PlayerSetHandsModel( ply, ent )

	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end

end

function GM:PlayerUse(ply,ent)
	return false
end

function GM:ShowHelp( ply )
	ply:ConCommand("rtdm_team")
end

function GM:ShowTeam( ply )
	ply:ConCommand("rtdm_loadout")
end