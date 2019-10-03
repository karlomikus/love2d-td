Rocket = GameObject:extend()

function Rocket:new(x, y, opts)
    Rocket.super.new(self, x, y, opts)

    self.max_velocity = 800
    self.velocity = self.max_velocity * director.current_player.barrel.power
    self.dmg = 50
    self.rot = math.rad(opts.rot)

    self.body = love.physics.newBody(map.world, self.x, self.y, "dynamic")
    self.shape = love.physics.newCircleShape(2.3)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setDensity(0.08)
    self.fixture:setUserData("Rocket")
    self.body:setMass(0.03)
    self.body:setLinearVelocity(self.velocity * math.cos(self.rot), self.velocity * math.sin(self.rot))

    sounds.rocket_start:stop()
    sounds.rocket_start:play()

    self.timer:every(0.01, function() map:addGameObject('RocketTrail', self.body:getX(), self.body:getY()) end)
end

function Rocket:update(dt)
    Rocket.super.update(self, dt)

    self.x = self.body:getX()
    self.y = self.body:getY()

    for _, p in ipairs(director.players) do
        if (self.body:getX() >= p.hitbox.x and self.body:getX() <= p.hitbox.x + p.hitbox.w) and (self.body:getY() >= p.hitbox.y and self.body:getY() <= p.hitbox.y + p.hitbox.h) then
            self:onHit(self.body:getX(), self.body:getY())
            p:onDamageTaken(self)
            return
        end
    end

    if map:collided(self.body:getX(), self.body:getY(), 5, 5, true) then
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
    sounds.explosion:stop()
    sounds.explosion:play()
    self.dead = true
end
