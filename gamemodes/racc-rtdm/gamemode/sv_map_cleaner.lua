function rtdm_cleanup_cleaner()

    for k, v in pairs( ents.FindByClass( "prop_*" ) ) do
        local obj = v:GetPhysicsObject()
        obj:EnableMotion(false)
    end

    for k, v in pairs( ents.FindByClass( "weapon_*" ) ) do
        if table.HasValue(player.GetAll(), v:GetOwner()) then
            return
        else
            SafeRemoveEntity( v )
        end
    end

    for k, v in pairs( ents.FindByClass( "item_*" ) ) do
        if table.HasValue(player.GetAll(), v:GetOwner()) then
            return
        else
            SafeRemoveEntity( v )
        end
    end

    for k, v in pairs( ents.FindByClass( "func_breakable" ) ) do
        SafeRemoveEntity( v )
    end
    
    for k, v in pairs(	ents.FindByClass( "func_lookdoor" ) ) do
        SafeRemoveEntity( v )
    end
    
    for k, v in pairs(	ents.FindByClass( "func_rotating" ) ) do
        SafeRemoveEntity( v )
    end
    
end

hook.Add( "PostCleanupMap", "rtdm_cleanup_cleaner", rtdm_cleanup_cleaner)
rtdm_cleanup_cleaner()