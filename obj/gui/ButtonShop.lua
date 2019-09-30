ButtonShop = Button:extend()

function ButtonShop:new(text, x, y, w, h, hoverable)
    ButtonShop.super.new(self, text, x, y, w, h, hoverable)

    self.accent_color = {252/255, 203/255, 78/255, 1}
    self.align = "left"
end

function ButtonShop:update(dt)
    ButtonShop.super.update(self, dt)
end

function ButtonShop:draw()
    ButtonShop.super.draw(self)
end
