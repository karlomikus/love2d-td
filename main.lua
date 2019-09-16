require "utils"

moonshine = require "libs/moonshine"
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
    -- background = love.graphics.newImage("res/bg.jpg")

    effect = moonshine(moonshine.effects.crt).chain(moonshine.effects.chromasep)
    -- effect.chromasep.angle = math.rad(30)
    -- effect.chromasep.radius = 2
    effect.disable("crt", "chromasep")

    timer = Timer()
    input = Input()

    debug = true

    coll_debug = {}
    coll_debug.x = 0
    coll_debug.y = 0
    coll_debug.w = 20
    coll_debug.h = 20
    coll_debug.hit = false

    input:bind('mouse1', 'm1')
    input:bind('w', 'up')
    input:bind('s', 'down')
    input:bind('d', 'fwd')
    input:bind('a', 'bwd')
    input:bind('lshift', 'shift')
    input:bind('space', 'shoot')
    input:bind('f3', 'debug')

    camera = Camera()
    stage = Stage()
end

function love.update(dt)
    timer:update(dt)
    camera:update(dt)

    coll_debug.x = love.mouse.getX() - (coll_debug.w/2)
    coll_debug.y = love.mouse.getY() - (coll_debug.h/2)

    if stage then stage:update(dt) end

    if stage.area:collided(coll_debug.x, coll_debug.y, coll_debug.w, coll_debug.h) then
        coll_debug.hit = true
    else
        coll_debug.hit = false
    end
end

function love.draw()
    love.graphics.setBackgroundColor(19/255, 0, 56/255)

    effect(function()
        if stage then stage:draw() end
    end)

    if coll_debug.hit then
        love.graphics.print("Collision hit", 100, 20)
    else
        love.graphics.print("Collision miss", 100, 20)

    end

    if debug then
        love.graphics.rectangle("fill", coll_debug.x, coll_debug.y, coll_debug.w, coll_debug.h)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
