--X_Z

game.ReplicatedStorage:WaitForChild("Modules")
game.ReplicatedStorage.Modules:WaitForChild("CosmeticIndex")

script.Parent:WaitForChild("Util")
script.Parent:WaitForChild("InventoryHandler")

local Util = require(script.Parent.Util)
local InventoryHandler = require(script.Parent.InventoryHandler)
local CosmeticIndex = require(game.ReplicatedStorage.Modules.CosmeticIndex)

local Rnd = Random.new()

local MessagingService = game:GetService("MessagingService")

local module = {}

function module:GetRequiredAmount(PlayerName)
	
	if Util:HasPass(PlayerName,"ReducedCrafting") then
		return 5
	end
	
	return 7
	
end

function module:GetCraftCount(PlayerName)
	
	local Count = 0
	
	local Data = Util:GetData(PlayerName)
	if Data then
		for i,v in pairs(Data.Crafting.ToCraft:GetChildren()) do
			Count += v.Copies.Value
		end
	end
	
	return Count
	
end

function module:GetNextRarity(CurrentRarity)
	
	if CurrentRarity == "Common" then
		return "Uncommon"
	elseif CurrentRarity == "Uncommon" then
		return "Rare"
	elseif CurrentRarity == "Rare" then
		return "Epic"
	elseif CurrentRarity == "Epic" then
		return "Exotic"	
	end
	
	return "Common"
	
end

function module:GetPossibleTypes(PlayerName)
	
	local Data = Util:GetData(PlayerName)
	if Data then
		
		Data.Crafting.PossibleTypes:ClearAllChildren()
		
		for i,v in pairs(Data.Crafting.ToCraft:GetChildren()) do
			local TypeFind = Data.Crafting.PossibleTypes:FindFirstChild(v.Type.Value)
			if TypeFind == nil then
				local Int = Instance.new("IntValue")
				Int.Name = v.Type.Value
				Int.Parent = Data.Crafting.PossibleTypes
			end
		end
		
	end
	
end

function module:AddItem(PlayerName,ItemName)
	
	if self:GetCraftCount(PlayerName) >= self:GetRequiredAmount(PlayerName) then return "Failed" end
	
	local Data = Util:GetData(PlayerName)
	if Data then
		local ItemFind = Data.Crafting.MyStuff:FindFirstChild(ItemName)
		if ItemFind then
			
			local CurrentItems = self:GetCraftCount(PlayerName)
			if CurrentItems == 0 then
				
				Data.Crafting.CurrentRarity.Value = ItemFind.Rarity.Value
				
				for i,v in pairs(Data.Crafting.MyStuff:GetChildren()) do
					if v.Rarity.Value ~= Data.Crafting.CurrentRarity.Value then
						v:Destroy()
					end
				end

			end
			
			local CraftFind = Data.Crafting.ToCraft:FindFirstChild(ItemName)
			if CraftFind then
				
				CraftFind.Copies.Value = CraftFind.Copies.Value + 1
				
			else
				
				local NewTemp = ItemFind:Clone()
				NewTemp.Copies.Value = 1
				NewTemp.Parent = Data.Crafting.ToCraft
				
			end
			
			if ItemFind.Copies.Value <= 1 then
				ItemFind:Destroy()
			else
				ItemFind.Copies.Value = ItemFind.Copies.Value - 1
			end
			
			return "Good"
			
		end
	end
	
	return "Failed"
	
end

function module:RemoveItem(PlayerName,ItemName)
	
	local Data = Util:GetData(PlayerName)
	if Data then
		local ItemFind = Data.Crafting.ToCraft:FindFirstChild(ItemName)
		if ItemFind then
			
			local MyFind = Data.Crafting.MyStuff:FindFirstChild(ItemName)
			if MyFind then
				MyFind.Copies.Value = MyFind.Copies.Value + 1
			else
				
				local NewTemp = ItemFind:Clone()
				NewTemp.Copies.Value = 1
				NewTemp.Parent = Data.Crafting.MyStuff
				
			end
			
			if ItemFind.Copies.Value <= 1 then
				ItemFind:Destroy()
			else
				ItemFind.Copies.Value = ItemFind.Copies.Value - 1
			end
			
			local CurrentItems = self:GetCraftCount(PlayerName)
			if CurrentItems == 0 then
				Util:RefreshCraftingInventory(PlayerName)
			end
			
			return "Good"
			
		end
	end
	
	return "Failed"
	
end

function module:Craft(PlayerName)
	
	if self:GetCraftCount(PlayerName) >= self:GetRequiredAmount(PlayerName) then
		
		self:GetPossibleTypes(PlayerName)
		
		local Data = Util:GetData(PlayerName)
		if Data then
			
			if Data.Crafting.Crafting.Value then return end
			
			Data.Crafting.Crafting.Value = true
			
			local NewItems = {}
			
			local ToCrafts = Data.Crafting.ToCraft:GetChildren()
			local NextRarity = self:GetNextRarity(Data.Crafting.CurrentRarity.Value)
			
			for i,v in pairs(CosmeticIndex) do
				if v["Rarity"] == NextRarity and Data.Crafting.PossibleTypes:FindFirstChild(v["Type"]) and v["Name"] ~= "Default" and v["NotCraftable"] == nil then
					table.insert(NewItems,1,v)
				end
			end
			
			local NewAward = NewItems[Rnd:NextInteger(1,#NewItems)]
			
			for i,v in pairs(ToCrafts) do
				if v.Type.Value == "Decor" then
					for i = 1,v.Copies.Value do
						InventoryHandler:RemoveDecor(PlayerName,v.Name,true)
					end
				elseif v.Type.Value == "Chair" then
					for i = 1,v.Copies.Value do
						InventoryHandler:RemoveChair(PlayerName,v.Name,true)
					end
				elseif v.Type.Value == "Particle" then
					for i = 1,v.Copies.Value do
						InventoryHandler:RemoveParticle(PlayerName,v.Name,true)
					end
				end
			end
			
			if NewAward["Type"] == "Decor" then
				InventoryHandler:AddDecor(PlayerName,NewAward["Name"])
			elseif NewAward["Type"] == "Chair" then
				InventoryHandler:AddChair(PlayerName,NewAward["Name"])
			elseif NewAward["Type"] == "Particle" then
				InventoryHandler:AddParticle(PlayerName,NewAward["Name"])
			end
			
			if InventoryHandler:HasParticle(PlayerName,InventoryHandler:GetEquippedParticle(PlayerName)) == false then
				InventoryHandler:UnEquipParticle(PlayerName)
			end
			
			if InventoryHandler:HasChair(PlayerName,InventoryHandler:GetEquippedChair(PlayerName)) == false then
				InventoryHandler:EquipChair(PlayerName,"Default")
			end
			
			local Player = game.Players:FindFirstChild(PlayerName)
			if Player then
				game.ReplicatedStorage.Remotes.CrateUnbox:FireClient(Player,"Crafting Crate",NewAward["Name"],NextRarity)
			end
			
			spawn(function()
				
				wait(4)
				
				local NoErrors, Msg = false, nil
				
				repeat
					
					NoErrors, Msg = pcall(function()
						MessagingService:PublishAsync("Unboxings",{PlayerName = PlayerName,ItemName = NewAward["Name"],Rarity = NextRarity,From = "CRAFTING"})
					end)
					
					if NoErrors then
						break
					end
					
					wait(10)
					
				until NoErrors
			end)
			
			Util:RefreshCraftingInventory(PlayerName)
			
			Data.Crafting.Crafting.Value = false
			
			return "Good"
			
		end
		
	end
	
	return "Failed"
	
end

return module