MainMenuState = Object:extend()

function MainMenuState:new()
    self.total_players = 2

    self.buttons = {}

    self.buttons.new_game = Button("New Game", 50, 120, 220, 40)
    self.buttons.new_game:setAction(function()
        current_state = GameState(self.total_players)
    end)

    self.buttons.dec_players = Button("-", 50, 50, 40, 40)
    self.buttons.dec_players:setAction(function()
        if self.total_players == 2 then
            return
        end
        self.total_players = self.total_players - 1
    end)

    self.buttons.inc_players = Button("+", 230, 50, 40, 40)
    self.buttons.inc_players:setAction(function()
        if self.total_players == 9 then
            return
        end
        self.total_players = self.total_players + 1
    end)

    self.buttons.total_players = Button("Players: 0", 90, 50, 140, 40, false)
end

function MainMenuState:update(dt)
    self.buttons.total_players.text:set(string.format("Players: %s", self.total_players))

    for _,b in pairs(self.buttons) do
        b:update(dt)
    end
end

function MainMenuState:draw()
    love.graphics.setBackgroundColor(COLORS["BG"])
    for _,b in pairs(self.buttons) do
        b:draw()
    end
    love.graphics.print("Middle mouse: Move the camera around", 50, 300)
    love.graphics.print("A/D: Move tank", 50, 320)
    love.graphics.print("W/S: Change barrel angle (Hold shift to move quicker)", 50, 340)
    love.graphics.print("Space: Shoot", 50, 360)
    love.graphics.print("Tab: Switch weapons", 50, 380)
end
