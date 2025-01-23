local player = require 'player'
local loadAnimations = require 'animation'
local setupWorld = require 'world'
local platforms = require 'platforms'

function love.load()
    love.window.setTitle('Cassiopeia')
    love.window.setMode(1200, 900, {resizable=false})
    sti = require 'libs/sti/sti'

    sprites, animations = loadAnimations()
    world = setupWorld()
    platforms.setupPlatforms(world)
    playerLoad(world)

    loadMap()
end

function love.update(dt)
    playerUpdate(dt)
    gameMap:update(dt)
    world:update(dt)
end

function love.draw()
    drawPlayer()
    gameMap:drawLayer(gameMap.layers["Foreground"])

    if love.keyboard.isDown('c') then
       world:draw()
    end
end

function love.keypressed(key)
    playerJump(key, world)
end

function loadMap()
    gameMap = sti('src/maps/level1.lua')
    for i, obj in pairs(gameMap.layers["Collision"].objects) do
        platforms.spawnCollisions(world, obj.x, obj.y, obj.width, obj.height)
    end
end