Enemy = GameObject:extend()

function Enemy:new(area, x, y, opts)
    Enemy.super.new(self, area, x, y, opts)

    self.body = love.physics.newBody(area.world, self.x, self.y, "dynamic")
    self.shape = love.physics.newRectangleShape(100, 100)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData("Enemy")
end

function Enemy:update(dt)
    Enemy.super.update(self, dt)
end

function Enemy:draw()
    love.graphics.setColor(0, 0, 1)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    love.graphics.setColor(1, 1, 1)
end
