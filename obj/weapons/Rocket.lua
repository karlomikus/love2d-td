Rocket = GameObject:extend()

function Rocket:new(x, y, opts)
    Rocket.super.new(self, x, y, opts)

    self.velocity = 500
    self.rot = math.rad(opts.rot)

    self.body = love.physics.newBody(map.world, self.x, self.y, "dynamic")
    self.shape = love.physics.newCircleShape(2.3)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setDensity(0.08)
    self.fixture:setUserData("Rocket")
    self.body:setMass(0.03)
    self.body:setLinearVelocity(self.velocity * math.cos(self.rot), self.velocity * math.sin(self.rot))
end

function Rocket:update(dt)
    Rocket.super.update(self, dt)

    if map:collided(self.body:getX(), self.body:getY(), 5, 5) then
        map:addGameObject('Explosion', self.body:getX(), self.body:getY())
        impact_sound:stop()
        impact_sound:play()
        self.dead = true
    end
end

function Rocket:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
    love.graphics.setColor(1, 1, 1)
end

function Rocket:destroy()
    Rocket.super.destroy(self)
end
