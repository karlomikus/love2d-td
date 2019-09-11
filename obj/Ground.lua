Ground = GameObject:extend()

function Ground:new(area, x, y, opts)
    Ground.super.new(self, area, x, y, opts)

    self.width = 500
    self.height = 50

    self.body = love.physics.newBody(area.world, self.width / 2, self.y - self.height / 2)
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
end

function Ground:update(dt)
    Ground.super.update(self, dt)
end

function Ground:draw()
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end
