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
    print("Starting round")
    -- self.players[1].paused = false
    self.players[1].paused = false
    -- self.current_player.paused = false

    -- self:nextPlayer()
end

function Director:getCurrentPlayer()
    for _, p in ipairs(self.players) do
        if p.paused == false then
            return p
        end
    end

    return nil
end

function Director:nextPlayer()
    print("Changing player")

    local prev_p_id = self:getCurrentPlayer().id
    self:getCurrentPlayer().paused = true

    local next_index = 1
    for k,v in pairs(self.players) do
        if v.id == prev_p_id then
            next_index = k + 1
        end
    end

    if next_index > #self.players then
        next_index = 1
    end

    self.players[next_index].paused = false
end
