function love.load()

    local vertices = {
        {20, 20},
        {300, 40},
        {300, 100},
        {20, 100}
    }
    mesh = love.graphics.newMesh(vertices, "fan")

    love.physics.setMeter(32)
    world = love.physics.newWorld(0, 9.81*32, true)

    objects = {}
    objects.ground = require "ground"
    objects.tank = require "tank"
end

function love.update(dt)
    world:update(dt)

    if love.keyboard.isDown("d") then
        objects.tank.moveForward()
    end

    if love.keyboard.isDown("a") then
        objects.tank.moveBackward()
    end

    if love.keyboard.isDown("space") then
        objects.tank.shoot()
    end
end

function love.draw()
    -- love.graphics.draw(mesh)

    love.graphics.setColor(0.28, 0.63, 0.05)
    love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

    love.graphics.setColor(0.76, 0.18, 0.05)
    love.graphics.polygon("fill", objects.tank.body:getWorldPoints(objects.tank.shape:getPoints()))
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
