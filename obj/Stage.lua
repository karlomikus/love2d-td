Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.score = 0
    self.player = self.area:addGameObject('Player', 250, 250)
end

function Stage:update(dt)
    self.area:update(dt)
end

function Stage:draw()
    camera:attach()
    self.area:draw()
    camera:detach()
end
