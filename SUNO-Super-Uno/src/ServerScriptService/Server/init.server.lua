--X_Z

--Everything Server-Sided

--//Waits

script:WaitForChild("DataHandler")
script:WaitForChild("LobbyHandler")
script:WaitForChild("GameHandler")
script:WaitForChild("InventoryHandler")
script:WaitForChild("LevelHandler")
script:WaitForChild("Util")
script:WaitForChild("CodeHandler")
script:WaitForChild("DailyReward")
script:WaitForChild("GlobalLeaderboard")
script:WaitForChild("CraftingHandler")
script:WaitForChild("TradeHandler")

game.ReplicatedStorage:WaitForChild("Remotes")
game.ReplicatedStorage.Remotes:WaitForChild("CreateLobby")
game.ReplicatedStorage.Remotes:WaitForChild("JoinLobby")
game.ReplicatedStorage.Remotes:WaitForChild("LeaveLobby")
game.ReplicatedStorage.Remotes:WaitForChild("DisbandLobby")
game.ReplicatedStorage.Remotes:WaitForChild("KickPlayer")
game.ReplicatedStorage.Remotes:WaitForChild("StartGame")
game.ReplicatedStorage.Remotes:WaitForChild("Respond")
game.ReplicatedStorage.Remotes:WaitForChild("PlayCard")
game.ReplicatedStorage.Remotes:WaitForChild("SetAction")
game.ReplicatedStorage.Remotes:WaitForChild("CallUno")
game.ReplicatedStorage.Remotes:WaitForChild("AddBot")
game.ReplicatedStorage.Remotes:WaitForChild("PickColor")
game.ReplicatedStorage.Remotes:WaitForChild("QuitLobby")
game.ReplicatedStorage.Remotes:WaitForChild("JumpIn")
game.ReplicatedStorage.Remotes:WaitForChild("ChoseSwap")
game.ReplicatedStorage.Remotes:WaitForChild("ChoseNumber")
game.ReplicatedStorage.Remotes:WaitForChild("EquipDecor")
game.ReplicatedStorage.Remotes:WaitForChild("UnEquipDecor")
game.ReplicatedStorage.Remotes:WaitForChild("EquipChair")
game.ReplicatedStorage.Remotes:WaitForChild("EquipParticle")
game.ReplicatedStorage.Remotes:WaitForChild("UnEquipParticle")
game.ReplicatedStorage.Remotes:WaitForChild("CreateDeck")
game.ReplicatedStorage.Remotes:WaitForChild("DeleteDeck")
game.ReplicatedStorage.Remotes:WaitForChild("RenameDeck")
game.ReplicatedStorage.Remotes:WaitForChild("DeleteCard")
game.ReplicatedStorage.Remotes:WaitForChild("DeleteMultiCard")
game.ReplicatedStorage.Remotes:WaitForChild("AddMultiCard")
game.ReplicatedStorage.Remotes:WaitForChild("AddCode")
game.ReplicatedStorage.Remotes:WaitForChild("ChangeVolume")
game.ReplicatedStorage.Remotes:WaitForChild("TradeToggle")
game.ReplicatedStorage.Remotes:WaitForChild("WatchGame")
game.ReplicatedStorage.Remotes:WaitForChild("ExitSpectate")
game.ReplicatedStorage.Remotes:WaitForChild("SwitchWatchPlayer")
game.ReplicatedStorage.Remotes:WaitForChild("BuyCase")
game.ReplicatedStorage.Remotes:WaitForChild("Prestige")
game.ReplicatedStorage.Remotes:WaitForChild("CraftAdd")
game.ReplicatedStorage.Remotes:WaitForChild("CraftRemove")
game.ReplicatedStorage.Remotes:WaitForChild("Craft")
game.ReplicatedStorage.Remotes:WaitForChild("SendTrade")
game.ReplicatedStorage.Remotes:WaitForChild("DeclineTrade")
game.ReplicatedStorage.Remotes:WaitForChild("AcceptTrade")
game.ReplicatedStorage.Remotes:WaitForChild("ConfirmTrade")
game.ReplicatedStorage.Remotes:WaitForChild("FinalAcceptTrade")
game.ReplicatedStorage.Remotes:WaitForChild("AddTradeItem")
game.ReplicatedStorage.Remotes:WaitForChild("RemoveTradeItem")
game.ReplicatedStorage.Remotes:WaitForChild("CancelTrade")
game.ReplicatedStorage.Remotes:WaitForChild("ShutdownSend")

game.ReplicatedStorage:WaitForChild("PermLobbies")
game.ReplicatedStorage.PermLobbies:WaitForChild("Classic")
game.ReplicatedStorage.PermLobbies.Classic:WaitForChild("LobbyC1")

--//Modules

local DataHandler = require(script.DataHandler)
local LobbyHandler = require(script.LobbyHandler)
local GameHandler = require(script.GameHandler)
local InventoryHandler = require(script.InventoryHandler)
local LevelHandler = require(script.LevelHandler)
local Util = require(script.Util)
local CodeHandler = require(script.CodeHandler)
local DailyReward = require(script.DailyReward)
local GlobalLeaderboard = require(script.GlobalLeaderboard)
local CraftingHandler = require(script.CraftingHandler)
local TradeHandler = require(script.TradeHandler)

--//Services

local TextService = game:GetService("TextService")
local MarketplaceService = game:GetService("MarketplaceService")
local MessagingService = game:GetService("MessagingService")

--//Vars

--//Remotes

game.ReplicatedStorage.Remotes.CreateLobby.OnServerInvoke = function(Invoker,Type,Args,Deck)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	if not (Type == "Classic" or Type == "Super" or Type == "Custom") then return end
	
	Args["Host"] = Invoker.Name
	
	local Status,Lobby = LobbyHandler:CreateLobby(Invoker.Name,Type,Args,Deck)
	return Status,Lobby
end

game.ReplicatedStorage.Remotes.JoinLobby.OnServerInvoke = function(Invoker,LobbyName,Code,Perm)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	local Status, Lobby = LobbyHandler:JoinLobby(Invoker.Name,LobbyName,Code,Perm)
	return Status, Lobby
end

game.ReplicatedStorage.Remotes.LeaveLobby.OnServerInvoke = function(Invoker)
	LobbyHandler:LeaveLobby(Invoker.Name)
	return true
end

game.ReplicatedStorage.Remotes.KickPlayer.OnServerInvoke = function(Invoker,KickerName)
	LobbyHandler:KickPlayer(Invoker.Name,KickerName)
end

game.ReplicatedStorage.Remotes.PlayCard.OnServerInvoke = function(Invoker,CardId)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	local GameC = LobbyHandler:IsInGame(Invoker.Name)
	if GameC and GameC.Started.Value then
		
		local PlayerGC = GameC.Players:FindFirstChild(Invoker.Name)
		if PlayerGC then
			
			local CardF = PlayerGC.Cards:FindFirstChild(CardId)
			if CardF then
				
				if GameHandler:CanPlayCard(GameC,CardF) then
					
					if GameC.CurrentPlayer.Value == Invoker.Name and GameC.Playable.Value and GameC.SelectedAction.Value == "None" then
					
						CardF.Parent = GameC.Discards
						GameC.SelectedAction.Value = "Card"
						GameC.PreviousCard.Value = GameC.CurrentCard.Value
						GameC.CurrentCard.Value = CardF
						
						return true
						
					elseif GameC.Settings.JumpIn.Value and not GameC.JumpedIn.Value then
						
						if ((CardF.Type.Value == "Number" and GameC.CurrentCard.Value.Type.Value == "Number") or (CardF.Type.Value == "Number" and GameC.CurrentCard.Value.Type.Value == "Wild Number")) and CardF.Class.Value == GameC.CurrentCard.Value.Class.Value and CardF.Color.Value == GameC.CurrentCard.Value.Color.Value then
							--[[GameC.JumpedIn.Value = true
							GameC.JumpedIn.Jumper.Value = Invoker.Name
							CardF.Parent = GameC.Discards
							GameC.SelectedAction.Value = "JumpIn"
							GameC.PreviousCard.Value = GameC.CurrentCard.Value
							GameC.CurrentCard.Value = CardF]]
							GameHandler:JumpIn(GameC,Invoker.Name,CardId)
						end
						
					end
					
				end
				
			end
			
		end
		
	end
	return false
end

game.ReplicatedStorage.Remotes.EquipDecor.OnServerInvoke = function(Invoker,DecorName,SlotNum)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) or Util:IsTrading(Invoker.Name) then return end
	
	if typeof(DecorName) ~= "string" and typeof(SlotNum) ~= "number" then return "Bad" end
	
	local Res = InventoryHandler:EquipDecor(Invoker.Name,SlotNum,DecorName)
	
	return Res
	
end

game.ReplicatedStorage.Remotes.UnEquipDecor.OnServerInvoke = function(Invoker,SlotNum)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) or Util:IsTrading(Invoker.Name) then return end
	
	if typeof(SlotNum) ~= "number" then return "Bad" end
	
	local Res = InventoryHandler:UnEquipDecor(Invoker.Name,SlotNum)
	
	return Res
	
end

game.ReplicatedStorage.Remotes.EquipChair.OnServerInvoke = function(Invoker,ChairName)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	if typeof(ChairName) ~= "string" then return "Bad" end
	
	local Res = InventoryHandler:EquipChair(Invoker.Name,ChairName)
	
	return Res
end

game.ReplicatedStorage.Remotes.EquipParticle.OnServerInvoke = function(Invoker,ParticleName)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	if typeof(ParticleName) ~= "string" then return "Bad" end

	local Res = InventoryHandler:EquipParticle(Invoker.Name,ParticleName)

	return Res
	
end

game.ReplicatedStorage.Remotes.UnEquipParticle.OnServerInvoke = function(Invoker)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	local Res = InventoryHandler:UnEquipParticle(Invoker.Name)
	
	return Res
	
end

game.ReplicatedStorage.Remotes.CreateDeck.OnServerInvoke = function(Invoker)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	local Res,NewDeck = InventoryHandler:CreateDeck(Invoker.Name)
	
	return Res,NewDeck
	
end

game.ReplicatedStorage.Remotes.DeleteDeck.OnServerInvoke = function(Invoker,DeckName)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	local Res = InventoryHandler:DeleteDeck(Invoker.Name,DeckName)
	
	return Res
	
end

game.ReplicatedStorage.Remotes.RenameDeck.OnServerInvoke = function(Invoker,DeckName,ReName)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	local Res,N = InventoryHandler:ReNameDeck(Invoker.Name,DeckName,ReName)
	
	return Res,N
	
end

game.ReplicatedStorage.Remotes.DeleteCard.OnServerInvoke = function(Invoker,DeckName,CardName)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	InventoryHandler:DeleteCard(Invoker.Name,DeckName,CardName)
	
	return true
	
end

game.ReplicatedStorage.Remotes.DeleteMultiCard.OnServerInvoke = function(Invoker,DeckName,Colors,Cards,Filters)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	if typeof(DeckName) ~= "string" or typeof(Colors) ~= "table" or typeof(Cards) ~= "table" or typeof(Filters) ~= "table" then return false end
	
	InventoryHandler:MultiRemoveCards(Invoker.Name, DeckName, Colors, Cards, Filters)
	
	return true
	
end

game.ReplicatedStorage.Remotes.AddMultiCard.OnServerInvoke = function(Invoker,DeckName,Colors,Cards,Filters)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	if typeof(DeckName) ~= "string" or typeof(Colors) ~= "table" or typeof(Cards) ~= "table" or typeof(Filters) ~= "table" then return false end
	
	InventoryHandler:MultiAddCards(Invoker.Name, DeckName, Colors, Cards, Filters)

	return true
	
end

game.ReplicatedStorage.Remotes.RedeemCode.OnServerInvoke = function(Invoker,Code)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	if typeof(Code) ~= "string" then return "INVALID CODE" end
	
	local CodeStatus = CodeHandler:RedeemCode(Invoker.Name,Code)
	
	return CodeStatus
	
end

game.ReplicatedStorage.Remotes.WatchGame.OnServerInvoke = function(Invoker, GameName)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	if typeof(GameName) ~= "string" then return end
	
	local Res = LobbyHandler:SpectateGame(Invoker.Name, GameName)
	
	return Res
	
end

game.ReplicatedStorage.Remotes.ExitSpectate.OnServerInvoke = function(Invoker)
	
	local Yield = LobbyHandler:UnSpectate(Invoker.Name)
	
	game.ReplicatedStorage.Remotes.UnSpec:FireClient(Invoker)
	
end

game.ReplicatedStorage.Remotes.SwitchWatchPlayer.OnServerInvoke = function(Invoker, Direction)
	
	LobbyHandler:SwitchWatchPlayer(Invoker.Name, Direction)
	
end

game.ReplicatedStorage.Remotes.BuyCase.OnServerInvoke = function(Invoker, CaseName)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) or Util:IsTrading(Invoker.Name) then return "Failed" end
	
	local Result = InventoryHandler:OpenCase(Invoker.Name, CaseName)
	
	return Result
	
end

game.ReplicatedStorage.Remotes.Prestige.OnServerInvoke = function(Invoker)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) or Util:IsTrading(Invoker.Name) then return "Failed" end
	
	local Result = LevelHandler:Prestige(Invoker.Name)
	
	return Result
	
end

game.ReplicatedStorage.Remotes.CraftAdd.OnServerInvoke = function(Invoker, ItemName)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) or Util:IsTrading(Invoker.Name) then return "Failed" end
	
	local Res = CraftingHandler:AddItem(Invoker.Name,ItemName)
	
	return Res
	
end

game.ReplicatedStorage.Remotes.CraftRemove.OnServerInvoke = function(Invoker, ItemName)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) or Util:IsTrading(Invoker.Name) then return "Failed" end

	local Res = CraftingHandler:RemoveItem(Invoker.Name,ItemName)

	return Res
	
end

game.ReplicatedStorage.Remotes.Craft.OnServerInvoke = function(Invoker)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) or Util:IsTrading(Invoker.Name) then return "Failed" end

	local Res = CraftingHandler:Craft(Invoker.Name)

	return Res
	
end

game.ReplicatedStorage.Remotes.AddTradeItem.OnServerInvoke = function(Invoker, ItemName)
	
	local TradeFolder = Util:GetTradeFolder(Invoker.Name)
	if TradeFolder then
		
		if TradeFolder.Canceled.Value then return end
		
		TradeHandler:AddItemToTrade(TradeFolder,Invoker.Name,ItemName)
		
	end
	
end

game.ReplicatedStorage.Remotes.RemoveTradeItem.OnServerInvoke = function(Invoker, ItemName)
	
	
	local TradeFolder = Util:GetTradeFolder(Invoker.Name)
	if TradeFolder then

		if TradeFolder.Canceled.Value then return end

		TradeHandler:RemoveItemFromTrade(TradeFolder,Invoker.Name,ItemName)

	end
	
end

game.ReplicatedStorage.Remotes.StartGame.OnServerEvent:Connect(function(Invoker)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	local Lobby = LobbyHandler:IsInLobby(Invoker.Name)
	if Lobby and Lobby.Settings.Host.Value == Invoker.Name then
		GameHandler:GameLoop(Lobby)
	end
end)

game.ReplicatedStorage.Remotes.Respond.OnServerEvent:Connect(function(Invoker)
	local GameIs = LobbyHandler:IsInGame(Invoker.Name)
	if GameIs then
		
		local Responsed = GameIs.Responses:FindFirstChild(Invoker.Name)
		if not Responsed then
			local IntVal = Instance.new("IntValue")
			IntVal.Name = Invoker.Name
			IntVal.Parent = GameIs.Responses
		end
		
	end
end)

game.ReplicatedStorage.Remotes.SetAction.OnServerEvent:Connect(function(Invoker,Action)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	local InvokerGame = LobbyHandler:IsInGame(Invoker.Name)
	if InvokerGame then
		if InvokerGame.Playable.Value and InvokerGame.CurrentPlayer.Value == Invoker.Name then
			
			if Action == "Keep" and InvokerGame.SelectedAction.Value == "None" and InvokerGame.SecondaryAction.Value == "PlayKeep" then
				InvokerGame.SelectedAction.Value = "Keep"
			elseif Action == "Draw" and InvokerGame.SelectedAction.Value == "None" and InvokerGame.SecondaryAction.Value == "None" then
				InvokerGame.SelectedAction.Value = "Draw"
			elseif InvokerGame.SecondaryAction.Value == "BluffPrompt" and Action == "Draw" and InvokerGame.SelectedAction.Value == "None" then
				InvokerGame.SelectedAction.Value = "Draw"
			elseif InvokerGame.SecondaryAction.Value == "BluffPrompt" and Action == "Challenge" and InvokerGame.SelectedAction.Value == "None" then
				InvokerGame.SelectedAction.Value = "Challenge"
			end
			
		end
	end
	
end)

game.ReplicatedStorage.Remotes.CallUno.OnServerEvent:Connect(function(Invoker)
	
	local InvokerGame = LobbyHandler:IsInGame(Invoker.Name)
	if InvokerGame then
		if InvokerGame.CurrentPlayer.Value == Invoker.Name then
			local InvokerPlayer = InvokerGame.Players:FindFirstChild(Invoker.Name)
			if InvokerPlayer then
				local Unoed = InvokerPlayer:FindFirstChild("UnoCall")
				if Unoed then
					--
				else
					local UnoCall = Instance.new("IntValue")
					UnoCall.Name = "UnoCall"
					UnoCall.Parent = InvokerPlayer
					
					game.ReplicatedStorage.Remotes.UnoPopper:FireClient(Invoker,false)
				end
			end
		end
	end
	
end)

game.ReplicatedStorage.Remotes.AddBot.OnServerEvent:Connect(function(Invoker)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	local InvokerLobby = LobbyHandler:IsInLobby(Invoker.Name)
	if InvokerLobby and InvokerLobby.Settings.Host.Value == Invoker.Name then
		LobbyHandler:AddBot(InvokerLobby)
	end
end)

game.ReplicatedStorage.Remotes.PickColor.OnServerEvent:Connect(function(Invoker,Color)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	if typeof(Color) ~= "Color3" then return end
	
	local InvokerGame = LobbyHandler:IsInGame(Invoker.Name)
	if InvokerGame and InvokerGame.CurrentPlayer.Value == Invoker.Name and InvokerGame.SecondaryAction.Value == "PickColor" and InvokerGame.Playable.Value == true then
		
		local FoundColor = false
		InvokerGame.Playable.Value = false
		
		for i,v in pairs(InvokerGame.ColorList:GetChildren()) do
			if v.Value == Color then
				FoundColor = true
				break
			end
		end
		
		if not FoundColor or InvokerGame.SecondaryAction.ColorChose.Value ~= Color3.fromRGB(0,0,0) then return end
		
		InvokerGame.SecondaryAction.ColorChose.Value = Color
	end
end)

game.ReplicatedStorage.Remotes.ChoseSwap.OnServerEvent:Connect(function(Invoker,WhoToSwapWith)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	if typeof(WhoToSwapWith) ~= "string" or WhoToSwapWith == Invoker.Name then return end
	
	local InvokerGame = LobbyHandler:IsInGame(Invoker.Name)
	if InvokerGame then
		
		if InvokerGame.CurrentPlayer.Value ~= Invoker.Name or (InvokerGame.SecondaryAction.Value ~= "Swap" and InvokerGame.SecondaryAction.Value ~= "PickPlayer") or InvokerGame.SecondaryAction.PlayerChose.Value ~= "" then return end
		
		local GameSwapper = InvokerGame.Players:FindFirstChild(WhoToSwapWith)
		if GameSwapper then
			InvokerGame.SecondaryAction.PlayerChose.Value = WhoToSwapWith
		end
		
	end
end)

game.ReplicatedStorage.Remotes.QuitLobby.OnServerEvent:Connect(function(Invoker)
	
	local InvokerGame = LobbyHandler:IsInGame(Invoker.Name)
	if InvokerGame then
		LobbyHandler:LeaveGame(InvokerGame,Invoker.Name)
	end
	
end)

game.ReplicatedStorage.Remotes.JumpIn.OnServerEvent:Connect(function(Invoker,CardName)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	if CardName == nil or typeof(CardName) ~= "string" then return end
	
	local InvokerGame = LobbyHandler:IsInGame(Invoker.Name)
	if InvokerGame then
		GameHandler:JumpIn(InvokerGame,Invoker.Name,CardName)
	end
	
end)

game.ReplicatedStorage.Remotes.ChoseNumber.OnServerEvent:Connect(function(Invoker,Number)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	if typeof(Number) ~= "string" then return end
	
	local InvokerGame = LobbyHandler:IsInGame(Invoker.Name)
	if InvokerGame then
		
		if InvokerGame.CurrentPlayer.Value == Invoker.Name and InvokerGame.SecondaryAction.Value == "PickNumber" and InvokerGame.Playable.Value then
			
			InvokerGame.Playable.Value = false
			InvokerGame.SecondaryAction.NumberChose.Value = Number
			
		end
		
	end
	
end)

game.ReplicatedStorage.Remotes.AddCode.OnServerEvent:Connect(function(Invoker,Code,RewardType,Expiration,Reward)
	
	if Invoker.UserId ~= 23441688 then return end
	
	if typeof(Code) == "string" and typeof(RewardType) == "string" and typeof(Expiration) == "number" then
		
		print(Reward)
	
		CodeHandler:AddCode(Code, Expiration, RewardType, Reward)
		
	end
	
end)

game.ReplicatedStorage.Remotes.ChangeVolume.OnServerEvent:Connect(function(Invoker,NewVolume)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	if typeof(NewVolume) ~= "number" then return end
	
	local Data = Util:GetData(Invoker.Name)
	if Data then
		Data.Settings.Volume.Value = math.clamp(NewVolume,0,1)
	end
	
end)

game.ReplicatedStorage.Remotes.TradeToggle.OnServerEvent:Connect(function(Invoker)
	
	if Util:IsSavedLocked(Invoker.Name) or Util:DataNotLoaded(Invoker.Name) then return end
	
	local Data = Util:GetData(Invoker.Name)
	if Data then
		Data.Settings.Trading.Value = not Data.Settings.Trading.Value
	end
	
end)

game.ReplicatedStorage.Remotes.SendTrade.OnServerEvent:Connect(function(Invoker, SendToName)
	
	if Util:IsTrading(Invoker.Name) then return end
	
	TradeHandler:SendTradeRequest(Invoker.Name,SendToName)
	
end)

game.ReplicatedStorage.Remotes.DeclineTrade.OnServerEvent:Connect(function(Invoker, TraderName)
	
	TradeHandler:DeclineTradeRequest(Invoker.Name,TraderName)
	
end)

game.ReplicatedStorage.Remotes.AcceptTrade.OnServerEvent:Connect(function(Invoker, TraderName)
	
	TradeHandler:AcceptTradeRequest(Invoker.Name, TraderName)
	
end)

game.ReplicatedStorage.Remotes.ConfirmTrade.OnServerEvent:Connect(function(Invoker)
	
	local TradeFolder = Util:GetTradeFolder(Invoker.Name)
	if TradeFolder then
		
		if TradeFolder.Canceled.Value then return end
		
		TradeHandler:ConfirmTrade(TradeFolder,Invoker.Name)
		
	end
	
end)

game.ReplicatedStorage.Remotes.FinalAcceptTrade.OnServerEvent:Connect(function(Invoker)
	
	local TradeFolder = Util:GetTradeFolder(Invoker.Name)
	if TradeFolder then

		if TradeFolder.Canceled.Value then return end

		TradeHandler:AcceptTrade(TradeFolder,Invoker.Name)

	end
	
end)

game.ReplicatedStorage.Remotes.CancelTrade.OnServerEvent:Connect(function(Invoker)
	
	local TradeFolder = Util:GetTradeFolder(Invoker.Name)
	if TradeFolder then
		
		if TradeFolder.Canceled.Value then return end
		
		TradeHandler:CancelTrade(TradeFolder)
		
	end
	
end)

game.ReplicatedStorage.Remotes.ShutdownSend.OnServerEvent:Connect(function(Invoker,Time,Msg)
	
	if Invoker.UserId ~= 23441688 then return end
	
	local DataT = {Time = os.time() + Time, Message = Msg}
	
	local Sent,Mg = false, nil
	
	repeat
		
		Sent, Mg = pcall(function()
			MessagingService:PublishAsync("Shutdowns",DataT)
		end)
		
		if Sent then
			break
		end
		
		wait(10)
	until Sent
	
end)

--//Misc Events

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(Player, GamePassId, WasPurchased)
	
	if WasPurchased then
		
		local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(Player.Name)
		if Data then
			if GamePassId == 49325386 then
				-- VIP
				local PassVal = Data.GamePasses:FindFirstChild("VIP")
				if PassVal and PassVal.Value == false then
					PassVal.Value = true
					Data.VipItems.Value = true
					InventoryHandler:AddDecor(Player.Name,"Crown")
					InventoryHandler:AddChair(Player.Name,"Throne")
					InventoryHandler:AddParticle(Player.Name,"Stars")
					
					game.ReplicatedStorage.Remotes.RefreshGamepass:FireClient(Player,"Sprint")
					game.ReplicatedStorage.Remotes.RefreshLeader:FireAllClients(Player.Name)
					Player:LoadCharacter()
					-- Award Stuff
				end
			elseif GamePassId == 49325708 then
				-- +2 Decor Slots
				local PassVal = Data.GamePasses:FindFirstChild("MoreSlots")
				if PassVal and PassVal.Value == false then
					PassVal.Value = true
					game.ReplicatedStorage.Remotes.RefreshGamepass:FireClient(Player,"MoreSlots")
				end
			elseif GamePassId == 49325855 then
				-- Sprint
				local PassVal = Data.GamePasses:FindFirstChild("Sprint")
				if PassVal and PassVal.Value == false then
					PassVal.Value = true
					game.ReplicatedStorage.Remotes.RefreshGamepass:FireClient(Player,"Sprint")
					Player:LoadCharacter()
				end
			elseif GamePassId == 49325954 then
				-- Bigger Lobbies
				local PassVal = Data.GamePasses:FindFirstChild("BiggerLobbies")
				if PassVal and PassVal.Value == false then
					PassVal.Value = true
					game.ReplicatedStorage.Remotes.RefreshGamepass:FireClient(Player,"Sprint")
				end
			elseif GamePassId == 49326056 then
				-- More Decks
				local PassVal = Data.GamePasses:FindFirstChild("MoreDecks")
				if PassVal and PassVal.Value == false then
					PassVal.Value = true
					game.ReplicatedStorage.Remotes.RefreshGamepass:FireClient(Player,"MoreDecks")
					-- Award Stuff
				end
			elseif GamePassId == 49326163 then
				-- x2 XP
				local PassVal = Data.GamePasses:FindFirstChild("x2XP")
				if PassVal and PassVal.Value == false then
					PassVal.Value = true
					game.ReplicatedStorage.Remotes.RefreshGamepass:FireClient(Player,"Sprint")
				end
			elseif GamePassId == 49326237 then
				-- Kit #1
				local PassVal = Data.GamePasses:FindFirstChild("CosmeticKit1")
				if PassVal and PassVal.Value == false then
					PassVal.Value = true
					game.ReplicatedStorage.Remotes.RefreshGamepass:FireClient(Player,"Sprint")
					InventoryHandler:AddDecor(Player.Name,"Amethyst Wand")
					InventoryHandler:AddChair(Player.Name,"Amethyst Throne")
					InventoryHandler:AddParticle(Player.Name,"Amethyst Gems")
					-- Award Stuff
				end
			elseif GamePassId == 49326290 then
				-- Kit #2
				local PassVal = Data.GamePasses:FindFirstChild("CosmeticKit2")
				if PassVal and PassVal.Value == false then
					PassVal.Value = true
					InventoryHandler:AddDecor(Player.Name,"Tesla Coil")
					InventoryHandler:AddChair(Player.Name,"Thunder")
					InventoryHandler:AddParticle(Player.Name,"Storm Clouds")
					game.ReplicatedStorage.Remotes.RefreshGamepass:FireClient(Player,"Sprint")
					-- Award Stuff
				end
			elseif GamePassId == 52330048 then
				-- Quicker Crafting
				local PassVal = Data.GamePasses:FindFirstChild("ReducedCrafting")
				if PassVal and PassVal.Value == false then
					PassVal.Value = true
					game.ReplicatedStorage.Remotes.RefreshGamepass:FireClient(Player,"ReducedCrafting")
				end
			elseif GamePassId == 52331325 then
				-- Cooldown
				local PassVal = Data.GamePasses:FindFirstChild("CrateCooldown")
				if PassVal and PassVal.Value == false then
					PassVal.Value = true
					game.ReplicatedStorage.Remotes.RefreshGamepass:FireClient(Player,"Sprint")
				end
			elseif GamePassId == 52851983 then
				-- iamond Lamdo
				local PassVal = Data.GamePasses:FindFirstChild("DiamondLambo")
				if PassVal and PassVal.Value == false then
					PassVal.Value = true
					--InventoryHandler:
					InventoryHandler:AddDecor(Player.Name,"Diamond Lambo")
					game.ReplicatedStorage.Remotes.RefreshGamepass:FireClient(Player,"Sprint")
				end
			elseif GamePassId == 52165312 then
				-- iamond Lamdo
				local PassVal = Data.GamePasses:FindFirstChild("EpicGems")
				if PassVal and PassVal.Value == false then
					PassVal.Value = true
					
					InventoryHandler:AddDecor(Player.Name,"Emerald Stack")
					InventoryHandler:AddDecor(Player.Name,"Ruby Stack")
					InventoryHandler:AddDecor(Player.Name,"Citrine Stack")
					
					game.ReplicatedStorage.Remotes.RefreshGamepass:FireClient(Player,"Sprint")
				end
			elseif GamePassId == 51838723 then
				-- Gaming Chairs
				local PassVal = Data.GamePasses:FindFirstChild("GamerChairs")
				if PassVal and PassVal.Value == false then
					PassVal.Value = true
					--InventoryHandler:
					InventoryHandler:AddChair(Player.Name,"Female Streamer")
					InventoryHandler:AddChair(Player.Name,"Tryhard")
					InventoryHandler:AddChair(Player.Name,"Nine Cloud")
					game.ReplicatedStorage.Remotes.RefreshGamepass:FireClient(Player,"Sprint")
				end
			end
		end
		
	end
	
end)

MarketplaceService.ProcessReceipt = function(ReceiptInfo)
	
	local PlayerName = game.Players:GetNameFromUserIdAsync(ReceiptInfo.PlayerId)
	if PlayerName then
		
		local Data = Util:GetData(PlayerName)
		if Data then
			
			if Util:DataNotLoaded(PlayerName) or Util:IsSavedLocked(PlayerName) then return Enum.ProductPurchaseDecision.NotProcessedYet end
			
			local ProductId = ReceiptInfo.ProductId
			
			if ProductId == 1269793463 then
				Util:AddCoins(PlayerName,200,true)
			elseif ProductId == 1269793505 then
				Util:AddCoins(PlayerName,520,true)
			elseif ProductId == 1269793580 then
				Util:AddCoins(PlayerName,1600,true)
			elseif ProductId == 1269793643 then
				Util:AddCoins(PlayerName,4200,true)
			elseif ProductId == 1269793698 then
				Util:AddCoins(PlayerName,9200,true)
			elseif ProductId == 1269793724 then
				Util:AddCoins(PlayerName,25000,true)
			elseif ProductId == 1269793315 then
				DailyReward:Award(PlayerName,true)
			end
			
			return Enum.ProductPurchaseDecision.PurchaseGranted
			
		end
		
	end
	
	return Enum.ProductPurchaseDecision.NotProcessedYet
	
end

game.Players.PlayerAdded:Connect(function(Player)
	
	if game.ServerStorage.Shutdown.Value then
		Player:Kick("Servers Are Currently Restarting. Please rejoin in a few minutes.")
		return
	end
	
	Player.CharacterAdded:Connect(function(Character)
		
		InventoryHandler:EquipCharacterParticle(Player.Name,InventoryHandler:GetEquippedParticle(Player.Name))
		
		if LobbyHandler:IsInGame(Player.Name) then
			local Root = Character:WaitForChild("HumanoidRootPart")
			if Root then
				Root.CFrame = game.Workspace.HumCF.CFrame
			end
		end
		
		local Humanoid = Character:WaitForChild("Humanoid")
		if Humanoid then
			
			if Util:HasPass(Player.Name,"Sprint") then
				Humanoid.WalkSpeed = 32
			end
			
			Humanoid.NameDisplayDistance = Enum.HumanoidDisplayDistanceType.None
		end
		
		Character:WaitForChild("Head")
		
		LevelHandler:LevelNameTag(Player.Name)
		
	end)
	
	DataHandler:LoadData(Player)
	
	DailyReward:DailyReward(Player.Name)
	
	Util:RefreshCraftingInventory(Player.Name)
	
	local pData = game.ReplicatedStorage.PlayerData:FindFirstChild(Player.Name)
	if pData then
		--pData.LevelData.Level.Value = 100
		if InventoryHandler:HasGamepass(Player.Name,"VIP") and pData.VipItems.Value == false then
			pData.VipItems.Value = true
			InventoryHandler:AddDecor(Player.Name,"Crown")
			InventoryHandler:AddChair(Player.Name,"Throne")
			InventoryHandler:AddParticle(Player.Name,"Stars")
			game.ReplicatedStorage.Remotes.RefreshLeader:FireAllClients(Player.Name)
		end
	end
	
	-- VIP
	spawn(function()
		local Val = Util:HasFirstTimePass(Player, "VIP" , 49325386)
		if Val and pData then
			pData.VipItems.Value = true
			InventoryHandler:AddDecor(Player.Name,"Crown")
			InventoryHandler:AddChair(Player.Name,"Throne")
			InventoryHandler:AddParticle(Player.Name,"Stars")
			game.ReplicatedStorage.Remotes.RefreshLeader:FireAllClients(Player.Name)
			Player:LoadCharacter()
		end
	end)
	
	-- Sprint
	spawn(function()
		local Val = Util:HasFirstTimePass(Player, "Sprint" , 49325855)
		if Val then
			Player:LoadCharacter()
		end
	end)
	
	-- +2 Decor Slots
	spawn(function()
		local Val = Util:HasFirstTimePass(Player, "MoreSlots" , 49325708)
	end)
	
	-- x2 XP
	spawn(function()
		local Val = Util:HasFirstTimePass(Player, "x2XP" , 49326163)
	end)
	
	-- More Decks
	spawn(function()
		local Val = Util:HasFirstTimePass(Player, "MoreDecks" , 49326056)
	end)
	
	-- Bigger Lobbies
	spawn(function()
		local Val = Util:HasFirstTimePass(Player, "BiggerLobbies" , 49325954)
	end)
	
	-- Costmetic Kit 1
	spawn(function()
		local Val = Util:HasFirstTimePass(Player, "CosmeticKit1" , 49326237)
		if Val then
			InventoryHandler:AddDecor(Player.Name,"Amethyst Wand")
			InventoryHandler:AddChair(Player.Name,"Amethyst Throne")
			InventoryHandler:AddParticle(Player.Name,"Amethyst Gems")
		end
	end)
	
	--  Costmetic Kit 2
	spawn(function()
		local Val = Util:HasFirstTimePass(Player, "CosmeticKit2" , 49326290)
		if Val then
			InventoryHandler:AddDecor(Player.Name,"Tesla Coil")
			InventoryHandler:AddChair(Player.Name,"Thunder")
			InventoryHandler:AddParticle(Player.Name,"Storm Clouds")
		end
	end)
	
	spawn(function()
		local Val = Util:HasFirstTimePass(Player, "ReducedCrafting" , 52330048)
		if Val then
			
		end
	end)
	
	spawn(function()
		local Val = Util:HasFirstTimePass(Player, "GamerChairs" , 51838723)
		if Val then
			InventoryHandler:AddChair(Player.Name,"Female Streamer")
			InventoryHandler:AddChair(Player.Name,"Tryhard")
			InventoryHandler:AddChair(Player.Name,"Nine Cloud")
		end
	end)
	
	-- Bigger Lobbies
	spawn(function()
		local Val = Util:HasFirstTimePass(Player, "CrateCooldown" , 52331325)
	end)
	
	
	--Diamond Lambo
	spawn(function()
		local Val = Util:HasFirstTimePass(Player, "DiamondLambo" , 52851983)
		if Val then
			InventoryHandler:AddDecor(Player.Name,"Diamond Lambo")
		end
	end)
	
	spawn(function()
		local Val = Util:HasFirstTimePass(Player, "EpicGems" , 52165312)
		if Val then
			InventoryHandler:AddDecor(Player.Name,"Emerald Stack")
			InventoryHandler:AddDecor(Player.Name,"Ruby Stack")
			InventoryHandler:AddDecor(Player.Name,"Citrine Stack")
		end
	end)
	
end)

game.Players.PlayerRemoving:Connect(function(Player)
	
	local pData = game.ReplicatedStorage.PlayerData:FindFirstChild(Player.Name)
	if pData then
		pData.Loaded.Value = true
	end
	
	local TradeFolder = Util:GetTradeFolder(Player.Name)
	if TradeFolder then
		if TradeFolder.Canceled.Value == false then
			TradeHandler:CancelTrade(TradeFolder)
		end
	end
	
	local PlayerGame = LobbyHandler:IsInGame(Player.Name)
	if PlayerGame then
		LobbyHandler:LeaveGame(PlayerGame,Player.Name)
	end
	
	local PlayerLobby = LobbyHandler:IsInLobby(Player.Name)
	if PlayerLobby then
		LobbyHandler:LeaveLobby(Player.Name)
	end
	
	LobbyHandler:UnSpectate(Player.Name)
	
	DataHandler:SaveData(Player,nil,true)
	DataHandler:CloseSession(Player)
	
end)

MessagingService:SubscribeAsync("Unboxings",function(Message)
	
	local Data = Message.Data
	
	game.ReplicatedStorage.Remotes.UnobxedList:FireAllClients(Data.From, Data.PlayerName, Data.Rarity, Data.ItemName)
	
	--[[local UC = game.ReplicatedStorage.Templates.UnboxTemplate:Clone()
	UC.PlayerName.Value = Data.PlayerName
	UC.Rarity.Value = Data.Rarity
	UC.From.Value = Data.From
	UC.ItemName.Value = Data.ItemName
	
	local Unboxes = game.ReplicatedStorage.Unboxings:GetChildren()
	if #Unboxes >= 20 then
		Unboxes[#Unboxes]:Destroy()
	end
	
	UC.Parent = game.ReplicatedStorage.Unboxings]]
	
end)

MessagingService:SubscribeAsync("Shutdowns",function(Message)
	
	local Data = Message.Data
	
	game.ReplicatedStorage.ShutdownInfo.Time.Value = Data.Time
	game.ReplicatedStorage.ShutdownInfo.Message.Value = Data.Message
	
	repeat
		wait(1)
	until os.time() >= game.ReplicatedStorage.ShutdownInfo.Time.Value
	
	game.ServerStorage.Shutdown.Value = true
	
	for i,v in pairs(game.Players:GetChildren()) do
		spawn(function()
			local Data2 = Util:GetData(v.Name)
			if Data2 then
				DataHandler:SaveData(v,nil,true)
				DataHandler:CloseSession(v)
			end
			v:Kick("Servers Are Shutting Down For An Update. Your data has been saved.")
		end)
	end
	
end)
--[[
LobbyHandler:CreateLobby("Invoker","Classic",{Host = "Invoker"})
LobbyHandler:CreateLobby("Garry","Classic",{Host = "Garry"})
LobbyHandler:CreateLobby("Jerry","Classic",{Host = "Jerry"})
LobbyHandler:CreateLobby("Terry","Super",{Host = "Terry"})
LobbyHandler:CreateLobby("Clyde","Super",{Host = "Clyde"})
LobbyHandler:CreateLobby("Bob","Classic",{Host = "Bob"})
LobbyHandler:CreateLobby("SCS","Custom",{Host = "SCS"})
LobbyHandler:CreateLobby("Thomas","Custom",{Host = "Thomas"})
]]
spawn(function()
	wait(5)
	
	--MessagingService:PublishAsync("Unboxings",{PlayerName = "X_Z",ItemName = "Decor4",Rarity = "Exotic",From = "CRATE"})
	
end)

--

for i,v in pairs(game.ReplicatedStorage.PermLobbies.Classic:GetChildren()) do
	
	local function GetBoard(Lobby)
		local LobbyF = game.Workspace.PermLobbies:FindFirstChild(Lobby.Name,true)
		if LobbyF then
			return LobbyF.Board
		end
		return nil
	end
	
	local function RefreshBoard(Lobby)
		local Board = GetBoard(Lobby)
		if Board ~= nil then
			
			local Playerz = Lobby.Players:GetChildren()
			
			Board.SG.Back.Count.Text = #Playerz .. " / 4"
			Board.SG.Back.Count.Dark.Text = #Playerz .. " / 4"
			
			for i,v in pairs(Board.SG.Back.PlayerList:GetChildren()) do
				local Corre = Lobby.Players:FindFirstChild(v.Name)
				if Corre then
					--
				else
					v:Destroy()
				end
			end
			
			for i,v in pairs(Lobby.Players:GetChildren()) do
				local Corre = Board.SG.Back.PlayerList:FindFirstChild(v.Name)
				if Corre then
					--
				else
					local tClone = game.ReplicatedStorage.MiscAssets.ListTemp:Clone()
					tClone.Name = v.Name
					tClone.Ttl.Text = v.Name
					tClone.Ttl.Dark.Text = v.Name
					tClone.Avatar.Image = game.Players:GetUserThumbnailAsync(game.Players:GetUserIdFromNameAsync(v.Name),Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)
					tClone.Parent = Board.SG.Back.PlayerList
				end
			end
			
			for i,v in pairs(Board.SG.Back.PlayerList:GetChildren()) do
				v.Position = UDim2.new(0,0,0 + ((i-1)*.25),0)
			end
			
		end
	end
	
	v.Players.ChildAdded:Connect(function()
		RefreshBoard(v)
		
		local Playerz = v.Players:GetChildren()
		if #Playerz == 4 then
			
			for j = 5,0,-1 do
				
				local Playerzz = v.Players:GetChildren()
				if #Playerzz < 4 then
					print("Break it")
					v.PermLobby.Timer.Value = 0
					break
				end
				
				v.PermLobby.Timer.Value = j
				wait(1)
				
			end
			
			local Playerz1z = v.Players:GetChildren()
			if #Playerz1z == 4 then
				GameHandler:GameLoop(v)
			end
			
		end
	end)
	
	v.Players.ChildRemoved:Connect(function()
		RefreshBoard(v)
	end)
	
	v.PermLobby.Timer.Changed:Connect(function()
		local Board = GetBoard(v)
		if Board ~= nil then
			
			local TimerTxt = v.PermLobby.Timer.Value
			
			if v.PermLobby.Timer.Value <= 0 then
				TimerTxt = "-- --"
			end
			
			Board.SG.Back.Timer.Text = TimerTxt
			Board.SG.Back.Timer.Dark.Text = TimerTxt
			
		end
	end)
end

for i,v in pairs(game.ReplicatedStorage.PermLobbies.Super:GetChildren()) do

	local function GetBoard(Lobby)
		local LobbyF = game.Workspace.PermLobbies:FindFirstChild(Lobby.Name,true)
		if LobbyF then
			return LobbyF.Board
		end
		return nil
	end

	local function RefreshBoard(Lobby)
		local Board = GetBoard(Lobby)
		if Board ~= nil then

			local Playerz = Lobby.Players:GetChildren()

			Board.SG.Back.Count.Text = #Playerz .. " / 4"
			Board.SG.Back.Count.Dark.Text = #Playerz .. " / 4"

			for i,v in pairs(Board.SG.Back.PlayerList:GetChildren()) do
				local Corre = Lobby.Players:FindFirstChild(v.Name)
				if Corre then
					--
				else
					v:Destroy()
				end
			end

			for i,v in pairs(Lobby.Players:GetChildren()) do
				local Corre = Board.SG.Back.PlayerList:FindFirstChild(v.Name)
				if Corre then
					--
				else
					local tClone = game.ReplicatedStorage.MiscAssets.ListTemp:Clone()
					tClone.Name = v.Name
					tClone.Ttl.Text = v.Name
					tClone.Ttl.Dark.Text = v.Name
					tClone.Avatar.Image = game.Players:GetUserThumbnailAsync(game.Players:GetUserIdFromNameAsync(v.Name),Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)
					tClone.Parent = Board.SG.Back.PlayerList
				end
			end

			for i,v in pairs(Board.SG.Back.PlayerList:GetChildren()) do
				v.Position = UDim2.new(0,0,0 + ((i-1)*.25),0)
			end

		end
	end

	v.Players.ChildAdded:Connect(function()
		RefreshBoard(v)

		local Playerz = v.Players:GetChildren()
		if #Playerz == 4 then

			for j = 5,0,-1 do

				local Playerzz = v.Players:GetChildren()
				if #Playerzz < 4 then
					print("Break it")
					v.PermLobby.Timer.Value = 0
					break
				end

				v.PermLobby.Timer.Value = j
				wait(1)

			end

			local Playerz1z = v.Players:GetChildren()
			if #Playerz1z == 4 then
				GameHandler:GameLoop(v)
			end

		end
	end)

	v.Players.ChildRemoved:Connect(function()
		RefreshBoard(v)
	end)

	v.PermLobby.Timer.Changed:Connect(function()
		local Board = GetBoard(v)
		if Board ~= nil then

			local TimerTxt = v.PermLobby.Timer.Value

			if v.PermLobby.Timer.Value <= 0 then
				TimerTxt = "-- --"
			end

			Board.SG.Back.Timer.Text = TimerTxt
			Board.SG.Back.Timer.Dark.Text = TimerTxt

		end
	end)
end

game.OnClose = function()
	for i,v in pairs(game.Players:GetPlayers()) do
		
		DataHandler:SaveData(v,nil,true)
	
		DataHandler:CloseSession(v)
		
	end
end

--Save Loop

spawn(function()
	while true do
		
		CodeHandler:RefreshCodes()
		
		GlobalLeaderboard:LoadWins()
		GlobalLeaderboard:LoadPrestiges()
		
		wait(121)
	end
end)

spawn(function()
	--CodeHandler:AddCode("XYNTX",0,"Coins",2000)
	--CodeHandler:AddCode("testdecoradd2",os.time() + 90000000,"Item","Decor4")
end)

while wait(61) do
	warn("Performing minutely save!")
	
	for i,v in pairs(game.Players:GetPlayers()) do
		spawn(function()
			DataHandler:SaveData(v)
		end)
		spawn(function()
			DataHandler:SetSession(v,true)
		end)
		
		local Data = Util:GetData(v.Name)
		if Data then
			if Data.Loaded.Value then
				spawn(function()
					GlobalLeaderboard:SetWins(v.UserId,Data.Stats.Wins.Value)
				end)
				spawn(function()
					GlobalLeaderboard:SetPrestige(v.UserId,Data.LevelData.Prestige.Value)
				end)
			end
		end
		
	end
	
end