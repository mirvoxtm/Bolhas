function love.load()
    love.window.setMode(1080, 720)
end

function love.draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    for i = 0, 10, 1 do
        love.graphics.setColor(1, 0, 0, 0.1)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        love.graphics.present()
        love.timer.sleep(1)
    end
    
    print('cu')

end