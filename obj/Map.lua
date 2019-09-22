Map = Object:extend()

function Map:new()
    local terrain_top_border_height = 8
    local terrain_top_border_color = COLORS["ELECTRO_GREEN"]

    self:addPhysicsWorld()
    self.game_objects = {}
    self.map_image_data = love.image.newImageData("res/map.bmp")
    self.map_image_data:mapPixel(function (x, y, r, g, b, a)
        if r == 0 and b == 0 and g == 1 then
            a = 0
        else
            r, g, b = unpack(COLORS["SLATE_LIGHT"])
        end

        return r, g, b, a
    end)

    -- Add top border
    for x = 1, self.map_image_data:getWidth() do
        for y = 1, self.map_image_data:getHeight() do
            local r,g,b,a = self:getPixel(x, y)
            local rb,gb,bb,ab = self:getPixel(x, y + 1)
            if a == 0 and ab == 1 then
                for i = 1, terrain_top_border_height do
                    self.map_image_data:setPixel(x, y + i, unpack(terrain_top_border_color))
                end
            end
        end
    end

    self.map = love.graphics.newImage(self.map_image_data)
end

function Map:update(dt)
    if self.world then
        self.world:update(dt)
    end

    for i = #self.game_objects, 1, -1 do
        local game_object = self.game_objects[i]
        game_object:update(dt)
        if game_object.dead then
            game_object:destroy()
            table.remove(self.game_objects, i)
        end
    end

    self.map = love.graphics.newImage(self.map_image_data)
end

function Map:draw()
    -- sun
    -- love.graphics.setColor(unpack(COLORS["YELLOW"]))
    -- love.graphics.circle("fill", gw/2, gh/2, 200)
    -- love.graphics.setColor(1, 1, 1)

    love.graphics.setColor(15/255, 2/255, 43/255)
    love.graphics.rectangle("fill", 0, gh/2 + 100, gw, gh)
    love.graphics.setColor(50/255, 18/255, 114/255)
    love.graphics.rectangle("fill", 0, gh/2 + 100, gw, 5)
    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(self.map)

    for _, game_object in ipairs(self.game_objects) do
        game_object:draw(dt)
    end
end

function Map:addGameObject(game_object_type, x, y, opts)
    local opts = opts or {}
    local game_object = _G[game_object_type](x or 0, y or 0, opts)
    table.insert(self.game_objects, game_object)
    return game_object
end

function Map:addPhysicsWorld()
    love.physics.setMeter(32)
    self.world = love.physics.newWorld(0, 9.81 * 32, true)
end

function Map:collided(hx, hy, hw, hh)
    -- Check top, and sides

    -- Check bottom
    if hx + hw > self.map_image_data:getWidth() or hx < 0 or hy + hh > self.map_image_data:getHeight() or hy < 0 then
        return true
    end

    for cx = hx, hx + hw, 1 do
        for cy = hy, hy + hh, 1 do
            local r,g,b,a = self.map_image_data:getPixel(math.floor(cx), math.floor(cy))
            if a ~= 0 then
                return true
            end
        end
    end
end

function Map:getPixel(x, y)
    if x >= self.map_image_data:getWidth() or x <= 0 or y >= self.map_image_data:getHeight() or y <= 0 then
        return 0, 0, 0, 0
    end

    return self.map_image_data:getPixel(math.floor(x), math.floor(y))
end
