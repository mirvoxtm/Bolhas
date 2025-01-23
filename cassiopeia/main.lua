require 'player'

function love.load()
    anim8 = require 'libs/anim8/anim8'
    sprites = {}
    sprites.player = love.graphics.newImage('src/cruz/running.png')

    local grid = anim8.newGrid(48, 96, sprites.player:getWidth(), sprites.player:getHeight())

    animations = {}
    animations.idle = anim8.newAnimation(grid('1-1', 1), 0.1)
    animations.run =  anim8.newAnimation(grid('1-5', 1), 0.1)

    wf = require 'libs/windfield'

    world = wf.newWorld(0, 560, false)

    world:addCollisionClass('Platform')
    world:addCollisionClass('Non-collide')
    world:addCollisionClass('Player', {ignores={'Non-collide'}})
    world:addCollisionClass('Danger')

    platform = world:newRectangleCollider(0,500,3000,1200, {collision_class = 'Platform'})
    platform:setType('static')

    danger = world:newRectangleCollider(500, 500, 100, 30, {collision_class = 'Danger'})
    danger:setType('dynamic')

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