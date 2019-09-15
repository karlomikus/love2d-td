Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.area:addPhysicsWorld()

    self.player = self.area:addGameObject('Player', 100, 300)
    -- self.enemy = self.area:addGameObject('Enemy', 450, 50)
end

function Stage:update(dt)
    self.area:update(dt)
end

function Stage:draw()
    camera:attach()
    self.area:draw()
    camera:detach()
end
