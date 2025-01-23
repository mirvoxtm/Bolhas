local anim8 = require 'libs/anim8/anim8'

local function loadAnimations()
    local sprites = {}
    sprites.player = love.graphics.newImage('src/cruz/running.png')

    local grid = anim8.newGrid(48, 96, sprites.player:getWidth(), sprites.player:getHeight())

    local animations = {}
    animations.idle = anim8.newAnimation(grid('1-1', 1), 0.1)
    animations.run = anim8.newAnimation(grid('1-5', 1), 0.1)

    return sprites, animations
end

return loadAnimations