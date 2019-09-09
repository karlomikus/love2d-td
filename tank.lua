local tank = {}

tank.body = love.physics.newBody(world, 500/2, 500/2, "dynamic")
tank.shape = love.physics.newRectangleShape(20, 20)
tank.fixture = love.physics.newFixture(tank.body, tank.shape, 3)
tank.fixture:setFriction(1)

function tank.shoot()
    tank.body:applyForce(-400, 0)
end

function tank.moveForward()
    tank.body:applyForce(300, 0)
end

function tank.moveBackward()
    tank.body:applyForce(-300, 0)
end

return tank
