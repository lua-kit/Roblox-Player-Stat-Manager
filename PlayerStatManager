-- Made by lua-kit/root_k1t on roblox

local PlayerStatManager = {}
local DataStoreService = game:GetService("DataStoreService")
local playerData = DataStoreService:GetDataStore("PlayerData")
local AUTOSAVE_INTERVAL = 60
local DATASTORE_RETRIES = 3
local sessionData = {}


-- Function to Update the LeaderBoard
local function updateboard(player)
	for i,e in pairs(sessionData[player]) do
		player.leaderstats[i].Value = e
	end
end


function PlayerStatManager:ChangeStat(player, statName, changeValue)
	sessionData[player][statName] = sessionData[player][statName] + changeValue
	updateboard(player)
end

local function dataStoreRetry(dataStoreFunction)
	local tries = 0
	local success = true
	local data = nil
	
	repeat
		tries = tries + 1
		success = pcall(function() data = dataStoreFunction() end)
		if not success then
			wait(1)
		end
	until tries == DATASTORE_RETRIES or success
	
	if not success then
		error("Could not access DataStore! Data might not save!")
	end
	
	return success, data
	
end

-- Function to retrieve player's data from the DataStore
local function getPlayerData(player)
	return dataStoreRetry(function()
		return playerData:GetAsync(player.UserId)
	end)
end

-- Function to save player's data to the DataStore
local function savePlayerData(player)
	if sessionData[player] then
		return dataStoreRetry(function()
			return playerData:SetAsync(player.UserId, sessionData[player])
		end)
	end
end

local function setupPlayerData(player)
	local success, data = getPlayerData(player)
	if not success then
		sessionData[player] = false -- Could not access DataStore, set session data for player to false
	else
		if not data then
			sessionData[player] = {Money = 0, Experience = 0} -- DataStores are working, but no data for this player
			savePlayerData(player)
		else
			sessionData[player] = data -- DataStores are working and we got data for this player
		end
	end
	updateboard(player)
end

-- Function to run in the background to periodically save player's data
local function autosave()
	while wait(AUTOSAVE_INTERVAL) do
		for player, data in pairs(sessionData) do
			savePlayerData(player)
		end
	end
end

-- Bind setupPlayerData to PlayerAdded to call it when player joins
game.Players.PlayerAdded:Connect(setupPlayerData)

-- Call savePlayerData on PlayerRemoving to save player data when they leave
-- Also delete the player from the sessionData, as the player isn't in-game anymore
game.Players.PlayerRemoving:Connect(function(player)
	savePlayerData(player)
	sessionData[player] = nil
end)

-- Start running autosave function in the background
spawn(autosave)

-- Return the PlayerStatManager table to external scripts can access it
return PlayerStatManager
