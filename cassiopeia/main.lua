local player = require 'player'
local loadAnimations = require 'animation'
local setupWorld = require 'world'
local platforms = require 'platforms'
local transports = require 'platforms'
local dialogues = require 'speechbubble'
local dialogos = require 'dialogos'

-- Função de carregamento do Jogo
function love.load()
    -- Settando o título e o tamanho da janela
    love.window.setTitle('Cassiopeia')
    love.window.setMode(1080, 720, {resizable=false})

    -- Importando as bibliotecas
    sti = require 'libs/sti/sti'
    cameraFile = require 'libs/hump/camera'

    -- Inicializando as variáveis de câmera
    camera = cameraFile()
    camera:zoom(3)

    -- Inicializando as variáveis de sprites e animações
    sprites, animations = loadAnimations()

    -- Inicializando as variáveis de mundo
    world = setupWorld()

    -- Inicializando as variáveis de plataformas, perigo e transportes e bolhas
    platforms.setupPlatforms(world)
    platforms.setupTransports(world)

    -- Inicializando as variáveis de jogador
    player = player.load(world)

    -- Timer
    bolhaTimer = {cooldown = 8, current = 0}
   
    -- Carregando Diálogos
    dialogLoad()
    dialogos = loadDialogues()

    -- Inicializando as variáveis de mapa
    loadMap(player.getLevel())
end

-- Função de atualização do Jogo a cada frame
function love.update(dt)

    -- Chamando playerUpdate de player.lua
    player.update(dt, world, level, dialogos)
    dialogUpdate()

    if player.getBubbleState() then 
        if love.timer.getTime() - bolhaTimer.current > bolhaTimer.cooldown then
            bolhaTimer.current = love.timer.getTime(bolhaTimer)
            player.setBubbleState(false)
            
            bx, by = platforms.getBubblePosition()
            bubble.animation = animations.bubblePop
            bubble.animation:draw(sprites.bubble, bx - 8, by - 8, nil, 1, 1)    

            print("Bolha estourada")
            platforms.destroyBubble()
        end
    end

    if player.body:enter('Bubble') then

        if player.getBubbleState() and love.timer.getTime() - bolhaTimer.current > bolhaTimer.cooldown then
            bolhaTimer.current = love.timer.getTime(bolhaTimer)
            player.setBubbleState(false)

            bubble.animation = animations.bubblePop
            bubble.animation:draw(sprites.bubble, bx - 8, by - 8, nil, 1, 1)    

            print("Bolha estourada")
            platforms.destroyBubble()
        end
    end

    if player.getBubbleState() then
        px, py = player.getCurrentPosition()
        if player.getBubbleState() then
            bx, by = platforms.getBubblePosition()
        else
            bx, by = 0, 0
        end
    end

    -- Chamando update de mapa e mundo do windfield
    gameMap:update(dt)
    world:update(dt)

    -- Atualizando a câmera para a posição do jogador
    if player.getLevel() < 2 then
        camera:lookAt(135, 135)
    else
        px, py = player.getCurrentPosition()
        camera:lookAt(px, py)
    end

end

-- Função de desenho do Jogo a cada frame
function love.draw()
    camera.smoother = camera.smooth.linear(100)
    love.graphics.draw(sprites.background, 0, 0)

    camera:attach()

        if player.getLevel() < 2 then
            camera:zoomTo(3)
        end

        gameMap:drawLayer(gameMap.layers["Platforms"])
        player.draw()

        if player.getBubbleState() then
            bx, by = platforms.getBubblePosition()
            bubble.animation:draw(sprites.bubble, bx - 8, by - 8, nil, 1, 1)    
        end

        if gameMap.layers["Foreground"] then
            gameMap:drawLayer(gameMap.layers["Foreground"])
        end

        if love.keyboard.isDown('c') then
            gameMap:drawLayer(gameMap.layers["Transport"])
            world:draw()
        end
    camera:detach()

    dialogDraw()
end

-- Função de carregamento de mapa.
function loadMap()
    -- Altera o Background com base no nivel que o jogador está.
    changeBackgroundAndSong(player.getLevel())

    player.inReturnZone = false
    player.inTransportZone = false

    -- Destrói as plataformas, perigos e transportes do mapa anterior.
    platforms.destroyDialogs()
    platforms.destroyTransports()
    platforms.destroyPlatforms()
    
    if player.getBubbleState() then
        platforms.destroyBubble()
        player.setBubbleState(false)
    end

    gameMap = sti('src/maps/level' .. player.getLevel() .. '.lua')

    -- Carregando o jogador na posição inicial do mapa definido no Tiled.
    for i, obj in pairs(gameMap.layers["Start"].objects) do
        player.setPosition(obj.x, obj.y)
    end

    -- Carregando as plataformas, perigos e transportes do mapa definido no Tiled.
    for i, obj in pairs(gameMap.layers["Collision"].objects) do
        platforms.spawnCollisions(world, obj.x, obj.y, obj.width, obj.height)
    end

    for i, obj in pairs(gameMap.layers["Transport"].objects) do
        transports.spawnTransport(world, obj.x, obj.y, obj.width, obj.height, 'Transport')
    end

    if gameMap.layers["Dialog"] then
        for i, obj in pairs(gameMap.layers["Dialog"].objects) do
            transports.spawnDialog(world, obj.x, obj.y, obj.width, obj.height, 'Dialog')
        end
    end

    if gameMap.layers["Back"] then
        for i, obj in pairs(gameMap.layers["Back"].objects) do
            transports.spawnTransport(world, obj.x, obj.y, obj.width, obj.height, 'Back')
        end
    end

    bubble = nil
end

function love.keypressed(key)
    if key == 'up' then
        love.audio.newSource("src/sfx/jump.mp3", "static"):play()
    end

    if key == 'down' then
        if player.getReturnZone() then
            print("Triggering level transition")
            decrementLevel()
            loadMap()
        end

        if player.getTransportZone() then
            print("Triggering level transition")
            incrementLevel()
            loadMap()
        end

        player.dialog(key, world, dialogos)
    end

    if key == 'z' and player.getBubbleState() == false then
        love.audio.newSource("src/sfx/bubble.mp3", "static"):play()
        player.setBubbleState(true)
        px, py = player.getCurrentPosition()
        
        bubble = platforms.spawnBubble(world, px + 10, py - 6, 10, 10, 'Bubble')

        bubble.animation = animations.bubbleIdle
    
    end
end
