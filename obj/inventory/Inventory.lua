Inventory = Object:extend()

function Inventory:new()
    self.height = 50
    self.offset_bottom = 30

    self.x = gw/4
    self.y = gh - self.height - self.offset_bottom

    self.items = {}
    table.insert(self.items, InventoryItem("Rocket", "Rocket\nlauncher", 10, 10))
    table.insert(self.items, InventoryItem("Laser", "Laser\nBeam", 1, 1))
    table.insert(self.items, InventoryItem("Grenade", "Grenade", 2, 3))
    table.insert(self.items, InventoryItem("Mole", "Mole\nRocket", 1, 1))
    table.insert(self.items, InventoryItem("Acid", "Acid\nSpray", 0, 1))
    table.insert(self.items, InventoryItem("Dirt", "Dirt\nBomb", 1, 2))
end

function Inventory:update(dt)
end

function Inventory:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", self.x, self.y, gw - gw/2, self.height)
    love.graphics.setLineWidth(1)

    local i = 0
    for _,item in ipairs(self.items) do
        love.graphics.push()
        love.graphics.translate(self.x + i * (item.w + 10), self.y)
        item:draw()
        i = i + 1
        love.graphics.pop()
    end
end
