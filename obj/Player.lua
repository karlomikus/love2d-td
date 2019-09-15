Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)

    self.w = 30
    self.h = 10

    self.speed = 250

    self.barrel_rot = 0
    self.barrel_length = 20
    self.barrel_caliber = 3
    self.barrel_x = self.x
    self.barrel_y = self.y
end

function Player:update(dt)
    Player.super.update(self, dt)

    self.barrel_x = self.y
    self.barrel_y = self.y - 5

    if input:down('angle_up') and self.barrel_rot > -60 then
        if (input:down('shift')) then
            self.barrel_rot = self.barrel_rot - 150 * dt
        else
            self.barrel_rot = self.barrel_rot - 50 * dt
        end
    end

    if input:down('angle_down') and self.barrel_rot < 0 then
        if (input:down('shift')) then
            self.barrel_rot = self.barrel_rot + 150 * dt
        else
            self.barrel_rot = self.barrel_rot + 20 * dt
        end
    end

    if input:pressed('shoot') then
        local d = 1.2 * self.barrel_length

        self.area:addGameObject('Projectile', self.barrel_x + d * math.cos(math.rad(self.barrel_rot)), self.barrel_y + d * math.sin(math.rad(self.barrel_rot)), {rot = self.barrel_rot})
    end
end

function Player:draw()
    love.graphics.setColor(0.4, 0.7, 0.1)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    love.graphics.setColor(1, 1, 1)

    love.graphics.print("Barrel angle: " .. math.floor(self.barrel_rot), 10, 10)
    love.graphics.print("Gas: " .. self.gas, 10, 25)
    love.graphics.push()
    love.graphics.translate(self.barrel_x, self.barrel_y - self.barrel_caliber / 2)
    love.graphics.rotate(math.rad(self.barrel_rot))
    love.graphics.rectangle("fill", 0, 0, self.barrel_length, self.barrel_caliber)
    love.graphics.pop()
end
