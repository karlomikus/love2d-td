GameObject = Object:extend()

function GameObject:new(director, x, y, opts)
    local opts = opts or {}
    if opts then
        for k,v in pairs(opts) do
            self[k] = v
        end
    end

    self.director = director
    self.x = x
    self.y = y
    self.id = UUID()
    self.dead = false
    self.paused = true
    self.timer = Timer()
end

function GameObject:update(dt)
    if self.timer then
        self.timer:update(dt)
    end
end

function GameObject:draw()
end

function GameObject:destroy()
end
