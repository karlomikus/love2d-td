TargetHit = GameObject:extend()

function TargetHit:new(x, y, opts)
    TargetHit.super.new(self, x, y, opts)

    self.w = 12
    self.h = 12

    self.first = true
    self.timer:after(0.2, function()
        self.first = false
        self.second = true
        self.timer:after(0.35, function()
            self.second = false
            self.dead = true
        end)
    end)
end

function TargetHit:update(dt)
    TargetHit.super.update(self, dt)
end

function TargetHit:draw()
    if self.first then
        love.graphics.setColor(0, 233/255, 235/255, 1)
    elseif self.second then
        love.graphics.setColor(235/255, 35/255, 0, 1)
    end
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1)
end
