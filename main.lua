require "utils"

Object = require "libs/classic"
Input = require "libs/Input"
Timer = require "libs/Timer"
Camera = require "libs/Camera"

require "obj/Stage"
require "obj/Area"
require "obj/GameObject"
require "obj/Player"
require "obj/Projectile"
require "obj/Explosion"

function love.load()
    -- love.graphics.setDefaultFilter('nearest', 'nearest')
    background = love.graphics.newImage("res/bg.jpg")

    timer = Timer()
    input = Input()

    input:bind('mouse1', 'm1')
    input:bind('w', 'up')
    input:bind('s', 'down')
    input:bind('d', 'fwd')
    input:bind('a', 'bwd')
    input:bind('lshift', 'shift')
    input:bind('space', 'shoot')

    camera = Camera()
    stage = Stage()
end

function love.update(dt)
    timer:update(dt)
    camera:update(dt)

    if stage then stage:update(dt) end
end

function love.draw()
    love.graphics.setBackgroundColor(19/255, 0, 56/255)

    if stage then stage:draw() end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
