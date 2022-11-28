--X_Z

game.ReplicatedStorage:WaitForChild("Decks")
game.ReplicatedStorage.Decks:WaitForChild("Classic")

script.Parent:WaitForChild("LevelHandler")
script.Parent:WaitForChild("Util")

local LevelHandler = require(script.Parent.LevelHandler)
local Util = require(script.Parent.Util)

local ClassicDeck = require(game.ReplicatedStorage.Decks.Classic)

local module = {}

local Rnd = Random.new()

function BotCount(Lobby)
	local BotCount = 0
	
	for i,v in pairs(Lobby.Players:GetChildren()) do
		if string.sub(v.Name,1,3) == "||." then
			BotCount = BotCount + 1
		end
	end
	
	return BotCount
end

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
	return Numbers
end

function module:IsBot(GameLobby,plrName)
	return string.sub(plrName,1,3) == "||."
end

function module:HasCalledUno(GameLobby,PlayerName)
	local HasCalled = false
	
	local PlrF = GameLobby.Players:FindFirstChild(PlayerName)
	if PlrF then
		local Called = PlrF:FindFirstChild("UnoCall")
		if Called then
			HasCalled = true
		end
	end
	
	return HasCalled
end

function module:CreateArena(ArenaF)
	
	local AreF = Instance.new("Folder")
	AreF.Name = ArenaF.Name
	AreF.Parent = game.Workspace.Arenas
	
	local Playerz = ArenaF.Players:GetChildren()
	
	local Base = Instance.new("Part")
	Base.Anchored = true
	Base.CanCollide = true
	Base.Size = Vector3.new(17+(1*(math.clamp(#Playerz,4,100)-4)),1,17+(1*(math.clamp(#Playerz,4,100)-4)))
	Base.Material = Enum.Material.SmoothPlastic
	Base.Name = "Base"
	Base.Parent = AreF
	Base.CFrame = game.Workspace.ArenaStart.CFrame*CFrame.new(game.ReplicatedStorage.Vals.Games.Value*100,0,0)
	Base.BrickColor = BrickColor.new("Sea green")
	
	local Circle = Base:Clone()
	Circle.Name = "Circle"
	Circle.Size = Vector3.new(Base.Size.X - 10,.3,Base.Size.Z - 10)
	Circle.CFrame = Base.CFrame + Vector3.new(0,4.5,0)
	Circle.BrickColor = BrickColor.new("Medium brown")
	local CircMesh = Instance.new("CylinderMesh")
	CircMesh.Parent = Circle
	Circle.Name = "Table"
	Circle.Parent = AreF
	
	Base.Size = Base.Size + Vector3.new(30,0,30)
	Base.CFrame = game.Workspace.ArenaStart.CFrame*CFrame.new(game.ReplicatedStorage.Vals.Games.Value*100,0,0)
	
	local Wall1 = Base:Clone()
	Wall1.Parent = AreF
	Wall1.Size = Vector3.new(Base.Size.X,15,1)
	Wall1.CFrame = Base.CFrame*CFrame.new(0,0,Base.Size.X/2) + Vector3.new(0,15/2,0)
	Wall1.BrickColor = BrickColor.new("Smoky grey")
	
	local Wall2 = Wall1:Clone()
	Wall2.Parent = AreF
	Wall2.CFrame = Base.CFrame*CFrame.new(0,0,-Base.Size.X/2) + Vector3.new(0,15/2,0)
	
	local Wall3 = Wall1:Clone()
	Wall3.Parent = AreF
	Wall3.CFrame = Base.CFrame*CFrame.Angles(0,math.rad(90),0)*CFrame.new(0,0,-Base.Size.X/2) + Vector3.new(0,15/2,0)
	
	local Wall4 = Wall1:Clone()
	Wall4.Parent = AreF
	Wall4.CFrame = Base.CFrame*CFrame.Angles(0,math.rad(90),0)*CFrame.new(0,0,Base.Size.X/2) + Vector3.new(0,15/2,0)
	
	local DeckB = Base:Clone()
	DeckB.Name = "DeckB"
	DeckB.Transparency = 1
	DeckB.BrickColor = BrickColor.Blue()
	DeckB.Size = game.ReplicatedStorage.MiscAssets.CardModel.PrimaryPart.Size
	DeckB.Parent = AreF
	DeckB.CFrame = Circle.CFrame + Vector3.new(1.5,(Circle.Size.Y/2)+(DeckB.Size.Y/2),1.5)
	
	local DiscardB = DeckB:Clone()
	DiscardB.Name = "DiscardB"
	DiscardB.BrickColor = BrickColor.new("Royal purple")
	DiscardB.Parent = AreF
	DiscardB.CFrame = Circle.CFrame + Vector3.new(0,(Circle.Size.Y/2)+(DeckB.Size.Y/2),0)
	
	local DrawClickB = DiscardB:Clone()
	DrawClickB.Name = "ClickerMans"
	DrawClickB.Size = Vector3.new(1.5, 1.5, 1)
	DrawClickB.Parent = AreF
	DrawClickB.CFrame = DeckB.CFrame + Vector3.new(0,.5,0)
	
	local Clicker = Instance.new("ClickDetector")
	Clicker.Parent = DrawClickB
	Clicker.MaxActivationDistance = math.huge
	Clicker.Name = "Drawer"
	
	local DrawsF = Instance.new("Folder")
	DrawsF.Name = "DrawsF"
	DrawsF.Parent = AreF
	
	local DisF = Instance.new("Folder")
	DisF.Name = "DiscardsF"
	DisF.Parent = AreF
	
	local RotArrows = game.ReplicatedStorage.MiscAssets.RotArrows:Clone()
	RotArrows.Parent = AreF
	RotArrows:SetPrimaryPartCFrame(DiscardB.CFrame)
	
	local PointArrow = game.ReplicatedStorage.MiscAssets.PointArrow:Clone()
	PointArrow.Parent = AreF
	PointArrow:SetPrimaryPartCFrame(DiscardB.CFrame)
	
	for i,v in pairs(ArenaF.Draws:GetChildren()) do
		local CardClone = game.ReplicatedStorage.MiscAssets.CardModel:Clone()
		CardClone.Parent = DrawsF
		CardClone:SetPrimaryPartCFrame(DeckB.CFrame+Vector3.new(0,(i-1)*(CardClone.PrimaryPart.Size.Y/2),0))
	end
	
	for i,v in pairs(Playerz) do
		
		local Seat = Instance.new("Seat")
		Seat.BrickColor = BrickColor.Red()
		Seat.Anchored = true
		Seat.Size = Vector3.new(2,.2,2)
		Seat.CanCollide = false
		Seat.Parent = AreF
		Seat.Name = v.Name .. "|Seat"
		Seat.Transparency = 1
		
		Seat.CFrame = Circle.CFrame*CFrame.Angles(0,math.rad((360/#Playerz)*i),0)*CFrame.new((Circle.Size.X/2)+1.25,0,0)
		Seat.CFrame = CFrame.new(Seat.Position,Circle.Position) - Vector3.new(0,1.2,0)
		
			
		local Dummy = game.ReplicatedStorage.MiscAssets.Dummy:Clone()
		
		Dummy.Name = v.Name
		Dummy.Parent = AreF
	
		if not self:IsBot(nil,v.Name) then
			local UserId = game.Players:GetUserIdFromNameAsync(v.Name)
			--local x,y = pcall(function()
			spawn(function()
				local HumDescr = game.Players:GetHumanoidDescriptionFromUserId(UserId)
				Dummy.Humanoid:ApplyDescription(HumDescr)
			end)
			
		end
	
		Seat:Sit(Dummy.Humanoid)
		
		local Anim = Instance.new("Animation")
		Anim.Name = "Sit"
		Anim.Parent = Dummy
		Anim.AnimationId = "rbxassetid://2506281703"
		
		local Track = Dummy.Humanoid:LoadAnimation(Anim)
		Track:Play()
		
		wait(.1)
		
		local CardCF = Base:Clone()
		CardCF.Name = "CardCF"
		CardCF.Size = Vector3.new(.2,.2,.2)
		CardCF.Transparency = 1
		CardCF.BrickColor = BrickColor.White()
		CardCF.Parent = Dummy
		CardCF.CFrame = Dummy.HumanoidRootPart.CFrame*CFrame.new(0,0,-.8) + Vector3.new(0,.75,0)
		
		local CardsF = Instance.new("Folder")
		CardsF.Name = "Cards"
		CardsF.Parent = Dummy
	
		local CardsF2 = Instance.new("Folder")
		CardsF2.Name = "NextCards"
		CardsF2.Parent = Dummy
		
		local EndCardz = DiscardB:Clone()
		EndCardz.Name = "EndCardCF"
		EndCardz.Parent = Dummy
		EndCardz.CFrame = CFrame.new(DiscardB.Position,Vector3.new(Dummy.HumanoidRootPart.CFrame.X,DiscardB.Position.Y,Dummy.HumanoidRootPart.CFrame.Z))*CFrame.new(0,0,-((Circle.Size.X/2)-1))*CFrame.Angles(0,math.rad(90),0)
		
		local DecorSlots = Instance.new("Folder")
		DecorSlots.Name = "DecorSlots"
		DecorSlots.Parent = Dummy
		
		local dSlot1 = EndCardz:Clone()
		dSlot1.Parent = DecorSlots
		dSlot1.Name = "Slot2"
		dSlot1.BrickColor = BrickColor.White()
		dSlot1.Size = Vector3.new(.4,.013,.4)
		dSlot1.CFrame = EndCardz.CFrame*CFrame.new(0,0,.7)*CFrame.Angles(0,math.rad(20),0)
		
		local dSlot2 = dSlot1:Clone()
		dSlot2.Parent = DecorSlots
		dSlot2.Name = "Slot3"
		dSlot2.CFrame = EndCardz.CFrame*CFrame.new(0,0,-.7)*CFrame.Angles(0,math.rad(-20),0)
		
		local dSlot3 = dSlot1:Clone()
		dSlot3.Parent = DecorSlots
		dSlot3.Name = "Slot1"
		dSlot3.CFrame = dSlot1.CFrame*CFrame.new(0,0,.5)
		
		local dSlot4 = dSlot1:Clone()
		dSlot4.Parent = DecorSlots
		dSlot4.Name = "Slot4"
		dSlot4.CFrame = dSlot2.CFrame*CFrame.new(0,0,-.5)
		
		local PlayerData = game.ReplicatedStorage.PlayerData:FindFirstChild(v.Name)
		if PlayerData then
			
			local CosmeticsF = Instance.new("Folder")
			CosmeticsF.Name = v.Name .. "|Cosmetics"
			CosmeticsF.Parent = AreF
			
			local DecorFF = Instance.new("Folder")
			DecorFF.Name = "Decor"
			DecorFF.Parent = CosmeticsF

			local ChairFind = game.ReplicatedStorage.Cosmetics.Chairs:FindFirstChild(PlayerData.Equips.Chair.Value)
			if ChairFind then
				local ChairClone = ChairFind:Clone()
				ChairClone.Parent = CosmeticsF
				ChairClone.Name = "Chair"
				ChairClone:SetPrimaryPartCFrame(Seat.CFrame)
			else
				local DefaultChair = game.ReplicatedStorage.Cosmetics.Chairs.Default:Clone()
				DefaultChair.Parent = CosmeticsF
				DefaultChair.Name = "Chair"
				DefaultChair:SetPrimaryPartCFrame(Seat.CFrame)
			end

			for i,v in pairs(PlayerData.Equips.Decorations:GetChildren()) do
				if v.Value ~= "" then

					local CorreSlot = DecorSlots:FindFirstChild(v.Name)
					if CorreSlot then
						local Decor = game.ReplicatedStorage.Cosmetics.Decorations:FindFirstChild(v.Value)
						if Decor then
							local DecorClone = Decor:Clone()
							DecorClone.Parent = DecorFF
							DecorClone.Name = v.Name
							DecorClone:SetPrimaryPartCFrame(CorreSlot.CFrame*CFrame.Angles(0,math.rad(90),0))
						end
					end

				end
			end
			
			local Particle = game.ReplicatedStorage.Cosmetics.Particles:FindFirstChild(PlayerData.Equips.Particle.Value)
			if Particle then
				local UppTors = Dummy:FindFirstChild("HumanoidRootPart")
				if UppTors then
					local PartClone = Particle:Clone()
					PartClone.Name = "Particle"
					PartClone.Parent = UppTors
				end
			end

		else

			local DefaultChair = game.ReplicatedStorage.Cosmetics.Chairs["Default"]:Clone()
			DefaultChair.Parent = AreF
			DefaultChair:SetPrimaryPartCFrame(Seat.CFrame)

		end
			
		--end)
		
	end
	
	ArenaF.Arena.Value = AreF
	
	return AreF
	
end

function module:ReCFCards(Dummy)
	
	local dCards = Dummy.Cards:GetChildren()

	local SideOffs = NumberStep(-math.clamp(.2*#dCards,0,2),math.clamp(.2*#dCards,0,2),#dCards)
	local Rotations = NumberStep(-12,12,#dCards)
	local YOffs = NumberStep(-.1,.1,#dCards)
	local ZOffs = NumberStep(-.02,.02,#dCards)
	--local ZOffs = NumberStep(-1,1,#dCards)

	local RevMul = 1

	for i,v in pairs(dCards) do

		if i > #dCards/2 then
			RevMul = -1
		end

		local EndCF = Dummy.CardCF.CFrame*CFrame.Angles(0,math.rad(90),math.rad(-90))*CFrame.new(0,0,SideOffs[i])*CFrame.Angles(0,math.rad(Rotations[i]),0)*CFrame.new(0,ZOffs[i]*RevMul,0) + Vector3.new(0,YOffs[i]*RevMul,0)

		if #dCards <= 1 then
			EndCF = Dummy.CardCF.CFrame*CFrame.Angles(0,math.rad(90),math.rad(-90))
		end

		v:SetPrimaryPartCFrame(EndCF)
		
	end
end

function module:CardAnimation(GameC,Who,Type,Card,EndCF,Speed)
	
	local CycledPlayers = {}
	
	for i,v in pairs(GameC.Players:GetChildren()) do
		local Player = game.Players:FindFirstChild(v.Name)
		if Player then
			table.insert(CycledPlayers,1,Player)
		end
	end
	
	for i,v in pairs(GameC.Spectators:GetChildren()) do
		local Player = game.Players:FindFirstChild(v.Name)
		if Player then
			table.insert(CycledPlayers,1,Player)
		end
	end
	
	for i,v in pairs(CycledPlayers) do
		spawn(function()
			game.ReplicatedStorage.Remotes.CardAnimation:FireClient(v,GameC.Arena.Value,GameC,Who,Type,Card,EndCF,Speed)
		end)
	end
	
	--game.ReplicatedStorage.Remotes.CardAnimation:FireAllClients(GameClone.Arena.Value,GameClone,b.Name,"PlayerSort")
end

function module:ApplyCardData(CardModel,Type,Color,Class,GameLobby)
	
	CardModel.CardBB.SG.Enabled = true
	
	CardModel.CardBB.SG.Card.ColorLRG.ImageColor3 = Color
	CardModel.CardBB.SG.Card.MidIcon.ImageColor3 = Color
	
	CardModel.CardBB.SG.Card.TopTxt.Text = ""
	CardModel.CardBB.SG.Card.BottomTxt.Text = ""
	CardModel.CardBB.SG.Card.MidTxt.Text = ""
	
	CardModel.CardBB.SG.Card.MidGrad.Visible = false
	CardModel.CardBB.SG.Card.DrawGrad.Visible = false
	
	CardModel.CardBB.SG.Card.TopIcon.Visible = false
	CardModel.CardBB.SG.Card.BottomIcon.Visible = false
	CardModel.CardBB.SG.Card.MidIcon.Visible = false
	
	CardModel.CardBB.SG.Card.MidTxt.TextColor3 = Color
	
	if Type == "Number" then
		
		CardModel.CardBB.SG.Card.MidTxt.Visible = true
		CardModel.CardBB.SG.Card.TopTxt.Visible = true
		CardModel.CardBB.SG.Card.BottomTxt.Visible = true
		
		local NumTxt = Class

		if string.sub(Class,1,1) == "6" or string.sub(Class,1,1) == "9" then
			NumTxt = "<u>" .. string.sub(Class,1,1) .. "</u>" .. string.sub(Class,2)
		end

		CardModel.CardBB.SG.Card.MidTxt.Text = NumTxt
		CardModel.CardBB.SG.Card.TopTxt.Text = NumTxt
		CardModel.CardBB.SG.Card.BottomTxt.Text = NumTxt
	elseif Type == "Reverse" then
		CardModel.CardBB.SG.Card.MidIcon.Image = "rbxassetid://9331931243"
		CardModel.CardBB.SG.Card.TopIcon.Image = "rbxassetid://9331931243"
		CardModel.CardBB.SG.Card.BottomIcon.Image = "rbxassetid://9331931243"

		CardModel.CardBB.SG.Card.MidIcon.Visible = true
		CardModel.CardBB.SG.Card.TopIcon.Visible = true
		CardModel.CardBB.SG.Card.BottomIcon.Visible = true
		
	elseif Type == "Wild Number" then

		CardModel.CardBB.SG.Card.MidTxt.Visible = true
		CardModel.CardBB.SG.Card.TopTxt.Visible = true
		CardModel.CardBB.SG.Card.BottomTxt.Visible = true

		CardModel.CardBB.SG.Card.MidTxt.Text = "#"
		CardModel.CardBB.SG.Card.TopTxt.Text = "#"
		CardModel.CardBB.SG.Card.BottomTxt.Text = "#"
		
	elseif Type == "Skip" then

		CardModel.CardBB.SG.Card.MidIcon.Image = "rbxassetid://8071990635"
		CardModel.CardBB.SG.Card.TopIcon.Image = "rbxassetid://8071990635"
		CardModel.CardBB.SG.Card.BottomIcon.Image = "rbxassetid://8071990635"

		CardModel.CardBB.SG.Card.MidIcon.Visible = true
		CardModel.CardBB.SG.Card.TopIcon.Visible = true
		CardModel.CardBB.SG.Card.BottomIcon.Visible = true
		
	elseif Type == "Double Skip" then

		CardModel.CardBB.SG.Card.MidIcon.Image = "rbxassetid://9480461554"
		CardModel.CardBB.SG.Card.TopIcon.Image = "rbxassetid://9480461554"
		CardModel.CardBB.SG.Card.BottomIcon.Image = "rbxassetid://9480461554"

		CardModel.CardBB.SG.Card.MidIcon.Visible = true
		CardModel.CardBB.SG.Card.TopIcon.Visible = true
		CardModel.CardBB.SG.Card.BottomIcon.Visible = true

	elseif Type == "Skip Everyone" then

		CardModel.CardBB.SG.Card.MidIcon.Image = "rbxassetid://9480504206"
		CardModel.CardBB.SG.Card.TopIcon.Image = "rbxassetid://9480504206"
		CardModel.CardBB.SG.Card.BottomIcon.Image = "rbxassetid://9480504206"

		CardModel.CardBB.SG.Card.MidIcon.Visible = true
		CardModel.CardBB.SG.Card.TopIcon.Visible = true
		CardModel.CardBB.SG.Card.BottomIcon.Visible = true

	elseif Type == "Swap Hands" then

		CardModel.CardBB.SG.Card.MidIcon.Image = "rbxassetid://9480483461"
		CardModel.CardBB.SG.Card.TopIcon.Image = "rbxassetid://9480483461"
		CardModel.CardBB.SG.Card.BottomIcon.Image = "rbxassetid://9480483461"

		CardModel.CardBB.SG.Card.MidIcon.Visible = true
		CardModel.CardBB.SG.Card.TopIcon.Visible = true
		CardModel.CardBB.SG.Card.BottomIcon.Visible = true
		
	elseif Type == "Wild" then

		CardModel.CardBB.SG.Card.BottomTxt.Text = "W"
		CardModel.CardBB.SG.Card.TopTxt.Text = "W"

		--Do Gradient Here
		
		local GameColors = GameLobby.ColorList:GetChildren()

		local GradientColors = {}

		local GradientSteps = NumberStep(0,1,#GameColors+1)

		local PrevColor = nil

		if #GameColors > 2 then

			for i,v in pairs(GameColors) do
				if i ~= 1 and i ~= #GameColors then
					table.insert(GradientColors,#GradientColors+1,ColorSequenceKeypoint.new(GradientSteps[i]-.001,PrevColor))
				elseif i == #GameColors then
					table.insert(GradientColors,#GradientColors+1,ColorSequenceKeypoint.new(GradientSteps[i]-.001,PrevColor))
				end
				table.insert(GradientColors,#GradientColors+1,ColorSequenceKeypoint.new(GradientSteps[i],v.Value))
				if i == #GameColors then
					table.insert(GradientColors,#GradientColors+1,ColorSequenceKeypoint.new(1,v.Value))
				end
				PrevColor = v.Value
			end

			CardModel.CardBB.SG.Card.MidGrad.UIGradient.Color = ColorSequence.new(GradientColors)

		elseif #GameColors == 2 then

			GradientColors = {
				ColorSequenceKeypoint.new(0,GameColors[1].Value),
				ColorSequenceKeypoint.new(.5,GameColors[1].Value),
				ColorSequenceKeypoint.new(.501,GameColors[2].Value),
				ColorSequenceKeypoint.new(1,GameColors[2].Value),
			}

		elseif #GameColors == 1 then

			GradientColors = {
				ColorSequenceKeypoint.new(0,GameColors[1].Value),
				ColorSequenceKeypoint.new(1,GameColors[1].Value),
			}

		elseif #GameColors == 0 then
			CardModel.CardBB.SG.Card.MidGrad.UIGradient.Enabled = false
			CardModel.CardBB.SG.Card.MidGrad.WildGradient.Enabled = true
		end

		if #GameColors ~= 0 then
			CardModel.CardBB.SG.Card.MidGrad.UIGradient.Color = ColorSequence.new(GradientColors)
			CardModel.CardBB.SG.Card.MidGrad.UIGradient.Enabled = true
		else
			CardModel.CardBB.SG.Card.MidGrad.UIGradient.Enabled = false
		end

		CardModel.CardBB.SG.Card.MidGrad.Visible = true
		CardModel.CardBB.SG.Card.TopTxt.Visible = true
		CardModel.CardBB.SG.Card.BottomTxt.Visible = true
		
	elseif Type == "Draw" then
		
		CardModel.CardBB.SG.Card.MidIcon.Image = "rbxassetid://8481315479"

		CardModel.CardBB.SG.Card.TopTxt.Text = "+" .. Class
		CardModel.CardBB.SG.Card.BottomTxt.Text = "+" .. Class

		CardModel.CardBB.SG.Card.MidIcon.Visible = true
		CardModel.CardBB.SG.Card.TopTxt.Visible = true
		CardModel.CardBB.SG.Card.BottomTxt.Visible = true
		
	elseif Type == "Targeted Draw" then

		CardModel.CardBB.SG.Card.MidIcon.Image = "rbxassetid://9481290686"

		CardModel.CardBB.SG.Card.TopTxt.Text = "+" ..Class
		CardModel.CardBB.SG.Card.BottomTxt.Text = "+" .. Class

		CardModel.CardBB.SG.Card.MidIcon.Visible = true
		CardModel.CardBB.SG.Card.TopTxt.Visible = true
		CardModel.CardBB.SG.Card.BottomTxt.Visible = true
		
	elseif Type == "Color Draw" then

		CardModel.CardBB.SG.Card.MidIcon.Image = "rbxassetid://9497107550"
		CardModel.CardBB.SG.Card.TopIcon.Image = "rbxassetid://9497107550"
		CardModel.CardBB.SG.Card.BottomIcon.Image = "rbxassetid://9497107550"

		CardModel.CardBB.SG.Card.MidIcon.Visible = true
		CardModel.CardBB.SG.Card.TopIcon.Visible = true
		CardModel.CardBB.SG.Card.BottomIcon.Visible = true

	elseif Type == "Discard Color" then

		CardModel.CardBB.SG.Card.MidIcon.Image = "rbxassetid://9497108915"
		CardModel.CardBB.SG.Card.TopIcon.Image = "rbxassetid://9497108915"
		CardModel.CardBB.SG.Card.BottomIcon.Image = "rbxassetid://9497108915"

		CardModel.CardBB.SG.Card.MidIcon.Visible = true
		CardModel.CardBB.SG.Card.TopIcon.Visible = true
		CardModel.CardBB.SG.Card.BottomIcon.Visible = true
		
	elseif Type == "Wild Draw" then

		CardModel.CardBB.SG.Card.TopTxt.Text = "+" .. Class
		CardModel.CardBB.SG.Card.BottomTxt.Text = "+" .. Class

		CardModel.CardBB.SG.Card.BottomTxt.Visible = true
		CardModel.CardBB.SG.Card.TopTxt.Visible = true

		CardModel.CardBB.SG.Card.DrawGrad.Visible = true

		local GameColors = GameLobby.ColorList:GetChildren()

		local GradientColors = {}

		local GradientSteps = NumberStep(0,1,#GameColors+1)

		local PrevColor = nil

		if #GameColors > 2 then

			for i,v in pairs(GameColors) do
				if i ~= 1 and i ~= #GameColors then
					table.insert(GradientColors,#GradientColors+1,ColorSequenceKeypoint.new(GradientSteps[i]-.001,PrevColor))
				elseif i == #GameColors then
					table.insert(GradientColors,#GradientColors+1,ColorSequenceKeypoint.new(GradientSteps[i]-.001,PrevColor))
				end
				table.insert(GradientColors,#GradientColors+1,ColorSequenceKeypoint.new(GradientSteps[i],v.Value))
				if i == #GameColors then
					table.insert(GradientColors,#GradientColors+1,ColorSequenceKeypoint.new(1,v.Value))
				end
				PrevColor = v.Value
			end

			CardModel.CardBB.SG.Card.DrawGrad.UIGradient.Color = ColorSequence.new(GradientColors)

		elseif #GameColors == 2 then

			GradientColors = {
				ColorSequenceKeypoint.new(0,GameColors[1].Value),
				ColorSequenceKeypoint.new(.5,GameColors[1].Value),
				ColorSequenceKeypoint.new(.501,GameColors[2].Value),
				ColorSequenceKeypoint.new(1,GameColors[2].Value),
			}

		elseif #GameColors == 1 then
			GradientColors = {
				ColorSequenceKeypoint.new(0,GameColors[1].Value),
				ColorSequenceKeypoint.new(1,GameColors[1].Value),
			}
		elseif #GameColors == 0 then
			CardModel.CardBB.SG.Card.DrawGrad.UIGradient.Enabled = false
			CardModel.CardBB.SG.Card.DrawGrad.WildGradient.Enabled = true
		end

		if #GameColors ~= 0 then
			CardModel.CardBB.SG.Card.DrawGrad.UIGradient.Enabled = true
			CardModel.CardBB.SG.Card.DrawGrad.WildGradient.Enabled = false
			CardModel.CardBB.SG.Card.DrawGrad.UIGradient.Color = ColorSequence.new(GradientColors)
		end
		
	end
	
end

function module:GetAllPlayers(GameLobby)
	local PlayersList = {}
	for i,v in pairs(GameLobby.Players:GetChildren()) do
		local Plr = game.Players:FindFirstChild(v.Name)
		if Plr then
			table.insert(PlayersList,1,Plr)
		end
	end
	for i,v in pairs(GameLobby.Spectators:GetChildren()) do
		local Plr = game.Players:FindFirstChild(v.Name)
		if Plr then
			table.insert(PlayersList,1,Plr)
		end
	end
	return PlayersList
end

function module:RealPlayerCount(GameLobby)
	
	local Count = 0
	
	for i,v in pairs(GameLobby.Players:GetChildren()) do
		if not self:IsBot(GameLobby,v.Name) then
			Count = Count + 1
		end
	end
	
	return Count
end

function module:ResponseWaiter(GameLobby,Increment,End,WaitTime)
	GameLobby.Responses:ClearAllChildren()
	local Count = 0
	repeat
		Count = Count + Increment
		wait(WaitTime)
	until Count >= End or #GameLobby.Responses:GetChildren() >= self:RealPlayerCount(GameLobby)

	GameLobby.Responses:ClearAllChildren()
end

function module:BotPlay(GameLobby,BotName)
	
end

function module:PlayerSort(GameLobby,PlayerName,Speed)
	
	local GamePlayers = self:GetAllPlayers(GameLobby)
	for i,v in pairs(GamePlayers) do
		game.ReplicatedStorage.Remotes.CardAnimation:FireClient(v,GameLobby.Arena.Value,GameLobby,PlayerName,"PlayerSort",nil,nil,Speed)
	end
	
	local SortCount = 0
	repeat
		SortCount = SortCount + .05
		wait(.05)
	until SortCount >= .6 or #GameLobby.Responses:GetChildren() >= #GameLobby.Players:GetChildren() - BotCount(GameLobby)
	
	GameLobby.Responses:ClearAllChildren()
	
	local DummyP = GameLobby.Arena.Value:FindFirstChild(PlayerName)
	if DummyP then
		self:ReCFCards(DummyP)
	end
	
	return true
	
end

function module:CanPlayCard(GameLobby,Card,Extra)
	local PrevCard = GameLobby.CurrentCard.Value
	--print("test1")
	if Extra == "Chal" then
		PrevCard = GameLobby.PreviousCard.Value
	end
	--print("test2")
	if GameLobby.UpcomingAction.Value == "Skip" or (GameLobby.Settings.Stacking.Value == false and GameLobby.UpcomingAction.Value == "Draw" and Extra == nil) or GameLobby.JumpedIn.Value then return false end
	--print("test3")
	if GameLobby.UpcomingAction.Value == "Draw" and GameLobby.Settings.Stacking.Value and Extra == nil then
		return (Card.Type.Value == "Draw" and (Card.Color.Value == PrevCard.Color.Value or (Card.Class.Value == PrevCard.Class.Value and PrevCard.Type.Value == "Draw"))) or Card.Type.Value == "Wild Draw"
	end
	--print("test4")
	if Extra == nil then
		if GameLobby.SecondaryAction.Value == "Bluff" or GameLobby.SecondaryAction.Value == "BluffPrompt" or GameLobby.SecondaryAction.Value == "PickColor" then return false end
		return PrevCard == nil or PrevCard.Color.Value == Color3.fromRGB(0,0,0) or Card.Color.Value == PrevCard.Color.Value or Card.Color.Value == Color3.fromRGB(0,0,0) or (Card.Type.Value == "Number" and PrevCard.Type.Value == "Number" and Card.Class.Value == PrevCard.Class.Value) or (Card.Type.Value == "Number" and PrevCard.Type.Value == "Wild Number" and Card.Class.Value == PrevCard.Class.Value) or (Card.Type.Value == "Reverse" and PrevCard.Type.Value == "Reverse") or (Card.Type.Value == "Skip" and PrevCard.Type.Value == "Skip") or (Card.Type.Value == "Color Draw" and PrevCard.Type.Value == "Color Draw") or (Card.Type.Value == "Discard Color" and PrevCard.Type.Value == "Discard Color")  or (Card.Type.Value == "Draw" and PrevCard.Type.Value == "Draw" and Card.Class.Value == PrevCard.Class.Value) or (Card.Type.Value == "Targeted Draw" and PrevCard.Type.Value == "Targeted Draw" and Card.Class.Value == PrevCard.Class.Value) or (Card.Type.Value == "Double Skip" and PrevCard.Type.Value == "Double Skip") or (Card.Type.Value == "Skip Everyone" and PrevCard.Type.Value == "Skip Everyone") or (Card.Type.Value == "Swap Hands" and PrevCard.Type.Value == "Swap Hands")
	else
		return PrevCard == nil or PrevCard.Color.Value == Color3.fromRGB(0,0,0) or Card.Color.Value == PrevCard.Color.Value or (Card.Color.Value == Color3.fromRGB(0,0,0) and Card.Type.Value == "Wild") or (Card.Type.Value == "Number" and PrevCard.Type.Value == "Number" and Card.Class.Value == PrevCard.Class.Value) or (Card.Type.Value == "Number" and PrevCard.Type.Value == "Wild Number" and Card.Class.Value == PrevCard.Class.Value) or (Card.Type.Value == "Reverse" and PrevCard.Type.Value == "Reverse") or (Card.Type.Value == "Skip" and PrevCard.Type.Value == "Skip") or (Card.Type.Value == "Discard Color" and PrevCard.Type.Value == "Discard Color") or (Card.Type.Value == "Color Draw" and PrevCard.Type.Value == "Color Draw") or (Card.Type.Value == "Draw" and PrevCard.Type.Value == "Draw" and Card.Class.Value == PrevCard.Class.Value) or (Card.Type.Value == "Targeted Draw" and PrevCard.Type.Value == "Targeted Draw" and Card.Class.Value == PrevCard.Class.Value) or (Card.Type.Value == "Double Skip" and PrevCard.Type.Value == "Double Skip") or (Card.Type.Value == "Skip Everyone" and PrevCard.Type.Value == "Skip Everyone") or (Card.Type.Value == "Swap Hands" and PrevCard.Type.Value == "Swap Hands")
	end
end

function module:ReshufflePile(GameLobby)
	
	local GameArena = GameLobby.Arena.Value
	if GameArena then
		local Discards = GameLobby.Discards:GetChildren()
		local DiscardModels = GameArena.DiscardsF:GetChildren()
		
		for i,v in pairs(Discards) do
			v.Parent = GameLobby.Draws
			if v.Type.Value == "Wild" or v.Type.Value == "Wild Draw" then
				v.Color.Value = Color3.fromRGB(0,0,0)
			elseif v.Type.Value == "Wild Number" then
				v.Class.Value = ""
			end
		end
		
		for i,v in pairs(DiscardModels) do
			spawn(function()
				v.Parent = GameArena.DrawsF
				
				local EndCF = GameArena.DeckB.CFrame+Vector3.new(0,(i-1)*(v.PrimaryPart.Size.Y/2),0)
				v.CardBB.SG.Enabled = false
				v.CardBB.SG.Card.MidGrad.Visible = false
				v.CardBB.SG.Card.MidTxt.Visible = false
				v.CardBB.SG.Card.TopTxt.Visible = false
				v.CardBB.SG.Card.BottomTxt.Visible = false
				v.CardBB.SG.Card.MidIcon.Visible = false
				v.CardBB.SG.Card.TopIcon.Visible = false
				v.CardBB.SG.Card.BottomIcon.Visible = false
				
				self:CardAnimation(GameLobby,nil,"OneCard",v,EndCF)
			end)
		end
		
		self:ResponseWaiter(GameLobby,.05,1,.05)
		
		for i,v in pairs(DiscardModels) do
			v:SetPrimaryPartCFrame(GameArena.DeckB.CFrame+Vector3.new(0,(i-1)*(v.PrimaryPart.Size.Y/2),0))
		end
		
		--Redo the initial card
		
		local DrawzS = GameLobby.Draws:GetChildren()
		if #DrawzS > 0 then
			local InitCard = DrawzS[Rnd:NextInteger(1,#DrawzS)]

			InitCard.Parent = GameLobby.Discards
			GameLobby.CurrentCard.Value = InitCard

			local iDrawsF = GameLobby.Arena.Value.DrawsF:GetChildren()
			local iDF = iDrawsF[#iDrawsF]

			iDF.Parent = GameLobby.Arena.Value.DiscardsF
			iDF.CardBB.SG.Enabled = true
			GameLobby.CurrentCM.Value = iDF

			local InitEndCF = GameLobby.Arena.Value.DiscardB.CFrame*CFrame.Angles(math.rad(180),0,0)

			self:ApplyCardData(iDF,InitCard.Type.Value,InitCard.Color.Value,InitCard.Class.Value,GameLobby)

			self:CardAnimation(GameLobby,"CockDestoyer","OneCard",iDF,InitEndCF)

			local RotArz = GameLobby.Arena.Value:FindFirstChild("RotArrows")
			if RotArz then
				local Plrs = self:GetAllPlayers(GameLobby)
				for i,v in pairs(Plrs) do
					game.ReplicatedStorage.Remotes.RotArrowColor:FireClient(v,RotArz,InitCard.Color.Value)
				end
			end

			local Countt = 0

			repeat
				Countt = Countt + .05
				wait(.05)
			until #GameLobby.Responses:GetChildren() >= #GameLobby.Players:GetChildren() - BotCount(GameLobby) or Countt >= .6

			RotArz.Arrow1.Arrow1.Color = GameLobby.CurrentCard.Value.Color.Value
			RotArz.Arrow2.Arrow2.Color = GameLobby.CurrentCard.Value.Color.Value

			GameLobby.Responses:ClearAllChildren()

			iDF:SetPrimaryPartCFrame(InitEndCF)
		else
			GameLobby.CurrentCard.Value = nil
			GameLobby.CurrentCM.Value = nil
		end
		
	end
	
end

function module:DrawFromPile(GameLobby,PlayerName,Single,Rule,DrawColor)
	
	local CorreSpondPlayer = GameLobby.Players:FindFirstChild(PlayerName)
	if CorreSpondPlayer then
		
		if #GameLobby.Draws:GetChildren() <= 0 then
			self:ReshufflePile(GameLobby)
		end
		
		if GameLobby.Settings.DrawToMatch.Value and not Single and Rule ~= "ColorDraw" then
			
			local CardDraw = nil
			local Doned = false

			repeat
				
				local DrawsTo = nil
				DrawsTo = GameLobby.Draws:GetChildren()
				
				if #DrawsTo <= 0 then
					self:ReshufflePile(GameLobby)
					DrawsTo = GameLobby.Draws:GetChildren()
				end
				
				if #DrawsTo > 0 then
					CardDraw = DrawsTo[Rnd:NextInteger(1,#DrawsTo)]

					CardDraw.Parent = CorreSpondPlayer.Cards

					local CardMdls = GameLobby.Arena.Value.DrawsF:GetChildren()
					local CorDum = GameLobby.Arena.Value:FindFirstChild(PlayerName)
					if CorDum then
						local CardMdl = CardMdls[#CardMdls]
						CardMdl.Parent = CorDum.Cards

						local Yield = self:PlayerSort(GameLobby,PlayerName,"Fast")

					end
				else
					Doned = true
				end
				
				wait(.1)
				
			until self:CanPlayCard(GameLobby,CardDraw) or Doned
			
			if #CorreSpondPlayer.Cards:GetChildren() == 2 then
				local uC = Instance.new("IntValue")
				uC.Name = "UnoCall"
				uC.Parent = CorreSpondPlayer
			end
			
			if Rule ~= "NoPlay" then
				if GameLobby.Settings.ForcePlay.Value == false and CardDraw ~= nil then
					GameLobby.SecondaryAction.Value = "PlayKeep"
					
					if self:IsBot(GameLobby,PlayerName) then
						local Chance = Rnd:NextInteger(1,2)
						if Chance == 1 then
							GameLobby.SelectedAction.Value = "Card"
							GameLobby.PreviousCard.Value = GameLobby.CurrentCard.Value
							GameLobby.CurrentCard.Value = CardDraw
							CardDraw.Parent = GameLobby.Discards
							return "Card"
						else
							GameLobby.SelectedAction.Value = "Keep"
							return "Keep"
						end
					end
				else
					
					wait(.5)
					
					GameLobby.SelectedAction.Value = "Card"
					GameLobby.PreviousCard.Value = GameLobby.CurrentCard.Value
					GameLobby.CurrentCard.Value = CardDraw
					CardDraw.Parent = GameLobby.Discards
				end
			end
			
		elseif Rule == "ColorDraw" then
			
			local CardDraw = nil
			local Doned = false

			repeat

				local DrawsTo = nil
				DrawsTo = GameLobby.Draws:GetChildren()

				if #DrawsTo <= 0 then
					self:ReshufflePile(GameLobby)
					DrawsTo = GameLobby.Draws:GetChildren()
				end

				if #DrawsTo > 0 then
					CardDraw = DrawsTo[Rnd:NextInteger(1,#DrawsTo)]

					CardDraw.Parent = CorreSpondPlayer.Cards

					local CardMdls = GameLobby.Arena.Value.DrawsF:GetChildren()
					local CorDum = GameLobby.Arena.Value:FindFirstChild(PlayerName)
					if CorDum then
						local CardMdl = CardMdls[#CardMdls]
						CardMdl.Parent = CorDum.Cards

						local Yield = self:PlayerSort(GameLobby,PlayerName,"Fast")

					end
				else
					Doned = true
				end

				wait(.1)

			until CardDraw and CardDraw.Color.Value == DrawColor

		else

			local DrawsTo = GameLobby.Draws:GetChildren()
			
			if #DrawsTo > 0 then
				local CardDraw = DrawsTo[Rnd:NextInteger(1,#DrawsTo)]

				CardDraw.Parent = CorreSpondPlayer.Cards

				if #CorreSpondPlayer.Cards:GetChildren() == 2 then
					local uC = Instance.new("IntValue")
					uC.Name = "UnoCall"
					uC.Parent = CorreSpondPlayer
				end

				local CardMdls = GameLobby.Arena.Value.DrawsF:GetChildren()
				local CorDum = GameLobby.Arena.Value:FindFirstChild(PlayerName)
				if CorDum then
					local CardMdl = CardMdls[#CardMdls]
					CardMdl.Parent = CorDum.Cards

					local Yield = self:PlayerSort(GameLobby,PlayerName,"Fast")

				end

				if self:CanPlayCard(GameLobby,CardDraw) and Rule ~= "NoPlay" then
					if GameLobby.Settings.ForcePlay.Value == false then
						GameLobby.SecondaryAction.Value = "PlayKeep"

						if self:IsBot(nil,PlayerName) then
							local Chance = Rnd:NextInteger(1,2)
							if Chance == 1 then
								GameLobby.SelectedAction.Value = "Card"
								GameLobby.PreviousCard.Value = GameLobby.CurrentCard.Value
								GameLobby.CurrentCard.Value = CardDraw
								CardDraw.Parent = GameLobby.Discards
								return "Card"
							else
								GameLobby.SelectedAction.Value = "Keep"
								return "Keep"
							end
						end
					else

						wait(.5)

						GameLobby.SelectedAction.Value = "Card"
						GameLobby.PreviousCard.Value = GameLobby.CurrentCard.Value
						GameLobby.CurrentCard.Value = CardDraw
						CardDraw.Parent = GameLobby.Discards
					end
				end
			end

		end
		
	end
	
	return false
	
end

function module:GetCardCount(GameLobby,PlayerName)
	
	local PlrF = GameLobby.Players:FindFirstChild(PlayerName)
	if PlrF then
		return #PlrF.Cards:GetChildren()
	end
	
	return 99
	
end

function module:JumpIn(GameLobby,PlayerName,CardName)

	if GameLobby.JumpedIn.Value or GameLobby.Settings.JumpIn.Value == false or GameLobby.SelectedAction.Value ~= "None" or not GameLobby.CanJumpIn.Value then return end
	
	local PlayerF = GameLobby.Players:FindFirstChild(PlayerName)
	if PlayerF then
		local Card = PlayerF.Cards:FindFirstChild(CardName)
		if Card then
			
			GameLobby.JumpedIn.Value = true
			GameLobby.JumpedIn.Jumper.Value = PlayerName
			
			Card.Parent = GameLobby.Discards
			GameLobby.SelectedAction.Value = "JumpIn"
			GameLobby.PreviousCard.Value = GameLobby.CurrentCard.Value
			GameLobby.CurrentCard.Value = Card
			GameLobby.SecondaryAction.Value = "None"
			
			local Arena = GameLobby.Arena.Value
			if Arena and Arena.Parent and Arena:IsDescendantOf(game.Workspace) then
				
				local RotArrows = Arena:FindFirstChild("RotArrows")
				
				local JumpDum = Arena:FindFirstChild(PlayerName)
				if JumpDum and RotArrows then
					
					local DumbCards = JumpDum.Cards:GetChildren()
					local ncdCard = DumbCards[Rnd:NextInteger(1,#DumbCards)]
					if ncdCard then
						local CurrCM = ncdCard
						ncdCard.Parent = Arena.DiscardsF
						GameLobby.CurrentCM.Value = ncdCard
						self:ApplyCardData(ncdCard,GameLobby.CurrentCard.Value.Type.Value,GameLobby.CurrentCard.Value.Color.Value,GameLobby.CurrentCard.Value.Class.Value,GameLobby)

						local DiscardsFs = Arena.DiscardsF:GetChildren()
						local FirstOneCF = Arena.DiscardB.CFrame + Vector3.new(0,(#DiscardsFs-1)*.005,0)
						local ncdEndCF = CFrame.new((FirstOneCF).p,Vector3.new(JumpDum.HumanoidRootPart.CFrame.X,FirstOneCF.Y,JumpDum.HumanoidRootPart.CFrame.Z))*CFrame.Angles(math.rad(180),math.rad(-90 + Rnd:NextInteger(-15,15)),0)
						
						local Cardiz = PlayerF.Cards:GetChildren()
						
						for i,v in pairs(self:GetAllPlayers(GameLobby)) do
							game.ReplicatedStorage.Remotes.CardAnimation:FireClient(v,Arena,GameLobby,"DumbassFucker","OneCard",ncdCard,ncdEndCF)
							game.ReplicatedStorage.Remotes.CardAnimation:FireClient(v,Arena,GameLobby,PlayerName,"PlayerSort",nil,nil)
							game.ReplicatedStorage.Remotes.BigPopper:FireClient(v,9466227763,Color3.fromRGB(255,0,0),"JumpIn")
							game.ReplicatedStorage.Remotes.PlayerConPopper:FireClient(v,PlayerName,"Image","9466227763",nil)
							
							if #Cardiz == 1 then
								spawn(function()
									wait(.5)
									game.ReplicatedStorage.Remotes.BigPopper:FireClient(v,9312284704,Color3.fromRGB(255,0,0),"UnoCall")
								end)
							end
							
						end

						local ncdCount = 0

						if RotArrows.Arrow1.Arrow1.Color ~= GameLobby.CurrentCard.Value.Color.Value then
							local Plrz = self:GetAllPlayers(GameLobby)
							for i,v in pairs(Plrz) do
								game.ReplicatedStorage.Remotes.RotArrowColor:FireClient(v,RotArrows,GameLobby.CurrentCard.Value.Color.Value)
							end
						end

						repeat
							ncdCount = ncdCount + .05
							wait(.05)
						until #GameLobby.Responses:GetChildren() >= self:RealPlayerCount(GameLobby) or ncdCount >= 1
						GameLobby.Responses:ClearAllChildren()

						ncdCard:SetPrimaryPartCFrame(ncdEndCF)

						RotArrows.Arrow1.Arrow1.Color = GameLobby.CurrentCard.Value.Color.Value
						RotArrows.Arrow2.Arrow2.Color = GameLobby.CurrentCard.Value.Color.Value

						local ncdDummy = GameLobby.Arena.Value:FindFirstChild(GameLobby.CurrentPlayer.Value)
						if ncdDummy then
							self:ReCFCards(ncdDummy)
						end

					end
					
				end
				
			end
			
		end
	end
	
end

function module:GameLoop(Lobby)
	
	--Game Setup
	local Players = Lobby.Players:GetChildren()
	
	if #Players >= 2 then
		
		local GameClone = game.ReplicatedStorage.Templates.GameTemplate:Clone()
		GameClone.LobbyType.Value = Lobby.Parent.Name
		
		for i,v in pairs(Lobby.Players:GetChildren()) do
			local CardsF = Instance.new("Folder")
			CardsF.Name = "Cards"
			CardsF.Parent = v
			
			local CardsF2 = Instance.new("Folder")
			CardsF2.Name = "NextCards"
			CardsF2.Parent = v
			
			local StatsF = game.ReplicatedStorage.Templates.GameStatsTemplate:Clone()
			StatsF.Parent = v
			StatsF.Name = "Stats"
		end
		
		--Lobby.Players.Parent = GameClone
		--Lobby.Settings.Parent = GameClone
		
		local PlrsClone = Lobby.Players:Clone()
		local SettingsClone = Lobby.Settings:Clone()
		
		PlrsClone.Parent = GameClone
		SettingsClone.Parent = GameClone
		
		game.ReplicatedStorage.Vals.Games.Value = game.ReplicatedStorage.Vals.Games.Value + 1
		
		GameClone.Name = Lobby.Name .. game.ReplicatedStorage.Vals.Games.Value
		
		local CardIC = 0
		
		for i,v in pairs(Lobby.DeckData:GetChildren()) do
			if v.Name == "FullDeck" then
				if v.Value == "Classic" then
					for a,b in pairs(ClassicDeck) do
						
						CardIC = CardIC + 1
						
						local CardClone = game.ReplicatedStorage.Templates.CardTemplate:Clone()
						CardClone.Color.Value = b["Color"]
						CardClone.Type.Value = b["Type"]
						CardClone.Class.Value = b["Class"]
						CardClone.Name = "Card" .. CardIC
						CardClone.Parent = GameClone.Draws
					end
				elseif v.Name == "Super" then
					
				end
			else
				
				CardIC = CardIC + 1
				
				local CardClone = game.ReplicatedStorage.Templates.CardTemplate:Clone()
				CardClone.Color.Value = v.Color.Value
				CardClone.Type.Value = v.Type.Value
				CardClone.Class.Value = v.Class.Value
				CardClone.Name = "Card" .. CardIC
				CardClone.Parent = GameClone.Draws
			end
		end
		
		if not Lobby.PermLobby.Value then
			Lobby:Destroy()
		else
			Lobby.Players:ClearAllChildren()
		end
		GameClone.Parent = game.ReplicatedStorage.Games
		
		--Arena Setup
		
		game.ReplicatedStorage.Vals.Games.Value = game.ReplicatedStorage.Vals.Games.Value + 1
		
		local GameArena = self:CreateArena(GameClone)
		
		--Inital Cutscene
		
		for i,v in pairs(GameClone.Players:GetChildren()) do
			local Player = game.Players:FindFirstChild(v.Name)
			if Player then
				game.ReplicatedStorage.Remotes.InitGame:FireClient(Player,GameClone)
				game.ReplicatedStorage.Remotes.TrackDeck:FireClient(Player,v.Cards)
				game.ReplicatedStorage.Remotes.TrackGame:FireClient(Player,GameClone)
			end
		end
		
		wait(3)
		
		for i,v in pairs(GameClone.Players:GetChildren()) do
			local Character = game.Workspace:FindFirstChild(v.Name)
			if Character then
				local Hum = Character:FindFirstChild("HumanoidRootPart")
				local rHum = Character:FindFirstChild("Humanoid")
				if Hum and rHum then
					rHum.Name = "Humi"
					Hum.CFrame = game.Workspace.HumCF.CFrame
					Hum.Anchored = true
				end
			end
		end
		
		local gPz = self:GetAllPlayers(GameClone)
		for i,v in pairs(gPz) do
			for a,b in pairs(GameClone.Players:GetChildren()) do
				local CharModel = GameArena:FindFirstChild(b.Name)
				if CharModel then
					if GameClone.Players:FindFirstChild(v.Name) then
						game.ReplicatedStorage.Remotes.AddConInfo:FireClient(v,CharModel.Head,b)
					end
				end
			end
		end
		
		local InitCount = 0
		
		repeat
			InitCount = InitCount + .1
			wait(.1)
		until InitCount >= 2 or #GameClone.Responses:GetChildren() >= #GameClone.Players:GetChildren() - BotCount(GameClone)
		
		GameClone.Responses:ClearAllChildren()
		
		local Droozers = GameClone.Draws:GetChildren()
		
		--Get a list of the colors used in the game
		for i,v in pairs(Droozers) do

			if v.Color.Value ~= Color3.fromRGB(0,0,0) then
				local Colorz = GameClone.ColorList:GetChildren()
				if #Colorz > 0 then

					local FoundColor = false

					for a,b in pairs(Colorz) do
						if b.Value == v.Color.Value then
							FoundColor = true
							break
						end
					end

					if not FoundColor then
						local ColV = Instance.new("Color3Value")
						ColV.Value = v.Color.Value
						ColV.Parent = GameClone.ColorList
					end
				else
					local ColV = Instance.new("Color3Value")
					ColV.Value = v.Color.Value
					ColV.Parent = GameClone.ColorList
				end
			end

		end
		
		--Get a list of
		
		for i,v in pairs(Droozers) do
			if v.Type.Value == "Number" then
				
				local CorreNum = GameClone.NumberList:FindFirstChild(v.Class.Value)
				if CorreNum then
					--
				else
					
					local Vale = Instance.new("IntValue")
					Vale.Name = v.Class.Value
					Vale.Parent = GameClone.NumberList
					
				end
				
			end
		end
		
		local NoCards = false
		
		for i = 1,GameClone.Settings.StartCards.Value do
			
			for a,b in pairs(GameClone.Players:GetChildren()) do
				
				local Drawz = GameClone.Draws:GetChildren()
				
				if #Drawz == 0 then
					NoCards = true
					break
				end
				
				local RndDraw = Drawz[Rnd:NextInteger(1,#Drawz)]
				
				RndDraw.Parent = b.Cards
				
				local CardModels = GameClone.Arena.Value.DrawsF:GetChildren()
				
				local CardM = CardModels[#CardModels]
				local DummyChar = GameClone.Arena.Value:FindFirstChild(b.Name)
				if DummyChar then
					CardM.Parent = DummyChar.Cards
				end
				
				
				--game.ReplicatedStorage.Remotes.CardAnimation:FireAllClients(GameClone.Arena.Value,GameClone,b.Name,"PlayerSort")
				self:CardAnimation(GameClone,b.Name,"PlayerSort",nil,nil,nil,"SuperFast")
			
				local Countt = 0
				
				repeat
					Countt = Countt + .05
					wait(.05)
				until #GameClone.Responses:GetChildren() >= #GameClone.Players:GetChildren() - BotCount(GameClone) or Countt >= .2
				
				GameClone.Responses:ClearAllChildren()
				
			end
			
			if NoCards then
				break
			end
			
			--wait(.3)
		end
		
		--Set server CFrames
		for i,v in pairs(GameClone.Players:GetChildren()) do
			local Dummy = GameClone.Arena.Value:FindFirstChild(v.Name)
			if Dummy then
				self:ReCFCards(Dummy)
			end
		end
		
		--Set inital card
		
		local DrawzS = GameClone.Draws:GetChildren()
		local iDF = nil
		local InitEndCF = nil
		local StartColor = Color3.fromRGB(255,255,255)
		
		if #DrawzS > 0 then
			local InitCard = DrawzS[Rnd:NextInteger(1,#DrawzS)]

			InitCard.Parent = GameClone.Discards
			GameClone.CurrentCard.Value = InitCard

			local iDrawsF = GameClone.Arena.Value.DrawsF:GetChildren()
			iDF = iDrawsF[#iDrawsF]

			iDF.Parent = GameClone.Arena.Value.DiscardsF
			iDF.CardBB.SG.Enabled = true
			GameClone.CurrentCM.Value = iDF

			InitEndCF = GameClone.Arena.Value.DiscardB.CFrame*CFrame.Angles(math.rad(180),0,0)
			
			StartColor = InitCard.Color.Value

			self:ApplyCardData(iDF,InitCard.Type.Value,InitCard.Color.Value,InitCard.Class.Value,GameClone)

			self:CardAnimation(GameClone,"CockDestoyer","OneCard",iDF,InitEndCF)
		end
		
		local RotArz = GameClone.Arena.Value:FindFirstChild("RotArrows")
		if RotArz then
			local Plrz = self:GetAllPlayers(GameClone)
			for i,v in pairs(Plrz) do
				spawn(function()
					game.ReplicatedStorage.Remotes.RotArrowColor:FireClient(v,RotArz,GameClone.CurrentCard.Value.Color.Value)
				end)
			end
		end

		local Countt = 0

		repeat
			Countt = Countt + .05
			wait(.05)
		until #GameClone.Responses:GetChildren() >= #GameClone.Players:GetChildren() - BotCount(GameClone) or Countt >= .6
		
		RotArz.Arrow1.Arrow1.Color = StartColor
		RotArz.Arrow2.Arrow2.Color = StartColor
		
		GameClone.Responses:ClearAllChildren()
		
		if iDF ~= nil and InitEndCF ~= nil then
			iDF:SetPrimaryPartCFrame(InitEndCF)
		end
		
		--Gamne Loop
		
		local GamePlayers = GameClone.Players:GetChildren()
		
		local RnPlrNum = Rnd:NextInteger(1,#GamePlayers)
		
		GameClone.CurrentPos.Value = RnPlrNum
		GameClone.CurrentPlayer.Value = GamePlayers[RnPlrNum].Name
		
		local CurrModel = GameClone.Arena.Value:FindFirstChild(GameClone.CurrentPlayer.Value)
		local ArrowPointer = GameClone.Arena.Value:FindFirstChild("PointArrow")
		
		--[[if CurrModel and ArrowPointer then
			local IeCF = CFrame.new(ArrowPointer.PrimaryPart.Position,Vector3.new(CurrModel.HumanoidRootPart.Position.X,ArrowPointer.PrimaryPart.Position.Y,CurrModel.HumanoidRootPart.Position.Z))*CFrame.Angles(0,math.rad(-180),0)
			game.ReplicatedStorage.Remotes.ArrowTween:FireAllClients(ArrowPointer.PrimaryPart,IeCF)
			
			local Counttt = 0

			repeat
				Counttt = Counttt + .05
				wait(.05)
			until #GameClone.Responses:GetChildren() >= #GameClone.Players:GetChildren() - BotCount(GameClone) or Counttt >= .6
			GameClone.Responses:ClearAllChildren()
			ArrowPointer:SetPrimaryPartCFrame(IeCF)
		end]]
		
		GameClone.Started.Value = true
		
		local GameWinner = nil
		local AllBots = false
		
		while (GameClone and GameClone.Parent and GameClone.Parent ~= nil) and GameWinner == nil and AllBots == false do
			
			--local GamePlayers = GameClone.Players:GetChildren()
			
			local TheArena = GameClone.Arena.Value
			if TheArena then
				local RotArrows = TheArena:FindFirstChild("RotArrows")
				local PointerArrow = TheArena:FindFirstChild("PointArrow")
				if RotArrows and PointerArrow then
					
					--Get the next player
					
					GameClone.CanJumpIn.Value = false
					
					if GameClone.JumpedIn.Value then
						GameClone.CurrentPos.Value = 0

						local Jound = false

						repeat
							GameClone.CurrentPos.Value = GameClone.CurrentPos.Value + 1
							if GamePlayers[GameClone.CurrentPos.Value].Name == GameClone.JumpedIn.Jumper.Value then
								Jound = true
							end
						until Jound

						GameClone.JumpedIn.Value = false
						GameClone.JumpedIn.Jumper.Value = ""
						GameClone.SelectedAction.Value = "None"

					end
					
					local CurrentPlayerPosition = GameClone.CurrentPos.Value

					if GameClone.Direction.Value == "Forwards" then
						CurrentPlayerPosition = CurrentPlayerPosition + 1
						if CurrentPlayerPosition > #GamePlayers then
							CurrentPlayerPosition = 1
						end
					else
						CurrentPlayerPosition = CurrentPlayerPosition - 1
						if CurrentPlayerPosition <= 0 then
							CurrentPlayerPosition = #GamePlayers
						end
					end

					GameClone.CurrentPos.Value = CurrentPlayerPosition
					GameClone.CurrentPlayer.Value = GamePlayers[CurrentPlayerPosition].Name
					
					local CurrentPlayer = GameClone.CurrentPlayer.Value
					local UpcomingAction = GameClone.UpcomingAction.Value
					
					local CurrentPlrF = GameClone.Players:FindFirstChild(GameClone.CurrentPlayer.Value)
					
					local CurrDum = TheArena:FindFirstChild(GameClone.CurrentPlayer.Value)
					if CurrDum then
						local IeeCF = CFrame.new(PointerArrow.PrimaryPart.Position,Vector3.new(CurrDum.HumanoidRootPart.Position.X,PointerArrow.PrimaryPart.Position.Y,CurrDum.HumanoidRootPart.Position.Z))*CFrame.Angles(0,math.rad(-180),0)
						game.ReplicatedStorage.Remotes.ArrowTween:FireAllClients(PointerArrow.PrimaryPart,IeeCF)

						local cCounttt = 0

						repeat
							cCounttt = cCounttt + .05
							wait(.05)
						until #GameClone.Responses:GetChildren() >= #GameClone.Players:GetChildren() - BotCount(GameClone) or cCounttt >= .25
						GameClone.Responses:ClearAllChildren()
						ArrowPointer:SetPrimaryPartCFrame(IeeCF)
					end
					
					for i,v in pairs(GameClone.Players:GetChildren()) do
						local UnoCall = v:FindFirstChild("UnoCall")
						if UnoCall then
							UnoCall:Destroy()
						end
					end
					
					--For when stacking and blufdfing is turned on
					
					local NoBluff = false
					
					local StackBluff = false
					if CurrentPlrF and GameClone.Settings.Stacking.Value then
						for i,v in pairs(CurrentPlrF.Cards:GetChildren()) do
							if self:CanPlayCard(GameClone,v) then
								StackBluff = true
								break
							end
						end
					end
					
					--
					
					if GameClone.SecondaryAction.Value == "BluffPrompt" then
						GameClone.SecondaryAction.Value = "None"
					end
					
					if GameClone.SecondaryAction.Value == "Bluff" and not StackBluff then
						
						GameClone.SecondaryAction.Value = "BluffPrompt"
						
						local TimerCounter = 0
						GameClone.Timer.Value = 5
						GameClone.Playable.Value = true
						GameClone.SelectedAction.Value = "None"

						repeat
							TimerCounter = TimerCounter + .1
							if TimerCounter >= 1 then
								GameClone.Timer.Value = GameClone.Timer.Value - 1
								TimerCounter = 0
								
								if self:IsBot(nil,GameClone.CurrentPlayer.Value) then
									
									local Choice = Rnd:NextInteger(1,2)
									if Choice == 1 then
										GameClone.SelectedAction.Value = "Challenge"
									else
										GameClone.SelectedAction.Value = "Challenge"
										--GameClone.SelectedAction.Value = "Draw"
									end
									
								end
								
							end
							wait(.1)
						until GameClone.Timer.Value <= 0 or GameClone.SelectedAction.Value ~= "None"
						
						if GameClone.SelectedAction.Value == "None" then
							GameClone.SelectedAction.Value = "Draw"
						end

						GameClone.Playable.Value = false
						GameClone.Timer.Value = 0
						
						GameClone.SecondaryAction.Value = "None"
						
						local ChallengeWon = false
						
						if GameClone.SelectedAction.Value == "Challenge" then
							
							for i,v in pairs(self:GetAllPlayers(GameClone)) do
								game.ReplicatedStorage.Remotes.PlayerConPopper:FireClient(v,GameClone.CurrentPlayer.Value,"Image","9374801911",nil,"BoxingBell")
							end
							
							local ChelledF = GameClone.Players:FindFirstChild(GameClone.SecondaryAction.PlayerChose.Value)
							if ChelledF then
								
								local CouldPlay = false
								
								for i,v in pairs(ChelledF.Cards:GetChildren()) do
									--print("Yee")
									if self:CanPlayCard(GameClone,v,"Chal") then
										--print(v.Type.Value .. " | " .. v.Name .. " | " .. v.Class.Value)
										--print("Yo")
										CouldPlay = true
										break
									end
								end
								
								if CouldPlay then
									ChallengeWon = true
								else
									ChallengeWon = false
								end
							end
						end
						
						wait(2)
						
						--Check to see if the challenge was possible
						
						if ChallengeWon and GameClone.SelectedAction.Value == "Challenge" then
							
							NoBluff = true
							
							for i,v in pairs(self:GetAllPlayers(GameClone)) do
								game.ReplicatedStorage.Remotes.PlayerConPopper:FireClient(v,GameClone.CurrentPlayer.Value,"Image","8071991135",.75,"CardConfirm",Color3.fromRGB(0, 225, 165))
							end
							
							if GameClone.SelectedAction.Value == "Challenge" then
								local ArenaChar = TheArena:FindFirstChild(GameClone.SecondaryAction.PlayerChose.Value)
								if ArenaChar then
									local CardMs = ArenaChar.Cards:GetChildren()
									local CardM = CardMs[Rnd:NextInteger(1,#CardMs)]
									if CardM then
										for i,v in pairs(self:GetAllPlayers(GameClone)) do
											game.ReplicatedStorage.Remotes.CardLift:FireClient(v,CardM)
										end

										self:ResponseWaiter(GameClone,.05,3,.05)

									end
								end
							end
							
							local LoserF = GameClone.Players:FindFirstChild(GameClone.SecondaryAction.PlayerChose.Value)
							if LoserF then
								
								repeat
									GameClone.DrawStack.Value = GameClone.DrawStack.Value - 1
									self:DrawFromPile(GameClone,LoserF.Name,true,"NoPlay")
									wait()
								until GameClone.DrawStack.Value <= 0
								GameClone.UpcomingAction.Value = "None"
								GameClone.StackCount.Value = 0
								GameClone.DrawStack.Value = 0
								
							end
							
							GameClone.UpcomingAction.Value = "None"
							GameClone.SecondaryAction.Value = "None"
							
							local RealPlr = game.Players:FindFirstChild(GameClone.CurrentPlayer.Value)
							if RealPlr then
								game.ReplicatedStorage.Remotes.QuickPostFix:FireClient(RealPlr,GameClone)
							end
							
						else
							
							GameClone.UpcomingAction.Value = "Draw"
							
							if GameClone.SelectedAction.Value == "Challenge" then
								GameClone.SecondaryAction.Value = "CantStack"
								GameClone.DrawStack.Value = GameClone.DrawStack.Value + 2
								GameClone.StackCount.Value = GameClone.StackCount.Value + 1
								
								for i,v in pairs(self:GetAllPlayers(GameClone)) do
									game.ReplicatedStorage.Remotes.PlayerConPopper:FireClient(v,GameClone.CurrentPlayer.Value,"Image","8071990635",nil,"Skip")
									if v.Name == GameClone.CurrentPlayer.Value then
										game.ReplicatedStorage.Remotes.SkipPopper:FireClient(v)
									end
								end
							else
								GameClone.SecondaryAction.Value = "None"
							end
							
						end
						
						GameClone.SelectedAction.Value = "None"
						GameClone.SecondaryAction.Value = "None"
						
					else
						
						--Stacking Overpowered the bluff
						GameClone.SecondaryAction.Value = "None"
						GameClone.SelectedAction.Value = "None"
						
					end
					
					GameClone.CanJumpIn.Value = true
					
					if GameClone.UpcomingAction.Value == "None" or (GameClone.UpcomingAction.Value == "Draw" and GameClone.Settings.Stacking.Value and GameClone.SecondaryAction.Value == "None") then
					
						--if not self:IsBot(nil,CurrentPlayer) then
							
						GameClone.Timer.Value = 10
						
						GameClone.Playable.Value = true
						
						local CurrCM = nil
						
						local TimerCounter = 0
						local SecPass = false
						
						repeat
							TimerCounter = TimerCounter + .1
							if TimerCounter >= 1 then
								
								local CanPlay = false

								if CurrentPlrF then
									local CardCheck = CurrentPlrF.Cards:GetChildren()
									for i,v in pairs(CardCheck) do
										if self:CanPlayCard(GameClone,v) then
											CanPlay = true
										end
									end
								end
								
								if not CanPlay and GameClone.UpcomingAction.Value == "Draw" then
									GameClone.SelectedAction.Value = "Draw"
								end
								
								GameClone.Timer.Value = GameClone.Timer.Value - 1
								TimerCounter = 0
								SecPass = true
								
							end
							
							if self:IsBot(nil,GameClone.CurrentPlayer.Value) and CurrentPlrF and SecPass then
								
								local PlayedCard = false
								local BotCardz = CurrentPlrF.Cards:GetChildren()
								
								for i,v in pairs(BotCardz) do
									if self:CanPlayCard(GameClone,v) then
										
										if #BotCardz == 2 then
											local UnoCC = Instance.new("IntValue")
											UnoCC.Name = "UnoCall"
											UnoCC.Parent = CurrentPlrF
										end
										
										v.Parent = GameClone.Discards
										GameClone.PreviousCard.Value = GameClone.CurrentCard.Value
										GameClone.CurrentCard.Value = v
										PlayedCard = true
										GameClone.SelectedAction.Value = "Card"
										break
									end
								end
								
								if not PlayedCard then
									GameClone.SelectedAction.Value = "Draw"
								end
							end
							
							wait(.1)
						until GameClone.Timer.Value <= 0 or GameClone.SelectedAction.Value ~= "None"
						
						GameClone.Playable.Value = false
						GameClone.Timer.Value = 0
						
						local DrawAction = nil
						
						if (GameClone.UpcomingAction.Value == "None" and (GameClone.SelectedAction.Value == "None" or GameClone.SelectedAction.Value == "Draw")) then
							DrawAction = self:DrawFromPile(GameClone,GameClone.CurrentPlayer.Value)
						elseif GameClone.UpcomingAction.Value == "Draw" and (GameClone.SelectedAction.Value == "None" or GameClone.SelectedAction.Value == "Draw") then
							
							repeat
								GameClone.DrawStack.Value = GameClone.DrawStack.Value - 1
								self:DrawFromPile(GameClone,GameClone.CurrentPlayer.Value,true,"NoPlay")
								wait()
							until GameClone.DrawStack.Value <= 0
							GameClone.UpcomingAction.Value = "None"
							GameClone.StackCount.Value = 0
							GameClone.DrawStack.Value = 0
							
							GameClone.SecondaryAction.Value = "None"
							
						end
						
						if GameClone.SecondaryAction.Value == "PlayKeep" then
							
							TimerCounter = 0
							GameClone.Timer.Value = 5
							GameClone.Playable.Value = true
							GameClone.SelectedAction.Value = "None"
							
							repeat
								TimerCounter = TimerCounter + .1
								if TimerCounter >= 1 then
									GameClone.Timer.Value = GameClone.Timer.Value - 1
									TimerCounter = 0
									
									if DrawAction then
										GameClone.SelectedAction.Value = DrawAction
									end
									
								end
								wait(.1)
							until GameClone.Timer.Value <= 0 or GameClone.SelectedAction.Value ~= "None"
							
							GameClone.Playable.Value = false
							GameClone.Timer.Value = 0
							
						end
						
						local Reverzed = false
						local CardModel = nil
						
						if GameClone.SelectedAction.Value == "Card" and CurrentPlrF then
							
							local PlrCrdz = CurrentPlrF.Cards:GetChildren()
							if #PlrCrdz == 1 then
								local PlrFF = GameClone.Players:FindFirstChild(GameClone.CurrentPlayer.Value)
								if PlrFF then
									PlrFF.Stats.UnoCalled.Value = PlrFF.Stats.UnoCalled.Value + 1

									local UnoCall = Instance.new("IntValue")
									UnoCall.Parent = CurrentPlrF
									UnoCall.Name = "UnoCall"

									for i,v in pairs(self:GetAllPlayers(GameClone)) do
										game.ReplicatedStorage.Remotes.PlayerConPopper:FireClient(v,GameClone.CurrentPlayer.Value,"Text","UNO",nil)
										game.ReplicatedStorage.Remotes.BigPopper:FireClient(v,9312284704,Color3.fromRGB(255,0,0),"UnoCall")
									end
								end
							end
							
							if self:HasCalledUno(GameClone,GameClone.CurrentPlayer.Value) and #CurrentPlrF.Cards:GetChildren() == 1 then
								local PlrFF = GameClone.Players:FindFirstChild(GameClone.CurrentPlayer.Value)
								if PlrFF then
									PlrFF.Stats.UnoCalled.Value = PlrFF.Stats.UnoCalled.Value + 1

									for i,v in pairs(self:GetAllPlayers(GameClone)) do
										game.ReplicatedStorage.Remotes.PlayerConPopper:FireClient(v,GameClone.CurrentPlayer.Value,"Text","UNO",nil)
										game.ReplicatedStorage.Remotes.BigPopper:FireClient(v,9312284704,Color3.fromRGB(255,0,0),"UnoCall")
									end
								end
							end
							
							local SelectedCard = GameClone.CurrentCard.Value
							
							if SelectedCard.Type.Value == "Wild Draw" and GameClone.Settings.Bluffing.Value then
								GameClone.SecondaryAction.PlayerChose.Value = GameClone.CurrentPlayer.Value
							end
							
							if SelectedCard.Type.Value == "Number" then
								
								GameClone.UpcomingAction.Value = "None"
								GameClone.SecondaryAction.Value = "None"
								
								if GameClone.Settings.SevenO.Value then
									if SelectedCard.Class.Value == "0" then
										GameClone.SecondaryAction.Value = "AllSwap"
									elseif SelectedCard.Class.Value == "7" then
										GameClone.SecondaryAction.Value = "Swap"
									end
								end
								
							elseif SelectedCard.Type.Value == "Draw" or SelectedCard.Type.Value == "Wild Draw" then
								
								GameClone.UpcomingAction.Value = "Draw"
								GameClone.DrawStack.Value = GameClone.DrawStack.Value + tonumber(SelectedCard.Class.Value)
								GameClone.StackCount.Value = GameClone.StackCount.Value + 1
								
								if SelectedCard.Type.Value == "Wild Draw" then
									
									local Colz = GameClone.ColorList:GetChildren()
									if #Colz > 0 then
										GameClone.SecondaryAction.Value = "PickColor"
									end
									
									CurrentPlrF.Stats.WildPlays.Value = CurrentPlrF.Stats.WildPlays.Value + 1
								end
								
							elseif SelectedCard.Type.Value == "Targeted Draw" then
								
								GameClone.DrawStack.Value = GameClone.DrawStack.Value + tonumber(SelectedCard.Class.Value)
								GameClone.StackCount.Value = GameClone.StackCount.Value + 1
								GameClone.SecondaryAction.Value = "PickPlayer"
								
								if GameClone.UpcomingAction.Value == "Draw" then
									GameClone.UpcomingAction.Value = "None"
								end
								
							elseif SelectedCard.Type.Value == "Skip" then
								
								GameClone.UpcomingAction.Value = "Skip"
								GameClone.UpcomingAction.Amount.Value = 1
								
								CurrentPlrF.Stats.SkipPlays.Value = CurrentPlrF.Stats.SkipPlays.Value + 1
								
							elseif SelectedCard.Type.Value == "Double Skip" then

								GameClone.UpcomingAction.Value = "Skip"
								GameClone.UpcomingAction.Amount.Value = 2

								CurrentPlrF.Stats.SkipPlays.Value = CurrentPlrF.Stats.SkipPlays.Value + 1
								
							elseif SelectedCard.Type.Value == "Skip Everyone" then

								GameClone.UpcomingAction.Value = "Skip"
								GameClone.UpcomingAction.Amount.Value = #GameClone.Players:GetChildren() - 1

								CurrentPlrF.Stats.SkipPlays.Value = CurrentPlrF.Stats.SkipPlays.Value + 1
								
							elseif SelectedCard.Type.Value == "Swap Hands" then
								
								GameClone.SecondaryAction.Value = "Swap"
								
							elseif SelectedCard.Type.Value == "Color Draw" then

								GameClone.UpcomingAction.Value = "ColorDraw"
								for i,v in pairs(self:GetAllPlayers(GameClone)) do
									game.ReplicatedStorage.Remotes.BigPopper:FireClient(v,"9497107550",SelectedCard.Color.Value,"CardCount")
								end
								
							elseif SelectedCard.Type.Value == "Discard Color" then
								
								for i,v in pairs(self:GetAllPlayers(GameClone)) do
									game.ReplicatedStorage.Remotes.BigPopper:FireClient(v,"9497108915",SelectedCard.Color.Value,"CardCount")
								end
								GameClone.SecondaryAction.Value = "DiscardColor"
								
							elseif SelectedCard.Type.Value == "Wild Number" then

								GameClone.SecondaryAction.Value = "PickNumber"
								
							elseif SelectedCard.Type.Value == "Reverse" then
								
								if GameClone.Direction.Value == "Forwards" then
									GameClone.Direction.Value = "Backwards"
								else
									GameClone.Direction.Value = "Forwards"
								end
								
								CurrentPlrF.Stats.ReversePlays.Value = CurrentPlrF.Stats.ReversePlays.Value + 1
								
								Reverzed = true
								
							elseif SelectedCard.Type.Value == "Wild" then
								
								local Colz = GameClone.ColorList:GetChildren()
								if #Colz > 0 then
									GameClone.SecondaryAction.Value = "PickColor"
								end
								
								CurrentPlrF.Stats.WildPlays.Value = CurrentPlrF.Stats.WildPlays.Value + 1
								
							end
							
							--
							
							local DumbCards = CurrDum.Cards:GetChildren()
							local ncdCard = DumbCards[Rnd:NextInteger(1,#DumbCards)]
							if ncdCard then
								CurrCM = ncdCard
								ncdCard.Parent = TheArena.DiscardsF
								GameClone.CurrentCM.Value = ncdCard
								self:ApplyCardData(ncdCard,GameClone.CurrentCard.Value.Type.Value,GameClone.CurrentCard.Value.Color.Value,GameClone.CurrentCard.Value.Class.Value,GameClone)
								
								local DiscardsFs = TheArena.DiscardsF:GetChildren()
								local FirstOneCF = TheArena.DiscardB.CFrame + Vector3.new(0,(#DiscardsFs-1)*.005,0)
								local ncdEndCF = CFrame.new((FirstOneCF).p,Vector3.new(CurrDum.HumanoidRootPart.CFrame.X,FirstOneCF.Y,CurrDum.HumanoidRootPart.CFrame.Z))*CFrame.Angles(math.rad(180),math.rad(-90 + Rnd:NextInteger(-15,15)),0)
								
								for i,v in pairs(self:GetAllPlayers(GameClone)) do
									game.ReplicatedStorage.Remotes.CardAnimation:FireClient(v,TheArena,GameClone,"DumbassFucker","OneCard",ncdCard,ncdEndCF)
									game.ReplicatedStorage.Remotes.CardAnimation:FireClient(v,TheArena,GameClone,GameClone.CurrentPlayer.Value,"PlayerSort",nil,nil)
								end
								
								local EndCF1 = RotArrows.Mid.AW1.C0*CFrame.Angles(math.rad(180),0,0)
								local EndCF2 = RotArrows.Mid.AW2.C0*CFrame.Angles(math.rad(180),0,0)
								
								if Reverzed then

									local RealPlrz = self:GetAllPlayers(GameClone)
									for i,v in pairs(RealPlrz) do
										game.ReplicatedStorage.Remotes.ArrowFullRotate:FireClient(v,EndCF1,EndCF2,RotArrows.Mid.AW1,RotArrows.Mid.AW2)
									end
									
								end
								
								local ncdCount = 0
								
								if RotArrows.Arrow1.Arrow1.Color ~= GameClone.CurrentCard.Value.Color.Value then
									local Plrz = self:GetAllPlayers(GameClone)
									for i,v in pairs(Plrz) do
										game.ReplicatedStorage.Remotes.RotArrowColor:FireClient(v,RotArrows,GameClone.CurrentCard.Value.Color.Value)
									end
								end

								repeat
									ncdCount = ncdCount + .05
									wait(.05)
								until #GameClone.Responses:GetChildren() >= self:RealPlayerCount(GameClone) or ncdCount >= .6
								GameClone.Responses:ClearAllChildren()
								
								ncdCard:SetPrimaryPartCFrame(ncdEndCF)
								
								RotArrows.Arrow1.Arrow1.Color = GameClone.CurrentCard.Value.Color.Value
								RotArrows.Arrow2.Arrow2.Color = GameClone.CurrentCard.Value.Color.Value
								
								if Reverzed then
									RotArrows.Mid.AW1.C0 = EndCF1
									RotArrows.Mid.AW2.C0 = EndCF2
								end
								
								local ncdDummy = GameClone.Arena.Value:FindFirstChild(GameClone.CurrentPlayer.Value)
								if ncdDummy then
									self:ReCFCards(ncdDummy)
								end
								
							end
							
						end
						
						if GameClone.SecondaryAction.Value ~= "None" then

							if GameClone.SecondaryAction.Value == "PickColor" then
								
								GameClone.SecondaryAction.ColorChose.Value = Color3.fromRGB(0,0,0)

								TimerCounter = 0
								GameClone.Timer.Value = 10
								GameClone.Playable.Value = true
								--GameClone.SelectedAction.Value = "None"

								local CurrPlr = game.Players:FindFirstChild(GameClone.CurrentPlayer.Value)
								if CurrPlr then
									game.ReplicatedStorage.Remotes.ColorPrompter:FireClient(CurrPlr,GameClone.ColorList)
								end

								repeat
									TimerCounter = TimerCounter + .1
									if TimerCounter >= 1 then
										GameClone.Timer.Value = GameClone.Timer.Value - 1
										TimerCounter = 0
									end
									if GameClone.Timer.Value <= 9 then
										if self:IsBot(nil,GameClone.CurrentPlayer.Value) then
											
											if CurrentPlrF then
												local FFCards = CurrentPlrF.Cards:GetChildren()
												local CardCol = FFCards[Rnd:NextInteger(1,#FFCards)]
												if CardCol and CardCol.Color.Value ~= Color3.fromRGB(0,0,0) then
													GameClone.SecondaryAction.ColorChose.Value = CardCol.Color.Value
												else
													local Colzz = GameClone.ColorList:GetChildren()

													local RndCol = Colzz[Rnd:NextInteger(1,#Colzz)]
													if RndCol then
														GameClone.SecondaryAction.ColorChose.Value = RndCol.Value
													end
												end
											end
											
											--[[local Colzz = GameClone.ColorList:GetChildren()

											local RndCol = Colzz[Rnd:NextInteger(1,#Colzz)]
											if RndCol then
												GameClone.SecondaryAction.ColorChose.Value = RndCol.Value
											end]]
										end
									end
									wait(.1)
								until GameClone.Timer.Value <= 0 or GameClone.SecondaryAction.ColorChose.Value ~= Color3.fromRGB(0,0,0)

								GameClone.Playable.Value = false
								GameClone.Timer.Value = 0

								if GameClone.SecondaryAction.ColorChose.Value == Color3.fromRGB(0,0,0) then
									
									for i,v in pairs(self:GetAllPlayers(GameClone)) do
										game.ReplicatedStorage.Remotes.CloseActions:FireClient(v)
									end

									local Colzz = GameClone.ColorList:GetChildren()

									local RndCol = Colzz[Rnd:NextInteger(1,#Colzz)]
									if RndCol then
										GameClone.SecondaryAction.ColorChose.Value = RndCol.Value
									end

								end

								local NewColor = GameClone.SecondaryAction.ColorChose.Value

								GameClone.SecondaryAction.ColorChose.Value = Color3.fromRGB(0,0,0)
								GameClone.SecondaryAction.Value = "None"
								
								if CurrPlr then
									game.ReplicatedStorage.Remotes.ColorPrompter:FireClient(CurrPlr,GameClone.ColorList,"Close")
								end
								
								GameClone.CurrentCard.Value.Color.Value = NewColor
								
								if RotArrows.Arrow1.Arrow1.Color ~= GameClone.CurrentCard.Value.Color.Value then
									local Plrz = self:GetAllPlayers(GameClone)
									for i,v in pairs(Plrz) do
										game.ReplicatedStorage.Remotes.RotArrowColor:FireClient(v,RotArrows,GameClone.CurrentCard.Value.Color.Value)
										if CurrCM then
											game.ReplicatedStorage.Remotes.RecolorLRG:FireClient(v,CurrCM,NewColor)
										end
									end
								end
								
								local tctcount = 0

								repeat
									tctcount = tctcount + .05
									wait(.05)
								until #GameClone.Responses:GetChildren() >= #GameClone.Players:GetChildren() - BotCount(GameClone) or tctcount >= .6
								GameClone.Responses:ClearAllChildren()

								RotArrows.Arrow1.Arrow1.Color = GameClone.CurrentCard.Value.Color.Value
								RotArrows.Arrow2.Arrow2.Color = GameClone.CurrentCard.Value.Color.Value
								
								if CurrCM then
									--CurrCM.Anchored = true
									CurrCM.CardBB.SG.Card.ColorLRG.ImageColor3 = NewColor
								end
								
							elseif GameClone.SecondaryAction.Value == "PickNumber" then
								
								TimerCounter = 0
								GameClone.Timer.Value = 10
								GameClone.Playable.Value = true
								--GameClone.SelectedAction.Value = "None"

								local CurrPlr = game.Players:FindFirstChild(GameClone.CurrentPlayer.Value)
								if CurrPlr then
									game.ReplicatedStorage.Remotes.NumberPrompter:FireClient(CurrPlr,GameClone.NumberList)
								end

								repeat
									TimerCounter = TimerCounter + .1
									if TimerCounter >= 1 then
										GameClone.Timer.Value = GameClone.Timer.Value - 1
										TimerCounter = 0
										
										local Numbz = GameClone.NumberList:GetChildren()
										if #Numbz <= 0 then
											GameClone.SecondaryAction.NumberChose.Value = "0"
											
											local RealCurrP = game.Players:FindFirstChild(GameClone.CurrentPlayer.Value)
											if RealCurrP then
												game.ReplicatedStorage.Remotes.CloseActions:FireClient(RealCurrP)
											end
											
										end
									end
									if GameClone.Timer.Value <= 9 then
										if self:IsBot(nil,GameClone.CurrentPlayer.Value) then
											
											local Numbz = GameClone.NumberList:GetChildren()
											if #Numbz > 0 then
												local Numbero = Numbz[Rnd:NextInteger(1,#Numbz)]
												GameClone.SecondaryAction.NumberChose.Value = Numbero.Name
											else
												GameClone.SecondaryAction.NumberChose.Value = "0"
											end
											
										end
									end
									wait(.1)
								until GameClone.Timer.Value <= 0 or GameClone.SecondaryAction.NumberChose.Value ~= ""

								GameClone.Playable.Value = false
								GameClone.Timer.Value = 0
								
								if GameClone.SecondaryAction.NumberChose.Value == "" then
									
									for i,v in pairs(self:GetAllPlayers(GameClone)) do
										game.ReplicatedStorage.Remotes.CloseActions:FireClient(v)
									end
									
									local Numbz = GameClone.NumberList:GetChildren()
									if #Numbz > 0 then
										local Numbero = Numbz[Rnd:NextInteger(1,#Numbz)]
										GameClone.SecondaryAction.NumberChose.Value = Numbero.Name
									else
										GameClone.SecondaryAction.NumberChose.Value = "0"
									end
								end
								
								CurrCM.CardBB.SG.Card.MidTxt.Text = GameClone.SecondaryAction.NumberChose.Value
								
								if GameClone.CurrentCard.Value ~= nil then
									GameClone.CurrentCard.Value.Class.Value = GameClone.SecondaryAction.NumberChose.Value
								end
								
								for i,v in pairs(self:GetAllPlayers(GameClone)) do
									game.ReplicatedStorage.Remotes.BigPopper:FireClient(v,GameClone.SecondaryAction.NumberChose.Value,Color3.fromRGB(255,0,0),"Boom")
								end
								
								GameClone.SecondaryAction.NumberChose.Value = ""
								GameClone.SecondaryAction.Value = "None"
								
							elseif GameClone.SecondaryAction.Value == "Swap" then
								
								TimerCounter = 0
								GameClone.Timer.Value = 10
								GameClone.Playable.Value = false
								GameClone.SelectedAction.Value = "None"
								
								GameClone.SecondaryAction.PlayerChose.Value = ""
								
								local RealCurrP = game.Players:FindFirstChild(GameClone.CurrentPlayer.Value)
								if RealCurrP then
									game.ReplicatedStorage.Remotes.SwapPrompt:FireClient(RealCurrP,GameClone)
								end
								
								for i,v in pairs(self:GetAllPlayers(GameClone)) do
									game.ReplicatedStorage.Remotes.BigPopper:FireClient(v,"9400888297",Color3.fromRGB(255,0,0),"CardConfirm")
								end
								
								repeat
									TimerCounter = TimerCounter + .1
									if TimerCounter >= 1 then
										GameClone.Timer.Value = GameClone.Timer.Value - 1
										TimerCounter = 0
									end
									if GameClone.Timer.Value <= 9 then
										if self:IsBot(nil,GameClone.CurrentPlayer.Value) then
											
											local Plerz = GameClone.Players:GetChildren()
											
											for a,b in pairs(Plerz) do
												if b.Name == GameClone.CurrentPlayer.Value then
													table.remove(Plerz,a)
													break
												end
											end
											
											local Pler = Plerz[Rnd:NextInteger(1,#Plerz)]
											if Pler then
												GameClone.SecondaryAction.PlayerChose.Value = Pler.Name
											end
											
										end
									end
									wait(.1)
								until GameClone.Timer.Value <= 0 or GameClone.SecondaryAction.PlayerChose.Value ~= ""

								GameClone.Playable.Value = false
								GameClone.Timer.Value = 0
								
								if GameClone.SecondaryAction.PlayerChose.Value == "" then
									--print("No Swap Chosen")
									local Plerz = GameClone.Players:GetChildren()

									for a,b in pairs(Plerz) do
										if b.Name == GameClone.CurrentPlayer.Value then
											table.remove(Plerz,a)
											--print("Removing Current Player")
											break
										end
									end

									local Pler = Plerz[Rnd:NextInteger(1,#Plerz)]
									if Pler then
										--print(Pler)
										GameClone.SecondaryAction.PlayerChose.Value = Pler.Name
									end
									
									for i,v in pairs(self:GetAllPlayers(GameClone)) do
										game.ReplicatedStorage.Remotes.CloseActions:FireClient(v)
									end
								end
								
								--Do The Swap
								
								local ChosenPF = GameClone.Players:FindFirstChild(GameClone.SecondaryAction.PlayerChose.Value)
								if ChosenPF and CurrentPlrF then
									
									local ChosenCards = ChosenPF.Cards:GetChildren()
									local CurrentPC = CurrentPlrF.Cards:GetChildren()
									
									for i,v in pairs(ChosenCards) do
										v.Parent = CurrentPlrF.Cards
									end
									
									for i,v in pairs(CurrentPC) do
										v.Parent = ChosenPF.Cards
									end
									
									local CurrCrdz = CurrentPlrF.Cards:GetChildren()
									if #CurrCrdz == 1 then
										local PlrFF = GameClone.Players:FindFirstChild(GameClone.CurrentPlayer.Value)
										if PlrFF then
											PlrFF.Stats.UnoCalled.Value = PlrFF.Stats.UnoCalled.Value + 1
											
											local UnoCC = Instance.new("IntValue")
											UnoCC.Name = "UnoCall"
											UnoCC.Parent = CurrentPlrF
											
											for i,v in pairs(self:GetAllPlayers(GameClone)) do
												game.ReplicatedStorage.Remotes.PlayerConPopper:FireClient(v,GameClone.CurrentPlayer.Value,"Text","UNO",nil)
												game.ReplicatedStorage.Remotes.BigPopper:FireClient(v,9312284704,Color3.fromRGB(255,0,0),"UnoCall")
											end
										end
									end
									
									local ChosenDummy = TheArena:FindFirstChild(ChosenPF.Name)
									local CurrentDumm1 = TheArena:FindFirstChild(CurrentPlrF.Name)
									if ChosenDummy and CurrentDumm1 then
										
										local Dum1Cards = ChosenDummy.Cards:GetChildren()
										local Dum2Cards = CurrentDumm1.Cards:GetChildren()
										
										for i,v in pairs(Dum1Cards) do
											v.Parent = CurrentDumm1.Cards
										end
										
										for i,v in pairs(Dum2Cards) do
											v.Parent = ChosenDummy.Cards
										end
										
									end
									
									for i,v in pairs(self:GetAllPlayers(GameClone)) do
										game.ReplicatedStorage.Remotes.CardAnimation:FireClient(v,TheArena,GameClone,ChosenPF.Name,"PlayerSort",nil,nil)
										game.ReplicatedStorage.Remotes.CardAnimation:FireClient(v,TheArena,GameClone,CurrentPlrF.Name,"PlayerSort",nil,nil)
										spawn(function()
											wait(1)
											game.ReplicatedStorage.Remotes.ResortCards:FireClient(v)
										end)
									end
									
									self:ResponseWaiter(GameClone,.05,1,.05)
									
									self:ReCFCards(ChosenDummy)
									self:ReCFCards(CurrentDumm1)
									
								end
								
							elseif GameClone.SecondaryAction.Value == "PickPlayer" then
								
								TimerCounter = 0
								GameClone.Timer.Value = 10
								GameClone.Playable.Value = false
								GameClone.SelectedAction.Value = "None"

								GameClone.SecondaryAction.PlayerChose.Value = ""

								local RealCurrP = game.Players:FindFirstChild(GameClone.CurrentPlayer.Value)
								if RealCurrP then
									game.ReplicatedStorage.Remotes.SwapPrompt:FireClient(RealCurrP,GameClone)
								end

								for i,v in pairs(self:GetAllPlayers(GameClone)) do
									game.ReplicatedStorage.Remotes.BigPopper:FireClient(v,"9481290686",Color3.fromRGB(255,0,0),"CardConfirm")
								end

								repeat
									TimerCounter = TimerCounter + .1
									if TimerCounter >= 1 then
										GameClone.Timer.Value = GameClone.Timer.Value - 1
										TimerCounter = 0
									end
									if GameClone.Timer.Value <= 9 then
										if self:IsBot(nil,GameClone.CurrentPlayer.Value) then

											local Plerz = GameClone.Players:GetChildren()

											for a,b in pairs(Plerz) do
												if b.Name == GameClone.CurrentPlayer.Value then
													table.remove(Plerz,a)
													break
												end
											end

											local Pler = Plerz[Rnd:NextInteger(1,#Plerz)]
											if Pler then
												GameClone.SecondaryAction.PlayerChose.Value = Pler.Name
											end

										end
									end
									wait(.1)
								until GameClone.Timer.Value <= 0 or GameClone.SecondaryAction.PlayerChose.Value ~= ""

								GameClone.Playable.Value = false
								GameClone.Timer.Value = 0

								if GameClone.SecondaryAction.PlayerChose.Value == "" then
									local Plerz = GameClone.Players:GetChildren()

									for a,b in pairs(Plerz) do
										if b.Name == GameClone.CurrentPlayer.Value then
											table.remove(Plerz,a)
											break
										end
									end

									local Pler = Plerz[Rnd:NextInteger(1,#Plerz)]
									if Pler then
										GameClone.SecondaryAction.PlayerChose.Value = Pler.Name
									end
								end
								
								for i,v in pairs(self:GetAllPlayers(GameClone)) do
									game.ReplicatedStorage.Remotes.BigPopper:FireClient(v,"9481290686",Color3.fromRGB(85, 170, 127),"JumpIn")
									game.ReplicatedStorage.Remotes.CloseActions:FireClient(v)
								end
								
								wait(1)
								
								repeat
									GameClone.DrawStack.Value = GameClone.DrawStack.Value - 1
									self:DrawFromPile(GameClone,GameClone.SecondaryAction.PlayerChose.Value,true,"NoPlay")
									wait()
								until GameClone.DrawStack.Value <= 0
								GameClone.UpcomingAction.Value = "None"
								GameClone.StackCount.Value = 0
								GameClone.DrawStack.Value = 0
								GameClone.SecondaryAction.Value = "None"
								
							elseif GameClone.SecondaryAction.Value == "AllSwap" then
								
								for i,v in pairs(self:GetAllPlayers(GameClone)) do
									game.ReplicatedStorage.Remotes.BigPopper:FireClient(v,"9400887753",Color3.fromRGB(255,0,0),"Warn")
								end
								
								wait(1)
								
								local PlrListz = GameClone.Players:GetChildren()
								
								for i,v in pairs(PlrListz) do
									
									local NextPlrNum = i + 1
									if NextPlrNum > #PlrListz then
										NextPlrNum = 1
									end
									
									local NextPlr = PlrListz[NextPlrNum]
									if NextPlr then
										
										for a,b in pairs(v.Cards:GetChildren()) do
											b.Parent = NextPlr.NextCards
										end
										
										local NextDummy = TheArena:FindFirstChild(NextPlr.Name)
										local OurDummy = TheArena:FindFirstChild(v.Name)
										if NextDummy and OurDummy then
											for a,b in pairs(OurDummy.Cards:GetChildren()) do
												b.Parent = NextDummy.NextCards
											end
										end
										
									end
									
								end
								
								for i,v in pairs(GameClone.Players:GetChildren()) do
									for a,b in pairs(v.NextCards:GetChildren()) do
										b.Parent = v.Cards
									end
									
									local TheDummy = TheArena:FindFirstChild(v.Name)
									if TheDummy then
										for a,b in pairs(TheDummy.NextCards:GetChildren()) do
											b.Parent = TheDummy.Cards
										end
									end
									
								end
								
								for i,v in pairs(self:GetAllPlayers(GameClone)) do
									for a,b in pairs(GameClone.Players:GetChildren()) do
										game.ReplicatedStorage.Remotes.CardAnimation:FireClient(v,TheArena,GameClone,b.Name,"PlayerSort",nil,nil)
									end
								end
								
								self:ResponseWaiter(GameClone,.05,1,.05)
								
								for a,b in pairs(GameClone.Players:GetChildren()) do
									local TheDummy = TheArena:FindFirstChild(b.Name)
									if TheDummy then
										self:ReCFCards(TheDummy)
									end
								end
								
								if CurrentPlrF then
									local CurrCrdz = CurrentPlrF.Cards:GetChildren()
									if #CurrCrdz == 1 then
										local PlrFF = GameClone.Players:FindFirstChild(GameClone.CurrentPlayer.Value)
										if PlrFF then
											PlrFF.Stats.UnoCalled.Value = PlrFF.Stats.UnoCalled.Value + 1

											local UnoCC = Instance.new("IntValue")
											UnoCC.Name = "UnoCall"
											UnoCC.Parent = CurrentPlrF

											for i,v in pairs(self:GetAllPlayers(GameClone)) do
												game.ReplicatedStorage.Remotes.PlayerConPopper:FireClient(v,GameClone.CurrentPlayer.Value,"Text","UNO",nil)
												game.ReplicatedStorage.Remotes.BigPopper:FireClient(v,9312284704,Color3.fromRGB(255,0,0),"UnoCall")
												spawn(function()
													wait(1)
													game.ReplicatedStorage.Remotes.ResortCards:FireClient(v)
												end)
											end
										end
									end
								end
								
							elseif GameClone.SecondaryAction.Value == "DiscardColor" then
								
								local CirrCard = GameClone.CurrentCard.Value
								if CirrCard ~= nil and CurrentPlrF then
									
									for i,v in pairs(CurrentPlrF.Cards:GetChildren()) do
										if v.Color.Value == CirrCard.Color.Value then
											wait(.25)
											v.Parent = GameClone.Discards
											
											GameClone.PreviousCard.Value = GameClone.CurrentCard.Value
											GameClone.CurrentCard.Value = v
											
											local PlrCrdz = CurrentPlrF.Cards:GetChildren()
											if #PlrCrdz == 1 then
												local PlrFF = GameClone.Players:FindFirstChild(GameClone.CurrentPlayer.Value)
												if PlrFF then
													PlrFF.Stats.UnoCalled.Value = PlrFF.Stats.UnoCalled.Value + 1
													
													local UnoCall = Instance.new("IntValue")
													UnoCall.Parent = CurrentPlrF
													UnoCall.Name = "UnoCall"

													for i,v in pairs(self:GetAllPlayers(GameClone)) do
														game.ReplicatedStorage.Remotes.PlayerConPopper:FireClient(v,GameClone.CurrentPlayer.Value,"Text","UNO",nil)
														game.ReplicatedStorage.Remotes.BigPopper:FireClient(v,9312284704,Color3.fromRGB(255,0,0),"UnoCall")
													end
												end
											end
											
											local DumbCards = CurrDum.Cards:GetChildren()
											local ncdCard = DumbCards[Rnd:NextInteger(1,#DumbCards)]
											if ncdCard then
												CurrCM = ncdCard
												GameClone.CurrentCM.Value = ncdCard
												ncdCard.Parent = TheArena.DiscardsF
												self:ApplyCardData(ncdCard,v.Type.Value,v.Color.Value,v.Class.Value,GameClone)

												local DiscardsFs = TheArena.DiscardsF:GetChildren()
												local FirstOneCF = TheArena.DiscardB.CFrame + Vector3.new(0,(#DiscardsFs-1)*.005,0)
												local ncdEndCF = CFrame.new((FirstOneCF).p,Vector3.new(CurrDum.HumanoidRootPart.CFrame.X,FirstOneCF.Y,CurrDum.HumanoidRootPart.CFrame.Z))*CFrame.Angles(math.rad(180),math.rad(-90 + Rnd:NextInteger(-15,15)),0)

												for i,v in pairs(self:GetAllPlayers(GameClone)) do
													game.ReplicatedStorage.Remotes.CardAnimation:FireClient(v,TheArena,GameClone,"DumbassFucker","OneCard",ncdCard,ncdEndCF,"Fast")
													game.ReplicatedStorage.Remotes.CardAnimation:FireClient(v,TheArena,GameClone,GameClone.CurrentPlayer.Value,"PlayerSort",nil,nil,"Fast")
												end
												
												local ncdCount = 0

												repeat
													ncdCount = ncdCount + .05
													wait(.05)
												until #GameClone.Responses:GetChildren() >= self:RealPlayerCount(GameClone) or ncdCount >= .2
												GameClone.Responses:ClearAllChildren()

												ncdCard:SetPrimaryPartCFrame(ncdEndCF)

												local ncdDummy = GameClone.Arena.Value:FindFirstChild(GameClone.CurrentPlayer.Value)
												if ncdDummy then
													self:ReCFCards(ncdDummy)
												end

											end
											
											--wait(1)
										end
									end
									
								end
								
							end

						end
						
						GameClone.SecondaryAction.Value = "None"
						
						if GameClone.SelectedAction.Value == "Card" and GameClone.CurrentCard.Value and GameClone.CurrentCard.Value.Type.Value == "Wild Draw" and GameClone.Settings.Bluffing.Value and GameClone.StackCount.Value <= 1 then
							GameClone.SecondaryAction.Value = "Bluff"
							GameClone.SecondaryAction.PlayerChose.Value = GameClone.CurrentPlayer.Value
						else
							GameClone.SecondaryAction.Value = "None"
							GameClone.SecondaryAction.PlayerChose.Value = ""
						end
						
						GameClone.SelectedAction.Value = "None"
						
						local PlayerCC = GameClone.Players:FindFirstChild(GameClone.CurrentPlayer.Value)
						if PlayerCC then
							local CardzP = PlayerCC.Cards:GetChildren()
							--[[if #CardzP <= 0 then
								GameWinner = PlayerCC.Name
								break
							else]]if #CardzP == 1 and not self:HasCalledUno(GameClone,GameClone.CurrentPlayer.Value) then
								
								local realCurr = game.Players:FindFirstChild(GameClone.CurrentPlayer.Value)
								if realCurr then
									game.ReplicatedStorage.Remotes.UnoPopper:FireClient(realCurr,true)
								end
								
								for i = 1,2 do
									--self:DrawFromPile(GameClone,GameClone.CurrentPlayer.Value,true,"NoPlay")
								end
							end
						end
							
						--else
							--self:BotPlay(GameClone,CurrentPlayer)
						--end
						
					else
					
						if GameClone.UpcomingAction.Value == "Draw" then
							
							local Stacked = false
							
							wait(1)
							
							if not Stacked then
								repeat
									GameClone.DrawStack.Value = GameClone.DrawStack.Value - 1
									
									local DiscardCount = GameClone.Discards:GetChildren()
									local DrawCount = GameClone.Draws:GetChildren()
									
									if #DrawCount + #DiscardCount <= 1 then
										GameClone.DrawStack.Value = 0
									end
									
									self:DrawFromPile(GameClone,GameClone.CurrentPlayer.Value,true,"NoPlay")
									--wait()
								until GameClone.DrawStack.Value <= 0
								GameClone.UpcomingAction.Value = "None"
								GameClone.StackCount.Value = 0
								GameClone.DrawStack.Value = 0
								GameClone.SecondaryAction.Value = "None"
							end
							
						elseif GameClone.UpcomingAction.Value  == "Skip" then
							
							GameClone.UpcomingAction.Amount.Value = GameClone.UpcomingAction.Amount.Value - 1
							if GameClone.UpcomingAction.Amount.Value <= 0 then
								GameClone.UpcomingAction.Amount.Value = 0
								GameClone.UpcomingAction.Value = "None"
							end
							
							for i,v in pairs(self:GetAllPlayers(GameClone)) do
								game.ReplicatedStorage.Remotes.PlayerConPopper:FireClient(v,GameClone.CurrentPlayer.Value,"Image","8071990635",nil)
								game.ReplicatedStorage.Remotes.BigPopper:FireClient(v,"8071990635",Color3.fromRGB(255,0,0),"Skip")
								if v.Name == GameClone.CurrentPlayer.Value then
									game.ReplicatedStorage.Remotes.SkipPopper:FireClient(v)
								end
							end
							
						elseif GameClone.UpcomingAction.Value  == "ColorDraw" then
							
							self:DrawFromPile(GameClone,GameClone.CurrentPlayer.Value,true,"ColorDraw",GameClone.CurrentCard.Value.Color.Value)
							
							GameClone.UpcomingAction.Value = "None"
							
						end
					
					end
					
				end
				
				for i,v in pairs(GameClone.Players:GetChildren()) do
					local CardZP = v.Cards:GetChildren()
					if #CardZP == 0 then
						GameWinner = v.Name
						break
					end
				end
				
			end
			
			if self:RealPlayerCount(GameClone) <= 0 then
				AllBots = true
			end
			
			wait(.4)
		end
		
		--If the game was all bots
		
		if AllBots then
			
			for i,v in pairs(GameClone.Spectators:GetChildren()) do
				local PlrFinder = game.Players:FindFirstChild(v.Name)
				if PlrFinder then
					game.ReplicatedStorage.Remotes.UnSpec:FireClient(PlrFinder)
				end
			end
			
			GameArena:Destroy()
			GameClone:Destroy()
			return
		end
		
		--Game Ending animation
		
		GameClone.DrawStack.Value = 0
		GameClone.StackCount.Value = 0
		
		for i,v in pairs(GameClone.Players:GetChildren()) do
			local pDum = GameClone.Arena.Value:FindFirstChild(v.Name)
			if pDum then
				local CardModlz = pDum.Cards:GetChildren() 
				for a,b in pairs(v.Cards:GetChildren()) do
					self:ApplyCardData(CardModlz[a],b.Type.Value,b.Color.Value,b.Class.Value,GameClone)
					local DataClone = b:Clone()
					DataClone.Name = "Data"
					DataClone.Parent = CardModlz[a]
				end
			end
		end
		
		GameClone.Responses:ClearAllChildren()
		
		local GamePlrz = self:GetAllPlayers(GameClone)
		for i,v in pairs(GamePlrz) do
			game.ReplicatedStorage.Remotes.EndofGameCards:FireClient(v,GameClone)
			
			local Char = game.Workspace:FindFirstChild(v.Name)
			if Char then
				local Root = Char:FindFirstChild("HumanoidRootPart")
				if Root then
					Root.Anchored = false
					Root.CFrame = game.Workspace.SuperULobby.SpawnLocation.CFrame + Vector3.new(0,2,0)
					
					local Humi = Char:FindFirstChild("Humi")
					if Humi then
						Humi.Name = "Humanoid"
					end
				end
			end
			
		end
		GameClone.Responses:ClearAllChildren()
		local MostCards = 10
		
		local EndCount = 0
		
		repeat
			EndCount = EndCount + .1
			wait(.1)
		until EndCount >= 4 or #GameClone.Responses:GetChildren() >= self:RealPlayerCount(GameClone)
		GameClone.Responses:ClearAllChildren()
		
		local GamePlrz = self:GetAllPlayers(GameClone)
		for i,v in pairs(GamePlrz) do
			game.ReplicatedStorage.Remotes.CameraReturn:FireClient(v)
		end
		
		EndCount = 0
		
		repeat
			EndCount = EndCount + .1
			wait(.1)
		until EndCount >= 2 or #GameClone.Responses:GetChildren() >= #GameClone.Players:GetChildren() - BotCount(GameClone)
		GameClone.Responses:ClearAllChildren()
		
		--Game Winner stuff
		
		local PlayerPoints = {}
		
		for i,v in pairs(GameClone.Players:GetChildren()) do
			
			local Teb = {
				Player = v.Name,
				Points = 0
			}
			
			for a,b in pairs(v.Cards:GetChildren()) do
				if b.Type.Value == "Number" then
					Teb["Points"] = Teb["Points"] + tonumber(b.Class.Value)
				elseif b.Type.Value == "Reverse" or b.Type.Value == "Skip" or b.Type.Value == "Draw" then
					Teb["Points"] = Teb["Points"] + 20
				end
			end
			
			table.insert(PlayerPoints,1,Teb)
			
		end
		
		local WinnerData = game.ReplicatedStorage.PlayerData:FindFirstChild(GameWinner)
		if WinnerData then
			WinnerData.Stats.Wins.Value = WinnerData.Stats.Wins.Value + 1
		end
		
		local WinnerDummy = game.ReplicatedStorage.MiscAssets.Dummy:Clone()
		WinnerDummy.Name = GameWinner .. "Dummy"
		WinnerDummy.Parent = game.Workspace.WinnerModels
		
		if not self:IsBot(nil,GameWinner) then
			local WinnerId = game.Players:GetUserIdFromNameAsync(GameWinner)
			local WinnerDescr = game.Players:GetHumanoidDescriptionFromUserId(WinnerId)
			WinnerDummy.Humanoid:ApplyDescription(WinnerDescr)
		end
		
		WinnerDummy.HumanoidRootPart.Anchored = true
		WinnerDummy.HumanoidRootPart.CFrame = game.Workspace.CamP.CFrame*CFrame.new(0,0,-5)*CFrame.Angles(0,math.rad(180),0)*CFrame.new(7,0,0)
		
		local LoserPlacings = {}
		
		--Sort the losers
		repeat
			
			local CurrentSetter = ""
			local CurrentPoints = 9999999999
			local CurrentIndex = nil
			
			for i,v in pairs(PlayerPoints) do
				if v["Points"] < CurrentPoints then
					CurrentSetter = v["Player"]
					CurrentPoints = v["Points"]
					CurrentIndex = i
				end
			end
			
			local NewAdd = PlayerPoints[CurrentIndex]
			
			if NewAdd["Player"] ~= GameWinner then
				table.insert(LoserPlacings,#LoserPlacings+1,NewAdd)
			end
			
			table.remove(PlayerPoints,CurrentIndex)
			
		until #PlayerPoints <= 0
		
		for i,v in pairs(GameClone.Players:GetChildren()) do
			
			local StatsTable = {}
			
			local AwardedXP = 25
			local AwardedCoins = 15
			
			for a,b in pairs(v.Stats:GetChildren()) do
				StatsTable[b.Name] = b.Value
				
				AwardedXP += math.clamp(b.Value,0,5)
				AwardedCoins += math.clamp(b.Value,0,5)
			end
			
			for c,d in pairs(LoserPlacings) do
				if d["Player"] == v.Name then
					StatsTable["Placement"] = c + 1
					
					break
				end
			end
			
			if v.Name == GameWinner then
				StatsTable["Placement"] = 1
				
				AwardedXP += 15
				AwardedCoins += 15
				
			end
			
			if GameClone.LobbyType.Value == "Custom" or GameClone.Settings.StartCards.Value < 5 then
				AwardedCoins = 0
				AwardedXP = 0
			end
			
			LevelHandler:AddXP(v.Name,AwardedXP)
			Util:AddCoins(v.Name,AwardedCoins)
			
			local GameP = game.Players:FindFirstChild(v.Name)
			if GameP then
				
				game.ReplicatedStorage.Remotes.ResultsScreen:FireClient(GameP,GameWinner,StatsTable,LoserPlacings,GameClone.LobbyType.Value,GameClone.Settings.StartCards.Value)
				
			end
		end
		
		--Get it ready for a remote event
		
		for i,v in pairs(GameClone.Spectators:GetChildren()) do
			local PlrFinder = game.Players:FindFirstChild(v.Name)
			if PlrFinder then
				game.ReplicatedStorage.Remotes.UnSpec:FireClient(PlrFinder)
			end
		end
		
		GameClone.Arena.Value:Destroy()
		GameClone:Destroy()
		
	end
	
end

return module