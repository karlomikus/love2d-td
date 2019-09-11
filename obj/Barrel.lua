Barrel = GameObject:extend()

function Barrel:new(area, x, y, opts)
    Barrel.super.new(self, area, x, y, opts)
    self.rot = 0
    self.length = 30
    self.caliber = 3
end

function Barrel:update(dt)
    Barrel.super.update(self, dt)

    if input:down('angle_up') and self.rot > -180 then
        if (input:down('shift')) then
            self.rot = self.rot - 150 * dt
        else
            self.rot = self.rot - 50 * dt
        end
    end

    if input:down('angle_down') and self.rot < 0 then
        if (input:down('shift')) then
            self.rot = self.rot + 150 * dt
        else
            self.rot = self.rot + 20 * dt
        end
    end
end

function Barrel:draw()
    love.graphics.print("Barrel angle: " .. math.floor(self.rot), 10, 10)
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(math.rad(self.rot))
    love.graphics.rectangle("fill", 0, 0, self.length, self.caliber)
    love.graphics.pop()
end
