local anim8 = require 'libs/anim8/anim8'

love.graphics.setDefaultFilter('nearest', 'nearest')

local function loadAnimations()
    local sprites = {}
    sprites.player = love.graphics.newImage('src/img/cruz/cruz_spritesheet.png')
    sprites.bubble = love.graphics.newImage('src/img/bubble/bubbles.png')

    local grid = anim8.newGrid(16, 32, sprites.player:getWidth(), sprites.player:getHeight())
    local bubbleGrid = anim8.newGrid(16, 16, 512, 16)

    local animations = {}
    animations.idle = anim8.newAnimation(grid('1-8', 1), 0.15)
    animations.idleLeft = anim8.newAnimation(grid('1-8', 1), 0.15):flipH()
    animations.runRight = anim8.newAnimation(grid('1-6', 2), 0.1)
    animations.runLeft = anim8.newAnimation(grid('1-6', 3), 0.1)

    animations.bubbleIdle = anim8.newAnimation(bubbleGrid('1-32', 1), 0.15726)

    return sprites, animations
end

function changeBackgroundAndSong(level)
    if level == 0 then
        love.audio.stop()
        sprites.background = love.graphics.newImage('src/img/bg/black.png')
    end

    if level == 1 then
        love.audio.stop()

        local music = love.audio.newSource('src/aud/vento.mp3', 'stream')
        music:setLooping(true)
        love.audio.play(music)
        
        sprites.background = love.graphics.newImage('src/img/bg/cgi.png')
    end

    if level == 2 then
        love.audio.stop()
        
        local music = love.audio.newSource('src/aud/cidade.mp3', 'stream')
        music:setLooping(true)
        love.audio.play(music)
        
        sprites.background = love.graphics.newImage('src/img/bg/parallax.png')
    end
    
    if level == 3 then
        love.audio.stop()
        
        local music = love.audio.newSource('src/aud/quadrado.mp3', 'stream')
        music:setLooping(true)
        love.audio.play(music)
        
        sprites.background = love.graphics.newImage('src/img/bg/cidade.png')
    end

    if level == 4 then
        love.audio.stop()
        
        local music = love.audio.newSource('src/aud/metro.mp3', 'stream')
        music:setLooping(true)
        love.audio.play(music)
        
        sprites.background = love.graphics.newImage('src/img/bg/tuneis.png')
    end

    if level == 5 then
        love.audio.stop()
        
        local music = love.audio.newSource('src/aud/agua.mp3', 'stream')
        music:setLooping(true)
        love.audio.play(music)
        
        sprites.background = love.graphics.newImage('src/img/bg/esgoto.png')
    end

    if level == 6 then
        love.audio.stop()
        
        local music = love.audio.newSource('src/aud/minas.mp3', 'stream')
        music:setLooping(true)
        love.audio.play(music)
        
        sprites.background = love.graphics.newImage('src/img/bg/minas.png')
    end

    if level == 7 then
        love.audio.stop()

        local music = love.audio.newSource('src/aud/fim.mp3', 'stream')
        music:setLooping(true)
        love.audio.play(music)
        
        sprites.background = love.graphics.newImage('src/img/bg/cidade.png')
    end

    if level == 8 then
        love.audio.stop()

        local music = love.audio.newSource('src/aud/vento.mp3', 'stream')
        music:setLooping(true)
        love.audio.play(music)
        
        sprites.background = love.graphics.newImage('src/img/bg/cge.png')
    end
end

function returnBackground()
    return sprites.background
end

function returnBubble()
    return sprites.bubble
end

return loadAnimations