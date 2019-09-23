Laser = GameObject:extend()

function Laser:new(x, y, opts)
    Laser.super.new(self, x, y, opts)

    self.range = 100
    self.rot = math.rad(opts.rot)
    self.laser_width = 3
    self.dmg = 100

    -- visual
    self.laser_line_w = 6
    self.laser_line_alpha = 1

    Bresenham.line(math.floor(self.x), math.floor(self.y), math.floor(self.x + self.range * math.cos(self.rot)), math.floor(self.y + self.range * math.sin(self.rot)), function (x, y, counter)
        for _, p in ipairs(director.players) do
            if (x >= p.hitbox.x and x <= p.hitbox.x + p.hitbox.w) and (y >= p.hitbox.y and y <= p.hitbox.y + p.hitbox.h) then
                p.hp = p.hp - self.dmg
                return
            end
        end

        if x >= map.map_image_data:getWidth() or x < 0 or y >= map.map_image_data:getHeight() or y < 0 then
            return false
        end
        local r,g,b,a = map.map_image_data:getPixel(math.floor(x), math.floor(y))
        if a > 0 then
            for i = 0, self.laser_width do
                map.map_image_data:setPixel(x, y + i, 0, 1, 0, 0)
            end
        end
        return true
    end)

    self.timer:tween(0.7, self, {laser_line_w = 0, laser_line_alpha = 0.3}, 'out-expo', function()
        love.event.push('endTurn')
        self.dead = true
    end)
end

function Laser:update(dt)
    Laser.super.update(self, dt)
end

function Laser:draw()
    if math.floor(self.laser_line_w) > 0 then
        love.graphics.setColor(1, 0, 0, self.laser_line_alpha)
        love.graphics.setLineWidth(self.laser_line_w)
        love.graphics.line(self.x, self.y, self.x + self.range * math.cos(self.rot), self.y + self.range * math.sin(self.rot))
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function Laser:destroy()
    Laser.super.destroy(self)
end
