local player = require 'player'
local loadAnimations = require 'animation'
local setupWorld = require 'world'
local platforms = require 'platforms'
local transports = require 'platforms'

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

    -- Inicializando as variáveis de plataformas, perigo e transportes
    platforms.setupPlatforms(world)
    platforms.setupTransports(world)

    -- Inicializando as variáveis de jogador
    player = player.load(world)

    level = 1
    -- Inicializando as variáveis de mapa
    loadMap(level)
end

-- Função de atualização do Jogo a cada frame
function love.update(dt)

    -- Chamando playerUpdate de player.lua
    player.update(dt, world, level)

    -- Chamando update de mapa e mundo do windfield
    gameMap:update(dt)
    world:update(dt)

    -- Atualizando a câmera para a posição do jogador
    px, py = player.getCurrentPosition()
    camera:lookAt(px, py)

end

-- Função de desenho do Jogo a cada frame
function love.draw()
    camera.smoother = camera.smooth.linear(100)
    love.graphics.draw(sprites.background, 0, 0)
    camera:attach()
        player.draw()
        gameMap:drawLayer(gameMap.layers["Platforms"])

        if love.keyboard.isDown('c') then
            gameMap:drawLayer(gameMap.layers["Transport"])
            world:draw()
        end
    camera:detach()
end

-- Função de pulo do jogador.
function love.keypressed(key)
    player.jump(key, world)
end

-- Função de carregamento de mapa.
function loadMap()
    changeBackground(player.getLevel())

    platforms.destroyPlatforms()
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

    if gameMap.layers["Back"] then
        for i, obj in pairs(gameMap.layers["Back"].objects) do
            transports.spawnTransport(world, obj.x, obj.y, obj.width, obj.height, 'Back')
        end
    end
end