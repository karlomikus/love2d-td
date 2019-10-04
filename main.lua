require "utils"

moonshine = require "libs/moonshine"
Object = require "libs/classic"
Input = require "libs/Input"
Timer = require "libs/Timer"
Bresenham = require "libs/Bresenham"
camera = require "libs/SXCamera"
anim8 = require "libs/anim8"
GameObject = require "libs/GameObject"

COLORS = {
    BG = { hex2rgb("#130038") },
    PINK = { hex2rgb("#f7009c") },
    YELLOW = { hex2rgb("#fccb4e") },
    BLUE = { hex2rgb("#1d4ef0") },
    GREEN = { hex2rgb("#249337") },
    RED = { hex2rgb("#f01d1d") },
}

function love.load()
    -- Include all obj files
    local object_files = {}
    recursiveEnumerate('obj', object_files)
    requireFiles(object_files)

    -- Canvases
    game_canvas = love.graphics.newCanvas()
    map_canvas = love.graphics.newCanvas()

    -- Modify defaults
    love.graphics.setLineStyle("rough")
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
    sounds.shop_open = love.audio.newSource("res/sounds/shop_open.ogg", "static")
    sounds.shop_close = love.audio.newSource("res/sounds/shop_close.ogg", "static")
    sounds.button_hover = love.audio.newSource("res/sounds/button_hover.ogg", "static")
    sounds.click = love.audio.newSource("res/sounds/click.ogg", "static")

    love.audio.setVolume(0.1)
    sounds.level_music:setLooping(true)
    sounds.level_music:play()

    -- Shaders
    effect = moonshine(moonshine.effects.crt).chain(moonshine.effects.chromasep).chain(moonshine.effects.scanlines)
    effect.chromasep.angle = math.rad(30)
    effect.chromasep.radius = 1
    effect.scanlines.opacity = 0.2
    effect.disable("crt", "chromasep", "scanlines")

    -- Init game objs
    camera = camera()
    map = Map()
    director = Director()
    gameUI = GameUI()

    -- Add players
    director:addPlayer(100, 0, {color = COLORS.GREEN, name = "Player 1"})
    director:addPlayer(900, 0, {color = COLORS.RED, name = "Player 2"})
    director:addPlayer(600, 0, {color = COLORS.BLUE, name = "Player 3"})
    director:addPlayer(400, 0, {color = COLORS.YELLOW, name = "Player 4"})
    director:startRound()
end

function love.update(dt)
    camera:update(dt)
    map:update(dt)
    director:update(dt)
    gameUI:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(COLORS["BG"])

    effect(function()
        -- Map bg
        love.graphics.setColor(15/255, 2/255, 43/255)
        love.graphics.rectangle("fill", 0, gh/2 + 100, gw, gh)
        love.graphics.setColor(50/255, 18/255, 114/255)
        love.graphics.rectangle("fill", 0, gh/2 + 100, gw, 5)
        love.graphics.setColor(1, 1, 1)

        map.rain:draw()

        camera:attach()
        map:draw()
        director:draw()
        camera:detach()
        gameUI:draw()
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
