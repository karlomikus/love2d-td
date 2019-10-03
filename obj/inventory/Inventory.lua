Inventory = Object:extend()

function Inventory:new(player)
    self.player = player
    self.height = 50
    self.offset_bottom = 30

    self.x = gw/4
    self.y = gh - self.height - self.offset_bottom

    self.items = {}
end

function Inventory:update(dt)
end

function Inventory:draw()
end

function Inventory:get(pos)
    return self.items[pos]
end

function Inventory:count()
    return #self.items
end

function Inventory:getItem(wp_item)
    for _,item in ipairs(self.items) do
        if item.weapon_pool_item.obj == wp_item.obj then
            return item
        end
    end

    return nil
end

function Inventory:hasItem(wp_item)
    for _,item in ipairs(self.items) do
        if item.weapon_pool_item.obj == wp_item.obj then
            return true
        end
    end

    return false
end

function Inventory:giveItem(wp_item, amount)
    local amount = amount or 1
    -- Check if item already in inventory
    if self:hasItem(wp_item) then
        if self:getItem(wp_item).q >= self:getItem(wp_item).weapon_pool_item.max_per_player then
            return false
        end
        self:getItem(wp_item):add(1)

        return true
    else
        table.insert(self.items, InventoryItem(wp_item, amount))

        return true
    end
end
