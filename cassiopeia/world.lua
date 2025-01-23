local wf = require 'libs/windfield'

local function setupWorld()
    local world = wf.newWorld(0, 560, false)

    world:addCollisionClass('Platform')
    world:addCollisionClass('Non-collide')
    world:addCollisionClass('Player', {ignores={'Non-collide'}})
    world:addCollisionClass('Danger')

    return world
end

return setupWorld