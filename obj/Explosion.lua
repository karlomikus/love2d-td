Explosion = GameObject:extend()

function Explosion:new(area, x, y, opts)
    Explosion.super.new(self, area, x, y, opts)

    self.radius = opts.radius or 20
    self.scorched_earth = 4
end

function Explosion:update(dt)
    Explosion.super.update(self, dt)

    for y = -self.radius, self.radius, 1 do
        for x = -self.radius, self.radius, 1 do
            if x*x+y*y <= self.radius * self.radius then
                if self.x + x < self.area.map_image_data:getWidth() and self.y + y < self.area.map_image_data:getHeight() and self.x + x > 0 and self.y + y > 0 then
                    self.area.map_image_data:setPixel(self.x + x, self.y + y, 0, 1, 0, 0)
                end
            end
        end
    end

    self.radius = self.radius + self.scorched_earth
    for y = -self.radius, self.radius, 1 do
        for x = -self.radius, self.radius, 1 do
            if x*x+y*y <= self.radius * self.radius then
                if self.x + x < self.area.map_image_data:getWidth() and self.y + y < self.area.map_image_data:getHeight() and self.x + x > 0 and self.y + y > 0 then
                    local r, g, b, a = self.area.map_image_data:getPixel(self.x + x, self.y + y)
                    if a > 0 then
                        self.area.map_image_data:setPixel(self.x + x, self.y + y, 1, 0, 0, 1)
                    end
                end
            end
        end
    end

    self.dead = true
end

function Explosion:draw()
end
