local platforms = {}
local transports = {}
local bubbles = {}
local dialogs = {}

-- Função de setup de plataformas. Inicializa a tabela de plataformas.
function platforms.setupPlatforms(world)
    platforms = {}
end

-- Função de setup de transportes. Inicializa a tabela de transportes.
function platforms.setupTransports(world)
    transports = {}
end

function platforms.setupDialog(world)
    dialogs = {}
end

function platforms.setupBubbles(world)
    bubbles = {}
end

-- Função de spawn de plataformas. Cria um retângulo de colisão com as dimensões passadas.
-- Para cada plataforma criada, adiciona na tabela de plataformas.

function platforms.spawnCollisions(world, x, y, width, height)
    if width > 0 and height > 0 then
        local platform = world:newRectangleCollider(x, y, width, height, {collision_class = 'Platform'})
        platform:setType('static')
        table.insert(platforms, platform)
    end
end

-- Função de spawn de transportes. Cria um retângulo de colisão com as dimensões passadas.
-- Para cada transporte criado, adiciona na tabela de transportes. Usado na transição de mapas.

function platforms.spawnTransport(world, x, y, width, height, class)
    if width > 0 and height > 0 then
        local transport = world:newRectangleCollider(x, y, width, height, {collision_class = class})
        transport:setType('static')
        table.insert(transports, transport)
    end
end

function platforms.spawnDialog(world, x, y, width, height, class)
    if width > 0 and height > 0 then
        local dialog = world:newRectangleCollider(x, y, width, height, {collision_class = class})
        dialog:setType('static')
        table.insert(dialogs, dialog)
    end
end

-- Função de destruição de plataformas. Remove todas as plataformas da tabela de plataformas atual.
-- Ou seja, remove a colisão e plataforma do mapa que acaba de ser descarregado.
function platforms.destroyPlatforms()
    local i = #platforms
    while i > 0 do
        if platforms[i] ~= nil then
            platforms[i]:destroy()
        end
        table.remove(platforms, i)
        i = i - 1
    end
end

function platforms.spawnBubble(world, x, y, width, height, class)
    if width > 0 and height > 0 then
        local bubble = world:newRectangleCollider(x, y, width, height, {collision_class = class})
        bubble:setType('dynamic')
        bubble:setFixedRotation(true)
        bubble:setGravityScale(0)
        table.insert(bubbles, bubble)
        return bubble
    end
end

function platforms.destroyBubble()
    bubbles[1]:destroy()
    table.remove(bubbles, 1)
end

function platforms.getBubblePosition()
    return bubbles[1]:getPosition()
end

function platforms.isBubbleValid()
    return bubbles[1]:isActive()
end

return platforms