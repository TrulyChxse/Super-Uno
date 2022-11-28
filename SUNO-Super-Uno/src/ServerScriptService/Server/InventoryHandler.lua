--X_Z

script.Parent:WaitForChild("Util")

local Util = require(script.Parent.Util)

local TextService = game:GetService("TextService")
local MessagingService = game:GetService("MessagingService")

game.ReplicatedStorage:WaitForChild("Modules")
game.ReplicatedStorage.Modules:WaitForChild("CosmeticIndex")
game.ReplicatedStorage.Modules:WaitForChild("CrateIndex")

local CosmeticIndex = require(game.ReplicatedStorage.Modules.CosmeticIndex)
local CrateIndex = require(game.ReplicatedStorage.Modules.CrateIndex)

local Rnd = Random.new()

local module = {}

function module:GetCosmeticInfo(CosmeticName)
	
	for i,v in pairs(CosmeticIndex) do
		if v["Name"] == CosmeticName then
			return v
		end
	end
	
	return "None"
	
end

function module:HasGamepass(PlrName,PassName)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlrName)
	if Data then
		local PassFind = Data.GamePasses:FindFirstChild(PassName)
		if PassFind then
			return PassFind.Value
		end
	end
	
	return false
	
end

function module:HasChair(PlayerName,ChairName)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		for i,v in pairs(Data.Inventory.Chairs:GetChildren()) do
			if v.Id.Value == ChairName then
				return true
			end
		end
	end

	return false
	
end

function module:HasParticle(PlayerName,ParticleName)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		for i,v in pairs(Data.Inventory.Particles:GetChildren()) do
			if v.Id.Value == ParticleName then
				return true
			end
		end
	end

	return false
	
end

function module:HasDecorInInventory(PlayerName,DecorName)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		for i,v in pairs(Data.Inventory.Decorations:GetChildren()) do
			if v.Id.Value == DecorName then
				return true
			end
		end
	end
	
	return false
	
end

function module:GetEquippedParticle(PlayerName)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		return Data.Equips.Particle.Value
	end
	
	return "None"
	
end

function module:GetEquippedChair(PlayerName)

	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		return Data.Equips.Chair.Value
	end

	return "Default"

end


function module:ArenaParticleFix(PlayerName,ParticleName)
	
	for i,v in pairs(game.Workspace.Arenas:GetChildren()) do
		local CharFind = v:FindFirstChild(PlayerName)
		if CharFind then
			local Root = CharFind:FindFirstChild("HumanoidRootPart")
			if Root then
				
				local ParticleOld = Root:FindFirstChild("Particle")
				if ParticleOld then
					ParticleOld:Destroy()
				end
				
				local NewParticle = game.ReplicatedStorage.Cosmetics.Particles:FindFirstChild(ParticleName)
				if NewParticle then
					local particleClone = NewParticle:Clone()
					particleClone.Name = "Particle"
					particleClone.Parent = Root
				end
				
				break
				
			end
			
		end
	end
	
end

function module:ArenaDecorFix(PlayerName,SlotNum,DecorName)
	
	for i,v in pairs(game.Workspace.Arenas:GetChildren()) do
		local CharFind = v:FindFirstChild(PlayerName)
		if CharFind then
			
			local DecorzFind = CharFind:FindFirstChild("DecorSlots")
			local CosFind = v:FindFirstChild(PlayerName .. "|Cosmetics")
			if CosFind and DecorzFind then
				local SlotP = DecorzFind:FindFirstChild("Slot" .. SlotNum)
				local OldDecor = CosFind.Decor:FindFirstChild("Slot" .. SlotNum)
				if SlotP then
					
					if OldDecor then
						OldDecor:Destroy()
					end
					
					local DecorFind = game.ReplicatedStorage.Cosmetics.Decorations:FindFirstChild(DecorName)
					if DecorFind then
						local DecorClone = DecorFind:Clone()
						DecorClone.Name = "Slot" .. SlotNum
						DecorClone.Parent = CosFind.Decor
						DecorClone:SetPrimaryPartCFrame(SlotP.CFrame*CFrame.Angles(0,math.rad(90),0))
						
						break
					end
					
				end
			end
			
		end
	end
	
end

function module:ArenaChairFix(PlayerName,ChairName)
	
	for i,v in pairs(game.Workspace.Arenas:GetChildren()) do
		local CharFind = v:FindFirstChild(PlayerName)
		if CharFind then
			
			local DecorzFind = CharFind:FindFirstChild("DecorSlots")
			local CosFind = v:FindFirstChild(PlayerName .. "|Cosmetics")
			local SeatFind = v:FindFirstChild(PlayerName .. "|Seat")
			if CosFind and DecorzFind and SeatFind then
				
				local OldChair = CosFind:FindFirstChild("Chair")
				if OldChair then
					OldChair:Destroy()
				end
				
				local NewChair = game.ReplicatedStorage.Cosmetics.Chairs:FindFirstChild(ChairName)
				if NewChair then
					
					local ChairClone = NewChair:Clone()
					ChairClone.Name = "Chair"
					ChairClone.Parent = CosFind
					ChairClone:SetPrimaryPartCFrame(SeatFind.CFrame)
					
					break
					
				end
				
			end

		end
	end
	
end

function module:AddDecor(PlayerName,DecorName)
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		
		local FoundFold = false
		
		for i,v in pairs(Data.Inventory.Decorations:GetChildren()) do
			if v.Id.Value == DecorName then
				v.Copies.Value = v.Copies.Value + 1
				FoundFold = true
				break
			end
		end
		
		if not FoundFold then
			local CosClone = game.ReplicatedStorage.Templates.CosmeticTemplate:Clone()
			CosClone.Name = "Decor"
			CosClone.Id.Value = DecorName
			CosClone.Copies.Value = 1
			CosClone.Parent = Data.Inventory.Decorations
		end
		
		Util:RefreshCraftingInventory(PlayerName)
		
	end
end

function module:AddChair(PlayerName,DecorName)
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then

		local FoundFold = false

		for i,v in pairs(Data.Inventory.Chairs:GetChildren()) do
			if v.Id.Value == DecorName then
				v.Copies.Value = v.Copies.Value + 1
				FoundFold = true
				break
			end
		end

		if not FoundFold then
			local CosClone = game.ReplicatedStorage.Templates.CosmeticTemplate:Clone()
			CosClone.Name = "Chair"
			CosClone.Id.Value = DecorName
			CosClone.Copies.Value = 1
			CosClone.Parent = Data.Inventory.Chairs
		end
		
		Util:RefreshCraftingInventory(PlayerName)
		
	end
end

function module:AddParticle(PlayerName,DecorName)
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then

		local FoundFold = false

		for i,v in pairs(Data.Inventory.Particles:GetChildren()) do
			if v.Id.Value == DecorName then
				v.Copies.Value = v.Copies.Value + 1
				FoundFold = true
				break
			end
		end

		if not FoundFold then
			local CosClone = game.ReplicatedStorage.Templates.CosmeticTemplate:Clone()
			CosClone.Name = "Particle"
			CosClone.Id.Value = DecorName
			CosClone.Copies.Value = 1
			CosClone.Parent = Data.Inventory.Particles
		end
		
		Util:RefreshCraftingInventory(PlayerName)

	end
end

function module:RemoveDecor(PlayerName,DecorName,NoRe)
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		--print(1)
		for i,v in pairs(Data.Inventory.Decorations:GetChildren()) do
			if v.Id.Value == DecorName then
				--print(2)
				if v.Copies.Value > 1 then
					v.Copies.Value  = v.Copies.Value - 1
				else
					v:Destroy()
				end
				if NoRe == nil then
					Util:RefreshCraftingInventory(PlayerName)
				end
				return true
			end
		end
		
	end
	return false
end

function module:RemoveChair(PlayerName,DecorName,NoRe)
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then

		for i,v in pairs(Data.Inventory.Chairs:GetChildren()) do
			if v.Id.Value == DecorName then
				if v.Copies.Value > 1 then
					v.Copies.Value  = v.Copies.Value - 1
				else
					v:Destroy()
				end
				if NoRe == nil then
					Util:RefreshCraftingInventory(PlayerName)
				end
				return true
			end
		end

	end
	return false
end

function module:RemoveParticle(PlayerName,DecorName,NoRe)
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then

		for i,v in pairs(Data.Inventory.Particles:GetChildren()) do
			if v.Id.Value == DecorName then
				if v.Copies.Value > 1 then
					v.Copies.Value  = v.Copies.Value - 1
				else
					v:Destroy()
				end
				if NoRe == nil then
					Util:RefreshCraftingInventory(PlayerName)
				end
				return true
			end
		end

	end
	return false
end

function module:EquipDecor(PlayerName,Slot,DecorName)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data and self:HasDecorInInventory(PlayerName,DecorName) then
		
		if (Slot == 1 or Slot == 4) and not self:HasGamepass(PlayerName,"MoreSlots") then return end
		
		local SlotFind = Data.Equips.Decorations:FindFirstChild("Slot" .. Slot)
		
		if SlotFind then
			
			if SlotFind.Value == DecorName then return "Bad" end
			
			if SlotFind.Value ~= "None" then
				self:AddDecor(PlayerName,SlotFind.Value)
				SlotFind.Value = "None"
			end
			
			local Remmed = self:RemoveDecor(PlayerName,DecorName)
			if Remmed  then
				SlotFind.Value = DecorName
				
				self:ArenaDecorFix(PlayerName,Slot,DecorName)

				return "Good"
			end
			
		end
	end
	
	return "Bad"
	
end

function module:UnEquipDecor(PlayerName,Slot)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		local SlotFind = Data.Equips.Decorations:FindFirstChild("Slot" .. Slot)
		if SlotFind then
			if SlotFind.Value ~= "None" then
				
				self:AddDecor(PlayerName,SlotFind.Value)
				
				SlotFind.Value = "None"
				
				self:ArenaDecorFix(PlayerName,Slot,"None")
				
				return "Good"
				
			end
		end
	end
	
	return "Bad"
	
end

function module:EquipChair(PlayerName,ChairName)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		if self:HasChair(PlayerName,ChairName) == false or Data.Equips.Chair.Value == ChairName then return "Bad" end
		
		Data.Equips.Chair.Value = ChairName
		
		self:ArenaChairFix(PlayerName,ChairName)
		
		return "Good"
	end
	
	return "Bad"
	
end

function module:UnEquipCharacterParticle(PlayerName)
	
	local Root = Util:GetRoot(PlayerName)
	if Root then
		local Particle = Root:FindFirstChild("Particle")
		if Particle then
			Particle:Destroy()
		end
	end
	
end

function module:EquipCharacterParticle(PlayerName,ParticleName)
	
	self:UnEquipCharacterParticle(PlayerName)
	
	local Root = Util:GetRoot(PlayerName)
	if Root and self:HasParticle(PlayerName,ParticleName) then
		
		local ParticleFind = game.ReplicatedStorage.Cosmetics.Particles:FindFirstChild(ParticleName)
		if ParticleFind then
			
			local ParticleClone = ParticleFind:Clone()
			ParticleClone.Name = "Particle"
			ParticleClone.Parent = Root
		end
		
	end
	
end

function module:EquipParticle(PlayerName,ParticleName)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		if self:HasParticle(PlayerName,ParticleName) == false then return "Bad" end

		Data.Equips.Particle.Value = ParticleName
		
		self:EquipCharacterParticle(PlayerName,ParticleName)
		self:ArenaParticleFix(PlayerName,ParticleName)

		return "Good"
	end

	return "Bad"
	
end

function module:UnEquipParticle(PlayerName)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		if Data.Equips.Particle.Value == "None" then return "Bad" end
		
		Data.Equips.Particle.Value = "None"
		
		self:ArenaParticleFix(PlayerName,"None")
		self:UnEquipCharacterParticle(PlayerName)
		
		return "Good"
	end

	return "Bad"
	
end

function module:GetMaxDecks(PlayerName)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		if self:HasGamepass(PlayerName,"MoreDecks") then
			return 20
		end
	end
	
	return 5
	
end

function module:CreateDeck(PlayerName)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		local Decks = Data.Inventory.Decks:GetChildren()
		local DeckCount = #Decks
		if DeckCount < self:GetMaxDecks(PlayerName) then
			
			local NewCount = 1
			
			local DeckF = Instance.new("Folder")
			DeckF.Name = "Deck #" .. NewCount
			
			local NameDone = false
			
			repeat
				local SameNameFind = Data.Inventory.Decks:FindFirstChild(DeckF.Name)
				if SameNameFind then
					NewCount += 1
					DeckF.Name = "Deck #" .. NewCount
				else
					NameDone = true
				end
			until NameDone
			
			DeckF.Parent = Data.Inventory.Decks
			
			return "Good",DeckF.Name
			
		end
	end
	
	return "Bad"
end

function module:DeleteDeck(PlayerName,DeckName)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		local DeckFind = Data.Inventory.Decks:FindFirstChild(DeckName)
		if DeckFind then
			DeckFind:Destroy()
			return "Good"
		end
	end
	
	return "Bad"
	
end

function module:ReNameDeck(PlayerName,DeckName,NewName)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		local DeckFind = Data.Inventory.Decks:FindFirstChild(DeckName)
		if DeckFind then
			
			local FilteredResult = TextService:FilterStringAsync(NewName,23441688)
			local FilterRes = FilteredResult:GetNonChatStringForBroadcastAsync()
			
			if FilterRes ~= NewName then
				return "Filtered"
			else
				
				local SameName = Data.Inventory.Decks:FindFirstChild(NewName)
				if SameName then
					
					local DisName = NewName
					
					local NameCount = 1
					
					local Named = false
					
					repeat
						NameCount += 1
						
						DisName = NewName .. " #" .. NameCount
						
						local NextFind = Data.Inventory.Decks:FindFirstChild(DisName)
						if NextFind then
							--
						else
							Named = true
						end
						
					until Named
					
					DeckFind.Name = DisName
					return "Good",DisName
					
				else
					
					DeckFind.Name = NewName
					return "Good",NewName
					
				end
				
			end
			
		end
	end
	
	return "Bad"
	
end

function module:RefreshCardNames(PlayerName,DeckName)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		local DeckFind = Data.Inventory.Decks:FindFirstChild(DeckName)
		if DeckFind then
			
			for i,v in pairs(DeckFind:GetChildren()) do
				
				local NextNum = i + 1
				
				local CardF = DeckFind:FindFirstChild("Card" .. NextNum)
				if CardF then
					if i then
						
						local PrevNum = NextNum - 1
						
						local PrevCard = DeckFind:FindFirstChild("Card" .. PrevNum)
						
						if PrevCard == nil then
							CardF.Name = "Card" .. PrevNum
						end
						
					end
				end
				
			end
			
		end
	end
	
end

function module:DeleteCard(PlayerName,DeckName,CardName)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		local DeckFind = Data.Inventory.Decks:FindFirstChild(DeckName)
		if DeckFind then
			
			--So the order isnt messed up
			local Cards = DeckFind:GetChildren()
			
			local CardFind = DeckFind:FindFirstChild(CardName)
			if CardFind then
				CardFind:Destroy()
				self:RefreshCardNames(PlayerName,DeckName)
			end
		end
	end
	
end

function module:IsWhiteListedColor(Color)
	
	for i,v in pairs(game.ReplicatedStorage.Vals.WhiteListedColors:GetChildren()) do
		if v.Value == Color then
			return true
		end
	end
	
	return false
	
end

function module:FixColors(ColorTable)
	
	local RemmedOnce = false
	local Fixed = true
	
	repeat
		
		Fixed = true
		
		for i,v in pairs(ColorTable) do
			if typeof(v) == nil or typeof(v) ~= "Color3" then
				table.remove(ColorTable,i)
				Fixed = false
				break
			else
				if not self:IsWhiteListedColor(v) then
					table.remove(ColorTable,i)
					Fixed = false
					break
				end
			end
		end
		
	until Fixed
	
	return ColorTable
	
end

function module:AddCardToDeck(PlayerName,DeckName,Type,Color,Class)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		local Deck = Data.Inventory.Decks:FindFirstChild(DeckName)
		if Deck then
			
			local CardCount = #Deck:GetChildren()
			
			if CardCount >= 250 then return end
			
			local CardF = game.ReplicatedStorage.Templates.CardTemplate:Clone()
			CardF.Class.Value = Class
			CardF.Color.Value = Color
			CardF.Type.Value = Type
			
			local Cerdz = Deck:GetChildren()
			
			local NextNum = #Cerdz + 1
			
			CardF.Name = "Card" .. NextNum
			CardF.Parent = Deck
			
		end
	end
	
end

function module:MultiAddCards(PlayerName,DeckName,Colors,Cards,Filters)
	
	--print(#Colors)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		local Deck = Data.Inventory.Decks:FindFirstChild(DeckName)
		if Deck then
			
			local FixedColors = self:FixColors(Colors)
			
			--print(#FixedColors)
			
			for i,v in pairs(Cards) do
				
				local CardSettings = Filters[v]
				if CardSettings then
					
					local Amount = 1
					
					if typeof(CardSettings["Amount"]) == "number" then
						Amount = math.clamp(CardSettings["Amount"],1,99)
					end
					
					local To = 1
					local From = 1
					
					if typeof(CardSettings["From"]) == "number" then

						local Min = 1
						local Max = 99

						if v == "Number" then
							Min = 0
							Max = 999
						end

						From = math.clamp(CardSettings["From"],Min,Max)

					end
					
					if typeof(CardSettings["To"]) == "number" then

						local Min = 1
						local Max = 99

						if v == "Number" then
							Min = 0
							Max = 999
						end

						To = math.clamp(CardSettings["To"],From,Max)

					end
					
					
					if v == "Wild" or v == "Wild Draw" then

						for j = 1,Amount do
							
							if v == "Wild Draw" then
								for h = From,To do
									self:AddCardToDeck(PlayerName,DeckName,v,Color3.fromRGB(0,0,0),h)
								end
							else
								self:AddCardToDeck(PlayerName,DeckName,v,Color3.fromRGB(0,0,0),"")
							end
							
						end

					else

						for a,b in pairs(FixedColors) do
							
							for j = 1,Amount do
								if v == "Number" or v == "Draw" or v == "Targeted Draw" then
									for h = From,To do
										self:AddCardToDeck(PlayerName,DeckName,v,b,h)
									end
								else
									self:AddCardToDeck(PlayerName,DeckName,v,b,"")
								end
							end
							
						end

					end
					
				end
				
			end
			
		end
	end
	
end

function module:MultiRemoveCards(PlayerName,DeckName,Colors,Cards,Filters)

	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
	if Data then
		local Deck = Data.Inventory.Decks:FindFirstChild(DeckName)
		if Deck then
			
			local FixedColors = self:FixColors(Colors)
			
			if #FixedColors >= 1 and #Cards >= 1 then
				
				for i,v in pairs(Cards) do
					
					local CardSettings = Filters[v]
					if CardSettings then
						
						local To = 1
						local From = 1

						if typeof(CardSettings["From"]) == "number" then

							local Min = 1
							local Max = 99

							if v == "Number" then
								Min = 0
								Max = 999
							end

							From = math.clamp(CardSettings["From"],Min,Max)

						end

						if typeof(CardSettings["To"]) == "number" then

							local Min = 1
							local Max = 99

							if v == "Number" then
								Min = 0
								Max = 999
							end

							To = math.clamp(CardSettings["To"],From,Max)

						end
						
						if v == "Wild" or v == "Wild Draw" then
							
							for c,d in pairs(Deck:GetChildren()) do
								if d.Type.Value == v then
									if v == "Wild Draw" then
										
										local Number = tonumber(d.Class.Value)
										
										if Number and (Number >= From and Number <= To) then
											self:DeleteCard(PlayerName,DeckName,d.Name)
										end
									else
										self:DeleteCard(PlayerName,DeckName,d.Name)
									end
								end
							end
							
						else
							
							for e,f in pairs(FixedColors) do
								for c,d in pairs(Deck:GetChildren()) do
									if d.Type.Value == v and d.Color.Value == f then
										if v == "Targeted Draw" or v == "Draw" or v == "Number" then

											local Number = tonumber(d.Class.Value)

											if Number and (Number >= From and Number <= To) then
												self:DeleteCard(PlayerName,DeckName,d.Name)
											end
										else
											self:DeleteCard(PlayerName,DeckName,d.Name)
										end
									end
								end
							end

						end
						
					end
					
				end
				
			--Remove By Color
			elseif #FixedColors >= 1 and #Cards == 0 then
				
				for i,v in pairs(FixedColors) do
					
					for a,b in pairs(Deck:GetChildren()) do
						if b.Color.Value == v then
							self:DeleteCard(PlayerName,DeckName,b.Name)
						end
					end
					
				end
				
			--Remove By Card Type
			elseif #Cards >= 1 and #FixedColors == 0 then
				
				for i,v in pairs(Cards) do

					local CardSettings = Filters[v]
					if CardSettings then
						
						local To = 1
						local From = 1

						if typeof(CardSettings["From"]) == "number" then

							local Min = 1
							local Max = 99

							if v == "Number" then
								Min = 0
								Max = 999
							end

							From = math.clamp(CardSettings["From"],Min,Max)

						end

						if typeof(CardSettings["To"]) == "number" then

							local Min = 1
							local Max = 99

							if v == "Number" then
								Min = 0
								Max = 999
							end

							To = math.clamp(CardSettings["To"],From,Max)

						end
						
						for c,d in pairs(Deck:GetChildren()) do
							if d.Type.Value == v then
								if v == "Targeted Draw" or v == "Draw" or v == "Number" or v == "Wild Draw" then

									local Number = tonumber(d.Class.Value)

									if Number and (Number >= From and Number <= To) then
										self:DeleteCard(PlayerName,DeckName,d.Name)
									end
								else
									self:DeleteCard(PlayerName,DeckName,d.Name)
								end
							end
						end
						
					end
					
				end
				
			end

		end
	end

end

function module:GetCrateInfo(CaseName)
	
	for i,v in pairs(CrateIndex) do
		if v["Name"] == CaseName then
			return v
		end
	end
	
	return nil
	
end

function module:OpenCase(PlayerName,CaseName)
	
	local Data = Util:GetData(PlayerName)
	if Data then
		
		local CrateInfo = self:GetCrateInfo(CaseName)
		if CrateInfo then
			
			if Data.Coins.Value >= CrateInfo["Cost"] then
				Data.Coins.Value -= CrateInfo["Cost"]
				
				local RarityRoll = Rnd:NextInteger(CrateInfo["MinRoll"],CrateInfo["MaxRoll"])
				
				for i,v in pairs(CrateInfo["Rarities"]) do
					local RarTable = CrateInfo["Skins"][v]
					if RarTable then
						
						if RarityRoll >= RarTable["MinR"] and RarityRoll <= RarTable["MaxR"] then
							
							local SkinObtain = RarTable["Skins"][Rnd:NextInteger(1,#RarTable["Skins"])]
							local ItemInfo = self:GetCosmeticInfo(SkinObtain)
							if ItemInfo then
								
								if ItemInfo["Type"] == "Decor" then
									self:AddDecor(PlayerName,SkinObtain)
								elseif ItemInfo["Type"] == "Chair" then
									self:AddChair(PlayerName,SkinObtain)
								else
									self:AddParticle(PlayerName,SkinObtain)
								end
								
								spawn(function()
									
									wait(3)
									
									local NoError, Msg = false, nil
									
									repeat
										
										NoError, Msg = pcall(function()
											MessagingService:PublishAsync("Unboxings",{PlayerName = PlayerName,ItemName = SkinObtain,Rarity = v,From = "CRATE"})
										end)
										
										if NoError then
											break
										end
										
										wait(5)
										
									until NoError
									
								end)
								
								local PlrFind = game.Players:FindFirstChild(PlayerName)
								if PlrFind then
									game.ReplicatedStorage.Remotes.CrateUnbox:FireClient(PlrFind, CaseName, SkinObtain, v)
								end
								
								return "Good"
								
							end
							
						end
						
					end
				end
				
			end
			
		end
		
	end
	
	return "Failed"
	
end

return module