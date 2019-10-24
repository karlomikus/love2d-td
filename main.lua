require "utils"

moonshine = require "libs/moonshine"
Object = require "libs/classic"
Input = require "libs/Input"
Timer = require "libs/Timer"
Bresenham = require "libs/Bresenham"
camera = require "libs/SXCamera"
anim8 = require "libs/anim8"
GameObject = require "libs/GameObject"
vector = require "libs/Vector"

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
    sounds.rocket_fly = love.audio.newSource("res/sounds/rocket_fly.mp3", "static")
    sounds.tank_move = love.audio.newSource("res/sounds/tank_move.wav", "static")
    sounds.explosion = love.audio.newSource("res/sounds/explosion.wav", "static")
    sounds.tank_hit = love.audio.newSource("res/sounds/impact.ogg", "static")
    sounds.shop_open = love.audio.newSource("res/sounds/shop_open.ogg", "static")
    sounds.shop_close = love.audio.newSource("res/sounds/shop_close.ogg", "static")
    sounds.button_hover = love.audio.newSource("res/sounds/button_hover.ogg", "static")
    sounds.click = love.audio.newSource("res/sounds/click.ogg", "static")
    sounds.invalid = love.audio.newSource("res/sounds/invalid_action.ogg", "static")
    sounds.dirt = love.audio.newSource("res/sounds/dirt.ogg", "static")

    love.audio.setVolume(0.1)
    sounds.tank_move:setVolume(0.1)
    sounds.level_music:setLooping(true)
    sounds.level_music:play()

    -- Shaders
    effect = moonshine(moonshine.effects.crt).chain(moonshine.effects.chromasep).chain(moonshine.effects.scanlines)
    effect.chromasep.angle = math.rad(30)
    effect.chromasep.radius = 1
    effect.scanlines.opacity = 0.2
    effect.disable("crt", "chromasep", "scanlines")

    -- States
    current_state = MainMenuState()
end

function love.update(dt)
    current_state:update(dt)
end

function love.draw()
    current_state:draw()
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
