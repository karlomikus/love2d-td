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
require "obj/Enemy"

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

    bomb_w = 50
    bomb_h = 50

    player_x = 100
    player_y = 100
    player_w = 20
    player_h = 20
    player_speed = 200

    map_image_data = love.image.newImageData("res/map.bmp")
    map_image_data:mapPixel(function (x, y, r, g, b, a)
        if r == 0 and b == 0 and g == 1 then
            a = 0
        end

        return r, g, b, a
    end)
    map = love.graphics.newImage(map_image_data)
end

function love.update(dt)
    timer:update(dt)
    camera:update(dt)

    if input:down('angle_up') then
        player_y = player_y - player_speed * dt
    end

    if input:down('angle_down') then
        player_y = player_y + player_speed * dt
    end

    if input:down('tank_forward') then
        player_x = player_x + player_speed * dt
    end

    if input:down('tank_backward') then
        player_x = player_x - player_speed * dt
    end

    for px = player_x, player_x + player_w, 1 do
        for py = player_y, player_y + player_h, 1 do
            local r,g,b,a = map_image_data:getPixel(px, py)
            if a ~= 0 then
                map_image_data:setPixel(px, py, 0, 0, 1, 1)
            end
        end
    end
    map = love.graphics.newImage(map_image_data)

    if input:pressed('m1') then
        for i = 1, bomb_w, 1 do
            for j = 1, bomb_h, 1 do
                local x_pixel, y_pixel = love.mouse.getX() + i - (bomb_w/2), love.mouse.getY() + j - (bomb_h/2)
                map_image_data:setPixel(x_pixel, y_pixel, 0, 1, 0, 0)
            end
        end
        map = love.graphics.newImage(map_image_data)
    end

    -- if stage then stage:update(dt) end
end


function love.draw()
    love.graphics.draw(map)
    love.graphics.setLineStyle("rough")
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", player_x, player_y, player_w, player_h)
    -- if stage then stage:draw() end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
