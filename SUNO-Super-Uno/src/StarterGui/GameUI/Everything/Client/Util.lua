--X_Z

game.ReplicatedStorage:WaitForChild("Modules")

game.ReplicatedStorage.Modules:WaitForChild("CosmeticIndex")
game.ReplicatedStorage.Modules:WaitForChild("CrateIndex")

local CosmeticIndex = require(game.ReplicatedStorage.Modules.CosmeticIndex)
local CrateIndex = require(game.ReplicatedStorage.Modules.CrateIndex)

local GameUI = script.Parent.Parent

local module = {}

local RarityColors = {
	Common = Color3.fromRGB(125, 125, 125),
	Uncommon = Color3.fromRGB(85, 170, 127),
	Rare = Color3.fromRGB(95, 148, 255),
	Epic = Color3.fromRGB(107, 67, 127),
	Exotic = Color3.fromRGB(255, 209, 115)
}

local TableOfSigns = {

	{
		MinOver = 3,
		MaxUnder = 6,
		Sign = "k"
	},

	{
		MinOver = 6,
		MaxUnder = 9,
		Sign = "M"
	},

	{
		MinOver = 9,
		MaxUnder = 12,
		Sign = "B"
	},

	{
		MinOver = 12,
		MaxUnder = 15,
		Sign = "T"
	},

	{
		MinOver = 15,
		MaxUnder = 18,
		Sign = "Qd"
	},

	{
		MinOver = 18,
		MaxUnder = 21,
		Sign = "Qn"
	},

}

function module:ConvertToShortString(Number)
	if Number < 1000 then return tostring(Number) end

	local NewNS = ""
	local Num = tostring(Number)

	local len = string.len(Num)

	for i,v in pairs(TableOfSigns) do
		if len > v["MinOver"] and len < v["MaxUnder"]+1 then
			local Nums3 = string.sub(Num,1,3)
			local Diff = len % 3--len - (3*i)

			if Diff ~= 0 then

				Nums3 = string.sub(Nums3,1,Diff) .. "." .. string.sub(Nums3,Diff+1)

			end

			NewNS = Nums3 .. v["Sign"]
			break
		end
	end

	return NewNS
end

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

function module:HasPass(PassName)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(GameUI.Parent.Parent.Parent.Name)
	if Data then
		local PassFind = Data.GamePasses:FindFirstChild(PassName)
		if PassFind then
			return PassFind.Value
		end
	end
	
	return false
	
end

function module:GetRarity(ItemName)
	
	for i,v in pairs(CosmeticIndex) do
		if v["Name"] == ItemName then
			return v["Rarity"]
		end
	end
	
	return "Common"
	
end

function module:GetRarityColor(Rarity)
	
	local RarCol = RarityColors[Rarity]
	if RarCol then
		return RarCol
	end
	
	return RarityColors["Common"]
	
end

function module:GetEquippedParticle()
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(GameUI.Parent.Parent.Name)
	if Data then
		return Data.Equips.Particle.Value
	end
	
	return "None"
	
end

function module:GetCrateInfo(CrateName)
	
	for i,v in pairs(CrateIndex) do
		if v["Name"] == CrateName then
			return v
		end
	end
	
	return nil
end

return module