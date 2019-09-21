Map = Object:extend()

function Map:new()
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

function Map:update(dt)
    self.map = love.graphics.newImage(self.map_image_data)
end

function Map:draw()
    love.graphics.draw(self.map)
end

function Map:collided(hx, hy, hw, hh)
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
