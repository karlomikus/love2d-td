InventoryItem = Object:extend()

function InventoryItem:new(weapon_pool_item, init_q)
    self.w = 50
    self.h = 50

    self.q = init_q or 0
    self.weapon_pool_item = weapon_pool_item
end

function InventoryItem:add(amount)
    self.q = self.q + amount
end
