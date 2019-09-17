Director = Object:extend()

function Director:new(stage)
    self.stage = stage

    self.players = {}
end

function Director:update(dt)
end

function Director:addPlayer(x, y, color)
    local player = self.stage.area:addGameObject('Player', x, y, {color = color})

    table.insert(self.players, player)
end

function Director:startRound()
    self.players[1].paused = false
end
