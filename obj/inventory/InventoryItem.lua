InventoryItem = Object:extend()

function InventoryItem:new(obj, name, q, max)
    self.w = 50
    self.h = 50

    self.obj = obj or nil
    self.q = q or 0
    self.max = max or 0
    self.name = name or "undefined"
    self.font = love.graphics.newFont(12)
end

function InventoryItem:update(dt)
end

function InventoryItem:draw()
    love.graphics.setFont(self.font)
    love.graphics.setColor(1, 0, 0, 0.1)
    love.graphics.rectangle("fill", 0, 0, self.w, self.h)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(string.format("%s\n(%s/%s)", self.name, self.q, self.max), 0, 0)
end
