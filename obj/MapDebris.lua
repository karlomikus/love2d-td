MapDebris = GameObject:extend()

function MapDebris:new(x, y, opts)
    MapDebris.super.new(self, x, y, opts)

    self.color = COLORS.PINK
    self.r = randomp(0, 2*math.pi)
    self.s = opts.s or randomp(2, 3)
    self.v = opts.v or randomp(75, 150)
    self.line_width = 5

    self.timer:tween(opts.d or randomp(0.5, 0.8), self, {s = 0, v = 0, line_width = 0},
        'linear', function() self.dead = true end)

    self.body = love.physics.newBody(map.world, self.x, self.y, "dynamic")
    self.shape = love.physics.newCircleShape(self.s)
    self.fixture = love.physics.newFixture(self.body, self.shape)
end

function MapDebris:update(dt)
    MapDebris.super.update(self, dt)

    self.x = self.body:getX()
    self.y = self.body:getY()

    self.body:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
end

function MapDebris:draw()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.r or 0)
    love.graphics.translate(-self.x, -self.y)
    love.graphics.setLineWidth(self.line_width)
    love.graphics.setColor(self.color)
    love.graphics.line(self.x - self.s, self.y, self.x + self.s, self.y)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setLineWidth(1)
    love.graphics.pop()
end
