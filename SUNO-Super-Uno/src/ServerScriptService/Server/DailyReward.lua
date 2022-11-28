--X_Z

local module = {}

script.Parent:WaitForChild("Util")
script.Parent:WaitForChild("LevelHandler")

local Util = require(script.Parent.Util)
local LevelHandler = require(script.Parent.LevelHandler)

local AwardWaitTime = 86400

function module:CanAward(PlayerName)
	
	local Data = Util:GetData(PlayerName)
	if Data then
		
		if Data.SaveLocked.Value then return false end
		
		local TypeOfAward = "Reset"
		if Data.DailyReward.Time.Value == 0 or os.time() - Data.DailyReward.Time.Value >= AwardWaitTime then
			
			if Data.DailyReward.Time.Value == 0 or (os.time() - Data.DailyReward.Time.Value >= AwardWaitTime and os.time() - Data.DailyReward.Time.Value <= (86400*2)) then
				TypeOfAward = "AddStreak"
			end
			
			return true, TypeOfAward
			
		end
	end
	
	return false
	
end

function module:Award(PlayerName,Anotha)
	
	local Data = Util:GetData(PlayerName)
	if Data then
		
		if Anotha then
			if Data.DailyReward["2ndBuy"].Value == false then
				Data.DailyReward["2ndBuy"].Value = true
			else
				return
			end
		end
		
		local CoinGain = 30 + (Data.DailyReward.Streak.Value*5)
		local XPGain = 35 + ((Data.DailyReward.Streak.Value - 1)*5)
		
		CoinGain = math.clamp(CoinGain,0,100)
		XPGain = math.clamp(XPGain,0,100)
		
		LevelHandler:AddXP(PlayerName,XPGain)
		Util:AddCoins(PlayerName,CoinGain)
		
		local Player = game.Players:FindFirstChild(PlayerName)
		if Player and Anotha == nil then
			game.ReplicatedStorage.Remotes.DailyOpener:FireClient(Player,Data.DailyReward.Streak.Value,CoinGain,XPGain)
		end
		
	end
	
end

function module:DailyReward(PlayerName)
	
	wait(4)
	
	local Data = Util:GetData(PlayerName)
	if Data then
		
		local WillReward, TypeReward = self:CanAward(PlayerName)
		if WillReward then
			
			if TypeReward == "Reset" then
				Data.DailyReward.Streak.Value = 1
			else
				Data.DailyReward.Streak.Value = Data.DailyReward.Streak.Value + 1
			end
			
			Data.DailyReward.Time.Value = os.time()
			Data.DailyReward["2ndBuy"].Value = false
			
			self:Award(PlayerName)
			
		end
		
	end
	
end

return module