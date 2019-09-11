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
    love.graphics.circle("line", self.x, self.y, 25)
    self.barrel:draw()
end
