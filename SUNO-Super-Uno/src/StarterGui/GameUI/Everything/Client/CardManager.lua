--X_Z

script.Parent.Parent.Parent.Parent:WaitForChild("RealGame")

local GameUI = script.Parent.Parent.Parent.Parent.RealGame

local TweenService = game:GetService("TweenService")

local TI1 = TweenInfo.new(.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)

local MaxSizeContraint = 10

function NumberStep(Start,End,Step)
	local Numbers = {Start}

	local Distance = math.abs(End-Start)
	
	local Increment = Distance/(Step-1)

	local CurrIncre = Start

	for i = 1,Step-2 do
		CurrIncre = CurrIncre + Increment
		table.insert(Numbers,#Numbers+1,CurrIncre)
		--table.insert(Numbers,#Numbers+1,i*Increment)
	end

	table.insert(Numbers,#Numbers+1,End)
	return Numbers,Increment
end

local module = {}

function module:ArrangeColor(Cards)
	
	local ArrangedCards = {}
	
	--Number Sort
	for i,v in pairs(Cards) do
		if v.Data.Type.Value == "Number" and v.Data.Color.Value ~= Color3.fromRGB(0,0,0) then
			if #ArrangedCards == 0 then
				table.insert(ArrangedCards,1,v)
			else

				local Placed = false

				for a,b in pairs(ArrangedCards) do

					local NextCard = ArrangedCards[a+1]

					if NextCard == nil then
						--NextCard = b
					end

					if v.Data.Color.Value == b.Data.Color.Value then

						if v.Data.Type.Value == b.Data.Type.Value then

							if v.Data.Type.Value == "Number" then

								local CurrNum = tonumber(v.Data.Class.Value)
								local SortNum = tonumber(b.Data.Class.Value)

								if (CurrNum <= SortNum) then
									--print("Same Spot: " .. CurrNum .. " " .. SortNum)
									Placed = true
									table.insert(ArrangedCards,a,v)
									break
								elseif (CurrNum > SortNum and NextCard == nil) or (CurrNum > SortNum and NextCard and (NextCard.Data.Color.Value ~= v.Data.Color.Value or NextCard.Data.Type.Value ~= v.Data.Type.Value or (NextCard.Data.Type.Value == "Number" and tonumber(NextCard.Data.Class.Value) >= CurrNum))) then
									--print("Ahead Spot: " .. CurrNum .. " " .. SortNum)
									if NextCard then
										--print("Next Card: " .. NextCard.Data.Class.Value)
									end
									Placed = true
									table.insert(ArrangedCards,a+1,v)
									break
								end
							else
								table.insert(ArrangedCards,a+1,v)
							end

						else



						end

					end

				end

				if not Placed then
					table.insert(ArrangedCards,#ArrangedCards+1,v)
				end

			end
		end
	end
	
	--Special Sorts
	
	for i,v in pairs(Cards) do
		if v.Data.Type.Value == "Wild Number" then
			table.insert(ArrangedCards,#ArrangedCards+1,v)
		end
	end
	
	for i,v in pairs(Cards) do
		if v.Data.Type.Value == "Reverse" then
			table.insert(ArrangedCards,#ArrangedCards+1,v)
		end
	end
	
	for i,v in pairs(Cards) do
		if v.Data.Type.Value == "Skip" then
			table.insert(ArrangedCards,#ArrangedCards+1,v)
		end
	end
	
	for i,v in pairs(Cards) do
		if v.Data.Type.Value == "Double Skip" then
			table.insert(ArrangedCards,#ArrangedCards+1,v)
		end
	end
	
	for i,v in pairs(Cards) do
		if v.Data.Type.Value == "Skip Everyone" then
			table.insert(ArrangedCards,#ArrangedCards+1,v)
		end
	end
	
	for i,v in pairs(Cards) do
		if v.Data.Type.Value == "Swap Hands" then
			table.insert(ArrangedCards,#ArrangedCards+1,v)
		end
	end
	
	for i,v in pairs(Cards) do
		if v.Data.Type.Value == "Wild" then
			table.insert(ArrangedCards,#ArrangedCards+1,v)
		end
	end
	
	for i,v in pairs(Cards) do
		if v.Data.Type.Value == "Wild Draw" then
			table.insert(ArrangedCards,#ArrangedCards+1,v)
		end
	end
	
	for i,v in pairs(Cards) do
		if v.Data.Type.Value == "Discard Color" then
			table.insert(ArrangedCards,#ArrangedCards+1,v)
		end
	end
	
	--Draw Cards
	for i,v in pairs(Cards) do
		if (v.Data.Type.Value == "Draw" or v.Data.Type.Value == "Targeted Draw") and v.Data.Color.Value ~= Color3.fromRGB(0,0,0) then
			if #ArrangedCards == 0 then
				table.insert(ArrangedCards,1,v)
			else

				local Placed = false

				for a,b in pairs(ArrangedCards) do

					local NextCard = ArrangedCards[a+1]

					if NextCard == nil then
						--NextCard = b
					end

					if v.Data.Color.Value == b.Data.Color.Value then

						if v.Data.Type.Value == b.Data.Type.Value then

							if v.Data.Type.Value == "Draw" or v.Data.Type.Value == "Targeted Draw" then

								local CurrNum = tonumber(v.Data.Class.Value)
								local SortNum = tonumber(b.Data.Class.Value)

								if (CurrNum <= SortNum) then
									--print("Same Spot: " .. CurrNum .. " " .. SortNum)
									Placed = true
									table.insert(ArrangedCards,a,v)
									break
								elseif (CurrNum > SortNum and NextCard == nil) or (CurrNum > SortNum and NextCard and (NextCard.Data.Color.Value ~= v.Data.Color.Value or NextCard.Data.Type.Value ~= v.Data.Type.Value or (NextCard.Data.Type.Value == "Draw" and tonumber(NextCard.Data.Class.Value) >= CurrNum))) then
									--print("Ahead Spot: " .. CurrNum .. " " .. SortNum)
									if NextCard then
										--print("Next Card: " .. NextCard.Data.Class.Value)
									end
									Placed = true
									table.insert(ArrangedCards,a+1,v)
									break
								end
							else
								table.insert(ArrangedCards,a+1,v)
							end

						else



						end

					end

				end

				if not Placed then
					table.insert(ArrangedCards,#ArrangedCards+1,v)
				end

			end
		end
	end
	
	for i,v in pairs(Cards) do
		if v.Data.Type.Value == "Color Draw" then
			table.insert(ArrangedCards,#ArrangedCards+1,v)
		end
	end
	
	return ArrangedCards
	
end

function module:ArrangeCards2(Cards)
	
	local ArrangedCards = {}
	
	local NewC = {}
	
	for i,v in pairs(Cards) do
		table.insert(NewC,i,v)
	end
	
	local Empty = true
	local LoopCount = 0
	
	--print("Starting Sort")
	
	repeat
		
		Empty = true
		
		LoopCount = LoopCount + 1
		
		--print("Sorting" .. LoopCount)
		
		local CurrColor = nil
		
		local ColorSort = {}
		
		for i,v in pairs(NewC) do
			if v ~= nil and v:FindFirstChild("Data") then
				
				Empty = false
				
				if CurrColor == nil then
					CurrColor = v.Data.Color.Value
					table.insert(ColorSort,1,v)
					NewC[i] = nil
				else
					
					if v.Data.Color.Value == CurrColor then
						table.insert(ColorSort,#ColorSort+1,v)
						NewC[i] = nil
					end
					
				end
				
			end
		end
		
		--print(CurrColor)
		
		if CurrColor ~= nil then
			local ColorSortz = self:ArrangeColor(ColorSort)
			
			for i,v in pairs(ColorSortz) do
				table.insert(ArrangedCards,#ArrangedCards+1,v)
			end
		end
		wait(.1)
	until Empty
	
	--print("Sorted: " .. #ArrangedCards)
	
	return ArrangedCards
	
end

function module:ArrangeCards(Cards)
	local ArrangedCards = {}
	
	for i,v in pairs(Cards) do
		
		if #ArrangedCards == 0 then
			table.insert(ArrangedCards,1,v)
		else
			
			local Placed = false
			
			for a,b in pairs(ArrangedCards) do
				
				local NextCard = ArrangedCards[a+1]
				
				if NextCard == nil then
					--NextCard = b
				end
				
				if v.Data.Color.Value == b.Data.Color.Value then
					
					if v.Data.Type.Value == b.Data.Type.Value then
						
						if v.Data.Type.Value == "Number" then
							
							local CurrNum = tonumber(v.Data.Class.Value)
							local SortNum = tonumber(b.Data.Class.Value)
							
							if (CurrNum <= SortNum) then
								--print("Same Spot: " .. CurrNum .. " " .. SortNum)
								Placed = true
								table.insert(ArrangedCards,a,v)
								break
							elseif (CurrNum > SortNum and NextCard == nil) or (CurrNum > SortNum and NextCard and (NextCard.Data.Color.Value ~= v.Data.Color.Value or NextCard.Data.Type.Value ~= v.Data.Type.Value or (NextCard.Data.Type.Value == "Number" and tonumber(NextCard.Data.Class.Value) >= CurrNum))) then
								--print("Ahead Spot: " .. CurrNum .. " " .. SortNum)
								if NextCard then
									--print("Next Card: " .. NextCard.Data.Class.Value)
								end
								Placed = true
								table.insert(ArrangedCards,a+1,v)
								break
							end
						else
							table.insert(ArrangedCards,a+1,v)
							--if v.Data.Type.Value == "Reverse" or
							
						end
						
					else
						
						
						
					end
					
				end
				
			end
			
			if not Placed then
				table.insert(ArrangedCards,#ArrangedCards+1,v)
			end
			
		end
		
	end
	--print("Resorted: " .. #ArrangedCards)
	return ArrangedCards
end

function module:SortCards()
	
	local Cards = GameUI.GameFrames.Cards:GetChildren()
	
	local Half = #Cards/2
	
	local Yincrement = .02
	
	local ButSize = 1
	
	if #Cards <= 2 then
		ButSize = 1
	elseif #Cards <= 3 then
		ButSize = .7
	elseif #Cards <= 4 then
		ButSize = .59
	elseif #Cards <= 5 then
		ButSize = .54
	elseif #Cards <= 6 then
		ButSize = .51
	elseif #Cards <= 7 then
		ButSize = .49
	elseif #Cards <= 8 then
		ButSize = .47
	elseif #Cards <= 9 then
		ButSize = .46
	elseif #Cards <= 10 then
		ButSize = .45
	elseif #Cards > 10 then
		ButSize = .45 - ((#Cards-10)*.0325)
	end
	
	if #Cards == 2 then
		--GameUI.Parent.GameUI.UnoB:TweenPosition(UDim2.new(.995,0,.9,0),"Out","Quad",.5,true)
	else
		--GameUI.Parent.GameUI.UnoB:TweenPosition(UDim2.new(1.3,0,.9,0),"Out","Quad",.5,true)
	end
	
	local CardSpaces,Incre = NumberStep(0,1,#Cards)
	local Rotations = NumberStep(-12,12,#Cards)
	local YOffs = NumberStep(-.11,.11,#Cards)
	
	local RevMul = -1
	
	local ReSortedCards = self:ArrangeCards2(Cards)
	
	--print(#Cards)
	
	local FirstCard = nil
	local LastCard = nil
	
	local MultSize = 1
	
	if GameUI.Parent.GameUI.Everything.ClientVars.IsMobile.Value then
		MultSize = (5/4)
	end
	
	for i,v in pairs(ReSortedCards) do
		--print(v.Name)
		if #Cards <= 1 and #Cards ~= 0 then
			GameUI.GameFrames.Cards:TweenSize(UDim2.new(0,0,.225*MultSize,0),"Out","Quad",.5,true)
			if v ~= nil and v.Parent ~= nil then
				v:TweenPosition(UDim2.new(.5,0,0,0),"Out","Quad",.5,true)
				local RotTween = TweenService:Create(v.Card,TI1,{Rotation = 0})
				v.Data.ZX.Value = 1
				v.Data.YOff.Value = 0
				v.Data.XOff.Value = .5
				v.But.NextSelectionLeft= v.But
				v.But.NextSelectionRight = v.But
				RotTween:Play()
			end
		else
			
			if v:FindFirstChild("But") then
				
				if i > Half then
					RevMul = 1
				end

				if i == 1 then
					v.But.NextSelectionLeft = GameUI.Parent.GameUI.Everything.DrawB.Button
					v.But.NextSelectionRight = v.But
					FirstCard = v.But
					GameUI.Parent.GameUI.Everything.DrawB.Button.NextSelectionRight = v.But
				end

				GameUI.Parent.GameUI.Everything.DrawB.Button.NextSelectionLeft = v.But

				if LastCard ~= nil then
					LastCard.NextSelectionRight = v.But
					v.But.NextSelectionLeft = LastCard
					v.But.NextSelectionRight = GameUI.Parent.GameUI.Everything.DrawB.Button
					GameUI.Parent.GameUI.Everything.DrawB.Button.NextSelectionLeft = v.But
				end

				LastCard = v.But

				v.ZIndex = i
				v.Data.ZX.Value = i
				v.Data.YOff.Value = YOffs[i]*RevMul
				v.Data.XOff.Value = CardSpaces[i]

				v.But.Size = UDim2.new(ButSize,0,1,0)

				GameUI.GameFrames.Cards:TweenSize(UDim2.new((.04 + (math.clamp(i,1,10)*.06))*MultSize,0,.225*MultSize,0),"Out","Quad",.5,true)
				v:TweenPosition(UDim2.new(CardSpaces[i],0,YOffs[i]*RevMul,0),"Out","Quad",.5,true)
				local RotTween = TweenService:Create(v.Card,TI1,{Rotation = Rotations[i]})
				RotTween:Play()

				game.Debris:AddItem(RotTween,.6)
				
			end
			
		end
		
	end
	
end

return module