ButtonShop = Button:extend()

function ButtonShop:new(text, x, y, w, h, hoverable)
    ButtonShop.super.new(self, text, x, y, w, h, hoverable)

    self.accent_color = COLORS.YELLOW
    self.align = "left"
end

function ButtonShop:update(dt)
    ButtonShop.super.update(self, dt)
end

function ButtonShop:draw()
    if self.is_hover then
        love.graphics.setColor(self.accent_color)
    else
        love.graphics.setColor(0, 0, 0, 1)
    end
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(self.accent_color)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(self.text, self.x + 10, self.y + (self.h - self.text:getHeight()) / 2)
end
