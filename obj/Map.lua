Map = Object:extend()

function Map:new()
    local terrain_top_border_height = 8
    local terrain_top_border_color = COLORS.PINK

    -- Init
    love.physics.setMeter(32)
    self.coll_checks = 0
    self.world = love.physics.newWorld(0, 9.81 * 32, true)
    self.game_objects = {}
    self.map_needs_update = false

    -- Camera controls
    self.timer = Timer()
    self.input = Input()
    self.input:bind('mouse3', 'move_camera')
    self.input:bind('wheelup', 'zoom_in')
    self.input:bind('wheeldown', 'zoom_out')

    -- Render map
    self.map_image_data = love.image.newImageData("res/map.bmp")
    self.map_image_data:mapPixel(function (x, y, r, g, b, a)
        if r == 0 and b == 0 and g == 1 then
            a = 0
        else
            r, g, b = 44/255, 0/255, 125/255
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
                    if y + i < self.map_image_data:getHeight() then
                        self.map_image_data:setPixel(x, y + i, unpack(terrain_top_border_color))
                    end
                end
            end
        end
    end

    self.map = love.graphics.newImage(self.map_image_data)

    -- Add rain
    self.rain = Rain(0, 0)
end

function Map:update(dt)
    self.timer:update(dt)
    self.world:update(dt)
    self.rain:update(dt)

    for i = #self.game_objects, 1, -1 do
        local game_object = self.game_objects[i]
        game_object:update(dt)
        if game_object.dead then
            game_object:destroy()
            table.remove(self.game_objects, i)
        end
    end

    -- TODO: Check if needs updating
    if self.map_needs_update then
        self.map = love.graphics.newImage(self.map_image_data)
    end

    if self.input:down('move_camera') then
        local mx, my = camera:getMousePosition(sx, sy, 0, 0, sx*gw, sy*gh)
        local dx, dy = mx - self.previous_mx, my - self.previous_my
        camera:move(-dx, -dy)
        if camera.x <= 0 then
            camera.x = 0
        elseif camera.x >= gw then
            camera.x = gw
        end

        if camera.y >= gh then
            camera.y = gh
        elseif camera.y <= (gh * 2) * -1 then
            camera.y = (gh * 2) * -1
        end
    end

    if self.input:pressed('zoom_in') then
        if camera.scale <= 2 then
            self.timer:tween(0.05, camera, {scale = camera.scale + 0.2}, 'in-out-cubic')
        end
    end

    if self.input:pressed('zoom_out') then
        if camera.scale >= 0.7 then
            self.timer:tween(0.05, camera, {scale = camera.scale - 0.2}, 'in-out-cubic')
        end
    end

    self.previous_mx, self.previous_my = camera:getMousePosition(sx, sy, 0, 0, sx*gw, sy*gh)
end

function Map:draw()

    -- Actual map
    love.graphics.draw(self.map)

    -- Debug
    -- love.graphics.print("Coll checks: " .. self.coll_checks, 10, 30)

    -- Sort map objects by depth
    table.sort(self.game_objects, function(a, b)
        if a.depth == b.depth then return a.creation_time < b.creation_time
        else return a.depth < b.depth end
    end)

    -- Draw map objects
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

function Map:collided(hx, hy, hw, hh, check_bounds)
    local check_bounds = check_bounds or false

    if check_bounds then
        -- Check bottom
        if hy + hh >= self.map_image_data:getHeight() then
            return true
        end
        -- Check top, and sides
        if hx + hw > self.map_image_data:getWidth() or hx < 0 or hy < 0 then
            return false
        end
    else
        if hx + hw > self.map_image_data:getWidth() or hx < 0 or hy + hh > self.map_image_data:getHeight() or hy < 0 then
            return true
        end
    end

    self.coll_checks = self.coll_checks + 1

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
