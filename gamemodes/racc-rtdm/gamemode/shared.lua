GM.Name = "rtdm"
GM.Author = "thechadraccoon"
GM.Email = "racc@thechadraccoon.xyz"
GM.Website = "thechadraccoon.xyz"
include("config.lua")

function GM:Initialize()
    team.SetUp(0, "Spectator", Color(0, 125, 0, 255)) -- just joined / afk
    team.SetUp(1, rtdm.config.team1name, rtdm.config.team1color) -- Red team
    team.SetUp(2, rtdm.config.team2name, rtdm.config.team2color) -- Blue team  
    team.SetUp(3, "ffa", Color(0, 0, 0, 255)) -- black sheep team
end
