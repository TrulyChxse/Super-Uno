--X_Z

--//Consts

local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

local Camera = game.Workspace.Camera

game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList,false)

--//Waitss

script.Parent.Parent.Parent:WaitForChild("RealGame")

game.ReplicatedStorage:WaitForChild("Unboxings")

game.ReplicatedStorage:WaitForChild("Remotes")
game.ReplicatedStorage.Remotes:WaitForChild("Notification")
game.ReplicatedStorage.Remotes:WaitForChild("InitGame")
game.ReplicatedStorage.Remotes:WaitForChild("CardAnimation")
game.ReplicatedStorage.Remotes:WaitForChild("TrackDeck")
game.ReplicatedStorage.Remotes:WaitForChild("TrackGame")
game.ReplicatedStorage.Remotes:WaitForChild("ArrowTween")
game.ReplicatedStorage.Remotes:WaitForChild("RotArrowColor")
game.ReplicatedStorage.Remotes:WaitForChild("ResultsScreen")
game.ReplicatedStorage.Remotes:WaitForChild("EndofGameCards")
game.ReplicatedStorage.Remotes:WaitForChild("CameraReturn")
game.ReplicatedStorage.Remotes:WaitForChild("AddConInfo")
game.ReplicatedStorage.Remotes:WaitForChild("PlayerConPopper")
game.ReplicatedStorage.Remotes:WaitForChild("BigPopper")
game.ReplicatedStorage.Remotes:WaitForChild("UnoPopper")
game.ReplicatedStorage.Remotes:WaitForChild("ArrowFullRotate")
game.ReplicatedStorage.Remotes:WaitForChild("SkipPopper")
game.ReplicatedStorage.Remotes:WaitForChild("ColorPrompter")
game.ReplicatedStorage.Remotes:WaitForChild("RecolorLRG")
game.ReplicatedStorage.Remotes:WaitForChild("CardLift")
game.ReplicatedStorage.Remotes:WaitForChild("QuickPostFix")
game.ReplicatedStorage.Remotes:WaitForChild("SwapPrompt")
game.ReplicatedStorage.Remotes:WaitForChild("QuitLobby")
game.ReplicatedStorage.Remotes:WaitForChild("GameLeaveNotif")
game.ReplicatedStorage.Remotes:WaitForChild("NumberPrompter")
game.ReplicatedStorage.Remotes:WaitForChild("CloseActions")
game.ReplicatedStorage.Remotes:WaitForChild("LevelUpPopper")
game.ReplicatedStorage.Remotes:WaitForChild("CoinGainPopper")
game.ReplicatedStorage.Remotes:WaitForChild("UnSpec")
game.ReplicatedStorage.Remotes:WaitForChild("CrateUnbox")
game.ReplicatedStorage.Remotes:WaitForChild("DailyOpener")
game.ReplicatedStorage.Remotes:WaitForChild("RefreshGamepass")
game.ReplicatedStorage.Remotes:WaitForChild("RefreshPrestige")
game.ReplicatedStorage.Remotes:WaitForChild("UnobxedList")
game.ReplicatedStorage.Remotes:WaitForChild("InitializeTrade")
game.ReplicatedStorage.Remotes:WaitForChild("TradeNotif")
game.ReplicatedStorage.Remotes:WaitForChild("RefreshTrade")
game.ReplicatedStorage.Remotes:WaitForChild("RefreshLeader")
game.ReplicatedStorage.Remotes:WaitForChild("ResortCards")

script:WaitForChild("ButtonManager")
script:WaitForChild("BindableManager")
script:WaitForChild("UIBoxManager")
script:WaitForChild("LobbyManager")
script:WaitForChild("NotificationManager")
script:WaitForChild("CardManager")
script:WaitForChild("PlayerConManager")
script:WaitForChild("Util")
script:WaitForChild("LeaderboardManager")
script:WaitForChild("TradeListManager")

game.ReplicatedStorage:WaitForChild("Lobbies")
game.ReplicatedStorage.Lobbies:WaitForChild("Classic")
game.ReplicatedStorage.Lobbies:WaitForChild("Super")
game.ReplicatedStorage.Lobbies:WaitForChild("Custom")

--//Services

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ProximityService = game:GetService("ProximityPromptService")
local UserInputService = game:GetService("UserInputService")
local PhysicsService = game:GetService("PhysicsService")
local GuiService = game:GetService("GuiService")
local GamepadService = game:GetService("GamepadService")
local MarketplaceService = game:GetService("MarketplaceService")

--//Modules

local ButtonManger = require(script.ButtonManager)
local BindableManager = require(script.BindableManager)
local UIBoxManager = require(script.UIBoxManager)
local LobbyManager = require(script.LobbyManager)
local NotificationManager = require(script.NotificationManager)
local CardManager = require(script.CardManager)
local PlayerConManager = require(script.PlayerConManager)
local Util = require(script.Util)
local LeaderboardManager = require(script.LeaderboardManager)
local TradeListManager = require(script.TradeListManager)

--//Variables

local TransTI = TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut)
local CardTI = TweenInfo.new(.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
local DrawTI = TweenInfo.new(.13,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
local DrawTI2 = TweenInfo.new(.07,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
local ArrowTI = TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut)
local ShadowTI = TweenInfo.new(.3,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut)
local ColRTI = TweenInfo.new(.3,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut)
local WinnerTI = TweenInfo.new(.5,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut)

local GameUI = script.Parent
local RealUI = script.Parent.Parent.Parent.RealGame

local VariableOrder = {"ReversePlays","SkipPlays","WildPlays","Placement","UnoCalled"}

local CrateCam = Instance.new("Camera")
CrateCam.CameraType = Enum.CameraType.Scriptable

local GameConnections = {}

local VolumeSliderHold = false

local Rnd = Random.new()

--//Functions

function PlayerIsInGame(GameLobby)
	local Corre = GameLobby.Players:FindFirstChild(Player.Name)
	local SpeccCore = GameLobby.Spectators:FindFirstChild(Player.Name)
	if Corre or SpeccCore then
		return true
	end
	return false
end

function GetSpecNumber(GameLobby)
	
	local SpeccCore = GameLobby.Spectators:FindFirstChild(Player.Name)
	if SpeccCore then
		return SpeccCore.Value
	end
	
	return 0
	
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

function GetSpecPlayer(LobbyName, Number)

	local GameLobby = game.ReplicatedStorage.Games:FindFirstChild(LobbyName)
	if GameLobby then
		local Specer = GameLobby.Spectators:FindFirstChild(Player.Name)
		if Specer then

			local Players = GameLobby.Players:GetChildren()
			return Players[Specer.Value].Name

		end
	end

	return "No One LOL"

end

function CardIsPlayable(GameCard,MyCard,GameLobby)
	if GameCard == nil then return true end
	
	--if GameLobby.Playable.Value == false then return false end
	
	local LocalPlr = Player.Name
	
	local SpecPlayer = GetSpecPlayer(GameLobby.Name)
	
	if SpecPlayer ~= "No One LOL" then
		LocalPlr = SpecPlayer
	end
	
	if (GameLobby.CurrentPlayer.Value ~= LocalPlr) and GameLobby.Settings.JumpIn.Value == false then return false end
	
	if GameLobby.Settings.JumpIn.Value and GameLobby.JumpedIn.Value == false and (GameLobby.CurrentPlayer.Value ~= LocalPlr) and GameLobby.CanJumpIn.Value then
		if GameCard ~= nil then
			return (GameCard.Color.Value == MyCard.Data.Color.Value and GameCard.Type.Value == "Number" and MyCard.Data.Type.Value == "Number" and GameCard.Class.Value == MyCard.Data.Class.Value) or (GameCard.Color.Value == MyCard.Data.Color.Value and GameCard.Type.Value == "Wild Number" and MyCard.Data.Type.Value == "Number" and GameCard.Class.Value == MyCard.Data.Class.Value), "JumpPls"
		end
	else
		if (GameLobby.CurrentPlayer.Value ~= LocalPlr) then
			return false
		end
	end
	
	if (GameLobby.UpcomingAction.Value == "Draw" and GameLobby.Settings.Stacking.Value == false) or GameLobby.UpcomingAction.Value == "Skip" or GameLobby.SecondaryAction.Value == "Bluff" or GameLobby.SecondaryAction.Value == "BluffPrompt" or GameLobby.SecondaryAction.Value == "PickColor" then return false end
	
	if GameLobby.UpcomingAction.Value == "Draw" and GameLobby.Settings.Stacking.Value then
		return ((MyCard.Data.Type.Value == "Draw" and (MyCard.Data.Color.Value == GameCard.Color.Value or (MyCard.Data.Class.Value == GameCard.Class.Value and GameCard.Type.Value == "Draw"))) or MyCard.Data.Type.Value == "Wild Draw")
	end
	
	return GameCard == nil or GameCard.Color.Value == Color3.fromRGB(0,0,0) or (MyCard.Data.Type.Value == "Draw" and GameCard.Type.Value == "Draw") or MyCard.Data.Color.Value == Color3.fromRGB(0,0,0) or GameCard.Color.Value == MyCard.Data.Color.Value or (GameCard.Type.Value == "Wild Number" and MyCard.Data.Type.Value == "Number" and GameCard.Class.Value == MyCard.Data.Class.Value) or (GameCard.Type.Value == "Number" and MyCard.Data.Type.Value == "Number" and GameCard.Class.Value == MyCard.Data.Class.Value) or (GameCard.Type.Value == "Reverse" and MyCard.Data.Type.Value == "Reverse") or (GameCard.Type.Value == "Targeted Draw" and MyCard.Data.Type.Value == "Targeted Draw" and MyCard.Data.Class.Value == GameCard.Class.Value) or (GameCard.Type.Value == "Skip" and MyCard.Data.Type.Value == "Skip") or (GameCard.Type.Value == "Discard Color" and MyCard.Data.Type.Value == "Discard Color") or (GameCard.Type.Value == "Color Draw" and MyCard.Data.Type.Value == "Color Draw") or (MyCard.Data.Type.Value == "Draw" and GameCard.Type.Value == "Draw" and MyCard.Data.Class.Value == GameCard.Class.Value) or (GameCard.Type.Value == "Double Skip" and MyCard.Data.Type.Value == "Double Skip") or (GameCard.Type.Value == "Skip Everyone" and MyCard.Data.Type.Value == "Skip Everyone") or (GameCard.Type.Value == "Swap Hands" and MyCard.Data.Type.Value == "Swap Hands")
end

function notOnFrame(frame,m) --Credit to Repotted
	local isOffFrame = false
	if m.X < frame.AbsolutePosition.X or m.X > frame.AbsolutePosition.X + frame.AbsoluteSize.X or m.Y < frame.AbsolutePosition.Y or m.Y > frame.AbsolutePosition.Y + frame.AbsoluteSize.Y or (frame.Parent == nil) then
		isOffFrame = true
	end
	return isOffFrame
end

function RefreshPlayables(GameC)
	local CurrCard = GameC.CurrentCard.Value
	
	for i,v in pairs(RealUI.GameFrames.Cards:GetChildren()) do
		
		local Playable,Sec = CardIsPlayable(CurrCard,v,GameC)

		if not Playable then

			local ShadowTween = TweenService:Create(v.Card.Shadow,ShadowTI,{ImageTransparency = .5})
			ShadowTween:Play()
			game.Debris:AddItem(ShadowTween,.31)
			v.Data.Playable.Value = false
			
			v.Jumper.Keyboard.Visible = false
			v.Jumper.Mobile.Visible = false
			v.Jumper.Xbox.Visible = false
			
			--print(2)

		else

			local ShadowTween = TweenService:Create(v.Card.Shadow,ShadowTI,{ImageTransparency = 1})
			ShadowTween:Play()
			game.Debris:AddItem(ShadowTween,.31)
			v.Data.Playable.Value = true
			
			if Sec == "JumpPls" then
				
				GameUI.Sounds.CanJump:Play()
				
				local BoxClone = v.Jumper.Popper:Clone()
				BoxClone.Name = "Shh"
				BoxClone.Parent = v.Jumper
				BoxClone.ImageTransparency = 0
				BoxClone.Visible = true
				
				local BVC = TweenService:Create(BoxClone,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size = UDim2.new(1.2,0,1.2,0), ImageTransparency = 1})
				BVC:Play()
				
				game.Debris:AddItem(BoxClone,2)
				game.Debris:AddItem(BVC,2)
				
				if GameUI.ClientVars.IsMobile.Value then
					v.Jumper.Mobile.Visible = true
				elseif #UserInputService:GetConnectedGamepads() > 0 then
					v.Jumper.Xbox.Visible = true
				else
					v.Jumper.Keyboard.Visible = true
				end
				
				GameUI.ClientVars.eBind.Value = v.But.Bind
				
			else
				
				v.Jumper.Keyboard.Visible = false
				v.Jumper.Mobile.Visible = false
				v.Jumper.Xbox.Visible = false
				
			end
			
			--print(3)

		end

	end
	
end

function AddCardUIThing(Child, CurrentGame, Deck)
	
	local SameNameFind = RealUI.GameFrames.Cards:FindFirstChild(Child.Name)
	if SameNameFind then
		return
	end
	
	local CardClone = GameUI.GuiTemplates.Card:Clone()
	CardClone.Name = Child.Name
	CardClone.Card.ColorLRG.ImageColor3 = Child.Color.Value
	CardClone.Card.MidIcon.ImageColor3 = Child.Color.Value
	CardClone.Card.MidTxt.TextColor3 = Child.Color.Value

	CardClone.Data.Class.Value = Child.Class.Value
	CardClone.Data.Type.Value = Child.Type.Value
	CardClone.Data.Color.Value = Child.Color.Value

	CardClone.But.HoverBind.Card.Value = CardClone
	CardClone.But.UnHovBind.Card.Value = CardClone

	CardClone.Card.MidTxt.Text = ""
	CardClone.Card.TopTxt.Text = ""
	CardClone.Card.BottomTxt.Text = ""

	CardClone.Card.MidGrad.Visible = false

	if Deck.Parent.Parent.Parent.Started.Value == true and Deck.Parent.Parent.Parent.CurrentPlayer.Value ~= Deck.Parent.Name or Deck.Parent.Parent.Parent.Started.Value == true and Deck.Parent.Parent.Parent.CurrentPlayer.Value == Deck.Parent.Name and not CardIsPlayable(Deck.Parent.Parent.Parent.CurrentCard.Value,CardClone,CurrentGame) then
		CardClone.Card.Shadow.ImageTransparency = .5
	end

	if Child.Type.Value == "Number" then

		local NumTxt = Child.Class.Value

		CardClone.Card.MidTxt.Visible = true
		CardClone.Card.TopTxt.Visible = true
		CardClone.Card.BottomTxt.Visible = true

		if string.sub(Child.Class.Value,1,1) == "6" or string.sub(Child.Class.Value,1,1) == "9" then
			NumTxt = "<u>" .. string.sub(Child.Class.Value,1,1) .. "</u>" .. string.sub(Child.Class.Value,2)
		end

		CardClone.Card.MidTxt.Text = NumTxt
		CardClone.Card.TopTxt.Text = NumTxt
		CardClone.Card.BottomTxt.Text = NumTxt

	else

		if Child.Type.Value == "Reverse" then

			CardClone.Card.MidIcon.Image = "rbxassetid://9331931243"
			CardClone.Card.TopIcon.Image = "rbxassetid://9331931243"
			CardClone.Card.BottomIcon.Image = "rbxassetid://9331931243"

			CardClone.Card.MidIcon.Visible = true
			CardClone.Card.TopIcon.Visible = true
			CardClone.Card.BottomIcon.Visible = true

		elseif Child.Type.Value == "Wild Number" then

			CardClone.Card.MidTxt.Visible = true
			CardClone.Card.TopTxt.Visible = true
			CardClone.Card.BottomTxt.Visible = true

			CardClone.Card.MidTxt.Text = "#"
			CardClone.Card.TopTxt.Text = "#"
			CardClone.Card.BottomTxt.Text = "#"

		elseif Child.Type.Value == "Skip" then

			CardClone.Card.MidIcon.Image = "rbxassetid://8071990635"
			CardClone.Card.TopIcon.Image = "rbxassetid://8071990635"
			CardClone.Card.BottomIcon.Image = "rbxassetid://8071990635"

			CardClone.Card.MidIcon.Visible = true
			CardClone.Card.TopIcon.Visible = true
			CardClone.Card.BottomIcon.Visible = true

		elseif Child.Type.Value == "Double Skip" then

			CardClone.Card.MidIcon.Image = "rbxassetid://9480461554"
			CardClone.Card.TopIcon.Image = "rbxassetid://9480461554"
			CardClone.Card.BottomIcon.Image = "rbxassetid://9480461554"

			CardClone.Card.MidIcon.Visible = true
			CardClone.Card.TopIcon.Visible = true
			CardClone.Card.BottomIcon.Visible = true

		elseif Child.Type.Value == "Skip Everyone" then

			CardClone.Card.MidIcon.Image = "rbxassetid://9480504206"
			CardClone.Card.TopIcon.Image = "rbxassetid://9480504206"
			CardClone.Card.BottomIcon.Image = "rbxassetid://9480504206"

			CardClone.Card.MidIcon.Visible = true
			CardClone.Card.TopIcon.Visible = true
			CardClone.Card.BottomIcon.Visible = true

		elseif Child.Type.Value == "Swap Hands" then

			CardClone.Card.MidIcon.Image = "rbxassetid://9480483461"
			CardClone.Card.TopIcon.Image = "rbxassetid://9480483461"
			CardClone.Card.BottomIcon.Image = "rbxassetid://9480483461"

			CardClone.Card.MidIcon.Visible = true
			CardClone.Card.TopIcon.Visible = true
			CardClone.Card.BottomIcon.Visible = true

		elseif Child.Type.Value == "Color Draw" then

			CardClone.Card.MidIcon.Image = "rbxassetid://9497107550"
			CardClone.Card.TopIcon.Image = "rbxassetid://9497107550"
			CardClone.Card.BottomIcon.Image = "rbxassetid://9497107550"

			CardClone.Card.MidIcon.Visible = true
			CardClone.Card.TopIcon.Visible = true
			CardClone.Card.BottomIcon.Visible = true

		elseif Child.Type.Value == "Discard Color" then

			CardClone.Card.MidIcon.Image = "rbxassetid://9497108915"
			CardClone.Card.TopIcon.Image = "rbxassetid://9497108915"
			CardClone.Card.BottomIcon.Image = "rbxassetid://9497108915"

			CardClone.Card.MidIcon.Visible = true
			CardClone.Card.TopIcon.Visible = true
			CardClone.Card.BottomIcon.Visible = true

		elseif Child.Type.Value == "Wild" then

			CardClone.Card.TopTxt.TextColor3 = Color3.fromRGB(255,255,255)
			CardClone.Card.BottomTxt.TextColor3 = Color3.fromRGB(255,255,255)

			CardClone.Card.BottomTxt.Text = "W"
			CardClone.Card.TopTxt.Text = "W"

			--Do Gradient Here

			local GameColors = CurrentGame.ColorList:GetChildren()

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

				CardClone.Card.MidGrad.UIGradient.Color = ColorSequence.new(GradientColors)

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
				CardClone.Card.MidGrad.UIGradient.Enabled = false
				CardClone.Card.MidGrad.WildGradient.Enabled = true
			end

			if #GameColors ~= 0 then
				CardClone.Card.MidGrad.UIGradient.Color = ColorSequence.new(GradientColors)
				CardClone.Card.MidGrad.UIGradient.Enabled = true
			else
				CardClone.Card.MidGrad.UIGradient.Enabled = false
			end

			CardClone.Card.MidGrad.Visible = true
			CardClone.Card.TopTxt.Visible = true
			CardClone.Card.BottomTxt.Visible = true

		elseif Child.Type.Value == "Draw" then

			CardClone.Card.MidIcon.Image = "rbxassetid://8481315479"

			CardClone.Card.TopTxt.Text = "+" .. Child.Class.Value
			CardClone.Card.BottomTxt.Text = "+" .. Child.Class.Value

			CardClone.Card.MidIcon.Visible = true
			CardClone.Card.TopTxt.Visible = true
			CardClone.Card.BottomTxt.Visible = true

		elseif Child.Type.Value == "Targeted Draw" then

			CardClone.Card.MidIcon.Image = "rbxassetid://9481290686"

			CardClone.Card.TopTxt.Text = "+" .. Child.Class.Value
			CardClone.Card.BottomTxt.Text = "+" .. Child.Class.Value

			CardClone.Card.MidIcon.Visible = true
			CardClone.Card.TopTxt.Visible = true
			CardClone.Card.BottomTxt.Visible = true

		elseif Child.Type.Value == "Wild Draw" then

			CardClone.Card.TopTxt.Text = "+" .. Child.Class.Value
			CardClone.Card.BottomTxt.Text = "+" .. Child.Class.Value

			CardClone.Card.BottomTxt.Visible = true
			CardClone.Card.TopTxt.Visible = true

			CardClone.Card.DrawGrad.Visible = true

			local GameColors = CurrentGame.ColorList:GetChildren()

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

				CardClone.Card.DrawGrad.UIGradient.Color = ColorSequence.new(GradientColors)

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
				CardClone.Card.DrawGrad.UIGradient.Enabled = false
				CardClone.Card.DrawGrad.WildGradient.Enabled = true
			end

			if #GameColors ~= 0 then
				CardClone.Card.DrawGrad.UIGradient.Enabled = true
				CardClone.Card.DrawGrad.WildGradient.Enabled = false
				CardClone.Card.DrawGrad.UIGradient.Color = ColorSequence.new(GradientColors)
			end

		end

	end

	CardClone.But.Bind.Card.Value = Child.Name
	CardClone.Jumper.Mobile.Back.Button.Bind.Card.Value = Child.Name
	CardClone.Jumper.Keyboard.Back.Button.Bind.Card.Value = Child.Name

	CardClone.Parent = RealUI.GameFrames.Cards
	CardClone.Visible = true

	if CardIsPlayable(CurrentGame.CurrentCard.Value,CardClone,CurrentGame) then
		GameUI.KeepPlay.PlayB.Button.Bind.Card.Value = Child.Name
		CardClone.Data.Playable.Value = true
	end

	ButtonManger:ButtonConnect(CardClone.But,Mouse)
	ButtonManger:ButtonConnect(CardClone.Jumper.Mobile.Back.Button,Mouse)
	ButtonManger:ButtonConnect(CardClone.Jumper.Keyboard.Back.Button,Mouse)
	
end

--//Remotes

game.ReplicatedStorage.Remotes.Notification.OnClientEvent:Connect(function(Type,Txt)
	NotificationManager:CreateLabel(Type,Txt)
end)

game.ReplicatedStorage.Remotes.InitGame.OnClientEvent:Connect(function(ArenaFolder)
	
	local TransIn = TweenService:Create(GameUI.Trans,TransTI,{BackgroundTransparency = 0})
	TransIn:Play()
	game.Debris:AddItem(TransIn,1.2)

	wait(1.2)
	
	for i,v in pairs(game.Workspace.PermLobbies.Classic:GetChildren()) do
		v.Base.Attachment.LobbyPrompt.ActionText = "Join"
	end
	
	for i,v in pairs(game.Workspace.PermLobbies.Super:GetChildren()) do
		v.Base.Attachment.LobbyPrompt.ActionText = "Join"
	end
	
	GameUI.PlayB.Visible = false
	GameUI.QuitB.Visible = true
	
	if GameUI.ClientVars.IsMobile.Value then
		GameUI.LeaderboardFrame.Visible = false
		GameUI.CoinsBack.Visible = false
	end
	
	Camera.CameraType = Enum.CameraType.Scriptable
	GameUI.DrawB.Visible = true
	
	local Base = ArenaFolder.Arena.Value:FindFirstChild("Table")
	local SelfChar = ArenaFolder.Arena.Value:WaitForChild(Player.Name)
	if SelfChar and Base then
		Camera.FieldOfView = 90
		Camera.CFrame = CFrame.new((SelfChar.HumanoidRootPart.CFrame*CFrame.new(0,0,-1 + ((-Base.Size.X/2) + 3.5))).p + Vector3.new(0,2.5,0),ArenaFolder.Arena.Value.Table.Position)
	end
	
	GameUI.Sounds.Music:Stop()
	GameUI.Sounds.GameMusic:Play()
	
	wait(.5)

	local TransIn = TweenService:Create(GameUI.Trans,TransTI,{BackgroundTransparency = 1})
	TransIn:Play()
	game.Debris:AddItem(TransIn,1.2)
	GameUI.LevelBack.Visible = false

	wait(1.7)

	game.ReplicatedStorage.Remotes.Respond:FireServer()
	
end)

game.ReplicatedStorage.Remotes.CardAnimation.OnClientEvent:Connect(function(Arena,GameF,PlayerName,AnimationType,Card,EndCF,SpeedType)
	
	local WaitTime = .2
	if SpeedType == "Fast" then
		WaitTime = .13
	elseif SpeedType == "SuperFast" then
		WaitTime = .07
	end
	
	if AnimationType == "PlayerSort" then
		
		local Dummy = Arena:FindFirstChild(PlayerName)
		if Dummy then
		
			local dCards = Dummy.Cards:GetChildren()
			
			local SideOffs = NumberStep(-math.clamp(.2*#dCards,0,2),math.clamp(.2*#dCards,0,2),#dCards)
			local Rotations = NumberStep(-12,12,#dCards)
			local YOffs = NumberStep(-.1,.1,#dCards)
			local ZOffs = NumberStep(-.02,.02,#dCards)
			--local ZOffs = NumberStep(-1,1,#dCards)
			
			local RevMul = 1
			
			local SelectedTween = CardTI
			if SpeedType == "Fast" then
				SelectedTween = DrawTI
			elseif SpeedType == "SuperFast" then
				SelectedTween = DrawTI2
			end
			
			for i,v in pairs(dCards) do
				
				if i > #dCards/2 then
					RevMul = -1
				end
				
				local EndCF = Dummy.CardCF.CFrame*CFrame.Angles(0,math.rad(90),math.rad(-90))*CFrame.new(0,0,SideOffs[i])*CFrame.Angles(0,math.rad(Rotations[i]),0)*CFrame.new(0,ZOffs[i]*RevMul,0) + Vector3.new(0,YOffs[i]*RevMul,0)
				
				if #dCards <= 1 then
					EndCF = Dummy.CardCF.CFrame*CFrame.Angles(0,math.rad(90),math.rad(-90))
				end
				
				local CFTween = TweenService:Create(v.PrimaryPart,SelectedTween,{CFrame = EndCF})
				CFTween:Play()
				GameUI.Sounds.RecieveCard:Play()
				game.Debris:AddItem(CFTween,.31)
			end
			
			wait(WaitTime)
			
			game.ReplicatedStorage.Remotes.Respond:FireServer()
			
		end
		
	elseif AnimationType == "OneCard" then
		
		local SelectedTween = CardTI
		if SpeedType == "Fast" then
			SelectedTween = DrawTI
		end
		
		local CardTween = TweenService:Create(Card.PrimaryPart,SelectedTween,{CFrame = EndCF})
		CardTween:Play()
		GameUI.Sounds.PlayCard:Play()
		
		game.Debris:AddItem(CardTween,.4)
		
		wait(WaitTime)

		game.ReplicatedStorage.Remotes.Respond:FireServer()
		
	end
	
end)

game.ReplicatedStorage.Remotes.TrackDeck.OnClientEvent:Connect(function(Deck,SpecNum)
	
	local AddCon,RemCon = nil,nil
	
	RealUI.GameFrames.Cards:ClearAllChildren()
	
	local CurrentGame = Deck.Parent.Parent.Parent
	
	spawn(function()
		for i,v in pairs(Deck:GetChildren()) do
			AddCardUIThing(v, CurrentGame, Deck)
		end
		
		repeat
			RunService.RenderStepped:Wait()
		until RealUI.PlayerCons:FindFirstChild(GetSpecPlayer(CurrentGame.Name))
		
		local CurrSpec = GetSpecPlayer(CurrentGame.Name)
		
		local Arena = game.Workspace.Arenas:FindFirstChild(CurrentGame.Name)
		if Arena then
			local SelfChar = Arena:FindFirstChild(CurrSpec)
			if CurrSpec then
				Camera.CameraType = Enum.CameraType.Scriptable
				Camera.FieldOfView = 90
				
				local CamEndCF = CFrame.new((SelfChar.HumanoidRootPart.CFrame*CFrame.new(0,0,-1 + ((-Arena.Table.Size.X/2) + 3.5))).p + Vector3.new(0,2.5,0),Arena.Table.Position)
				
				local CamTween = TweenService:Create(Camera,TweenInfo.new(.5,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{CFrame = CamEndCF})
				CamTween:Play()
				
				GameUI.Sounds.Swoosh2:Play()
				
				game.Debris:AddItem(CamTween,.7)
				--Camera.CFrame = 
			end
		end
		
		for i,v in pairs(RealUI.PlayerCons:GetChildren()) do
			if v.Name == CurrSpec then
				v.Visible = false
			else
				v.Visible = true
			end
		end
	end)
	
	AddCon = Deck.ChildAdded:Connect(function(Child)
		
		if not PlayerIsInGame(Deck.Parent.Parent.Parent) or (SpecNum ~= nil and SpecNum ~= GetSpecNumber(CurrentGame)) then AddCon:Disconnect() return end
		
		AddCardUIThing(Child, CurrentGame, Deck)
	end)
	
	RemCon = Deck.ChildRemoved:Connect(function(Child)
		
		if not PlayerIsInGame(Deck.Parent.Parent.Parent)  or (SpecNum ~= nil and SpecNum ~= GetSpecNumber(CurrentGame)) then RemCon:Disconnect() return end
		
		local CorreCard = RealUI.GameFrames.Cards:FindFirstChild(Child.Name)
		if CorreCard then
			CorreCard:Destroy()
		end
	end)
	
	table.insert(GameConnections,1,AddCon)
	table.insert(GameConnections,1,RemCon)
	
end)

game.ReplicatedStorage.Remotes.TrackGame.OnClientEvent:Connect(function(GameC)
	
	local CurrCon = nil
	local TimerCon = nil
	local SecCon = nil
	local SecCon2 = nil
	local StackCon = nil
	local DrawCon = nil
	local JumpCon = nil
	local JumpiCon = nil
	local CMCon = nil
	
	CMCon = GameC.CurrentCM.Changed:Connect(function()
		
		if not PlayerIsInGame(GameC) then CMCon:Disconnect() return end
		
		local CM = GameUI.ClientVars.CurrCM.Value
		if CM ~= nil and CM:IsDescendantOf(game.Workspace) then
			CM.CardBB.SG.Card:TweenSize(UDim2.new(.7,0,1,0),"Out","Quad",.3,true)
		end
		GameUI.ClientVars.CurrCM.Value = GameC.CurrentCM.Value
		
		local newCM = GameC.CurrentCM.Value
		if newCM ~= nil then
			newCM.CardBB.SG.Card:TweenSize(UDim2.new(1.05,0,1.5,0),"Out","Quad",.3,true)
		end
	end)
	
	JumpiCon = GameC.CanJumpIn.Changed:Connect(function()
		if not PlayerIsInGame(GameC) then JumpiCon:Disconnect() return end

		RefreshPlayables(GameC)
	end)
	
	JumpCon = GameC.JumpedIn.Changed:Connect(function()
		if not PlayerIsInGame(GameC) then JumpCon:Disconnect() return end
		
		RefreshPlayables(GameC)
	end)
	
	TimerCon = GameC.Timer.Changed:Connect(function(val)
		
		if not PlayerIsInGame(GameC) then TimerCon:Disconnect() return end
		
		UIBoxManager:BoxText(GameUI.QuitB.TimerB.Mid.ColorDark.TimeBox,tostring(GameC.Timer.Value))
		
		if GameC.Timer.Value == 0 then
			GameUI.QuitB.TimerB:TweenPosition(UDim2.new(1.1,0,5.9,0),"Out","Back",.3,true)
		else
			GameUI.QuitB.TimerB:TweenPosition(UDim2.new(1.1,0,0,0),"Out","Back",.3,true)
			
			if GameC.Timer.Value > 4 then
				GameUI.Sounds.Tick:Play()
			else
				GameUI.Sounds.Beep:Play()
			end
		end
		
	end)
	
	SecCon = GameC.SecondaryAction.Changed:Connect(function()
		
		if not PlayerIsInGame(GameC) then SecCon:Disconnect() return end
		
		if GameC.SecondaryAction.Value == "PlayKeep" and GameC.CurrentPlayer.Value == Player.Name then
			GameUI.Sounds.PlayKeep:Play()
			GameUI.KeepPlay.PlayB:TweenPosition(UDim2.new(0,0,0,0),"Out","Quart",.5,true)
			
			if #UserInputService:GetConnectedGamepads() > 0 then
				GuiService.SelectedObject = GameUI.KeepPlay.PlayB.Button
			end
			
			wait(.2)
			GameUI.KeepPlay.KeepB:TweenPosition(UDim2.new(1,0,0,0),"Out","Quart",.5,true)
		else
			GameUI.KeepPlay.PlayB:TweenPosition(UDim2.new(0,0,2,0),"Out","Quart",.5,true)
			wait(.2)
			GameUI.KeepPlay.KeepB:TweenPosition(UDim2.new(1,0,2,0),"Out","Quart",.5,true)
		end
		
		if GameC.SecondaryAction.Value == "BluffPrompt" and GameC.CurrentPlayer.Value == Player.Name then
			GameUI.Sounds.PlayKeep:Play()
			GameUI.BluffPrompt.ChallengeB:TweenPosition(UDim2.new(.08,0,0,0),"Out","Quart",.5,true)
			
			if #UserInputService:GetConnectedGamepads() > 0 then
				GuiService.SelectedObject = GameUI.BluffPrompt.ChallengeB.Button
			end
			
			wait(.2)
			GameUI.BluffPrompt.PassB:TweenPosition(UDim2.new(.92,0,0,0),"Out","Quart",.5,true)
		else
			GameUI.BluffPrompt.ChallengeB:TweenPosition(UDim2.new(.08,0,2,0),"Out","Quart",.5,true)
			wait(.2)
			GameUI.BluffPrompt.PassB:TweenPosition(UDim2.new(.92,0,2,0),"Out","Quart",.5,true)
		end
		
	end)
	
	SecCon2 = GameC.SecondaryAction.Changed:Connect(function()
		
		if not PlayerIsInGame(GameC) then SecCon2:Disconnect() return end
		
		RefreshPlayables(GameC)
	end)
	
	CurrCon = GameC.CurrentPlayer.Changed:Connect(function()
		
		if not PlayerIsInGame(GameC) then CurrCon:Disconnect() return end
		
		for i,v in pairs(RealUI.PlayerCons:GetChildren()) do
			if v.Name ~= GameC.CurrentPlayer.Value then
				
				local CircTween = TweenService:Create(v.PicF.CircleDark,TweenInfo.new(.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{ImageColor3 = Color3.fromRGB(216, 216, 216)})
				local HideTween = TweenService:Create(v.PicF.CircleDark.InfoHider.Back,TweenInfo.new(.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{ImageColor3 = Color3.fromRGB(216, 216, 216)})
				
				CircTween:Play()
				HideTween:Play()
				
				game.Debris:AddItem(CircTween,1)
				game.Debris:AddItem(HideTween,1)
				
			end
		end
		
		local CurrPlrCon = RealUI.PlayerCons:FindFirstChild(GameC.CurrentPlayer.Value)
		if CurrPlrCon then
			
			local CircTween = TweenService:Create(CurrPlrCon.PicF.CircleDark,TweenInfo.new(.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{ImageColor3 = Color3.fromRGB(227, 227, 113)})
			local HideTween = TweenService:Create(CurrPlrCon.PicF.CircleDark.InfoHider.Back,TweenInfo.new(.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{ImageColor3 = Color3.fromRGB(227, 227, 113)})

			CircTween:Play()
			HideTween:Play()

			game.Debris:AddItem(CircTween,1)
			game.Debris:AddItem(HideTween,1)
			
		end
		
		if GameC.CurrentPlayer.Value == Player.Name or GameC.CurrentPlayer.Value == GetSpecPlayer(GameC.Name) then
			
			GameUI.Sounds.MyTurn:Play()
			
			RealUI.GameFrames.Cards:TweenPosition(UDim2.new(.5,0,.93,0),"Out","Quad",.3,true)
			
			local Cordi = RealUI.GameFrames.Cards:GetChildren()
			
			if (#UserInputService:GetConnectedGamepads() > 0 or (UserInputService.MouseEnabled and UserInputService.KeyboardEnabled)) and #Cordi > 0 then
				GamepadService:DisableGamepadCursor()
				GuiService.SelectedObject = Cordi[1].But
			end
			
			if #Cordi == 2 then
				--GameUI.Parent.GameUI.UnoB:TweenPosition(UDim2.new(.995,0,.9,0),"Out","Quad",.5,true)
			else
				--GameUI.Parent.GameUI.UnoB:TweenPosition(UDim2.new(1.3,0,.9,0),"Out","Quad",.5,true)
			end
			--print(1)
			RefreshPlayables(GameC)
			
		else
			
			--GameUI.Parent.GameUI.UnoB:TweenPosition(UDim2.new(1.3,0,.9,0),"Out","Quad",.5,true)
			RealUI.GameFrames.Cards:TweenPosition(UDim2.new(.5,0,1.05,0),"Out","Quad",.3,true)
			GuiService.SelectedObject = nil
			RefreshPlayables(GameC)
			
		end
		
	end)
	
	StackCon = GameC.StackCount.Changed:Connect(function()
		
		if not PlayerIsInGame(GameC) then StackCon:Disconnect() return end
		
		game.SoundService.Draw.Pitch.Octave = 1 + ((GameC.StackCount.Value-1)*.1)
		
		GameUI.Sounds.Draw:Play()
	end)
	
	DrawCon = GameC.DrawStack.Changed:Connect(function()
		
		if not PlayerIsInGame(GameC) then DrawCon:Disconnect() return end
		
		if GameC.DrawStack.Value <= 0 then
			GameUI.Sounds.TickDown:Play()
			RealUI.DrawFrame.Txt.Text = "x0"
			RealUI.DrawFrame.TxtDark.Text = "x0"
			
			spawn(function()
				wait(.7)
				if RealUI.DrawFrame.Txt.Text == "x0" then
					RealUI.DrawFrame.Txt.Text = ""
					RealUI.DrawFrame.TxtDark.Text = ""
				end
			end)
		else
			
			RealUI.DrawFrame.Txt.Text = "x" .. GameC.DrawStack.Value
			RealUI.DrawFrame.TxtDark.Text = "x" .. GameC.DrawStack.Value
		end
		
		GameUI.Sounds.TickUp:Play()
		
		RealUI.DrawFrame.Size = UDim2.new(1,0,.2,0)
		RealUI.DrawFrame:TweenSize(UDim2.new(1,0,.15,0),"Out","Quad",.2,true)
		
	end)
	
	local RotArrows = GameC.Arena.Value:FindFirstChild("RotArrows")
	if RotArrows then
		
		while RotArrows and RotArrows.Parent and RotArrows.Parent ~= nil and PlayerIsInGame(GameC) do
			
			local Dir = 2
			
			if GameC.Direction.Value == "Backwards" then
				--Dir = -2
			end
			
			RotArrows.Mid.AW1.C1 = RotArrows.Mid.AW1.C1*CFrame.Angles(0,-math.rad(Dir),0)
			RotArrows.Mid.AW2.C1 = RotArrows.Mid.AW2.C1*CFrame.Angles(0,-math.rad(Dir),0)
			
			RunService.RenderStepped:wait()
			
			--[[
			local AW1T = TweenService:Create(RotArrows.Mid.AW1,ArrowTI,{C1 = RotArrows.Mid.AW1.C1*CFrame.Angles(0,-math.rad(179.9),0)})
			local AW2T = TweenService:Create(RotArrows.Mid.AW2,ArrowTI,{C1 = RotArrows.Mid.AW2.C1*CFrame.Angles(0,-math.rad(179.9),0)})
			
			AW1T:Play()
			AW2T:Play()
			
			game.Debris:AddItem(AW1T,1)
			game.Debris:AddItem(AW2T,1)
			
			local Count = 0
			repeat
				Count = Count + .05
				wait(.05)
			until Count >= .9
			]]
		end
		
	end
	
	table.insert(GameConnections,1,CurrCon)
	table.insert(GameConnections,1,SecCon)
	table.insert(GameConnections,1,SecCon2)
	table.insert(GameConnections,1,DrawCon)
	table.insert(GameConnections,1,StackCon)
	table.insert(GameConnections,1,TimerCon)
	
end)

game.ReplicatedStorage.Remotes.ArrowTween.OnClientEvent:Connect(function(Arrow,CF)
	
	local ArrowTween = TweenService:Create(Arrow,TweenInfo.new(.11,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{CFrame = CF})
	ArrowTween:Play()
	
	game.Debris:AddItem(ArrowTween,.31)
	
	wait(.07)
	
	game.ReplicatedStorage.Remotes.Respond:FireServer()
	
end)

game.ReplicatedStorage.Remotes.RotArrowColor.OnClientEvent:Connect(function(Arrows,NewColor)
	
	local Color1T = TweenService:Create(Arrows.Arrow1.Arrow1,CardTI,{Color = NewColor})
	local Color2T = TweenService:Create(Arrows.Arrow2.Arrow2,CardTI,{Color = NewColor})
	
	local Arr1C = Arrows.Arrow1.Arrow1:Clone()
	local Arr2C = Arrows.Arrow2.Arrow2:Clone()
	
	Arr1C.Anchored = true
	Arr2C.Anchored = true
	Arr2C.Parent = game.Workspace
	Arr1C.Parent = game.Workspace
	
	local AT1 = TweenService:Create(Arr1C,ColRTI,{Color = NewColor,Size = Arr1C.Size*2,Transparency = 1})
	local AT2 = TweenService:Create(Arr2C,ColRTI,{Color = NewColor,Size = Arr2C.Size*2,Transparency = 1})
	
	AT1:Play()
	AT2:Play()
	
	Color1T:Play()
	Color2T:Play()
	
	GameUI.Sounds.Boom:Play()
	
	game.Debris:AddItem(Color1T,.31)
	game.Debris:AddItem(Color2T,.31)
	game.Debris:AddItem(Arr1C,2)
	game.Debris:AddItem(Arr2C,2)
	
	wait(.3)
	
	game.ReplicatedStorage.Remotes.Respond:FireServer()
	
end)

game.ReplicatedStorage.Remotes.ResultsScreen.OnClientEvent:Connect(function(Winner, MyStats, Losers, LobbyType, StartCards)
	
	GameUI.Sounds.GameMusic:Stop()
	GameUI.Sounds.Music:Play()
	
	if #Losers >= 5 then
		GameUI.Results.LosersBack.Losers.CanvasSize = UDim2.new(1 + ((#Losers-4)*.26),0,0,0)
	end
	
	GameUI.LevelBack.Visible = true
	
	GameUI.ClientVars.SkipResults.Value = false
	
	local Skipped = GameUI.ClientVars.SkipResults
	
	GameUI.CardInfo.Position = UDim2.new(1.4,0,.6,0)
	
	--GameUI.Parent.GameUI.UnoB:TweenPosition(UDim2.new(1.3,0,.9,0),"Out","Quad",.5,true)
	
	--Prep the UI
	GameUI.Results.LosersBack.Losers.List:ClearAllChildren()
	GameUI.Results.LosersBack.Losers.CanvasSize = UDim2.new(0,0,0,0)
	
	for i,v in pairs(GameUI.Results.StatsBack.Stats:GetChildren()) do
		if v.Name ~= "CoinGain" then
			v.CoinIcon.Position = UDim2.new(.885,0,-1,0)
			v.Ttl.Position = UDim2.new(-1,0,0,0)
			v.Val.Text = ""
			v.Val.Dark.Text = ""
			v.CoinGain.Text = ""
			v.CoinGain.Dark.Text = ""
		else
			v.Txt.Text = ""
			v.Txt.Dark.Text = ""
			v.CoinIcon.Position = UDim2.new(.375,0,1,0)
		end
	end
	
	local RWinner = Winner
	
	if string.sub(RWinner,1,3) == "||." then
		RWinner = string.sub(RWinner,4)
	end
	
	GameUI.Results.WinnerBack.CharFrame.WM:ClearAllChildren()
	GameUI.Results.WinnerBack.CharFrame.ImageColor3 = Color3.fromRGB(0,0,0)
	GameUI.Results.WinnerBack.Winner.Position = UDim2.new(.5,0,1.1,0)
	
	GameUI.Results.WinnerBack.Winner.Text = RWinner
	GameUI.Results.WinnerBack.Winner.Dark.Text = RWinner
	
	GameUI.Results.WinnerBack.Ttl.Position = UDim2.new(.5,0,-.2,0)
	GameUI.Results.LosersBack.Ttl.Position = UDim2.new(.5,0,-.3,0)
	GameUI.Results.StatsBack.Ttl.Position = UDim2.new(.5,0,-.25,0)
	
	GameUI.Results.Visible = true
	
	--Start the sequence
	if GameUI.ClientVars.IsMobile.Value == false then
		GameUI.Results:TweenSize(UDim2.new(.7,0,.6,0),"Out","Quad",.3,true)
	else
		GameUI.Results:TweenSize(UDim2.new(.7*1.2,0,.6*1.2,0),"Out","Quad",.3,true)
	end
	GameUI.Sounds.OpenSound:Play()
	
	if not Skipped.Value then
		wait(1)
	end
	
	GameUI.Sounds.Swoosh2:Play()
	GameUI.Results.WinnerBack.Ttl:TweenPosition(UDim2.new(.5,0,.02,0),"Out","Quad",.5,true)
	
	if not Skipped.Value then
		wait(.35)
	end
	
	GameUI.Sounds.Swoosh2:Play()
	GameUI.Results.StatsBack.Ttl:TweenPosition(UDim2.new(.5,0,0,0),"Out","Quad",.5,true)
	
	if not Skipped.Value then
		wait(.35)
	end
	
	GameUI.Sounds.Swoosh2:Play()
	GameUI.Results.LosersBack.Ttl:TweenPosition(UDim2.new(.5,0,0,0),"Out","Quad",.5,true)
	
	if not Skipped.Value then
		wait(.55)
	end
	
	--Winner
	
	local WinnerDum = game.Workspace.WinnerModels:FindFirstChild(Winner .. "Dummy")
	if WinnerDum then
		WinnerDum.Parent = GameUI.Results.WinnerBack.CharFrame.WM
		
		local AnimTrack = WinnerDum.Humanoid:LoadAnimation(WinnerDum.Humanoid.WinnerAnim)
		AnimTrack:Play()
		
		local WinCamb = Instance.new("Camera")
		WinCamb.Parent = GameUI.Results.WinnerBack.CharFrame
		WinCamb.CFrame = game.Workspace.CamP.CFrame
		GameUI.Results.WinnerBack.CharFrame.CurrentCamera = WinCamb
	end
	
	GameUI.Sounds.Swoosh3:Play()
	
	local WinnerTween = TweenService:Create(WinnerDum.HumanoidRootPart,CardTI,{CFrame = WinnerDum.HumanoidRootPart.CFrame*CFrame.new(-7,0,0)})
	WinnerTween:Play()
	
	game.Debris:AddItem(WinnerTween,.4)
	
	if not Skipped.Value then
		wait(.5)
	end
	
	GameUI.Sounds.Swoosh1:Play()
	
	GameUI.Results.WinnerBack.Winner:TweenPosition(UDim2.new(.5,0,.95,0),"Out","Linear",.5,true)
	
	local CharImgTween = TweenService:Create(GameUI.Results.WinnerBack.CharFrame,WinnerTI,{ImageColor3 = Color3.fromRGB(255,255,255)})
	CharImgTween:Play()
	
	game.Debris:AddItem(CharImgTween,.55)
	
	--Stats
	
	if not Skipped.Value then
		wait(1)
	end
	
	local TotalGain = 0
	
	for i,v in pairs(VariableOrder) do
		
		local GainNum = math.clamp(MyStats[v],0,5)
		
		if v == "Placement" then
			GainNum = 15
		end
		
		local CorrespondingStat = GameUI.Results.StatsBack.Stats:FindFirstChild(v)
		if CorrespondingStat then
			
			if MyStats[v] == 1 and v == "Placement" then
				GainNum += 15
			end
			
			if LobbyType == "Custom" or StartCards < 5 then
				GainNum = 0
			end
			
			TotalGain = TotalGain + GainNum
			
			spawn(function()
				
				CorrespondingStat.Ttl:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
				GameUI.Sounds.Swoosh3:Play()
				
				if not Skipped.Value then
					wait(.3)
				end
				
				local StatSteps = NumberStep(0,MyStats[v],7)
				for a,b in pairs(StatSteps) do
					
					local RealText = tostring(b)
					
					if b < 10 then
						RealText = string.sub(tostring(b),1,3)
					else
						RealText = string.sub(tostring(b),1,2)
					end
					
					CorrespondingStat.Val.Text = RealText
					CorrespondingStat.Val.Dark.Text = RealText
					GameUI.Sounds.Tick:Play()
					
					if not Skipped.Value then
						wait(.1)
					end
				end
				
				GameUI.Sounds.TickDown:Play()
				
				if not Skipped.Value then
					wait(.2)
				end
				
				GameUI.Sounds.Swoosh3:Play()
				
				
				if not Skipped.Value then
					wait(.07)
				end
				
				CorrespondingStat.CoinIcon:TweenPosition(UDim2.new(.885,0,0,0),"Out","Quad",.2,true)
				
				local CoinSteps = NumberStep(0,GainNum,7)
				for a,b in pairs(CoinSteps) do
					
					local RealText = tostring(b)

					if b < 10 then
						RealText = string.sub(tostring(b),1,3)
					else
						RealText = string.sub(tostring(b),1,2)
					end
					
					CorrespondingStat.CoinGain.Text = RealText
					CorrespondingStat.CoinGain.Dark.Text = RealText
					GameUI.Sounds.Coin:Play()
					
					if not Skipped.Value then
						wait(.1)
					end
				end

				GameUI.Sounds.CoinUp:Play()
				
			end)
			
		end
		if not Skipped.Value then
			wait(2.5)
		end
	end
	
	if not Skipped.Value then
		wait(.5)
	end
	
	GameUI.Sounds.Swoosh2:Play()
	GameUI.Results.StatsBack.Stats.CoinGain.CoinIcon:TweenPosition(UDim2.new(.375,0,0,0),"Out","Quad",.5,true)
	
	if not Skipped.Value then
		wait(.5)
	end
	
	local GainStep = NumberStep(0,TotalGain,12)
	for a,b in pairs(GainStep) do
		
		local RealText = tostring(b)

		if b < 10 then
			RealText = string.sub(tostring(b),1,3)
		else
			RealText = string.sub(tostring(b),1,2)
		end
		
		GameUI.Results.StatsBack.Stats.CoinGain.Txt.Text = "+" .. RealText
		GameUI.Results.StatsBack.Stats.CoinGain.Txt.Dark.Text = "+" .. RealText
		GameUI.Sounds.Tick:Play()
		if not Skipped.Value then
			wait(.05)
		end
	end
	
	GameUI.Sounds.Boom:Play()
	
	local EffectTxt = GameUI.Results.StatsBack.Stats.CoinGain.Txt:Clone()
	EffectTxt.Dark:Destroy()
	EffectTxt.Name = "Efx"
	EffectTxt.Parent = GameUI.Results.StatsBack.Stats.CoinGain
	
	local EfxTween = TweenService:Create(EffectTxt,TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),{Size = UDim2.new(1,0,2,0),TextTransparency = 1})
	EfxTween:Play()
	
	game.Debris:AddItem(EfxTween,1.2)
	game.Debris:AddItem(EffectTxt,1.2)
	
	--Losers
	
	for i,v in pairs(Losers) do
		GameUI.Sounds.Swoosh2:Play()
		spawn(function()
			
			local LoserTemp = GameUI.GuiTemplates.LoserTemplate:Clone()
			local Place = i + 1
			LoserTemp.PicF.PlacingCircle.Txt.Text = "#" .. Place
			LoserTemp.PicF.PlacingCircle.Txt.Dark.Text = "#" .. Place
			LoserTemp.Position = UDim2.new((i-1)*1.165,0,1,0)
			LoserTemp.Parent = GameUI.Results.LosersBack.Losers.List
			LoserTemp.Visible = true
			
			LoserTemp:TweenPosition(UDim2.new(LoserTemp.Position.X.Scale,0,0,0),"Out","Quad",.5,true)
			
			LoserTemp.PicF.Thumb.Image = game.Players:GetUserThumbnailAsync(game.Players:GetUserIdFromNameAsync(v["Player"]),Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size180x180)
			
		end)
		if not Skipped.Value then
			wait(1)
		end
	end
	
	wait(4)
	
	GameUI.Results:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
	GameUI.Sounds.CloseSound:Play()
	
	GuiService.SelectedObject = nil
	
end)

game.ReplicatedStorage.Remotes.EndofGameCards.OnClientEvent:Connect(function(GameLobby)
	
	for i,v in pairs(GameLobby.Players:GetChildren()) do
		local GameDummy = GameLobby.Arena.Value:FindFirstChild(v.Name)
		if GameDummy then
			local CardMdls = GameDummy.Cards:GetChildren()
			
			local PosSteps = NumberStep(-1,1,#CardMdls)
			local RotSteps = NumberStep(-15,15,#CardMdls)
			local zSteps = NumberStep(-.1,.1,#CardMdls)
			
			local Rev = true
			
			for a,b in pairs(CardMdls) do
				if #CardMdls > 1 then
					
					if a > #CardMdls/2 then
						Rev = false
					end
					
					local zStep = zSteps[a]
					if Rev then
						zStep = -zStep
					end
					
					local cEndCF = GameDummy.EndCardCF.CFrame*CFrame.new(0,0,-PosSteps[a])*CFrame.Angles(math.rad(180),-math.rad(-RotSteps[a]),0)*CFrame.new(zStep,0,0)
					
					local CardTwen = TweenService:Create(b.PrimaryPart,CardTI,{CFrame = cEndCF})
					CardTwen:Play()
					
					game.Debris:AddItem(CardTwen,1)
					
				else
					
					local cEndCF = GameDummy.EndCardCF.CFrame*CFrame.Angles(math.rad(180),0,0)--*CFrame.new(0,0,PosSteps[a])*CFrame.Angles(0,math.rad(RotSteps[a]),0)

					local CardTwen = TweenService:Create(b.PrimaryPart,CardTI,{CFrame = cEndCF})
					CardTwen:Play()

					game.Debris:AddItem(CardTwen,1)
					
				end
			end
			
			GameUI.Sounds.PlayCard:Play()
		end
	end
	
	--[[wait(1)
	
	for i,v in pairs(GameLobby.Players:GetChildren()) do
		local GameDummy = GameLobby.Arena.Value:FindFirstChild(v.Name)
		if GameDummy then
			
			spawn(function()
				
				local TotalPoints = 0
				
				for a,b in pairs(GameDummy.Cards:GetChildren()) do
					--Number popup
					
					local NumbPop = game.ReplicatedStorage.MiscAssets.NumberPop:Clone()
					
					if b.Data.Type.Value == "Number" then
						NumbPop.Txt.Text = "-" .. b.Data.Class.Value
						NumbPop.Txt.Dark.Text = NumbPop.Txt.Text
						
						TotalPoints = TotalPoints + tonumber(b.Data.Class.Value)
					end
					
					NumbPop.Parent = b
					NumbPop.Adornee = b
					
					local PopTween = TweenService:Create(NumbPop,WinnerTI,{StudsOffset = Vector3.new(0,3,0)})
					local TxtTween = TweenService:Create(NumbPop.Txt,WinnerTI,{TextTransparency = 1})
					local TxtDTween = TweenService:Create(NumbPop.Txt.Dark,WinnerTI,{TextTransparency = 1})
					
					PopTween:Play()
					TxtTween:Play()
					TxtDTween:Play()
					
					game.Debris:AddItem(PopTween,.6)
					game.Debris:AddItem(TxtTween,.6)
					game.Debris:AddItem(TxtDTween,.6)
					game.Debris:AddItem(NumbPop,.6)
					
					GameUI.Sounds.CardCount:Play()
					
					wait(.4)
				end
				
				wait(.3)
				
				local EndPop = game.ReplicatedStorage.MiscAssets.NumberPop:Clone()
				EndPop.Txt.Text = "-" .. TotalPoints
				EndPop.Txt.Dark.Text = EndPop.Txt.Text
				EndPop.Parent = GameDummy.EndCardCF
				EndPop.Adornee = GameDummy.EndCardCF
				
				local PopTween = TweenService:Create(EndPop,WinnerTI,{StudsOffset = Vector3.new(0,3,0)})
				local TxtTween = TweenService:Create(EndPop.Txt,WinnerTI,{TextTransparency = 1})
				local TxtDTween = TweenService:Create(EndPop.Txt.Dark,WinnerTI,{TextTransparency = 1})

				PopTween:Play()
				TxtTween:Play()
				TxtDTween:Play()

				game.Debris:AddItem(PopTween,.6)
				game.Debris:AddItem(TxtTween,.6)
				game.Debris:AddItem(TxtDTween,.6)
				game.Debris:AddItem(EndPop,.6)
				
				GameUI.Sounds.Boom:Play()
				
			end)
			
		end
	end]]
	
	wait(2)
	
	game.ReplicatedStorage.Remotes.Respond:FireServer()
	
end)

game.ReplicatedStorage.Remotes.CameraReturn.OnClientEvent:Connect(function()
	
	local TransIn = TweenService:Create(GameUI.Trans,TransTI,{BackgroundTransparency = 0})
	TransIn:Play()
	game.Debris:AddItem(TransIn,1.2)

	wait(1.2)

	GameUI.PlayB.Visible = true
	GameUI.QuitB.Visible = false
	GameUI.LeaderboardFrame.Visible = true
	GameUI.CoinsBack.Visible = true

	Camera.CameraType = Enum.CameraType.Custom
	GameUI.DrawB.Visible = false

	Camera.FieldOfView = 70
	
	RealUI.GameFrames.Cards:ClearAllChildren()

	wait(.5)

	local TransIn = TweenService:Create(GameUI.Trans,TransTI,{BackgroundTransparency = 1})
	TransIn:Play()
	game.Debris:AddItem(TransIn,1.2)

	wait(1.7)
	
	game.ReplicatedStorage.Remotes.Respond:FireServer()
	
end)

game.ReplicatedStorage.Remotes.AddConInfo.OnClientEvent:Connect(function(Object,PlayerTrack)
	
	if PlayerTrack == nil or PlayerTrack.Name == Player.Name then return end
	
	local ConClone = GameUI.GuiTemplates.ConTemp:Clone()
	
	ConClone.Name = PlayerTrack.Name
	ConClone.Data.TrackObject.Value = Object
	ConClone.Data.PlayerTrack.Value = PlayerTrack
	if string.sub(PlayerTrack.Name,1,3) ~= "||." then
		ConClone.PicF.Thumb.Image = game.Players:GetUserThumbnailAsync(game.Players:GetUserIdFromNameAsync(PlayerTrack.Name),Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)
	else
		ConClone.PicF.Thumb.Image = "rbxassetid://8157351271"
		ConClone.PicF.Thumb.ImageColor3 = Color3.fromRGB(216, 216, 216)
	end
	ConClone.Visible = true
	
	ConClone.Parent = RealUI.PlayerCons
	
end)

game.ReplicatedStorage.Remotes.PlayerConPopper.OnClientEvent:Connect(function(PlayerName,Type,Content,DelayT,Sound,Color)
	local ConFind = RealUI.PlayerCons:FindFirstChild(PlayerName)
	if ConFind then
		PlayerConManager:ConPopper(ConFind,Type,Content,DelayT,Color)
	end
	
	if Sound ~= nil then
		local Ps = GameUI.Sounds:FindFirstChild(Sound)
		if Ps then
			Ps:Play()
		end
	end
end)

game.ReplicatedStorage.Remotes.BigPopper.OnClientEvent:Connect(function(ImgId,Color,Sound)
	
	if Sound then
		local pSound = GameUI.Sounds:FindFirstChild(Sound)
		if pSound then
			pSound:Play()
		end
	end
	
	if tonumber(ImgId) >= 1000 then
	
		local ImgClone = RealUI.BigPoppers.ImagePopper:Clone()
		ImgClone.Visible = true
		ImgClone.Name = "Cloned"
		ImgClone.Image = "rbxassetid://" .. ImgId
		
		if Color then
			ImgClone.ImageColor3 = Color
		end
		
		ImgClone.Parent = RealUI.BigPoppers
		
		local ImgTween = TweenService:Create(ImgClone,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size = UDim2.new(3,0,3,0),ImageTransparency = 1})
		ImgTween:Play()
		
		game.Debris:AddItem(ImgTween,2.2)
		game.Debris:AddItem(ImgClone,2.2)
		
	else
		
		local ImgClone = RealUI.BigPoppers.TextPopper:Clone()
		ImgClone.Visible = true
		ImgClone.Name = "Cloned"
		ImgClone.Text = ImgId

		if Color then
			ImgClone.TextColor3 = Color
		end

		ImgClone.Parent = RealUI.BigPoppers

		local ImgTween = TweenService:Create(ImgClone,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size = UDim2.new(3,0,3,0),TextTransparency = 1})
		ImgTween:Play()

		game.Debris:AddItem(ImgTween,2.2)
		game.Debris:AddItem(ImgClone,2.2)
		
	end
	
end)

game.ReplicatedStorage.Remotes.UnoPopper.OnClientEvent:Connect(function(PlaySound)
	
	if PlaySound then
		GameUI.Sounds.Warn:Play()
		
		local ExClone = GameUI.UnoB.TextPopper:Clone()
		ExClone.Name = "ExClone"
		ExClone.Visible = true
		ExClone.Parent = GameUI.UnoB
		
		local ExTween = TweenService:Create(ExClone,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size = UDim2.new(3,0,3,0), TextTransparency = 1})
		ExTween:Play()
		
		game.Debris:AddItem(ExClone,2.2)
		game.Debris:AddItem(ExTween,2.2)
	else
		GameUI.Sounds.CoinUp:Play()
	end
	
	local PopClone = GameUI.UnoB.Popper:Clone()
	PopClone.Name = "Pop"
	PopClone.Parent = GameUI.UnoB
	
	local PopTween = TweenService:Create(PopClone,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size = UDim2.new(1.75,0,2,0),ImageTransparency = 1})
	PopTween:Play()
	
	game.Debris:AddItem(PopClone,2.2)
	game.Debris:AddItem(PopTween,2.2)
end)

game.ReplicatedStorage.Remotes.ArrowFullRotate.OnClientEvent:Connect(function(EndCF1,EndCF2,Weld1,Weld2)
	
	local RotTween1 = TweenService:Create(Weld1,TweenInfo.new(.3,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{C0 = EndCF1})
	local RotTween2 = TweenService:Create(Weld2,TweenInfo.new(.3,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{C0 = EndCF2})
	
	RotTween1:Play()
	RotTween2:Play()
	
	GameUI.Sounds.Reverse:Play()
	
	wait(.61)
	
	game.Debris:AddItem(RotTween1)
	game.Debris:AddItem(RotTween2)
	game.ReplicatedStorage.Remotes.Respond:FireServer()
	
end)

game.ReplicatedStorage.Remotes.SkipPopper.OnClientEvent:Connect(function()
	
	local ImgClone = RealUI.GameFrames.SkipPopper.Popper:Clone()
	ImgClone.Visible = true
	ImgClone.Name = "SP"
	ImgClone.Parent = RealUI.GameFrames.SkipPopper
	
	local SPTween = TweenService:Create(ImgClone,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size = UDim2.new(1.5,0,1.5,0),ImageTransparency = 1})
	SPTween:Play()
	
	game.Debris:AddItem(SPTween,1.2)
	game.Debris:AddItem(ImgClone,1.2)
	
end)

game.ReplicatedStorage.Remotes.ColorPrompter.OnClientEvent:Connect(function(ColorFolder,Action)
	
	if Action == "Close" then
		RealUI.ColorPicker:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.5,true)
		GameUI.Sounds.CloseSound:Play()
		return
	end
	
	RealUI.ColorPicker.Colors:ClearAllChildren()
	
	local Coloorz = ColorFolder:GetChildren()
	
	local PosIncrement = 1/#Coloorz
	local SizeIncrement = PosIncrement - .03
	
	for i,v in pairs(Coloorz) do
		
		local ColBc = GameUI.GuiTemplates.ColB:Clone()
		ColBc.Visible = true
		ColBc.ColP.ImageColor3 = v.Value
		ColBc.Bind.Col.Value = v.Value
		ColBc.Size = UDim2.new(1,0,SizeIncrement,0)
		ColBc.Position = UDim2.new(.5,0,PosIncrement*(i-1),0)
		ColBc.Parent = RealUI.ColorPicker.Colors
		
		ButtonManger:ButtonConnect(ColBc,Mouse)
		
		local Hoving = false
		
		ColBc.MouseEnter:Connect(function()
			if not Hoving then
				
				Hoving = true
				GameUI.Sounds.Hov:Play()
				
				ColBc.ColP:TweenSize(UDim2.new(1.1,0,1.1,0),"Out","Quad",.3,true)
				
				repeat
					RunService.RenderStepped:Wait()
				until notOnFrame(ColBc,Mouse)
				
				Hoving = false
				
				ColBc.ColP:TweenSize(UDim2.new(1,0,1,0),"Out","Quad",.3,true)
			end
		end)
		
	end
	
	RealUI.ColorPicker:TweenSize(UDim2.new(.5,0,.5,0),"Out","Quad",.5,true)
	GameUI.Sounds.OpenSound:Play()
	
end)

game.ReplicatedStorage.Remotes.RecolorLRG.OnClientEvent:Connect(function(CardModel,NewColor)
	
	local CT = TweenService:Create(CardModel.CardBB.SG.Card.ColorLRG,CardTI,{ImageColor3 = NewColor})
	CT:Play()
	
	game.Debris:AddItem(CT,1)
	
	wait(.4)
	
	game.ReplicatedStorage.Remotes.Respond:FireServer()
	
end)

game.ReplicatedStorage.Remotes.CardLift.OnClientEvent:Connect(function(CardModel)
	
	local StartCF = CardModel.PrimaryPart.CFrame
	local EndCF = CardModel.PrimaryPart.CFrame + Vector3.new(0,.3,0)
	
	local UpTween = TweenService:Create(CardModel.PrimaryPart,TweenInfo.new(.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{CFrame = EndCF})
	UpTween:Play()
	
	GameUI.Sounds.CardLift:Play()
	
	wait(1.5)
	
	local DownTween = TweenService:Create(CardModel.PrimaryPart,TweenInfo.new(.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{CFrame = StartCF})
	DownTween:Play()
	
	wait(1)
	
	game.Debris:AddItem(UpTween,2)
	game.Debris:AddItem(DownTween,2)
		
	game.ReplicatedStorage.Remotes.Respond:FireServer()
end)

game.ReplicatedStorage.Remotes.QuickPostFix.OnClientEvent:Connect(function(GameLobby)
	GameLobby.CurrentPlayer.Value = ""
	wait()
	GameLobby.CurrentPlayer.Value = Player.Name
end)

game.ReplicatedStorage.Remotes.SwapPrompt.OnClientEvent:Connect(function(GameLobby)
	
	GameUI.Sounds.OpenSound:Play()
	GameUI.SwapPicker:TweenSize(UDim2.new(.4,0,.5,0),"Out","Quad",.5,true)
	
	GameUI.SwapPicker.Players.List.xList:ClearAllChildren()
	
	local Offset = 0
	
	local Plerz = GameLobby.Players:GetChildren()
	
	if #Plerz <= 6 then
		GameUI.SwapPicker.Players.List.CanvasSize = UDim2.new(0,0,.98,0)
	else
		GameUI.SwapPicker.Players.List.CanvasSize = UDim2.new(0,0,1 + ((#Plerz-6)*.2),0)
	end
	
	for i,v in pairs(Plerz) do
		if v.Name ~= Player.Name then
			
			local SwapClone = GameUI.GuiTemplates.SwapTemp:Clone()
			SwapClone.Visible = true
			SwapClone.Back.Username.Text = v.Name
			
			if string.sub(v.Name,1,3) == "||." then
				SwapClone.Back.Username.Text = string.sub(v.Name,4)
				SwapClone.Back.Avatar.Image = "rbxassetid://8157351271"
			else
				spawn(function()
					SwapClone.Back.Avatar.Image = game.Players:GetUserThumbnailAsync(game.Players:GetUserIdFromNameAsync(v.Name),Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)
				end)
			end
			
			SwapClone.Back.CardCount.Count.Text = "x" .. #v.Cards:GetChildren()
			
			SwapClone.Position = UDim2.new(0,0,Offset,0)
			SwapClone.Parent = GameUI.SwapPicker.Players.List.xList
			
			SwapClone.Back.But.Bind.Player.Value = v.Name
			
			local Hoving = false
			
			SwapClone.Back.But.MouseEnter:Connect(function()
				
				if not Hoving then
					
					Hoving = true
					GameUI.Sounds.Hov:Play()
					
					SwapClone.Back:TweenSize(UDim2.new(1,0,.9,0),"Out","Quad",.1,true)
					
					repeat
						RunService.RenderStepped:Wait()
					until notOnFrame(SwapClone.Back.But,Mouse)
					
					Hoving = false
					SwapClone.Back:TweenSize(UDim2.new(1,0,.8,0),"Out","Quad",.1,true)
					
				end
				
			end)
			
			ButtonManger:ButtonConnect(SwapClone.Back.But,Mouse)
			
			Offset = Offset + 1
			
		end
	end
	
end)

game.ReplicatedStorage.Remotes.QuitLobby.OnClientEvent:Connect(function()
	
	local TransTween = TweenService:Create(GameUI.Trans,TransTI,{BackgroundTransparency = 0})
	TransTween:Play()
	
	wait(1.5)
	
	if GameUI.ClientVars.LeavePromptOpen.Value then
		GameUI.Bindables.LeavePromptOpener:Fire({})
	end
	
	GameUI.Sounds.Music:Play()
	GameUI.Sounds.GameMusic:Stop()
	
	GameUI.KeepPlay.KeepB.Position = UDim2.new(1,0,2,0)
	GameUI.KeepPlay.PlayB.Position = UDim2.new(0,0,2,0)
	
	GameUI.BluffPrompt.ChallengeB.Position = UDim2.new(.08,0,2,0)
	GameUI.BluffPrompt.PassB.Position = UDim2.new(.92,0,2,0)
	
	GameUI.SwapPicker.Size = UDim2.new(0,0,0,0)
	RealUI.ColorPicker.Size = UDim2.new(0,0,0,0)
	
	GameUI.UnoB.Position = UDim2.new(1.3,0,.9,0)
	
	GameUI.QuitB.Visible = false
	GameUI.PlayB.Visible = true
	GameUI.DrawB.Visible = false
	
	GameUI.LeaderboardFrame.Visible = true
	GameUI.CoinsBack.Visible = true
	
	GameUI.QuitB.TimerB.Position = UDim2.new(1.1,0,5.9,0)
	
	RealUI.DrawFrame.Txt.Text = ""
	RealUI.DrawFrame.TxtDark.Text = ""
	
	local Chara = game.Workspace:FindFirstChild(Player.Name)
	if Chara then
		local Root = Chara:FindFirstChild("HumanoidRootPart")
		if Root then
			Root.CFrame = game.Workspace.SuperULobby.SpawnLocation.CFrame + Vector3.new(0,2,0)
		end
	end
	
	for i,v in pairs(GameConnections) do
		v:Disconnect()
	end
	
	RealUI.PlayerCons:ClearAllChildren()
	RealUI.GameFrames.Cards:ClearAllChildren()
	
	GameUI.CardInfo.Position = UDim2.new(1.4,0,.6,0)
	
	GameConnections = {}
	
	Camera.CameraType = Enum.CameraType.Custom
	Camera.FieldOfView = 70
	
	GuiService.SelectedObject = nil
	
	wait(.5)
	
	GameUI.LevelBack.Visible = true
	
	local TransTween2 = TweenService:Create(GameUI.Trans,TransTI,{BackgroundTransparency = 1})
	TransTween2:Play()
	
	game.Debris:AddItem(TransTween,2)
	game.Debris:AddItem(TransTween2,2)
	
end)

game.ReplicatedStorage.Remotes.GameLeaveNotif.OnClientEvent:Connect(function(LeaverName)
	
	GameUI.Sounds.NegativeNotif:Play()
	
	local PlrCon = RealUI.PlayerCons:FindFirstChild(LeaverName)
	if PlrCon then
		PlrCon.Name = "||." .. LeaverName
		PlrCon.PicF.Thumb.Image = "rbxassetid://8157351271"
		PlrCon.PicF.Thumb.ImageColor3 = Color3.fromRGB(216, 216, 216)
	end
	
	local LeavePopper = GameUI.LeavePopper.Txt:Clone()
	LeavePopper.Name = "Popper"
	LeavePopper.Text = LeaverName .. " Has Left..."
	LeavePopper.Dark.Text = LeaverName .. " Has Left..."
	LeavePopper.Visible = true
	LeavePopper.Parent = GameUI.LeavePopper
	
	local LeaveTween = TweenService:Create(LeavePopper,TweenInfo.new(2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{TextTransparency = 1,Position = UDim2.new(.5,0,0,0)})
	local DarkTween = TweenService:Create(LeavePopper.Dark,TweenInfo.new(2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{TextTransparency = 1,})
	
	LeaveTween:Play()
	DarkTween:Play()
	
	game.Debris:AddItem(LeavePopper,3)
	game.Debris:AddItem(LeaveTween,3)
	game.Debris:AddItem(DarkTween,3)
	
end)

game.ReplicatedStorage.Remotes.NumberPrompter.OnClientEvent:Connect(function(NumberList)
	
	GameUI.Sounds.OpenSound:Play()
	
	if GameUI.ClientVars.IsMobile.Value == false then
		RealUI.NumberPicker:TweenSize(UDim2.new(.7,0,.1,0),"Out","Quad",.3,true)
	else
		RealUI.NumberPicker:TweenSize(UDim2.new(.7*1.5,0,.1*1.5,0),"Out","Quad",.3,true)
	end
	
	local Numberz = NumberList:GetChildren()
	
	RealUI.NumberPicker.Numbers.Scroller.yList:ClearAllChildren()
	
	if #Numberz > 5 then
		RealUI.NumberPicker.Numbers.Scroller.CanvasSize = UDim2.new(1 + ((#Numberz-5)*.2),0,0,0)
	else
		RealUI.NumberPicker.Numbers.Scroller.CanvasSize = UDim2.new(0,0,0,0)
	end
	
	for i,v in pairs(Numberz) do
		
		local ButtonClone = GameUI.GuiTemplates.NumTemp:Clone()
		
		ButtonClone.Back.Dark.Text = v.Name
		ButtonClone.Back.Txt.Text = v.Name
		ButtonClone.Back.But.Bind.Number.Value = v.Name
		
		ButtonClone.Position = UDim2.new((i-1)*1,0,0,0)
		ButtonClone.Parent = RealUI.NumberPicker.Numbers.Scroller.yList
		ButtonClone.Visible = true
		
		local Hoving = false
		
		ButtonClone.Back.But.MouseEnter:Connect(function()
			
			if not Hoving then
				
				Hoving = true
				
				ButtonClone.Back:TweenSize(UDim2.new(.94,0,.85,0),"Out","Quad",.3,true)
				
				repeat
					RunService.RenderStepped:Wait()
				until notOnFrame(ButtonClone.Back.But,Mouse)
				
				Hoving = false
				ButtonClone.Back:TweenSize(UDim2.new(.9,0,.8,0),"Out","Quad",.3,true)
				
			end
			
		end)
		
		ButtonManger:ButtonConnect(ButtonClone.Back.But,Mouse)
		
	end
	
end)

game.ReplicatedStorage.Remotes.CloseActions.OnClientEvent:Connect(function()
	
	GameUI.Sounds.CloseSound:Play()
	
	GameUI.SwapPicker:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
	RealUI.NumberPicker:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
	RealUI.ColorPicker:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
	
end)

game.ReplicatedStorage.Remotes.LevelUpPopper.OnClientEvent:Connect(function()
	
	local LevelClone = GameUI.LevelUpPopper:Clone()
	LevelClone.Name = "NotAPopper"
	LevelClone.Visible = true
	LevelClone.Parent = GameUI
	
	local TI_LU = TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
	
	local luTween = TweenService:Create(LevelClone,TI_LU,{Size = UDim2.new(.6,0,.6,0), ImageTransparency = 1})
	luTween:Play()
	
	GameUI.Sounds.JumpIn:Play()
	
	game.Debris:AddItem(LevelClone,2)
	game.Debris:AddItem(luTween,2)
	
end)

game.ReplicatedStorage.Remotes.CoinGainPopper.OnClientEvent:Connect(function(Amount)
	
	local CoinGainClone = GameUI.CoinGainPopper:Clone()
	CoinGainClone.Name = "NotAPopper"
	CoinGainClone.Visible = true
	CoinGainClone.Parent = GameUI
	
	CoinGainClone.Txt.Text = "+" .. Amount
	CoinGainClone.Txt.Dark.Text = "+" .. Amount
	
	CoinGainClone.VM.CurrentCamera = BindableManager.VCam
	
	game.Debris:AddItem(CoinGainClone,2)
	
	GameUI.Sounds.CoinUp:Stop()
	
	GameUI.Sounds.CoinUp:Play()
	
	local TI_LU = TweenInfo.new(.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
	
	CoinGainClone:TweenPosition(UDim2.new(.5,0,.3,0),"Out","Back",1,true)
	
	wait(.6)
	
	local VMTween = TweenService:Create(CoinGainClone.VM,TI_LU,{ImageTransparency = 1})
	local TxtTween1 = TweenService:Create(CoinGainClone.Txt,TI_LU,{TextTransparency = 1})
	local TxtTween2 = TweenService:Create(CoinGainClone.Txt.Dark,TI_LU,{TextTransparency = 1})
	
	VMTween:Play()
	TxtTween1:Play()
	TxtTween2:Play()
	
	game.Debris:AddItem(VMTween,1)
	game.Debris:AddItem(TxtTween1,1)
	game.Debris:AddItem(TxtTween2,1)
	
end)

game.ReplicatedStorage.Remotes.UnSpec.OnClientEvent:Connect(function()
	
	GameUI.KeepPlay.KeepB.Position = UDim2.new(1,0,2,0)
	GameUI.KeepPlay.PlayB.Position = UDim2.new(0,0,2,0)
	
	GameUI.SpecButtons.Visible = false
	GameUI.QuitB.Button.Bind.Value = GameUI.Bindables.LeaveGame
	
	GameUI.ShopB.Visible = true
	GameUI.MenuB.Visible = true

	GameUI.BluffPrompt.ChallengeB.Position = UDim2.new(.08,0,2,0)
	GameUI.BluffPrompt.PassB.Position = UDim2.new(.92,0,2,0)

	GameUI.SwapPicker.Size = UDim2.new(0,0,0,0)
	RealUI.ColorPicker.Size = UDim2.new(0,0,0,0)

	GameUI.UnoB.Position = UDim2.new(1.3,0,.9,0)

	GameUI.QuitB.Visible = false
	GameUI.PlayB.Visible = true
	GameUI.DrawB.Visible = false
	GameUI.LeaderboardFrame.Visible = true
	GameUI.CoinsBack.Visible = true

	GameUI.QuitB.TimerB.Position = UDim2.new(1.1,0,5.9,0)

	RealUI.DrawFrame.Txt.Text = ""
	RealUI.DrawFrame.TxtDark.Text = ""

	local Chara = game.Workspace:FindFirstChild(Player.Name)
	if Chara then
		local Root = Chara:FindFirstChild("HumanoidRootPart")
		if Root then
			Root.CFrame = game.Workspace.SuperULobby.SpawnLocation.CFrame + Vector3.new(0,2,0)
		end
	end

	for i,v in pairs(GameConnections) do
		v:Disconnect()
	end

	RealUI.PlayerCons:ClearAllChildren()
	RealUI.GameFrames.Cards:ClearAllChildren()

	GameUI.CardInfo.Position = UDim2.new(1.4,0,.6,0)

	GameConnections = {}

	Camera.CameraType = Enum.CameraType.Custom
	Camera.FieldOfView = 70

	GameUI.LevelBack.Visible = true
	
	GuiService.SelectedObject = nil
	
end)

game.ReplicatedStorage.Remotes.CrateUnbox.OnClientEvent:Connect(function(CrateName, ItemName, Rarity)
	
	local UnBoxerClone = GameUI.CrateUnboxer:Clone()
	UnBoxerClone.Name = "Unboobser"
	UnBoxerClone.Parent = GameUI
	UnBoxerClone.CurrentCamera = CrateCam
	CrateCam.CFrame = UnBoxerClone.WM.CrateSetup.CrateCam.CFrame*CFrame.new(0,0,0)
	
	local CrateRigFind = game.ReplicatedStorage.CaseRigs:FindFirstChild(CrateName)
	if CrateRigFind then
		local SnapRig = CrateRigFind:Clone()
		SnapRig.Parent = game.Workspace.RigSnaps
		local RigClone = CrateRigFind:Clone()
		RigClone.Parent = UnBoxerClone.WM
		
		for i,v in pairs(SnapRig:GetDescendants()) do
			if v:IsA("BasePart") or v:IsA("MeshPart") then
				PhysicsService:SetPartCollisionGroup(v,"Crates")
			end
		end
		
		local OpeningAnimation = RigClone.AnimationController.Animator:LoadAnimation(UnBoxerClone.OpenAnim)
		
		local Tracking = true
		
		SnapRig.PrimaryPart.Anchored = false
		
		spawn(function()
			wait(2)
			Tracking = false
		end)
		
		spawn(function()
			wait(.15)
			GameUI.Sounds.Ground:Play()
		end)
		
		spawn(function()
			while Tracking do
				RigClone:SetPrimaryPartCFrame(SnapRig.PrimaryPart.CFrame)
				RunService.RenderStepped:Wait()
			end
		end)
		
		wait(1)
		OpeningAnimation:Play()
		
		spawn(function()
			--wait(.1)
			GameUI.Sounds.CaseUnlock:Play()
		end)
		
		local LockTrans1 = TweenService:Create(RigClone.Lock.Main,TweenInfo.new(.6,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Transparency = 1})
		local LockTrans2 = TweenService:Create(RigClone.Lock.Silver,TweenInfo.new(.6,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Transparency = 1})
		
		LockTrans1:Play()
		LockTrans2:Play()
		
		game.Debris:AddItem(LockTrans1,.66)
		game.Debris:AddItem(LockTrans2,.66)
		
		spawn(function()
			wait(.4)
			GameUI.Sounds.CaseClick:Play()
		end)
		
		game.Debris:AddItem(SnapRig,5)
		game.Debris:AddItem(UnBoxerClone,5)
		
		wait(1.5)
		
		local UnboxerTween = TweenService:Create(UnBoxerClone,TweenInfo.new(.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{ImageTransparency = 1, Size = UDim2.new(1.1,0,1.1,0)})
		UnboxerTween:Play()
		GameUI.Sounds.Swoosh2:Play()
		
		game.Debris:AddItem(UnboxerTween,.7)
		
		wait(.5)
		
		local UnboxedClone = GameUI.Unboxed:Clone()
		UnboxedClone.Name = "UBOX"
		UnboxedClone.Parent = GameUI
		UnboxedClone.CurrentCamera = BindableManager.VCam
		
		local VMF = game.ReplicatedStorage.ViewportModels:FindFirstChild(ItemName)
		local PartiF = game.ReplicatedStorage.Cosmetics.Particles:FindFirstChild(ItemName)
		if VMF or PartiF then
			
			if VMF then
				local VMC = VMF:Clone()
				VMC.Parent = UnboxedClone
			elseif PartiF then
				UnboxedClone.Img.Visible = true
				UnboxedClone.Img.Image = PartiF.Texture
			end
			
			local InTween = TweenService:Create(UnboxedClone,TweenInfo.new(.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size = UDim2.new(.8,0,.8,0),ImageTransparency = 0})
			InTween:Play()
			game.Debris:AddItem(InTween,.7)
			local InTween2 = TweenService:Create(UnboxedClone.Img,TweenInfo.new(.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size = UDim2.new(.8,0,.8,0),ImageTransparency = 0})
			InTween2:Play()
			game.Debris:AddItem(InTween2,.7)
			GameUI.Sounds.Swoosh2:Play()
			
			UIBoxManager:BoxText(GameUI.CrateItenNameBox,string.upper(ItemName))
			
			wait(.5)
			
			GameUI.Sounds.JumpIn:Play()
			
			local RarSound = GameUI.RaritySounds:FindFirstChild(Rarity)
			if RarSound then
				RarSound:Play()
			end
			
			local RarCirc = GameUI.RarityCirclePopper:Clone()
			RarCirc.Name = "RarCirc"
			RarCirc.ImageColor3 = Util:GetRarityColor(Rarity)
			RarCirc.Parent = GameUI
			
			local CircTween = TweenService:Create(RarCirc,TweenInfo.new(2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size = UDim2.new(.8,0,.8,0),ImageTransparency = 1})
			RarCirc.Visible = true
			CircTween:Play()
			
			game.Debris:AddItem(CircTween,2.7)
			game.Debris:AddItem(RarCirc,2.7)
			
			local ClonedUBOX = UnboxedClone:Clone()
			ClonedUBOX.Parent = GameUI
			
			local PopperTween = TweenService:Create(ClonedUBOX,TweenInfo.new(.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size = UDim2.new(1,0,1,0),ImageTransparency = 1})
			PopperTween:Play()
			game.Debris:AddItem(PopperTween,.7)
			local PopperTween2 = TweenService:Create(ClonedUBOX.Img,TweenInfo.new(.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size = UDim2.new(1,0,1,0),ImageTransparency = 1})
			PopperTween2:Play()
			game.Debris:AddItem(PopperTween2,.7)
			game.Debris:AddItem(ClonedUBOX,.7)
			
			wait(1)
			
			UIBoxManager:BoxText(GameUI.CrateItenNameBox,"")
			
			local OuterTween = TweenService:Create(UnboxedClone,TweenInfo.new(.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size = UDim2.new(1,0,1,0),ImageTransparency = 1})
			OuterTween:Play()
			GameUI.Sounds.CloseSound:Play()
			local OuterTween2 = TweenService:Create(UnboxedClone.Img,TweenInfo.new(.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size = UDim2.new(1,0,1,0),ImageTransparency = 1})
			OuterTween2:Play()
			GameUI.Sounds.CloseSound:Play()
			
			game.Debris:AddItem(UnboxedClone,1)
			game.Debris:AddItem(OuterTween,.7)
			game.Debris:AddItem(OuterTween2,.7)
			
		end
		
	end
	
	GameUI.ClientVars.CanOpenCrate.Value = true
	
end)

game.ReplicatedStorage.Remotes.DailyOpener.OnClientEvent:Connect(function(Streak, CoinAmount, XPAmount)
	
	GameUI.ClientVars.DailyOpen.Value = true
	GameUI.Sounds.OpenSound:Play()
	GameUI.Sounds.JumpIn:Play()
	
	GameUI.DailyReward.Back.Streak.Text = "STREAK: " .. Streak
	GameUI.DailyReward.Back.CoinsFrame.Amount.Text = "+" .. CoinAmount
	GameUI.DailyReward.Back.XPFrame.Amount.Text = "+" .. XPAmount
	
	GameUI.DailyReward:TweenSize(UDim2.new(.8,0,.6,0),"Out",.5,true)
	
end)

game.ReplicatedStorage.Remotes.RefreshGamepass.OnClientEvent:Connect(function(PassName)
	
	GameUI.Sounds.JumpIn:Play()
	
	if PassName == "MoreSlots" then
		
		local InventoryFrame = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List
		
		InventoryFrame.Decor.EquipBack.SlotsBack.Buttons.Slot1.ColorLight.Icon.Visible = false
		InventoryFrame.Decor.EquipBack.SlotsBack.Buttons.Slot4.ColorLight.Icon.Visible = false
		GameUI.SlotSelection.Buttons.Slot1.ColorLight.Icon1.Visible = false
		GameUI.SlotSelection.Buttons.Slot1.ColorLight.Icon2.Visible = false
		GameUI.SlotSelection.Buttons.Slot4.ColorLight.Icon1.Visible = false
		GameUI.SlotSelection.Buttons.Slot4.ColorLight.Icon2.Visible = false
		
	elseif PassName == "MoreDecks" then
		
		GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.SlotsBack.Max.Text = "20"
		
	elseif PassName == "ReducedCrafting" then
		
		UIBoxManager:BoxText(GameUI.MenuBack.List.Lister.List.Crafting.Counter.MaxBox,"5")
		
	end
	
end)

game.ReplicatedStorage.Remotes.RefreshPrestige.OnClientEvent:Connect(function(PlayerName)
	
	local FrameFind = GameUI.LeaderboardFrame.Backer.Back.Scroller.xList:FindFirstChild(PlayerName)
	if FrameFind then
		
		local pData = game.ReplicatedStorage.PlayerData:FindFirstChild(PlayerName)
		if pData then
			
			if pData.LevelData.Prestige.Value <= 0 then return end
			
			local RomanPrestige = Util:intToRoman(pData.LevelData.Prestige.Value)
			
			FrameFind.Icons.Prestige.Text = "[" .. RomanPrestige .. "]"
			FrameFind.Icons.Prestige.Dark.Text = FrameFind.Icons.Prestige.Text
			
		end
		
	end
	
end)

game.ReplicatedStorage.Remotes.UnobxedList.OnClientEvent:Connect(function(From, PlayerName, Rarity, ItemName)
	
	for i,v in pairs(GameUI.UnboxList.Scroller:GetChildren()) do
		v.YVal.Value = v.YVal.Value + .1
		v:TweenPosition(UDim2.new(0,0,v.YVal.Value,0),"Out","Quad",.3,true)

		if v.YVal.Value > 2 then
			v:Destroy()
		end
	end

	local Cloner = game.ReplicatedStorage.MiscAssets.UnboxTemp:Clone()
	Cloner.Parent = GameUI.UnboxList.Scroller
	
	Cloner.Method.Text = "FROM " ..From
	Cloner.User.Text = PlayerName
	Cloner.RarityBack.ImageColor3 = Util:GetRarityColor(Rarity)

	local VMF = game.ReplicatedStorage.ViewportModels:FindFirstChild(ItemName)
	if VMF then
		local VMC = VMF:Clone()
		VMC.Parent = Cloner.RarityBack.VM
		Cloner.RarityBack.VM.CurrentCamera = BindableManager.VCam
	end

	local PartF = game.ReplicatedStorage.Cosmetics.Particles:FindFirstChild(ItemName)
	if PartF then
		Cloner.RarityBack.VM.Visible = false
		Cloner.RarityBack.Img.Image = PartF.Texture
		Cloner.RarityBack.Img.Visible = true
	end

	Cloner.Avatar.Image = game.Players:GetUserThumbnailAsync(game.Players:GetUserIdFromNameAsync(PlayerName),Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size180x180)
	
end)

game.ReplicatedStorage.Remotes.InitializeTrade.OnClientEvent:Connect(function(TradeFolder)
	
	if GameUI.ClientVars.MenuOpen.Value then
		GameUI.Bindables.MenuOpener:Fire({})
	end
	
	if GameUI.ClientVars.ShopOpen.Value then
		GameUI.Bindables.ShopOpener:Fire({})
	end
	
	if GameUI.ClientVars.InspectorOpen.Value then
		GameUI.Bindables.CloseInspector:Fire({})
	end
	
	if GameUI.ClientVars.LobbyOpen.Value then
		GameUI.Bindables.LobbyOpener:Fire({})
	end
	
	if GameUI.ClientVars.LobbyCreOpen.Value then
		GameUI.Bindables.LobbyCreOpener:Fire({})
	end
	
	if GameUI.ClientVars.ViewerOpen.Value then
		GameUI.Bindables.ViewDowner:Fire({Action = "Close"})
	end
	
	GameUI.ClientVars.Trading.Value = true
	
	GameUI.Sounds.OpenSound:Play()
	
	--Open and load the trade UI
	
	GameUI.TradingUI.Confirms.ButtonClip.ConfrimB.Position = UDim2.new(0,0,0,0)
	GameUI.TradingUI.Confirms.ButtonClip.AcceptB.Position = UDim2.new(0,0,1,0)
	
	local P2Name = ""
	
	
	for i,v in pairs(TradeFolder:GetChildren()) do
		if v.Name ~= Player.Name and v.Name  ~= "Canceled" then
			P2Name = v.Name
			break
		end
	end
	
	GameUI.TradingUI.P1.Value.ScrollBack.Inner.Back.Scroller.yList:ClearAllChildren()
	GameUI.TradingUI.P2.Value.ScrollBack.Inner.Back.Scroller.yList:ClearAllChildren()
	
	GameUI.TradingUI.InvBack.ScrollBack.Inner.Back.Scroller.xList:ClearAllChildren()
	
	GameUI.TradingUI.P1.Value.Name = P2Name
	GameUI.TradingUI.P2.Value.Name = Player.Name
	
	GameUI.TradingUI.P1.Value.Top.Ttl.Text = P2Name
	GameUI.TradingUI.P2.Value.Top.Ttl.Text = Player.Name
	
	if GameUI.ClientVars.IsMobile.Value == false then
		GameUI.TradingUI:TweenSize(UDim2.new(1,0,.65,0),"Out","Quad",.3,true)
	else
		GameUI.TradingUI:TweenSize(UDim2.new(1*(5/4),0,.65*(5/4),0),"Out","Quad",.3,true)
	end
	
	GameUI.Bindables.RefreshTradeUI:Fire(TradeFolder)
	
end)

game.ReplicatedStorage.Remotes.TradeNotif.OnClientEvent:Connect(function(Header, Body)
	
	if Header == "TRADE CANCELLED" or Header == "TRADE COMPLETE" then
		
		if Header == "TRADE CANCELLED" then
			GameUI.Sounds.Warn:Play()
		else
			GameUI.Sounds.JumpIn:Play()
		end
		
		GameUI.TradingUI:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
		GameUI.Sounds.CloseSound:Play()
		GameUI.ClientVars.Trading.Value = false
		
		GameUI.TradingUI.P1.Value.ScrollBack.Inner.Back.Scroller.yList:ClearAllChildren()
		GameUI.TradingUI.P2.Value.ScrollBack.Inner.Back.Scroller.yList:ClearAllChildren()

		GameUI.TradingUI.InvBack.ScrollBack.Inner.Back.Scroller.xList:ClearAllChildren()
		
	end
	
	local NotifClone = GameUI.TradeNotif.RequestTemp:Clone()
	NotifClone.Name = "Notif"
	NotifClone.Parent = GameUI.TradeNotif
	NotifClone.Header.Text = Header
	NotifClone.Body.Text = Body
	NotifClone:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
	
	wait(2)
	
	NotifClone:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.3,true)
	
	wait(.4)
	
	NotifClone:Destroy()
	
end)

game.ReplicatedStorage.Remotes.RefreshTrade.OnClientEvent:Connect(function(TradeFolder)
	
	GameUI.Bindables.RefreshTradeUI:Fire(TradeFolder)
	
end)

game.ReplicatedStorage.Remotes.RefreshLeader.OnClientEvent:Connect(function(PlrName)
	
	local Player1 = game.Players:FindFirstChild(PlrName)
	local plrData = game.ReplicatedStorage.PlayerData:FindFirstChild(PlrName)
	local LeaderFrame = GameUI.LeaderboardFrame.Backer.Back.Scroller.xList:FindFirstChild(PlrName)
	
	if Player1 and plrData and LeaderFrame then
		LeaderboardManager:RefreshLabel(Player1,plrData,LeaderFrame)
	end
	
end)

game.ReplicatedStorage.Remotes.ResortCards.OnClientEvent:Connect(function()
	CardManager:SortCards()
end)

--//Other Events

game.ReplicatedStorage.Unboxings.ChildAdded:Connect(function(Child)
	
	for i,v in pairs(GameUI.UnboxList.Scroller:GetChildren()) do
		v.YVal.Value = v.YVal.Value + .1
		v:TweenPosition(UDim2.new(0,0,v.YVal.Value,0),"Out","Quad",.3,true)
		
		if v.YVal.Value > 2 then
			v:Destroy()
		end
	end
	
	local Cloner = game.ReplicatedStorage.MiscAssets.UnboxTemp:Clone()
	Cloner.Parent = GameUI.UnboxList.Scroller
	
	Child:WaitForChild("From")
	Child:WaitForChild("PlayerName")
	Child:WaitForChild("Rarity")
	Child:WaitForChild("ItemName")
	
	Cloner.Method.Text = "FROM " .. Child.From.Value
	Cloner.User.Text = Child.PlayerName.Value
	Cloner.RarityBack.ImageColor3 = Util:GetRarityColor(Child.Rarity.Value)
	
	local VMF = game.ReplicatedStorage.ViewportModels:FindFirstChild(Child.ItemName.Value)
	if VMF then
		local VMC = VMF:Clone()
		VMC.Parent = Cloner.RarityBack.VM
		Cloner.RarityBack.VM.CurrentCamera = BindableManager.VCam
	end
	
	local PartF = game.ReplicatedStorage.Cosmetics.Particles:FindFirstChild(Child.ItemName.Value)
	if PartF then
		Cloner.RarityBack.VM.Visible = false
		Cloner.RarityBack.Img.Image = PartF.Texture
		Cloner.RarityBack.Img.Visible = true
	end
	
	Cloner.Avatar.Image = game.Players:GetUserThumbnailAsync(game.Players:GetUserIdFromNameAsync(Child.PlayerName.Value),Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size180x180)
	
end)

GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.MaxPlrs.Bottom.Slider.Input.FocusLost:Connect(function()
	
	local MaxPlrs = 10
	
	if Util:HasPass("BiggerLobbies") then
		MaxPlrs = 50
	end
	
	local Numb = tonumber(GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.MaxPlrs.Bottom.Slider.Input.Text)
	if Numb ~= nil then
		
		if Numb > 10 and Util:HasPass("BiggerLobbies") == false then
			MarketplaceService:PromptGamePassPurchase(Player,49325954)
		end
		
		Numb = math.clamp(Numb,2,MaxPlrs)
	else
		Numb = 4
	end
	
	GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.MaxPlrs.Bottom.Slider.Input.Text = Numb
	
	GameUI.Bindables.RuleEdit:Fire({Rule = "MaxPlrs",Val = Numb})
end)

GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.CodeLocked.CodeFrame.Bar.Input.FocusLost:Connect(function()
	GameUI.Bindables.RuleEdit:Fire({Rule = "Code",Val = GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.CodeLocked.CodeFrame.Bar.Input.Text})
end)

GameUI.CodePrompt.Back.CodeBack.Input.FocusLost:Connect(function()
	GameUI.CodePrompt.Back.JoinB.Bind.Code.Value = GameUI.CodePrompt.Back.CodeBack.Input.Text
end)

GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.StartCards.Bottom.Slider.Input.FocusLost:Connect(function()
	local Numb = tonumber(GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.StartCards.Bottom.Slider.Input.Text)
	if Numb ~= nil then
		Numb = math.clamp(Numb,2,15)
	else
		Numb = 7
	end

	GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.StartCards.Bottom.Slider.Input.Text = Numb

	GameUI.Bindables.RuleEdit:Fire({Rule = "StartCards",Val = Numb})
end)

game.Players.ChildAdded:Connect(function(Child)
	TradeListManager:RefreshPlrList(Mouse)
	LeaderboardManager:RefreshLeaderboard()
end)

game.Players.ChildRemoved:Connect(function(Child)
	TradeListManager:RefreshPlrList(Mouse)
	LeaderboardManager:RefreshLeaderboard()
end)

game.ReplicatedStorage.Lobbies.Classic.ChildAdded:Connect(function(Child)
	wait()
	LobbyManager:RefreshLobby("Classic")
end)

game.ReplicatedStorage.Lobbies.Classic.ChildRemoved:Connect(function(Child)
	wait()
	LobbyManager:RefreshLobby("Classic")
end)

game.ReplicatedStorage.Lobbies.Super.ChildAdded:Connect(function(Child)
	wait()
	LobbyManager:RefreshLobby("Super")
end)

game.ReplicatedStorage.Lobbies.Super.ChildRemoved:Connect(function(Child)
	wait()
	LobbyManager:RefreshLobby("Super")
end)

game.ReplicatedStorage.Lobbies.Custom.ChildAdded:Connect(function(Child)
	wait()
	LobbyManager:RefreshLobby("Custom")
end)

game.ReplicatedStorage.Lobbies.Custom.ChildRemoved:Connect(function(Child)
	wait()
	LobbyManager:RefreshLobby("Custom")
end)

RealUI.GameFrames.Cards.ChildAdded:Connect(function()
	CardManager:SortCards()
end)

RealUI.GameFrames.Cards.ChildRemoved:Connect(function()
	CardManager:SortCards()
end)

ProximityService.PromptTriggered:Connect(function(Prompt,Triggerer)
	
	if Triggerer.Name == Player.Name then
		
		if Prompt.Name == "LobbyPrompt" then
			
			if Prompt.ActionText == "Join" then
				
				local LobbyType = Prompt.LobbyType.Value
				local LobbyNum = Prompt.LobbyNum.Value
				
				local LobbyName = "Lobby"
				
				if LobbyType == "Classic" then
					LobbyName = LobbyName .. "C"
				else
					LobbyName = LobbyName .. "S"
				end
				
				LobbyName = LobbyName .. tostring(LobbyNum)
				
				local JoinCheck, Lobby = game.ReplicatedStorage.Remotes.JoinLobby:InvokeServer(LobbyName,nil,true)
				if JoinCheck == "Yay" then
					Prompt.ActionText = "Leave"
				end
				
			else
				
				local Yield = game.ReplicatedStorage.Remotes.LeaveLobby:InvokeServer()
				Prompt.ActionText = "Join"
				
			end
			
		elseif Prompt.Name == "ShopPrompt" then
			
			if #UserInputService:GetConnectedGamepads() > 0 then
				GameUI.Bindables.ShopOpener:Fire({XBX = true})
			else
				GameUI.Bindables.ShopOpener:Fire({})
			end
			
		elseif Prompt.Name == "VipPrompt" then
			
			MarketplaceService:PromptGamePassPurchase(Player,49325386)
			
		end
		
	end
	
end)

local BButtonPr = false

UserInputService.InputChanged:Connect(function(Input)
	
	if Input.UserInputType == Enum.UserInputType.MouseWheel then
		
		if GuiService.SelectedObject ~= nil and (GuiService.SelectedObject:IsDescendantOf(RealUI.GameFrames.Cards) or GuiService.SelectedObject:IsDescendantOf(GameUI.DrawB)) then
			if Input.Position.Z > 0 then
				GuiService.SelectedObject = GuiService.SelectedObject.NextSelectionLeft
			else
				GuiService.SelectedObject = GuiService.SelectedObject.NextSelectionRight
			end
		end
		
	end
	
end)

UserInputService.InputBegan:Connect(function(Input,GameEvent)
	
	if GameUI.ClientVars.IsMobile.Value then
		--if not notOnFrame(GameUI.LeaderboardFrame.Scroller.Trigger,Mouse) then
			--GameUI.LeaderboardFrame.Scroller.ScrollingEnabled = true
		--end
	end
	
	if GameEvent then
		if Input.KeyCode == Enum.KeyCode.ButtonB then
			BButtonPr = true
		end
	end
	
end)

UserInputService.InputEnded:Connect(function(Input,GameEvent)
	
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		
		if notOnFrame(GameUI.SlotSelection,Mouse) then
			GameUI.Bindables.SlotSelectionOpener:Fire({Action = "Close"})
		end
		
		if notOnFrame(GameUI.LeaderboardFrame.Buttons,Mouse) and notOnFrame(GameUI.InspectorBack,Mouse) then
			GameUI.LeaderboardFrame.Buttons:TweenPosition(UDim2.new(1.55,0,1.02,0),"Out","Quad",.5,true)
		end
		
		if GameUI.ClientVars.IsMobile.Value then
			--if notOnFrame(GameUI.LeaderboardFrame.Scroller.Trigger,Mouse) then
				--GameUI.LeaderboardFrame.Scroller.ScrollingEnabled = false
			--end
		end
		
		if GuiService.SelectedObject ~= nil and (GuiService.SelectedObject:IsDescendantOf(RealUI.GameFrames.Cards) or GuiService.SelectedObject:IsDescendantOf(GameUI.DrawB)) then
			
			local Bind = GuiService.SelectedObject:FindFirstChild("Bind")
			if Bind and Bind.Value ~= nil then
				--print(22)
				GameUI.Sounds.Click:Play()
				local Args = {}
				for i,v in pairs(Bind:GetChildren()) do
					Args[v.Name] = v.Value
				end
				--print(Bind.Value)
				Bind.Value:Fire(Args)
			end
			
		end
		
	end
	
	if GameEvent then 
		return 
	end
	
	if Input.KeyCode == Enum.KeyCode.Tab then
		
		GameUI.ClientVars.PlayerListOpen.Value = not GameUI.ClientVars.PlayerListOpen.Value
		GameUI.Sounds.TransitionSound:Play()
		if GameUI.ClientVars.PlayerListOpen.Value then
			GameUI.LeaderboardFrame:TweenPosition(UDim2.new(.998,0,.01,0),"Out","Quad",.5,true)
		else
			GameUI.LeaderboardFrame:TweenPosition(UDim2.new(1.698,0,.01,0),"Out","Quad",.5,true)
		end
		
		
	elseif Input.KeyCode == Enum.KeyCode.ButtonSelect then
		
		if GamepadService.GamepadCursorEnabled == false then
			
			if GuiService.SelectedObject == nil or (GuiService.SelectedObject ~= nil and not GuiService.SelectedObject:IsDescendantOf(RealUI.GameFrames.Cards) and not GuiService.SelectedObject:IsDescendantOf(GameUI.KeepPlay) and not GuiService.SelectedObject:IsDescendantOf(GameUI.BluffPrompt)) then
				GamepadService:EnableGamepadCursor(GameUI)
			end
			
			for i,v in pairs(GameUI.XboxElements:GetChildren()) do
				v.Value.Visible = true
			end
			
			--[[GuiService.SelectedObject = GameUI.PlayB.Button
			
			if GameUI.SpecButtons.Visible then
				GuiService.SelectedObject = GameUI.QuitB.Button
			end
			
			if GameUI.ClientVars.ViewerOpen.Value then
				GuiService.SelectedObject = GameUI
			end
			
			--GamepadService:EnableGamepadCursor(GameUI)
			
			GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.AddB.ColorLight.Icon.Visible = false
			GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.RemoveB.ColorLight.Icon.Visible = false
			]]
		else
			
			GamepadService:DisableGamepadCursor()
			
			for i,v in pairs(GameUI.XboxElements:GetChildren()) do
				v.Value.Visible = false
			end
			
			if GuiService.SelectedObject ~= nil and not GuiService.SelectedObject:IsDescendantOf(RealUI.GameFrames.Cards) then
				GuiService.SelectedObject = nil
			end
			--[[GuiService.SelectedObject = nil
			
			for i,v in pairs(GameUI.XboxElements:GetChildren()) do
				v.Value.Visible = false
			end
			
			GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.AddB.ColorLight.Icon.Visible = true
			GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.RemoveB.ColorLight.Icon.Visible = true
			
			if GameUI.ClientVars.ShopOpen.Value then
				GameUI.Bindables.ShopOpener:Fire({})
			end
			
			if GameUI.ClientVars.MenuOpen.Value then
				GameUI.Bindables.MenuOpener:Fire({})
			end
			
			if GameUI.ClientVars.SlotOpen.Value then
				GameUI.Bindables.SlotSelectionOpener:Fire({Action = "Close"})
			end
			
			if GameUI.ClientVars.LobbyOpen.Value then
				GameUI.Bindables.LobbyOpener:Fire({})
			end
			
			if GameUI.ClientVars.LobbyCreOpen.Value then
				GameUI.Bindables.LobbyCreOpener:Fire({Action = "Close"})
			end]]
			
		end
		
	elseif Input.KeyCode == Enum.KeyCode.ButtonL1 then
		
		if GameUI.ClientVars.ShopOpen.Value then
			
			local ShopSection = GameUI.ClientVars.ShopSection.Value
			
			local NextSection = "Crates"
			
			if ShopSection == "Crates" or ShopSection == "CrateInfo" then
				NextSection = "Coins"
			elseif ShopSection == "Coins" then
				NextSection = "Boosts"
			elseif ShopSection == "Boosts" then
				NextSection = "Crates"
			end
			
			GameUI.Bindables.ShopSection:Fire({Section = NextSection})
			
		end
		
		if GameUI.ClientVars.MenuOpen.Value then
			
			if GameUI.ClientVars.MenuSection.Value == "INVENTORY" then
				
				local NextSection = "Decor"
				
				if GameUI.ClientVars.InvSection.Value == "Decor" then
					NextSection = "Particles"
				elseif GameUI.ClientVars.InvSection.Value == "Chairs" then
					NextSection = "Decor"
				elseif GameUI.ClientVars.InvSection.Value == "Particles" then
					NextSection = "Chairs"
				end
				
				GameUI.Bindables.InvSection:Fire({Section = NextSection})
				
			elseif GameUI.ClientVars.MenuSection.Value == "TRADING" then
				
				local NextSection = "Requests"
				
				if GameUI.ClientVars.TradeSection.Value == "Requests" then
					NextSection = "Players"
				end
				
				GameUI.Bindables.TradeSection:Fire({Section = NextSection})
				
			end
			
			if GameUI.ClientVars.MenuSection.Value == "DECK BUILDER" and GameUI.ClientVars.BuildSettings.BuildMode.Value == "Edit" then
				GameUI.Bindables.MultiAdd:Fire()
			end
			
			if GameUI.ClientVars.MenuSection.Value == "SETTINGS" then
				GameUI.Bindables.VolumeChange:Fire({Action = "Minus"})
			end
			
		end
		
		if GameUI.SpecButtons.Visible then
			GameUI.Bindables.SwitchWatcher:Fire({Direction = "Back"})
		end
		
		if GameUI.ClientVars.LobbyOpen.Value then

			local NextSection = "Custom"

			if GameUI.ClientVars.LobbySection.Value == "Classic" then
				NextSection = "Custom"
			elseif GameUI.ClientVars.LobbySection.Value == "Super" then
				NextSection = "Classic"
			elseif GameUI.ClientVars.LobbySection.Value == "Custom" then
				NextSection = "Super"
			end

			GameUI.Bindables.LobbySection:Fire({Section = NextSection})

		end
		
		if GameUI.ClientVars.InspectorOpen.Value then
			
			local NextSection = "Decor"
			
			if GameUI.ClientVars.InspectorSection.Value == "Decor" then
				NextSection = "Particles"
			elseif GameUI.ClientVars.InspectorSection.Value == "Particles" then
				NextSection = "Chairs"
			elseif GameUI.ClientVars.InspectorSection.Value == "Chairs" then
				NextSection = "Decor"
			end
			
			GameUI.Bindables.InspectorSection:Fire({Section = NextSection})
			
		end
		
	elseif Input.KeyCode == Enum.KeyCode.ButtonR1 then

		if GameUI.ClientVars.ShopOpen.Value then

			local ShopSection = GameUI.ClientVars.ShopSection.Value

			local NextSection = "Crates"

			if ShopSection == "Crates" then
				NextSection = "Boosts"
			elseif ShopSection == "Boosts" then
				NextSection = "Coins"
			elseif ShopSection == "Coins" or ShopSection == "CrateInfo" then
				NextSection = "Crates"
			end

			GameUI.Bindables.ShopSection:Fire({Section = NextSection})

		end
		
		if GameUI.ClientVars.MenuOpen.Value then

			if GameUI.ClientVars.MenuSection.Value == "INVENTORY" then

				local NextSection = "Decor"

				if GameUI.ClientVars.InvSection.Value == "Decor" then
					NextSection = "Chairs"
				elseif GameUI.ClientVars.InvSection.Value == "Chairs" then
					NextSection = "Particles"
				elseif GameUI.ClientVars.InvSection.Value == "Particles" then
					NextSection = "Decor"
				end

				GameUI.Bindables.InvSection:Fire({Section = NextSection})
				
			elseif GameUI.ClientVars.MenuSection.Value == "TRADING" then

				local NextSection = "Requests"

				if GameUI.ClientVars.TradeSection.Value == "Requests" then
					NextSection = "Players"
				end

				GameUI.Bindables.TradeSection:Fire({Section = NextSection})

			end
			
			if GameUI.ClientVars.MenuSection.Value == "DECK BUILDER" and GameUI.ClientVars.BuildSettings.BuildMode.Value == "Edit" then
				GameUI.Bindables.MultiRemove:Fire()
			end
			
			if GameUI.ClientVars.MenuSection.Value == "SETTINGS" then
				GameUI.Bindables.VolumeChange:Fire({Action = "Add"})
			end

		end
		
		if GameUI.SpecButtons.Visible then
			GameUI.Bindables.SwitchWatcher:Fire({Direction = "Next"})
		end
		
		if GameUI.ClientVars.LobbyOpen.Value then
			
			local NextSection = "Custom"
			
			if GameUI.ClientVars.LobbySection.Value == "Classic" then
				NextSection = "Super"
			elseif GameUI.ClientVars.LobbySection.Value == "Super" then
				NextSection = "Custom"
			elseif GameUI.ClientVars.LobbySection.Value == "Custom" then
				NextSection = "Classic"
			end
			
			GameUI.Bindables.LobbySection:Fire({Section = NextSection})
			
		end
		
		if GameUI.ClientVars.InspectorOpen.Value then

			local NextSection = "Decor"

			if GameUI.ClientVars.InspectorSection.Value == "Decor" then
				NextSection = "Chairs"
			elseif GameUI.ClientVars.InspectorSection.Value == "Particles" then
				NextSection = "Decor"
			elseif GameUI.ClientVars.InspectorSection.Value == "Chairs" then
				NextSection = "Particles"
			end

			GameUI.Bindables.InspectorSection:Fire({Section = NextSection})

		end
		
	elseif Input.KeyCode == Enum.KeyCode.ButtonB then
		
		if BButtonPr then BButtonPr = false return end
		
		if GameUI.ClientVars.ShopOpen.Value then
			GameUI.Bindables.ShopOpener:Fire({})
		end
		
		local SlotClose = false
		
		if GameUI.ClientVars.SlotOpen.Value then
			GameUI.Bindables.SlotSelectionOpener:Fire({Action = "Close"})
			SlotClose = true
		end
		
		if GameUI.ClientVars.DeleteOpen.Value then
			GameUI.Bindables.DeleteOpener:Fire({Action = "Close"})
			SlotClose = true
		end
		
		if GameUI.ClientVars.RenameOpen.Value then
			GameUI.Bindables.RenameOpener:Fire({Action = "Close"})
			SlotClose = true
		end
		
		if GameUI.ClientVars.MenuSection.Value == "DECK BUILDER" and GameUI.ClientVars.MenuOpen.Value and GameUI.ClientVars.BuildSettings.BuildMode.Value == "Edit" then
			SlotClose = true
			GameUI.Bindables.DBSection:Fire({Section = "List"})
		end
		
		if GameUI.ClientVars.LobbyOpen.Value then
			GameUI.Bindables.LobbyOpener:Fire({})
		end
		
		if GameUI.ClientVars.InspectorOpen.Value then
			GameUI.Bindables.CloseInspector:Fire({})
		end
		
		if SlotClose == false then
			if GameUI.ClientVars.MenuOpen.Value and GameUI.ClientVars.MenuSection.Value == "MAIN MENU" then
				GameUI.Bindables.MenuOpener:Fire({})
			elseif GameUI.ClientVars.MenuOpen.Value and GameUI.ClientVars.MenuSection.Value ~= "MAIN MENU" then
				GameUI.Bindables.MenuSection:Fire({Section = "MAIN MENU",SectionPos = 0})
			end
		end
		
		if GameUI.ClientVars.LobbyCreOpen.Value and GameUI.ClientVars.LobbyCreSection.Value == "ModeSlide" then
			GameUI.Bindables.LobbyCreOpener:Fire({Action = "Close"})
		elseif GameUI.ClientVars.LobbyCreOpen.Value then
			GameUI.Bindables.LobbyCreSection:Fire({Section = "ModeSlide"})
		end
		
	elseif Input.KeyCode == Enum.KeyCode.E or Input.KeyCode == Enum.KeyCode.ButtonX then
		
		local eBind = GameUI.ClientVars.eBind.Value
		
		if eBind ~= nil and eBind.Parent and eBind:IsDescendantOf(GameUI.Parent.Parent) then
			
			local Args = {}
			
			for i,v in pairs(eBind:GetChildren()) do
				Args[v.Name] = v.Value
			end
			
			eBind.Value:Fire(Args)
			
		end
		
	end
	
end)

local SliderB = GameUI.MenuBack.List.Lister.List.Settings.VolumeBack.Slider.Bar.Button
local VBar = GameUI.MenuBack.List.Lister.List.Settings.VolumeBack.Slider.Bar

SliderB.MouseButton1Down:Connect(function()
	
	VolumeSliderHold = true
	
	local PositionOffset = (Mouse.X - SliderB.AbsolutePosition.X - (SliderB.AbsoluteSize.X/2))
	
	repeat
		
		local AbsoluteStart = VBar.AbsolutePosition.X -- (SliderB.AbsoluteSize.X/2)
		local AbsoluteEnd = VBar.AbsolutePosition.X + VBar.AbsoluteSize.X --+ (SliderB.AbsoluteSize.X/2)
		
		local Distance = AbsoluteEnd - AbsoluteStart
		
		local MouseOffset = (Mouse.X - AbsoluteStart)
		
		local Pos = math.clamp((MouseOffset - PositionOffset)/Distance,0,1)
		
		SliderB.Position = UDim2.new(Pos,0,.5,0)
		
		RunService.RenderStepped:Wait()
	until VolumeSliderHold == false 
	
end)

SliderB.MouseButton1Up:Connect(function()
	
	if VolumeSliderHold then

		VolumeSliderHold = false

		game.ReplicatedStorage.Remotes.ChangeVolume:FireServer(SliderB.Position.X.Scale)

	end
	
end)

Mouse.Button1Up:Connect(function()
	
	if VolumeSliderHold then
		
		VolumeSliderHold = false
		
		game.ReplicatedStorage.Remotes.ChangeVolume:FireServer(SliderB.Position.X.Scale)
		
	end
	
	if Mouse.Target and Mouse.Target.Name == "ClickerMans" then
		game.ReplicatedStorage.Remotes.SetAction:FireServer("Draw")
	end
	
end)

--//Misc

wait(.1)

RunService.RenderStepped:Connect(function()
	
	local Chara = game.Workspace:FindFirstChild(Player.Name)
	if Chara then
		local Head = Chara:FindFirstChild("Head")
		local Root = Chara:FindFirstChild("HumanoidRootPart")
		if Head and Root then
			
			local Particle = Root:FindFirstChild("Particle") 
			if Particle then
				
				local Dist = (Head.Position - Camera.CFrame.p).magnitude
				if Dist < 1 then
					Particle.Enabled = false
					Particle:Clear()
				else
					Particle.Enabled = true
				end
				
			end
			
		end
	end
	
	local Target = Mouse.Target
	if Target then
		if Target.Name == "ClickerMans" then
			Mouse.Icon = "rbxassetid://10070489202"
		else
			Mouse.Icon = ""
		end
	else
		Mouse.Icon = ""
	end
	
end)

for i,v in pairs(GameUI.XboxElements:GetChildren()) do
	v.Value.Visible = false
end

GuiService.AutoSelectGuiEnabled = false

for i,v in pairs(GameUI:GetDescendants()) do
	if v:IsA("TextButton") then
		ButtonManger:ButtonConnect(v,Mouse)
	end
end

BindableManager:Init(Mouse)
LobbyManager:SetMouse(Mouse,Player)

GameUI.Bindables.CrateSelector:Fire({Crate = "Decor Crate #1"})

GameUI.Bindables.LobbyCreSection:Fire({Section = "ModeSlide"})

LobbyManager:RefreshLobby("Classic")
LobbyManager:RefreshLobby("Super")
LobbyManager:RefreshLobby("Custom")

PlayerConManager:Init(RealUI.PlayerCons)

local LoadFinished = false

spawn(function()
	while not LoadFinished do
		
		GameUI.Parent.Parent.LoadingFrame.Back.LoadingDots.Dot1.Position = UDim2.new(-1,0,0,0)
		GameUI.Parent.Parent.LoadingFrame.Back.LoadingDots.Dot2.Position = UDim2.new(-.5,0,0,0)
		GameUI.Parent.Parent.LoadingFrame.Back.LoadingDots.Dot3.Position = UDim2.new(0,0,0,0)
		
		GameUI.Parent.Parent.LoadingFrame.Back.LoadingDots.Dot1:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
		wait(.3)
		GameUI.Parent.Parent.LoadingFrame.Back.LoadingDots.Dot2:TweenPosition(UDim2.new(.5,0,0,0),"Out","Quad",.3,true)
		wait(.3)
		GameUI.Parent.Parent.LoadingFrame.Back.LoadingDots.Dot3:TweenPosition(UDim2.new(1,0,0,0),"Out","Quad",.3,true)
		wait(.5)
		
		GameUI.Parent.Parent.LoadingFrame.Back.LoadingDots.Dot3:TweenPosition(UDim2.new(2,0,0,0),"Out","Quad",.3,true)
		wait(.3)
		GameUI.Parent.Parent.LoadingFrame.Back.LoadingDots.Dot2:TweenPosition(UDim2.new(1.5,0,0,0),"Out","Quad",.3,true)
		wait(.3)
		GameUI.Parent.Parent.LoadingFrame.Back.LoadingDots.Dot1:TweenPosition(UDim2.new(1,0,0,0),"Out","Quad",.3,true)
		
		wait(1)
	end
end)

repeat
	wait(1)
until game.ReplicatedStorage.PlayerSessions:FindFirstChild(Player.Name)

UIBoxManager:BoxText(GameUI.Parent.Parent.LoadingFrame.Back.StatusBox,"LOADING DATA")

wait(1)

local FullLoad = false

repeat
	
	local Dataaa =  game.ReplicatedStorage.PlayerData:FindFirstChild(Player.Name)
	if Dataaa then
		if Dataaa.Loaded.Value then
			FullLoad = true
		end
	end
	
	wait(.1)
until FullLoad

UIBoxManager:BoxText(GameUI.Parent.Parent.LoadingFrame.Back.StatusBox,"DATA LOADED")

wait(1)

if UserInputService.TouchEnabled and GameUI.Parent.AbsoluteSize.Y < 570 and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
	
	GameUI.ClientVars.IsMobile.Value = true
	
	local NewButtonSize = UDim2.new(.23*(7/4),0,.07*(7/4),0)
	
	GameUI.TradingUI.Position = UDim2.new(.5,0,.43,0)
	GameUI.MenuBack.Position = UDim2.new(.5,0,.43,0)
	GameUI.ShopBack.Position = UDim2.new(.5,0,.43,0)
	GameUI.Browser.Position = UDim2.new(.5,0,.43,0)
	GameUI.LobbyCreator.Position = UDim2.new(.5,0,.43,0)
	--GameUI.Viewer.Position = UDim2.new(.5,0,.33,0)
	GameUI.InspectorBack.Position = UDim2.new(.5,0,.43,0)
	GameUI.Results.Position = UDim2.new(.5,0,.42,0)
	
	GameUI.PlayB.Size = NewButtonSize
	GameUI.QuitB.Size = NewButtonSize
	GameUI.MenuB.Size = NewButtonSize
	GameUI.ShopB.Size = NewButtonSize
	GameUI.DrawB.Size = NewButtonSize
	GameUI.SpecButtons.Size = NewButtonSize
	
	GameUI.TradeRequests.Size = UDim2.new(.35*(5/4),0,.2*(5/4),0)
	
	GameUI.MenuB.Position = UDim2.new(.005,0,.64,0)
	GameUI.PlayB.Position = UDim2.new(.005,0,.78,0)
	GameUI.QuitB.Position = UDim2.new(.005,0,.36,0)
	GameUI.SpecButtons.Position = UDim2.new(.005,0,.78,0)
	
	GameUI.CoinsBack.Size = UDim2.new(.31*1.9,0,.07*1.9,0)
	GameUI.MobileButtons.Visible = true
	
	GameUI.PlayB.Size = UDim2.new(0,0,0,0)
	GameUI.ShopB.Size = UDim2.new(0,0,0,0)
	GameUI.MenuB.Size = UDim2.new(0,0,0,0)
	GameUI.ShopB.Visible = false
	GameUI.MenuB.Visible = false
	
	GameUI.LeaderboardFrame.Size = UDim2.new(.525*(6/4),0,.3*(6/4),0)
	--GameUI.LeaderboardFrame.Position = UDim2.new(.998,0,.063,0)
	
	RealUI.GameFrames.Cards.Size = UDim2.new(.16*(6/4),0,.225*(6/4),0)
	
	for i,v in pairs(GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules:GetChildren()) do
		local Bottom = v:FindFirstChild("Bottom")
		if Bottom then
			local Button = Bottom.Slider:FindFirstChild("Button")
			if Button then
				Button.Bigger.Visible = true
				Button.Bigger.Size = UDim2.new(3,0,3,0)
			end
		end
	end
	
	--GameUI.LeaderboardFrame.Scroller.ScrollingEnabled = false
	
	--[[GameUI.LeaderboardFrame.Scroller.Trigger.MouseEnter:Connect(function()
		GameUI.LeaderboardFrame.Scroller.ScrollingEnabled = false
	end)
	
	GameUI.LeaderboardFrame.Scroller.Trigger.MouseLeave:Connect(function()
		GameUI.LeaderboardFrame.Scroller.ScrollingEnabled = false
	end)]]
	
end

GameUI.Parent.Parent.LoadingFrame.Back:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.5,true)

GameUI.Bindables.SelectGamepass:Fire({Gamepass = "VIP"})
GameUI.Bindables.SelectCoins:Fire({Coins = "Coins1"})

LoadFinished = true

if #UserInputService:GetConnectedGamepads() > 0 then
	GameUI.UnboxList.Scroller.ScrollingEnabled = false
end

local DataF = game.ReplicatedStorage.PlayerData:FindFirstChild(Player.Name)

if DataF then
	
	DataF.TradeRequests.ChildAdded:Connect(function(Child)
		
		local OldReq = GameUI.TradeRequests:FindFirstChild("CurrRequest")
		if OldReq then
			OldReq.Name = "OldReq"
			OldReq:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.3,true)
			
			game.Debris:AddItem(OldReq)
		end
		
		GameUI.Sounds.CardLift:Play()
		
		local NewReq = GameUI.TradeRequests.RequestTemp:Clone()
		NewReq.Name = "CurrRequest"
		NewReq.Who.Text = Child.Name
		NewReq.Parent = GameUI.TradeRequests
		NewReq:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
		
		ButtonManger:ButtonConnect(NewReq.ViewPew,Mouse)
		
		spawn(function()
			wait(3)
			
			if NewReq.Name == "CurrRequest" then
				NewReq.Name = "GoAway"
				NewReq:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.3,true)
				
				game.Debris:AddItem(NewReq,1)
			end
		end)
		
		TradeListManager:RefreshRequestList(Mouse)
	end)
	
	DataF.TradeRequests.ChildRemoved:Connect(function(Child)
		TradeListManager:RefreshRequestList(Mouse)
	end)
	
	UIBoxManager:BoxText(GameUI.LevelBack.TxtFrame.CurrBox,DataF.LevelData.CurrXP.Value)
	UIBoxManager:BoxText(GameUI.LevelBack.TxtFrame.NeedBox,DataF.LevelData.NeedXP.Value)
	UIBoxManager:BoxText(GameUI.CoinsBack.AmountBox,Util:ConvertToShortString(DataF.Coins.Value))
	
	SliderB:TweenPosition(UDim2.new(DataF.Settings.Volume.Value,0,.5,0),"Out","Quad",.3,true)
	GameUI.Sounds.Music.Volume = DataF.Settings.Volume.Value
	GameUI.Sounds.GameMusic.Volume = DataF.Settings.Volume.Value
	
	if DataF.Settings.Trading.Value then
		GameUI.MenuBack.List.Lister.List.Settings.TradeBack.Slider.Button:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.15,true)
		ButtonManger:SwitchColors(GameUI.MenuBack.List.Lister.List.Settings.TradeBack.Slider.Button,Color3.fromRGB(113, 217, 132),Color3.fromRGB(89, 171, 103),Color3.fromRGB(123, 235, 141))
		UIBoxManager:BoxImage(GameUI.MenuBack.List.Lister.List.Settings.TradeBack.Slider.Button.ColorLight.ImgBox,8071991135)
	else
		GameUI.MenuBack.List.Lister.List.Settings.TradeBack.Slider.Button:TweenPosition(UDim2.new(1,0,0,0),"Out","Quad",.15,true)
		ButtonManger:SwitchColors(GameUI.MenuBack.List.Lister.List.Settings.TradeBack.Slider.Button,Color3.fromRGB(161, 83, 83),Color3.fromRGB(116, 60, 60),Color3.fromRGB(194, 100, 100))
		UIBoxManager:BoxImage(GameUI.MenuBack.List.Lister.List.Settings.TradeBack.Slider.Button.ColorLight.ImgBox,8071990635)
	end
	
	GameUI.LevelBack.BarBack.Bar.Bar:TweenSize(UDim2.new(math.clamp(DataF.LevelData.CurrXP.Value/DataF.LevelData.NeedXP.Value,0,1),0,1,0),"Out","Quad",.3,true)
	
	DataF.LevelData.CurrXP.Changed:Connect(function()
		UIBoxManager:BoxText(GameUI.LevelBack.TxtFrame.CurrBox,DataF.LevelData.CurrXP.Value)
		GameUI.LevelBack.BarBack.Bar.Bar:TweenSize(UDim2.new(math.clamp(DataF.LevelData.CurrXP.Value/DataF.LevelData.NeedXP.Value,0,1),0,1,0),"Out","Quad",.3,true)
	end)
	
	DataF.LevelData.NeedXP.Changed:Connect(function()
		UIBoxManager:BoxText(GameUI.LevelBack.TxtFrame.NeedBox,DataF.LevelData.NeedXP.Value)
		GameUI.LevelBack.BarBack.Bar.Bar:TweenSize(UDim2.new(math.clamp(DataF.LevelData.CurrXP.Value/DataF.LevelData.NeedXP.Value,0,1),0,1,0),"Out","Quad",.3,true)
	end)
	
	DataF.Coins.Changed:Connect(function()
		UIBoxManager:BoxText(GameUI.CoinsBack.AmountBox,Util:ConvertToShortString(DataF.Coins.Value))
	end)
	
	DataF.Settings.Volume.Changed:Connect(function()
		SliderB:TweenPosition(UDim2.new(DataF.Settings.Volume.Value,0,.5,0),"Out","Quad",.3,true)
		GameUI.Sounds.Music.Volume = DataF.Settings.Volume.Value
		GameUI.Sounds.GameMusic.Volume = DataF.Settings.Volume.Value
	end)
	
	DataF.Settings.Trading.Changed:Connect(function()
		
		if DataF.Settings.Trading.Value then
			GameUI.MenuBack.List.Lister.List.Settings.TradeBack.Slider.Button:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.15,true)
			ButtonManger:SwitchColors(GameUI.MenuBack.List.Lister.List.Settings.TradeBack.Slider.Button,Color3.fromRGB(113, 217, 132),Color3.fromRGB(89, 171, 103),Color3.fromRGB(123, 235, 141))
			UIBoxManager:BoxImage(GameUI.MenuBack.List.Lister.List.Settings.TradeBack.Slider.Button.ColorLight.ImgBox,8071991135)
		else
			GameUI.MenuBack.List.Lister.List.Settings.TradeBack.Slider.Button:TweenPosition(UDim2.new(1,0,0,0),"Out","Quad",.15,true)
			ButtonManger:SwitchColors(GameUI.MenuBack.List.Lister.List.Settings.TradeBack.Slider.Button,Color3.fromRGB(161, 83, 83),Color3.fromRGB(116, 60, 60),Color3.fromRGB(194, 100, 100))
			UIBoxManager:BoxImage(GameUI.MenuBack.List.Lister.List.Settings.TradeBack.Slider.Button.ColorLight.ImgBox,8071990635)
		end
		
	end)
	
end

GameUI.Sounds.Music:Play()

LeaderboardManager:RefreshLeaderboard(Mouse)

if Player.UserId == 23441688 then
	GameUI.CodesB.Visible = true
	GameUI.AdminB.Visible = true
	GameUI.ShutdownB.Visible = true
end

TradeListManager:RefreshRequestList(Mouse)
TradeListManager:RefreshPlrList(Mouse)

while wait(.07) do
	
	local StarClone = GameUI.PlayB.Stars.StarT:Clone()
	StarClone.Name = "Clone"
	StarClone.Visible = true
	
	local Sizer = Rnd:NextInteger(700,1000)/1000
	
	StarClone.Position = UDim2.new(Rnd:NextInteger(0,1000)/1000,0,Rnd:NextInteger(400,600)/1000,0)
	StarClone.Size = UDim2.new(Sizer,0,Sizer,0)
	StarClone.Rotation = Rnd:NextInteger(-90,90)
	
	StarClone.Parent = GameUI.PlayB.Stars
	
	local StarTween = TweenService:Create(StarClone,TweenInfo.new(.9,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{ImageTransparency = 1, Size = StarClone.Size + UDim2.new(.2,0,.2,0), Rotation = StarClone.Rotation + 90,Position = StarClone.Position - UDim2.new(0,0,1,0)})
	StarTween:Play()
	
	game.Debris:AddItem(StarClone,1)
	game.Debris:AddItem(StarTween,1)
	
	--
	
	local StarClone2 = GameUI.PlayB.Stars.StarT:Clone()
	StarClone2.Name = "Clone"
	StarClone2.Visible = true

	--local Sizer = Rnd:NextInteger(700,1000)/1000

	StarClone2.Position = UDim2.new(Rnd:NextInteger(0,1000)/1000,0,Rnd:NextInteger(400,600)/1000,0)
	StarClone2.Size = UDim2.new(Sizer,0,Sizer,0)
	StarClone2.Rotation = Rnd:NextInteger(-90,90)

	StarClone2.Parent = GameUI.MobileButtons.PlayB.Stars

	local StarTween2 = TweenService:Create(StarClone2,TweenInfo.new(.9,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{ImageTransparency = 1, Size = StarClone2.Size + UDim2.new(.2,0,.2,0), Rotation = StarClone2.Rotation + 90,Position = StarClone2.Position - UDim2.new(0,0,1,0)})
	StarTween2:Play()

	game.Debris:AddItem(StarClone2,1)
	game.Debris:AddItem(StarTween2,1)
end