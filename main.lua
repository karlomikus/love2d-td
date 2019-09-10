Object = require "libs/classic"
Circle = require("obj/Circle")
HyperCircle = require("obj/HyperCircle")

function love.load()
    -- local object_files = {}
    -- recursiveEnumerate('obj', object_files)
    -- print(object_files)
    -- requireFiles(object_files)

    -- local exerciseCircle = Test()
    -- exerciseCircle = Circle(400, 300, 50)
    exHyperCircle = HyperCircle(400, 300, 50, 10, 120)
end

function love.update(dt)
end


function love.draw()
    -- exerciseCircle:draw()
    exHyperCircle:draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. "/" .. item
        if love.filesystem.isFile(file) then
            table.insert(file_list, file)
        elseif love.filesystem.isDirectory(file) then
            recursiveEnumerate(file, file_list)
        end
    end
end

function requireFiles(files)
    for _, file in ipairs(files) do
        local file = file.sub(1, -5)
        require(file)
    end
end
