Player = GameObject:extend()

function Player:new(director, x, y, opts)
    Player.super.new(self, director, x, y, opts)

    self.input = Input()
    self.input:bind('w', 'up')
    self.input:bind('s', 'down')
    self.input:bind('d', 'fwd')
    self.input:bind('a', 'bwd')
    self.input:bind('lshift', 'shift')
    self.input:bind('space', 'shoot')

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

    self.has_finished_action = false
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
    if map:collided(self.x, self.y + self.hitbox.h, self.hitbox.w, 1) then
        self.y = oldY
        self.vy = 0
    else
        self.y = self.y + (self.vy * dt)
        self.vy = self.vy - (self.gravity * dt)
    end

    if director.current_player.id ~= self.id then
        return
    end

    -- Move barrel up
    if self.input:down('up') and self.barrel.angle > -180 then
        if (self.input:down('shift')) then
            self.barrel.angle = self.barrel.angle - 150 * dt
        else
            self.barrel.angle = self.barrel.angle - 50 * dt
        end
    end

    -- Move barrel down
    if self.input:down('down') and self.barrel.angle < 0 then
        if (self.input:down('shift')) then
            self.barrel.angle = self.barrel.angle + 150 * dt
        else
            self.barrel.angle = self.barrel.angle + 20 * dt
        end
    end

    -- Move tank forward
    if self.input:down('fwd') then
        if not map:collided(self.x + self.hitbox.w, self.y, 1, self.hitbox.h - self.hitbox.damping) then
            self.x = self.x + (self.speed * dt)
            if map:collided(self.x, self.y + self.hitbox.h - self.hitbox.damping, self.hitbox.w, 1) then
                self.y = self.y - 1
            end
        end
    end

    -- Move tank backward
    if self.input:down('bwd') then
        if not map:collided(self.x - 1, self.y, 1, self.hitbox.h - self.hitbox.damping) then
            self.x = self.x - (self.speed * dt)
            if map:collided(self.x, self.y + self.hitbox.h - self.hitbox.damping, self.hitbox.w, 1) then
                self.y = self.y - 1
            end
        end
    end

    -- Shoot chosen weapon
    if self.input:pressed('shoot') and director.current_player.id == self.id then
        print("shot by: " .. self.id)
        self.has_finished_action = true
        projectile_launch_sound:stop()
        projectile_launch_sound:play()
        local d = 1.2 * self.barrel.w
        self.p_system:emit(32)

        map:addGameObject('Rocket', self.barrel.x + d * math.cos(math.rad(self.barrel.angle)), self.barrel.y + d * math.sin(math.rad(self.barrel.angle)), {rot = self.barrel.angle})
    end

end

function Player:draw()
    -- Draw particle effects
    love.graphics.draw(self.p_system, self.barrel.x + 1.2 * self.barrel.w * math.cos(math.rad(self.barrel.angle)), self.barrel.y + 1.2 * self.barrel.w * math.sin(math.rad(self.barrel.angle)))

    -- Tank
    love.graphics.setColor(self.color)
    love.graphics.draw(self.gfx, self.x, self.y)

    -- Tank barrel
    love.graphics.push()
    love.graphics.translate(self.barrel.x, self.barrel.y)
    love.graphics.rotate(math.rad(self.barrel.angle))
    love.graphics.rectangle("fill", 0, 0, self.barrel.w, self.barrel.h)
    love.graphics.pop()
end
