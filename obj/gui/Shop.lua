Shop = Object:extend()

function Shop:new(player)
    self.w = 700
    self.h = 500
    self.x = (gw - self.w) / 2
    self.y = 20

    self.shown = false

    self.items = {}
    for i, item in pairs(weapons_pool) do
        i = i - 1
        local buttonRow = {
            ButtonShop(string.format("%s", item.stock), self.x + 20, 80 + i * 40, 50, 30, false),    -- Quantity
            ButtonShop(item.name, self.x + 70, 80 + i * 40, 360, 30, false),                                 -- Name
            ButtonShop(string.format("$%s", item.price), self.x + 430, 80 + i * 40, 140, 30, false),         -- Price
            Button("Buy", self.x + 600, 80 + i * 40, 60, 30, true, true, true)                               -- Buy button
        }
        buttonRow[#buttonRow]:setAction(function ()
            self:buy(item)
        end)
        table.insert(self.items, buttonRow)
    end
end

function Shop:update(dt)
    if not self.shown then
        return
    end

    for i, item in pairs(weapons_pool) do
        self.items[i][#self.items[i]]:setDisabled(director.current_player.money < item.price)
    end

    for i,r in ipairs(self.items) do
        for _,b in pairs(r) do
            b:update(dt)
        end
    end
end

function Shop:draw()
    if not self.shown then
        return
    end

    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor({247/255, 0, 157/255, 0.2})
    love.graphics.rectangle("line", self.x + 3, self.y + 3, self.w - 5, self.h - 5)
    love.graphics.line(self.x, self.y + 40, self.x + self.w, self.y + 40)
    love.graphics.setColor(COLORS.PINK)

    love.graphics.print("Weapon shop", self.x + 20, 26)

    love.graphics.push()
    for i,r in ipairs(self.items) do
        for _,b in pairs(r) do
            b:draw()
        end
    end
    love.graphics.pop()
end

function Shop:buy(item)
    if director.current_player.money < item.price then
        return false
    end

    local itemGiven = director.current_player.inventory:giveItem(item)
    if itemGiven then
        director.current_player.money = director.current_player.money - item.price
    end
end
