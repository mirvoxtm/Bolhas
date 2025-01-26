local anim8 = require 'libs/anim8/anim8'

love.graphics.setDefaultFilter('nearest', 'nearest')

local function loadAnimations()
    local sprites = {}
    sprites.player = love.graphics.newImage('src/img/cruz/cruz_spritesheet.png')
    sprites.bubble = love.graphics.newImage('src/img/bubble/bubbles.png')

    local grid = anim8.newGrid(16, 32, sprites.player:getWidth(), sprites.player:getHeight())
    local bubbleGrid = anim8.newGrid(16, 16, sprites.bubble:getWidth(), sprites.bubble:getHeight())

    local animations = {}
    animations.idle = anim8.newAnimation(grid('1-8', 1), 0.15)
    animations.runRight = anim8.newAnimation(grid('1-6', 2), 0.1)
    animations.runLeft = anim8.newAnimation(grid('1-6', 3), 0.1)

    animations.bubbleIdle = anim8.newAnimation(bubbleGrid('1-2', 1), 0.1)
    animations.bubblePop = anim8.newAnimation(bubbleGrid('1-4', 2), 0.1)

    return sprites, animations
end

function changeBackgroundAndSong(level)
    print(level)
    if level == 0 then
        love.audio.stop()
        sprites.background = love.graphics.newImage('src/img/bg/black.png')
    end

    if level == 1 then
        love.audio.stop()
        love.audio.play(love.audio.newSource('src/aud/vento.mp3', 'stream'))
        sprites.background = love.graphics.newImage('src/img/bg/parallax.png')
    end

    if level == 2 then
        love.audio.stop()
        love.audio.play(love.audio.newSource('src/aud/cooler.mp3', 'stream'))
        sprites.background = love.graphics.newImage('src/img/bg/parallax.png')
    end
end

function returnBackground()
    return sprites.background
end

return loadAnimations