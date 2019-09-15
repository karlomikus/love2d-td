Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
    Projectile.super.new(self, area, x, y, opts)

    self.velocity = 500
    self.rot = math.rad(opts.rot)

    self.body = love.physics.newBody(area.world, self.x, self.y, "dynamic")
    self.shape = love.physics.newRectangleShape(5, 5)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setDensity(0.08)
    self.fixture:setUserData("Projectile")
    self.body:setMass(0.03)
    self.body:setLinearVelocity(self.velocity * math.cos(self.rot), self.velocity * math.sin(self.rot))
end

function Projectile:update(dt)
    Projectile.super.update(self, dt)

    if self.area:collided(self.body:getX(), self.body:getY(), 5, 5) then
        self.area:addGameObject('Explosion', self.body:getX(), self.body:getY())
        self.dead = true
    end
end

function Projectile:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    love.graphics.setColor(1, 1, 1)
end

function Projectile:destroy()
    Projectile.super.destroy(self)
end
