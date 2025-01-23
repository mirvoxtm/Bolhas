function playerLoad(world)
    player = world:newRectangleCollider(45, 76, 30, 50, {collision_class = 'Player'})
    player:setType('dynamic')
    player:setFixedRotation(true)
    player.speed = 300
    player.direction = 1
    player.animation = animations.idle
end

function playerUpdate(dt)
    if player.body then
        local px, py = player:getPosition()

        if love.keyboard.isDown('left') then
            player.animation = animations.run
            player.direction = -1
            player.setX(player, px - player.speed * dt)

        elseif love.keyboard.isDown('right') then
            player.animation = animations.run
            player.direction = 1
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

function drawPlayer()
    if player.body then
        local px, py = player:getPosition()
        local scaleX = 1 * player.direction
        local offsetX = player.direction == 1 and -25 or 25
        player.animation:draw(sprites.player, px + offsetX, py - 70, nil, scaleX, 1)    
    end
end

function playerJump(key, world)
    if player.body then
        if key == 'up' then
            local colliders = world:queryRectangleArea(player:getX() - 15, player:getY() + 25, 30, 5, {'Platform', 'Danger'})
            if #colliders > 0 then
                player:applyLinearImpulse(0, -800)
            end
        end
    end
end