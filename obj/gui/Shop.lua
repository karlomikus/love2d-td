Shop = Object:extend()

function Shop:new(player)
    self.w = 600
    self.h = 500
    self.x = 200
    self.y = 20

    self.shown = false

    self.buttons = {}

    local bh = 30
    for i, item in pairs(weapons_pool) do
        i = i - 1
        -- Name
        table.insert(self.buttons, ButtonShop(item.name, 20, 60 + i * 40, 300, bh))
        -- Price
        table.insert(self.buttons, ButtonShop(string.format("$%s", item.price), 340, 60 + i * 40, 100, bh))
        -- Quantity
        table.insert(self.buttons, ButtonShop(string.format("%s", item.shop_quantity), 460, 60 + i * 40, 40, bh))
    end
end

function Shop:update(dt)
end

function Shop:draw()
    if not self.shown then
        return
    end

    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.print("Shop", self.x + self.w / 2, 40)

    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    for _,b in pairs(self.buttons) do
        b:draw()
    end
    love.graphics.pop()
end
