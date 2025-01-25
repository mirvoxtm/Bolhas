local player = {
    speed = 100,
    direction = 1,
    body = nil,
    animation = nil,
    inTransportZone = false,
    inReturnZone = false,
    level = 1
}

function player.load(world)
    player.body = world:newRectangleCollider(100, 150, 10, 20, {collision_class = 'Player'})
    player.body:setType('dynamic')
    player.body:setFixedRotation(true)
    player.animation = animations.idle
    return player
end

function player.update(dt, world, level)
    if player.body then
        local px, py = player.body:getPosition()

        if love.keyboard.isDown('left') then
            player.animation = animations.runLeft
            player.direction = -1
            player.body:setX(px - player.speed * dt)

        elseif love.keyboard.isDown('right') then
            player.animation = animations.runRight
            player.direction = 1
            player.body:setX(px + player.speed * dt)

        else
            player.animation = animations.idle
        end

        if player.body:enter('Danger') then
            player.body:destroy()
        end

        if player.body:enter('Transport') then
            print("Entered transport zone")
            player.inTransportZone = true
        end

        if player.body:exit('Transport') then
            print("Exited transport zone")
            player.inTransportZone = false
        end

        if player.body:enter('Back') then
            print("Entered transport zone")
            player.inReturnZone = true
        end

        if player.body:exit('Back') then
            print("Exited transport zone")
            player.inReturnZone = false
        end

        if player.inTransportZone and love.keyboard.isDown('down') then
            print("Triggering level transition")
            loadMap(incrementLevel())
        end

        if player.inReturnZone and love.keyboard.isDown('down') then
            print("Triggering level transition")
            loadMap(decrementLevel())
        end
        
    end

    player.animation:update(dt)
end

function player.draw()
    if player.body then
        local px, py = player.body:getPosition()
        player.animation:draw(sprites.player, px - 7, py - 21, nil, 1, 1)    
    end
end

function player.getPosition()
    if player.body then
        return player.body:getPosition()
    end
end

function player.getDirection()
    if player.body then
        return player.direction
    end
end

function player.jump(key, world)
    if player.body and key == 'up' then
        local colliders = world:queryRectangleArea(
            player.body:getX() - 5, 
            player.body:getY() + 10, 
            10, 
            5, 
            {'Platform'}
        )
        if #colliders > 0 then
            player.body:applyLinearImpulse(0, -50)
        end
    end
end

function player.getCurrentPosition()
    return player.getPosition()
end

function player.setPosition(x, y)
    if player.body then
        player.body:setPosition(x, y)
    end
end

function player.getLevel()
    return player.level
end

function incrementLevel()
    player.level = player.level + 1
    print("Level incremented to " .. player.level)
end

function decrementLevel()
    player.level = player.level - 1
    print("Level decremented to " .. player.level)
end

return player