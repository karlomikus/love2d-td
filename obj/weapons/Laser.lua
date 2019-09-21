Laser = GameObject:extend()

function Laser:new(test, x, y, opts)
    Laser.super.new(self, test, x, y, opts)

    self.range = 500
    self.rot = math.rad(opts.rot)

    Bresenham.line(math.floor(self.x), math.floor(self.y), math.floor(self.x + self.range * math.cos(self.rot)), math.floor(self.y + self.range * math.sin(self.rot)), function (x, y, counter)
        if x >= map.map_image_data:getWidth() or x < 0 or y >= map.map_image_data:getHeight() or y < 0 then
            return false
        end
        local r,g,b,a = map.map_image_data:getPixel(math.floor(x), math.floor(y))
        if a > 0 then
            map.map_image_data:setPixel(x, y, 0, 1, 0, 0)
        end
        return true
    end)
end

function Laser:update(dt)
    Laser.super.update(self, dt)

    self.dead = true
end

function Laser:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.line(self.x, self.y, self.x + self.range * math.cos(self.rot), self.y + self.range * math.sin(self.rot))
end

function Laser:destroy()
    Laser.super.destroy(self)
end
