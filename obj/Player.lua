Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)

    self.gfx = love.graphics.newImage("res/tank.png")
    self.w = 32
    self.h = 32

    local ex_img = love.graphics.newImage("res/explosion.png")
    self.p_system = love.graphics.newParticleSystem(ex_img, 32)
    self.p_system:setParticleLifetime(0.5, 0.5)
    self.p_system:setLinearAcceleration(-100, -100, 100, 100)
    self.p_system:setColors(255, 255, 0, 255, 255, 153, 51, 255, 64, 64, 64, 0)
    self.p_system:setSizes(0.5, 0.5)

    self.hitbox = {}
    self.hitbox.w = 32
    self.hitbox.h = 32
    self.hitbox.x = 0
    self.hitbox.y = 0
    self.hitbox.damping = 3

    self.barrel = {}
    self.barrel.w = 15
    self.barrel.h = 2
    self.barrel.x = self.x
    self.barrel.y = self.y
    self.barrel.angle = 0

    self.speed = 150
    self.gravity = -1000
    self.vy = 0
end

function Player:update(dt)
    Player.super.update(self, dt)
    local oldX, oldY = self.x, self.y

    self.p_system:update(dt)

    self.hitbox.x = self.x
    self.hitbox.y = self.y

    self.barrel.x = self.x + self.w / 2
    self.barrel.y = (self.y + self.h / 2) - 3

    -- Gravity
    if self.area:collided(self.x, self.y + self.hitbox.h, self.hitbox.w, 1) then
        self.y = oldY
        self.vy = 0
    else
        self.y = self.y + (self.vy * dt)
        self.vy = self.vy - (self.gravity * dt)
    end

    -- Move barrel up
    if input:down('up') and self.barrel.angle > -180 then
        if (input:down('shift')) then
            self.barrel.angle = self.barrel.angle - 150 * dt
        else
            self.barrel.angle = self.barrel.angle - 50 * dt
        end
    end

    -- Move barrel down
    if input:down('down') and self.barrel.angle < 0 then
        if (input:down('shift')) then
            self.barrel.angle = self.barrel.angle + 150 * dt
        else
            self.barrel.angle = self.barrel.angle + 20 * dt
        end
    end

    -- Move tank forward
    if input:down('fwd') then
        if not self.area:collided(self.x + self.hitbox.w, self.y, 1, self.hitbox.h - self.hitbox.damping) then
            self.x = self.x + (self.speed * dt)
            if self.area:collided(self.x, self.y + self.hitbox.h - self.hitbox.damping, self.hitbox.w, 1) then
                self.y = self.y - 1
            end
        end
    end

    -- Move tank backward
    if input:down('bwd') then
        if not self.area:collided(self.x - 1, self.y, 1, self.hitbox.h - self.hitbox.damping) then
            self.x = self.x - (self.speed * dt)
            if self.area:collided(self.x, self.y + self.hitbox.h - self.hitbox.damping, self.hitbox.w, 1) then
                self.y = self.y - 1
            end
        end
    end

    -- Shoot chosen weapon
    if input:pressed('shoot') then
        projectile_launch_sound:stop()
        projectile_launch_sound:play()
        local d = 1.2 * self.barrel.w
        self.p_system:emit(32)

        self.area:addGameObject('Projectile', self.barrel.x + d * math.cos(math.rad(self.barrel.angle)), self.barrel.y + d * math.sin(math.rad(self.barrel.angle)), {rot = self.barrel.angle})
    end
end

function Player:draw()
    -- Draw particle effects
    love.graphics.draw(self.p_system, self.barrel.x + 1.2 * self.barrel.w * math.cos(math.rad(self.barrel.angle)), self.barrel.y + 1.2 * self.barrel.w * math.sin(math.rad(self.barrel.angle)))

    love.graphics.setColor(0.4, 0.7, 0.1)
    love.graphics.draw(self.gfx, self.x, self.y)
    love.graphics.setColor(1, 0, 0)
    -- love.graphics.rectangle("line", self.hitbox.x, self.hitbox.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(1, 1, 1)

    love.graphics.print("Barrel angle: " .. math.floor(self.barrel.angle), 10, 10)
    love.graphics.push()
    love.graphics.translate(self.barrel.x, self.barrel.y)
    love.graphics.rotate(math.rad(self.barrel.angle))
    love.graphics.rectangle("fill", 0, 0, self.barrel.w, self.barrel.h)
    love.graphics.pop()
end
