Explosion = GameObject:extend()

function Explosion:new(x, y, opts)
    Explosion.super.new(self, x, y, opts)

    self.radius = opts.radius or 33
    self.scorched_earth = self.radius + 5

    local g = anim8.newGrid(33, 33, texture.explosion:getWidth(), texture.explosion:getHeight())
    self.animation = anim8.newAnimation(g('1-7',1), 0.03)

    self.timer:after(0.03 * 7, function ()
        love.event.push('endTurn')
        self.dead = true
    end)

    camera:shake(5, 0.3, 60)

    for i = 1, love.math.random(4, 8) do
        map:addGameObject('MapDebris', self.x, self.y)
    end
end

function Explosion:update(dt)
    Explosion.super.update(self, dt)

    self.animation:update(dt)

    for y = -self.radius, self.radius, 1 do
        for x = -self.radius, self.radius, 1 do
            if x*x+y*y <= self.radius * self.radius then
                if self.x + x < map.map_image_data:getWidth() and self.y + y < map.map_image_data:getHeight() and self.x + x > 0 and self.y + y > 0 then
                    map.map_image_data:setPixel(self.x + x, self.y + y, 0, 1, 0, 0)
                end
            end
        end
    end

    for y = -self.scorched_earth, self.scorched_earth, 1 do
        for x = -self.scorched_earth, self.scorched_earth, 1 do
            if x*x+y*y <= self.scorched_earth * self.scorched_earth then
                if self.x + x < map.map_image_data:getWidth() and self.y + y < map.map_image_data:getHeight() and self.x + x > 0 and self.y + y > 0 then
                    local r, g, b, a = map.map_image_data:getPixel(self.x + x, self.y + y)
                    if a > 0 then
                        map.map_image_data:setPixel(self.x + x, self.y + y, 247/255, 0, 157/255, 1)
                    end
                end
            end
        end
    end
end

function Explosion:draw()
    self.animation:draw(texture.explosion, self.x + 40, self.y - 20, 2, 2)
end

function Explosion:destroy()
    Explosion.super.destroy(self)
end
