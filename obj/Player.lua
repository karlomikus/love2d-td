Player = GameObject:extend()

function Player:new(x, y, opts)
    Player.super.new(self, x, y, opts)

    -- Input handler
    self.input = Input()
    self.input:bind('w', 'inc_barrel_angle')
    self.input:bind('s', 'dec_barrel_angle')
    self.input:bind('d', 'fwd')
    self.input:bind('a', 'bwd')
    self.input:bind('lshift', 'shift')
    self.input:bind('space', 'shoot')

    -- Tank graphics
    self.gfx = love.graphics.newImage("res/tank.png")
    self.w = 32
    self.h = 32

    -- Gameplay stuff
    self.hp = 100           -- Health points
    self.mp = 750           -- Move points
    self.speed = 50         -- Move speed
    self.gravity = -1200    -- Tank y gravity
    self.vy = 0             -- Tank y velocity
    if not self.name then
        self.name = self.id
    end

    -- Turn handling
    self.finished_action = false    -- Has player executed attack
    self.controls_paused = false    -- Does player have control of tank

    -- Particles
    self.p_system = love.graphics.newParticleSystem(love.graphics.newImage("res/explosion.png"), 32)
    self.p_system:setParticleLifetime(0.5, 0.5)
    self.p_system:setLinearAcceleration(-100, -100, 100, 100)
    self.p_system:setColors(255, 255, 0, 255, 255, 153, 51, 255, 64, 64, 64, 0)
    self.p_system:setSizes(0.5, 0.5)

    -- Hitbox
    self.hitbox = {}
    self.hitbox.w = 32
    self.hitbox.h = 32
    self.hitbox.x = 0
    self.hitbox.y = 0
    self.hitbox.damping = 3 -- Y Axis damping when moving on slopes

    -- Barrel positioning
    self.barrel = {}
    self.barrel.w = 15
    self.barrel.h = 2
    self.barrel.x = self.x
    self.barrel.y = self.y
    self.barrel.angle = 0
end

function Player:update(dt)
    Player.super.update(self, dt)

    local oldX, oldY = self.x, self.y

    self.p_system:update(dt)

    if self.hp <= 0 then
        director:removePlayer(self.id)
    end

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

    if self.finished_action then
        return
    end

    -- Move barrel up
    if self.input:down('inc_barrel_angle') and self.barrel.angle > -180 then
        if (self.input:down('shift')) then
            self.barrel.angle = self.barrel.angle - 150 * dt
        else
            self.barrel.angle = self.barrel.angle - 50 * dt
        end
    end

    -- Move barrel down
    if self.input:down('dec_barrel_angle') and self.barrel.angle < 0 then
        if (self.input:down('shift')) then
            self.barrel.angle = self.barrel.angle + 150 * dt
        else
            self.barrel.angle = self.barrel.angle + 20 * dt
        end
    end

    -- Move tank forward
    if self.input:down('fwd') and self.mp > 0 then
        self.mp = math.floor(self.mp - 10 * dt)
        if not map:collided(self.x + self.hitbox.w, self.y, 1, self.hitbox.h - self.hitbox.damping) then
            self.x = self.x + (self.speed * dt)
            if map:collided(self.x, self.y + self.hitbox.h - self.hitbox.damping, self.hitbox.w, 1) then
                self.y = self.y - 1
            end
        end
    end

    -- Move tank backward
    if self.input:down('bwd') and self.mp > 0 then
        self.mp = math.floor(self.mp - 10 * dt)
        if not map:collided(self.x - 1, self.y, 1, self.hitbox.h - self.hitbox.damping) then
            self.x = self.x - (self.speed * dt)
            if map:collided(self.x, self.y + self.hitbox.h - self.hitbox.damping, self.hitbox.w, 1) then
                self.y = self.y - 1
            end
        end
    end

    -- Shoot chosen weapon
    if self.input:pressed('shoot') and director.current_player.id == self.id then
        self.finished_action = true
        projectile_launch_sound:stop()
        projectile_launch_sound:play()
        local d = 1.2 * self.barrel.w
        self.p_system:emit(32)

        map:addGameObject('Rocket', self.barrel.x + d * math.cos(math.rad(self.barrel.angle)), self.barrel.y + d * math.sin(math.rad(self.barrel.angle)), {rot = self.barrel.angle})
        -- map:addGameObject('Laser', self.barrel.x + d * math.cos(math.rad(self.barrel.angle)), self.barrel.y + d * math.sin(math.rad(self.barrel.angle)), {rot = self.barrel.angle})
    end

end

function Player:draw()
    -- Draw particle effects
    love.graphics.draw(self.p_system, self.barrel.x + 1.2 * self.barrel.w * math.cos(math.rad(self.barrel.angle)), self.barrel.y + 1.2 * self.barrel.w * math.sin(math.rad(self.barrel.angle)))

    -- Tank
    love.graphics.setColor(self.color)
    love.graphics.draw(self.gfx, self.x, self.y)
    love.graphics.setColor(1, 1, 1)

    -- Tank barrel
    love.graphics.push()
    love.graphics.setColor(self.color)
    love.graphics.translate(self.barrel.x, self.barrel.y)
    love.graphics.rotate(math.rad(self.barrel.angle))
    love.graphics.rectangle("fill", 0, 0, self.barrel.w, self.barrel.h)
    love.graphics.setColor(1, 1, 1)
    love.graphics.pop()
end
