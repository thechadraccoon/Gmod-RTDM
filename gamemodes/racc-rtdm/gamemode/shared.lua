GM.Name = "rtdm"
GM.Author = "thechadraccoon"
GM.Email = "racc@thechadraccoon.xyz"
GM.Website = "thechadraccoon.xyz"
include("config.lua")

function GM:Initialize()
    team.SetUp(1, "Spectator", Color(0, 125, 0, 255)) -- just joined / afk
    team.SetUp(2, rtdm.config.team2name, rtdm.config.team2color) -- Red team
    team.SetUp(3, rtdm.config.team3name, rtdm.config.team3color) -- Blue team  
    team.SetUp(4, "ffa", Color(0, 0, 0, 255)) -- black sheep team
end
