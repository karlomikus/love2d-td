Barrage = GameObject:extend()

function Barrage:new(x, y, opts)
    Barrage.super.new(self, x, y, opts)

    self.max_velocity = 1200
    self.velocity = self.max_velocity * director.current_player.barrel.power
    self.dmg = 50
    self.rot = math.rad(opts.rot)

    self.body = love.physics.newBody(map.world, self.x, self.y, "dynamic")
    self.shape = love.physics.newCircleShape(4)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setDensity(0.08)
    self.fixture:setUserData("BarrageProjectile")
    self.body:setMass(0.03)
    self.body:setLinearVelocity(self.velocity * math.cos(self.rot), self.velocity * math.sin(self.rot))

    sounds.rocket_start:stop()
    sounds.rocket_start:play()
end

function Barrage:update(dt)
    Barrage.super.update(self, dt)
    local oldY = self.y

    self.x = self.body:getX()
    self.y = self.body:getY()

    if self.y > oldY then
        self:onHit(self.x, self.y)
    end
end

function Barrage:draw()
    love.graphics.setColor(0.4, 0.1, 0.3)
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
    love.graphics.setColor(1, 1, 1)
end

function Barrage:destroy()
    Barrage.super.destroy(self)
end

function Barrage:onHit(x, y)
    sounds.rocket_fly:stop()
    map:addGameObject('Explosion', x, y, {dmg = 5, radius = 10})
    self.dead = true
    map:addGameObject(
        'Rocket',
        self.x,
        self.y,
        {rot = -160}
    )
    map:addGameObject(
        'Rocket',
        self.x,
        self.y,
        {rot = -180}
    )
    map:addGameObject(
        'Rocket',
        self.x,
        self.y,
        {rot = -40}
    )
    -- love.event.push('endTurn')
end
