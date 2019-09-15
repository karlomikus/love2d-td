Explosion = GameObject:extend()

function Explosion:new(area, x, y, opts)
    Explosion.super.new(self, area, x, y, opts)

    self.radius = opts.radius or 20
end

function Explosion:update(dt)
    Explosion.super.update(self, dt)

    for y = -self.radius, self.radius, 1 do
        for x = -self.radius, self.radius, 1 do
            if x*x+y*y <= self.radius * self.radius + self.radius then
                self.area.map_image_data:setPixel(self.x + x, self.y + y, 0, 1, 0, 0)
            end
        end
    end

    self.dead = true
end

function Explosion:draw()

end
