require "utils"

moonshine = require "libs/moonshine"
Object = require "libs/classic"
Input = require "libs/Input"
Timer = require "libs/Timer"
Bresenham = require "libs/Bresenham"

require "obj/GameObject"
require "obj/Player"
require "obj/Director"
require "obj/Map"
require "obj/Inventory"

require "obj/weapons/Explosion"
require "obj/weapons/Rocket"
require "obj/weapons/RocketTrail"
require "obj/weapons/Laser"

COLORS = {
    BG = { hex2rgb("#130038") },
    SLATE_DARK = { hex2rgb("#2e2c3b") },
    SLATE_MED = { hex2rgb("#3e415f") },
    SLATE_LIGHT = { hex2rgb("#55607d") },
    GRAY = { hex2rgb("#747d88") },
    ELECTRO_GREEN = { hex2rgb("#41de95") },
    SEA_GREEN = { hex2rgb("#2aa4aa") },
    BLUE = { hex2rgb("#3b77a6") },
    GREEN = { hex2rgb("#249337") },
    GREEN_LIGHT = { hex2rgb("#56be44") },
    LEMON = { hex2rgb("#c6de78") },
    YELLOW = { hex2rgb("#f3c220") },
    ORANGE = { hex2rgb("#c4651c") },
    RED = { hex2rgb("#b54131") },
    PURPLE_DARK = { hex2rgb("#61407a") },
    PURPLE_LIGHT = { hex2rgb("#8f3da7") },
    PINK = { hex2rgb("#ea619d") },
    SKY = { hex2rgb("#c1e5ea") },
}

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    mainFont = love.graphics.newFont("res/forcedsquare.ttf", 30)

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

    map = Map()
    director = Director()
    inventory = Inventory()

    director:addPlayer(100, 300, {color = COLORS["GREEN"], name = "Player 1"})
    director:addPlayer(900, 300, {color = COLORS["RED"], name = "Player 2"})
    director:addPlayer(600, 100, {color = COLORS["BLUE"], name = "Player 3"})
    director:startRound()
end

function love.update(dt)
    global_timer:update(dt)
    map:update(dt)
    director:update(dt)
    inventory:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(COLORS["BG"])
    love.graphics.setFont(mainFont)

    effect(function()
        map:draw()
        director:draw()
    end)
    inventory:draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
