require "utils"

Object = require "libs/classic"
Input = require "libs/Input"
Timer = require "libs/Timer"
Camera = require "libs/Camera"

require "obj/Stage"
require "obj/Area"
require "obj/GameObject"
require "obj/Player"
require "obj/Ground"
require "obj/Projectile"

function love.load()
    timer = Timer()
    input = Input()
    input:bind('mouse1', 'm1')
    input:bind('w', 'angle_up')
    input:bind('s', 'angle_down')
    input:bind('d', 'tank_forward')
    input:bind('a', 'tank_backward')
    input:bind('lshift', 'shift')
    input:bind('space', 'shoot')

    camera = Camera()
    stage = Stage()
end

function love.update(dt)
    timer:update(dt)
    camera:update(dt)
    if input:pressed('m1') then print('pressed') end

    if stage then stage:update(dt) end
end


function love.draw()
    if stage then stage:draw() end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
