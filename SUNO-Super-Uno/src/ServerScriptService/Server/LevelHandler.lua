--X_Z

script.Parent:WaitForChild("Util")
script.Parent:WaitForChild("InventoryHandler")

game.ReplicatedStorage:WaitForChild("Modules")
game.ReplicatedStorage.Modules:WaitForChild("CosmeticIndex")

local Util = require(script.Parent.Util)
local CostmeticIndex = require(game.ReplicatedStorage.Modules.CosmeticIndex)
local InventoryHandler = require(script.Parent.InventoryHandler)

local Rnd = Random.new()

local MessagingService = game:GetService("MessagingService")

local module = {}

function module:GetLevel(PlayerName)
	
	local Data = Util:GetData(PlayerName)
	if Data then
		return Data.LevelData.Level.Value
	end
	
	return 1
	
end

function module:GetPrestige(PlayerName)
	
	local Data = Util:GetData(PlayerName)
	if Data then
		return Data.LevelData.Prestige.Value
	end
	
	return 0
	
end

function module:Prestige(PlayerName)

	local Data = Util:GetData(PlayerName)
	if Data then
		
		if Data.LevelData.Level.Value >= 100 then
			
			Data.LevelData.Prestige.Value = Data.LevelData.Prestige.Value + 1
			Data.LevelData.CurrXP.Value = 0
			Data.LevelData.NeedXP.Value = 50
			Data.LevelData.Level.Value = 1
			
			Util:AddCoins(PlayerName,5000,true)
			
			local Exotics = {}
			
			for i,v in pairs(CostmeticIndex) do
				if v["Rarity"] == "Exotic" then
					table.insert(Exotics,1,v)
				end
			end
			
			local ExoticObtain = Exotics[Rnd:NextInteger(1,#Exotics)]
			if ExoticObtain then
				
				local Player = game.Players:FindFirstChild(PlayerName)
				if Player then
					
					if ExoticObtain["Type"] == "Particle" then
						InventoryHandler:AddParticle(PlayerName,ExoticObtain["Name"])
					elseif ExoticObtain["Type"] == "Chair" then
						InventoryHandler:AddChair(PlayerName,ExoticObtain["Name"])
					else
						InventoryHandler:AddDecor(PlayerName,ExoticObtain["Name"])
					end
					
					game.ReplicatedStorage.Remotes.CrateUnbox:FireClient(Player,"Prestige Crate",ExoticObtain["Name"], "Exotic")
					game.ReplicatedStorage.Remotes.RefreshPrestige:FireAllClients(PlayerName)
					
					MessagingService:PublishAsync("Unboxings",{PlayerName = PlayerName,ItemName = ExoticObtain["Name"],Rarity = "Exotic",From = "PRESTIGE"})
					
					Player:LoadCharacter()
					
				end
				
			end
			
			--Award random exotic
			
			return "Good"
			
		end
		
	end
	
	return "Failed"

end

function module:LevelNameTag(PlayerName)
	
	local Data = Util:GetData(PlayerName)
	local Character = Util:GetCharacter(PlayerName)
	if Character and Data then
		local Head = Character:WaitForChild("Head")
		if Head then

			local oldPb = Head:FindFirstChild("pB")
			if oldPb then
				oldPb:Destroy()
			end

			local newPb = game.ReplicatedStorage.MiscAssets.pB:Clone()
			newPb.Ttl.Text = Util:GetDisplayName(PlayerName)
			newPb.Ttl.Dark.Text = Util:GetDisplayName(PlayerName)
			
			if Data.GamePasses.VIP.Value then
				newPb.Ttl.TextColor3 = Color3.fromRGB(255, 255, 127)
			end

			local LevelString = "LEVEL " .. self:GetLevel(PlayerName)
			local LevelString2 = "LEVEL " .. self:GetLevel(PlayerName)

			local PrestigeNumber = self:GetPrestige(PlayerName)
			if PrestigeNumber > 0 then

				local RomanNumberal = Util:intToRoman(PrestigeNumber)

				local newStr = LevelString

				LevelString = '<font color="rgb(255,255,0)">[' .. RomanNumberal .. "]</font> " .. newStr
				LevelString2 = '<font color="rgb(200,200,0)">[' .. RomanNumberal .. "]</font> " .. newStr
			end

			newPb.LvlTxt.Text = LevelString
			newPb.LvlTxt.Dark.Text = LevelString2

			newPb.Parent = Head

		end
	end

end

function module:AddXP(PlayerName,Amount,NoMult)
	
	local Data = Util:GetData(PlayerName)
	if Data then
		
		if Data.LevelData.Level.Value >= 100 then return end
		
		local Multiplier = 1
		
		if Util:HasPass(PlayerName, "VIP") and not NoMult then
			Multiplier += .5
		end
		
		if Util:HasPass(PlayerName, "x2XP") and not NoMult then
			Multiplier += 1
		end
		
		Data.LevelData.CurrXP.Value += (Amount*Multiplier)
		
		if Data.LevelData.CurrXP.Value >=  Data.LevelData.NeedXP.Value then
			
			local ExtraXP = Data.LevelData.CurrXP.Value - Data.LevelData.NeedXP.Value
			
			Data.LevelData.CurrXP.Value = 0
			Data.LevelData.NeedXP.Value = math.ceil(Data.LevelData.NeedXP.Value*1.053)
			Data.LevelData.Level.Value += 1
			
			self:LevelNameTag(PlayerName)
			
			local PlayerFind = game.Players:FindFirstChild(PlayerName)
			if PlayerFind then
				game.ReplicatedStorage.Remotes.LevelUpPopper:FireClient(PlayerFind)
			end
			
			wait(.5)
			Util:AddCoins(PlayerName,100)
			
			if Data.LevelData.Level.Value >= 100 then
				Data.LevelData.CurrXP.Value = 1
				Data.LevelData.NeedXP.Value = 1
			end
			
			wait(.5)
			
			self:AddXP(PlayerName,ExtraXP,true)
			
		end
		
	end
	
end

return module