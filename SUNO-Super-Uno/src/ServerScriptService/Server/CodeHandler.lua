--X_Z

local DataStoreService = game:GetService("DataStoreService")

local CodeStore = DataStoreService:GetDataStore("CodeStore")

script.Parent:WaitForChild("InventoryHandler")
script.Parent:WaitForChild("Util")

local InvHandler = require(script.Parent.InventoryHandler)
local Util = require(script.Parent.Util)

local module = {}

function module:LoadCodes()
	
	local Loaded = false
	local Msg = nil
	
	warn("Attempting to retrieve codes")
	
	local Codes = nil
	
	local Retries = 0
	
	repeat
		
		Loaded, Msg = pcall(function()
			Codes = CodeStore:GetAsync("Codes")
		end)
		
		if Loaded then
			warn("Codes Successfully Obtained")
			break
		else
			Retries += 1
			warn("Could not load codes retrying #" .. Retries)
		end
		
		wait(6.1)
	until Loaded
	
	return Codes
	
end

function module:RefreshCodes()
	
	game.ReplicatedStorage.Vals.CodesLoaded.Value = false
	
	local Codes = self:LoadCodes()
	
	if Codes == nil then
		warn("No codes available")
	else
		warn("Loading Codes")

		game.ServerStorage.Codes:ClearAllChildren()

		for i,v in pairs(Codes) do

			local Temp = game.ReplicatedStorage.Templates.CodeTemplate:Clone()
			Temp.Name = v["Code"]
			Temp.Expire.Value = v["Expire"]
			Temp.RewardType.Value = v["RewardType"]
			
			if v["RewardType"] == "Coins" then
				Temp.Coins.Value = v["Reward"]
			else
				Temp.ItemGive.Value = v["Reward"]
			end
			
			Temp.Parent = game.ServerStorage.Codes

		end
		
		warn("Codes Fully Finished Loading!")

	end
	
	game.ReplicatedStorage.Vals.CodesLoaded.Value = true
	
end

function module:AddCode(C0de,Expiration,R3wardType,R3ward)
	
	repeat
		wait(1)
	until game.ReplicatedStorage.Vals.CodesLoaded.Value

	local CodeFind = game.ServerStorage.Codes:FindFirstChild(C0de)
	if CodeFind then
		return
	end

	local Codes = self:LoadCodes()

	if Codes == nil then
		Codes = {}
	end

	local CodeTymp = {
		Code = C0de,
		Expire = os.time() + Expiration,
		RewardType = R3wardType,
		Reward = R3ward,
	}

	table.insert(Codes,CodeTymp)

	local Saved = false
	local Msg = nil

	local Retries = 0

	warn("Adding Code")

	repeat

		Saved, Msg = pcall(function()
			CodeStore:SetAsync("Codes",Codes)
		end)

		if Saved then
			warn("Code Successfully Added!")
			break
		else
			Retries += 1
			warn("Code could not be saved retrying #" .. Retries)
		end

		wait(6.1)
	until Saved
	
	self:RefreshCodes()

end

function module:RedeemCode(PlayerName, Code)
	
	local Status = "CODE NOT FOUND"
	
	local NewCode = string.upper(Code)
	
	local CodeRedeemed = false
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		
		for i,v in pairs(Data.RedeemedCodes:GetChildren()) do
			if string.upper(v.Name) == NewCode then
				Status = "CODE ALREADY REDEEMED"
				CodeRedeemed = true
				break
			end
		end
		
		if CodeRedeemed == false then
			
			local Expired = false
			
			for i,v in pairs(game.ServerStorage.Codes:GetChildren()) do
				if string.upper(v.Name) == NewCode then
					
					if v.Expire.Value ~= 0 and os.time() > v.Expire.Value then
						
						Expired = true
						Status = "CODE EXPIRED"
						break
						
					else
						
						Status = "SUCCESSFULLY REDEEMED"
						
						local Val = Instance.new("IntValue")
						Val.Name = NewCode
						Val.Parent = Data.RedeemedCodes
						
						if v.RewardType.Value == "Coins" then
							
							Util:AddCoins(PlayerName,v.Coins.Value,true)
							
						else
							
							local ItemInfo = InvHandler:GetCosmeticInfo(v.ItemGive.Value)
							if ItemInfo ~= "None" then
								if ItemInfo["Type"] == "Decor" then
									InvHandler:AddDecor(PlayerName,v.ItemGive.Value)
								elseif ItemInfo["Type"] == "Particle" then
									InvHandler:AddParticle(PlayerName,v.ItemGive.Value)
								else
									InvHandler:AddChair(PlayerName,v.ItemGive.Value)
								end
							end
							
						end
						
					end
					
				end
			end

		end
		
	end
	
	return Status
	
end

return module