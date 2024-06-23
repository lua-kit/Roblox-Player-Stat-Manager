local function addLeaderboard(player)
	local board = Instance.new("Model", player)
	board.Name = "leaderstats"
	
	local money = Instance.new("IntValue", board)
	money.Name = "Money"
	money.Value = 0
	
	local xp = Instance.new("IntValue", board)
	xp.Name = "Experience"
	xp.Value = 0
end

game.Players.PlayerAdded:Connect(addLeaderboard)
