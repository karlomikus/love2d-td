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

function Inventory:giveItem(wp_item)
    -- Check if item already in inventory
    if self:hasItem(wp_item) then
        self:getItem(wp_item):add(1)
    else
        table.insert(self.items, InventoryItem(wp_item, 1))
    end
end
