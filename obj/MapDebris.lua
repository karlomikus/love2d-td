MapDebris = GameObject:extend()

function MapDebris:new(x, y, opts)
    MapDebris.super.new(self, x, y, opts)

    self.w = 20
    self.h = 20

    self.vx = 100
    self.vy = 100
    self.gravity = -1000

    self.body = love.physics.newBody(map.world, self.x, self.y, "dynamic")
    self.shape = love.physics.newRectangleShape(self.w, self.h)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setDensity(0.08)
    self.body:setMass(0.03)
    self.body:setLinearVelocity(-100, -100)

    -- self.timer:tween(0.1, self, {r = 0, c = {r = 245/255, g = 57/255, b = 0/255}}, 'linear', function() self.dead = true end)
end

function MapDebris:update(dt)
    MapDebris.super.update(self, dt)
end

function MapDebris:draw()
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle('fill', self.body:getX(), self.body:getY(), self.w, self.h)
    love.graphics.setColor(1, 1, 1)
end
