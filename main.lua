require "utils"

moonshine = require "libs/moonshine"
Object = require "libs/classic"
Input = require "libs/Input"
Timer = require "libs/Timer"
Camera = require "libs/Camera"
Bresenham = require "libs/Bresenham"

require "obj/GameObject"
require "obj/Player"
require "obj/Director"
require "obj/Map"

require "obj/weapons/Explosion"
require "obj/weapons/Rocket"
require "obj/weapons/Laser"

COLORS = {}

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- background = love.graphics.newImage("res/bg.jpg")
    effect = moonshine(moonshine.effects.crt).chain(moonshine.effects.chromasep)
    -- effect.chromasep.angle = math.rad(30)
    -- effect.chromasep.radius = 2
    effect.disable("crt", "chromasep")

    global_timer = Timer()

    COLORS["SLATE_DARK"] = { hex2rgb("#2e2c3b") }
    COLORS["SLATE_MED"] = { hex2rgb("#3e415f") }
    COLORS["SLATE_LIGHT"] = { hex2rgb("#55607d") }
    COLORS["GRAY"] = { hex2rgb("#747d88") }
    COLORS["ELECTRO_GREEN"] = { hex2rgb("#41de95") }
    COLORS["SEA_GREEN"] = { hex2rgb("#2aa4aa") }
    COLORS["BLUE"] = { hex2rgb("#3b77a6") }
    COLORS["GREEN"] = { hex2rgb("#249337") }
    COLORS["GREEN_LIGHT"] = { hex2rgb("#56be44") }
    COLORS["LEMON"] = { hex2rgb("#c6de78") }
    COLORS["YELLOW"] = { hex2rgb("#f3c220") }
    COLORS["ORANGE"] = { hex2rgb("#c4651c") }
    COLORS["RED"] = { hex2rgb("#b54131") }
    COLORS["PURPLE_DARK"] = { hex2rgb("#61407a") }
    COLORS["PURPLE_LIGHT"] = { hex2rgb("#8f3da7") }
    COLORS["PINK"] = { hex2rgb("#ea619d") }
    COLORS["SKY"] = { hex2rgb("#c1e5ea") }

    love.audio.setVolume(0.1)
    impact_sound = love.audio.newSource("res/sounds/impact.ogg", "static")
    projectile_launch_sound = love.audio.newSource("res/sounds/projectile_launch.wav", "static")
    bg_music = love.audio.newSource("res/sounds/bg.ogg", "stream")
    bg_music:setLooping(true)
    bg_music:play()

    camera = Camera()
    map = Map()
    director = Director()

    director:addPlayer(100, 300, COLORS["GREEN"])
    director:addPlayer(900, 300, COLORS["RED"])
    director:addPlayer(600, 100, COLORS["BLUE"])
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

function hex2rgb(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)) / 255, tonumber("0x"..hex:sub(3,4)) / 255, tonumber("0x"..hex:sub(5,6)) / 255
end
