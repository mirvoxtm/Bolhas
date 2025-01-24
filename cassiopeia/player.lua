function playerLoad(world)
    player = world:newRectangleCollider(100, 150, 10, 20, {collision_class = 'Player'})
    player:setType('dynamic')
    player:setFixedRotation(true)
    player.speed = 100
    player.direction = 1
    player.animation = animations.idle
end

function playerUpdate(dt)
    if player.body then
        local px, py = player:getPosition()

        if love.keyboard.isDown('left') then
            player.animation = animations.runLeft
            player.direction = -1
            player.setX(player, px - player.speed * dt)

        elseif love.keyboard.isDown('right') then
            player.animation = animations.runRight
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
        player.animation:draw(sprites.player, px - 7, py - 21, nil, 1, 1)    
    end
end

function getPlayerPosition()
    if player.body then
        return player:getPosition()
    end
end

function getPlayerDirection()
    if player.body then
        return player.direction
    end
end

function playerJump(key, world)
    if player.body then
        if key == 'up' then
            local colliders = world:queryRectangleArea(player:getX() - 5, player:getY() + 10, 10, 5, {'Platform'})
            if #colliders > 0 then
                player:applyLinearImpulse(0, -50)
            end
        end
    end
end