Object = require "libs/classic"
Input = require "libs/Input"
Timer = require "libs/Timer"
Circle = require("obj/Circle")
HyperCircle = require("obj/HyperCircle")

function love.load()
    timer = Timer()
    input = Input()
    input:bind('mouse1', 'm1')

    exHyperCircle = HyperCircle(400, 300, 50, 10, 120)
    circle = {radius = 24}
    timer:tween(6, circle, {radius = 96}, 'in-out-cubic')
end

function love.update(dt)
    timer:update(dt)
    if input:pressed('m1') then print('pressed') end
end


function love.draw()
    -- exHyperCircle:draw()
    love.graphics.circle('fill', 400, 300, circle.radius)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
