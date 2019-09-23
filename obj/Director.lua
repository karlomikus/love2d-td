Director = Object:extend()

function Director:new()
    self.players = {}
    self.current_player = nil
    self.current_round_seconds = 0
    self.max_round_time = 60

    self.current_player_indicator = {}
    self.current_player_indicator.x = 0
    self.current_player_indicator.y = 0
    self.current_player_indicator.color = {1, 1, 1, 1}

    self.round_timer_handler = global_timer:every(1, function ()
        self.current_round_seconds = self.current_round_seconds + 1
    end, self.max_round_time)
end

function Director:update(dt)
    Timer.update(dt)

    for _, p in ipairs(self.players) do
        if p.has_finished_action then
            self:nextPlayer(p)
        end
        p:update(dt)
    end

    self.current_player_indicator.x = self.current_player.x
    self.current_player_indicator.y = self.current_player.y

    camera:follow(self.current_player.x, self.current_player.y)
end

function Director:draw()
    love.graphics.print("Round timer: " .. self.current_round_seconds .. "s", gw - 300, 10)
    for k,p in ipairs(self.players) do
        p:draw()
    end

    local i = 15
    local t = nil
    for _, player in ipairs(self.players) do
        if player.id == self.current_player.id then
            t = "<-"
        else
            t = ""
        end

        love.graphics.setColor(player.color)
        love.graphics.print(string.format("%s [hp: %s] [mp: %s] %s", player.name, player.hp, player.mp, t), 20, 10 + i)
        love.graphics.setColor(1, 1, 1)
        i = i + 40
    end

    if self.current_player then
        love.graphics.setColor(self.current_player_indicator.color)
        love.graphics.circle("line", self.current_player_indicator.x + self.current_player.w / 2, self.current_player_indicator.y + self.current_player.h / 2, 40)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Director:addPlayer(x, y, opts)
    local player = Player(x, y, opts)

    table.insert(self.players, player)
end

function Director:removePlayer(id)
    local index = 1
    for k,v in pairs(self.players) do
        if v.id == id then
            index = k
        end
    end

    table.remove(self.players, index)

    if self.current_player.id == id then
        self:nextPlayer()
    end
end

function Director:startRound()
    self:nextPlayer(nil)
end

function Director:nextPlayer(shot_player)
    if shot_player then
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
    else
        self.current_player = self.players[1]
    end

    self.current_round_seconds = 0
    Timer.cancel(self.round_timer_handler)
    self.current_player_indicator.color = {1, 1, 1, 1}
    Timer.tween(1, self.current_player_indicator, {color = {1, 1, 1, 0}}, 'in-out-quad')
end
