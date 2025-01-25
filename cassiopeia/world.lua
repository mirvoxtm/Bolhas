local wf = require 'libs/windfield'

local function setupWorld()
    local world = wf.newWorld(0, 500, false)

    world:addCollisionClass('Platform')
    world:addCollisionClass('Non-collide')
    world:addCollisionClass('Transport')
    world:addCollisionClass('Back')
    world:addCollisionClass('Dialog')
    world:addCollisionClass('Player', {ignores={'Non-collide', 'Transport', 'Back', 'Dialog'}})
    world:addCollisionClass('Danger')

    return world
end

function returnGameMap()
    return gameMap
end

return setupWorld