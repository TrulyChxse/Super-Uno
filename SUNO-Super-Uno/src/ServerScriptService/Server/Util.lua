--X_Z

game.ReplicatedStorage:WaitForChild("Modules")
game.ReplicatedStorage.Modules:WaitForChild("CosmeticIndex")

local CosmeticIndex = require(game.ReplicatedStorage.Modules.CosmeticIndex)

local module = {}

local MPS = game:GetService("MarketplaceService")

numberMap = {
	{1000, 'M'},
	{900, 'CM'},
	{500, 'D'},
	{400, 'CD'},
	{100, 'C'},
	{90, 'XC'},
	{50, 'L'},
	{40, 'XL'},
	{10, 'X'},
	{9, 'IX'},
	{5, 'V'},
	{4, 'IV'},
	{1, 'I'}

}

function module:intToRoman(num)
	local roman = ""
	while num > 0 do
		for index,v in pairs(numberMap)do 
			local romanChar = v[2]
			local int = v[1]
			while num >= int do
				roman = roman..romanChar
				num = num - int
			end
		end
	end
	return roman
end

function module:GetCosmeticInfo(CosmeticName)

	for i,v in pairs(CosmeticIndex) do
		if v["Name"] == CosmeticName then
			return v
		end
	end

	return "None"

end

function module:GetData(PlayerName)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		return Data
	end
	
	return nil
	
end

function module:GetCharacter(PlayerName)
	
	local Character = game.Workspace:WaitForChild(PlayerName)
	if Character then
		return Character
	end
	
	return false
	
end

function module:GetRoot(PlayerName)
	
	local Character = self:GetCharacter(PlayerName)
	if Character then
		local Root = Character:WaitForChild("HumanoidRootPart")
		if Root then
			return Root
		end
	end
	
	return false
	
end

function module:HasPass(PlayerName,PassName)
	
	local Data = self:GetData(PlayerName)
	if Data then
		local PassFind = Data.GamePasses:FindFirstChild(PassName)
		if PassFind then
			return PassFind.Value
		end
	end
	
	return false
	
end

function module:PassIdCheck(Player, PassId)
	
	local Successed, Msg = false, nil
	local Owns = false
	
	repeat
		Successed, Msg = pcall(function()
			Owns = MPS:UserOwnsGamePassAsync(Player.UserId, PassId)
		end)
		
		if Successed then
			break
		end
		
		wait(6.1)
	until Successed
	
	return Owns
	
end

function module:GetDisplayName(PlayerName)
	
	local PlayerFind = game.Players:FindFirstChild(PlayerName)
	if PlayerFind then
		return PlayerFind.DisplayName
	end
	
	return PlayerName
	
end

function module:AddCoins(PlayerName,Amount,NoMult)
	
	local Data = self:GetData(PlayerName)
	if Data then
		
		local Multiplier = 1
		
		if self:HasPass(PlayerName,"VIP") then
			Multiplier = 1.5
		end
		
		if NoMult then
			Multiplier = 1
		end
		
		Data.Coins.Value += (Amount*Multiplier)
		
		local PlayerFind = game.Players:FindFirstChild(PlayerName)
		if PlayerFind then
			game.ReplicatedStorage.Remotes.CoinGainPopper:FireClient(PlayerFind,Amount*Multiplier)
		end
		
	end
	
end

function module:IsSavedLocked(PlayerName)
	
	local Data = self:GetData(PlayerName)
	if Data then
		return Data.SaveLocked.Value
	end
	
	return true
	
end

function module:DataNotLoaded(PlayerName)
	
	local Data = self:GetData(PlayerName)
	if Data then
		return not Data.Loaded.Value
	end
	
	return true
	
end

function module:InSession(PlayerName)
	
	local PlrFind = game.ReplicatedStorage.PlayerSessions:FindFirstChild(PlayerName)
	if PlrFind then
		return true
	end
	
	return false
	
end

function module:HasFirstTimePass(Player, FolderValue, PassId)

	if self:HasPass(Player.Name, FolderValue) then return false end

	local Data = self:GetData(Player.Name)
	if Data then
		
		Data:WaitForChild("Loaded")
		
		if Data.Loaded.Value == false then
			repeat
				wait(.1)
			until Data.Loaded.Value
		end
		
		local Valu = Data.GamePasses:FindFirstChild(FolderValue)
		local PassCheck = self:PassIdCheck(Player, PassId)
		if PassCheck and Valu then

			if Data and Data.Parent and Data.Parent ~= nil then
				
				if Data.Loaded.Value then
				
					Valu.Value = true
					return true
				end
				
			end

		end

	end

end

function module:IsTrading(PlayerName)
	
	for i,v in pairs(game.ReplicatedStorage.Trades:GetChildren()) do
		local PlrFind = v:FindFirstChild(PlayerName)
		if PlrFind then
			return true
		end
	end
	
	return false
	
end

function module:GetTradeFolder(PlayerName)
	
	for i,v in pairs(game.ReplicatedStorage.Trades:GetChildren()) do
		local PlrFind = v:FindFirstChild(PlayerName)
		if PlrFind then
			return v
		end
	end
	
	return false
	
end

function module:RefreshCraftingInventory(PlayerName)
	
	local Data = self:GetData(PlayerName)
	if Data then
		
		Data.Crafting.MyStuff:ClearAllChildren()
		Data.Crafting.ToCraft:ClearAllChildren()
		Data.Crafting.CurrentRarity.Value = ""
		
		for i,v in pairs(Data.Inventory.Decorations:GetChildren()) do
			local CosInfo = self:GetCosmeticInfo(v.Id.Value)
			if CosInfo ~= "None" and CosInfo["Rarity"] ~= "Exotic" then
				local CraftT = game.ReplicatedStorage.Templates.CraftingItem:Clone()
				CraftT.Id.Value = v.Id.Value
				CraftT.Name = v.Id.Value
				CraftT.Copies.Value = v.Copies.Value
				CraftT.Rarity.Value = CosInfo["Rarity"]
				CraftT.Type.Value = CosInfo["Type"]
				CraftT.Parent = Data.Crafting.MyStuff
			end
		end
		
		for i,v in pairs(Data.Inventory.Chairs:GetChildren()) do
			local CosInfo = self:GetCosmeticInfo(v.Id.Value)
			if CosInfo ~= "None" and v.Id.Value ~= "Default" and CosInfo["Rarity"] ~= "Exotic"  then
				local CraftT = game.ReplicatedStorage.Templates.CraftingItem:Clone()
				CraftT.Id.Value = v.Id.Value
				CraftT.Name = v.Id.Value
				CraftT.Copies.Value = v.Copies.Value
				CraftT.Rarity.Value = CosInfo["Rarity"]
				CraftT.Type.Value = CosInfo["Type"]
				CraftT.Parent = Data.Crafting.MyStuff
			end
		end
		
		for i,v in pairs(Data.Inventory.Particles:GetChildren()) do
			local CosInfo = self:GetCosmeticInfo(v.Id.Value)
			if CosInfo ~= "None" and v.Id.Value ~= "Default" and CosInfo["Rarity"] ~= "Exotic"  then
				local CraftT = game.ReplicatedStorage.Templates.CraftingItem:Clone()
				CraftT.Id.Value = v.Id.Value
				CraftT.Name = v.Id.Value
				CraftT.Copies.Value = v.Copies.Value
				CraftT.Rarity.Value = CosInfo["Rarity"]
				CraftT.Type.Value = CosInfo["Type"]
				CraftT.Parent = Data.Crafting.MyStuff
			end
		end
		
	end
	
end

return module