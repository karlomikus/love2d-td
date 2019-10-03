GameUI = Object:extend()

function GameUI:new(player)
    self.h = 70
    self.x = 0
    self.y = gh - self.h

    self.shop = Shop()

    self.buttons = {}
    self.buttons.shoot_button = Button("Shoot!", self.x + 20, self.y + (self.h - 40) / 2, 120, 40)
    self.buttons.shoot_button:setAccent({123/255, 186/255, 29/255})

    self.buttons.inc_angle = Button("<", self.x + 170, self.y + (self.h - 40) / 2, 40, 40, true, false, true)
    self.buttons.angle_print = Button("0°", self.x + 210, self.y + (self.h - 40) / 2, 60, 40, false)
    self.buttons.dec_angle = Button(">", self.x + 270, self.y + (self.h - 40) / 2, 40, 40, true, false, true)

    self.buttons.dec_power = Button("<", self.x + 330, self.y + (self.h - 40) / 2, 40, 40, true, false, true)
    self.buttons.power_print = Button("0%", self.x + 370, self.y + (self.h - 40) / 2, 60, 40, false)
    self.buttons.inc_power = Button(">", self.x + 430, self.y + (self.h - 40) / 2, 40, 40, true, false, true)

    self.buttons.prev_weapon = Button("<", self.x + 490, self.y + (self.h - 40) / 2, 40, 40, true, false, true)
    self.buttons.curr_weapon = Button("nil", self.x + 530, self.y + (self.h - 40) / 2, 250, 40, false)
    self.buttons.next_weapon = Button(">", self.x + 780, self.y + (self.h - 40) / 2, 40, 40, true, false, true)

    self.buttons.shop = Button("Shop ($0)", self.x + gw - 220, self.y + (self.h - 40) / 2, 200, 40)
    self.buttons.shop:setAccent({252/255, 203/255, 78/255})

    self.buttons.prev_weapon:setAction(function()
        director.current_player:prevWeapon()
    end)

    self.buttons.next_weapon:setAction(function()
        director.current_player:nextWeapon()
    end)

    self.buttons.shoot_button:setAction(function()
        director.current_player:shoot()
    end)

    self.buttons.inc_angle:setAction(function()
        director.current_player:incrementAngleBy(1, 1)
    end)

    self.buttons.dec_angle:setAction(function()
        director.current_player:decrementAngleBy(1, 1)
    end)

    self.buttons.shop:setAction(function()
        sounds.shop_open:stop()
        sounds.shop_close:stop()

        if not self.shop.shown then
            sounds.shop_open:play()
        else
            sounds.shop_close:play()
        end

        self.shop.shown = not self.shop.shown
    end)

    self.buttons.inc_power:setAction(function()
        director.current_player:incrementPowerBy(0.01, 1)
    end)

    self.buttons.dec_power:setAction(function()
        director.current_player:decrementPowerBy(0.01, 1)
    end)
end

function GameUI:update(dt)
    for _,b in pairs(self.buttons) do
        b:update(dt)
    end

    if director.current_player.barrel.angle < 0 then
        self.buttons.angle_print.text:set(string.format("%s°", math.floor(director.current_player.barrel.angle) * -1))
    end

    self.buttons.power_print.text:set(string.format("%s%%", director.current_player.barrel.power * 100))

    self.buttons.shop.text:set(string.format("Shop ($%s)", director.current_player.money))

    if director.current_player:getCurrentItem() then
        self.buttons.curr_weapon.text:set(
            string.format(
                "%s (%s/%s)",
                director.current_player:getCurrentItem().weapon_pool_item.name,
                director.current_player:getCurrentItem().q,
                director.current_player:getCurrentItem().weapon_pool_item.max_per_player
            )
        )
    end

    self.shop:update(dt)
end

function GameUI:draw()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", self.x, self.y, gw, self.h)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setFont(fonts.main_md)
    love.graphics.setColor(252/255, 203/255, 78/255, 1)
    love.graphics.print("Round " .. director.round.count, 10, 10)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Time left: " .. director.round.time_left .. "s", 10, 35)

    for _,b in pairs(self.buttons) do
        b:draw()
    end

    self.shop:draw()
end
