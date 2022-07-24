GM.Name = "rtdm"
GM.Author = "thechadraccoon"
GM.Email = "racc@thechadraccoon.xyz"
GM.Website = "thechadraccoon.xyz"

function GM:Initialize()
    team.SetUp(1, "Spectator", Color(0, 125, 0, 255)) -- just joined / afk
    team.SetUp(2, "Red", Color(200, 0, 0, 255)) -- Red team
    team.SetUp(3, "Blue", Color(0, 0, 200, 255)) -- Blue team  
    team.SetUp(4, "ffa", Color(0, 0, 0, 255)) -- black sheep team
end