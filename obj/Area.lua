Area = Object:extend()

function Area:new(room)
    self.room = room
    self.game_objects = {}

    self.map_image_data = love.image.newImageData("res/map.bmp")
    self.map_image_data:mapPixel(function (x, y, r, g, b, a)
        if r == 0 and b == 0 and g == 1 then
            a = 0
        end

        return r, g, b, a
    end)
    self.map = love.graphics.newImage(self.map_image_data)
end

function Area:update(dt)
    if self.world then
        self.world:update(dt)
    end

    for i = #self.game_objects, 1, -1 do
        local game_object = self.game_objects[i]
        game_object:update(dt)
        if game_object.dead then
            table.remove(self.game_objects, i)
        end
    end

    self.map = love.graphics.newImage(self.map_image_data)
end

function Area:draw()
    love.graphics.draw(self.map)

    for _, game_object in ipairs(self.game_objects) do
        game_object:draw(dt)
    end
end

function Area:addGameObject(game_object_type, x, y, opts)
    local opts = opts or {}
    local game_object = _G[game_object_type](self, x or 0, y or 0, opts)
    table.insert(self.game_objects, game_object)
    return game_object
end

function Area:addPhysicsWorld()
    love.physics.setMeter(32)
    self.world = love.physics.newWorld(0, 9.81 * 32, true)
end

function Area:collided(hx, hy, hw, hh)
    if hx + hw > self.map_image_data:getWidth() or hx < 0 or hy + hh > self.map_image_data:getHeight() or hy < 0 then
        return true
    end

    for cx = hx, hx + hw, 1 do
        for cy = hy, hy + hh, 1 do
            local r,g,b,a = self.map_image_data:getPixel(cx, cy)
            if a ~= 0 then
                return true
            end
        end
    end
end
