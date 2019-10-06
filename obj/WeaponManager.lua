WeaponManager = Object:extend()

function WeaponManager:new()
    self.current_wpi = nil
    self.grace = 2
end

function WeaponManager:update(dt)
    self.current_wpi = director.current_player:getCurrentItem().weapon_pool_item
    if director.current_player.state == "waiting" then
        -- self.current_wpi
    end
end

function WeaponManager:spawn()
end
