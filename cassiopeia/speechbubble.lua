utf8 = require "libs/utf8/utf8"
local dialogues = require "dialogos" 
local player = require "player"

function dialogLoad()
    w, h = 1080, 720
    love.window.setMode(w, h)
    love.window.setTitle("Speechbubble")
    love.graphics.setDefaultFilter('nearest', 'nearest')

    local font = love.graphics.newFont("src/fnt/gohufont-11.ttf", 11)
    love.graphics.setFont(font)

    offset = 10
    size = 2

    MAX_NAME_SIZE = 10

    
    dialogbox = {
        size          = {w = w * (5/7), h = 720/5},
        
        padding       = {x = 50, y = 10},

        bgcolor       = {67/255, 30/255, 102/255},
        color         = {1, 1, 1},

        cursor        = MAX_NAME_SIZE + 2,  -- ponto inicial

        cursorTimer   = {duration = 0.03, current = 0},
        nextlineTimer = {duration = 3, current = 0},

        gotonext      = false,
        active        = false,  -- inativa por padrão

        lines         = loadDialogues()[1],
        linesIndex    = 1
    }

    
    -- Cálculos, não mexer
    dialogbox.pos = {x = (w - dialogbox.size.w) / 2, y = h - dialogbox.size.h - offset}
    lines = loadDialogues()
    dialogbox.active = false

end

-- Atualiza o cursor (corrigir bug do utf-8)
function dialogUpdate()
    if love.timer.getTime() - dialogbox.cursorTimer.current > dialogbox.cursorTimer.duration then
        dialogbox.cursorTimer.current = love.timer.getTime()

        -- Escrita
        if dialogbox.cursor < #dialogbox.lines[dialogbox.linesIndex] then
            dialogbox.cursor = dialogbox.cursor + 1
            dialogbox.gotonext = false
        -- Próxima Linha
        elseif dialogbox.gotonext and dialogbox.linesIndex < #dialogbox.lines then
            dialogbox.linesIndex = dialogbox.linesIndex + 1
            dialogbox.gotonext = false
            dialogbox.cursor = MAX_NAME_SIZE + 2
        -- Fim do diálogo
        elseif dialogbox.gotonext and dialogbox.linesIndex >= #dialogbox.lines then
            dialogbox.active = false
            player.makePlayerMovable()
        end
    end
end


function dialogDraw()
    if  dialogbox.active then
        player.makePlayerUnmovable()
        -- Desenha a caixa
        love.graphics.setColor(dialogbox.bgcolor[1], dialogbox.bgcolor[2], dialogbox.bgcolor[3])
        love.graphics.rectangle("fill", dialogbox.pos.x, dialogbox.pos.y, dialogbox.size.w, dialogbox.size.h)
        
        -- Escreve o texto
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(
            {dialogbox.color, utf8_sub(dialogbox.lines[dialogbox.linesIndex], 1, dialogbox.cursor)},
            dialogbox.pos.x+dialogbox.padding.x,
            dialogbox.pos.y + dialogbox.padding.y, nil, size, size, 0, 0)
    end
end

function newDialog(lines)
    dialogbox.linesIndex = 1
    dialogbox.cursor = MAX_NAME_SIZE + 2
    dialogbox.lines = lines
    dialogbox.active = true
end

function isDialogActive()
    return dialogbox.active
end

function nextLine()
    dialogbox.gotonext = true
end

function isLastLine()
    return dialogbox.lines[dialogbox.linesIndex] == dialogbox.lines[-1]
end


-- love

-- function love.load(dt)
--     dialogLoad()
-- end

-- function love.update(dt)
--     dialogUpdate()
    
-- end

-- function love.draw(dt)
--     dialogDraw()
-- end

-- function love.keypressed(key)
--     if key == 'escape' then
--         love.event.quit()
--     elseif key == 'z' then
--         dialogbox.gotonext = true
--     elseif key == 'c' then
--         newDialog(dialogues[4])
--     end
-- end