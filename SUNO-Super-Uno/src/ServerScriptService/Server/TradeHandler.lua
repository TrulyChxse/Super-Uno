--X_Z

script.Parent:WaitForChild("Util")
script.Parent:WaitForChild("InventoryHandler")

game.ReplicatedStorage:WaitForChild("Modules")
game.ReplicatedStorage.Modules:WaitForChild("CosmeticIndex")

local Util = require(script.Parent.Util)
local InventoryHandler = require(script.Parent.InventoryHandler)

local module = {}

function module:InitializeTrade(Player1Name, Player2Name)
	
	local Player1 = game.Players:FindFirstChild(Player1Name)
	local Player2 = game.Players:FindFirstChild(Player2Name)
	
	if Player1 and Player2 then
		
		local TradeClone = game.ReplicatedStorage.Templates.TradeTemplate:Clone()
		TradeClone.Player1.Name = Player1Name
		TradeClone.Player2.Name = Player2Name
		
		--Load Inventories
		--
		
		TradeClone.Parent = game.ReplicatedStorage.Trades
		
		game.ReplicatedStorage.Remotes.InitializeTrade:FireClient(Player1,TradeClone)
		game.ReplicatedStorage.Remotes.InitializeTrade:FireClient(Player2,TradeClone)
		
	end
	
end

function module:SendTradeRequest(SenderName, ToWho)
	
	local SenderData = Util:GetData(SenderName)
	local ToWhoData = Util:GetData(ToWho)
	
	if SenderData and ToWhoData then
		
		if ToWhoData.Settings.Trading.Value == false or SenderData.Settings.Trading.Value == false or SenderName == ToWho then return end
		
		local OldFind = ToWhoData.TradeRequests:FindFirstChild(SenderName)
		if OldFind == nil then
			local NewInt = Instance.new("IntValue")
			NewInt.Name = SenderName
			NewInt.Parent = ToWhoData.TradeRequests
			
			--Send Out Notif
			local SenderPlr = game.Players:FindFirstChild(SenderName)
			if SenderPlr then
				game.ReplicatedStorage.Remotes.TradeNotif:FireClient(SenderPlr, "Trade Sent!", "To\n" .. ToWho)
			end
			
		end
		
	end
	
end

function module:DeclineTradeRequest(PlayerName, TraderName)
	
	local Data = Util:GetData(PlayerName)
	if Data then
		
		local TradeFind = Data.TradeRequests:FindFirstChild(TraderName)
		if TradeFind then
			TradeFind:Destroy()
		end
		
	end
	
end

function module:AcceptTradeRequest(AccepterName, Player2Name)
	
	if AccepterName == Player2Name then return end
	
	local Data = Util:GetData(AccepterName)
	if Data then
		
		local TradeFind = Data.TradeRequests:FindFirstChild(Player2Name)
		if TradeFind then
			
			if Util:DataNotLoaded(Player2Name) or Util:DataNotLoaded(AccepterName) or Util:IsTrading(AccepterName) or Util:IsTrading(Player2Name) then return end
			
			TradeFind:Destroy()
			
			local TradeTemp = game.ReplicatedStorage.Templates.TradeTemplate:Clone()
			
			local P1Data = Util:GetData(AccepterName)
			local P2Data = Util:GetData(Player2Name)
			
			local P1T = TradeTemp.Player1
			local P2T = TradeTemp.Player2
			
			if P1Data and P2Data then
				
				--Load Player 1's Data
				
				for i,v in pairs(P1Data.Inventory.Decorations:GetChildren()) do
					local CosData = InventoryHandler:GetCosmeticInfo(v.Id.Value)
					if CosData then
						local ItemTemp = game.ReplicatedStorage.Templates.CraftingItem:Clone()
						ItemTemp.Name = v.Id.Value
						ItemTemp.Rarity.Value = CosData["Rarity"]
						ItemTemp.Copies.Value = v.Copies.Value
						ItemTemp.Type.Value = CosData["Type"]
						ItemTemp.Parent = TradeTemp.Player1.Inventory
					end
				end
				
				for i,v in pairs(P1Data.Inventory.Chairs:GetChildren()) do
					local CosData = InventoryHandler:GetCosmeticInfo(v.Id.Value)
					if CosData and v.Id.Value ~= "Default" then
						local ItemTemp = game.ReplicatedStorage.Templates.CraftingItem:Clone()
						ItemTemp.Name = v.Id.Value
						ItemTemp.Rarity.Value = CosData["Rarity"]
						ItemTemp.Copies.Value = v.Copies.Value
						ItemTemp.Type.Value = CosData["Type"]
						ItemTemp.Parent = TradeTemp.Player1.Inventory
					end
				end
				
				for i,v in pairs(P1Data.Inventory.Particles:GetChildren()) do
					local CosData = InventoryHandler:GetCosmeticInfo(v.Id.Value)
					if CosData then
						local ItemTemp = game.ReplicatedStorage.Templates.CraftingItem:Clone()
						ItemTemp.Name = v.Id.Value
						ItemTemp.Rarity.Value = CosData["Rarity"]
						ItemTemp.Copies.Value = v.Copies.Value
						ItemTemp.Type.Value = CosData["Type"]
						ItemTemp.Parent = TradeTemp.Player1.Inventory
					end
				end
				
				--Load Player 2's Data

				for i,v in pairs(P2Data.Inventory.Decorations:GetChildren()) do
					local CosData = InventoryHandler:GetCosmeticInfo(v.Id.Value)
					if CosData then
						local ItemTemp = game.ReplicatedStorage.Templates.CraftingItem:Clone()
						ItemTemp.Name = v.Id.Value
						ItemTemp.Rarity.Value = CosData["Rarity"]
						ItemTemp.Copies.Value = v.Copies.Value
						ItemTemp.Type.Value = CosData["Type"]
						ItemTemp.Parent = TradeTemp.Player2.Inventory
					end
				end

				for i,v in pairs(P2Data.Inventory.Chairs:GetChildren()) do
					local CosData = InventoryHandler:GetCosmeticInfo(v.Id.Value)
					if CosData and v.Id.Value ~= "Default" then
						local ItemTemp = game.ReplicatedStorage.Templates.CraftingItem:Clone()
						ItemTemp.Name = v.Id.Value
						ItemTemp.Rarity.Value = CosData["Rarity"]
						ItemTemp.Copies.Value = v.Copies.Value
						ItemTemp.Type.Value = CosData["Type"]
						ItemTemp.Parent = TradeTemp.Player2.Inventory
					end
				end

				for i,v in pairs(P2Data.Inventory.Particles:GetChildren()) do
					local CosData = InventoryHandler:GetCosmeticInfo(v.Id.Value)
					if CosData then
						local ItemTemp = game.ReplicatedStorage.Templates.CraftingItem:Clone()
						ItemTemp.Name = v.Id.Value
						ItemTemp.Rarity.Value = CosData["Rarity"]
						ItemTemp.Copies.Value = v.Copies.Value
						ItemTemp.Type.Value = CosData["Type"]
						ItemTemp.Parent = TradeTemp.Player2.Inventory
					end
				end
				
			end
			
			P1T.Name = AccepterName
			P2T.Name = Player2Name
			
			local Plr1 = game.Players:FindFirstChild(AccepterName)
			local Plr2 = game.Players:FindFirstChild(Player2Name)
			
			if Plr1 and Plr2 then
				TradeTemp.Parent = game.ReplicatedStorage.Trades
				game.ReplicatedStorage.Remotes.InitializeTrade:FireClient(Plr1,TradeTemp)
				game.ReplicatedStorage.Remotes.InitializeTrade:FireClient(Plr2,TradeTemp)
			else
				TradeTemp:Destroy()
			end
			
		end
		
	end
	
end

function module:AddItemToTrade(TradeFolder,TraderName,ItemName)
	
	local TraderF = TradeFolder:FindFirstChild(TraderName)
	if TraderF then
		
		if TraderF.Confirmed.Value then return end
		
		local InvFind = TraderF.Inventory:FindFirstChild(ItemName)
		if InvFind then
			
			local TradeFind = TraderF.Trading:FindFirstChild(ItemName)
			if TradeFind then
				
				TradeFind.Copies.Value = TradeFind.Copies.Value + 1
				
			else
				
				local NewTrade = InvFind:Clone()
				NewTrade.Copies.Value = 1
				NewTrade.Parent = TraderF.Trading
				
			end
			
			if InvFind.Copies.Value > 1 then
				InvFind.Copies.Value = InvFind.Copies.Value - 1
			else
				InvFind:Destroy()
			end
			
		end
		
		for i,v in pairs(TradeFolder:GetChildren()) do
			local Plr = game.Players:FindFirstChild(v.Name)
			if Plr then
				game.ReplicatedStorage.Remotes.RefreshTrade:FireClient(Plr,TradeFolder)
			end
		end
		
	end
	
end

function module:RemoveItemFromTrade(TradeFolder,TraderName,ItemName)
	
	local TraderF = TradeFolder:FindFirstChild(TraderName)
	if TraderF then
		
		if TraderF.Confirmed.Value then return end

		local InvFind = TraderF.Trading:FindFirstChild(ItemName)
		if InvFind then

			local TradeFind = TraderF.Inventory:FindFirstChild(ItemName)
			if TradeFind then

				TradeFind.Copies.Value = TradeFind.Copies.Value + 1

			else

				local NewTrade = InvFind:Clone()
				NewTrade.Copies.Value = 1
				NewTrade.Parent = TraderF.Inventory

			end

			if InvFind.Copies.Value > 1 then
				InvFind.Copies.Value = InvFind.Copies.Value - 1
			else
				InvFind:Destroy()
			end

		end

		for i,v in pairs(TradeFolder:GetChildren()) do
			local Plr = game.Players:FindFirstChild(v.Name)
			if Plr then
				game.ReplicatedStorage.Remotes.RefreshTrade:FireClient(Plr,TradeFolder)
			end
		end

	end
	
end

function module:CompleteTrade(TradeFolder)
	
	TradeFolder.Canceled.Value = true
	
	local Player1 = nil
	local Player2 = nil
	
	for i,v in pairs(TradeFolder:GetChildren()) do
		if v.Name ~= "Canceled" then
			if Player1 == nil then
				Player1 = v
			elseif Player2 == nil then
				Player2 = v
				break
			end
		end
	end
	
	for i,v in pairs(TradeFolder:GetChildren()) do
		local Plr = game.Players:FindFirstChild(v.Name)
		if Plr then
			game.ReplicatedStorage.Remotes.RefreshTrade:FireClient(Plr,TradeFolder)
		end
	end
	
	if Player1 and Player2 then
		
		local P1Data = Util:GetData(Player1.Name)
		local P2Data = Util:GetData(Player2.Name)
		
		if P1Data and P2Data then
			
			P1Data.SaveLocked.Value = true
			P2Data.SaveLocked.Value = true

			for i,v in pairs(Player1.Trading:GetChildren()) do

				for j = 1,v.Copies.Value do

					if v.Type.Value == "Decor" then
						InventoryHandler:AddDecor(Player2.Name,v.Name)
						InventoryHandler:RemoveDecor(Player1.Name,v.Name)
					elseif v.Type.Value == "Chair" then
						InventoryHandler:AddChair(Player2.Name,v.Name)
						InventoryHandler:RemoveChair(Player1.Name,v.Name)
					elseif v.Type.Value == "Particle" then
						InventoryHandler:AddParticle(Player2.Name,v.Name)
						InventoryHandler:RemoveParticle(Player1.Name,v.Name)
					end

				end

			end

			for i,v in pairs(Player2.Trading:GetChildren()) do

				for j = 1,v.Copies.Value do

					if v.Type.Value == "Decor" then
						InventoryHandler:AddDecor(Player1.Name,v.Name)
						local Val = InventoryHandler:RemoveDecor(Player2.Name,v.Name)
						--print(Val)
					elseif v.Type.Value == "Chair" then
						InventoryHandler:AddChair(Player1.Name,v.Name)
						InventoryHandler:RemoveChair(Player2.Name,v.Name)
					elseif v.Type.Value == "Particle" then
						InventoryHandler:AddParticle(Player1.Name,v.Name)
						InventoryHandler:RemoveParticle(Player2.Name,v.Name)
					end

				end

			end
			
			if InventoryHandler:HasParticle(Player1.Name,InventoryHandler:GetEquippedParticle(Player1.Name)) == false then
				InventoryHandler:UnEquipParticle(Player1.Name)
			end
			
			if InventoryHandler:HasParticle(Player2.Name,InventoryHandler:GetEquippedParticle(Player2.Name)) == false then
				InventoryHandler:UnEquipParticle(Player2.Name)
			end
			
			local EquippedChairP1 = InventoryHandler:GetEquippedChair(Player1.Name)
			if InventoryHandler:HasChair(Player1.Name,EquippedChairP1) == false then
				InventoryHandler:EquipChair(Player1.Name,"Default")
			end
			
			local EquippedChairP2 = InventoryHandler:GetEquippedChair(Player2.Name)
			if InventoryHandler:HasChair(Player2.Name,EquippedChairP2) == false then
				InventoryHandler:EquipChair(Player2.Name,"Default")
			end
			
			P1Data.SaveLocked.Value = false
			P2Data.SaveLocked.Value = false
			
		end
		
	end
	
	for i,v in pairs(TradeFolder:GetChildren()) do
		local Plr = game.Players:FindFirstChild(v.Name)
		if Plr then
			game.ReplicatedStorage.Remotes.TradeNotif:FireClient(Plr,"TRADE COMPLETE","Trade Has Been Completed")
		end
	end
	
	TradeFolder:Destroy()
	
end

function module:ConfirmTrade(TradeFolder,TraderName)
	
	local MeFolder = nil
	local ThemFolder = nil

	for i,v in pairs(TradeFolder:GetChildren()) do
		if v.Name ~= "Canceled" then

			if v.Name == TraderName then
				MeFolder = v
			else
				ThemFolder = v
			end

		end
	end

	if MeFolder and ThemFolder then

		MeFolder.Confirmed.Value = not MeFolder.Confirmed.Value

		if MeFolder.Confirmed.Value == false then
			ThemFolder.Confirmed.Accepted.Value = false
			MeFolder.Confirmed.Accepted.Value = false
		end

		for i,v in pairs(TradeFolder:GetChildren()) do
			if v.Name ~= "Canceled" then
				local Plr = game.Players:FindFirstChild(v.Name)
				if Plr then
					game.ReplicatedStorage.Remotes.RefreshTrade:FireClient(Plr,TradeFolder)
				end
			end
		end

	end
	
end

function module:AcceptTrade(TradeFolder,TraderName)
	
	if TradeFolder.Canceled.Value then return end
	
	local MeFolder = nil
	local ThemFolder = nil

	for i,v in pairs(TradeFolder:GetChildren()) do
		if v.Name ~= "Canceled" then

			if v.Name == TraderName then
				MeFolder = v
			else
				ThemFolder = v
			end

		end
	end

	if MeFolder and ThemFolder and MeFolder.Confirmed.Value and ThemFolder.Confirmed.Value then

		MeFolder.Confirmed.Accepted.Value = not MeFolder.Confirmed.Accepted.Value

		for i,v in pairs(TradeFolder:GetChildren()) do
			if v.Name ~= "Canceled" then
				local Plr = game.Players:FindFirstChild(v.Name)
				if Plr then
					game.ReplicatedStorage.Remotes.RefreshTrade:FireClient(Plr,TradeFolder)
				end
			end
		end
		
		if MeFolder.Confirmed.Value and ThemFolder.Confirmed.Value then
			if MeFolder.Confirmed.Accepted.Value and ThemFolder.Confirmed.Accepted.Value then
				
				self:CompleteTrade(TradeFolder)
				
			end
		end

	end
	
end

function module:CancelTrade(TradeFolder)
	
	TradeFolder.Canceled.Value = true
	
	for i,v in pairs(TradeFolder:GetChildren()) do
		local Plr = game.Players:FindFirstChild(v.Name)
		if Plr then
			game.ReplicatedStorage.Remotes.TradeNotif:FireClient(Plr,"TRADE CANCELLED","Trade Has Been Canceled")
		end
	end
	
	TradeFolder:Destroy()
	
end

return module