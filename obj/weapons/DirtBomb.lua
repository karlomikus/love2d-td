DirtBomb = GameObject:extend()

function DirtBomb:new(x, y, opts)
    DirtBomb.super.new(self, x, y, opts)

    self.max_velocity = 800
    self.velocity = self.max_velocity * director.current_player.barrel.power
    self.dmg = 50
    self.rot = math.rad(opts.rot)

    self.body = love.physics.newBody(map.world, self.x, self.y, "dynamic")
    self.shape = love.physics.newCircleShape(3)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setDensity(0.08)
    self.fixture:setUserData("DirtBomb")
    self.body:setMass(0.03)
    self.body:setLinearVelocity(self.velocity * math.cos(self.rot), self.velocity * math.sin(self.rot))
end

function DirtBomb:update(dt)
    DirtBomb.super.update(self, dt)

    self.x = self.body:getX()
    self.y = self.body:getY()

    for _, p in ipairs(director.players) do
        if (self.body:getX() >= p.hitbox.x and self.body:getX() <= p.hitbox.x + p.hitbox.w) and (self.body:getY() >= p.hitbox.y and self.body:getY() <= p.hitbox.y + p.hitbox.h) then
            self:onHit(self.body:getX(), self.body:getY())
            return
        end
    end

    if map:collided(self.body:getX(), self.body:getY(), 5, 5, true) then
        self:onHit(self.body:getX(), self.body:getY())
    end
end

function DirtBomb:draw()
    love.graphics.setColor(171/255, 74/255, 0)
    love.graphics.circle("fill", self.x, self.y, self.shape:getRadius())
    love.graphics.setColor(1, 1, 1)
end

function DirtBomb:destroy()
    DirtBomb.super.destroy(self)
end

function DirtBomb:onHit(x, y)
    map:addGameObject('Dirt', x, y)
    self.dead = true
    love.event.push('endTurn')
end
