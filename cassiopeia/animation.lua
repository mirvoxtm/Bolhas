local anim8 = require 'libs/anim8/anim8'
love.graphics.setDefaultFilter('nearest', 'nearest')

local function loadAnimations()
    local sprites = {}
    sprites.player = love.graphics.newImage('src/img/cruz/cruz_spritesheet.png')

    local grid = anim8.newGrid(16, 32, sprites.player:getWidth(), sprites.player:getHeight())

    local animations = {}
    animations.idle = anim8.newAnimation(grid('1-8', 1), 0.15)
    animations.runRight = anim8.newAnimation(grid('1-6', 2), 0.1)
    animations.runLeft = anim8.newAnimation(grid('1-6', 3), 0.1)

    return sprites, animations
end

return loadAnimations