net.Start("rtdm_weapons")
net.SendToServer()

net.Receive("rtdm_weapons", function(ply)
    file.Write("rtdm/weaponlists/main.txt", table.ToString(net.ReadTable()))
    file.Write("rtdm/weaponlists/side.txt", table.ToString(net.ReadTable()))
    file.Write("rtdm/weaponlists/side.txt", table.ToString(net.ReadTable()))
    primariestable = string.ToTable(file.Read("rtdm/weaponlists/main.txt"))
    secondariestable = string.ToTable(file.Read("rtdm/weaponlists/side.txt"))
    extrastable = string.ToTable(file.Read("rtdm/weaponlists/extra.txt"))
end)

function LoadoutMenu()
  local main = vgui.Create( "DFrame" )
  main:SetSize( 500, 500 )
  main:Center()
  main:MakePopup()
  
  local submain = vgui.Create( "DCategoryList", main )
  CatList:Dock( FILL )
  
  local Primaries = CatList:Add( "Main Weapons" )
  for i, v in next, primariestable do
    Primaries:Add( v[ 2 ] )
  end
  button.DoClick = function()
    p = i
  end

  local Secondaries = CatList:Add( "Side Weapons" )
  for i, v in next, primariestable do
    Primaries:Add( v[ 1 ] )
  end
  button.DoClick = function()
    s = i
  end

  local Extras = CatList:Add( "Extras" )
  for i, v in next, primariestable do
    Primaries:Add( v[ 2 ] )
  end
  button.DoClick = function()
    e = i
  end

  CatList:InvalidateLayout( true )

  requestloadout(p, s, e)
end

function requestloadout()
    net.Start("rtdm_loadout")
    net.WriteString(p)
    net.WriteString(s)
    net.WriteString(e)
    net.SendToServer()
end

concommand.Add("rtdm_loadout", LoadoutMenu())