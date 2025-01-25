local player = {
    speed = 100,
    direction = 1,
    body = nil,
    animation = nil,
    inTransportZone = false,
    inReturnZone = false,
    inDialogTile = false,
    canMove = true,
    bubbleActive = false,
    level = 0
}

-- Função de carregamento do jogador. Cria um retângulo de colisão com as dimensões passadas.
-- Define o tipo do corpo como dinâmico e fixa a rotação. Retorna o jogador.

function player.load(world)
    player.body = world:newRectangleCollider(100, 150, 10, 20, {collision_class = 'Player'})
    player.body:setType('dynamic')
    player.body:setFixedRotation(true)
    player.animation = animations.idle
    return player
end

-- Função de atualização do jogador.


function player.update(dt, world, level)

    -- Se o jogador tiver um corpo, ele pode se mover.
    if player.body then
        -- Pega a posição do jogador.
        local px, py = player.body:getPosition()

        if player.canMove then
            if love.keyboard.isDown('up') then
                player.jump('up', world)
            end

            -- Se o jogador pressionar a tecla de movimento para a esquerda, ele se move para a esquerda.
            if love.keyboard.isDown('left') and player.canMove then
                player.animation = animations.runLeft
                player.direction = -1
                player.body:setX(px - player.speed * dt)

            -- Se o jogador pressionar a tecla de movimento para a direita, ele se move para a direita.
            elseif love.keyboard.isDown('right') and player.canMove then
                player.animation = animations.runRight
                player.direction = 1
                player.body:setX(px + player.speed * dt)
            else
                player.animation = animations.idle
        end

        -- Se o jogador não pressionar nenhuma tecla de movimento, ele fica parado.
        else
            player.animation = animations.idle
        end

        -- Se o jogador entrar em um objeto de perigo, ele é destruído.
        if player.body:enter('Danger') then
            player.body:destroy()
        end

        -- Se o jogador entrar em um objeto de transporte, ele é transportado para outro mapa.
        if player.body:enter('Transport') then
            print("Entered transport zone")
            player.inTransportZone = true
        end

        -- Se o jogador sair de um objeto de transporte, inTransportZone é falso.
        if player.body:exit('Transport') then
            print("Exited transport zone")
            player.inTransportZone = false
        end

        -- Outro objeto de transporte, este usado para retornar ao mapa anterior.
        if player.body:enter('Back') then
            print("Entered transport zone")
            player.inReturnZone = true
        end

        if player.body:exit('Back') then
            print("Exited transport zone")
            player.inReturnZone = false
        end

        -- Se o jogador entrar em um objeto de diálogo, inDialogTile é verdadeiro.
        if player.body:enter('Dialog') then
            print("Entered dialog zone")
            player.inDialogTile = true
        end

        -- Se o jogador sair de um objeto de diálogo, inDialogTile é falso.
        if player.body:exit('Dialog') then
            print("Exited dialog zone")
            player.inDialogTile = false
        end


        -- Se o jogador pressionar a tecla de movimento para baixo, ele pode interagir com o objeto.
        -- Aqui, essa função irá transportar o jogador para outro mapa (um acima) do atual.
        if player.inTransportZone and love.keyboard.isDown('down') then
            print("Triggering level transition")
            loadMap(incrementLevel())
        end

        -- Se o jogador estiver em uma zona de retorno e pressionar a tecla de movimento para baixo, ele pode retornar ao mapa anterior.

        if player.inReturnZone and love.keyboard.isDown('down') then
            print("Triggering level transition")
            loadMap(decrementLevel())
        end

        -- Se o jogador estiver em uma zona de diálogo e pressionar a tecla de movimento para baixo, ele pode interagir com o objeto.
        -- Aqui, essa função irá exibir um diálogo.
        
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
        player.animation:draw(sprites.player, px - 7, py - 21, nil, 1, 1)    
    end
end

-- Função de pegar a posição do jogador.
-- Usado na câmera para seguir o jogador em main.lua.
function player.getPosition()
    if player.body then
        return player.body:getPosition()
    end
end

-- Função de pegar a direção do jogador.
-- Usado para definir a direção da animação do jogador.
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

function player.dialog(key, world, dialogues)
    if player.body and key == 'down' and player.inDialogTile and not isDialogActive() then
        newDialog(dialogues[1])
    elseif player.body and key == 'down' then
        if not isLastLine() then
            nextLine()
        else
            
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

function player.makePlayerUnmovable()
    print("fez imovivel")
    player.canMove = false
end

function player.makePlayerMovable()
    player.canMove = true
end

function player.getBubbleState()
    return player.bubbleActive
end

function player.setBubbleState(state)
    player.bubbleActive = state
end

return player