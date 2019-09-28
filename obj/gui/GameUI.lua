GameUI = Object:extend()

function GameUI:new(player)
    self.h = 100
    self.x = 0
    self.y = gh - self.h

    self.buttons = {}
    self.buttons.shoot_button = Button("Shoot!", self.x + 40, self.y + (self.h - 40) / 2, 120, 40)

    self.buttons.inc_angle = Button("<", self.x + 200, self.y + (self.h - 40) / 2, 40, 40)
    self.buttons.angle_print = Button("0°", self.x + 240, self.y + (self.h - 40) / 2, 60, 40)
    self.buttons.dec_angle = Button(">", self.x + 300, self.y + (self.h - 40) / 2, 40, 40)

    self.buttons.prev_weapon = Button("<", self.x + 380, self.y + (self.h - 40) / 2, 40, 40)
    self.buttons.curr_weapon = Button("nil", self.x + 420, self.y + (self.h - 40) / 2, 250, 40)
    self.buttons.next_weapon = Button(">", self.x + 670, self.y + (self.h - 40) / 2, 40, 40)

    self.buttons.shop = Button("Buy ($0)", self.x + 750, self.y + (self.h - 40) / 2, 250, 40)
end

function GameUI:update(dt)
    if director.current_player.barrel.angle < 0 then
        self.buttons.angle_print.text:set(string.format("%s°", math.floor(director.current_player.barrel.angle) * -1))
    end

    self.buttons.shop.text:set(string.format("Buy ($%s)", 3200))

    if director.current_player:getCurrentItem() then
        self.buttons.curr_weapon.text:set(
            string.format(
                "%s (%s/%s)",
                director.current_player:getCurrentItem().name,
                director.current_player:getCurrentItem().q,
                director.current_player:getCurrentItem().max
            )
        )
    end
end

function GameUI:draw()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", self.x, self.y, gw, self.h)
    love.graphics.setColor(1, 1, 1, 1)

    for _,b in pairs(self.buttons) do
        b:draw()
    end
end
