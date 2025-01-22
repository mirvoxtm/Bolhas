function love.load()
    anim8 = require 'libs/anim8/anim8'
    sprites = {}
    sprites.player = love.graphics.newImage('src/cruz/running.png')

    local grid = anim8.newGrid(48, 96, sprites.player:getWidth(), sprites.player:getHeight())

    animations = {}
    animations.idle = anim8.newAnimation(grid('1-1', 1), 0.1)
    animations.run =  anim8.newAnimation(grid('1-5', 1), 0.1)

    wf = require 'libs/windfield'

    world = wf.newWorld(0, 900, false)

    world:addCollisionClass('Platform')
    world:addCollisionClass('Non-collide')
    world:addCollisionClass('Player', {ignores={'Non-collide'}})
    world:addCollisionClass('Danger')

    player = world:newRectangleCollider(45, 76, 30, 50, {collision_class = 'Player'})
    player:setType('dynamic')
    player:setFixedRotation(true)
    player.speed = 300
    player.animation = animations.idle

    platform = world:newRectangleCollider(0,500,3000,1200, {collision_class = 'Platform'})
    platform:setType('static')

    danger = world:newRectangleCollider(500, 400, 100, 100, {collision_class = 'Danger'})
    danger:setType('dynamic')

end

function love.update(dt)
    world:update(dt)

    if player.body then
        local px, py = player:getPosition()
        if love.keyboard.isDown('left') then
            player.animation = animations.run
            player.setX(player, px - player.speed * dt)
        elseif love.keyboard.isDown('right') then
            player.animation = animations.run
            player.setX(player, px + player.speed * dt)
        else
            player.animation = animations.idle
        end

        if player:enter('Danger') then
            player:destroy()
        end
    end

    player.animation:update(dt)
end

function love.draw()
    if player.body then
        local px, py = player:getPosition()
        player.animation:draw(sprites.player, px - 25, py - 70)
    end

    world:draw()
end

function love.keypressed(key)
    if player.body then
        if key == 'up' then
            local colliders = world:queryRectangleArea(player:getX() - 15, player:getY() + 25, 30, 5, {'Platform', 'Danger'})
            if #colliders > 0 then
                player:applyLinearImpulse(0, -800)
            end
        end
    end
end