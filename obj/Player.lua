Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)

    self.gfx = love.graphics.newImage("res/tank.png")

    local ex_img = love.graphics.newImage("res/explosion.png")
    self.p_system = love.graphics.newParticleSystem(ex_img, 32)
    self.p_system:setParticleLifetime(0.5, 0.5)
    self.p_system:setLinearAcceleration(-100, -100, 100, 100)
    self.p_system:setColors(255, 255, 0, 255, 255, 153, 51, 255, 64, 64, 64, 0)
    self.p_system:setSizes(0.5, 0.5)

    self.w = 30
    self.h = 10
    self.pixel_damping = 3

    self.hitbox = {}
    self.hitbox.w = 30
    self.hitbox.h = 20
    self.hitbox.x = 0
    self.hitbox.y = 0

    self.speed = 150
    self.gravity = -1000
    self.vy = 0

    self.p_angle = 0
    self.barrel_length = 15
    self.barrel_caliber = 2
    self.barrel_x = self.x
    self.barrel_y = self.y
end

function Player:update(dt)
    Player.super.update(self, dt)
    local oldX, oldY = self.x, self.y

    self.p_system:update(dt)

    -- Gravity
    if self.area:collided(self.x, self.y + self.h, self.w, 1) then
        self.y = oldY
        self.vy = 0
    else
        self.y = self.y + (self.vy * dt)
        self.vy = self.vy - (self.gravity * dt)
    end

    if input:down('up') and self.p_angle > -180 then
        if (input:down('shift')) then
            self.p_angle = self.p_angle - 150 * dt
        else
            self.p_angle = self.p_angle - 50 * dt
        end
    end

    if input:down('down') and self.p_angle < 0 then
        if (input:down('shift')) then
            self.p_angle = self.p_angle + 150 * dt
        else
            self.p_angle = self.p_angle + 20 * dt
        end
    end

    if input:down('fwd') then
        if not self.area:collided(self.x + self.w, self.y, 1, self.h - self.pixel_damping) then
            self.x = self.x + (self.speed * dt)
            if self.area:collided(self.x, self.y + self.h - self.pixel_damping, self.w, 1) then
                self.y = self.y - 1
            end
        end
    end

    if input:down('bwd') then
        if not self.area:collided(self.x - 1, self.y, 1, self.h - self.pixel_damping) then
            self.x = self.x - (self.speed * dt)
            if self.area:collided(self.x, self.y + self.h - self.pixel_damping, self.w, 1) then
                self.y = self.y - 1
            end
        end
    end

    self.barrel_x = self.x + self.w / 2
    self.barrel_y = self.y - 5

    if input:pressed('shoot') then
        projectile_launch_sound:stop()
        projectile_launch_sound:play()
        local d = 1.2 * self.barrel_length
        self.p_system:emit(32)

        -- self.area:addGameObject('Projectile', self.barrel_x + d * math.cos(math.rad(self.p_angle - 15)), self.barrel_y + d * math.sin(math.rad(self.p_angle - 15)), {rot = self.p_angle - 15})
        self.area:addGameObject('Projectile', self.barrel_x + d * math.cos(math.rad(self.p_angle)), self.barrel_y + d * math.sin(math.rad(self.p_angle)), {rot = self.p_angle})
        -- self.area:addGameObject('Projectile', self.barrel_x + d * math.cos(math.rad(self.p_angle + 15)), self.barrel_y + d * math.sin(math.rad(self.p_angle + 15)), {rot = self.p_angle + 15})
    end
end

function Player:draw()
    love.graphics.draw(self.p_system, self.barrel_x + 1.2 * self.barrel_length * math.cos(math.rad(self.p_angle)), self.barrel_y + 1.2 * self.barrel_length * math.sin(math.rad(self.p_angle)))

    love.graphics.setColor(0.4, 0.7, 0.1)
    love.graphics.draw(self.gfx, self.x, self.y - 20)
    love.graphics.setColor(1, 0, 0)
    -- love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1)

    love.graphics.print("Barrel angle: " .. math.floor(self.p_angle), 10, 10)
    love.graphics.push()
    love.graphics.translate(self.barrel_x, self.barrel_y)
    love.graphics.rotate(math.rad(self.p_angle))
    love.graphics.rectangle("fill", 0, 0, self.barrel_length, self.barrel_caliber)
    love.graphics.pop()
end
