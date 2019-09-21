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
require "obj/Map"

require "obj/weapons/Rocket"

function love.load()
    -- love.graphics.setDefaultFilter('nearest', 'nearest')
    -- background = love.graphics.newImage("res/bg.jpg")

    effect = moonshine(moonshine.effects.crt).chain(moonshine.effects.chromasep)
    -- effect.chromasep.angle = math.rad(30)
    -- effect.chromasep.radius = 2
    effect.disable("crt", "chromasep")

    global_timer = Timer()

    love.audio.setVolume(0.1)
    impact_sound = love.audio.newSource("res/sounds/impact.ogg", "static")
    projectile_launch_sound = love.audio.newSource("res/sounds/projectile_launch.wav", "static")
    bg_music = love.audio.newSource("res/sounds/bg.ogg", "stream")
    bg_music:setLooping(true)
    bg_music:play()

    camera = Camera()
    map = Map()
    director = Director()

    director:addPlayer(100, 300, {0.4, 0.7, 0.1})
    director:addPlayer(900, 300, {0.6, 0.1, 0.2})
    director:addPlayer(600, 100, {0.2, 0.5, 0.8})
    director:startRound()
end

function love.update(dt)
    global_timer:update(dt)
    camera:update(dt)
    map:update(dt)
    director:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(19/255, 0, 56/255)

    effect(function()
        map:draw()
        director:draw()
    end)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
