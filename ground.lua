local ground = {}

ground.body = love.physics.newBody(world, 500/2, 500-50/2)
ground.shape = love.physics.newRectangleShape(500, 50)
ground.fixture = love.physics.newFixture(ground.body, ground.shape)

return ground
