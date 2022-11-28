--X_Z

local DataStore = game:GetService("DataStoreService")

local GlobalWins = DataStore:GetOrderedDataStore("Wins")
local GlobalPrestiges = DataStore:GetOrderedDataStore("Prestiges")

local module = {}

function module:LoadWins()
	
	local Loaded, Msg = false, nil
	
	local Pages
	
	repeat
		
		Loaded, Msg = pcall(function()
			Pages = GlobalWins:GetSortedAsync(false, 50)
		end)
		
		if Loaded then
			
			local CurrentPage = Pages:GetCurrentPage()
			
			game.Workspace.Global_Leaderboards.WinsLeader.SG.Scroller:ClearAllChildren()
			
			for i,v in pairs(CurrentPage) do
				
				local Id = tonumber(v.key)
				
				if Id <= 0 then
					Id = 2
				end
				
				if Id > 0 then
					local PlayerName = game.Players:GetNameFromUserIdAsync(Id)
					local Wins = v.value

					local StatClone = game.ReplicatedStorage.MiscAssets.GlobalTemp:Clone()
					StatClone.Placement.Text = i
					StatClone.User.Text = PlayerName
					StatClone.Stat.Text = Wins
					StatClone.Position = UDim2.new(0,0,.02*(i - 1),0)
					StatClone.Parent = game.Workspace.Global_Leaderboards.WinsLeader.SG.Scroller
				end
				
			end
			
			break
		end
		
		wait(6.1)
	until Loaded
	
end

function module:LoadPrestiges()
	
	local Loaded, Msg = false, nil

	local Pages

	repeat

		Loaded, Msg = pcall(function()
			Pages = GlobalPrestiges:GetSortedAsync(false, 50)
		end)

		if Loaded then

			local CurrentPage = Pages:GetCurrentPage()
			
			game.Workspace.Global_Leaderboards.PrestigeLeader.SG.Scroller:ClearAllChildren()

			for i,v in pairs(CurrentPage) do

				local Id = tonumber(v.key)
				
				if Id <= 0 then
					Id = 2
				end
				
				if Id > 0 then
					local PlayerName = game.Players:GetNameFromUserIdAsync(Id)
					local Prestige = v.value

					local StatClone = game.ReplicatedStorage.MiscAssets.GlobalTemp:Clone()
					StatClone.Placement.Text = i
					StatClone.User.Text = PlayerName
					StatClone.Stat.Text = Prestige
					StatClone.Position = UDim2.new(0,0,.02*(i - 1),0)
					StatClone.Parent = game.Workspace.Global_Leaderboards.PrestigeLeader.SG.Scroller
				end

			end

			break
		end

		wait(6.1)
	until Loaded
	
end

function module:SetWins(PlayerId, Wins)
	
	local Set = false
	local Msg = nil
	
	repeat
		
		Set, Msg = pcall(function()
			GlobalWins:SetAsync(tostring(PlayerId), Wins)
		end)
		
		if Set then
			break
		end
		
		wait(6.1)
	until Set
	
end

function module:SetPrestige(PlayerId, Prestige)
	
	local Set = false
	local Msg = nil

	repeat

		Set, Msg = pcall(function()
			GlobalPrestiges:SetAsync(tostring(PlayerId), Prestige)
		end)

		if Set then
			break
		end

		wait(6.1)
	until Set
	
end

return module