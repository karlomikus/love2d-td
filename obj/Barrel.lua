Barrel = GameObject:extend()

function Barrel:new(area, x, y, opts)
    Barrel.super.new(self, area, x, y, opts)
end

function Barrel:update(dt)
    Barrel.super.update(self, dt)
end

function Barrel:draw()
    love.graphics.rectangle("fill", self.x, self.y, 40, 3)
end
