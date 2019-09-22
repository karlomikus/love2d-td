RocketTrail = GameObject:extend()

function RocketTrail:new(x, y, opts)
    RocketTrail.super.new(self, x, y, opts)

    self.r = 2
    self.c = {}
    self.c.r = 245/255
    self.c.g = 167/255
    self.c.b = 0/255

    self.timer:tween(0.1, self, {r = 0, c = {r = 245/255, g = 57/255, b = 0/255}}, 'linear', function() self.dead = true end)
end

function RocketTrail:update(dt)
    RocketTrail.super.update(self, dt)

end

function RocketTrail:draw()
    love.graphics.setColor(self.c.r, self.c.g, self.c.b)
    love.graphics.circle('fill', self.x, self.y, self.r + randomp(-0.5, 0.5))
    love.graphics.setColor(1, 1, 1)
end
