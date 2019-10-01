Shop = Object:extend()

function Shop:new(player)
    self.w = 700
    self.h = 500
    self.x = (gw - self.w) / 2
    self.y = 20

    self.shown = false

    self.buttons = {}
    for i, item in pairs(weapons_pool) do
        i = i - 1
        -- Quantity
        table.insert(self.buttons, ButtonShop(string.format("%s", item.shop_quantity), 20, 60 + i * 40, 50, 30))
        -- Name
        table.insert(self.buttons, ButtonShop(item.name, 70, 60 + i * 40, 360, 30))
        -- Price
        table.insert(self.buttons, ButtonShop(string.format("$%s", item.price), 430, 60 + i * 40, 140, 30))
        -- Buy button
        table.insert(self.buttons, Button("Buy", 600, 60 + i * 40, 60, 30, true, true, true))
    end
end

function Shop:update(dt)
    if not self.shown then
        return
    end

    -- self.buttons[#self.buttons]:setDisabled(director.current_player.money >= item.price)

    for _,b in pairs(self.buttons) do
        b:update(dt)
    end
end

function Shop:draw()
    if not self.shown then
        return
    end

    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor({247/255, 0, 157/255, 0.2})
    love.graphics.rectangle("line", self.x + 3, self.y + 3, self.w - 5, self.h - 5)
    love.graphics.line(self.x, self.y + 40, self.x + self.w, self.y + 40)
    love.graphics.setColor({247/255, 0, 157/255, 1})

    love.graphics.print("Weapon shop", self.x + 20, 26)

    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    for _,b in pairs(self.buttons) do
        b:draw()
    end
    love.graphics.pop()
end
