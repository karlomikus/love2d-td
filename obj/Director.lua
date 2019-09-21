Director = Object:extend()

function Director:new()
    self.players = {}
    self.current_player = nil
    self.current_round_timer = 0
    self.current_round_timer_handler = nil
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
    love.graphics.print("Round timer: " .. self.current_round_timer)
    for k,p in ipairs(self.players) do
        p:draw()
    end

    local i = 15
    for _, player in ipairs(self.players) do
        love.graphics.setColor(player.color)
        love.graphics.print("PlayerID: " .. player.id, 20, 10 + i)
        love.graphics.setColor(1, 1, 1)
        i = i + 15
    end

    if self.current_player then
        love.graphics.print("Current player: " .. self.current_player.id, 600, 10)
    end
end

function Director:addPlayer(x, y, color)
    local player = Player(x, y, {color = color})

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

    if self.current_round_timer_handler then
        Timer.cancel(self.current_round_timer_handler)
        director.current_round_timer = 0
    end

    self.current_round_timer_handler = global_timer:every(1, function ()
        director.current_round_timer = director.current_round_timer + 1
    end)
end
