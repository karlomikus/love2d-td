Director = Object:extend()

function Director:new()
    -- Player data
    self.players = {}
    self.current_player = nil

    -- Round options
    self.timer = Timer()
    self.round = {}
    self.round.count = 1
    self.round.time_max = 60
    self.round.time_left = self.round.time_max

    -- Player indicator, TODO: Move to player/new class
    self.current_player_indicator = {}
    self.current_player_indicator.x = 0
    self.current_player_indicator.y = 0
    self.current_player_indicator.color = {1, 1, 1, 1}

    -- Round timer
    self.round_timer_handler = self.timer:every(1, function ()
        self.round.time_left = self.round.time_left - 1
    end)
end

function Director:update(dt)
    self.timer:update(dt)

    for _, p in ipairs(self.players) do
        p:update(dt)
    end

    self.current_player_indicator.x = self.current_player.x
    self.current_player_indicator.y = self.current_player.y
end

function Director:draw()
    for k,p in ipairs(self.players) do
        p:draw()
    end

    if self.current_player then
        love.graphics.setColor(self.current_player_indicator.color)
        love.graphics.circle("line", self.current_player_indicator.x + self.current_player.w / 2, self.current_player_indicator.y + self.current_player.h / 2, 40)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Director:addPlayer(x, y, opts)
    -- Find first safe spawn point
    for py = gh - 1, 0, -1 do
        local terrain_safe = false
        for px = x, x + 32 do
            local r,g,b,a = map:getPixel(px, py)
            if a == 0 then
                terrain_safe = true
            else
                terrain_safe = false
            end
        end

        if terrain_safe then
            y = py - 33
            break
        end
    end

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
        -- Reset current player
        shot_player.finished_action = false

        -- Find index of current player in table
        local next_index = 1
        for k,v in pairs(self.players) do
            if v.id == shot_player.id then
                next_index = k + 1
            end
        end

        -- Then increment that index, handling overflow, to get next player
        if next_index > #self.players then
            next_index = 1
            self.round.count = self.round.count + 1
            self:roundReward()
        end

        self.current_player = self.players[next_index]
    else
        self.current_player = self.players[1]
    end

    self.current_player:focus()

    -- Reset round timer
    self.round.time_left = self.round.time_max
    -- self.timer:cancel(self.round_timer_handler)

    -- Show current player indicator
    self.current_player_indicator.color = {1, 1, 1, 1}
    self.timer:tween(1, self.current_player_indicator, {color = {1, 1, 1, 0}}, 'in-out-quad')
end

function Director:roundReward()
    for _, p in ipairs(self.players) do
        p:giveMoney(250)
    end
end

function love.handlers.endTurn()
    director:nextPlayer(director.current_player)
end
