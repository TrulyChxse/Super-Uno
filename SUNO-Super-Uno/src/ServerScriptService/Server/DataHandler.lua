--X_Z

script.Parent:WaitForChild("Util")

local DataStoreService = game:GetService("DataStoreService")
local PlayerStore = DataStoreService:GetDataStore("PlayerData")
local SessionStore = DataStoreService:GetDataStore("SessionStore")

local module = {}

local DataScope = "Data4_"
local SeesionScope = "Session_"

local Util = require(script.Parent.Util)

function SessionTable()
	
	local Session = {
		SessionId = "None",
		LastUpdate = 0,
	}
	
	return Session
	
end

function DataTable()
	
	local Data = {
		
		Equips = {
			
			Chair = "None",
			Particles = "None",
			
			Decor = {
				Slot1 = "None",
				Slot2 = "None",
				Slot3 = "None",
				Slot4 = "None",
			}
			
		},
		
		Decks = {
			
		},
		
		Chairs = {
			
		},
		
		Particles = {
			
		},
		
		Decor = {
			
		},
		
		GamePasses = {
			
		},
		
		GameStats = {
			Wins = 0,
			GamesPlayed = 0,
		},
		
		LevelData = {
			Level = 1,
			NeedXP = 30,
			CurrXP = 0,
			Prestige = 0
		},
		
		DailyReward = {
			Streak = 0,
			Time = 0,
			Anotha = false
		},
		
		Settings = {
			Trading = true,
			Volume = .5,
		},
		
		RedeemedCodes = {
			
		},
		
		Coins = 500,
		SaveLocked = false,
		VipItems = false,
		
	}
	
	return Data
	
end

function module:CreateFolder(Player)
	local Folder
	local PreExist = game.ReplicatedStorage.PlayerData:FindFirstChild(Player.Name)
	if PreExist then
		Folder = PreExist
	else
		Folder = game.ReplicatedStorage.Templates.DataTemplate:Clone()
		Folder.Name = Player.Name
		Folder.Parent = game.ReplicatedStorage.PlayerData
	end
	return Folder
end

function module:SetSession(Player,Refresh)
	
	warn("Setting session for: " .. Player.Name)
	
	local CanRefresh = true
	
	if Refresh then
		local DataFind = game.ReplicatedStorage.PlayerData:FindFirstChild(Player.Name)
		if DataFind then
			if DataFind.Loaded.Value == false then
				CanRefresh = false
			end
		else
			CanRefresh = false
		end
	end
	
	if CanRefresh == false then
		warn("Could not set session as the first session has not loaded yet: " .. Player.Name)
		return
	end
	
	local SesTeb = SessionTable()
	SesTeb["SessionId"] = game.JobId
	SesTeb["LastUpdate"] = os.time()

	local SessionLoaded = false
	local Msg = nil
	local Retries = 0
	
	repeat
		
		SessionLoaded, Msg = pcall(function()
			SessionStore:SetAsync(SeesionScope .. Player.UserId,SesTeb)
		end)
		
		if SessionLoaded then
			warn("Session successfully set for: " .. Player.Name)
			break
		else
			Retries += 1
			warn("Session could not be set for " .. Player.Name .. " Retrying #" .. Retries)
		end
		
		wait(6.1)
		
	until SessionLoaded
	
	local PlayerFind = game.Players:FindFirstChild(Player.Name)
	if PlayerFind then
		local IntFind = game.ReplicatedStorage.PlayerSessions:FindFirstChild(Player.Name)
		if IntFind == nil then
			local int = Instance.new("IntValue")
			int.Name = Player.Name
			int.Parent = game.ReplicatedStorage.PlayerSessions
		end
	end
	
end

function module:LoadSession(Player)
	
	local IntFind = game.ReplicatedStorage.PlayerSessions:FindFirstChild(Player.Name)
	if IntFind then
		IntFind:Destroy()
	end
	
	local SessionLoaded = false
	local LoadMsg = nil
	
	local SessionData = nil
	
	warn("Loading Session for: " .. Player.Name)
	
	local Retries = 0
	
	repeat
		
		SessionLoaded, LoadMsg = pcall(function()
			SessionData = SessionStore:GetAsync(SeesionScope .. Player.UserId)
		end)
		
		if SessionLoaded then
			
			local NoPriorSession = false
			
			if SessionData == nil or (SessionData["SessionId"] == "None" or os.time() - SessionData["LastUpdate"] >= 90) then
				NoPriorSession = true
				warn("No Prior Session Detected! " .. Player.Name)
				break
			else
				Retries += 1
				SessionLoaded = false
				warn("Prior Session Detected: " .. Player.Name .. " Retrying #" .. Retries)
			end
			
		end
		
		wait(6.1)
	until SessionLoaded
	
	self:SetSession(Player)
	
end

function module:CloseSession(Player)
	
	local IntFind = nil
	IntFind = game.ReplicatedStorage.PlayerSessions:FindFirstChild(Player.Name)
	if IntFind then
		IntFind:Destroy()
	else
		repeat
			IntFind = game.ReplicatedStorage.PlayerSessions:FindFirstChild(Player.Name)
			wait(1)
		until IntFind ~= nil
		
		if IntFind then
			IntFind:Destroy()
		end
	end
	
	local SessionLoaded = false
	local LoadMsg = nil

	local SessionData = nil

	warn("Closing Session for: " .. Player.Name)
	
	local pDete = game.ReplicatedStorage.PlayerData:FindFirstChild(Player.Name)
	if pDete then
		
		if pDete.Saving.Value then
			warn("Waiting for data to finish saving " .. Player.Name)
			repeat
				wait(.5)
			until pDete.Saving.Value == false
		end
		
		pDete.Loaded.Value = false
		
	end

	local Retries = 0
	
	local Teb = SessionTable()
	Teb["SessionId"] = "None"
	Teb["LastUpdate"] = 0
	
	repeat
		
		
		SessionLoaded, LoadMsg = pcall(function()
			SessionStore:SetAsync(SeesionScope .. Player.UserId,Teb)
		end)

		if SessionLoaded then

			warn("Session Cleared: " .. Player.Name)
			break
			
		else
			
			Retries += 1
			warn("Session failed to clear: " .. Player.Name .. " Retrying #" .. Retries)

		end
		

		wait(6.1)
		
	until SessionLoaded
	
	local Data = Util:GetData(Player.Name)
	if Data then
		Data:Destroy()
	end
	
end

function module:ConvertDataToTable(PlayerName,LockAction)
	
	local TblData = DataTable()
	
	local PlayerData = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if PlayerData then
		
		TblData["Coins"] = PlayerData.Coins.Value
		
		TblData["Equips"]["Chair"] = PlayerData.Equips.Chair.Value
		TblData["Equips"]["Particle"] = PlayerData.Equips.Particle.Value
		
		TblData["LevelData"]["Level"] = PlayerData.LevelData.Level.Value
		TblData["LevelData"]["Prestige"] = PlayerData.LevelData.Prestige.Value
		TblData["LevelData"]["CurrXP"] = PlayerData.LevelData.CurrXP.Value
		TblData["LevelData"]["NeedXP"] = PlayerData.LevelData.NeedXP.Value
		
		TblData["VipItems"] = PlayerData.VipItems.Value
		
		if LockAction == "Lock" then
			TblData["SaveLocked"] = true
		else
			TblData["SaveLocked"] = false
		end
		
		for i,v in pairs(PlayerData.Equips.Decorations:GetChildren()) do
			TblData["Equips"]["Decor"][v.Name] = v.Value
		end
		
		for i,v in pairs(PlayerData.RedeemedCodes:GetChildren()) do
			table.insert(TblData["RedeemedCodes"],v.Name)
		end
		
		TblData["Settings"]["Volume"] = PlayerData.Settings.Volume.Value
		TblData["Settings"]["Trading"] = PlayerData.Settings.Trading.Value
		
		for i,v in pairs(PlayerData.Inventory.Decks:GetChildren()) do
			
			local DeckTable = {
				DeckName = v.Name,
				Cards = {}
			}
			
			for a,b in pairs(v:GetChildren()) do
				
				local CardTable = {
					CardName = b.Name,
					Type = b.Type.Value,
					Class = b.Class.Value,
					Color = {
						R = b.Color.Value.R,
						G = b.Color.Value.G,
						B = b.Color.Value.B
					}
				}
				
				table.insert(DeckTable["Cards"],CardTable)
				
			end
			
			table.insert(TblData["Decks"],DeckTable)
			
		end
		
		for i,v in pairs(PlayerData.GamePasses:GetChildren()) do
			if v.Value then
				table.insert(TblData["GamePasses"],v.Name)
			end
		end
		
		for i,v in pairs(PlayerData.Inventory.Decorations:GetChildren()) do
			
			local ItemTable = {
				Copies = 1,
				ItemName = "None",
			}
			
			ItemTable["Copies"] = v.Copies.Value
			ItemTable["ItemName"] = v.Id.Value
			
			table.insert(TblData["Decor"],ItemTable)
			
		end
		
		for i,v in pairs(PlayerData.Inventory.Chairs:GetChildren()) do

			local ItemTable = {
				Copies = 1,
				ItemName = "None",
			}

			ItemTable["Copies"] = v.Copies.Value
			ItemTable["ItemName"] = v.Id.Value

			table.insert(TblData["Chairs"],ItemTable)

		end
		
		for i,v in pairs(PlayerData.Inventory.Particles:GetChildren()) do

			local ItemTable = {
				Copies = 1,
				ItemName = "None",
			}

			ItemTable["Copies"] = v.Copies.Value
			ItemTable["ItemName"] = v.Id.Value

			table.insert(TblData["Particles"],ItemTable)

		end
		
		TblData["DailyReward"]["Time"] = PlayerData.DailyReward.Time.Value
		TblData["DailyReward"]["Streak"] = PlayerData.DailyReward.Streak.Value
		TblData["DailyReward"]["Anotha"] = PlayerData.DailyReward["2ndBuy"].Value
		
		TblData["GameStats"]["Wins"] = PlayerData.Stats.Wins.Value
		TblData["GameStats"]["GamesPlayed"] = PlayerData.Stats.GamesPlayed.Value
		
	end
	
	return TblData
	
end

function module:SaveData(Player,LockAction,LeaveGame)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(Player.Name)
	if Data then
		
		warn("Attempting to save data for user: " .. Player.Name)
		
		if Data.SaveLocked.Value then
			repeat
				warn("Data is currently locked waiting for unlock | " .. Player.Name)
				wait(6)
			until Data.SaveLocked.Value == false
		end
		
		if not Util:InSession(Player.Name) then
			warn("Could not save data for " .. Player.Name .. " as their session isn't set")
			return
		end
		
		if Data.Loaded.Value == false and LockAction == nil then
			warn("Could not save data for " .. Player.Name .. " as their data hasn't been loaded yet")
			return
		end
		
		if Data.Saving.Value then
			if LeaveGame == nil or (LockAction ~= "Lock" and LockAction ~= "UnLock") then
				warn("Could not save data for " .. Player.Name .. " as their data already has an attempt to save it")
			else
				warn("Waiting for data for " .. Player.Name .. " to save so the locking can begin/end")
				repeat
					wait(1)
				until Data.Saving.Value == false
			end
			return
		end
		
		Data.Saving.Value = true
		
		if LockAction == nil and Data.SaveLocked.Value then
			--warn("Could not save data for " .. Player.Name .. " as their data is currently in lock-mode")
			--return
		end
		
		if LockAction == "Lock" then
			Data.SaveLocked.Value = true
			warn("Data saves locked for user: " .. Player.Name)
		end

		local NoFail, Msg = false, nil

		local Retries = 0
		
		repeat
			
			--Retries += 1
			
			local DataTabl = self:ConvertDataToTable(Player.Name,LockAction)
			
			NoFail, Msg = pcall(function()
				PlayerStore:SetAsync(DataScope .. Player.UserId,DataTabl)
			end)
			
			if not NoFail then
				Retries += 1
				warn("Failed to save data for user: " .. Player.Name .. " | Retrying attempt #" .. Retries)
				print(Msg)
			else
				warn("Data successfully saved for user: " .. Player.Name)
				
				Data.Saving.Value = false

				if LockAction == "UnLock" then
					Data.SaveLocked.Value = false
					warn("Data saves unlocked for user: " .. Player.Name)
				end
				
				break
			end
			
			wait(6.1)
			
		until NoFail
		
	end
	
end

function module:LoadData(Player)
	
	local Folder = self:CreateFolder(Player)
	
	self:LoadSession(Player)
	
	local LoadedData = nil
	
	local NoFail = false
	local Msg = nil
	
	local Retries = 0
	
	warn("Loading data for user: " .. Player.Name)
	
	repeat
		NoFail, Msg = pcall(function()
			LoadedData = PlayerStore:GetAsync(DataScope .. Player.UserId)
		end)
		
		if not NoFail then
			Retries += 1
			warn("Failed to load data for user: " .. Player.Name .. " | Retrying attempt #" .. Retries)
		else
			if LoadedData ~= nil then
				if LoadedData["SaveLocked"] == true then
					NoFail = false
					Retries += 1
					warn("Data could not be loaded as the data is save-locked | " .. Player.Name .. " Retrying #" .. Retries)
				else
					warn("Data successfully loaded for user: " .. Player.Name)
					break
				end
			else
				warn("Data successfully loaded for user: " .. Player.Name)
				break
			end
			
		end
		
		wait(6.01)
	until NoFail
	
	if LoadedData == nil then
		warn("No previous data for user: " .. Player.Name .. " | Inserting new data!")
		Folder.Loaded.Value = true
		self:SaveData(Player)
		
		Player:LoadCharacter()
	else
		
		warn("Data found for user: " .. Player.Name .. " | Loading Data!")
		
		Folder.Coins.Value = LoadedData["Coins"]
		
		Folder.Inventory.Decks:ClearAllChildren()
		Folder.Inventory.Decorations:ClearAllChildren()
		Folder.Inventory.Chairs:ClearAllChildren()
		Folder.Inventory.Particles:ClearAllChildren()
		Folder.RedeemedCodes:ClearAllChildren()
		
		Folder.Equips.Chair.Value = LoadedData["Equips"]["Chair"]
		Folder.Equips.Particle.Value = LoadedData["Equips"]["Particle"]
		
		for i,v in pairs(Folder.Equips.Decorations:GetChildren()) do
			v.Value = LoadedData["Equips"]["Decor"][v.Name]
		end
		
		Folder.LevelData.Level.Value = LoadedData["LevelData"]["Level"]
		Folder.LevelData.Prestige.Value = LoadedData["LevelData"]["Prestige"]
		Folder.LevelData.CurrXP.Value = LoadedData["LevelData"]["CurrXP"]
		Folder.LevelData.NeedXP.Value = LoadedData["LevelData"]["NeedXP"]
		
		Folder.DailyReward.Streak.Value = LoadedData["DailyReward"]["Streak"]
		Folder.DailyReward.Time.Value = LoadedData["DailyReward"]["Time"]
		
		if LoadedData["VipItems"] ~= nil then
			Folder.VipItems.Value = LoadedData["VipItems"]
		end
 		
		if LoadedData["DailyReward"]["Anotha"] ~= nil then
			Folder.DailyReward["2ndBuy"].Value = LoadedData["DailyReward"]["Anotha"]
		end
		
		if LoadedData["GameStats"] then
			Folder.Stats.Wins.Value = LoadedData["GameStats"]["Wins"]
			Folder.Stats.GamesPlayed.Value = LoadedData["GameStats"]["GamesPlayed"]
		end
		
		for i,v in pairs(LoadedData["GamePasses"]) do
			local PassFind = Folder.GamePasses:FindFirstChild(v)
			if PassFind then
				PassFind.Value = true
			end
		end
		
		if LoadedData["Settings"] then
			Folder.Settings.Trading.Value = LoadedData["Settings"]["Trading"]
			Folder.Settings.Volume.Value = LoadedData["Settings"]["Volume"]
		end
		
		if LoadedData["RedeemedCodes"] then
			for i,v in pairs(LoadedData["RedeemedCodes"]) do
				local Val = Instance.new("IntValue")
				Val.Name = v
				Val.Parent = Folder.RedeemedCodes
			end
		end
		
		for i,v in pairs(LoadedData["Chairs"]) do
			local ItemClone = game.ReplicatedStorage.Templates.CosmeticTemplate:Clone()
			ItemClone.Id.Value = v["ItemName"]
			
			if ItemClone.Id.Value == "Midget" then
				ItemClone.Id.Value = "Smally"
			end
			
			ItemClone.Copies.Value = v["Copies"]
			ItemClone.Parent = Folder.Inventory.Chairs
		end
		
		for i,v in pairs(LoadedData["Particles"]) do
			local ItemClone = game.ReplicatedStorage.Templates.CosmeticTemplate:Clone()
			ItemClone.Id.Value = v["ItemName"]
			ItemClone.Copies.Value = v["Copies"]
			ItemClone.Parent = Folder.Inventory.Particles
		end
		
		for i,v in pairs(LoadedData["Decor"]) do
			local ItemClone = game.ReplicatedStorage.Templates.CosmeticTemplate:Clone()
			ItemClone.Id.Value = v["ItemName"]
			
			if ItemClone.Id.Value == "Dimaond Lambo" then
				ItemClone.Id.Value = "Diamond Lambo"
			end
			
			ItemClone.Copies.Value = v["Copies"]
			ItemClone.Parent = Folder.Inventory.Decorations
		end
		
		for i,v in pairs(LoadedData["Decks"]) do
			local DeckFolder = Instance.new("Folder")
			DeckFolder.Name = v["DeckName"]
			
			for a,b in pairs(v["Cards"]) do
				local CardTemp = game.ReplicatedStorage.Templates.CardTemplate:Clone()
				CardTemp.Name = b["CardName"]
				CardTemp.Class.Value = b["Class"]
				CardTemp.Color.Value = Color3.new(b["Color"]["R"],b["Color"]["G"],b["Color"]["B"])
				CardTemp.Type.Value = b["Type"]
				CardTemp.Parent = DeckFolder
			end
			
			DeckFolder.Parent = Folder.Inventory.Decks
		end
		
		warn("Data fully loaded for user: " .. Player.Name)
		
		Folder.Loaded.Value = true
		Player:LoadCharacter()
		
	end
	
end

return module