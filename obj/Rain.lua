Rain = GameObject:extend()

function Rain:new(x, y, opts)
    Rain.super.new(self, x, y, opts)

    self.wind = 0.5
    self.max = 200
    self.drops = {}
end

function Rain:update(dt)
    Rain.super.update(self, dt)

    self.timer:after(love.math.random(0.3, 0.8), function()
        if #self.drops <= self.max then
            table.insert(self.drops, {
                x = 0 + love.math.random(1, gw),
                y = 0,
                a = love.math.random(0.3, 0.5),
                vy = love.math.random(400, 700),
                lh = love.math.random(4, 12),
                ld = love.math.random(1, 2)
            })
        end
    end)

    -- Update drops
    for i,d in ipairs(self.drops) do
        d.y = d.y + (d.vy * dt)
        -- d.x = d.x + self.wind

        if d.y > gh then
            table.remove(self.drops, i)
        end
    end
end

function Rain:draw()
    for _,d in pairs(self.drops) do
        love.graphics.setColor(122/255, 103/255, 166/255, d.a)
        love.graphics.line(d.x, d.y, d.x, d.y - d.lh)
        love.graphics.circle("fill", d.x, d.y, d.ld)
    end
    love.graphics.setColor(1, 1, 1, 1)
end
