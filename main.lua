require "utils"

moonshine = require "libs/moonshine"
Object = require "libs/classic"
Input = require "libs/Input"
Timer = require "libs/Timer"
Bresenham = require "libs/Bresenham"
camera = require "libs/SXCamera"
anim8 = require "libs/anim8"

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
    -- Include all obj files
    local object_files = {}
    recursiveEnumerate('obj', object_files)
    requireFiles(object_files)

    -- Modify defaults
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Font resources
    fonts = {}
    fonts.main_sm = love.graphics.newFont("res/fonts/m5x7.ttf", 20, "mono")
    fonts.main_md = love.graphics.newFont("res/fonts/m5x7.ttf", 30, "mono")

    -- Texture resources
    texture = {}
    texture.explosion = love.graphics.newImage("res/textures/explosion.png")

    -- Sound resources
    sounds = {}
    sounds.level_music = love.audio.newSource("res/sounds/bg.ogg", "stream")
    sounds.rocket_start = love.audio.newSource("res/sounds/rocket_start.wav", "static")
    sounds.explosion = love.audio.newSource("res/sounds/explosion.wav", "static")
    sounds.tank_hit = love.audio.newSource("res/sounds/impact.ogg", "static")

    love.audio.setVolume(0.1)
    sounds.level_music:setLooping(true)
    sounds.level_music:play()

    -- Shaders
    effect = moonshine(moonshine.effects.crt).chain(moonshine.effects.chromasep).chain(moonshine.effects.scanlines)
    -- effect.chromasep.angle = math.rad(30)
    -- effect.chromasep.radius = 1
    -- effect.scanlines.opacity = 0.2
    effect.disable("crt", "chromasep", "scanlines")

    -- Init game objs
    global_timer = Timer()
    camera = camera()
    map = Map()
    director = Director()
    gameUI = GameUI()

    -- Add players
    director:addPlayer(100, 0, {color = COLORS["GREEN"], name = "Player 1"})
    director:addPlayer(900, 0, {color = COLORS["RED"], name = "Player 2"})
    director:addPlayer(600, 0, {color = COLORS["BLUE"], name = "Player 3"})
    director:startRound()
end

function love.update(dt)
    camera:update(dt)
    global_timer:update(dt)
    map:update(dt)
    director:update(dt)
    gameUI:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(COLORS["BG"])

    effect(function()
        camera:attach()
        map:draw()
        director:draw()
        gameUI:draw()
        camera:detach()
    end)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "f1" then
        print("Before collection: " .. collectgarbage("count")/1024)
        collectgarbage()
        print("After collection: " .. collectgarbage("count")/1024)
        print("Object count: ")
        local counts = type_count()
        for k, v in pairs(counts) do print(k, v) end
        print("-------------------------------------")
    end
end
