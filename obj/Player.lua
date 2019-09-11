Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)

    -- self.barrel = Barrel(area, self.x - 5, self.y - 7)
    self.rot = 0
    self.length = 20
    self.caliber = 3
    self.barrel_x = self.x + 20
    self.barrel_y = self.y + 20

    self.body = love.physics.newBody(area.world, self.x, self.y, "dynamic")
    self.shape = love.physics.newRectangleShape(40, 30)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
end

function Player:update(dt)
    Player.super.update(self, dt)

    self.barrel_x = self.body:getX()
    self.barrel_y = self.body:getY()

    if input:down('angle_up') and self.rot > -60 then
        if (input:down('shift')) then
            self.rot = self.rot - 150 * dt
        else
            self.rot = self.rot - 50 * dt
        end
    end

    if input:down('angle_down') and self.rot < 0 then
        if (input:down('shift')) then
            self.rot = self.rot + 150 * dt
        else
            self.rot = self.rot + 20 * dt
        end
    end

    if input:down('tank_forward') then
        self.body:applyForce(400, 0)
    end

    if input:down('tank_backward') then
        self.body:applyForce(-400, 0)
    end
end

function Player:draw()
    love.graphics.setColor(0.4, 0.7, 0.1)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    love.graphics.setColor(1, 1, 1)

    love.graphics.print("Barrel angle: " .. math.floor(self.rot), 10, 10)
    love.graphics.push()
    love.graphics.translate(self.barrel_x, self.barrel_y - self.caliber / 2)
    love.graphics.rotate(math.rad(self.rot))
    love.graphics.rectangle("fill", 0, 0, self.length, self.caliber)
    love.graphics.pop()
end
