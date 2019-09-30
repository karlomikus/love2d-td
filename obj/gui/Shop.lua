Shop = Object:extend()

function Shop:new(player)
    self.w = 500
    self.h = 500
    self.x = 200
    self.y = 20

    self.shown = false

    self.inventory = {
        {name = "Rockets", price = 200, q = 50},
        {name = "Grenade", price = 200, q = 50},
        {name = "Item", price = 200, q = 50},
        {name = "Name 2", price = 200, q = 50},
        {name = "A very long item name", price = 200, q = 50},
        {name = "More grenades", price = 200, q = 50},
    }

    self.buttons = {}

    for i, item in pairs(self.inventory) do
        i = i - 1
        table.insert(self.buttons, ButtonShop(
            item.name,
            20,
            60 + i * 40,
            300,
            30
        ))
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
