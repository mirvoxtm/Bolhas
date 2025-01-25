local wf = require 'libs/windfield'

-- setupWorld() é uma função que inicializa o mundo de colisões do jogo.
-- Toda vez que tiver algo novo no Tiled, deve ter uma collision class que a identifique.
-- Essa aqui é a definição de nossas classes de colisão.

local function setupWorld()
    local world = wf.newWorld(0, 500, false)

    world:addCollisionClass('Platform')
    world:addCollisionClass('Non-collide')
    world:addCollisionClass('Transport')
    world:addCollisionClass('Back')
    world:addCollisionClass('Dialog')
    world:addCollisionClass('Bubble')
    world:addCollisionClass('Player', {ignores={'Non-collide', 'Transport', 'Back', 'Dialog'}})
    world:addCollisionClass('Danger')

    return world
end

function returnGameMap()
    return gameMap
end

return setupWorld