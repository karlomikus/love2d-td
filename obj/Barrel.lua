Barrel = GameObject:extend()

function Barrel:new(area, x, y, opts)
    Barrel.super.new(self, area, x, y, opts)
    self.rot = 0
end

function Barrel:update(dt)
    Barrel.super.update(self, dt)

    if input:down('angle_up') then
        self.rot = self.rot - 100 * dt
    end

    if input:down('angle_down') then
        self.rot = self.rot + 100 * dt
    end
end

function Barrel:draw()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(math.rad(self.rot))
    love.graphics.rectangle("fill", 0, 0, 40, 3)
    love.graphics.pop()
end
