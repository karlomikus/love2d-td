Grenade = GameObject:extend()

function Grenade:new(x, y, opts)
    Grenade.super.new(self, x, y, opts)

    self.max_velocity = 400
    self.velocity = self.max_velocity * director.current_player.barrel.power
    self.dmg = 100
    self.rot = math.rad(opts.rot)

    self.timer:after(2, function()
        sounds.rocket_fly:stop()
        map:addGameObject('Explosion', self.x, self.y, {dmg = self.dmg})
        self.dead = true
        love.event.push('endTurn')
    end)
end

function Grenade:update(dt)
    Grenade.super.update(self, dt)
end

function Grenade:draw()
    love.graphics.circle("fill", self.x, self.y, 2.5)
end

function Grenade:destroy()
    Grenade.super.destroy(self)
end
