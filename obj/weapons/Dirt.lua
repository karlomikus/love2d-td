Dirt = GameObject:extend()

function Dirt:new(x, y, opts)
    Dirt.super.new(self, x, y, opts)

    sounds.dirt:stop()
    sounds.dirt:play()

    self.radius_max = 40
    self.radius = 0
    self.dirt_pos = {}

    map.map_needs_update = true
end

function Dirt:update(dt)
    Dirt.super.update(self, dt)

    for y = -self.radius, self.radius, 1 do
        for x = -self.radius, self.radius, 1 do
            if x*x+y*y <= self.radius * self.radius then
                local _, _, _, ca = map.map_image_data:getPixel(self.x + x, self.y + y)
                if self.x + x < map.map_image_data:getWidth() and self.y + y < map.map_image_data:getHeight() and self.x + x > 0 and self.y + y > 0 and ca == 0 then
                    map.map_image_data:setPixel(math.floor(self.x + x), math.floor(self.y + y), 171/255, 74/255, 0, 1)
                    -- table.insert(self.dirt_pos, {x = math.floor(self.x + x), y = math.floor(self.y + y)})
                end
            end
        end
    end

    if self.radius < self.radius_max then
        self.radius = self.radius + 1
    end

    if self.radius == self.radius_max then
        map.map_needs_update = false
        sounds.dirt:stop()
        self.dead = true
    end
end

function Dirt:draw()
end

function Dirt:destroy()
    Dirt.super.destroy(self)
end
