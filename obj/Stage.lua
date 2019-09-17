Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.area:addPhysicsWorld()

    self.director = Director(self)

    self.director:addPlayer(100, 300, {0.4, 0.7, 0.1})
    self.director:addPlayer(900, 300, {0.6, 0.1, 0.2})
    self.director:addPlayer(600, 100, {0.2, 0.5, 0.8})
    -- self.director:addPlayer(700, 100, {0.2, 1, 0.8})

    self.director:startRound()
end

function Stage:update(dt)
    self.area:update(dt)
    self.director:update(dt)
end

function Stage:draw()
    camera:attach()
    self.area:draw()

    local i = 15
    for _, player in ipairs(self.director.players) do
        love.graphics.setColor(player.color)
        love.graphics.print("PlayerID: " .. player.id, 10, 10 + i)
        love.graphics.setColor(1, 1, 1)
        i = i + 15
    end

    if self.director:getCurrentPlayer() then
        love.graphics.print("Current player: " .. self.director:getCurrentPlayer().id, 600, 10)
    end

    camera:detach()
end
