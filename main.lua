local sti = require "sti"

function love.load()
    map = sti("map1.lua")
    player = {}
    player.x = 200
    player.y = 200
    player.speed = 450
end

function love.update(dt)
    map:update(dt)
    if love.keyboard.isDown("d") then
        player.x = player.x + (player.speed * dt)
    end

    if love.keyboard.isDown("a") then
        player.x = player.x - (player.speed * dt)
    end

    if love.keyboard.isDown("s") then
        player.y = player.y + (player.speed * dt)
    end

    if love.keyboard.isDown("w") then
        player.y = player.y - (player.speed * dt)
    end
end

function love.draw()
    map:draw()
    love.graphics.rectangle("fill", player.x, player.y, 32, 32, 5, 5)
end
