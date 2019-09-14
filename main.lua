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
    canvas = love.graphics.newCanvas(125, 125)

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

    player_x = 100
    player_y = 300
    player_w = 10
    player_h = 30
    player_speed = 200

    player_hitbox_left_w = 0
    player_hitbox_left_h = 0
    player_hitbox_left_x = 0
    player_hitbox_left_y = 0

    player_hitbox_right_w = 0
    player_hitbox_right_h = 0
    player_hitbox_right_x = 0
    player_hitbox_right_y = 0

    player_hitbox_top_w = 0
    player_hitbox_top_h = 0
    player_hitbox_top_x = 0
    player_hitbox_top_y = 0

    player_hitbox_bottom_w = 0
    player_hitbox_bottom_h = 0
    player_hitbox_bottom_x = 0
    player_hitbox_bottom_y = 0

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

    camera:follow(player_x, player_y)
    camera:setFollowLerp(0.2)

    player_y = player_y + player_speed * dt

    player_hitbox_left_w = 1
    player_hitbox_left_h = player_h - 3
    player_hitbox_left_x = player_x - player_hitbox_left_w
    player_hitbox_left_y = player_y

    player_hitbox_right_w = 1
    player_hitbox_right_h = player_h - 3
    player_hitbox_right_x = player_x + player_w
    player_hitbox_right_y = player_y

    player_hitbox_top_w = player_w
    player_hitbox_top_h = 1
    player_hitbox_top_x = player_x
    player_hitbox_top_y = player_y

    player_hitbox_bottom_w = player_w
    player_hitbox_bottom_h = 1
    player_hitbox_bottom_x = player_x
    player_hitbox_bottom_y = player_y + player_h

    if collided(player_hitbox_bottom_x, player_hitbox_bottom_y, player_hitbox_bottom_w, player_hitbox_bottom_h) then
        player_y = player_y - player_speed * dt
    end

    if collided(player_hitbox_top_x, player_hitbox_top_y, player_hitbox_top_w, player_hitbox_top_h) then
        player_y = player_y + player_speed * dt
    end

    if input:down('up') then
        player_y = player_y - player_speed * 2 * dt
    end

    if input:down('tank_forward') then
        if not collided(player_hitbox_right_x, player_hitbox_right_y, player_hitbox_right_w, player_hitbox_right_h) then
            player_x = player_x + player_speed * dt
            if collided(player_hitbox_bottom_x, player_hitbox_bottom_y, player_hitbox_bottom_w, player_hitbox_bottom_h) then
                player_y = player_y - 1
            end
        end
    end

    if input:down('tank_backward') then
        if not collided(player_hitbox_left_x, player_hitbox_left_y, player_hitbox_left_w, player_hitbox_left_h) then
            player_x = player_x - player_speed * dt
            if collided(player_hitbox_bottom_x, player_hitbox_bottom_y, player_hitbox_bottom_w, player_hitbox_bottom_h) then
                player_y = player_y - 1
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
    camera:attach()
    love.graphics.draw(map)
    love.graphics.setLineStyle("rough")
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", player_x, player_y, player_w, player_h)
    camera:detach()

    -- love.graphics.setColor(0, 1, 0)
    -- love.graphics.rectangle("fill", player_hitbox_left_x, player_hitbox_left_y, player_hitbox_left_w, player_hitbox_left_h)
    -- love.graphics.rectangle("fill", player_hitbox_right_x, player_hitbox_right_y, player_hitbox_right_w, player_hitbox_right_h)
    -- love.graphics.setColor(1, 1, 1)

    -- love.graphics.setColor(1, 0, 0)
    -- love.graphics.rectangle("fill", player_hitbox_top_x, player_hitbox_top_y, player_hitbox_top_w, player_hitbox_top_h)
    -- love.graphics.rectangle("fill", player_hitbox_bottom_x, player_hitbox_bottom_y, player_hitbox_bottom_w, player_hitbox_bottom_h)
    -- love.graphics.setColor(1, 1, 1)

    -- if stage then stage:draw() end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
