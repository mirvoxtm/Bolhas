require 'player'
local loadAnimations = require 'animation'
local setupWorld = require 'world'
local setupPlatforms = require 'platforms'

function love.load()
    sprites, animations = loadAnimations()
    world = setupWorld()
    setupPlatforms(world)
    playerLoad(world)
end

function love.update(dt)
    playerUpdate(dt)
    world:update(dt)
end

function love.draw()
    drawPlayer()
    world:draw()
end

function love.keypressed(key)
    playerJump(key, world)
end