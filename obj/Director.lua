Director = Object:extend()

function Director:new()
    self.players = {}
    self.current_player = nil
end

function Director:update(dt)
    for _, p in ipairs(self.players) do
        if p.has_finished_action then
            self:nextPlayer(p)
        end
        p:update(dt)
    end
end

function Director:draw()
    for k,p in ipairs(self.players) do
        p:draw()
    end
end

function Director:addPlayer(x, y, color)
    local player = Player(nil, x, y, {color = color})

    table.insert(self.players, player)
end

function Director:startRound()
    self.current_player = self.players[1]
end

function Director:nextPlayer(shot_player)
    shot_player.has_finished_action = false

    local prev_p_id = shot_player.id

    local next_index = 1
    for k,v in pairs(self.players) do
        if v.id == prev_p_id then
            next_index = k + 1
        end
    end

    if next_index > #self.players then
        next_index = 1
    end

    self.current_player = self.players[next_index]
end
