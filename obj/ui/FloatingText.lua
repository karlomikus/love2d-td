FloatingText = GameObject:extend()

function FloatingText:new(text, x, y, opts)
    FloatingText.super.new(self, x, y, opts)

    self.text = love.graphics.newText(fonts.main_md, text)
    self.a = 1

    self.timer:tween(2, self, {a = 0}, 'linear', function()
        self.dead = true
    end)
end

function FloatingText:update(dt)
    FloatingText.super.update(self, dt)
    self.y = self.y - 100 * dt
end

function FloatingText:draw()
    love.graphics.setColor(1, 0, 0, self.a)
    love.graphics.draw(self.text, self.x, self.y)
    love.graphics.setColor(1, 1, 1, 1)
end
