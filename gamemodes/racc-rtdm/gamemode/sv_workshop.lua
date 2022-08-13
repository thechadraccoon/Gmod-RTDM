include("config.lua")

for i, v in next, rtdm.config.workshop do
    resource.AddWorkshop(v)
end
