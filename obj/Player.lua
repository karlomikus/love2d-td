Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)

    self.barrel = Barrel(area, self.x, self.y)
end

function Player:update(dt)
    Player.super.update(self, dt)
    self.barrel:update(dt)
end

function Player:draw()
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("line", self.x - 20, self.y, 40, 10)
    love.graphics.setColor(1, 1, 1)
    self.barrel:draw()
end
