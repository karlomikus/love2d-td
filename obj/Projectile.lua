Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
    Projectile.super.new(self, area, x, y, opts)

    self.velocity = 700
    self.rot = math.rad(opts.rot)

    area.world:setCallbacks(function (a, b, coll)
        self:beginContact(a, b, coll)
    end, nil, nil, nil)

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
end

function Projectile:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    love.graphics.setColor(1, 1, 1)
end

function Projectile:beginContact(a, b, coll)
    if (a:getUserData() == "Enemy" and b:getUserData() == "Projectile") then
        self.dead = true
    end
end
