Button = Object:extend()

function Button:new(text, x, y, w, h, hoverable)
    self.x = x or 0
    self.y = y or 0
    self.w = w or 100
    self.h = h or 40
    self.text = love.graphics.newText(fonts.main_md, text)

    self.accent_color = {247/255, 0, 157/255, 1}

    self.align = "center"

    self.input = Input()
    self.input:bind('mouse1', 'do_action')

    self.action = nil

    if hoverable == nil then
        self.hoverable = true
    else
        self.hoverable = false
    end
    self.is_hover = false
end

function Button:update(dt)
    if self.hoverable and love.mouse.getX() >= self.x and love.mouse.getX() <= self.x + self.w and love.mouse.getY() >= self.y and love.mouse.getY() <= self.y + self.h then
        self.is_hover = true
    else
        self.is_hover = false
    end

    if self.action and self.input:pressed('do_action') and love.mouse.getX() >= self.x and love.mouse.getX() <= self.x + self.w and love.mouse.getY() >= self.y and love.mouse.getY() <= self.y + self.h then
        self.action()
    end
end

function Button:draw()
    if self.is_hover then
        love.graphics.setColor(self.accent_color)
    else
        love.graphics.setColor(0, 0, 0, 1)
    end
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(self.accent_color)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1, 1)

    if self.align == "center" then
        self.text_x = self.x + (self.w - self.text:getWidth()) / 2
        self.text_y = self.y + (self.h - self.text:getHeight()) / 2
    else
        self.text_x = 20
        self.text_y = self.y + (self.h - self.text:getHeight()) / 2
    end

    love.graphics.draw(self.text, self.text_x, self.text_y)
end

function Button:setAction(action)
    self.action = action

    return self
end
