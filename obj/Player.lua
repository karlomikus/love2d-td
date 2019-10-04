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
    self.input:bind('tab', 'change_weapon')

    -- Tank graphics
    self.gfx = love.graphics.newImage("res/tank.png")
    self.w = 32
    self.h = 32
    self.depth = 40

    -- Gameplay stuff
    self.max_hp = 200       -- Health points
    self.hp = self.max_hp   -- Current health points
    self.max_mp = 750       -- Move points
    self.mp = self.max_mp   -- Current move points
    self.speed = 50         -- Move speed
    self.gravity = -1200    -- Tank y gravity
    self.vy = 0             -- Tank y velocity
    if not self.name then
        self.name = self.id
    end
    self.inventory = Inventory(self)
    self.current_item_idx = 1
    self.bar_w = 60
    self.bar_h = 3
    self.money = 2000

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
    self.barrel.power = 0.5
    self.barrel.max_angle = 180
    self.barrel.min_angle = 0

    -- Default weapons
    self.inventory:giveItem(weapons_pool[1], 10)
    self.inventory:giveItem(weapons_pool[2], 1)
    self.inventory:giveItem(weapons_pool[3], 2)
end

function Player:update(dt)
    Player.super.update(self, dt)

    local oldX, oldY = self.x, self.y

    self.p_system:update(dt)
    self.inventory:update(dt)

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
    if self.input:down('inc_barrel_angle') then
        if (self.input:down('shift')) then
            self:incrementAngleBy(150, dt)
        else
            self:incrementAngleBy(20, dt)
        end
    end

    -- Move barrel down
    if self.input:down('dec_barrel_angle') then
        if (self.input:down('shift')) then
            self:decrementAngleBy(150, dt)
        else
            self:decrementAngleBy(20, dt)
        end
    end

    -- Move tank forward
    if self.input:down('fwd') and self.mp > 0 then
        if not map:collided(self.x + self.hitbox.w, self.y, 1, self.hitbox.h - self.hitbox.damping) then
            self.mp = math.floor(self.mp - 10 * dt)
            self.x = self.x + (self.speed * dt)
            if map:collided(self.x, self.y + self.hitbox.h - self.hitbox.damping, self.hitbox.w, 1) then
                self.y = self.y - 1
            end
        end
    end

    -- Move tank backward
    if self.input:down('bwd') and self.mp > 0 then
        if not map:collided(self.x - 1, self.y, 1, self.hitbox.h - self.hitbox.damping) then
            self.mp = math.floor(self.mp - 10 * dt)
            self.x = self.x - (self.speed * dt)
            if map:collided(self.x, self.y + self.hitbox.h - self.hitbox.damping, self.hitbox.w, 1) then
                self.y = self.y - 1
            end
        end
    end

    -- Change waeapon
    if self.input:pressed('change_weapon') then
        self:nextWeapon()
    end

    -- Shoot chosen weapon
    if self.input:pressed('shoot') then
        self:shoot()
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
    love.graphics.translate(self.barrel.x, self.barrel.y - 1)
    love.graphics.rotate(math.rad(self.barrel.angle))
    love.graphics.rectangle("fill", 0, self.barrel.h/2*-1, self.barrel.w, self.barrel.h)
    love.graphics.setColor(1, 1, 1)
    love.graphics.pop()

    -- HP
    love.graphics.setColor(1, 1, 1, 0.6)
    love.graphics.setFont(fonts.main_sm)
    love.graphics.print(self.name, self.x - 5, self.y - 30)
    love.graphics.setColor(206/255, 242/255, 0, 0.6)
    love.graphics.rectangle("fill", self.x - 5, self.y - 10, self.bar_w * (self.hp / self.max_hp), self.bar_h)
    love.graphics.rectangle("line", self.x - 6, self.y - 10, self.bar_w, self.bar_h)
    love.graphics.setColor(1, 1, 1, 1)

    -- MP
    love.graphics.setColor(0, 214/255, 242/255, 0.6)
    love.graphics.rectangle("fill", self.x - 5, self.y - 5, self.bar_w * (self.mp / self.max_mp), self.bar_h)
    love.graphics.rectangle("line", self.x - 6, self.y - 5, self.bar_w, self.bar_h)
    love.graphics.setColor(1, 1, 1, 1)
end

function Player:getCurrentItem()
    return self.inventory:get(self.current_item_idx)
end

function Player:incrementAngleBy(angle, dt)
    if self.barrel.angle > self.barrel.max_angle * -1 then
        self.barrel.angle = self.barrel.angle - angle * dt
    end
end

function Player:decrementAngleBy(angle, dt)
    if self.barrel.angle < self.barrel.min_angle then
        self.barrel.angle = self.barrel.angle + angle * dt
    end
end

function Player:shoot()
    self.finished_action = true

    if self:getCurrentItem().q > 0 then
        local d = 1.2 * self.barrel.w
        self.p_system:emit(32)

        map:addGameObject(self:getCurrentItem().weapon_pool_item.obj, self.barrel.x + d * math.cos(math.rad(self.barrel.angle)), self.barrel.y + d * math.sin(math.rad(self.barrel.angle)), {rot = self.barrel.angle})
        self:getCurrentItem().q = self:getCurrentItem().q - 1
    else
        love.event.push('endTurn')
    end
end

function Player:onDamageTaken(dmgSource)
    self.hp = self.hp - dmgSource.dmg

    map:addGameObject('TargetHit', dmgSource.x, dmgSource.y)
    map:addGameObject('FloatingText', string.format("-%s", dmgSource.dmg), dmgSource.x, dmgSource.y)

    sounds.tank_hit:stop()
    sounds.tank_hit:play()
end

function Player:nextWeapon()
    local next_weapon_idx = self.current_item_idx + 1
    if next_weapon_idx > self.inventory:count() then
        next_weapon_idx = 1
    end
    self.current_item_idx = next_weapon_idx
end

function Player:prevWeapon()
    local prev_weapon_idx = self.current_item_idx - 1
    if prev_weapon_idx <= 0 then
        prev_weapon_idx = self.inventory:count()
    end
    self.current_item_idx = prev_weapon_idx
end

function Player:giveMoney(amount)
    self.money = self.money + amount
end

function Player:incrementPowerBy(amount, dt)
    if self.barrel.power <= 1 then
        self.barrel.power = self.barrel.power + amount * dt
    end
end

function Player:decrementPowerBy(amount, dt)
    if self.barrel.power >= 0 then
        self.barrel.power = self.barrel.power - amount * dt
    end
end
