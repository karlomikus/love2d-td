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
require "obj/Director"
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

    love.audio.setVolume(0.1)
    impact_sound = love.audio.newSource("res/sounds/impact.ogg", "static")
    projectile_launch_sound = love.audio.newSource("res/sounds/projectile_launch.wav", "static")
    bg_music = love.audio.newSource("res/sounds/bg.mp3", "stream")
    bg_music:setLooping(true)
    bg_music:play()

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
    stage:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(19/255, 0, 56/255)

    effect(function()
        stage:draw()
    end)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
