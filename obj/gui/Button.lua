Button = Object:extend()

function Button:new(text, x, y, w, h)
    self.x = x or 0
    self.y = y or 0
    self.w = w or 100
    self.h = h or 20
    self.text = love.graphics.newText(fonts.main_md, text)

    self.is_hover = false
end

function Button:update(dt)
    if love.mouse.getX() >= self.x and love.mouse.getX() <= self.x + self.w and love.mouse.getY() >= self.y and love.mouse.getY() <= self.y + self.h then
        self.is_hover = true
    else
        self.is_hover = false
    end
end

function Button:draw()
    if self.is_hover then
        love.graphics.setColor(247/255, 0, 157/255, 1)
    else
        love.graphics.setColor(0, 0, 0, 1)
    end
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(247/255, 0, 157/255, 1)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.text, self.x + (self.w - self.text:getWidth()) / 2, self.y + (self.h - self.text:getHeight()) / 2)
end
