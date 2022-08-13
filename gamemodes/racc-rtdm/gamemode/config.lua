-- Pretty code pls no touch
rtdm = {}
rtdm.config = {}
rtdm.config.loadout = {}
-------------------
-- Game Settings --
-------------------
rtdm.config.ticketcount = 100 -- the amount of tickets that need to be depleted from the other team. ( Default: 100 )
rtdm.config.gametime = 300 -- How long should the match last? ( default: 30 mins )
rtdm.config.suicidetimer = 15 -- How long should a player having typed "kill" or "explode" in the console have to wait before being respawned at the cost of a ticket?
rtdm.config.ffa = false -- Are we playing free for all? ( Default: false )
----------------
-- Team Stuff --
----------------
rtdm.config.team2name = "Necos" -- Team 2's name.
rtdm.config.team3name = "Nyns" -- Team 3's name
rtdm.config.team2color = Color(150, 0, 0, 250) -- Team 2's color
rtdm.config.team3color = Color(140, 70, 190, 250) -- Team 3's color
rtdm.config.team2plymdl = "models/necoarc2/necoarc2_model.mdl" -- Player model for Team 2
rtdm.config.team3plymdl = "models/player/nyn.mdl" -- Player model for Team 3

-------------
-- Weapons --
-------------
rtdm.config.loadout.main_weapons = {
    {"30-30 Repeater", "arccw_apex_3030", "models/weapons/w_apex_3030.mdl", "The 30-30 has a unique charge mechanic allowing the weapon to do up to 36% more damage by aiming down the sights for longer without firing. It can also be simply fired without charging at a higher fire rate."},
    {"Alternator SMG", "arccw_apex_alternator", "models/weapons/w_apex_alternator.mdl", "Twin barrel full-auto SMG."},
    {"Bocek Compound Bow", "arccw_apex_bocek", "models/weapons/c_apex_compound_bow.mdl", "Unlike other weapons, the Bocek fires an arrow when the Fire button (default: Left click) is released. Holding the button for longer before firing will increase its damage and velocity. Pressing Reload (default: R ) while charging an arrow will un-nock it without firing. "},
    {"Devotion LMG", "arccw_apex_devotion", "models/weapons/w_apex_car.mdl", "The Devotion LMG has a unique RPM acceleration mechanic: the longer the Devotion is fired continuously, the faster its fire rate will become, up to a cap."},
    {"EVA-8 Auto", "arccw_apex_eva", "models/weapons/w_apex_eva8.mdl", "The EVA-8 Auto, or EVA-8, is a fully-automatic shotgun that fires 9 pellets in the shape of the number 8. "},
    {"G7 Scout", "arccw_apex_g7", "models/weapons/w_apex_g7.mdl", "The G7 Scout is Semi-auto light Marksman Rifle. Its precision deals massive damage."},
    {"HAVOC Rifle", "arccw_apex_havoc", "models/weapons/w_apex_havoc.mdl", "Full-auto charged energy rifle."},
    {"Hemlok Burst AR", "arccw_apex_hemlok", "models/weapons/w_apex_hemlok.mdl", "The Hemlok Burst AR, also called Hemlok, may be switched between a 3-shot burst and single fire modes."},
    {"Longbow DMR", "arccw_apex_longbow", "models/weapons/w_apex_longbow.mdl", "Semi-automatic designated marksman rifle"},
    {"M600 Spitfire", "arccw_apex_spitfire", "models/weapons/w_apex_spitfire.mdl", "Fully-automatic light machine gun"},
    {"Mastiff Shotgun ", "arccw_apex_mastiff", "models/weapons/w_apex_mastiff.mdl", "The Mastiff Shotgun, or Mastiff, is a semi-automatic shotgun that fires 8 pellets in the shape of a horizontal line, which decreases in width while aiming down the sights, reducing the spread and thus increasing accuracy."},
    {"Peacekeeper Shotgun", "arccw_apex_peacekeeper", "models/weapons/w_apex_peacekeeper.mdl", "The Peacekeeper is a lever-action energy shotgun that fires 11 pellets in the shape of a star, with one pellet in the middle and two on each outer line of the star shape."},
    {"Prowler Burst PDW", "arccw_apex_prowler", "models/weapons/w_apex_prowler.mdl", "The Prowler Burst PDW, Prowler SMG, or Prowler, is a sub machine gun that fires in a 5-round burst. "},
    {"R-301 Carbine", "arccw_apex_r301", "models/weapons/w_apex_r301.mdl", "The R-301 Carbine, or R-301, is an assault rifle that can be switched between fully-automatic and semi-automatic fire modes. "},
    {"R-99 SMG", "arccw_apex_r99", "models/weapons/w_apex_prowler.mdl", "The R-99 SMG, or R-99, is a rapid-fire automatic SMG."},
    {"Sentinel SR", "arccw_apex_sentinel", "models/weapons/w_apex_sentinel.mdl", "The Sentinel is a Bolt-action sniper rifle."},
    {"Triple Take", "arccw_apex_tripletake", "models/weapons/w_apex_tripletake.mdl", "The Triple Take is a triple-barreled semi-automatic marksman rifle that fires 3 projectiles, one in the middle and two to the sides, consuming 3 ammo each shot."},
    {"VK-47 Flatline", "arccw_apex_flatline", "models/weapons/w_apex_flatline.mdl", "The VK-47 Flatline, or Flatline, is an assault rifle that can be switched between fully-automatic and semi-automatic fire modes."},
}

rtdm.config.loadout.side_weapons = {
    {"P2020", "arccw_apex_p2020", "models/weapons/w_apex_p2020.mdl", "Semi-auto pistol."},
    {"Re-45", "arccw_apex_re45", "models/weapons/w_apex_re45.mdl", "The RE-45 Auto, or RE-45, is a fully-automatic pistol "},
    {"Wingman", "arccw_apex_wingman", "models/weapons/w_apex_wingman.mdl", "The Wingman is a High-powered revolver. "},
    {"Mozambique Shotgun", "arccw_apex_mozambique", "models/weapons/w_apex_mozambique.mdl", "The Mozambique Shotgun, or Mozambique, is a fully-automatic triple-barreled shotgun pistol that shoots three pellets in the shape of a triangle. "},
}

rtdm.config.loadout.extra_weapons = {
    {"Arc Star", "arccw_apex_nade_arcstar", "models/weapons/w_apex_nade_arcstar.mdl", "Sticks, then explodes after a short delay. Causes damage and blurred vision. "},
    {"Frag Grenade", "arccw_apex_nade_frag", "models/weapons/w_apex_nade_frag.mdl", "Explosive ordnance. Throw to start fuse."},
    {"Thermite Grenade", "arccw_apex_nade_thermite", "models/weapons/w_apex_nade_thermite.mdl", "Creates a horizontal wall of flames horizontal, perpendicular to the direction it was thrown from."},
}

------------------
-- SERVER STUFF --
------------------
--[[ [ArcCW] Arctic's Customizable Weapons (Base Only) ]]
--[[ Neco Arc playermodel/ragdoll ]]
--[[ nyn ]]
--[[ Third Person Flashlight: Improved ]]
--[[ [ArcCW] Apex Legends SWEPs ]]
rtdm.config.workshop = {'2131057232', '2784840100', '2468310008', '925309004', '2813902415',}
