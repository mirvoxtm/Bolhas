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
    print(sprites.bubble)

    -- Inicializando as variáveis de mundo
    world = setupWorld()

    -- Inicializando as variáveis de plataformas, perigo e transportes e bolhas
    platforms.setupPlatforms(world)
    platforms.setupTransports(world)

    -- Inicializando as variáveis de jogador
    player = player.load(world)

    -- Timer
    bolhaTimer = {cooldown = 8, current = 0}

    fade = false
   
    -- Carregando Diálogos
    dialogLoad()
    dialogos = loadDialogues()

    canvas = love.graphics.newCanvas(1080, 720)

    -- Inicializando as variáveis de mapa
    loadMap(player.getLevel())
end

-- Função de atualização do Jogo a cada frame
function love.update(dt)

    if player.getBubbleState() then
        bubble.animation:update(dt)
    end

    -- Chamando playerUpdate de player.lua
    player.update(dt, world, level, dialogos)
    dialogUpdate()

    -- Chamando update de mapa e mundo do windfield
    gameMap:update(dt)
    world:update(dt)

    if player.getBubbleState() then 
        if love.timer.getTime() - bolhaTimer.current >= bolhaTimer.cooldown then
            player.setBubbleState(false)
            
            bx, by = platforms.getBubblePosition()

            print("Bolha estourada")
            platforms.destroyBubble()
        end
    end

    -- Atualizando a câmera para a posição do jogador
    if player.getLevel() < 3 then
        camera:lookAt(135, 135)
    else
        px, py = player.getCurrentPosition()
        camera:lookAt(px, py)
    end

end

-- Função de desenho do Jogo a cada frame
function love.draw()

    if fade == false then
        for i = 0, 200, 1 do
            love.graphics.setColor(0, 0, 0, 0.1)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            love.graphics.present()
            love.timer.sleep(0.001)
        end
    
        fade = true
        love.graphics.setColor(1, 1, 1, 1)
    end

    camera.smoother = camera.smooth.linear(100)
    love.graphics.draw(sprites.background, 0, 0)

    camera:attach()

        if player.getLevel() == 0 then
            camera:zoomTo(3)
        end

        if player.getLevel() == 2 then
            camera:zoomTo(3)
        end
      

        if gameMap.layers["BG"] then
            gameMap:drawLayer(gameMap.layers["BG"])
        end

        gameMap:drawLayer(gameMap.layers["Platforms"])
        player.draw()

        if player.getBubbleState() then
            bx, by = platforms.getBubblePosition()
            bubble.animation:draw(sprites.bubble, bubble:getX() - 8, bubble:getY() - 8, nil, 1, 1)
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
    fade = false

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

    if key == 'down' and player.isMovable() then
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
    end

    player.dialog(key, world, dialogos)

    if key == 'z' and player.getBubbleState() == false then
        bolhaTimer.current = love.timer.getTime(bolhaTimer)

        love.audio.newSource("src/sfx/bubble.mp3", "static"):play()
        player.setBubbleState(true)
        px, py = player.getCurrentPosition()
        
        bubble = platforms.spawnBubble(world, px + 10, py - 6, 10, 10, 'Bubble')

        bubble.animation = animations.bubbleIdle
        bubble.animation:gotoFrame(1)

    end
end
