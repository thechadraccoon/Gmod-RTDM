net.Start("rtdm_weapons")
net.SendToServer()

net.Receive("rtdm_weapons", function(ply)
        file.Write("rtdm/weaponlists/main.txt", net.ReadTable())
        file.Write("rtdm/weaponlists/main.txt", net.ReadTable())
        file.Write("rtdm/weaponlists/main.txt", net.ReadTable())
end)

function LoadoutMenu()

    main_weapons = string.ToTable(file.Read("rtdm/weaponlist/main.txt", "data"))
    side_weapons = string.ToTable(file.Read("/rtdm/weaponlist/sides.txt", "data"))
    extra_weapons = string.ToTable(file.Read("/rtdm/weaponlist/extras.txt", "data"))


  local main = vgui.Create("DFrame")
  frame:SetSize(75, 75)
  frame:Center()
  frame:MakePopup()
  local mainscroll = vgui.Create("DScrollPanel", main)
  DScrollPanel:Dock(FILL)

  for i, v in next, main_weapons do
      local DButton = mainscroll:Add("DButton")
      DButton:SetText("" .. i)
      DButton:Dock(TOP)
      DButton:DockMargin(0, 0, 0, 5)
  end
end
concommand.Add("rtdm_loadout", LoadoutMenu())