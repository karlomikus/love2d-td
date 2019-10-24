GameState = Object:extend()

function GameState:new(total_players)
    -- Init game objs
    camera = camera()
    map = Map()
    director = Director()
    gameUI = GameUI()
    wp = WeaponManager()

    -- Tank colors
    self.colors = {
        COLORS.GREEN,
        COLORS.RED,
        COLORS.BLUE,
        COLORS.YELLOW,
        { hex2rgb("#06dd8b") },
        { hex2rgb("#c60d8c") },
        { hex2rgb("#975ce0") },
        { hex2rgb("#ffffff") },
        { hex2rgb("#648e5b") },
    }

    -- Add players
    for i = 1, total_players do
        director:addPlayer(100 + (i * 100), 0, {color = self.colors[i], name = string.format("Player %s", i)})
    end
    director:startRound()
end

function GameState:update(dt)
    camera:update(dt)
    map:update(dt)
    director:update(dt)
    gameUI:update(dt)
    wp:update(dt)
end

function GameState:draw()
    love.graphics.setBackgroundColor(COLORS["BG"])

    effect(function()
        -- Map bg
        love.graphics.setColor(15/255, 2/255, 43/255)
        love.graphics.rectangle("fill", 0, gh/2 + 100, gw, gh)
        love.graphics.setColor(50/255, 18/255, 114/255)
        love.graphics.rectangle("fill", 0, gh/2 + 100, gw, 5)
        love.graphics.setColor(1, 1, 1)

        map.rain:draw()

        camera:attach()
        map:draw()
        director:draw()
        camera:detach()
        gameUI:draw()
    end)
end
