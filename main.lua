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
    love.graphics.setDefaultFilter('nearest', 'nearest')

    timer = Timer()
    input = Input()

    input:bind('mouse1', 'm1')
    input:bind('w', 'up')
    input:bind('s', 'down')
    input:bind('d', 'tank_forward')
    input:bind('a', 'tank_backward')
    input:bind('lshift', 'shift')
    input:bind('space', 'shoot')

    camera = Camera()
    stage = Stage()

    bomb_w = 50
    bomb_h = 50

    player = {}
    player.x = 100
    player.y = 300
    player.w = 10
    player.h = 30
    player.speed = 250

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

    -- camera:follow(player.x, player.y)
    -- camera:setFollowLerp(0.2)

    if input:down('up') then
        player.y = player.y - player.speed * dt
    end

    if input:down('down') then
        player.y = player.y + player.speed * dt
    end

    if input:down('tank_forward') then
        if not collided(player.x + player.w, player.y, 1, player.h - 3) then
            player.x = player.x + player.speed * dt
            if collided(player.x, player.y + player.h, player.w, 1) then
                print("fw: pushing up")
                player.y = player.y - 1
            end
        end
    end

    if input:down('tank_backward') then
        if not collided(player.x - 1, player.y, 1, player.h - 3) then
            player.x = player.x - player.speed * dt
            if collided(player.x, player.y + player.h, player.w, 1) then
                print("bw: pushing up")
                player.y = player.y - 1
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

function collided(hx, hy, hw, hh)
    if hx > map_image_data:getWidth() or hx < 0 or hy > map_image_data:getHeight() or hy < 0 then
        return true
    end

    for cx = hx, hx + hw, 1 do
        for cy = hy, hy + hh, 1 do
            local r,g,b,a = map_image_data:getPixel(cx, cy)
            if a ~= 0 then
                return true
            end
        end
    end
end

function love.draw()
    love.graphics.print("player x: " .. math.floor(player.x), 30, 130)
    love.graphics.print("player y: " .. math.floor(player.y), 30, 150)
    -- camera:attach()
    love.graphics.draw(map)
    love.graphics.setLineStyle("rough")
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", player.x, player.y, player.w, player.h)
    -- camera:detach()

    -- if stage then stage:draw() end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
