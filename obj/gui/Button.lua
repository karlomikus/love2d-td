Button = Object:extend()

function Button:new(text, x, y, w, h)
    self.x = x or 0
    self.y = y or 0
    self.w = w or 100
    self.h = h or 20
    self.text = love.graphics.newText(fonts.main_md, text)
end

function Button:update(dt)
end

function Button:draw()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(247/255, 0, 157/255, 1)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.text, self.x + (self.w - self.text:getWidth()) / 2, self.y + (self.h - self.text:getHeight()) / 2)
end
