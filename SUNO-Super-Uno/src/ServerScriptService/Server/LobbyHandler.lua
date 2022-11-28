--X_Z

script.Parent:WaitForChild("GameHandler")
script.Parent:WaitForChild("Util")

local GameHandler = require(script.Parent.GameHandler)
local Util = require(script.Parent.Util)

game.ReplicatedStorage:WaitForChild("Decks")
game.ReplicatedStorage.Decks:WaitForChild("Classic")
game.ReplicatedStorage.Decks:WaitForChild("Super")

local ClassicDeck = require(game.ReplicatedStorage.Decks.Classic)
local SuperDeck = require(game.ReplicatedStorage.Decks.Super)

local TextService = game:GetService("TextService")

local module = {}

module.LobbyCount = 0

function module:LeaveGame(GameLobby,PlayerName)
	
	local GameArena = GameLobby.Arena.Value
	if GameArena then
		
		local PlayerF = GameLobby.Players:FindFirstChild(PlayerName)
		local DummyArena = GameArena:FindFirstChild(PlayerName)
		
		if PlayerF and DummyArena then
			PlayerF.Name = "||." .. PlayerName
			DummyArena.Name = "||." .. PlayerName
			
			if GameLobby.CurrentPlayer.Value == PlayerName then
				GameLobby.CurrentPlayer.Value = "||." .. PlayerName
			end
			
			local PlayerModel = game.Workspace:FindFirstChild(PlayerName)
			if PlayerModel then
				local Root = PlayerModel:FindFirstChild("HumanoidRootPart")
				if Root then
					Root.Anchored = false
				end
				local Humi = PlayerModel:FindFirstChild("Humi")
				if Humi then
					Humi.Name = "Humanoid"
				end
			end
			
			local RealPlayer = game.Players:FindFirstChild(PlayerName)
			if RealPlayer then
				game.ReplicatedStorage.Remotes.QuitLobby:FireClient(RealPlayer)
			end
			
			local GamePlerz = GameHandler:GetAllPlayers(GameLobby)
			for i,v in pairs(GamePlerz) do
				game.ReplicatedStorage.Remotes.GameLeaveNotif:FireClient(v,PlayerName)
			end
			
		end
		
	end
	
end

function module:IsInGame(PlayerName)
	
	local GamE = false
	
	for i,v in pairs(game.ReplicatedStorage.Games:GetChildren()) do
		for a,b in pairs(v.Players:GetChildren()) do
			if b.Name == PlayerName then
				return v
			end
		end
	end
	
	return GamE
	
end

function module:IsSpectating(PlayerName)
	
	for i,v in pairs(game.ReplicatedStorage.Games:GetChildren()) do
		for a,b in pairs(v.Spectators:GetChildren()) do
			if b.Name == PlayerName then
				return v
			end
		end
	end
	
	return false
	
end

function module:IsInLobby(PlayerName)
	local Lobby = false
	
	for i,v in pairs(game.ReplicatedStorage.PermLobbies.Classic:GetChildren()) do
		local Plr = v.Players:FindFirstChild(PlayerName)
		if Plr then
			return v
		end
	end
	
	for i,v in pairs(game.ReplicatedStorage.PermLobbies.Super:GetChildren()) do
		local Plr = v.Players:FindFirstChild(PlayerName)
		if Plr then
			return v
		end
	end
	
	for i,v in pairs(game.ReplicatedStorage.Lobbies.Classic:GetChildren()) do
		local Plr = v.Players:FindFirstChild(PlayerName)
		if Plr then
			return v
		end
	end
	
	for i,v in pairs(game.ReplicatedStorage.Lobbies.Super:GetChildren()) do
		local Plr = v.Players:FindFirstChild(PlayerName)
		if Plr then
			return v
		end
	end
	
	for i,v in pairs(game.ReplicatedStorage.Lobbies.Custom:GetChildren()) do
		local Plr = v.Players:FindFirstChild(PlayerName)
		if Plr then
			return v
		end
	end
	
	return Lobby
end

function module:JoinLobby(PlayerName,LobbyName,CodeEntered,Perm)
		
	if self:IsInLobby(PlayerName) or self:IsInGame(PlayerName) or self:IsSpectating(PlayerName) then return end
	
	local LookIn = game.ReplicatedStorage.Lobbies
	if Perm then
		LookIn = game.ReplicatedStorage.PermLobbies
	end
	
	local Lobby = LookIn:FindFirstChild(LobbyName,true)
	if Lobby then
		if Lobby.Settings.CodeLocked.Value == false or (Lobby.Settings.CodeLocked.Value == true and Lobby.Settings.Code.Value == CodeEntered) or PlayerName == Lobby.Settings.Host.Value then
			if #Lobby.Players:GetChildren() < Lobby.Settings.MaxPlrs.Value then
				local StringVal = Instance.new("BoolValue")
				StringVal.Name = PlayerName

				StringVal.Parent = Lobby.Players
				
				if Perm then
					local Chara = game.Workspace:FindFirstChild(PlayerName)
					local WorkLobby = game.Workspace.PermLobbies:FindFirstChild(LobbyName,true)
					if Chara and WorkLobby then
						local Root = Chara:FindFirstChild("HumanoidRootPart")
						if Root then
							
							Root.CFrame = WorkLobby.Base.CFrame + Vector3.new(0,1.5,0)
							
						end
					end
				end
			
				return "Yay", Lobby
			end
		end
	end
	
	return "No",nil
	
end

function module:CreateLobby(PlayerName,Type,Args,Deck)
	
	if self:IsInLobby(PlayerName) or self:IsInGame(PlayerName) or self:IsSpectating(PlayerName) then return "Failed" end
	
	if Args["CodeLocked"] then
		local Code = Args["Code"]
		
		local FilteredResult = TextService:FilterStringAsync(Code,23441688)
		local FilterRes = FilteredResult:GetNonChatStringForBroadcastAsync()
		
		if FilterRes ~= Code then
			return "Filtered"
		end
		
	end
	
	local LobClone = game.ReplicatedStorage.Templates.LobbyTemplate:Clone()
	
	for i,v in pairs(LobClone.Settings:GetChildren()) do
		local Arg = Args[v.Name]
		if Arg ~= nil then
			v.Value = Arg
			local Maxi = 10
			
			if Util:HasPass(PlayerName,"BiggerLobbies") then
				Maxi = 50
			end
			
			if v.Name == "MaxPlrs" then
				v.Value = math.clamp(Arg,2,Maxi)
			end
		end
	end
	
	if Type == "Classic" or Type == "Super" then
		
		--[[local DeckVal = Instance.new("StringValue")
		DeckVal.Name = "FullDeck"
		DeckVal.Value = Type
		DeckVal.Parent = LobClone.DeckData]]
		
		if Type == "Classic" then
			
			for i,v in pairs(ClassicDeck) do
				local CardClone = game.ReplicatedStorage.Templates.CardTemplate:Clone()
				CardClone.Name = "Card" .. i
				CardClone.Color.Value = v["Color"]
				CardClone.Type.Value = v["Type"]
				CardClone.Class.Value = v["Class"]
				CardClone.Parent = LobClone.DeckData
			end
			
		elseif Type == "Super" then
			
			for i,v in pairs(SuperDeck) do
				local CardClone = game.ReplicatedStorage.Templates.CardTemplate:Clone()
				CardClone.Name = "Card" .. i
				CardClone.Color.Value = v["Color"]
				CardClone.Type.Value = v["Type"]
				CardClone.Class.Value = v["Class"]
				CardClone.Parent = LobClone.DeckData
			end
			
		end
		
	else
		
		local PlrData = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
		if PlrData then
			local CorreDeck = PlrData.Inventory.Decks:FindFirstChild(Deck)
			if CorreDeck then
				for i,v in pairs(CorreDeck:GetChildren()) do
					
					local CardClone = game.ReplicatedStorage.Templates.CardTemplate:Clone()
					CardClone.Name = "Card" .. i
					CardClone.Color.Value = v.Color.Value
					CardClone.Type.Value = v.Type.Value
					CardClone.Class.Value = v.Class.Value
					CardClone.Parent = LobClone.DeckData
					
				end
			else
				return "Failed"
			end
		else
			return "Failed"
		end
		
	end
	
	for i,v in pairs(LobClone.DeckData:GetChildren()) do
		if v.Color.Value ~= Color3.fromRGB(0,0,0) then
			
			local FoundColor = false
			
			for a,b in pairs(LobClone.ColorList:GetChildren()) do
				if b.Value ==  v.Color.Value then
					FoundColor = true
					break
				end
			end
			
			if not FoundColor then
				local Col = Instance.new("Color3Value")
				Col.Value = v.Color.Value
				Col.Parent = LobClone.ColorList
			end
			
		end
	end
	
	self.LobbyCount = self.LobbyCount + 1
	
	LobClone.Name = "Lobby" .. self.LobbyCount
	
	local Folder = game.ReplicatedStorage.Lobbies:FindFirstChild(Type)
	if Folder then
		
		LobClone.Parent = Folder
		self:JoinLobby(PlayerName,LobClone.Name,Args["Code"])
	end
	
	return "Yay",LobClone
	
end

function module:DisbandLobby(Lobby)
	for i,v in pairs(Lobby.Players:GetChildren()) do
		--Alert that lobby was deleted
	end
	
	Lobby:Destroy()
end

function module:LeaveLobby(PlayerName)
	local Lobby = self:IsInLobby(PlayerName)
	if Lobby then
		
		local plrTag = Lobby.Players:FindFirstChild(PlayerName)
		if plrTag then plrTag:Destroy() end
		
		if Lobby.PermLobby.Value then
			local Chara = game.Workspace:FindFirstChild(PlayerName)
			local WorkLobby = game.Workspace.PermLobbies:FindFirstChild(Lobby.Name,true)
			if Chara and WorkLobby then
				local Root = Chara:FindFirstChild("HumanoidRootPart")
				if Root then

					Root.CFrame = WorkLobby.Base.CFrame*CFrame.new(0,0,13) + Vector3.new(0,2,0)

				end
			end
		end
		
		if Lobby.Settings.Host.Value == PlayerName then
			self:DisbandLobby(Lobby)
		end
	end
end

function module:WatchPlayer(WatcherName, Position, GameName)
	
	local GameS = game.ReplicatedStorage.Games:FindFirstChild(GameName)
	if GameS then
		
		local GameSpec = self:IsSpectating(WatcherName)
		if GameSpec and GameSpec.Name == GameName then
			local Players = GameSpec.Players:GetChildren()
			local Player = Players[Position]
			local Watcher = game.Players:FindFirstChild(WatcherName)
			if Player and Watcher then
				
				game.ReplicatedStorage.Remotes.TrackDeck:FireClient(Watcher, Player.Cards, Position)
				
			end
		end
		
	end
	
end

function module:SwitchWatchPlayer(PlayerName,Direction)
	
	if self:IsInLobby(PlayerName) or self:IsInGame(PlayerName) then return end
	
	local GameSpec = self:IsSpectating(PlayerName)
	if GameSpec then
		
		local Plr = game.Players:FindFirstChild(PlayerName)
		local Plerz = GameSpec.Players:GetChildren()
		
		local PlayerFind = GameSpec.Spectators:FindFirstChild(PlayerName)
		if PlayerFind and Plr then
			
			if Direction == "Next" then
				PlayerFind.Value = PlayerFind.Value + 1
			else
				PlayerFind.Value = PlayerFind.Value - 1
			end
			
			if PlayerFind.Value <= 0 then
				PlayerFind.Value = #Plerz
			elseif PlayerFind.Value > #Plerz then
				PlayerFind.Value = 1
			end
			
			self:WatchPlayer(PlayerName, PlayerFind.Value, GameSpec.Name)
			
		end
	end
	
end

function module:SpectateGame(PlayerName, GameName)
	
	if self:IsInLobby(PlayerName) or self:IsInGame(PlayerName) or self:IsSpectating(PlayerName) then return "Failed" end
	
	local GameS = game.ReplicatedStorage.Games:FindFirstChild(GameName)
	local Arena = game.Workspace.Arenas:FindFirstChild(GameName)
	if GameS and Arena then
		
		local IntV = Instance.new("IntValue")
		IntV.Name = PlayerName
		IntV.Parent = GameS.Spectators
		IntV.Value = 1
		
		local Plr = game.Players:FindFirstChild(PlayerName)
		if Plr then
			game.ReplicatedStorage.Remotes.TrackGame:FireClient(Plr,GameS)
			
			for i,v in pairs(GameS.Players:GetChildren()) do
				local Char = Arena:FindFirstChild(v.Name)
				if Char then
					local Head = Char:FindFirstChild("Head")
					if Head then
						
						game.ReplicatedStorage.Remotes.AddConInfo:FireClient(Plr,Head,v)
						
					end
				end
			end
			
			self:WatchPlayer(PlayerName, IntV.Value, GameName)
		end
		
		return "Good"
		
	end
	
	return "Failed"
	
end

function module:UnSpectate(PlayerName)
	
	local SpecFind = self:IsSpectating(PlayerName)
	local Plr = game.Players:FindFirstChild(PlayerName)
	if SpecFind then
		local Specer = SpecFind.Spectators:FindFirstChild(PlayerName)
		if Specer then Specer:Destroy() end
	end
	
	if Plr then
		
	end
	
end

function module:KickPlayer(PlayerKicking,ToBeKicked)
	
	if PlayerKicking == ToBeKicked then return end
	
	local Lob1 = self:IsInLobby(PlayerKicking)
	local Lob2 = self:IsInLobby(ToBeKicked)
	if Lob1 and Lob2 then
		if Lob1.Name == Lob2.Name then
			
			if Lob1.Settings.Host.Value == ToBeKicked then return end
			
			if Lob1.Settings.Host.Value == PlayerKicking then
				--Notif
				self:LeaveLobby(ToBeKicked)
			end
			
		end
	end
	
end

function module:AddBot(Lobby)
	
	if #Lobby.Players:GetChildren() >= Lobby.Settings.MaxPlrs.Value then return end
	
	Lobby.Settings.BotCounter.Value = Lobby.Settings.BotCounter.Value + 1
	
	local BotVal = Instance.new("BoolValue")
	BotVal.Name = "||.BOT " .. Lobby.Settings.BotCounter.Value
	BotVal.Parent = Lobby.Players
	
end

return module