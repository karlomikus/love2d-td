Inventory = Object:extend()

function Inventory:new()
    self.height = 50
    self.offset_bottom = 30

    self.x = gw/4
    self.y = gh - self.height - self.offset_bottom

    self.weapons = {}
    table.insert(self.weapons, {
        name = "Rocket Launcher",
        class = "Rocket"
    })
    table.insert(self.weapons, {
        name = "Laser",
        class = "Laser"
    })
end

function Inventory:update(dt)
end

function Inventory:draw()
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle("fill", self.x, self.y, gw - gw/2, self.height)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", self.x, self.y, gw - gw/2, self.height)
    love.graphics.setLineWidth(1)
end
