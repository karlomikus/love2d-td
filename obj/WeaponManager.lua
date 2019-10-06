WeaponManager = Object:extend()

function WeaponManager:new()
    self.current_wpi = nil
end

function WeaponManager:update(dt)
    -- self.current_wpi = director.current_player:getCurrentItem().weapon_pool_item
end

function WeaponManager:spawn()
end
