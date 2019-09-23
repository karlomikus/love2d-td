Rocket = GameObject:extend()

function Rocket:new(x, y, opts)
    Rocket.super.new(self, x, y, opts)

    self.velocity = 500
    self.dmg = 50
    self.rot = math.rad(opts.rot)

    self.body = love.physics.newBody(map.world, self.x, self.y, "dynamic")
    self.shape = love.physics.newCircleShape(2.3)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setDensity(0.08)
    self.fixture:setUserData("Rocket")
    self.body:setMass(0.03)
    self.body:setLinearVelocity(self.velocity * math.cos(self.rot), self.velocity * math.sin(self.rot))

    self.timer:every(0.01, function() map:addGameObject('RocketTrail', self.body:getX(), self.body:getY()) end)
end

function Rocket:update(dt)
    Rocket.super.update(self, dt)

    for _, p in ipairs(director.players) do
        if (self.body:getX() >= p.hitbox.x and self.body:getX() <= p.hitbox.x + p.hitbox.w) and (self.body:getY() >= p.hitbox.y and self.body:getY() <= p.hitbox.y + p.hitbox.h) then
            self:onHit(self.body:getX(), self.body:getY())
            p.hp = p.hp - self.dmg
            return
        end
    end

    if map:collided(self.body:getX(), self.body:getY(), 5, 5) then
        self:onHit(self.body:getX(), self.body:getY())
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

function Rocket:onHit(x, y)
    map:addGameObject('Explosion', x, y, {dmg = self.dmg})
    impact_sound:stop()
    impact_sound:play()
    self.dead = true
end
