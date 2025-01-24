function playerLoad(world)
    player = world:newRectangleCollider(70, 76, 18, 30, {collision_class = 'Player'})
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
        player.animation:draw(sprites.player, px - 13, py - 40, nil, 1.7, 1.7)    
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
            local colliders = world:queryRectangleArea(player:getX() - 15, player:getY() + 25, 30, 5, {'Platform', 'Danger'})
            if #colliders > 0 then
                player:applyLinearImpulse(0, -300)
            end
        end
    end
end