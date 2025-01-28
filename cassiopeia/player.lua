local player = {
    speed = 80,
    maxSpeed = 80,
    acceleration = 200,
    deceleration = 180,
    direction = 1,
    body = nil,
    animation = nil,
    inTransportZone = false,
    inReturnZone = false,
    inDialogTile = false,
    canMove = true,
    bubbleActive = false,
    isInCg = false,
    inBubble = false,
    level = 0,
    isJumping = false,
    doubleJump = true,
    jumpCooldown = 0.4,
    bubbleCooldown = 0.5,
    jumpTimer = 0
}

function player.getBubbleCooldown()
    return player.bubbleCooldown
end

function player.setBubbleCooldown(x)
    player.bubbleCooldown = x
end

-- Função de carregamento do jogador. Cria um retângulo de colisão com as dimensões passadas.
-- Define o tipo do corpo como dinâmico e fixa a rotação. Retorna o jogador.

function player.load(world)
    player.body = world:newRectangleCollider(100, 155, 10, 15, {collision_class = 'Player'})
    player.body:setType('dynamic')
    player.body:setFixedRotation(true)
    player.animation = animations.idle
    return player
end

-- Função de atualização do jogador.


function player.update(dt, world, level, dialogues)
    
    if player.jumpTimer > 0 then
        player.jumpTimer = player.jumpTimer - dt
    end

    -- Função de tocar a CG
    if player.getLevel() == 1 and player.isInCg == false then
        player.isInCg = true
        newDialog(dialogues[1])
        player.makePlayerMovable()
    end

    if player.getLevel() == 8 and player.isInCg == false then
        player.isInCg = true
        player.makePlayerUnmovable()
    end

    if player.body then
        -- Pega a posição do jogador.
        local px, py = player.body:getPosition()
        local vx, vy = player.body:getLinearVelocity()

        if player.canMove then
            if love.keyboard.isDown('up') then
                if player.isMovable() then
                    player.jump(world)
                end
            end

            if love.keyboard.isDown('left') then
                player.direction = -1
                player.setX(player, px - player.speed * dt)
                player.animation = animations.runLeft

            elseif love.keyboard.isDown('right') then
                player.direction = 1
                player.setX(player, px + player.speed * dt)
                player.animation = animations.runRight

            else

                if player.direction == 1 then
                    player.animation = animations.idle
                else
                    player.animation = animations.idleLeft
                end
            end
        end

        -- Se o jogador entrar em um objeto de perigo, ele é destruído.
        if player.body:enter('Danger') then
            for i, obj in pairs(gameMap.layers["Start"].objects) do
                player.setPosition(obj.x, obj.y)
            end
        end

        -- Se o jogador entrar em um objeto de transporte, ele é transportado para outro mapa.
        if player.body:enter('Transport') then
            player.inTransportZone = true
        end

        -- Se o jogador sair de um objeto de transporte, inTransportZone é falso.
        if player.body:exit('Transport') then
            player.inTransportZone = false
        end

        -- Outro objeto de transporte, este usado para retornar ao mapa anterior.
        if player.body:enter('Back') then
            player.inReturnZone = true
        end

        if player.body:exit('Back') then
            player.inReturnZone = false
        end

        -- Se o jogador entrar em um objeto de diálogo, inDialogTile é verdadeiro.
        if player.body:enter('Dialog') then
            player.inDialogTile = true
        end

        -- Se o jogador sair de um objeto de diálogo, inDialogTile é falso.
        if player.body:exit('Dialog') then
            player.inDialogTile = false
        end
    end

    -- Atualiza a animação do jogador a cada frame.
    player.animation:update(dt)
end


-- Função de desenho do jogador.
function player.draw()

    -- Se o jogador tiver um corpo, desenha o jogador na tela.
    if player.body then

        -- Pega a posição do jogador.
        local px, py = player.body:getPosition()

        -- Desenha o jogador na tela.
        player.animation:draw(sprites.player, px - 7, py - 24, nil, 1, 1) 

        --love.graphics.setColor(1, 0, 0, 0.5)  -- Set color to red with 50% transparency
        --love.graphics.rectangle("line", px - 4, py + 7, 8, 2)
        --love.graphics.setColor(1, 1, 1, 1) 
 -- Res
    end
end

-- Função de pegar a posição do jogador.
-- Usado na câmera para seguir o jogador em main.lua.
function player.getPosition()
    if player.body then
        return player.body:getPosition()
    end
end

function player.setX(player, x)
    if player.body then
        player.body:setX(x)
    end
end

-- Função de pegar a direção do jogador.
-- Usado para definir a direção da animação do jogador.
function player.getDirection()
    if player.body then
        return player.direction
    end
end

function player.jump(world)
    if player.body and player.jumpTimer <= 0 then
        local px, py = player.body:getPosition()
        local colliders = world:queryRectangleArea(px - 4, py + 7, 8, 2, {'Platform', 'Bubble'})

        if #colliders > 0 then
            player.body:applyLinearImpulse(0, -48)
            player.isJumping = true
            player.jumpTimer = player.jumpCooldown  -- Reset jump timer
        end
    end
end

function player.dialog(key, world, dialogues)
    if player.body and key == 'down' and player.inDialogTile and not isDialogActive() then

        if player.getLevel() == 2 then
            newDialog(dialogues[2])
            dialogues[2] = dialogues[3]

        elseif player.getLevel() == 7 then
            newDialog(dialogues[12])
        end

    elseif player.body and key == 'down' then
        if not isLastLine() then
            nextLine()
        else
            if player.getLevel() == 7 then
                loadMap(8)
            end
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
end

function decrementLevel()
    player.level = player.level - 1
end

function player.makePlayerUnmovable()
    player.canMove = false
end

function player.makePlayerMovable()
    player.canMove = true
end

function player.isInBubble()
    return player.inBubble
end

function player.setInBubble(state)
    player.inBubble = state
end

function player.isMovable()
    return player.canMove
end

function player.getBubbleState()
    return player.bubbleActive
end

function player.setBubbleState(state)
    player.bubbleActive = state
end

function player.getReturnZone()
    return player.inReturnZone
end

function player.isJumping()
    return player.isJumping
end

function player.getTransportZone()
    return player.inTransportZone
end

return player