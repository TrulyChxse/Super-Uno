--X_Z

local GameUI = script.Parent.Parent

script.Parent:WaitForChild("ButtonManager")
script.Parent:WaitForChild("UIBoxManager")
script.Parent:WaitForChild("Util")

GameUI:WaitForChild("ClientVars")

local ClientVars = GameUI.ClientVars

local ButtonManager = require(script.Parent.ButtonManager)
local UIBoxManager = require(script.Parent.UIBoxManager)
local Util = require(script.Parent.Util)

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local GuiService = game:GetService("GuiService")
local GamepadService = game:GetService("GamepadService")

local GleamTI = TweenInfo.new(.3,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)

GameUI:WaitForChild("Bindables")

local Binds = GameUI.Bindables

local CardInfos = {
	Reverse = "When this card is played\nThe direction of turns\nSwitches Directions\n\n",
	Skip = "When this card is played\nThe next player's\nTurn is skipped\n\n",
	Wild = "When this card is played\nYou will change the color\n\n\n",
	Draw = "When this card is played\nThe next player will\nDraw the number of\nCards indicated and\nLose their turn",
	["Wild Draw"] = "When this card is played\nPick a new color AND\nThe next player will\nDraw cards\n",
	["Double Skip"] = "When this card is played\nThe next 2 players\nAre skipped\n\n",
	["Skip Everyone"] = "When this card is played\nEveryone will lose\nA turn\n\n",
	["Swap Hands"] = "When this card is played\nYou must swap cards\nWith another player\n\n",
	["Wild Number"] = "When this card is played\nYou will change\nThe number\n\n",
	["Targeted Draw"] = "When this card is played\nYou will target\nAnother player and\nMake them draw\n",
	["Color Draw"] = "The next player must draw\nUntil they get a\nCard the same color\nAs this one\n",
	["Discard Color"] = "When this card is played\nDiscard all cards of\nThe same color as\nThis one\n",
}

local GamepassInfo = {
	
	VIP = {
		
		Cost = 499,
		Description = "Benefits\n\n~x1.5 XP(Stacks with x2 XP)\n~x1.5 Coin Rewards\n~EXCLUSIVE Throne Chair\n~EXCLUSIVE Crown Decor\n~EXCLUSIVE Stars Particle\n~Gold Leaderboard Name\n~Gold In-Game Name\n~Crown Leaderboard Icon",
		Id = 49325386,
		
	},
	
	["+2 Decor Slots"] = {

		Cost = 259,
		Description = "\n\nGet An Additional 2 Decor Slots\nIncreasing Your Slots From 2 to 4\n\n\nMore Room To Flex\nYour Awesome Stuff!\n\n",
		Id = 49325708,

	},
	
	["x2 XP"] = {

		Cost = 399,
		Description = "\n\nGain x2 XP\nFrom Games AND Daily Rewards\n\nStacks with VIP's x1.5 XP\n\nLevel-Up And Prestige Faster!\n\n",
		Id = 49326163,

	},
	
	["Amethyst Kit"] = {

		Cost = 699,
		Description = "\n\nItems Gained:\n\nEXCLUSIVE Amethyst Wand Decor\nEXCLUSIVE Amethyst Throne Chair\nEXCLUSIVE Amethyst Gems Particle\n\nAll Items Are Tradeable!\n",
		Id = 49326237,

	},
	
	["Thunder Kit"] = {

		Cost = 699,
		Description = "\n\nItems Gained:\n\nEXCLUSIVE Tesla Coil Decor\nEXCLUSIVE Thunder Chair\nEXCLUSIVE Storm Clouds Particle\n\nAll Items Are Tradeable!\n",
		Id = 49326290,

	},
	
	["Bigger Lobbies"] = {

		Cost = 49,
		Description = "\n\n\nIncrease The Maximum Amount\nOf Players Allowed In A Game\nFrom 10 -> 50\n\nHost The Largest Games Ever!\n\n",
		Id = 49325954,

	},
	
	["More Decks"] = {

		Cost = 39,
		Description = "\n\n\nIncrease The Maximum Amount\nOf Custom Decks You Can Save\nFrom 5 -> 20\n\nBe Even More Creative And Fun!\n\n",
		Id = 49326056,

	},
	
	["Sprint"] = {

		Cost = 29,
		Description = "\n\nRun TWICE as FAST\nIn The Lobby!\n\n\nGet To Games Faster Than\nEver Before!\n\n",
		Id = 49325855,

	},
	
	["Diamond Lambo"] = {

		Cost = 3500,
		Description = "\n\nGamepass EXCLUSIVE\n\nEXOTIC Table Decor\n\nShow Off This Unique\nAnd Ultra-Rare Table Decor!\n\nIt's Also Tradeable!",
		Id = 52851983,

	},
	
	["Gaming Chairs Kit"] = {

		Cost = 599,
		Description = "\n\nGet These Cool Chairs!\n\nEXCLUSIVE Female Streamer Chair\nEXCLUSIVE Tryhard Chair\nEXCLUSIVE Nine Cloud Chair\n\nAll Items Are Tradeable!\n",
		Id = 51838723,

	},	
	
	["Quicker Crafting"] = {

		Cost = 899,
		Description = "\n\nReduce The Amount Of Items\nTo Craft Up To A New Item\n\nFrom 7 -> 5\n\nCraft More With Less!\n\n",
		Id = 52330048,

	},	
	
	["Epic Gems Kit"] = {

		Cost = 1799,
		Description = "\n\Get These Epic-Tier Decor Items!\n\nEXCLUSIVE Emerald Stack\nEXCLUSIVE Ruby Stack\nEXCLUSIVE Citrine Stack\n\nAll Items Are Tradeable!\n",
		Id = 52165312,

	},	
	
	["Cooldown Removal"] = {

		Cost = 59,
		Description = "\n\Tired Of Waiting For The\nCurrent Crate To Finish?\n\nWith This Pass, Open As\nMany Without Waiting For\nThe Previous Crate To Finish!\n\n",
		Id = 52331325,

	},	
	
}

local DevProductInfo = {
	
	Coins1 = {
		Amount = "+200",
		Cost = 59,
		Id = 1269793463,
	},
	
	Coins2 = {
		Amount = "+520",
		Cost = 129,
		Id = 1269793505,
	},
	
	Coins3 = {
		Amount = "+1600",
		Cost = 359,
		Id = 1269793580,
	},
	
	Coins4 = {
		Amount = "+4200",
		Cost = 899,
		Id = 1269793643,
	},
	
	Coins5 = {
		Amount = "+9200",
		Cost = 1799,
		Id = 1269793698,
	},
	
	Coins6 = {
		Amount = "+25000",
		Cost = 3399,
		Id = 1269793724,
	},
	
	
}

Binds:WaitForChild("Test")
Binds:WaitForChild("LobbySection")
Binds:WaitForChild("LobbyOpener")
Binds:WaitForChild("LobbyCreatorHoverText")
Binds:WaitForChild("CreateLobby")
Binds:WaitForChild("LobbyCreSelect")
Binds:WaitForChild("RuleEdit")
Binds:WaitForChild("RuleInfo")
Binds:WaitForChild("LobbyCreSection")
Binds:WaitForChild("LobbyCreOpener")
Binds:WaitForChild("ViewDowner")
Binds:WaitForChild("ViewOpener")
Binds:WaitForChild("ViewPlrUpdate")
Binds:WaitForChild("LeaveLobby")
Binds:WaitForChild("JoinLobby")
Binds:WaitForChild("AddBot")
Binds:WaitForChild("RemoveBot")
Binds:WaitForChild("KickPlayer")
Binds:WaitForChild("StartGame")
Binds:WaitForChild("Notification")
Binds:WaitForChild("CardHover")
Binds:WaitForChild("PlayCard")
Binds:WaitForChild("SetAction")
Binds:WaitForChild("CallUno")
Binds:WaitForChild("PickColor")
Binds:WaitForChild("SwapChoice")
Binds:WaitForChild("LeaveGame")
Binds:WaitForChild("SelectDeck")
Binds:WaitForChild("SkipResults")
Binds:WaitForChild("NumberChoice")
Binds:WaitForChild("MenuOpener")
Binds:WaitForChild("MenuSection")
Binds:WaitForChild("RefreshInventory")
Binds:WaitForChild("DecorPreview")
Binds:WaitForChild("EquipDecor")
Binds:WaitForChild("UnEquipDecor")
Binds:WaitForChild("SlotSelectionOpener")
Binds:WaitForChild("InvBHov")
Binds:WaitForChild("InvBuHov")
Binds:WaitForChild("EquipChair")
Binds:WaitForChild("EquipParticle")
Binds:WaitForChild("UnEquipChair")
Binds:WaitForChild("UnEquipParticle")
Binds:WaitForChild("ChairPreview")
Binds:WaitForChild("LoadDecks")
Binds:WaitForChild("PreviewDeck")
Binds:WaitForChild("DBSection")
Binds:WaitForChild("EditDeck")
Binds:WaitForChild("CreateDeck")
Binds:WaitForChild("DeleteDeck")
Binds:WaitForChild("RenameOpener")
Binds:WaitForChild("DeleteOpener")
Binds:WaitForChild("RenameDeck")
Binds:WaitForChild("LoadEditCards")
Binds:WaitForChild("SelectEditColor")
Binds:WaitForChild("RefreshBuildColorList")
Binds:WaitForChild("EditCardToggle")
Binds:WaitForChild("EditCardSetting")
Binds:WaitForChild("RefreshCardSettings")
Binds:WaitForChild("ClearAllCardToggles")
Binds:WaitForChild("UpdateEditButtons")
Binds:WaitForChild("MultiAdd")
Binds:WaitForChild("MultiRemove")
Binds:WaitForChild("SetPlrInspect")
Binds:WaitForChild("LoadInspector")
Binds:WaitForChild("InspectorSection")
Binds:WaitForChild("CloseInspector")
Binds:WaitForChild("RedeemCode")
Binds:WaitForChild("CodeCreatorOpener")
Binds:WaitForChild("CodeType")
Binds:WaitForChild("AddCode")
Binds:WaitForChild("VolumeChange")
Binds:WaitForChild("TradeToggle")
Binds:WaitForChild("WatchGame")
Binds:WaitForChild("ExitSpectate")
Binds:WaitForChild("SwitchWatcher")
Binds:WaitForChild("RefreshWatchList")
Binds:WaitForChild("ShopOpener")
Binds:WaitForChild("ShopSection")
Binds:WaitForChild("CrateSelector")
Binds:WaitForChild("ViewCrateSkins")
Binds:WaitForChild("BuyCrate")
Binds:WaitForChild("SelectGamepass")
Binds:WaitForChild("BuyGamepass")
Binds:WaitForChild("SelectCoins")
Binds:WaitForChild("BuyCoins")
Binds:WaitForChild("SkipToCoins")
Binds:WaitForChild("CloseDaily")
Binds:WaitForChild("BuyAnotherDaily")
Binds:WaitForChild("CardHover2")
Binds:WaitForChild("CardUnHover")
Binds:WaitForChild("Prestige")
Binds:WaitForChild("AddCraft")
Binds:WaitForChild("RemoveCraft")
Binds:WaitForChild("Craft")
Binds:WaitForChild("RefreshCraft")
Binds:WaitForChild("ReduceBuy")
Binds:WaitForChild("SendTrade")
Binds:WaitForChild("DeclineTrade")
Binds:WaitForChild("AcceptTrade")
Binds:WaitForChild("AddTradeItem")
Binds:WaitForChild("RemoveTradeItem")
Binds:WaitForChild("ConfirmTrade")
Binds:WaitForChild("FinalAcceptTrade")
Binds:WaitForChild("CancelTrade")
Binds:WaitForChild("QuickTradeView")
Binds:WaitForChild("TradeSection")
Binds:WaitForChild("RefreshTradeUI")
Binds:WaitForChild("LeavePromptOpener")
Binds:WaitForChild("ShutdownOpener")
Binds:WaitForChild("ShutdownSend")

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

function ApplyCardData(CardClone,Child,ColorList)
	
	CardClone.Name = Child.Name
	CardClone.Card.ColorLRG.ImageColor3 = Child.Color.Value
	CardClone.Card.MidIcon.ImageColor3 = Child.Color.Value
	CardClone.Card.MidTxt.TextColor3 = Child.Color.Value

	CardClone.Data.Class.Value = Child.Class.Value
	CardClone.Data.Type.Value = Child.Type.Value
	CardClone.Data.Color.Value = Child.Color.Value
	
	if CardClone:FindFirstChild("But") then
		CardClone.But.HoverBind.Card.Value = CardClone
		CardClone.But.UnHovBind.Card.Value = CardClone
	end
	
	CardClone.Card.MidTxt.Text = ""
	CardClone.Card.TopTxt.Text = ""
	CardClone.Card.BottomTxt.Text = ""

	CardClone.Card.MidGrad.Visible = false

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

		elseif Child.Type.Value == "Swap Hands" then

			CardClone.Card.MidIcon.Image = "rbxassetid://9480483461"
			CardClone.Card.TopIcon.Image = "rbxassetid://9480483461"
			CardClone.Card.BottomIcon.Image = "rbxassetid://9480483461"

			CardClone.Card.MidIcon.Visible = true
			CardClone.Card.TopIcon.Visible = true
			CardClone.Card.BottomIcon.Visible = true

		elseif Child.Type.Value == "Wild" then

			CardClone.Card.TopTxt.TextColor3 = Color3.fromRGB(255,255,255)
			CardClone.Card.BottomTxt.TextColor3 = Color3.fromRGB(255,255,255)

			CardClone.Card.BottomTxt.Text = "W"
			CardClone.Card.TopTxt.Text = "W"

			--Do Gradient Here
			
			CardClone.Card.MidGrad.UIGradient.Enabled = false
			CardClone.Card.MidGrad.WildGradient.Enabled = false

			local GameColors = ColorList:GetChildren()

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
				
				--print(#GradientColors)
				
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
			
			CardClone.Card.DrawGrad.UIGradient.Enabled = false
			CardClone.Card.DrawGrad.WildGradient.Enabled = false

			local GameColors = ColorList:GetChildren()

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
	
end

local module = {}

module.Mouse = nil

module.VCam = nil

function module:Init(mse)
	
	local VMCam = Instance.new("Camera")
	VMCam.Name = "VMCam"
	VMCam.FieldOfView = 1
	
	for i,v in pairs(GameUI.Results.StatsBack.Stats:GetChildren()) do
		v.CoinIcon.CurrentCamera = VMCam
	end
	
	GameUI.CoinsBack.VM.CurrentCamera = VMCam
	GameUI.ShopBack.TopBack.CoinsB.ColorLight.VM.CurrentCamera = VMCam
	GameUI.ShopBack.List.Lister.List.Crates.InfoBack.CoinBack.VM.CurrentCamera = VMCam
	GameUI.ShopBack.List.Lister.List.CrateInfo.InfoBack.CoinBack.VM.CurrentCamera = VMCam
	GameUI.ShopBack.List.Lister.List.Coins.InfoBack.CoinBack.VM.CurrentCamera = VMCam
	GameUI.DailyReward.Back.CoinsFrame.VM.CurrentCamera = VMCam
	
	for i,v in pairs(GameUI.ShopBack.List.Lister.List.Crates.ScrollerBack.Back.Scroller.xList:GetChildren()) do
		for a,b in pairs(v.Holder:GetChildren()) do
			local CrateM = game.ReplicatedStorage.ViewportModels:FindFirstChild(b.Bind.Crate.Value)
			if CrateM then
				local CrateC = CrateM:Clone()
				CrateC.Parent = b.ColorLight.VM
				b.ColorLight.VM.CurrentCamera = VMCam
			end
		end
	end
	
	for i,v in pairs(GameUI.ShopBack.List.Lister.List.Boosts.ScrollerBack.Back.Scroller.xList:GetChildren()) do
		for a,b in pairs(v.Holder:GetChildren()) do
			b.ColorLight.VM.CurrentCamera = VMCam
		end
	end
	
	for i,v in pairs(GameUI.ShopBack.List.Lister.List.Coins.ScrollerBack.Back.Scroller:GetChildren()) do
		v.ColorLight.VM.CurrentCamera = VMCam
	end
	
	local cRot = 0
	
	RunService.RenderStepped:Connect(function()
		cRot = cRot + 1.4
		VMCam.CFrame = game.Workspace.VMP.CFrame*CFrame.Angles(0,math.rad(cRot),0)*CFrame.new(0,0,-80)
		VMCam.CFrame = CFrame.new(VMCam.CFrame.p,game.Workspace.VMP.CFrame.p)
	end)
	
	self.Mouse = mse
	self.VCam = VMCam
	
	Binds.Test.Event:Connect(function(args)
		print("It works")
	end)
	
	Binds.LobbySection.Event:Connect(function(args)
		
		local ArgSection = args["Section"]
		
		if ArgSection then
			
			if ArgSection == ClientVars.LobbySection.Value then return end
			
			ClientVars.LobbySection.Value = ArgSection
			
			GameUI.Sounds.TransitionSound:Play()
			
			if ArgSection == "Classic" then
				GameUI.Browser.List.Back.Lister.List:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
			elseif ArgSection == "Super" then
				GameUI.Browser.List.Back.Lister.List:TweenPosition(UDim2.new(-1,0,0,0),"Out","Quad",.3,true)
			else
				GameUI.Browser.List.Back.Lister.List:TweenPosition(UDim2.new(-2,0,0,0),"Out","Quad",.3,true)
			end
			
			for i,v in pairs(GameUI.Browser.TopBack:GetChildren()) do
				if v.Name == ArgSection .. "B" then
					ButtonManager:SwitchColors(v,Color3.fromRGB(255, 199, 85),Color3.fromRGB(193, 150, 64),Color3.fromRGB(255, 215, 135))
				elseif v:IsA("TextButton") then
					ButtonManager:SwitchColors(v,Color3.fromRGB(106, 106, 106),Color3.fromRGB(83, 83, 83),Color3.fromRGB(138, 138, 138))
				end
			end
			
			local LastJoinB = nil
			
			local FindL = GameUI.Browser.List.Back.Lister.List:FindFirstChild(GameUI.ClientVars.LobbySection.Value)
			if FindL then
				local Lobbies = FindL.List:GetChildren()

				if #Lobbies == 0 then

					GameUI.Browser.List.CreateB.NextSelectionDown = GameUI.Browser.List.CreateB
					GameUI.Browser.List.CreateB.NextSelectionUp = GameUI.Browser.List.CreateB

				else

					for i,v in pairs(Lobbies) do

						if i == 1 then
							v.JoinB.NextSelectionUp = GameUI.Browser.List.CreateB
							GameUI.Browser.List.CreateB.NextSelectionDown = v.JoinB
						end
						
						if LastJoinB ~= nil then
							LastJoinB.NextSelectionDown = v.JoinB
							v.JoinB.NextSelectionUp = LastJoinB
						end

						if i == #Lobbies then
							v.JoinB.NextSelectionDown = GameUI.Browser.List.CreateB
							GameUI.Browser.List.CreateB.NextSelectionUp = v.JoinB
						end
						
						LastJoinB = v.JoinB

					end

				end

			end
			
			if GuiService.SelectedObject ~= nil then
				--GuiService.SelectedObject = GameUI.Browser.List.CreateB
			end
			
		end
		
	end)
	
	Binds.LobbyOpener.Event:Connect(function(args)
		
		if GameUI.ClientVars.LobbyCreOpen.Value or GameUI.ClientVars.ViewerOpen.Value or GameUI.ClientVars.Trading.Value then return end
		
		Binds.CloseInspector:Fire({})
		
		local ActionArg = args["Action"]
		if ActionArg then
			
			if ActionArg == "Close" then
				GameUI.ClientVars.LobbyOpen.Value = false
			end
			
		else
			GameUI.ClientVars.LobbyOpen.Value = not GameUI.ClientVars.LobbyOpen.Value
		end
		
		if GameUI.ClientVars.LobbyOpen.Value == false then
			GameUI.Sounds.CloseSound:Play()
			GameUI.Browser:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.2,true)
			
			if GuiService.SelectedObject ~= nil then
				--GuiService.SelectedObject = GameUI.MenuB.Button
			end
			
		else
			GameUI.Sounds.OpenSound:Play()
			if GameUI.ClientVars.IsMobile.Value == false then
				GameUI.Browser:TweenSize(UDim2.new(.8,0,.65,0),"Out","Quad",.2,true)
			else
				GameUI.Browser:TweenSize(UDim2.new(.8*(5/4),0,.65*(5/4),0),"Out","Quad",.2,true)
			end
			
			if GameUI.ClientVars.MenuOpen.Value then
				Binds.MenuOpener:Fire({Action = false})
			end
			if GameUI.ClientVars.ShopOpen.Value then
				Binds.ShopOpener:Fire({Action = "Close"})
			end
			
			if GuiService.SelectedObject ~= nil then
				--GuiService.SelectedObject = GameUI.Browser.List.CreateB
			end
			
			local FindL = GameUI.Browser.List.Back.Lister.List:FindFirstChild(GameUI.ClientVars.LobbySection.Value)
			if FindL then
				local Lobbies = FindL.List:GetChildren()
				
				if #Lobbies == 0 then
					
					GameUI.Browser.List.CreateB.NextSelectionDown = GameUI.Browser.List.CreateB
					GameUI.Browser.List.CreateB.NextSelectionUp = GameUI.Browser.List.CreateB
					
				else
					
					for i,v in pairs(Lobbies) do
						
						if i == 1 then
							v.JoinB.NextSelectionUp = GameUI.Browser.List.CreateB
							GameUI.Browser.List.CreateB.NextSelectionDown = v.JoinB
						end
						
						if i == #Lobbies then
							v.JoinB.NextSelectionDown = GameUI.Browser.List.CreateB
							GameUI.Browser.List.CreateB.NextSelectionUp = v.JoinB
						end
						
					end
					
				end
				
			end
			
		end
		
	end)
	
	Binds.LobbyCreatorHoverText.Event:Connect(function(args)
		local Txt = args["Txt"]
		if Txt then
			UIBoxManager:BoxText(GameUI.LobbyCreator.Back.CreBack.Lister.List.ModeSlide.InfoBox,Txt,{})
		end
	end)
	
	Binds.CreateLobby.Event:Connect(function(args)
		local Type = GameUI.ClientVars.LobbyCreation.Type.Value
		
		local Deck = GameUI.ClientVars.SelectedDeck.Value
		
		local Rules = {}
		
		for i,v in pairs(GameUI.ClientVars.LobbyCreation:GetChildren()) do
			Rules[v.Name] = v.Value
		end
		
		local ret,lobby = game.ReplicatedStorage.Remotes.CreateLobby:InvokeServer(Type,Rules,Deck)
		
		if ret == "Yay" then
			
			GameUI.ClientVars.CurrentLobby.Value = lobby
			
			GameUI.Bindables.LobbyCreOpener:Fire({Action = "Close"})
			GameUI.Bindables.ViewOpener:Fire({Action = "Open",Lobby = lobby})
			
		elseif ret == "Filtered" then
			
			GameUI.Sounds.Warn:Play()
			GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.CodeLocked.CodeFrame.Bar.Input.Text = "####"
			wait(1)
			GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.CodeLocked.CodeFrame.Bar.Input.Text = ""
			
		end
		
	end)
	
	Binds.LobbyCreSelect.Event:Connect(function(args)
		
		local Type = args["Type"]
		if Type then
			if Type == "Custom" then
				--
			else
				
			end
		end
		
	end)
	
	Binds.RuleEdit.Event:Connect(function(args)
		
		local Rule = args["Rule"]
		local Value = args["Val"]
		
		if Rule then
			
			local RuleFrame = GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules:FindFirstChild(Rule)
			local RuleVal = GameUI.ClientVars.LobbyCreation:FindFirstChild(Rule)
			
			if Rule == "Code" or (RuleFrame and RuleVal) then
				
				if Value or typeof(Value) == "boolean" then
					
					if Rule == "MaxPlrs" and Value then
						GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.MaxPlrs.Bottom.Slider.Input.Text = Value
					elseif Rule == "Code" and Value then
						GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.CodeLocked.CodeFrame.Bar.Input.Text = Value
					elseif Rule == "StartCards" and Value then
						GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.StartCards.Bottom.Slider.Input.Text = Value
					end
					
					RuleVal.Value = Value
				else
					RuleVal.Value = not RuleVal.Value
				end
				
				local NewVal = RuleVal.Value
				
				if Rule == "CodeLocked" then
					if NewVal == false then
						GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.CodeLocked.CodeFrame.Bar:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.15,true)
						
						GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.CodeLocked.Bottom.Slider.Button.NextSelectionLeft = GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.CodeLocked.Bottom.Slider.Button
						GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.StartCards.Bottom.Slider.Input.NextSelectionRight = GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.CodeLocked.Bottom.Slider.Button
					else
						GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.CodeLocked.CodeFrame.Bar:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.15,true)
						
						GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.CodeLocked.Bottom.Slider.Button.NextSelectionLeft = GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.CodeLocked.CodeFrame.Bar.Input
						GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.StartCards.Bottom.Slider.Input.NextSelectionRight = GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.CodeLocked.CodeFrame.Bar.Input
					end
				end
				
				if Rule ~= "MaxPlrs" and Rule ~= "Code" and Rule ~= "StartCards" then
					if NewVal == true then
						RuleFrame.Bottom.Slider.Button:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.15,true)
						ButtonManager:SwitchColors(RuleFrame.Bottom.Slider.Button,Color3.fromRGB(113, 217, 132),Color3.fromRGB(89, 171, 103),Color3.fromRGB(123, 235, 141))
						UIBoxManager:BoxImage(RuleFrame.Bottom.Slider.Button.ColorLight.ImgBox,8071991135)
					else
						RuleFrame.Bottom.Slider.Button:TweenPosition(UDim2.new(.61,0,0,0),"Out","Quad",.15,true)
						ButtonManager:SwitchColors(RuleFrame.Bottom.Slider.Button,Color3.fromRGB(161, 83, 83),Color3.fromRGB(116, 60, 60),Color3.fromRGB(194, 100, 100))
						UIBoxManager:BoxImage(RuleFrame.Bottom.Slider.Button.ColorLight.ImgBox,8071990635)
					end
				end
			end
			
		end
		
	end)
	
	Binds.RuleInfo.Event:Connect(function(args)
		
		local RuleTxt = args["Info"]
		if RuleTxt then
			UIBoxManager:BoxText(GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.InfoBox,RuleTxt)
			--GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.RuleInfo.Text = RuleTxt
		else
			UIBoxManager:BoxText(GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.InfoBox,"")
			--GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.RuleInfo.Text = ""
		end
		
	end)
	
	Binds.LobbyCreSection.Event:connect(function(args)
		
		local Section = args["Section"]
		local GameMode = args["GameMode"]
		
		if Section == GameUI.ClientVars.LobbyCreSection.Value then return end
		
		GameUI.Sounds.TransitionSound:Play()
		--print(1)
		if GameMode then
			GameUI.ClientVars.LobbyCreation.Type.Value = GameMode
			
			if GameMode == "Custom" and GameUI.ClientVars.SelectedDeck.Value == "" and Section and Section == "RulesSlide" then return end
			
		end
		
		GameUI.ClientVars.LobbyCreSection.Value = Section
		
		if Section then
			if Section == "RulesSlide" then
				
				--GamepadService:EnableGamepadCursor()
				
				GameUI.LobbyCreator.Back.CreBack.Lister.List:TweenPosition(UDim2.new(-2,0,0,0),"Out","Quad",.3,true)
				GameUI.LobbyCreator.Back.CancelB:TweenSize(UDim2.new(.476,0,.1,0),"Out","Quad",.3,true)
				GameUI.LobbyCreator.Back.CreateB:TweenPosition(UDim2.new(.983,0,.98,0),"Out","Quad",.3,true)
				GameUI.LobbyCreator.Back.SelectB:TweenPosition(UDim2.new(1.55,0,.98,0),"Out","Quad",.3,true)
				
				GameUI.LobbyCreator.Back.CreateB.NextSelectionDown = GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.SevenO.Bottom.Slider.Button
				GameUI.LobbyCreator.Back.CreateB.NextSelectionUp = GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.StartCards.Bottom.Slider.Input
				GameUI.LobbyCreator.Back.CreateB.NextSelectionLeft = GameUI.LobbyCreator.Back.CancelB
				GameUI.LobbyCreator.Back.CreateB.NextSelectionRight = GameUI.LobbyCreator.Back.CancelB
				
				GameUI.LobbyCreator.Back.CancelB.NextSelectionLeft = GameUI.LobbyCreator.Back.CreateB
				GameUI.LobbyCreator.Back.CancelB.NextSelectionRight = GameUI.LobbyCreator.Back.CreateB
				GameUI.LobbyCreator.Back.CancelB.NextSelectionUp = GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.CodeLocked.Bottom.Slider.Button
				GameUI.LobbyCreator.Back.CancelB.NextSelectionDown = GameUI.LobbyCreator.Back.CreBack.Lister.List.RulesSlide.Rules.Stacking.Bottom.Slider.Button
				
				if GuiService.SelectedObject ~= nil then
					--GuiService.SelectedObject = GameUI.LobbyCreator.Back.CreateB
				end
				
				if GameMode == "Classic" then

					GameUI.Bindables.RuleEdit:Fire({Rule = "SevenO",Val = false})
					GameUI.Bindables.RuleEdit:Fire({Rule = "Bluffing",Val = false})
					GameUI.Bindables.RuleEdit:Fire({Rule = "JumpIn",Val = false})
					GameUI.Bindables.RuleEdit:Fire({Rule = "ForcePlay",Val = true})
					GameUI.Bindables.RuleEdit:Fire({Rule = "Stacking",Val = false})
					GameUI.Bindables.RuleEdit:Fire({Rule = "CodeLocked",Val = false})
					GameUI.Bindables.RuleEdit:Fire({Rule = "DrawToMatch",Val = false})
					GameUI.Bindables.RuleEdit:Fire({Rule = "MaxPlrs",Val = 4})
					GameUI.Bindables.RuleEdit:Fire({Rule = "Type",Val = "Classic"})
					GameUI.Bindables.RuleEdit:Fire({Rule = "StartCards",Val = 7})

				elseif GameMode == "Super" then

					GameUI.Bindables.RuleEdit:Fire({Rule = "SevenO",Val = false})
					GameUI.Bindables.RuleEdit:Fire({Rule = "Bluffing",Val = true})
					GameUI.Bindables.RuleEdit:Fire({Rule = "JumpIn",Val = true})
					GameUI.Bindables.RuleEdit:Fire({Rule = "ForcePlay",Val = true})
					GameUI.Bindables.RuleEdit:Fire({Rule = "Stacking",Val = true})
					GameUI.Bindables.RuleEdit:Fire({Rule = "CodeLocked",Val = false})
					GameUI.Bindables.RuleEdit:Fire({Rule = "DrawToMatch",Val = true})
					GameUI.Bindables.RuleEdit:Fire({Rule = "MaxPlrs",Val = 4})
					GameUI.Bindables.RuleEdit:Fire({Rule = "Type",Val = "Super"})
					GameUI.Bindables.RuleEdit:Fire({Rule = "StartCards",Val = 7})

				else

					GameUI.Bindables.RuleEdit:Fire({Rule = "SevenO",Val = false})
					GameUI.Bindables.RuleEdit:Fire({Rule = "Bluffing",Val = false})
					GameUI.Bindables.RuleEdit:Fire({Rule = "JumpIn",Val = false})
					GameUI.Bindables.RuleEdit:Fire({Rule = "ForcePlay",Val = true})
					GameUI.Bindables.RuleEdit:Fire({Rule = "Stacking",Val = false})
					GameUI.Bindables.RuleEdit:Fire({Rule = "CodeLocked",Val = false})
					GameUI.Bindables.RuleEdit:Fire({Rule = "DrawToMatch",Val = false})
					GameUI.Bindables.RuleEdit:Fire({Rule = "MaxPlrs",Val = 4})
					GameUI.Bindables.RuleEdit:Fire({Rule = "Type",Val = "Custom"})
					GameUI.Bindables.RuleEdit:Fire({Rule = "StartCards",Val = 7})

				end
				
			elseif Section == "ModeSlide" then
				
				GameUI.LobbyCreator.Back.CreBack.Lister.List:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
				GameUI.LobbyCreator.Back.CreateB:TweenPosition(UDim2.new(1.55,0,.98,0),"Out","Quad",.3,true)
				GameUI.LobbyCreator.Back.CancelB:TweenSize(UDim2.new(.966,0,.1,0),"Out","Quad",.3,true)
				GameUI.LobbyCreator.Back.SelectB:TweenPosition(UDim2.new(1.55,0,.98,0),"Out","Quad",.3,true)
				
				GameUI.LobbyCreator.Back.CancelB.NextSelectionDown = GameUI.LobbyCreator.Back.CreBack.Lister.List.ModeSlide.SuperB
				GameUI.LobbyCreator.Back.CancelB.NextSelectionUp = GameUI.LobbyCreator.Back.CreBack.Lister.List.ModeSlide.CustomB
				
				if GuiService.SelectedObject ~= nil then
					--GuiService.SelectedObject = GameUI.LobbyCreator.Back.CreBack.Lister.List.ModeSlide.SuperB
				end
				
			else --Deck Slide
				
				GameUI.LobbyCreator.Back.CreBack.Lister.List.DeckSlide.List.Scroller.xList:ClearAllChildren()
				GameUI.ClientVars.SelectedDeck.Value = ""
				
				local LastHolder = nil
				local yMult = 0
				local xCount = 1
				
				local PlrData = game.ReplicatedStorage.PlayerData:FindFirstChild(GameUI.Parent.Parent.Parent.Name)
				if PlrData then
					
					local Decks = PlrData.Inventory.Decks:GetChildren()
					
					for i,v in pairs(Decks) do
						
						if i == 1 then
							local NewHolder = GameUI.GuiTemplates.DH:Clone()
							NewHolder.Parent = GameUI.LobbyCreator.Back.CreBack.Lister.List.DeckSlide.List.Scroller.xList
							LastHolder = NewHolder
						end
						
						local ButtonClone = GameUI.GuiTemplates.DeckB:Clone()
						ButtonClone.Parent = LastHolder.DeckHolder
						ButtonClone.Bind.Deck.Value = v.Name
						ButtonClone.Bind.Button.Value = ButtonClone
						ButtonClone.ColorLight.Count.Text = "x" .. #v:GetChildren()
						ButtonClone.ColorLight.Count.TxtDark.Text = ButtonClone.ColorLight.Count.Text
						ButtonClone.ColorLight.Ttl.Text = v.Name
						ButtonClone.ColorLight.Ttl.TxtDark.Text = v.Name
						ButtonClone.Visible = true
						
						xCount = xCount + 1
						if xCount > 5 then
							xCount = 1
							if i ~= #Decks then
								yMult = yMult + 1
								local NextHolder = GameUI.GuiTemplates.DH:Clone()
								NextHolder.Parent = GameUI.LobbyCreator.Back.CreBack.Lister.List.DeckSlide.List.Scroller.xList
								NextHolder.Position = UDim2.new(0,0,yMult,0)
								LastHolder = NextHolder
							end
						end
						
						ButtonManager:ButtonConnect(ButtonClone,mse)
						
					end
					
					if yMult <= 2 then
						GameUI.LobbyCreator.Back.CreBack.Lister.List.DeckSlide.List.Scroller.CanvasSize = UDim2.new(0,0,0,0)
					else
						GameUI.LobbyCreator.Back.CreBack.Lister.List.DeckSlide.List.Scroller.CanvasSize = UDim2.new(0,0,1 + ((yMult - 2)*(1/3)),0)
					end
					
					for i,v in pairs(GameUI.LobbyCreator.Back.CreBack.Lister.List.DeckSlide.List.Scroller.xList:GetChildren()) do
						
						local ButtonSteps = NumberStep(0,1,5)
						
						for a,b in pairs(v.DeckHolder:GetChildren()) do
							b.Position = UDim2.new(ButtonSteps[a],0,.5,0)
						end
						
					end
					
				end
				
				GameUI.LobbyCreator.Back.CreBack.Lister.List:TweenPosition(UDim2.new(-1,0,0,0),"Out","Quad",.3,true)
				GameUI.LobbyCreator.Back.CreateB:TweenPosition(UDim2.new(1.55,0,.98,0),"Out","Quad",.3,true)
				GameUI.LobbyCreator.Back.CancelB:TweenSize(UDim2.new(.476,0,.1,0),"Out","Quad",.3,true)
				GameUI.LobbyCreator.Back.SelectB:TweenPosition(UDim2.new(.983,0,.98,0),"Out","Quad",.3,true)
				
			end
		end
		
	end)
	
	Binds.LobbyCreOpener.Event:Connect(function(args)
		
		if GameUI.ClientVars.Trading.Value then return end
		
		local Action = args["Action"]
		if Action then
			
			if Action == "Open" then
				GameUI.Bindables.LobbyOpener:Fire({Action = "Close"})
				GameUI.ClientVars.LobbyCreOpen.Value = true
				GameUI.Sounds.OpenSound:Play()
				if GameUI.ClientVars.IsMobile.Value == false then
					GameUI.LobbyCreator:TweenSize(UDim2.new(.8,0,.6,0),"Out","Quad",.3,true)
				else
					GameUI.LobbyCreator:TweenSize(UDim2.new(.8*1.4,0,.6*1.4,0),"Out","Quad",.3,true)
				end
				if GuiService.SelectedObject ~= nil then
					--GuiService.SelectedObject = GameUI.LobbyCreator.Back.CreBack.Lister.List.ModeSlide.SuperB
				end
				
			else
				GameUI.ClientVars.LobbyCreOpen.Value = false
				GameUI.Sounds.CloseSound:Play()
				GameUI.Bindables.LobbyCreSection:Fire({Section = "ModeSlide"})
				GameUI.LobbyCreator:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
				
				if GuiService.SelectedObject ~= nil then
					--GuiService.SelectedObject = GameUI.MenuB.Button
				end
				
			end
			
		end
	end)
	
	Binds.ViewDowner.Event:Connect(function(args)
		
		GameUI.Sounds.TransitionSound:Play()
		
		local Action = args["Action"]
		if Action then
			
			if Action == "Close" then
				
				if GameUI.ClientVars.ViewerDown.Value then return end
				
				if GameUI.ClientVars.MenuOpen.Value then
					Binds.MenuOpener:Fire({Action = false})
				end
				
				if GameUI.ClientVars.ShopOpen.Value then
					Binds.ShopOpener:Fire({Action = "Close"})
				end
				
				GameUI.Bindables.CloseInspector:Fire({})
				
				GameUI.ClientVars.ViewerDown.Value = true
			else
				
				if not GameUI.ClientVars.ViewerDown.Value then return end
				
				GameUI.ClientVars.ViewerDown.Value = false
			end
			
			GameUI.Sounds.TransitionSound:Play()
			
			if GameUI.ClientVars.ViewerDown.Value then
				GameUI.LevelBack:TweenPosition(UDim2.new(.5,0,1.5,0),"Out","Quad",.2,true)
				GameUI.Viewer:TweenPosition(UDim2.new(.5,0,1.296,0),"Out","Quad",.2,true)
			else
				GameUI.LevelBack:TweenPosition(UDim2.new(.5,0,1.1,0),"Out","Quad",.2,true)
				GameUI.Viewer:TweenPosition(UDim2.new(.5,0,.43,0),"Out","Quad",.2,true)
				game.ReplicatedStorage.Remotes.CancelTrade:FireServer()
			end
			
		else
			
			GameUI.ClientVars.ViewerDown.Value = not GameUI.ClientVars.ViewerDown.Value
			if GameUI.ClientVars.ViewerDown.Value then
				GameUI.LevelBack:TweenPosition(UDim2.new(.5,0,1.5,0),"Out","Quad",.2,true)
				GameUI.Viewer:TweenPosition(UDim2.new(.5,0,1.296,0),"Out","Quad",.2,true)
			else
				GameUI.LevelBack:TweenPosition(UDim2.new(.5,0,1.1,0),"Out","Quad",.2,true)
				GameUI.Viewer:TweenPosition(UDim2.new(.5,0,.43,0),"Out","Quad",.2,true)
				if GameUI.ClientVars.MenuOpen.Value then
					Binds.MenuOpener:Fire({Action = false,NoDown = true})
				end

				if GameUI.ClientVars.ShopOpen.Value then
					Binds.ShopOpener:Fire({Action = "Close",NoDown = true})
				end

				GameUI.Bindables.CloseInspector:Fire({})
				game.ReplicatedStorage.Remotes.CancelTrade:FireServer()
			end
			
		end
		
	end)
	
	Binds.ViewOpener.Event:Connect(function(args)
		
		if GameUI.ClientVars.Trading.Value then return end
		
		local Action = args["Action"]
		local Loobby = args["Lobby"]
		
		if Action then
			if Action == "Open" then
				
				if Loobby then
					GameUI.Viewer.StartB:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
					GameUI.Bindables.ViewDowner:Fire({Action = "Open"})
					GameUI.ClientVars.ViewerOpen.Value = true
					
					if GameUI.ClientVars.IsMobile.Value == false then
						GameUI.Viewer:TweenSize(UDim2.new(1,0,.75,0),"Out","Quad",.3,true)
					else
						GameUI.Viewer:TweenSize(UDim2.new(1*(8/7),0,.75*(8/7),0),"Out","Quad",.3,true)
					end
					GameUI.Viewer.TopBar.Ttl.Text = string.upper(Loobby.Settings.Type.Value .. " SUNO LOBBY!")
					
					GameUI.Viewer.Back.TtlC.Text = "CARDS(START: " .. Loobby.Settings.StartCards.Value .. ")"
					
					for i,v in pairs(GameUI.Viewer.Back.Rules:GetChildren()) do
						local Rule = Loobby.Settings:FindFirstChild(v.Name)
						if Rule then
							if Rule.Value then
								v.Icon.Image = "rbxassetid://8071991135"
								v.Icon.ImageColor3 = Color3.fromRGB(0, 225, 165)
							else
								v.Icon.Image = "rbxassetid://8071990635"
								v.Icon.ImageColor3 = Color3.fromRGB(216, 89, 89)
							end
						end
					end
					
					local LobbyCards = Loobby.DeckData:GetChildren()
					
					local xCount = 1
					local yMult = 0
					
					GameUI.Viewer.Back.CardsBack.ListReal.List.xList:ClearAllChildren()
					
					local LastPosY = 0
					
					local LastLister = nil
					
					for i,v in pairs(LobbyCards) do
						local CardUI = GameUI.GuiTemplates.Card:Clone()
						CardUI.Name = v.Name
						
						local xPos = 0
						
						if xCount == 1 then
							CardUI.AnchorPoint = Vector2.new(0,0)
							xPos = 0
						elseif xCount == 2 then
							CardUI.AnchorPoint = Vector2.new(.5,0)
							xPos = .5
						elseif xCount == 3 then
							CardUI.AnchorPoint = Vector2.new(1,0)
							xPos = 1
						end
						
						if xCount == 1 then
							local ListerClone = GameUI.GuiTemplates.Lister:Clone()
							ListerClone.Parent = GameUI.Viewer.Back.CardsBack.ListReal.List.xList
							LastLister = ListerClone
							ListerClone.Position = UDim2.new(0,0,yMult,0)
						end
						
						CardUI.Parent = LastLister.CardHolder
						CardUI.Position = UDim2.new(xPos,0,0,0)
						CardUI.Selectable = false
						CardUI.But.Selectable = false
						
						LastPosY = yMult*1.11
						
						xCount = xCount + 1
						if xCount > 3 and i ~= #LobbyCards then
							yMult = yMult + 1
							xCount = 1
						end
						
						ApplyCardData(CardUI,v,Loobby.ColorList)
						
					end
					
					local yOff = yMult - 2
					--print(yOff)
					
					if #LobbyCards <= 9 then
						GameUI.Viewer.Back.CardsBack.ListReal.List.CanvasSize = UDim2.new(0,0,0,0)
					else
						GameUI.Viewer.Back.CardsBack.ListReal.List.CanvasSize = UDim2.new(0,0,1 + (yOff*(1/3)),0)
					end
					
					--local SlotsFF = (GameUI.Viewer.Back.CardsBack.List.CanvasSize.Y.Scale - 1)/.205
					--local SlotsF = LastPosY/1.11
					
					--print("Canvas Slots = " .. SlotsFF)
					--print("Last Card Slot = " .. SlotsF)
					
					GameUI.Bindables.ViewPlrUpdate:Fire({Lobby = Loobby})
				end
				
			else
				
				GameUI.Bindables.ViewDowner:Fire({Action = "Open"})
				GameUI.Viewer.Back.PlrsBack.List.Plrs:ClearAllChildren()
				GameUI.ClientVars.CurrentLobby.Value = nil
				GameUI.ClientVars.ViewerOpen.Value = false
				GameUI.Viewer:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
				
			end
		end
		
	end)
	
	Binds.ViewPlrUpdate.Event:Connect(function(args)
		
		local MePlayer = GameUI.Parent.Parent.Parent
		
		local Lobby = args["Lobby"]
		if Lobby then
			
			--Get rid of old labels
			for i,v in pairs(GameUI.Viewer.Back.PlrsBack.List.Plrs:GetChildren()) do
				local Corresponding = Lobby.Players:FindFirstChild(v.Name)
				if Corresponding then
					-- :P
				else
					
					if v.Name == GameUI.Parent.Parent.Parent.Name then
						
					end
					
					v:Destroy()
				end
			end
			
			local Plrz = Lobby.Players:GetChildren()
			
			if #Plrz <= 4 then
				GameUI.Viewer.Back.PlrsBack.List.CanvasSize = UDim2.new(0,0,.9,0)
			else
				GameUI.Viewer.Back.PlrsBack.List.CanvasSize = UDim2.new(0,0,.91 + ((#Plrz-4)*.23),0)
			end
			
			GameUI.Viewer.Back.PlrsTopper.Numbers.Max.Text = tostring(Lobby.Settings.MaxPlrs.Value)
			
			UIBoxManager:BoxText(GameUI.Viewer.Back.PlrsTopper.Numbers.InfoBox,tostring(#Plrz))
			
			for i,v in pairs(Plrz) do
				local Label = GameUI.Viewer.Back.PlrsBack.List.Plrs:FindFirstChild(v.Name)
				if Label then
					Label:TweenPosition(UDim2.new(0,0,i-1,0),"Out","Quad",.15,true)
				else
					
					local IsBot = false
					local BotName = ""
					
					if string.sub(v.Name,1,3) == "||." then
						IsBot = true
						BotName = string.sub(v.Name,4)
					end
					
					local pLabel = GameUI.GuiTemplates.PlrTemplate:Clone()
					
					if not IsBot then
						local PlrFind = game.Players:FindFirstChild(v.Name)
						if PlrFind then
							pLabel.Txt.Text = PlrFind.DisplayName
							pLabel.Txt.Dark.Text = PlrFind.DisplayName
						end
					else
						pLabel.Txt.Text = BotName
						pLabel.Txt.Dark.Text = BotName
					end
					
					if v.Name == Lobby.Settings.Host.Value then
						pLabel.Txt.TextColor3 = Color3.fromRGB(255, 255, 127)
					end
					
					spawn(function()
						if not IsBot then
							local Thumb,iR = game.Players:GetUserThumbnailAsync(game.Players:GetUserIdFromNameAsync(v.Name),Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)
							pLabel.Icon.Image = Thumb
						else
							pLabel.Icon.Image = "rbxassetid://8157351271"
							pLabel.Icon.Dark.Image = "rbxassetid://8157351271"
							pLabel.Icon.Dark.Visible = true
						end
					end)
					
					pLabel.Name = v.Name
					pLabel.Parent = GameUI.Viewer.Back.PlrsBack.List.Plrs
					pLabel.Visible = true
					pLabel:TweenPosition(UDim2.new(0,0,i-1,0),"Out","Quad",.15,true)
					
					if Lobby.Settings.Host.Value ~= MePlayer.Name then
						pLabel.KickB.Visible = false
					end
					
					pLabel.KickB.Bind.Player.Value = v.Name
					
					if v.Name == Lobby.Settings.Host.Value then
						pLabel.KickB.Visible = false
						pLabel.Crown.Visible = true
					end
					
					ButtonManager:ButtonConnect(pLabel.KickB,mse,true)
					
				end
			end
			
		end
	end)
	
	Binds.JoinLobby.Event:Connect(function(args)
		
		local LobbyName = args["LobbyName"]
		local Type = args["Type"]
		local Code = args["Code"]
		
		if LobbyName and Type then
			local TypeF = game.ReplicatedStorage.Lobbies:FindFirstChild(Type)
			if TypeF then
				local Lobby = TypeF:FindFirstChild(LobbyName)
				if Lobby then
					
					if Lobby.Settings.CodeLocked.Value then
						if Code ~= nil then
							local status, lobby = game.ReplicatedStorage.Remotes.JoinLobby:InvokeServer(LobbyName,Code)
							if status == "Yay" then
								GameUI.ClientVars.CurrentLobby.Value = lobby

								GameUI.Bindables.LobbyOpener:Fire({Action = "Close"})
								GameUI.Bindables.LobbyCreOpener:Fire({Action = "Close"})
								GameUI.Bindables.CodePromptOpener:Fire({Action = "Close"})
								GameUI.Bindables.ViewOpener:Fire({Action = "Open",Lobby = lobby})
							elseif status == "WrongCode" then
								
							end
						else
							GameUI.Bindables.CodePromptOpener:Fire({Action = "Open",Lobby = LobbyName,Type = Type})
						end
					else
						local status, lobby = game.ReplicatedStorage.Remotes.JoinLobby:InvokeServer(LobbyName)
						if status == "Yay" then
							GameUI.ClientVars.CurrentLobby.Value = lobby
							
							GameUI.Bindables.LobbyOpener:Fire({Action = "Close"})
							GameUI.Bindables.LobbyCreOpener:Fire({Action = "Close"})
							GameUI.Bindables.CodePromptOpener:Fire({Action = "Close"})
							GameUI.Bindables.ViewOpener:Fire({Action = "Open",Lobby = lobby})
						end
					end
					
				end
			end
		end
		
	end)
	
	Binds.LeaveLobby.Event:Connect(function(args)
		local ret = game.ReplicatedStorage.Remotes.LeaveLobby:InvokeServer()
		
		GameUI.ClientVars.CurrentLobby.Value = nil
		GameUI.Viewer.Back.PlrsBack.List.Plrs:ClearAllChildren()
		
		GameUI.Bindables.ViewOpener:Fire({Action = "Close"})
	end)
	
	Binds.AddBot.Event:Connect(function(args)
		game.ReplicatedStorage.Remotes.AddBot:FireServer()
	end)
	
	Binds.RemoveBot.Event:Connect(function(args)
		
	end)
	
	Binds.KickPlayer.Event:Connect(function(args)
		--print(1)
		local Plr = args["Player"]
		if Plr then
			--print(2)
			game.ReplicatedStorage.Remotes.KickPlayer:InvokeServer(Plr)
		end
	end)
	
	Binds.StartGame.Event:Connect(function(args)
		game.ReplicatedStorage.Remotes.StartGame:FireServer()
	end)
	
	Binds.CodePromptOpener.Event:Connect(function(args)
		
		local Action = args["Action"]
		local Lobby = args["Lobby"]
		local Type = args["Type"]
		
		if Action then
			
			if Action == "Open" and Lobby and Type then
				GameUI.Sounds.OpenSound:Play()
				
				if GameUI.ClientVars.IsMobile.Value == false then
					GameUI.CodePrompt:TweenSize(UDim2.new(.4,0,.2,0),"Out","Quad",.3,true)
				else
					GameUI.CodePrompt:TweenSize(UDim2.new(.4*1.75,0,.2*1.75,0),"Out","Quad",.3,true)
				end
				
				GameUI.CodePrompt.Back.JoinB.Bind.LobbyName.Value = Lobby
				GameUI.CodePrompt.Back.JoinB.Bind.Type.Value = Type
			else
				GameUI.Sounds.CloseSound:Play()
				GameUI.CodePrompt:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
			end
			
		end
		
	end)
	
	Binds.Notification.Event:Connect(function(args)
		
	end)
	
	Binds.CardUnHover.Event:Connect(function(args)
		
		local Card = args["Card"]

		if Card then
			
			--print(2)
			
			GameUI.CardInfo.CardTtl.Text = ""
			GameUI.CardInfo.CardTtl.Dark.Text = ""
			GameUI.CardInfo.Info.Text = ""
			GameUI.CardInfo.Info.Dark.Text = ""
			GameUI.CardInfo:TweenPosition(UDim2.new(1.4,0,.6,0),"Out","Quad",.5,true)

			Card.Data.Hoving.Value = false
			Card.ZIndex = Card.Data.ZX.Value
			--Card:TweenPosition(UDim2.new(Card.Data.XOff.Value,0,Card.Data.YOff.Value,0),"Out","Quad",.3,true)
			Card.Card:TweenPosition(UDim2.new(.5,0,.5,0),"Out","Quad",.3,true)

			local GleamTween = TweenService:Create(Card.Card.Gleam,GleamTI,{ImageTransparency = 1})
			GleamTween:Play()

			game.Debris:AddItem(GleamTween,.31)
			
			GameUI.ClientVars.CurrentCard.Value = nil
			
		end
		
	end)
	
	Binds.CardHover2.Event:Connect(function(args)
		
		local Card = args["Card"]
		
		if Card then
			--print(1)
			if GameUI.ClientVars.CurrentCard.Value and GameUI.ClientVars.CurrentCard.Value.Parent and GameUI.ClientVars.CurrentCard.Value.Parent ~= nil then
				Binds.CardUnHover:Fire({Card = GameUI.ClientVars.CurrentCard.Value})
			end
			
			if CardInfos[Card.Data.Type.Value] then
				GameUI.CardInfo.CardTtl.Text = Card.Data.Type.Value
				GameUI.CardInfo.CardTtl.Dark.Text = Card.Data.Type.Value
				GameUI.CardInfo.Info.Text = CardInfos[Card.Data.Type.Value]
				GameUI.CardInfo.Info.Dark.Text = CardInfos[Card.Data.Type.Value]
				GameUI.CardInfo:TweenPosition(UDim2.new(.99,0,.6,0),"Out","Quad",.5,true)
			else
				GameUI.CardInfo.CardTtl.Text = ""
				GameUI.CardInfo.CardTtl.Dark.Text = ""
				GameUI.CardInfo.Info.Text = ""
				GameUI.CardInfo.Info.Dark.Text = ""
				GameUI.CardInfo:TweenPosition(UDim2.new(1.4,0,.6,0),"Out","Quad",.5,true)
			end
			
			GameUI.ClientVars.CurrentCard.Value = Card
			
			Card.ZIndex = 999
			--Card:TweenPosition(UDim2.new(Card.Data.XOff.Value,0,Card.Data.YOff.Value-.25,0),"Out","Quad",.3,true)
			Card.Card:TweenPosition(UDim2.new(.5,0,.25,0),"Out","Quad",.3,true)

			local GleamTween = TweenService:Create(Card.Card.Gleam,GleamTI,{ImageTransparency = .8})
			GleamTween:Play()

			game.Debris:AddItem(GleamTween,.31)
			
		end
		
	end)
	
	Binds.CardHover.Event:Connect(function(args)
		
		local Card = args["Card"]
		local Hoving = args["Hoving"]
		
		if Card then
			
			if Card.Data.Played.Value then 
				
				GameUI.CardInfo.CardTtl.Text = ""
				GameUI.CardInfo.CardTtl.Dark.Text = ""
				GameUI.CardInfo.Info.Text = ""
				GameUI.CardInfo.Info.Dark.Text = ""
				GameUI.CardInfo:TweenPosition(UDim2.new(1.4,0,.6,0),"Out","Quad",.5,true)
				
				return 
			end
			
			--[[if Card.Data.Hoving.Value then
				
				if CardInfos[Card.Data.Type.Value] then
					GameUI.CardInfo.CardTtl.Text = Card.Data.Type.Value
					GameUI.CardInfo.CardTtl.Dark.Text = Card.Data.Type.Value
					GameUI.CardInfo.Info.Text = CardInfos[Card.Data.Type.Value]
					GameUI.CardInfo.Info.Dark.Text = CardInfos[Card.Data.Type.Value]
					GameUI.CardInfo:TweenPosition(UDim2.new(.01,0,.5,0),"Out","Quad",.5,true)
				end
				
			else
				
				GameUI.CardInfo.CardTtl.Text = ""
				GameUI.CardInfo.CardTtl.Dark.Text = ""
				GameUI.CardInfo.Info.Text = ""
				GameUI.CardInfo.Info.Dark.Text = ""
				GameUI.CardInfo:TweenPosition(UDim2.new(-.4,0,.5,0),"Out","Quad",.5,true)
				
			end]]
			
			if Hoving then
				
				if Card.Data.Hoving.Value then return end
				
				--GameUI.ClientVars.CardHoving.Value = true
				
				--print("Testing")
				
				if CardInfos[Card.Data.Type.Value] then
					GameUI.CardInfo.CardTtl.Text = Card.Data.Type.Value
					GameUI.CardInfo.CardTtl.Dark.Text = Card.Data.Type.Value
					GameUI.CardInfo.Info.Text = CardInfos[Card.Data.Type.Value]
					GameUI.CardInfo.Info.Dark.Text = CardInfos[Card.Data.Type.Value]
					GameUI.CardInfo:TweenPosition(UDim2.new(.99,0,.6,0),"Out","Quad",.5,true)
				else
					GameUI.CardInfo.CardTtl.Text = ""
					GameUI.CardInfo.CardTtl.Dark.Text = ""
					GameUI.CardInfo.Info.Text = ""
					GameUI.CardInfo.Info.Dark.Text = ""
					GameUI.CardInfo:TweenPosition(UDim2.new(1.4,0,.6,0),"Out","Quad",.5,true)
				end
				
				if GameUI.ClientVars.CurrentCard.Value and GameUI.ClientVars.CurrentCard.Value.Parent and GameUI.ClientVars.CurrentCard.Value.Parent ~= nil then
					GameUI.Bindables.CardHover:Fire({Card = GameUI.ClientVars.CurrentCard.Value,Hover = false})
					if CardInfos[Card.Data.Type.Value] then
						GameUI.CardInfo.CardTtl.Text = Card.Data.Type.Value
						GameUI.CardInfo.CardTtl.Dark.Text = Card.Data.Type.Value
						GameUI.CardInfo.Info.Text = CardInfos[Card.Data.Type.Value]
						GameUI.CardInfo.Info.Dark.Text = CardInfos[Card.Data.Type.Value]
						GameUI.CardInfo:TweenPosition(UDim2.new(.99,0,.6,0),"Out","Quad",.5,true)
					else
						GameUI.CardInfo.CardTtl.Text = ""
						GameUI.CardInfo.CardTtl.Dark.Text = ""
						GameUI.CardInfo.Info.Text = ""
						GameUI.CardInfo.Info.Dark.Text = ""
						GameUI.CardInfo:TweenPosition(UDim2.new(1.4,0,.6,0),"Out","Quad",.5,true)
					end
				end
				
				GameUI.ClientVars.CurrentCard.Value = Card
				
				Card.Data.Hoving.Value = true
				Card.ZIndex = 999
				--Card:TweenPosition(UDim2.new(Card.Data.XOff.Value,0,Card.Data.YOff.Value-.25,0),"Out","Quad",.3,true)
				Card.Card:TweenPosition(UDim2.new(.5,0,.25,0),"Out","Quad",.3,true)
				
				local GleamTween = TweenService:Create(Card.Card.Gleam,GleamTI,{ImageTransparency = .8})
				GleamTween:Play()
				
				game.Debris:AddItem(GleamTween,.31)
			else
				
				if not Card.Data.Hoving.Value then return end
				
				--print("Esting")
				
				GameUI.CardInfo.CardTtl.Text = ""
				GameUI.CardInfo.CardTtl.Dark.Text = ""
				GameUI.CardInfo.Info.Text = ""
				GameUI.CardInfo.Info.Dark.Text = ""
				GameUI.CardInfo:TweenPosition(UDim2.new(1.4,0,.6,0),"Out","Quad",.5,true)
				
				Card.Data.Hoving.Value = false
				Card.ZIndex = Card.Data.ZX.Value
				--Card:TweenPosition(UDim2.new(Card.Data.XOff.Value,0,Card.Data.YOff.Value,0),"Out","Quad",.3,true)
				Card.Card:TweenPosition(UDim2.new(.5,0,.5,0),"Out","Quad",.3,true)
				
				local GleamTween = TweenService:Create(Card.Card.Gleam,GleamTI,{ImageTransparency = 1})
				GleamTween:Play()

				game.Debris:AddItem(GleamTween,.31)
				
			end
			
		else
			
			GameUI.CardInfo.CardTtl.Text = ""
			GameUI.CardInfo.CardTtl.Dark.Text = ""
			GameUI.CardInfo.Info.Text = ""
			GameUI.CardInfo.Info.Dark.Text = ""
			GameUI.CardInfo:TweenPosition(UDim2.new(1.4,0,.6,0),"Out","Quad",.5,true)
			
		end
		
	end)
	
	Binds.PlayCard.Event:Connect(function(args)
		local Card = args["Card"]
		if Card then
			local CorreCard = GameUI.Parent.Parent.RealGame.GameFrames.Cards:FindFirstChild(Card)
			if CorreCard then
				if CorreCard.Data.Playable.Value then
					
					CorreCard.Data.Played.Value = true
					
					for i,v in pairs(GameUI.Parent.Parent.RealGame.GameFrames.Cards:GetChildren()) do
						v.Data.Playable.Value = false
					end

					GameUI.Sounds.CardPick:Play()

					CorreCard.Card:TweenPosition(UDim2.new(.5,0,2,0),"Out","Quad",.1,true)
					
					GameUI.CardInfo.CardTtl.Text = ""
					GameUI.CardInfo.CardTtl.Dark.Text = ""
					GameUI.CardInfo.Info.Text = ""
					GameUI.CardInfo.Info.Dark.Text = ""
					GameUI.CardInfo:TweenPosition(UDim2.new(1.4,0,.6,0),"Out","Quad",.5,true)
					
					local DidPlay = game.ReplicatedStorage.Remotes.PlayCard:InvokeServer(Card)
					if not DidPlay then
						CorreCard.Card:TweenPosition(UDim2.new(.5,0,.5,0),"Out","Quad",.1,true)
						CorreCard.Data.Played.Value = false
						for i,v in pairs(GameUI.Parent.Parent.RealGame.GameFrames.Cards:GetChildren()) do
							v.Data.Playable.Value = true
						end
					else
						if #UserInputService:GetConnectedGamepads() > 0 then
							GuiService.SelectedObject = nil
							GamepadService:EnableGamepadCursor(GameUI)
						end
					end
				end
			end
		end
	end)
	
	Binds.SetAction.Event:Connect(function(args)
		
		local Action = args["Action"]
		if Action then
			game.ReplicatedStorage.Remotes.SetAction:FireServer(Action)
		end
		
	end)
	
	Binds.CallUno.Event:Connect(function()
		game.ReplicatedStorage.Remotes.CallUno:FireServer()
	end)
	
	Binds.PickColor.Event:Connect(function(args)
		
		local Col = args["Col"]
		if Col then
			game.ReplicatedStorage.Remotes.PickColor:FireServer(Col)
		end
		
	end)
	
	Binds.SwapChoice.Event:Connect(function(args)
		
		local Plr = args["Player"]
		if Plr and Plr ~= "" then
			game.ReplicatedStorage.Remotes.ChoseSwap:FireServer(Plr)
		end
		
		GameUI.Sounds.CloseSound:Play()
		
		GameUI.SwapPicker:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.5,true)
		
	end)
	
	Binds.LeaveGame.Event:Connect(function()
		game.ReplicatedStorage.Remotes.QuitLobby:FireServer()
	end)
	
	Binds.SelectDeck.Event:Connect(function(args)
		
		local Deck = args["Deck"]
		local Button = args["Button"]
		
		if Deck and Button then
			
			for i,v in pairs(GameUI.LobbyCreator.Back.CreBack.Lister.List.DeckSlide.List.Scroller.xList:GetChildren()) do
				for a,b in pairs(v.DeckHolder:GetChildren()) do
					b.ColorLight.CheckBox.Check:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.2,true)
				end
			end
			
			Button.ColorLight.CheckBox.Check:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.2,true)
			GameUI.ClientVars.SelectedDeck.Value = Deck
			
		end
		
	end)
	
	Binds.SkipResults.Event:Connect(function()
		GameUI.ClientVars.SkipResults.Value = true
	end)
	
	Binds.NumberChoice.Event:Connect(function(args)
		
		local Number = args["Number"]
		if Number then
			game.ReplicatedStorage.Remotes.ChoseNumber:FireServer(Number)
			GameUI.Parent.Parent.RealGame.NumberPicker:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
			GameUI.Sounds.CloseSound:Play()
		end
		
	end)
	
	Binds.MenuOpener.Event:Connect(function(args)
		
		GameUI.Bindables.SlotSelectionOpener:Fire({Action = "Close"})
		
		if GameUI.ClientVars.LobbyCreOpen.Value or GameUI.ClientVars.Trading.Value then return end
		
		local NoDown = args["NoDown"]
		if NoDown == nil then
			GameUI.Bindables.ViewDowner:Fire({Action = "Close"})
		end
		
		Binds.CloseInspector:Fire({})
		
		local sAction = args["Action"]
		if sAction ~= nil then
			GameUI.ClientVars.MenuOpen.Value = sAction
		else
			GameUI.ClientVars.MenuOpen.Value = not GameUI.ClientVars.MenuOpen.Value
		end
		
		if GameUI.ClientVars.MenuOpen.Value then
			if GameUI.ClientVars.LobbyOpen.Value then
				Binds.LobbyOpener:Fire({Action = "Close"})
			end
			if GameUI.ClientVars.ShopOpen.Value then
				Binds.ShopOpener:Fire({Action = "Close"})
			end
			GameUI.Sounds.OpenSound:Play()
			if GameUI.ClientVars.IsMobile.Value == false then
				GameUI.MenuBack:TweenSize(UDim2.new(1,0,.65,0),"Out","Quad",.2,true)
			else
				GameUI.MenuBack:TweenSize(UDim2.new(1*(5/4),0,.65*(5/4),0),"Out","Quad",.2,true)
			end
			
			Binds.MenuSection:Fire({SectionPos = 0,Section = "MAIN MENU"})
			
			if GuiService.SelectedObject ~= nil then
				--GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.MainMenu.InvB
			end
			
		else
			GameUI.Sounds.CloseSound:Play()
			GameUI.MenuBack:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.2,true)
			
			local InventoryFrame = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List

			InventoryFrame.Decor.ScrollBack.Back.Scroller.xList:ClearAllChildren()
			InventoryFrame.Chairs.ScrollBack.Back.Scroller.xList:ClearAllChildren()
			InventoryFrame.Particles.ScrollBack.Back.Scroller.xList:ClearAllChildren()
			
			GameUI.MenuBack.List.Lister.List.Crafting.MyStuff.Back.Scroller.xList:ClearAllChildren()
			GameUI.MenuBack.List.Lister.List.Crafting.ToCraft.Back.Scroller.xList:ClearAllChildren()
			
			if GuiService.SelectedObject ~= nil then
				--GuiService.SelectedObject = GameUI.PlayB.Button
			end
		end
		
	end)
	
	Binds.MenuSection.Event:Connect(function(args)
		
		GameUI.Bindables.SlotSelectionOpener:Fire({Action = "Close"})
		
		local Pos = args["SectionPos"]
		local Section = args["Section"]
		
		if Pos and Section then
			
			GameUI.ClientVars.MenuSection.Value = Section
			
			UIBoxManager:BoxText(GameUI.MenuBack.TopBack.TtlBox,Section,nil)
			GameUI.MenuBack.List.Lister.List:TweenPosition(UDim2.new(Pos,0,0,0),"Out","Quad",.3,true)
			GameUI.Sounds.TransitionSound:Play()
			
			if Section ~= "INVENTORY" and Section ~= "TRADING" then
				GameUI.MenuBack.List.XboxL:TweenPosition(UDim2.new(.1,0,.05,0),"Out","Quad",.3,true)
				GameUI.MenuBack.List.XboxR:TweenPosition(UDim2.new(.9,0,.05,0),"Out","Quad",.3,true)
			end
			
			if Section ~= "INVENTORY" then
				
				local InventoryFrame = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List

				InventoryFrame.Decor.ScrollBack.Back.Scroller.xList:ClearAllChildren()
				InventoryFrame.Chairs.ScrollBack.Back.Scroller.xList:ClearAllChildren()
				InventoryFrame.Particles.ScrollBack.Back.Scroller.xList:ClearAllChildren()
				
			end
			
			if Section == "INVENTORY" then
				
				GameUI.Bindables.RefreshInventory:Fire({})
				
				GameUI.MenuBack.List.XboxL:TweenPosition(UDim2.new(-.01,0,.05,0),"Out","Quad",.3,true)
				GameUI.MenuBack.List.XboxR:TweenPosition(UDim2.new(1.01,0,.05,0),"Out","Quad",.3,true)
				
			elseif Section == "DECK BUILDER" then
				GameUI.Bindables.LoadDecks:Fire({})
			elseif Section == "SPECTATE" then
				GameUI.Bindables.RefreshWatchList:Fire({})
			elseif Section == "CRAFTING" then
				GameUI.Bindables.RefreshCraft:Fire({})
			elseif Section == "TRADING" then
				GameUI.MenuBack.List.XboxL:TweenPosition(UDim2.new(-.01,0,.05,0),"Out","Quad",.3,true)
				GameUI.MenuBack.List.XboxR:TweenPosition(UDim2.new(1.01,0,.05,0),"Out","Quad",.3,true)
			end
			
			if Pos == 0 then
				GameUI.MenuBack.TopBack:TweenSize(UDim2.new(.928,0,.1,0),"Out","Quad",.3,true)
				GameUI.MenuBack.BackFrame.BackF:TweenPosition(UDim2.new(-1,0,0,0),"Out","Quad",.3,true)
			else
				GameUI.MenuBack.TopBack:TweenSize(UDim2.new(.855,0,.1,0),"Out","Quad",.3,true)
				GameUI.MenuBack.BackFrame.BackF:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
			end
			
			--[[if GuiService.SelectedObject ~= nil then
				if Section == "MAIN MENU" then
					GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.MainMenu.InvB
				elseif Section == "INVENTORY" then
					--
				elseif Section == "DECK BUILDER" then
					GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.CreateB
				elseif Section == "CODES" then
					GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.Codes.CodeBack.Input
				elseif Section == "SETTINGS" then
					GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.Settings.TradeBack.Slider.Button
				elseif Section == "TRADING" then
					GuiService.SelectedObject = GameUI.MenuBack.BackFrame.BackF.BackB
				elseif Section == "CRAFTING" then
					GuiService.SelectedObject = GameUI.MenuBack.BackFrame.BackF.BackB
				elseif Section == "PRESTIGE" then
					GuiService.SelectedObject = GameUI.MenuBack.BackFrame.BackF.BackB
				elseif Section == "SPECTATE" then
					--GuiService.SelectedObject = GameUI.MenuBack.BackFrame.BackF.BackB
				end
			end]]
			
		end
		
	end)
	
	Binds.InvSection.Event:Connect(function(args)
		
		GameUI.Bindables.SlotSelectionOpener:Fire({Action = "Close"})
		
		local Section = args["Section"]
		if Section then
			
			if GameUI.ClientVars.InvSection.Value == Section then return end
			
			GameUI.Sounds.TransitionSound:Play()
			
			GameUI.ClientVars.InvSection.Value = Section
			
			if Section == "Decor" then
				GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
				if GuiService.SelectedObject ~= nil and GameUI.ClientVars.InvSection.Value == "Decor" then
					--GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons.Slot2
				end
			elseif Section == "Chairs" then
				GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List:TweenPosition(UDim2.new(-1,0,0,0),"Out","Quad",.3,true)
				if GuiService.SelectedObject ~= nil then
					--GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Chairs.EquipBack.EquBack.ButtonClip.EqB
				end
			else
				GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List:TweenPosition(UDim2.new(-2,0,0,0),"Out","Quad",.3,true)
				if GuiService.SelectedObject ~= nil then
					local FoundButton = false
					
					for i,v in pairs(GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.ScrollBack.Back.Scroller.xList:GetChildren()) do
						for a,b in pairs(v.Spacer:GetChildren()) do
							if b:IsA("TextButton") then
								FoundButton = true
								--GuiService.SelectedObject = b
								break
							end
						end
						if FoundButton then
							break
						end
					end
					
					if not FoundButton then
						--GuiService.SelectedObject = GameUI.MenuBack.BackFrame.BackF.BackB
					end
				end
			end
			
			for i,v in pairs(GameUI.MenuBack.List.Lister.List.Inventory.TopButtons:GetChildren()) do
				if v.Name == Section .. "B" then
					ButtonManager:SwitchColors(v,Color3.fromRGB(255, 199, 85),Color3.fromRGB(193, 150, 64),Color3.fromRGB(255, 215, 135))
				else
					ButtonManager:SwitchColors(v,Color3.fromRGB(106, 106, 106),Color3.fromRGB(83, 83, 83),Color3.fromRGB(138, 138, 138))
				end
			end
			
		end
		
	end)
	
	Binds.RefreshInventory.Event:Connect(function(args)
		
		local OnlySlot
		local HardPrev
		local DecPrev
		local NoChair = false
		local ParticlePrev
		
		if args ~= nil then
			OnlySlot = args["OnlySlot"]
			HardPrev = args["HardPrevSlot"]
			DecPrev = args["PrevDec"]
			NoChair = args["NoChair"]
			ParticlePrev = args["ParticlePrev"]
		end
		
		local InventoryFrame = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List
		
		InventoryFrame.Decor.ScrollBack.Back.Scroller.xList:ClearAllChildren()
		InventoryFrame.Chairs.ScrollBack.Back.Scroller.xList:ClearAllChildren()
		InventoryFrame.Particles.ScrollBack.Back.Scroller.xList:ClearAllChildren()
		
		local yOff = 0
		local ButCount = 0
		
		local LastHolder = GameUI.GuiTemplates.InvHolder:Clone()
		LastHolder.Parent = InventoryFrame.Decor.ScrollBack.Back.Scroller.xList
		
		local PlayerData = game.ReplicatedStorage.PlayerData:FindFirstChild(GameUI.Parent.Parent.Parent.Name)
		if PlayerData then
			
			--Decor Loading
			
			if GuiService.SelectedObject ~= nil and GameUI.ClientVars.InvSection.Value == "Decor" then
				--GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons.Slot2
			end
			
			local vFirstX,vTwoX,vThreeX,vFourX = nil,nil,nil,nil
			local CurrOne,CurrTwo,CurrThree,CurrFour = nil,nil,nil,nil
			local LastOne,LastTwo,LastThree,LastFour = nil,nil,nil,nil
			
			GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons.Slot4.NextSelectionRight = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons.Slot1
			GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons.Slot1.NextSelectionLeft = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons.Slot4
			
			for i,v in pairs(PlayerData.Inventory.Decorations:GetChildren()) do
				ButCount = ButCount + 1
				
				local xPos = 0
				
				if ButCount == 2 then
					xPos = 1/3
				elseif ButCount == 3 then
					xPos = 2/3
				elseif ButCount == 4 then
					xPos = 1
				end
				
				local inButton = GameUI.GuiTemplates.InvB:Clone()
				inButton.Parent = LastHolder.Spacer
				inButton.Position = UDim2.new(xPos,0,.5,0)
				inButton.ColorLight.VM.CurrentCamera = VMCam
				
				--Xbox Selection stuffs
				
				if ButCount == 1 then
					
					if vFirstX == nil then
						vFirstX = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons.Slot4.NextSelectionRight = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons.Slot1.NextSelectionLeft = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.EqB.NextSelectionLeft = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.UnEqB.NextSelectionLeft = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.EqB.NextSelectionRight = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.UnEqB.NextSelectionRight = inButton
						inButton.NextSelectionUp = inButton
					else
						if vFirstX.NextSelectionDown == nil then
							vFirstX.NextSelectionDown = inButton
						end
						vFirstX.NextSelectionUp = inButton
					end
					if CurrOne ~= nil then
						inButton.NextSelectionUp = CurrOne
						CurrOne.NextSelectionDown = inButton
					end
					inButton.NextSelectionLeft = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons.Slot4
					inButton.NextSelectionRight = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons.Slot1
					inButton.NextSelectionDown = vFirstX
					CurrOne = inButton
					
				elseif ButCount == 2 then
					
					if vTwoX == nil then
						vTwoX = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons.Slot1.NextSelectionLeft = inButton
						inButton.NextSelectionUp = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.EqB.NextSelectionLeft = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.UnEqB.NextSelectionLeft = inButton
					else
						if vTwoX.NextSelectionDown == nil then
							vTwoX.NextSelectionDown = inButton
						end
						vTwoX.NextSelectionUp = inButton
					end
					if CurrTwo ~= nil then
						inButton.NextSelectionUp = CurrTwo
						CurrTwo.NextSelectionDown = inButton
					end
					CurrOne.NextSelectionRight = inButton
					inButton.NextSelectionLeft = CurrOne
					inButton.NextSelectionRight = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons.Slot1
					inButton.NextSelectionDown = vTwoX
					CurrTwo = inButton
					
				elseif ButCount == 3 then

					if vThreeX == nil then
						vThreeX = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons.Slot1.NextSelectionLeft = inButton
						inButton.NextSelectionUp = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.EqB.NextSelectionLeft = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.UnEqB.NextSelectionLeft = inButton
					else
						if vThreeX.NextSelectionDown == nil then
							vThreeX.NextSelectionDown = inButton
						end
						vThreeX.NextSelectionUp = inButton
					end
					if CurrThree ~= nil then
						inButton.NextSelectionUp = CurrThree
						CurrThree.NextSelectionDown = inButton
					end
					CurrTwo.NextSelectionRight = inButton
					inButton.NextSelectionLeft = CurrTwo
					inButton.NextSelectionRight = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons.Slot1
					inButton.NextSelectionDown = vThreeX
					CurrThree = inButton
					
				elseif ButCount == 4 then

					if vFourX == nil then
						vFourX = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons.Slot1.NextSelectionLeft = inButton
						inButton.NextSelectionUp = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.EqB.NextSelectionLeft = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.UnEqB.NextSelectionLeft = inButton
					else
						if vFourX.NextSelectionDown == nil then
							vFourX.NextSelectionDown = inButton
						end
						vFourX.NextSelectionUp = inButton
					end
					if CurrFour ~= nil then
						inButton.NextSelectionUp = CurrFour
						CurrFour.NextSelectionDown = inButton
					end
					CurrThree.NextSelectionRight = inButton
					inButton.NextSelectionLeft = CurrThree
					inButton.NextSelectionRight = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons.Slot1
					inButton.NextSelectionDown = vFourX
					CurrFour = inButton
					
				end
				
				if v.Copies.Value > 1 then
					inButton.ColorLight.Copies.Text = "x" .. v.Copies.Value
					inButton.ColorLight.Copies.Dark.Text = "x" .. v.Copies.Value
				end
				
				local VMmodel = game.ReplicatedStorage.ViewportModels:FindFirstChild(v.Id.Value)
				if VMmodel then
					local VMC = VMmodel:Clone()
					VMC.Parent = inButton.ColorLight.VM
				end
				
				local Rarity = Util:GetRarity(v.Id.Value)
				if Rarity then
					inButton.ColorLight.RarityBar.Txt.Text = string.upper(Rarity)
					inButton.ColorLight.RarityBar.Txt.Dark.Text = string.upper(Rarity)
					local RarityColor = Util:GetRarityColor(Rarity)
					if RarityColor then
						inButton.ColorLight.RarityBar.ImageColor3 = RarityColor
					end
				end
				
				inButton.Visible = true
				inButton.Bind.DecorName.Value = v.Id.Value
				
				if ButCount == 4 then
					yOff = yOff + 1
					ButCount = 0
					LastHolder = GameUI.GuiTemplates.InvHolder:Clone()
					LastHolder.Parent = InventoryFrame.Decor.ScrollBack.Back.Scroller.xList
					LastHolder.Position = UDim2.new(0,0,yOff,0)
				end
				
				ButtonManager:ButtonConnect(inButton,mse)
				
			end
			
			for i,v in pairs(PlayerData.Equips.Decorations:GetChildren()) do
				local CorreSpond = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons:FindFirstChild(v.Name)
				if CorreSpond then
					CorreSpond.Bind.DecorName.Value = v.Value
					if OnlySlot ~= nil then
						if OnlySlot == string.gsub(v.Name,"Slot","") then
							UIBoxManager:BoxVM(CorreSpond.ColorLight.PrevBox,v.Value,VMCam)
						end
					else
						UIBoxManager:BoxVM(CorreSpond.ColorLight.PrevBox,v.Value,VMCam)
					end
				end
			end
			
			if yOff <= 2 then
				InventoryFrame.Decor.ScrollBack.Back.Scroller.CanvasSize = UDim2.new(0,0,0,0)
			else
				InventoryFrame.Decor.ScrollBack.Back.Scroller.CanvasSize = UDim2.new(0,0,1 + ((1/3)*(yOff-2)),0)
			end
			
			if HardPrev == nil then
				GameUI.Bindables.DecorPreview:Fire({ViewType = "None", DecorName = ""})
			else
				if HardPrev and DecPrev then
					--GameUI.Bindables.DecorPreview:Fire({ViewType = "Slot", DecorName = DecPrev, Slot = HardPrev})
					GameUI.Bindables.DecorPreview:Fire({ViewType = "None", DecorName = ""})
				end
			end
			
			if Util:HasPass("MoreSlots") then
				InventoryFrame.Decor.EquipBack.SlotsBack.Buttons.Slot1.ColorLight.Icon.Visible = false
				InventoryFrame.Decor.EquipBack.SlotsBack.Buttons.Slot4.ColorLight.Icon.Visible = false
			else
				InventoryFrame.Decor.EquipBack.SlotsBack.Buttons.Slot1.ColorLight.Icon.Visible = true
				InventoryFrame.Decor.EquipBack.SlotsBack.Buttons.Slot4.ColorLight.Icon.Visible = true
			end
			
			--Chair Loading
			
			LastHolder = GameUI.GuiTemplates.InvHolder:Clone()
			LastHolder.Parent = InventoryFrame.Chairs.ScrollBack.Back.Scroller.xList
			
			yOff = 0
			ButCount = 0
			
			vFirstX,vTwoX,vThreeX,vFourX = nil,nil,nil,nil
			CurrOne,CurrTwo,CurrThree,CurrFour = nil,nil,nil,nil
			
			GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Chairs.EquipBack.EquBack.ButtonClip.EqB.NextSelectionLeft = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Chairs.EquipBack.EquBack.ButtonClip.EqB
			GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Chairs.EquipBack.EquBack.ButtonClip.EqB.NextSelectionRight = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Chairs.EquipBack.EquBack.ButtonClip.EqB
			
			if GuiService.SelectedObject ~= nil and GameUI.ClientVars.InvSection.Value == "Chairs" then
				--GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Chairs.EquipBack.EquBack.ButtonClip.EqB
			end
			
			for i,v in pairs(PlayerData.Inventory.Chairs:GetChildren()) do
				ButCount = ButCount + 1

				local xPos = 0

				if ButCount == 2 then
					xPos = 1/3
				elseif ButCount == 3 then
					xPos = 2/3
				elseif ButCount == 4 then
					xPos = 1
				end
				
				if i == 1 and not NoChair then
					GameUI.Bindables.ChairPreview:Fire({DecorName = v.Id.Value})
				end

				local inButton = GameUI.GuiTemplates.InvB:Clone()
				inButton.Parent = LastHolder.Spacer
				inButton.Position = UDim2.new(xPos,0,.5,0)
				inButton.ColorLight.VM.CurrentCamera = VMCam
				inButton.Bind.Value = GameUI.Bindables.ChairPreview
				
				if ButCount == 1 then

					if vFirstX == nil then
						vFirstX = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Chairs.EquipBack.EquBack.ButtonClip.EqB.NextSelectionLeft = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Chairs.EquipBack.EquBack.ButtonClip.EqB.NextSelectionRight = inButton
						inButton.NextSelectionUp = inButton
					else
						if vFirstX.NextSelectionDown == nil then
							vFirstX.NextSelectionDown = inButton
						end
						vFirstX.NextSelectionUp = inButton
					end
					if CurrOne ~= nil then
						inButton.NextSelectionUp = CurrOne
						CurrOne.NextSelectionDown = inButton
					end
					inButton.NextSelectionLeft = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Chairs.EquipBack.EquBack.ButtonClip.EqB
					inButton.NextSelectionRight = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Chairs.EquipBack.EquBack.ButtonClip.EqB
					inButton.NextSelectionDown = vFirstX
					CurrOne = inButton

				elseif ButCount == 2 then

					if vTwoX == nil then
						vTwoX = inButton
						inButton.NextSelectionUp = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Chairs.EquipBack.EquBack.ButtonClip.EqB.NextSelectionLeft = inButton
					else
						if vTwoX.NextSelectionDown == nil then
							vTwoX.NextSelectionDown = inButton
						end
						vTwoX.NextSelectionUp = inButton
					end
					if CurrTwo ~= nil then
						inButton.NextSelectionUp = CurrTwo
						CurrTwo.NextSelectionDown = inButton
					end
					CurrOne.NextSelectionRight = inButton
					inButton.NextSelectionLeft = CurrOne
					inButton.NextSelectionRight = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Chairs.EquipBack.EquBack.ButtonClip.EqB
					inButton.NextSelectionDown = vTwoX
					CurrTwo = inButton

				elseif ButCount == 3 then

					if vThreeX == nil then
						vThreeX = inButton
						inButton.NextSelectionUp = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Chairs.EquipBack.EquBack.ButtonClip.EqB.NextSelectionLeft = inButton
					else
						if vThreeX.NextSelectionDown == nil then
							vThreeX.NextSelectionDown = inButton
						end
						vThreeX.NextSelectionUp = inButton
					end
					if CurrThree ~= nil then
						inButton.NextSelectionUp = CurrThree
						CurrThree.NextSelectionDown = inButton
					end
					CurrTwo.NextSelectionRight = inButton
					inButton.NextSelectionLeft = CurrTwo
					inButton.NextSelectionRight = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Chairs.EquipBack.EquBack.ButtonClip.EqB
					inButton.NextSelectionDown = vThreeX
					CurrThree = inButton

				elseif ButCount == 4 then

					if vFourX == nil then
						vFourX = inButton
						inButton.NextSelectionUp = inButton
						GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Chairs.EquipBack.EquBack.ButtonClip.EqB.NextSelectionLeft = inButton
					else
						if vFourX.NextSelectionDown == nil then
							vFourX.NextSelectionDown = inButton
						end
						vFourX.NextSelectionUp = inButton
					end
					if CurrFour ~= nil then
						inButton.NextSelectionUp = CurrFour
						CurrFour.NextSelectionDown = inButton
					end
					CurrThree.NextSelectionRight = inButton
					inButton.NextSelectionLeft = CurrThree
					inButton.NextSelectionRight = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Chairs.EquipBack.EquBack.ButtonClip.EqB
					inButton.NextSelectionDown = vFourX
					CurrFour = inButton

				end

				if v.Copies.Value > 1 then
					inButton.ColorLight.Copies.Text = "x" .. v.Copies.Value
					inButton.ColorLight.Copies.Dark.Text = "x" .. v.Copies.Value
				end

				local VMmodel = game.ReplicatedStorage.ViewportModels:FindFirstChild(v.Id.Value)
				if VMmodel then
					local VMC = VMmodel:Clone()
					VMC.Parent = inButton.ColorLight.VM
				end

				local Rarity = Util:GetRarity(v.Id.Value)
				if Rarity then
					inButton.ColorLight.RarityBar.Txt.Text = string.upper(Rarity)
					inButton.ColorLight.RarityBar.Txt.Dark.Text = string.upper(Rarity)
					local RarityColor = Util:GetRarityColor(Rarity)
					if RarityColor then
						inButton.ColorLight.RarityBar.ImageColor3 = RarityColor
					end
				end

				inButton.Visible = true
				inButton.Bind.DecorName.Value = v.Id.Value
				
				if PlayerData.Equips.Chair.Value == v.Id.Value then
					inButton.ColorLight.CheckBox.Check:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.5,true)
				end
				
				if ButCount == 4 then
					yOff = yOff + 1
					ButCount = 0
					LastHolder = GameUI.GuiTemplates.InvHolder:Clone()
					LastHolder.Parent = InventoryFrame.Chairs.ScrollBack.Back.Scroller.xList
					LastHolder.Position = UDim2.new(0,0,yOff,0)
				end

				ButtonManager:ButtonConnect(inButton,mse)

			end
			
			if yOff <= 2 then
				InventoryFrame.Chairs.ScrollBack.Back.Scroller.CanvasSize = UDim2.new(0,0,0,0)
			else
				InventoryFrame.Chairs.ScrollBack.Back.Scroller.CanvasSize = UDim2.new(0,0,1 + ((1/3)*(yOff-2)),0)
			end
			
			--Particle Loading
			
			vFirstX,vTwoX,vThreeX,vFourX = nil,nil,nil,nil
			CurrOne,CurrTwo,CurrThree,CurrFour = nil,nil,nil,nil
			
			LastHolder = GameUI.GuiTemplates.InvHolder:Clone()
			LastHolder.Parent = InventoryFrame.Particles.ScrollBack.Back.Scroller.xList

			yOff = 0
			ButCount = 0
			
			local Parti = PlayerData.Inventory.Particles:GetChildren()
			
			if GuiService.SelectedObject ~= nil and GameUI.ClientVars.InvSection.Value == "Particles" then
				if #Parti <= 0 then
					--GuiService.SelectedObject = GameUI.MenuBack.BackFrame.BackF.BackB
				end
			end
			
			GameUI.Bindables.ParticlePreview:Fire({DecorName = ""})
			
			for i,v in pairs(Parti) do
				ButCount = ButCount + 1

				local xPos = 0

				if ButCount == 2 then
					xPos = 1/3
				elseif ButCount == 3 then
					xPos = 2/3
				elseif ButCount == 4 then
					xPos = 1
				end

				if i == 1 and ParticlePrev == nil then
					GameUI.Bindables.ParticlePreview:Fire({DecorName = v.Id.Value})
				elseif i == 1 and ParticlePrev then
					GameUI.Bindables.ParticlePreview:Fire({DecorName = ParticlePrev})
				end

				local inButton = GameUI.GuiTemplates.InvB:Clone()
				inButton.Parent = LastHolder.Spacer
				inButton.Position = UDim2.new(xPos,0,.5,0)
				inButton.ColorLight.VM.CurrentCamera = VMCam
				inButton.Bind.Value = GameUI.Bindables.ParticlePreview
				
				local SelectedEqB = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.EquBack.ButtonClip.EqB
				local SelectedEqB2 = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.EquBack.ButtonClip.UnEqB
				
				if Util:GetEquippedParticle(GameUI.Parent.Parent.Parent.Name) == GameUI.ClientVars.ParticleViewer.Id.Value then
					SelectedEqB = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.EquBack.ButtonClip.UnEqB
					SelectedEqB2 = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.EquBack.ButtonClip.EqB
				end
				
				if i == 1 and GuiService.SelectedObject ~= nil  and GameUI.ClientVars.InvSection.Value == "Particles" then
					--GuiService.SelectedObject = inButton
				end
				
				if ButCount == 1 then

					if vFirstX == nil then
						vFirstX = inButton
						SelectedEqB.NextSelectionRight = inButton
						SelectedEqB.NextSelectionLeft = inButton
						SelectedEqB2.NextSelectionRight = inButton
						SelectedEqB2.NextSelectionLeft = inButton
						inButton.NextSelectionUp = inButton
					else
						if vFirstX.NextSelectionDown == nil then
							vFirstX.NextSelectionDown = inButton
						end
						vFirstX.NextSelectionUp = inButton
					end
					if CurrOne ~= nil then
						inButton.NextSelectionUp = CurrOne
						CurrOne.NextSelectionDown = inButton
					end
					inButton.NextSelectionLeft = SelectedEqB
					inButton.NextSelectionRight = SelectedEqB
					inButton.NextSelectionDown = vFirstX
					CurrOne = inButton

				elseif ButCount == 2 then

					if vTwoX == nil then
						vTwoX = inButton
						inButton.NextSelectionUp = inButton
						SelectedEqB.NextSelectionLeft = inButton
						SelectedEqB2.NextSelectionLeft = inButton
					else
						if vTwoX.NextSelectionDown == nil then
							vTwoX.NextSelectionDown = inButton
						end
						vTwoX.NextSelectionUp = inButton
					end
					if CurrTwo ~= nil then
						inButton.NextSelectionUp = CurrTwo
						CurrTwo.NextSelectionDown = inButton
					end
					CurrOne.NextSelectionRight = inButton
					inButton.NextSelectionLeft = CurrOne
					inButton.NextSelectionRight = SelectedEqB
					inButton.NextSelectionDown = vTwoX
					CurrTwo = inButton

				elseif ButCount == 3 then

					if vThreeX == nil then
						vThreeX = inButton
						inButton.NextSelectionUp = inButton
						SelectedEqB.NextSelectionLeft = inButton
						SelectedEqB2.NextSelectionLeft = inButton
					else
						if vThreeX.NextSelectionDown == nil then
							vThreeX.NextSelectionDown = inButton
						end
						vThreeX.NextSelectionUp = inButton
					end
					if CurrThree ~= nil then
						inButton.NextSelectionUp = CurrThree
						CurrThree.NextSelectionDown = inButton
					end
					CurrTwo.NextSelectionRight = inButton
					inButton.NextSelectionLeft = CurrTwo
					inButton.NextSelectionRight = SelectedEqB
					inButton.NextSelectionDown = vThreeX
					CurrThree = inButton

				elseif ButCount == 4 then

					if vFourX == nil then
						vFourX = inButton
						inButton.NextSelectionUp = inButton
						SelectedEqB.NextSelectionLeft = inButton
						SelectedEqB2.NextSelectionLeft = inButton
					else
						if vFourX.NextSelectionDown == nil then
							vFourX.NextSelectionDown = inButton
						end
						vFourX.NextSelectionUp = inButton
					end
					if CurrFour ~= nil then
						inButton.NextSelectionUp = CurrFour
						CurrFour.NextSelectionDown = inButton
					end
					CurrThree.NextSelectionRight = inButton
					inButton.NextSelectionLeft = CurrThree
					inButton.NextSelectionRight = SelectedEqB
					inButton.NextSelectionDown = vFourX
					CurrFour = inButton

				end
				
				if v.Copies.Value > 1 then
					inButton.ColorLight.Copies.Text = "x" .. v.Copies.Value
					inButton.ColorLight.Copies.Dark.Text = "x" .. v.Copies.Value
				end

				inButton.ColorLight.VM.Visible = false
				inButton.ColorLight.Img.Visible = true
				
				local PartFind = game.ReplicatedStorage.Cosmetics.Particles:FindFirstChild(v.Id.Value)
				if PartFind then
					inButton.ColorLight.Img.Image = PartFind.Texture
				end

				local Rarity = Util:GetRarity(v.Id.Value)
				if Rarity then
					inButton.ColorLight.RarityBar.Txt.Text = string.upper(Rarity)
					inButton.ColorLight.RarityBar.Txt.Dark.Text = string.upper(Rarity)
					local RarityColor = Util:GetRarityColor(Rarity)
					if RarityColor then
						inButton.ColorLight.RarityBar.ImageColor3 = RarityColor
					end
				end

				inButton.Visible = true
				inButton.Bind.DecorName.Value = v.Id.Value

				if PlayerData.Equips.Particle.Value == v.Id.Value then
					inButton.ColorLight.CheckBox.Check:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.5,true)
				end

				if ButCount == 4 then
					yOff = yOff + 1
					ButCount = 0
					LastHolder = GameUI.GuiTemplates.InvHolder:Clone()
					LastHolder.Parent = InventoryFrame.Particles.ScrollBack.Back.Scroller.xList
					LastHolder.Position = UDim2.new(0,0,yOff,0)
				end

				ButtonManager:ButtonConnect(inButton,mse)

			end

			if yOff <= 2 then
				InventoryFrame.Particles.ScrollBack.Back.Scroller.CanvasSize = UDim2.new(0,0,0,0)
			else
				InventoryFrame.Particles.ScrollBack.Back.Scroller.CanvasSize = UDim2.new(0,0,1 + ((1/3)*(yOff-2)),0)
			end
			
		end
		
	end)
	
	Binds.DecorPreview.Event:Connect(function(args)
		
		GameUI.Bindables.SlotSelectionOpener:Fire({Action = "Close"})
		
		local DecorName = args["DecorName"]
		local ViewType = args["ViewType"]
		
		local SlotVar = args["Slot"]
		if SlotVar then

			if SlotVar == 1 or SlotVar == 4 then
				if Util:HasPass("MoreSlots") == false then
					MarketplaceService:PromptGamePassPurchase(GameUI.Parent.Parent.Parent,49325708)
					return
				end
			end

		end
		
		if DecorName and ViewType then
			
			if ViewType == "None" or DecorName == "None" then
				
				UIBoxManager:BoxText(GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.TtlBox,"")
				UIBoxManager:BoxVM(GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.PreviewBack.PrevBox,"",VMCam)
				
				GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.EqB:TweenPosition(UDim2.new(0,0,-1,0),"Out","Quad",.3,true)
				GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.UnEqB:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.3,true)
				
				for i,v in pairs(GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons:GetChildren()) do
					v.NextSelectionDown = nil
					v.NextSelectionUp = nil
					v.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
					v.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
				end
				
			else
				
				if GameUI.ClientVars.DecorViewer.Id.Value ~= DecorName then
					UIBoxManager:BoxText(GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.TtlBox,string.upper(DecorName))
					UIBoxManager:BoxVM(GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.PreviewBack.PrevBox,DecorName,VMCam)
				end
				
				if ViewType == "Slot" then
					
					local SlotVar = args["Slot"]
					if SlotVar then
						
						if SlotVar == 1 or SlotVar == 4 then
							if Util:HasPass("MoreSlots") == false then
								MarketplaceService:PromptGamePassPurchase(GameUI.Parent.Parent.Parent,49325708)
								return
							end
						end
						
						GameUI.ClientVars.DecorViewer.Slot.Value = SlotVar
					end
					
					GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.EqB:TweenPosition(UDim2.new(0,0,-1,0),"Out","Quad",.3,true)
					GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.UnEqB:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
					
					for i,v in pairs(GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons:GetChildren()) do
						v.NextSelectionDown = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.UnEqB
						v.NextSelectionUp = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.UnEqB
						v.SelectionBehaviorDown = Enum.SelectionBehavior.Escape
						v.SelectionBehaviorUp = Enum.SelectionBehavior.Escape
					end
					
				elseif ViewType == "Inventory" then
					
					GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.EqB:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
					GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.UnEqB:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.3,true)
					
					for i,v in pairs(GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons:GetChildren()) do
						v.NextSelectionDown = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.EqB
						v.NextSelectionUp = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.EquBack.ButtonClip.EqB
						v.SelectionBehaviorDown = Enum.SelectionBehavior.Escape
						v.SelectionBehaviorUp = Enum.SelectionBehavior.Escape
					end
					
				end
				
			end
			
			GameUI.ClientVars.DecorViewer.Id.Value = DecorName
			GameUI.ClientVars.DecorViewer.Type.Value = ViewType
			
		end
		
	end)
	
	Binds.EquipDecor.Event:Connect(function(args)
		
		local DecorName = GameUI.ClientVars.DecorViewer.Id.Value
		local SlotNum = args["Slot"]
		
		if SlotNum then
			
			if SlotNum == 1 or SlotNum == 4 then
				if Util:HasPass("MoreSlots") == false then
					MarketplaceService:PromptGamePassPurchase(GameUI.Parent.Parent.Parent,49325708)
					return
				end
			end
			
			local Result = game.ReplicatedStorage.Remotes.EquipDecor:InvokeServer(DecorName,SlotNum)
			
			if Result == "Good" then
				GameUI.Sounds.Equip:Play()
				GameUI.Bindables.SlotSelectionOpener:Fire({Action = "Close"})
				Binds.RefreshInventory:Fire({OnlySlot = tostring(SlotNum),HardPrevSlot = SlotNum,PrevDec = DecorName})
			end
		end
		
	end)
	
	Binds.UnEquipDecor.Event:Connect(function(args)
		
		local SlotNum = GameUI.ClientVars.DecorViewer.Slot.Value
		
		if SlotNum == 1 or SlotNum == 4 then
			if Util:HasPass("MoreSlots") == false then
				MarketplaceService:PromptGamePassPurchase(GameUI.Parent.Parent.Parent,49325708)
				return
			end
		end
		
		local Result = game.ReplicatedStorage.Remotes.UnEquipDecor:InvokeServer(SlotNum)
		
		if Result == "Good" then
			GameUI.Sounds.UnEquip:Play()
			Binds.RefreshInventory:Fire({OnlySlot = tostring(SlotNum)})
		end
		
	end)
	
	Binds.SlotSelectionOpener.Event:Connect(function(args)
		
		local Action = args["Action"]
		if Action then
			
			if Util:HasPass("MoreSlots") then
				GameUI.SlotSelection.Buttons.Slot1.ColorLight.Icon1.Visible = false
				GameUI.SlotSelection.Buttons.Slot1.ColorLight.Icon2.Visible = false
				GameUI.SlotSelection.Buttons.Slot4.ColorLight.Icon1.Visible = false
				GameUI.SlotSelection.Buttons.Slot4.ColorLight.Icon2.Visible = false
			else
				GameUI.SlotSelection.Buttons.Slot1.ColorLight.Icon1.Visible = true
				GameUI.SlotSelection.Buttons.Slot1.ColorLight.Icon2.Visible = true
				GameUI.SlotSelection.Buttons.Slot4.ColorLight.Icon1.Visible = true
				GameUI.SlotSelection.Buttons.Slot4.ColorLight.Icon2.Visible = true
			end
			
			if Action == "Open" then
				wait()
				
				if GameUI.ClientVars.IsMobile.Value == false then
					GameUI.SlotSelection:TweenSize(UDim2.new(.3,0,.3,0),"Out","Quad",.3,true)
				else
					GameUI.SlotSelection:TweenSize(UDim2.new(.6,0,.6,0),"Out","Quad",.3,true)
				end
				
				GameUI.Sounds.OpenSound:Play()
				GameUI.ClientVars.SlotOpen.Value = true
				
				if GuiService.SelectedObject ~= nil then
					--GuiService.SelectedObject = GameUI.SlotSelection.Buttons.Slot2
				end
				
			else
				if GameUI.ClientVars.SlotOpen.Value then
					GameUI.ClientVars.SlotOpen.Value = false
					GameUI.SlotSelection:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
					GameUI.Sounds.CloseSound:Play()
				end
				
				if GuiService.SelectedObject ~= nil then
					--GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Decor.EquipBack.SlotsBack.Buttons.Slot2
				end
				
			end
			
		end
		
	end)
	
	Binds.InvBHov.Event:Connect(function(args)
		
		local Button = args["Button"]
		if Button ~= nil then
			
			Button.ColorLight.RarityBar:TweenPosition(UDim2.new(.5,0,-.17,0),"Out","Quad",.2,true)
			Button.ColorLight.RarityBar.Txt:TweenPosition(UDim2.new(.5,0,.88,0),"Out","Quad",.2,true)
			
		end
		
	end)
	
	Binds.InvBuHov.Event:Connect(function(args)
		
		local Button = args["Button"]
		if Button ~= nil then
			
			Button.ColorLight.RarityBar:TweenPosition(UDim2.new(.5,0,-.3,0),"Out","Quad",.2,true)
			Button.ColorLight.RarityBar.Txt:TweenPosition(UDim2.new(.5,0,.7,0),"Out","Quad",.2,true)
			
		end
		
	end)
	
	Binds.EquipChair.Event:Connect(function(args)
		
		local DecorName = GameUI.ClientVars.ChairViewer.Id.Value
	
		local Result = game.ReplicatedStorage.Remotes.EquipChair:InvokeServer(DecorName)

		if Result == "Good" then
			GameUI.Sounds.Equip:Play()
			Binds.RefreshInventory:Fire({NoChair = true})
			
			if GuiService.SelectedObject ~= nil and GameUI.ClientVars.InvSection.Value == "Chairs" then
				--GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Chairs.EquipBack.EquBack.ButtonClip.EqB
			end
		end
		
	end)
	
	Binds.UnEquipChair.Event:Connect(function(args)
		
	end)
	
	Binds.EquipParticle.Event:Connect(function(args)
		
		local DecorName = GameUI.ClientVars.ParticleViewer.Id.Value

		local Result = game.ReplicatedStorage.Remotes.EquipParticle:InvokeServer(DecorName)

		if Result == "Good" then
			GameUI.Sounds.Equip:Play()
			Binds.RefreshInventory:Fire({ParticlePrev = DecorName})
			
			for i,v in pairs(GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.ScrollBack.Back.Scroller.xList:GetChildren()) do
				for a,b in pairs(v.Spacer:GetChildren()) do
					if b.NextSelectionLeft and b.NextSelectionLeft.Name == "EqB" then
						b.NextSelectionLeft = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.EquBack.ButtonClip.UnEqB
					end
					if b.NextSelectionRight and b.NextSelectionRight.Name == "EqB" then
						b.NextSelectionRight = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.EquBack.ButtonClip.UnEqB
					end
				end
			end
			
		end
		
	end)
	
	Binds.UnEquipParticle.Event:Connect(function(args)
		
		local Result = game.ReplicatedStorage.Remotes.UnEquipParticle:InvokeServer()

		if Result == "Good" then
			GameUI.Sounds.UnEquip:Play()
			Binds.RefreshInventory:Fire({ParticlePrev = GameUI.ClientVars.ParticleViewer.Id.Value})
			
			for i,v in pairs(GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.ScrollBack.Back.Scroller.xList:GetChildren()) do
				for a,b in pairs(v.Spacer:GetChildren()) do
					if b.NextSelectionLeft and b.NextSelectionLeft.Name == "UnEqB" then
						b.NextSelectionLeft = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.EquBack.ButtonClip.EqB
					end
					if b.NextSelectionRight and b.NextSelectionRight.Name == "UnEqB" then
						b.NextSelectionRight = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.EquBack.ButtonClip.EqB
					end
				end
			end
			
		end
		
	end)
	
	Binds.ChairPreview.Event:Connect(function(args)
		
		local DecorName = args["DecorName"]
		
		if DecorName then

			if GameUI.ClientVars.ChairViewer.Id.Value ~= DecorName then
				UIBoxManager:BoxText(GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Chairs.EquipBack.TtlBox,string.upper(DecorName))
				UIBoxManager:BoxVM(GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Chairs.EquipBack.PreviewBack.PrevBox,DecorName,VMCam)
			end
			
			GameUI.ClientVars.ChairViewer.Id.Value = DecorName

		end
		
	end)
	
	Binds.ParticlePreview.Event:Connect(function(args)
		
		local DecorName = args["DecorName"]

		if DecorName then
			
			local PartFind = game.ReplicatedStorage.Cosmetics.Particles:FindFirstChild(DecorName)
			
			if GameUI.ClientVars.ParticleViewer.Id.Value ~= DecorName and PartFind then
				UIBoxManager:BoxText(GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.TtlBox,string.upper(DecorName))
				UIBoxManager:BoxImage(GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.PreviewBack.PrevBox,PartFind.Texture,VMCam)
			end
			
			local EquippedParticle = Util:GetEquippedParticle()
			
			if EquippedParticle == DecorName then
				GameUI.ClientVars.ParticleViewer.Type.Value = "Eq"
				GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.EquBack.ButtonClip.EqB:TweenPosition(UDim2.new(0,0,-1,0),"Out","Quad",.3,true)
				GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.EquBack.ButtonClip.UnEqB:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
				
				for i,v in pairs(GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.ScrollBack.Back.Scroller.xList:GetChildren()) do
					for a,b in pairs(v.Spacer:GetChildren()) do
						if b.NextSelectionLeft and b.NextSelectionLeft.Name == "EqB" then
							b.NextSelectionLeft = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.EquBack.ButtonClip.UnEqB
						end
						if b.NextSelectionRight and b.NextSelectionRight.Name == "EqB" then
							b.NextSelectionRight = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.EquBack.ButtonClip.UnEqB
						end
					end
				end
				
			else
				GameUI.ClientVars.ParticleViewer.Type.Value = "UnEq"
				GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.EquBack.ButtonClip.EqB:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
				GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.EquBack.ButtonClip.UnEqB:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.3,true)
				
				for i,v in pairs(GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.ScrollBack.Back.Scroller.xList:GetChildren()) do
					for a,b in pairs(v.Spacer:GetChildren()) do
						if b.NextSelectionLeft and b.NextSelectionLeft.Name == "UnEqB" then
							b.NextSelectionLeft = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.EquBack.ButtonClip.EqB
						end
						if b.NextSelectionRight and b.NextSelectionRight.Name == "UnEqB" then
							b.NextSelectionRight = GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.EquBack.ButtonClip.EqB
						end
					end
				end
			end
			
			if DecorName == "" then
				GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.EquBack.ButtonClip.EqB:TweenPosition(UDim2.new(0,0,-1,0),"Out","Quad",.3,true)
				GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.EquBack.ButtonClip.UnEqB:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.3,true)
				UIBoxManager:BoxText(GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.TtlBox,"")
				UIBoxManager:BoxImage(GameUI.MenuBack.List.Lister.List.Inventory.InvSections.List.Particles.EquipBack.PreviewBack.PrevBox,"",VMCam)
			end

			GameUI.ClientVars.ParticleViewer.Id.Value = DecorName

		end
		
	end)
	
	Binds.LoadDecks.Event:Connect(function(args)
		
		local DeckOverride = args["DeckPrev"]
		
		local AlreadyLoaded = args["Moved"]
		
		GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.ScrollBack.Back.Scroller.xList:ClearAllChildren()
		
		local yOff = 0
		local ButtonCount = 0
		
		local LastHolder = GameUI.GuiTemplates.DeckHolder:Clone()
		LastHolder.Parent = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.ScrollBack.Back.Scroller.xList
		
		if AlreadyLoaded == nil then
			GameUI.Bindables.DBSection:Fire({Section = "List",Loaded = true})
		end
		
		local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(GameUI.Parent.Parent.Parent.Name)
		if Data then
			
			local Deckz = Data.Inventory.Decks:GetChildren()
			
			local vFirstX,vTwoX,vThreeX,vFourX = nil,nil,nil,nil
			local CurrOne,CurrTwo,CurrThree,CurrFour = nil,nil,nil,nil
			
			for i,v in pairs(Deckz) do
				
				ButtonCount += 1
				
				local xPos = 0
				
				if ButtonCount == 2 then
					xPos = .33333
				elseif ButtonCount == 3 then
					xPos = .66666
				elseif ButtonCount == 4 then
					xPos = 1
				end
				
				local DeckB = GameUI.GuiTemplates.DeckB:Clone()
				DeckB.Visible = true
				
				DeckB.ColorLight.Ttl.Text = v.Name
				DeckB.ColorLight.Ttl.TxtDark.Text = v.Name
				
				local CardCount = #v:GetChildren()
				
				DeckB.ColorLight.Count.Text = "x" .. CardCount
				DeckB.ColorLight.Count.TxtDark.Text = "x" .. CardCount
				
				DeckB.Bind.Value = GameUI.Bindables.PreviewDeck
				DeckB.Bind.Deck.Value = v.Name
				
				DeckB.Position = UDim2.new(xPos,0,.5,0)
				DeckB.Parent = LastHolder.Spacer
				
				ButtonManager:ButtonConnect(DeckB,mse)
				
				if ButtonCount == 1 then

					if vFirstX == nil then
						vFirstX = DeckB
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.EditB.NextSelectionLeft = DeckB
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.EditB.NextSelectionRight = DeckB
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.RenameB.NextSelectionLeft = DeckB
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.RenameB.NextSelectionRight = DeckB
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.DeleteB.NextSelectionLeft = DeckB
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.DeleteB.NextSelectionRight = DeckB
						DeckB.NextSelectionUp = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.CreateB
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.CreateB.NextSelectionDown = DeckB
					else
						if vFirstX.NextSelectionDown == nil then
							vFirstX.NextSelectionDown = DeckB
						end
					end
					if CurrOne ~= nil then
						DeckB.NextSelectionUp = CurrOne
						CurrOne.NextSelectionDown = DeckB
					end
					DeckB.NextSelectionLeft = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.EditB
					DeckB.NextSelectionRight = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.EditB
					DeckB.NextSelectionDown = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.CreateB
					CurrOne = DeckB

					GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.CreateB.NextSelectionUp = DeckB

				elseif ButtonCount == 2 then

					if vTwoX == nil then
						vTwoX = DeckB
						DeckB.NextSelectionUp = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.CreateB
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.EditB.NextSelectionLeft = DeckB
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.RenameB.NextSelectionLeft = DeckB
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.DeleteB.NextSelectionLeft = DeckB
					else
						if vTwoX.NextSelectionDown == nil then
							vTwoX.NextSelectionDown = DeckB
						end
					end
					if CurrTwo ~= nil then
						DeckB.NextSelectionUp = CurrTwo
						CurrTwo.NextSelectionDown = DeckB
					end
					CurrOne.NextSelectionRight = DeckB
					DeckB.NextSelectionLeft = CurrOne
					DeckB.NextSelectionRight = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.EditB
					DeckB.NextSelectionDown = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.CreateB
					CurrTwo = DeckB

				elseif ButtonCount == 3 then

					if vThreeX == nil then
						vThreeX = DeckB
						DeckB.NextSelectionUp = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.CreateB
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.EditB.NextSelectionLeft = DeckB
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.RenameB.NextSelectionLeft = DeckB
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.DeleteB.NextSelectionLeft = DeckB
					else
						if vThreeX.NextSelectionDown == nil then
							vThreeX.NextSelectionDown = DeckB
						end
					end
					if CurrThree ~= nil then
						DeckB.NextSelectionUp = CurrThree
						CurrThree.NextSelectionDown = DeckB
					end
					CurrTwo.NextSelectionRight = DeckB
					DeckB.NextSelectionLeft = CurrTwo
					DeckB.NextSelectionRight = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.EditB
					DeckB.NextSelectionDown = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.CreateB
					CurrThree = DeckB

				elseif ButtonCount == 4 then

					if vFourX == nil then
						vFourX = DeckB
						DeckB.NextSelectionUp = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.CreateB
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.EditB.NextSelectionLeft = DeckB
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.RenameB.NextSelectionLeft = DeckB
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.DeleteB.NextSelectionLeft = DeckB
					else
						if vFourX.NextSelectionDown == nil then
							vFourX.NextSelectionDown = DeckB
						end
					end
					if CurrFour ~= nil then
						DeckB.NextSelectionUp = CurrFour
						CurrFour.NextSelectionDown = DeckB
					end
					CurrThree.NextSelectionRight = DeckB
					DeckB.NextSelectionLeft = CurrThree
					DeckB.NextSelectionRight = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.EditB
					DeckB.NextSelectionDown = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.CreateB
					CurrFour = DeckB

				end
				
				if ButtonCount == 4 then
					ButtonCount = 0
					yOff += 1
					LastHolder = GameUI.GuiTemplates.DeckHolder:Clone()
					LastHolder.Position = UDim2.new(0,0,yOff,0)
					LastHolder.Parent = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.ScrollBack.Back.Scroller.xList
				end
				
				if i == 1 and DeckOverride == nil then
					GameUI.Bindables.PreviewDeck:Fire({Deck = v.Name})
				elseif DeckOverride and v.Name == DeckOverride then
					GameUI.Bindables.PreviewDeck:Fire({Deck = DeckOverride})
				end
				
			end
			
			if yOff <= 2 then
				GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.ScrollBack.Back.Scroller.CanvasSize = UDim2.new(0,0,0,0)
			else
				GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.ScrollBack.Back.Scroller.CanvasSize = UDim2.new(0,0,1 + ((1/3)*(yOff-2)),0)
			end
			
			if #Deckz == 0 then
				UIBoxManager:BoxText(GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.TtlBox,"-- --")
				UIBoxManager:BoxText(GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.CountBox,"N/A")
			end
			
			UIBoxManager:BoxText(GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.SlotsBack.InfoBox,#Deckz)
			
			GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.SlotsBack.Max.Text = "5"
			
			if Util:HasPass("MoreDecks") then
				GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.SlotsBack.Max.Text = "20"
			end
			
		end
		
	end)
	
	Binds.PreviewDeck.Event:Connect(function(args)
		
		local Deck = args["Deck"]
		if Deck then
			
			local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(GameUI.Parent.Parent.Parent.Name)
			if Data then
				local DeckFind = Data.Inventory.Decks:FindFirstChild(Deck)
				if DeckFind then
					
					local CardCount = #DeckFind:GetChildren()
					
					if GameUI.ClientVars.BuildSettings.SelectedDeck.Value ~= Deck then
						UIBoxManager:BoxText(GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.TtlBox,string.upper(Deck))
						UIBoxManager:BoxText(GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.PreviewBack.Back.CountBox,"x" .. CardCount)
					end
					
					GameUI.ClientVars.BuildSettings.SelectedDeck.Value = Deck
					
					for i,v in pairs(GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.ScrollBack.Back.Scroller.xList:GetChildren()) do
						for a,b in pairs(v.Spacer:GetChildren()) do
							if b.Bind.Deck.Value == Deck then
								b.ColorLight.CheckBox.Check:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
							else
								b.ColorLight.CheckBox.Check:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.3,true)
							end
						end
					end
					
				end
			end
			
		end
		
	end)
	
	Binds.DBSection.Event:Connect(function(args)
		
		local Section = args["Section"]
		local Loaded = args["Loaded"]
		
		if Section then
			
			if GameUI.ClientVars.BuildSettings.BuildMode.Value ~= Section then
				--
			end
			
			GameUI.ClientVars.BuildSettings.BuildMode.Value = Section
			if Section == "Edit" then
				
				local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(GameUI.Parent.Parent.Parent.Name)
				if Data then
					local Decks = Data.Inventory.Decks:FindFirstChild(GameUI.ClientVars.BuildSettings.SelectedDeck.Value)
					if Decks then
						GameUI.Sounds.TransitionSound:Play()
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List:TweenPosition(UDim2.new(0,0,-1,0),"Out","Quad",.3,true)
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
					end
				end
				
				if GuiService.SelectedObject ~= nil then
					--GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.SelBack.Back.Scroller.xList.ClearH.Button
				end
				
			else
				
				if Loaded == nil then
					GameUI.Bindables.LoadDecks:Fire({Moved = true})
				end
				
				GameUI.Sounds.TransitionSound:Play()
				
				GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
				GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.3,true)
				
				if GuiService.SelectedObject ~= nil then
					--GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.CreateB
				end
			end
		end
		
	end)
	
	Binds.DeleteDeck.Event:Connect(function(args)
		
		GameUI.Bindables.DeleteOpener:Fire({Action = "Close"})
		
		local Res = game.ReplicatedStorage.Remotes.DeleteDeck:InvokeServer(GameUI.ClientVars.BuildSettings.SelectedDeck.Value)
		
		if Res == "Good" then
			GameUI.Bindables.LoadDecks:Fire({})
			
			if GuiService.SelectedObject ~= nil then
				--GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.CreateB
			end
		end
		
	end)
	
	Binds.CreateDeck.Event:Connect(function(args)
		
		GameUI.Bindables.RenameOpener:Fire({Action = "Close"})
		GameUI.Bindables.DeleteOpener:Fire({Action = "Close"})
		
		local Result,NewDeckName = game.ReplicatedStorage.Remotes.CreateDeck:InvokeServer()
		
		if Result == "Good" then
			GameUI.Bindables.LoadDecks:Fire({DeckPrev = NewDeckName})
		end
		
	end)
	
	Binds.EditDeck.Event:Connect(function(args)
		
		GameUI.Bindables.RenameOpener:Fire({Action = "Close"})
		GameUI.Bindables.DeleteOpener:Fire({Action = "Close"})
		
		GameUI.Bindables.DBSection:Fire({Section = "Edit"})
		
		GameUI.Bindables.LoadEditCards:Fire({Deck = GameUI.ClientVars.BuildSettings.SelectedDeck.Value})
		
		for i,v in pairs(GameUI.ClientVars.BuildSettings.CardToggles:GetChildren()) do
			GameUI.Bindables.EditCardToggle:Fire({CardName = v.Name, Toggle = false})
			GameUI.Bindables.EditCardSetting:Fire({CardName = v.Name, Setting = "Amount", Val = 1})
			
			if v.Name == "Draw" or v.Name == "Targeted Draw" then
				GameUI.Bindables.EditCardSetting:Fire({CardName = v.Name, Setting = "To", Val = 2})
				GameUI.Bindables.EditCardSetting:Fire({CardName = v.Name, Setting = "From", Val = 2})
			elseif v.Name == "Wild Draw" then
				GameUI.Bindables.EditCardSetting:Fire({CardName = v.Name, Setting = "To", Val = 4})
				GameUI.Bindables.EditCardSetting:Fire({CardName = v.Name, Setting = "From", Val = 4})
			elseif v.Name == "Number" then
				GameUI.Bindables.EditCardSetting:Fire({CardName = v.Name, Setting = "To", Val = 0})
				GameUI.Bindables.EditCardSetting:Fire({CardName = v.Name, Setting = "From", Val = 0})
			end
		end
		
		for i,v in pairs(GameUI.ClientVars.BuildSettings.ColorSelects:GetChildren()) do
			GameUI.Bindables.SelectEditColor:Fire({Col = v.Value, Toggle = false})
		end
		
	end)
	
	Binds.RenameOpener.Event:Connect(function(args)
		
		local Action = args["Action"]
		if Action then
			if Action == "Close" then
				if GameUI.ClientVars.RenameOpen.Value then
					GameUI.Sounds.CloseSound:Play()
				end
				GameUI.RenamePrompt:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
				GameUI.ClientVars.RenameOpen.Value = false
				
				if GuiService.SelectedObject ~= nil then
					--GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.CreateB
				end
				
			else
				GameUI.Bindables.DeleteOpener:Fire({Action = "Close"})
				GameUI.ClientVars.RenameOpen.Value = true
				GameUI.Sounds.OpenSound:Play()
				
				if GameUI.ClientVars.IsMobile.Value == false then
					GameUI.RenamePrompt:TweenSize(UDim2.new(.4,0,.2,0),"Out","Quad",.3,true)
				else
					GameUI.RenamePrompt:TweenSize(UDim2.new(.4*1.75,0,.2*1.75,0),"Out","Quad",.3,true)
				end
				
				if GuiService.SelectedObject ~= nil then
					--GuiService.SelectedObject = GameUI.RenamePrompt.Back.CodeBack.Input
				end
				
			end
		end
		
	end)
	
	Binds.DeleteOpener.Event:Connect(function(args)
		
		local Action = args["Action"]
		if Action then
			if Action == "Close" then
				if GameUI.ClientVars.DeleteOpen.Value then
					GameUI.Sounds.CloseSound:Play()
				end
				GameUI.DeletePrompt:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
				GameUI.ClientVars.DeleteOpen.Value = false
				
				if GuiService.SelectedObject ~= nil then
					--GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.CreateB
				end
				
			else
				GameUI.Bindables.RenameOpener:Fire({Action = "Close"})
				GameUI.ClientVars.DeleteOpen.Value = true
				GameUI.Sounds.OpenSound:Play()
				
				if GameUI.ClientVars.IsMobile.Value == false then
					GameUI.DeletePrompt:TweenSize(UDim2.new(.4,0,.2,0),"Out","Quad",.3,true)
				else
					GameUI.DeletePrompt:TweenSize(UDim2.new(.4*1.75,0,.2*1.75,0),"Out","Quad",.3,true)
				end
				
				if GuiService.SelectedObject ~= nil then
					--GuiService.SelectedObject = GameUI.DeletePrompt.Back.CancelB
				end
			end
		end
		
	end)
	
	Binds.RenameDeck.Event:Connect(function(args)
		
		local NewName = GameUI.RenamePrompt.Back.CodeBack.Input.Text
		
		local Res,ReturnedName = game.ReplicatedStorage.Remotes.RenameDeck:InvokeServer(GameUI.ClientVars.BuildSettings.SelectedDeck.Value,NewName)
		
		if Res == "Good" then
			
			GameUI.Bindables.RenameOpener:Fire({Action = "Close"})
			GameUI.Bindables.LoadDecks:Fire({DeckPrev = ReturnedName})
			
			if GuiService.SelectedObject ~= nil then
				--GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.List.CreateB
			end
			
		elseif Res == "Filtered" then
			GameUI.Sounds.Warn:Play()
			GameUI.RenamePrompt.Back.Ttl.Text = "DECK NAME CENSORED"
			wait(2)
			GameUI.RenamePrompt.Back.Ttl.Text = "ENTER NEW NAME"
		end
		
	end)
	
	Binds.LoadEditCards.Event:Connect(function(args)
		
		local DeckName = args["Deck"]
		if DeckName then
			
			local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(GameUI.Parent.Parent.Parent.Name)
			if Data then
				local Deck = Data.Inventory.Decks:FindFirstChild(DeckName)
				if Deck then
					
					local Cards = Deck:GetChildren()
					
					UIBoxManager:BoxText(GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.CountBox,#Cards)
					
					GameUI.ClientVars.BuildSettings.ColorList:ClearAllChildren()
					
					--Load In The Colors
					for i,v in pairs(Cards) do
						
						local ColorFinded = false
						
						if v.Color.Value ~= Color3.new(0,0,0) then
							for a,b in pairs(GameUI.ClientVars.BuildSettings.ColorList:GetChildren()) do
								if b.Value == v.Color.Value or v.Color.Value == Color3.new(0,0,0) then
									ColorFinded = true
									break
								end
							end
						else
							ColorFinded = true
						end
						
						if not ColorFinded then
							local ColV = Instance.new("Color3Value")
							ColV.Value = v.Color.Value
							ColV.Parent = GameUI.ClientVars.BuildSettings.ColorList
						end
						
					end
					
					--Load In The Cards
					
					local vFirstX,vTwoX,vThreeX,vFourX = nil,nil,nil,nil
					local CurrOne,CurrTwo,CurrThree,CurrFour = nil,nil,nil,nil
					
					GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.CardsBack.Back.Scroller.xList:ClearAllChildren()
					
					local LastHolder = GameUI.GuiTemplates.EditHolder:Clone()
					LastHolder.Parent = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.CardsBack.Back.Scroller.xList
					
					local CardCount = 0
					local yOff = 0
					
					for i,v in pairs(GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.SelBack.Back.Scroller.xList:GetChildren()) do
						v.Button.NextSelectionLeft = v.Button
						v.Button.NextSelectionRight = v.Button
					end
					
					GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BlueB.NextSelectionLeft = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BrownB
					GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BrownB.NextSelectionRight = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BlueB
					
					--for i = #Cards,1,-1 do
					for i,ccv in pairs(Cards) do
						
						local v = Deck:FindFirstChild("Card" .. i)
						if v then
							
							CardCount += 1
							
							local xPos = 0
							
							if CardCount == 2 then
								xPos = 1/3
							elseif CardCount == 3 then
								xPos = 2/3
							elseif CardCount == 4 then
								xPos = 1
							end
							
							local eCard = GameUI.GuiTemplates.CardEdit:Clone()
							eCard.Name = v.Name
							eCard.Card.DeleteB.Bind.Card.Value = v.Name
							eCard.Position = UDim2.new(xPos,0,.5,0)
							ApplyCardData(eCard,v,GameUI.ClientVars.BuildSettings.ColorList)
							eCard.Parent = LastHolder.Spacer
							eCard.Visible = true
							
							local inButton = eCard.Card.DeleteB
							
							ButtonManager:ButtonConnect(eCard.Card.DeleteB,mse)
							
							if CardCount == 1 then

								if vFirstX == nil then
									vFirstX = inButton
									GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BlueB.NextSelectionLeft = inButton
									GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BrownB.NextSelectionRight = inButton
									inButton.NextSelectionUp = inButton
									
									for i,v in pairs(GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.SelBack.Back.Scroller.xList:GetChildren()) do
										v.Button.NextSelectionRight = inButton
										v.Button.NextSelectionLeft = inButton
									end
									
								else
									if vFirstX.NextSelectionDown == nil then
										vFirstX.NextSelectionDown = inButton
									end
									vFirstX.NextSelectionUp = inButton
								end
								if CurrOne ~= nil then
									inButton.NextSelectionUp = CurrOne
									CurrOne.NextSelectionDown = inButton
								end
								inButton.NextSelectionLeft = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BrownB
								inButton.NextSelectionRight = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BlueB
								inButton.NextSelectionDown = vFirstX
								CurrOne = inButton

							elseif CardCount == 2 then

								if vTwoX == nil then
									vTwoX = inButton
									inButton.NextSelectionUp = inButton
									GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BlueB.NextSelectionLeft = inButton
									
									for i,v in pairs(GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.SelBack.Back.Scroller.xList:GetChildren()) do
										v.Button.NextSelectionLeft = inButton
									end
									
								else
									if vTwoX.NextSelectionDown == nil then
										vTwoX.NextSelectionDown = inButton
									end
									vTwoX.NextSelectionUp = inButton
								end
								if CurrTwo ~= nil then
									inButton.NextSelectionUp = CurrTwo
									CurrTwo.NextSelectionDown = inButton
								end
								CurrOne.NextSelectionRight = inButton
								inButton.NextSelectionLeft = CurrOne
								inButton.NextSelectionRight = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BlueB
								inButton.NextSelectionDown = vTwoX
								CurrTwo = inButton

							elseif CardCount == 3 then

								if vThreeX == nil then
									vThreeX = inButton
									inButton.NextSelectionUp = inButton
									GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BlueB.NextSelectionLeft = inButton
									
									for i,v in pairs(GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.SelBack.Back.Scroller.xList:GetChildren()) do
										v.Button.NextSelectionLeft = inButton
									end
									
								else
									if vThreeX.NextSelectionDown == nil then
										vThreeX.NextSelectionDown = inButton
									end
									vThreeX.NextSelectionUp = inButton
								end
								if CurrThree ~= nil then
									inButton.NextSelectionUp = CurrThree
									CurrThree.NextSelectionDown = inButton
								end
								CurrTwo.NextSelectionRight = inButton
								inButton.NextSelectionLeft = CurrTwo
								inButton.NextSelectionRight = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BlueB
								inButton.NextSelectionDown = vThreeX
								CurrThree = inButton

							elseif CardCount == 4 then

								if vFourX == nil then
									vFourX = inButton
									inButton.NextSelectionUp = inButton
									GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BlueB.NextSelectionLeft = inButton
									
									for i,v in pairs(GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.SelBack.Back.Scroller.xList:GetChildren()) do
										v.Button.NextSelectionLeft = inButton
									end
									
								else
									if vFourX.NextSelectionDown == nil then
										vFourX.NextSelectionDown = inButton
									end
									vFourX.NextSelectionUp = inButton
								end
								if CurrFour ~= nil then
									inButton.NextSelectionUp = CurrFour
									CurrFour.NextSelectionDown = inButton
								end
								CurrThree.NextSelectionRight = inButton
								inButton.NextSelectionLeft = CurrThree
								inButton.NextSelectionRight = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BlueB
								inButton.NextSelectionDown = vFourX
								CurrFour = inButton

							end
							
							if CardCount >= 4 then
								if i ~= #Cards then
									yOff += 1
								end
								CardCount = 0
								LastHolder = GameUI.GuiTemplates.EditHolder:Clone()
								LastHolder.Position = UDim2.new(0,0,yOff,0)
								LastHolder.Parent = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.CardsBack.Back.Scroller.xList
							end
							
							
						end
						
					end
					
					if yOff > 2 then
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.CardsBack.Back.Scroller.CanvasSize = UDim2.new(0,0,1 + ((1/3)*(yOff-2)),0)
					else
						GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.CardsBack.Back.Scroller.CanvasSize = UDim2.new(0,0,0,0)
					end
					
				end
			end
			
		end
		
	end)
	
	Binds.SelectEditColor.Event:Connect(function(args)
		
		local Color = args["Col"]
		local Toggle = args["Toggle"]
		
		local EndResult = false
		
		if Color and Toggle ~= nil then
			
			local FoundColor = nil
			
			for i,v in pairs(GameUI.ClientVars.BuildSettings.ColorSelects:GetChildren()) do
				if v.Value == Color then
					FoundColor = v
					break
				end
			end
			
			if Toggle == false then
				if FoundColor then FoundColor:Destroy() end
			else
				if FoundColor == nil then
					local ColV = Instance.new("Color3Value")
					ColV.Value = Color
					ColV.Parent = GameUI.ClientVars.BuildSettings.ColorSelects
				end
				EndResult = true
			end
			
		elseif Color then
			
			local FoundColor = nil

			for i,v in pairs(GameUI.ClientVars.BuildSettings.ColorSelects:GetChildren()) do
				if v.Value == Color then
					FoundColor = v
					break
				end
			end
			
			if FoundColor then
				if FoundColor then FoundColor:Destroy() end
				EndResult = false
			else
				EndResult = true
				local ColV = Instance.new("Color3Value")
				ColV.Value = Color
				ColV.Parent = GameUI.ClientVars.BuildSettings.ColorSelects
			end
			
		end
		
		for i,v in pairs(GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer:GetChildren()) do
			if v.Bind.Col.Value == Color then
				
				if EndResult then
					v.ColorLight.CheckBox.Check:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
				else
					v.ColorLight.CheckBox.Check:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.3,true)
				end
				break
				
			end
		end
		
		Binds.UpdateEditButtons:Fire({})
		
	end)
	
	Binds.RefreshBuildColorList.Event:Connect(function(args)
		
		local DeckName = args["Deck"]
		if DeckName then
			
			
			
		end
		
	end)
	
	Binds.EditCardToggle.Event:Connect(function(args)
		
		local CardName = args["CardName"]
		local Toggle = args["Toggle"]
		
		if CardName then
			
			local CardV = GameUI.ClientVars.BuildSettings.CardToggles:FindFirstChild(CardName)
			if CardV then
				if Toggle ~= nil then
					CardV.Value = Toggle
				else
					CardV.Value = not CardV.Value
				end
				
				local Res = CardV.Value

				local CardHolder = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.SelBack.Back.Scroller.xList:FindFirstChild(CardName .. "H")
				if CardHolder then

					if Res then
						CardHolder.Button.ColorLight.CheckBox1.Check:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
						CardHolder.Button.ColorLight.CheckBox2.Check:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
					else
						CardHolder.Button.ColorLight.CheckBox1.Check:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.3,true)
						CardHolder.Button.ColorLight.CheckBox2.Check:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.3,true)
					end

				end
				
			end
			
		end
		
		Binds.RefreshCardSettings:Fire({})
		Binds.UpdateEditButtons:Fire({})
		
	end)
	
	Binds.EditCardSetting.Event:Connect(function(args)
		
		local CardName = args["CardName"]
		local Setting = args["Setting"]
		local Val = args["Val"]
		
		if CardName and Setting and Val then
			
			local CardF = GameUI.ClientVars.BuildSettings.MultiFilters:FindFirstChild(CardName)
			if CardF then
				local SettingV = CardF:FindFirstChild(Setting)
				if SettingV then
					
					local newVal = math.abs(math.floor(Val))
					SettingV.Value = newVal
					
				end
			end
			
		end
		
	end)
	
	Binds.DeleteCard.Event:Connect(function(args)
		
		local Card = args["Card"]
		if Card then
			
			local Yield = game.ReplicatedStorage.Remotes.DeleteCard:InvokeServer(GameUI.ClientVars.BuildSettings.SelectedDeck.Value,Card)
			
			Binds.LoadEditCards:Fire({Deck = GameUI.ClientVars.BuildSettings.SelectedDeck.Value})
			
			GameUI.Sounds.Trash:Play()
			
			if GuiService.SelectedObject ~= nil then
				--GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.SelBack.Back.Scroller.xList.ClearH.Button
			end
			
		end
		
	end)
	
	Binds.ClearAllCardToggles.Event:Connect(function()
		
		for i,v in pairs(GameUI.ClientVars.BuildSettings.CardToggles:GetChildren()) do
			GameUI.Bindables.EditCardToggle:Fire({CardName = v.Name, Toggle = false})
		end
		
		for i,v in pairs(GameUI.ClientVars.BuildSettings.ColorSelects:GetChildren()) do
			GameUI.Bindables.SelectEditColor:Fire({Col = v.Value, Toggle = false})
		end
		
		Binds.RefreshCardSettings:Fire({})
		
	end)
	
	Binds.RefreshCardSettings.Event:Connect(function()
		
		for i,v in pairs(GameUI.ClientVars.BuildSettings.CardToggles:GetChildren()) do
			if v.Value then
				
				local BadHolder = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.OptionsBack.Back.Scroller.xList:FindFirstChild(v.Name)
				if BadHolder == nil then
					
					local HolderType = "Constant"
					
					local CorreFilter = GameUI.ClientVars.BuildSettings.MultiFilters:FindFirstChild(v.Name)
					if CorreFilter then
						
						local Filters = CorreFilter:GetChildren()
						if #Filters > 1 then
							HolderType = "Variable"
						end
						
						local CloneFind = GameUI.GuiTemplates:FindFirstChild("Settings" .. HolderType)
						if CloneFind then
							local CloneF = CloneFind:Clone()
							CloneF.Name = v.Name
							CloneF.Parent = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.OptionsBack.Back.Scroller.xList
							CloneF.Spacer.Holder.Ttl.Text = string.upper(v.Name)
							CloneF.Spacer.Holder.Ttl.Dark.Text = string.upper(v.Name)
							
							for a,b in pairs(Filters) do
								local FrameFind = CloneF.Spacer.Holder:FindFirstChild(b.Name .. "Frame")
								if FrameFind then
									FrameFind.CodeBack.Input.Text = b.Value
									
									FrameFind.CodeBack.Input.FocusLost:Connect(function()
										
										local Number = tonumber(FrameFind.CodeBack.Input.Text)
										if Number then
											
											Number = math.floor(Number)
											
											local Min = 0
											local Max = 99
											
											if b.Name == "Amount" or v.Name == "Draw" or v.Name == "Wild Draw" then
												Min = 1
											end
											
											if v.Name == "Number" and b.Name ~= "Amount" then
												Max = 999
											end
											
											local FinalNumber = math.clamp(Number,Min,Max)
											
											if b.Name == "To" then
												if CorreFilter.From.Value > FinalNumber then
													CorreFilter.From.Value = FinalNumber
													FrameFind.Parent.FromFrame.CodeBack.Input.Text = FinalNumber
												end
											elseif b.Name == "From" then
												if CorreFilter.To.Value < FinalNumber then
													CorreFilter.To.Value = FinalNumber
													FrameFind.Parent.ToFrame.CodeBack.Input.Text = FinalNumber
												end
											end
											
											b.Value = FinalNumber
											
											FrameFind.CodeBack.Input.Text = FinalNumber
											
										else
											
											FrameFind.CodeBack.Input.Text = b.Value
											
										end
										
									end)
								end
							end
							
							CloneF.Visible = true
						end
						
					end
					
				end
				
			else
				
				local BadHolder = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.OptionsBack.Back.Scroller.xList:FindFirstChild(v.Name)
				if BadHolder then
					BadHolder:Destroy()
				end
				
			end
		end
		
		local Setters = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.OptionsBack.Back.Scroller.xList:GetChildren()
		
		if #Setters <= 0 then
			for i,v in pairs(GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer:GetChildren()) do
				v.NextSelectionUp = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.SelBack.Back.Scroller.xList["Targeted DrawH"].Button
			end
			GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.SelBack.Back.Scroller.xList["Targeted DrawH"].Button.NextSelectionDown = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BlueB
		end
		
		local PreviousSetter = nil
		
		for i,v in pairs(Setters) do
			
			v:TweenPosition(UDim2.new(0,0,i-1,0),"Out","Quad",.3,true)
			
			local AmountFind = v.Spacer.Holder:FindFirstChild("AmountFrame")
			if AmountFind then
				
				local ToFrame = v.Spacer.Holder:FindFirstChild("ToFrame")
				local FromFrame = v.Spacer.Holder:FindFirstChild("FromFrame")
				
				local BlueLeft = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BlueB.NextSelectionLeft
				local BrownLeft = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BrownB.NextSelectionRight
				
				local NoCards = true
				
				if BlueLeft and BrownLeft then
					if BlueLeft.Name == "DeleteB" and BrownLeft.Name == "DeleteB" then
						
						AmountFind.CodeBack.Input.NextSelectionLeft = BlueLeft
						AmountFind.CodeBack.Input.NextSelectionRight = BrownLeft
						AmountFind.CodeBack.Input.NextSelectionDown = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BlueB
						
						if ToFrame and FromFrame then
							
							ToFrame.CodeBack.Input.NextSelectionUp = FromFrame.CodeBack.Input
							FromFrame.CodeBack.Input.NextSelectionDown = ToFrame.CodeBack.Input
							ToFrame.CodeBack.Input.NextSelectionDown = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BlueB
							
							ToFrame.CodeBack.Input.NextSelectionRight = AmountFind.CodeBack.Input
							FromFrame.CodeBack.Input.NextSelectionRight = AmountFind.CodeBack.Input
							
							ToFrame.CodeBack.Input.NextSelectionLeft = BlueLeft
							FromFrame.CodeBack.Input.NextSelectionLeft = BlueLeft
							
							AmountFind.CodeBack.Input.NextSelectionLeft = FromFrame.CodeBack.Input
							
						end
						
						NoCards = false
					end
				end
				
				if PreviousSetter ~= nil then
					PreviousSetter.Spacer.Holder.AmountFrame.CodeBack.Input.NextSelectionDown = AmountFind.CodeBack.Input
					AmountFind.CodeBack.Input.NextSelectionUp = PreviousSetter.Spacer.Holder.AmountFrame.CodeBack.Input
					
					local PrevTo = PreviousSetter.Spacer.Holder:FindFirstChild("ToFrame")
					if PrevTo then
						PrevTo.CodeBack.Input.NextSelectionDown = AmountFind.CodeBack.Input
					end
					
					if ToFrame and FromFrame then
						FromFrame.CodeBack.Input.NextSelectionUp = PreviousSetter.Spacer.Holder.AmountFrame.CodeBack.Input
					end
					
				else
					AmountFind.CodeBack.Input.NextSelectionUp = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.SelBack.Back.Scroller.xList["Targeted DrawH"].Button
				end
				
				if NoCards then
					
					AmountFind.CodeBack.Input.NextSelectionLeft = AmountFind.CodeBack.Input
					AmountFind.CodeBack.Input.NextSelectionRight = AmountFind.CodeBack.Input
					
					if ToFrame and FromFrame then
						AmountFind.CodeBack.Input.NextSelectionLeft = FromFrame.CodeBack.Input
						
						ToFrame.CodeBack.Input.NextSelectionLeft = AmountFind.CodeBack.Input
						FromFrame.CodeBack.Input.NextSelectionLeft = AmountFind.CodeBack.Input
					end
					
				end
				
				if i == 1 then

					GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.SelBack.Back.Scroller.xList["Targeted DrawH"].Button.NextSelectionDown = AmountFind.CodeBack.Input
					AmountFind.CodeBack.Input.NextSelectionUp = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.SelBack.Back.Scroller.xList["Targeted DrawH"].Button
					
					if ToFrame and FromFrame then
						
						FromFrame.CodeBack.Input.NextSelectionUp = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.SelBack.Back.Scroller.xList["Targeted DrawH"].Button
						
					end
					
				end

				if i == #Setters then

					AmountFind.CodeBack.Input.NextSelectionDown = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BlueB
					for i,v in pairs(GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer:GetChildren()) do
						v.NextSelectionUp = AmountFind.CodeBack.Input
					end
					
					if ToFrame and FromFrame then

						ToFrame.CodeBack.Input.NextSelectionDown = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.Colors.Spacer.BlueB

					end

				end
				
				if ToFrame and FromFrame then
					AmountFind.CodeBack.Input.NextSelectionLeft = FromFrame.CodeBack.Input

					ToFrame.CodeBack.Input.NextSelectionLeft = AmountFind.CodeBack.Input
					FromFrame.CodeBack.Input.NextSelectionLeft = AmountFind.CodeBack.Input
				end
				
			end
			
			PreviousSetter = v
			
		end
		
		if #Setters <= 2 then
			GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.OptionsBack.Back.Scroller.CanvasSize = UDim2.new(0,0,0,0)
		else
			GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.OptionsBack.Back.Scroller.CanvasSize = UDim2.new(0,0,1 + (.5*(#Setters-2)),0)
		end
		
	end)
	
	Binds.UpdateEditButtons.Event:Connect(function()
		
		local CanAdd, CanRemove = false, false
		
		local ColorSelected = false
		local CardSelected = false
		local WildSelected = false
		
		for i,v in pairs(GameUI.ClientVars.BuildSettings.CardToggles:GetChildren()) do
			if v.Value then
				if v.Name == "Wild" or v.Name == "Wild Draw" then
					WildSelected = true
				else
					CardSelected = true
				end
			end
		end
		
		local Colorz = GameUI.ClientVars.BuildSettings.ColorSelects:GetChildren()
		if #Colorz > 0 then
			ColorSelected = true
		end
		
		if WildSelected or (CardSelected and ColorSelected) then
			CanAdd = true
		end
		
		if ColorSelected or CardSelected or WildSelected then
			CanRemove = true
		end
		
		if CanAdd then
			GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.AddB:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.3,true)
		else
			GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.AddB:TweenPosition(UDim2.new(0,0,1.15,0),"Out","Quad",.3,true)
		end
		
		if CanRemove then
			GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.RemoveB:TweenPosition(UDim2.new(.5,0,1,0),"Out","Quad",.3,true)
		else
			GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.RemoveB:TweenPosition(UDim2.new(.5,0,1.15,0),"Out","Quad",.3,true)
		end
		
	end)
	
	Binds.MultiAdd.Event:Connect(function()
		
		local Colors = {}
		local Cards = {}
		local Filters = {}
		
		local function FilterT()
			local TT = {
				Amount = 1,
				To = 1,
				From = 1,
			}
			
			return TT
		end
		
		for i,v in pairs(GameUI.ClientVars.BuildSettings.ColorSelects:GetChildren()) do
			table.insert(Colors,1,v.Value)
		end
		
		for i,v in pairs(GameUI.ClientVars.BuildSettings.CardToggles:GetChildren()) do
			if v.Value then
				table.insert(Cards,1,v.Name)
				local CorreSpondFilter = GameUI.ClientVars.BuildSettings.MultiFilters:FindFirstChild(v.Name)
				if CorreSpondFilter then
					
					local Filt = FilterT()
					
					for a,b in pairs(CorreSpondFilter:GetChildren()) do
						Filt[b.Name] = b.Value
					end
					
					Filters[v.Name] = Filt
				end
			end
		end
		
		local Yield = game.ReplicatedStorage.Remotes.AddMultiCard:InvokeServer(GameUI.ClientVars.BuildSettings.SelectedDeck.Value,Colors,Cards,Filters)
		
		Binds.LoadEditCards:Fire({Deck = GameUI.ClientVars.BuildSettings.SelectedDeck.Value})
		
		if GuiService.SelectedObject ~= nil then
			--GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.SelBack.Back.Scroller.xList.ClearH.Button
		end
		
	end)
	
	Binds.MultiRemove.Event:Connect(function()
		
		local Colors = {}
		local Cards = {}
		local Filters = {}
		
		local function FilterT()
			local TT = {
				Amount = 1,
				To = 1,
				From = 1,
			}

			return TT
		end
		
		for i,v in pairs(GameUI.ClientVars.BuildSettings.ColorSelects:GetChildren()) do
			table.insert(Colors,1,v.Value)
		end

		for i,v in pairs(GameUI.ClientVars.BuildSettings.CardToggles:GetChildren()) do
			if v.Value then
				table.insert(Cards,1,v.Name)
				local CorreSpondFilter = GameUI.ClientVars.BuildSettings.MultiFilters:FindFirstChild(v.Name)
				if CorreSpondFilter then
					local Filt = FilterT()

					for a,b in pairs(CorreSpondFilter:GetChildren()) do
						Filt[b.Name] = b.Value
					end

					Filters[v.Name] = Filt
				end
			end
		end

		local Yield = game.ReplicatedStorage.Remotes.DeleteMultiCard:InvokeServer(GameUI.ClientVars.BuildSettings.SelectedDeck.Value,Colors,Cards,Filters)

		Binds.LoadEditCards:Fire({Deck = GameUI.ClientVars.BuildSettings.SelectedDeck.Value})
		
		if GuiService.SelectedObject ~= nil then
			--GuiService.SelectedObject = GameUI.MenuBack.List.Lister.List.DeckBuilder.Sectioner.Builder.SelBack.Back.Scroller.xList.ClearH.Button
		end
		
	end)
	
	Binds.SetPlrInspect.Event:Connect(function(args)
		
		local PlrName = args["PlrName"]
		if PlrName then
			
			GameUI.ClientVars.LeaderboardInspect.Value = PlrName
			
			if PlrName ~= "None" then
				
				wait()
				GameUI.LeaderboardFrame.Buttons:TweenPosition(UDim2.new(1,0,1.02,0),"Out","Quad",.3,true)
				
				--wait()
				GameUI.LeaderboardFrame.Buttons.InspectB.Button.Bind.PlrName.Value = PlrName
				GameUI.LeaderboardFrame.Buttons.TradeB.Button.Bind.PlrName.Value = PlrName
				
			else
				
				GameUI.LeaderboardFrame.Buttons:TweenPosition(UDim2.new(1.55,0,1.02,0),"Out","Quad",.3,true)
				
			end
			
		end
		
	end)
	
	Binds.LoadInspector.Event:Connect(function(Args)
		
		if GameUI.ClientVars.LobbyCreOpen.Value or GameUI.ClientVars.Trading.Value then return end
		
		GameUI.Bindables.ViewDowner:Fire({Action = "Close"})
		
		GameUI.ClientVars.InspectorOpen.Value = true
		
		if GameUI.ClientVars.MenuOpen.Value then
			Binds.MenuOpener:Fire({})
		end
		
		if GameUI.ClientVars.LobbyOpen.Value then
			Binds.LobbyOpener:Fire({})
		end
		
		local ChosenName = GameUI.ClientVars.LeaderboardInspect.Value
		
		local PlrName = Args["PlrName"]
		if PlrName and PlrName ~= "" then
			ChosenName = PlrName
		end
		
		local PlayerData = game.ReplicatedStorage.PlayerData:FindFirstChild(ChosenName)
		if PlayerData then
			
			GameUI.Sounds.OpenSound:Play()
			
			if GameUI.ClientVars.IsMobile.Value == false then
				GameUI.InspectorBack:TweenSize(UDim2.new(.8,0,.55,0),"Out","Quad",.3,true)
			else
				GameUI.InspectorBack:TweenSize(UDim2.new(.8*(6/4),0,.55*(6/4),0),"Out","Quad",.3,true)
			end
			
			UIBoxManager:BoxText(GameUI.InspectorBack.TopBack.TtlBox,string.upper(ChosenName .. "'s inventory"))
			
			Binds.InspectorSection:Fire({Section = "Decor"})
			
			GameUI.InspectorBack.List.Lister.List.Decor.ScrollerBack.Back.Scroller.xList:ClearAllChildren()
			GameUI.InspectorBack.List.Lister.List.Chairs.ScrollerBack.Back.Scroller.xList:ClearAllChildren()
			GameUI.InspectorBack.List.Lister.List.Particles.ScrollerBack.Back.Scroller.xList:ClearAllChildren()
			
			local LastHolder = GameUI.GuiTemplates.DecorInspectHolder:Clone()
			LastHolder.Parent = GameUI.InspectorBack.List.Lister.List.Decor.ScrollerBack.Back.Scroller.xList
			
			local yOff = 0
			local ButtonCount = 0
			
			local Decorz = PlayerData.Inventory.Decorations:GetChildren()
			
			for i,v in pairs(Decorz) do
				
				ButtonCount += 1
				
				local xOff = 0
				
				if ButtonCount == 2 then
					xOff = .5
				elseif ButtonCount == 3 then
					xOff = 1
				end
				
				local InvB = GameUI.GuiTemplates.InvB:Clone()
				InvB.Visible = true
				InvB.Bind.Value = Binds.Test
				InvB.Parent = LastHolder.Spacer
				InvB.Position = UDim2.new(xOff,0,.5,0)
				InvB.ColorLight.VM.CurrentCamera = VMCam
				
				local VMM = game.ReplicatedStorage.ViewportModels:FindFirstChild(v.Id.Value)
				if VMM then
					local VMC = VMM:Clone()
					VMC.Parent = InvB.ColorLight.VM
				end
				
				if v.Copies.Value > 1 then
					InvB.ColorLight.Copies.Text = "x" .. v.Copies.Value
					InvB.ColorLight.Copies.Dark.Text = "x" .. v.Copies.Value
				end
				
				local Rarity = Util:GetRarity(v.Id.Value)
				if Rarity then
					InvB.ColorLight.RarityBar.Txt.Text = Rarity
					InvB.ColorLight.RarityBar.Txt.Dark.Text = Rarity
					local RarityColor = Util:GetRarityColor(Rarity)
					if RarityColor then
						InvB.ColorLight.RarityBar.ImageColor3 = RarityColor
					end
				end
				
				if ButtonCount >= 3 and i ~= #Decorz then
					
					ButtonCount = 0
					yOff += 1
					
					LastHolder = GameUI.GuiTemplates.DecorInspectHolder:Clone()
					LastHolder.Parent = GameUI.InspectorBack.List.Lister.List.Decor.ScrollerBack.Back.Scroller.xList
					LastHolder.Position = UDim2.new(.5,0,yOff,0)
					
				end
				
				ButtonManager:ButtonConnect(InvB,mse)
				
			end
			
			for i,v in pairs(PlayerData.Equips.Decorations:GetChildren()) do
				
				local SlotB = GameUI.InspectorBack.List.Lister.List.Decor.EquipsBack.Buttons:FindFirstChild(v.Name)
				if SlotB then
					
					UIBoxManager:BoxVM(SlotB.ColorLight.PrevBox,v.Value,VMCam)
					
					if v.Value == "None" or v.Value == "" then
						SlotB.ColorLight.RarityBar.Visible = false
					else
						SlotB.ColorLight.RarityBar.Visible = true
						local Rarity = Util:GetRarity(v.Value)
						if Rarity then
							SlotB.ColorLight.RarityBar.Txt.Text = Rarity
							SlotB.ColorLight.RarityBar.Txt.Dark.Text = Rarity
							local RarityColor = Util:GetRarityColor(Rarity)
							if RarityColor then
								SlotB.ColorLight.RarityBar.ImageColor3 = RarityColor
							end
						end
					end
					
				end
				
			end
			
			if yOff <= 2 then
				GameUI.InspectorBack.List.Lister.List.Decor.ScrollerBack.Back.Scroller.CanvasSize = UDim2.new(0,0,0,0)
			else
				GameUI.InspectorBack.List.Lister.List.Decor.ScrollerBack.Back.Scroller.CanvasSize = UDim2.new(0,0,1 + ((1/3)*(yOff-2)),0)
			end
			
			LastHolder = GameUI.GuiTemplates.InspectHolder2:Clone()
			LastHolder.Parent = GameUI.InspectorBack.List.Lister.List.Chairs.ScrollerBack.Back.Scroller.xList
			
			local Chairz = PlayerData.Inventory.Chairs:GetChildren()
			
			ButtonCount = 0
			yOff = 0
			
			for i,v in pairs(Chairz) do
				
				ButtonCount += 1

				local xOff = 0

				if ButtonCount == 2 then
					xOff = .25
				elseif ButtonCount == 3 then
					xOff = .5
				elseif ButtonCount == 4 then
					xOff = .75
				elseif ButtonCount == 5 then
					xOff = 1
				end

				local InvB = GameUI.GuiTemplates.InvB:Clone()
				InvB.Visible = true
				InvB.Bind.Value = Binds.Test
				InvB.Parent = LastHolder.Spacer
				InvB.Position = UDim2.new(xOff,0,.5,0)
				InvB.ColorLight.VM.CurrentCamera = VMCam

				local VMM = game.ReplicatedStorage.ViewportModels:FindFirstChild(v.Id.Value)
				if VMM then
					local VMC = VMM:Clone()
					VMC.Parent = InvB.ColorLight.VM
				end

				if v.Copies.Value > 1 then
					InvB.ColorLight.Copies.Text = "x" .. v.Copies.Value
					InvB.ColorLight.Copies.Dark.Text = "x" .. v.Copies.Value
				end

				local Rarity = Util:GetRarity(v.Id.Value)
				if Rarity then
					InvB.ColorLight.RarityBar.Txt.Text = Rarity
					InvB.ColorLight.RarityBar.Txt.Dark.Text = Rarity
					local RarityColor = Util:GetRarityColor(Rarity)
					if RarityColor then
						InvB.ColorLight.RarityBar.ImageColor3 = RarityColor
					end
				end
				
				if PlayerData.Equips.Chair.Value == v.Id.Value then
					InvB.ColorLight.CheckBox.Check.Position = UDim2.new(0,0,0,0)
				end

				if ButtonCount >= 5 and i ~= #Chairz then

					ButtonCount = 0
					yOff += 1

					LastHolder = GameUI.GuiTemplates.InspectHolder2:Clone()
					LastHolder.Parent = GameUI.InspectorBack.List.Lister.List.Chairs.ScrollerBack.Back.Scroller.xList
					LastHolder.Position = UDim2.new(.5,0,yOff,0)

				end

				ButtonManager:ButtonConnect(InvB,mse)
				
			end
			
			if yOff <= 2 then
				GameUI.InspectorBack.List.Lister.List.Chairs.ScrollerBack.Back.Scroller.CanvasSize = UDim2.new(0,0,0,0)
			else
				GameUI.InspectorBack.List.Lister.List.Chairs.ScrollerBack.Back.Scroller.CanvasSize = UDim2.new(0,0,1 + ((1/3)*(yOff-2)),0)
			end
			
			LastHolder = GameUI.GuiTemplates.InspectHolder2:Clone()
			LastHolder.Parent = GameUI.InspectorBack.List.Lister.List.Particles.ScrollerBack.Back.Scroller.xList

			local Particlez = PlayerData.Inventory.Particles:GetChildren()

			ButtonCount = 0
			yOff = 0

			for i,v in pairs(Particlez) do

				ButtonCount += 1

				local xOff = 0

				if ButtonCount == 2 then
					xOff = .25
				elseif ButtonCount == 3 then
					xOff = .5
				elseif ButtonCount == 4 then
					xOff = .75
				elseif ButtonCount == 5 then
					xOff = 1
				end

				local InvB = GameUI.GuiTemplates.InvB:Clone()
				InvB.Visible = true
				InvB.Bind.Value = Binds.Test
				InvB.Parent = LastHolder.Spacer
				InvB.Position = UDim2.new(xOff,0,.5,0)
				InvB.ColorLight.VM.CurrentCamera = VMCam

				local ParticleFind = game.ReplicatedStorage.Cosmetics.Particles:FindFirstChild(v.Id.Value)
				if ParticleFind then
					InvB.ColorLight.Img.Visible = true
					InvB.ColorLight.Img.Image = ParticleFind.Texture
				end

				if v.Copies.Value > 1 then
					InvB.ColorLight.Copies.Text = "x" .. v.Copies.Value
					InvB.ColorLight.Copies.Dark.Text = "x" .. v.Copies.Value
				end

				local Rarity = Util:GetRarity(v.Id.Value)
				if Rarity then
					InvB.ColorLight.RarityBar.Txt.Text = Rarity
					InvB.ColorLight.RarityBar.Txt.Dark.Text = Rarity
					local RarityColor = Util:GetRarityColor(Rarity)
					if RarityColor then
						InvB.ColorLight.RarityBar.ImageColor3 = RarityColor
					end
				end

				if PlayerData.Equips.Particle.Value == v.Id.Value then
					InvB.ColorLight.CheckBox.Check.Position = UDim2.new(0,0,0,0)
				end

				if ButtonCount >= 5 and i ~= #Decorz then

					ButtonCount = 0
					yOff += 1

					LastHolder = GameUI.GuiTemplates.InspectHolder2:Clone()
					LastHolder.Parent = GameUI.InspectorBack.List.Lister.List.Particles.ScrollerBack.Back.Scroller.xList
					LastHolder.Position = UDim2.new(.5,0,yOff,0)

				end

				ButtonManager:ButtonConnect(InvB,mse)

			end

			if yOff <= 2 then
				GameUI.InspectorBack.List.Lister.List.Particles.ScrollerBack.Back.Scroller.CanvasSize = UDim2.new(0,0,0,0)
			else
				GameUI.InspectorBack.List.Lister.List.Particles.ScrollerBack.Back.Scroller.CanvasSize = UDim2.new(0,0,1 + ((1/3)*(yOff-2)),0)
			end
			
		end
		
	end)
	
	Binds.InspectorSection.Event:Connect(function(args)
		
		local Section = args["Section"]
		if Section then
			
			if Section == GameUI.ClientVars.InspectorSection.Value then return end
			
			GameUI.Sounds.TransitionSound:Play()
			GameUI.ClientVars.InspectorSection.Value = Section
			
			local TweenTo = 0
			
			if Section == "Chairs" then
				TweenTo = -1
			elseif Section == "Particles" then
				TweenTo = -2
			end
			
			for i,v in pairs(GameUI.InspectorBack.List.TopButtons:GetChildren()) do
				if v.Name == Section .. "B" then
					ButtonManager:SwitchColors(v,Color3.fromRGB(255, 199, 85),Color3.fromRGB(193, 150, 64),Color3.fromRGB(255, 215, 135))
				else
					ButtonManager:SwitchColors(v,Color3.fromRGB(106, 106, 106),Color3.fromRGB(83, 83, 83),Color3.fromRGB(138, 138, 138))
				end
			end
			
			GameUI.InspectorBack.List.Lister.List:TweenPosition(UDim2.new(TweenTo,0,0,0),"Out","Quad",.3,true)
			
		end
		
	end)
	
	Binds.CloseInspector.Event:Connect(function()
		
		GameUI.InspectorBack:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
		
		GameUI.InspectorBack.List.Lister.List.Decor.ScrollerBack.Back.Scroller.xList:ClearAllChildren()
		GameUI.InspectorBack.List.Lister.List.Chairs.ScrollerBack.Back.Scroller.xList:ClearAllChildren()
		GameUI.InspectorBack.List.Lister.List.Particles.ScrollerBack.Back.Scroller.xList:ClearAllChildren()
		
		if GameUI.ClientVars.InspectorOpen.Value then
			GameUI.Sounds.CloseSound:Play()
			GameUI.ClientVars.InspectorOpen.Value = false
		end
		
	end)
	
	Binds.RedeemCode.Event:Connect(function()
		
		local Status = game.ReplicatedStorage.Remotes.RedeemCode:InvokeServer(GameUI.MenuBack.List.Lister.List.Codes.CodeBack.Input.Text)
		
		if Status == "SUCCESSFULLY REDEEMED" then
			GameUI.Sounds.JumpIn:Play()
		else
			GameUI.Sounds.Warn:Play()
		end
		
		GameUI.MenuBack.List.Lister.List.Codes.CodeBack.Input.Text = Status
		wait(1)
		GameUI.MenuBack.List.Lister.List.Codes.CodeBack.Input.Text = ""
		
	end)
	
	Binds.CodeCreatorOpener.Event:Connect(function()
		
		GameUI.ClientVars.CodeCreator.Open.Value = not GameUI.ClientVars.CodeCreator.Open.Value
		
		if GameUI.ClientVars.CodeCreator.Open.Value then
			GameUI.CodeCreator:TweenSize(UDim2.new(.5,0,.5,0),"Out","Quad",.3,true)
		else
			GameUI.CodeCreator:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
		end
		
	end)
	
	Binds.CodeType.Event:Connect(function(args)
		
		local Type = args["Type"]
		if Type then
			
			if Type == "Coins" then
				GameUI.CodeCreator.BackB.CoinsBack.Visible = true
				GameUI.CodeCreator.BackB.ItemBack.Visible = false
				GameUI.ClientVars.CodeCreator.RewardType.Value = "Coins"
			else
				GameUI.CodeCreator.BackB.CoinsBack.Visible = false
				GameUI.CodeCreator.BackB.ItemBack.Visible = true
				GameUI.ClientVars.CodeCreator.RewardType.Value = "Item"
			end
			
		end
		
	end)
	
	Binds.AddCode.Event:Connect(function()
		
		if GameUI.ClientVars.CodeCreator.RewardType.Value == "Coins" then
			game.ReplicatedStorage.Remotes.AddCode:FireServer(GameUI.CodeCreator.BackB.CodeBack.Input.Text, GameUI.ClientVars.CodeCreator.RewardType.Value, tonumber(GameUI.CodeCreator.BackB.ExpireBack.Input.Text), tonumber(GameUI.CodeCreator.BackB.CoinsBack.Input.Text))
		else
			game.ReplicatedStorage.Remotes.AddCode:FireServer(GameUI.CodeCreator.BackB.CodeBack.Input.Text, GameUI.ClientVars.CodeCreator.RewardType.Value, tonumber(GameUI.CodeCreator.BackB.ExpireBack.Input.Text), GameUI.CodeCreator.BackB.ItemBack.Input.Text)
		end
		
	end)
	
	Binds.VolumeChange.Event:Connect(function(args)
		
		local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(GameUI.Parent.Parent.Parent.Name)
		if Data then
			
			local NewVolume = Data.Settings.Volume.Value
			
			local Action = args["Action"]
			if Action == "Add" then
				NewVolume += .1
			else
				NewVolume -= .1
			end
			
			game.ReplicatedStorage.Remotes.ChangeVolume:FireServer(NewVolume)
		end
		
	end)
	
	Binds.TradeToggle.Event:Connect(function()
		
		game.ReplicatedStorage.Remotes.TradeToggle:FireServer()
		
	end)
	
	Binds.WatchGame.Event:Connect(function(args)
		
		local sGame = args["Game"]
		if sGame then
			
			local Res = game.ReplicatedStorage.Remotes.WatchGame:InvokeServer(sGame)
			
			if Res == "Good" then
				
				GameUI.MenuB.Visible = false
				GameUI.ShopB.Visible = false
				GameUI.PlayB.Visible = false
				GameUI.LevelBack.Visible = false
				
				if GameUI.ClientVars.MenuOpen.Value then
					GameUI.Bindables.MenuOpener:Fire({Action = false})
				end
				
				GameUI.QuitB.Visible = true
				GameUI.QuitB.Button.Bind.Value = Binds.ExitSpectate
				GameUI.SpecButtons.Visible = true
				
				GameUI.QuitB.Button.NextSelectionDown = GameUI.SpecButtons.Prev.Button
				GameUI.QuitB.Button.NextSelectionUp = GameUI.SpecButtons.Prev.Button
				
				if GuiService.SelectedObject ~= nil then
					--GuiService.SelectedObject = GameUI.SpecButtons.Next.Button
				end
				
			end
			
		end
		
	end)
	
	Binds.ExitSpectate.Event:Connect(function()
		
		local Res = game.ReplicatedStorage.Remotes.ExitSpectate:InvokeServer()
		
		if GuiService.SelectedObject ~= nil then
			--GuiService.SelectedObject = GameUI.PlayB.Button
		end
		
	end)
	
	Binds.SwitchWatcher.Event:Connect(function(args)
		
		local Direction = args["Direction"]
		if Direction then
			
			game.ReplicatedStorage.Remotes.SwitchWatchPlayer:InvokeServer(Direction)
			
		end
		
	end)
	
	Binds.RefreshWatchList.Event:Connect(function()
		
		GameUI.MenuBack.List.Lister.List.Spectate.ScrollBack.Back.Scroller.xList:ClearAllChildren()
		
		local Gamez = game.ReplicatedStorage.Games:GetChildren()
		
		local FirstOne = nil
		local LastOne = nil
		
		if #Gamez == 0 then
			if GuiService.SelectedObject ~= nil then
				--GuiService.SelectedObject = GameUI.MenuBack.BackFrame.BackF.BackB
			end
		end
		
		for i,v in pairs(Gamez) do
			
			local SpecTemp = GameUI.GuiTemplates.SpecTemp:Clone()
			SpecTemp.Holder.Host.Text = v.Settings.Host.Value
			SpecTemp.Holder.Host.Dark.Text = v.Settings.Host.Value
			SpecTemp.Holder.Type.Text = string.upper(v.LobbyType.Value)
			SpecTemp.Holder.Type.Dark.Text = string.upper(v.LobbyType.Value)
			
			local Plerts = v.Players:GetChildren()
			
			SpecTemp.Holder.Players.Text = tostring(#Plerts)
			SpecTemp.Holder.Players.Dark.Text = tostring(#Plerts)
			
			SpecTemp.Position = UDim2.new(0,0,i-1,0)
			SpecTemp.Parent = GameUI.MenuBack.List.Lister.List.Spectate.ScrollBack.Back.Scroller.xList
			SpecTemp.Visible = true
			
			SpecTemp.Holder.WatchB.Bind.Game.Value = v.Name
			
			ButtonManager:ButtonConnect(SpecTemp.Holder.WatchB,mse)
			
			if i == 1 then
				FirstOne = SpecTemp
				if GuiService.SelectedObject ~= nil then
					wait()
					if GameUI.ClientVars.MenuSection.Value == "SPECTATE" then
					--	GuiService.SelectedObject = SpecTemp.Holder.WatchB
					end
				end
				SpecTemp.Holder.WatchB.NextSelectionLeft = SpecTemp.Holder.WatchB
				SpecTemp.Holder.WatchB.NextSelectionRight = SpecTemp.Holder.WatchB
				SpecTemp.Holder.WatchB.NextSelectionUp = SpecTemp.Holder.WatchB
				SpecTemp.Holder.WatchB.NextSelectionDown = SpecTemp.Holder.WatchB
			else
				SpecTemp.Holder.WatchB.NextSelectionLeft = SpecTemp.Holder.WatchB
				SpecTemp.Holder.WatchB.NextSelectionRight = SpecTemp.Holder.WatchB
				SpecTemp.Holder.WatchB.NextSelectionUp = LastOne.Holder.WatchB
				SpecTemp.Holder.WatchB.NextSelectionDown = FirstOne.Holder.WatchB
				LastOne.Holder.WatchB.NextSelectionDown = SpecTemp.Holder.WatchB
				FirstOne.Holder.WatchB.NextSelectionUp = SpecTemp.Holder.WatchB
			end
			
			LastOne = SpecTemp
			
		end
		
		if #Gamez <= 7 then
			GameUI.MenuBack.List.Lister.List.Spectate.ScrollBack.Back.Scroller.CanvasSize = UDim2.new(0,0,0,0)
		else
			GameUI.MenuBack.List.Lister.List.Spectate.ScrollBack.Back.Scroller.CanvasSize = UDim2.new(0,0,1 + ((1/7)*(#Gamez-7)),0)
		end
		
	end)
	
	Binds.ShopOpener.Event:Connect(function(args)
		
		if GameUI.ClientVars.LobbyCreOpen.Value or GameUI.ClientVars.Trading.Value then return end
		
		local NoDown = args["NoDown"]
		if NoDown == nil then
			GameUI.Bindables.ViewDowner:Fire({Action = "Close"})
		end

		Binds.CloseInspector:Fire({})
		
		local Action = args["Action"]
		if Action then
			
			if Action == "Close" then
				GameUI.ClientVars.ShopOpen.Value = false
			else
				GameUI.ClientVars.ShopOpen.Value = true
			end
			
		else
			GameUI.ClientVars.ShopOpen.Value = not GameUI.ClientVars.ShopOpen.Value
		end
		
		if GameUI.ClientVars.ShopOpen.Value == false then
			
			if GuiService.SelectedObject ~= nil then
				--GuiService.SelectedObject = GameUI.PlayB.Button
			end
			
			for i,v in pairs(GameUI.ShopBack.List.Lister.List.Coins.ScrollerBack.Back.Scroller:GetChildren()) do
				v.ColorLight.VM.CurrentCamera = nil
			end
			
			for i,v in pairs(GameUI.ShopBack.List.Lister.List.Crates.ScrollerBack.Back.Scroller.xList:GetChildren()) do
				for a,b in pairs(v.Holder:GetChildren()) do
					b.ColorLight.VM.CurrentCamera = nil
				end
			end
			
			for i,v in pairs(GameUI.ShopBack.List.Lister.List.Boosts.ScrollerBack.Back.Scroller.xList:GetChildren()) do
				for a,b in pairs(v.Holder:GetChildren()) do
					b.ColorLight.VM.CurrentCamera = nil
				end
			end
			
			for i,v in pairs(GameUI.ShopBack.List.Lister.List.Coins.ScrollerBack.Back.Scroller:GetChildren()) do
				v.ColorLight.VM.CurrentCamera = nil
			end
			
			GameUI.ShopBack:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
			GameUI.Sounds.CloseSound:Play()
		else
			
			--if GuiService.SelectedObject ~= nil then
				local Section = GameUI.ClientVars.ShopSection.Value
				if Section == "Crates" then
					for i,v in pairs(GameUI.ShopBack.List.Lister.List.Crates.ScrollerBack.Back.Scroller.xList:GetChildren()) do
						for a,b in pairs(v.Holder:GetChildren()) do
							b.ColorLight.VM.CurrentCamera = VMCam
						end
					end
				elseif Section == "CrateInfo" then
					--GuiService.SelectedObject = GameUI.ShopBack.List.Lister.List.CrateInfo.InfoBack.BuyB
				elseif Section == "Boosts" then
					for i,v in pairs(GameUI.ShopBack.List.Lister.List.Boosts.ScrollerBack.Back.Scroller.xList:GetChildren()) do
						for a,b in pairs(v.Holder:GetChildren()) do
							b.ColorLight.VM.CurrentCamera = VMCam
						end
					end
				elseif Section == "Coins" then
					for i,v in pairs(GameUI.ShopBack.List.Lister.List.Coins.ScrollerBack.Back.Scroller:GetChildren()) do
						v.ColorLight.VM.CurrentCamera = VMCam
					end
				end
			--end
			
			if GameUI.ClientVars.LobbyOpen.Value then
				Binds.LobbyOpener:Fire({Action = "Close"})
			end

			if GameUI.ClientVars.MenuOpen.Value then
				Binds.MenuOpener:Fire({Action = false})
			end
			
			local XboxPrompt = args["XBX"]
			if XboxPrompt then
				GamepadService:EnableGamepadCursor(GameUI)
				
				for i,v in pairs(GameUI.XboxElements:GetChildren()) do
					v.Value.Visible = true
				end
			end
			
			if GameUI.ClientVars.IsMobile.Value == false then
				GameUI.ShopBack:TweenSize(UDim2.new(1,0,.65,0),"Out","Quad",.2,true)
			else
				GameUI.ShopBack:TweenSize(UDim2.new(1*(5/4),0,.65*(5/4),0),"Out","Quad",.2,true)
			end
			GameUI.Sounds.OpenSound:Play()
		end
		
	end)
	
	Binds.ShopSection.Event:Connect(function(args)
		
		local Section = args["Section"]
		if Section then
			
			if Section ~= GameUI.ClientVars.ShopSection.Value then
				
				GameUI.ClientVars.ShopSection.Value = Section
				GameUI.Sounds.TransitionSound:Play()
				
				local TweenTo = 0
				
				if Section == "CrateInfo" then
					TweenTo = 1
				elseif Section == "Boosts" then
					TweenTo = -1
				elseif Section == "Coins" then
					TweenTo = -2
				end
				
				if Section ~= "Crates" then
					for i,v in pairs(GameUI.ShopBack.List.Lister.List.Crates.ScrollerBack.Back.Scroller.xList:GetChildren()) do
						for a,b in pairs(v.Holder:GetChildren()) do
							b.ColorLight.VM.CurrentCamera = nil
						end
					end
				else
					for i,v in pairs(GameUI.ShopBack.List.Lister.List.Crates.ScrollerBack.Back.Scroller.xList:GetChildren()) do
						for a,b in pairs(v.Holder:GetChildren()) do
							b.ColorLight.VM.CurrentCamera = VMCam
						end
					end
				end
				
				if Section ~= "Boosts" then
					for i,v in pairs(GameUI.ShopBack.List.Lister.List.Boosts.ScrollerBack.Back.Scroller.xList:GetChildren()) do
						for a,b in pairs(v.Holder:GetChildren()) do
							b.ColorLight.VM.CurrentCamera = nil
						end
					end
				else
					for i,v in pairs(GameUI.ShopBack.List.Lister.List.Boosts.ScrollerBack.Back.Scroller.xList:GetChildren()) do
						for a,b in pairs(v.Holder:GetChildren()) do
							b.ColorLight.VM.CurrentCamera = VMCam
						end
					end
				end
				
				if Section ~= "Coins" then
					for i,v in pairs(GameUI.ShopBack.List.Lister.List.Coins.ScrollerBack.Back.Scroller:GetChildren()) do
						v.ColorLight.VM.CurrentCamera = nil
					end
				else
					for i,v in pairs(GameUI.ShopBack.List.Lister.List.Coins.ScrollerBack.Back.Scroller:GetChildren()) do
						v.ColorLight.VM.CurrentCamera = VMCam
					end
				end
				
				GameUI.ShopBack.List.Lister.List:TweenPosition(UDim2.new(TweenTo,0,0,0),"Out","Quad",.3,true)
				
				for i,v in pairs(GameUI.ShopBack.TopBack:GetChildren()) do
					if v.Name == Section .. "B" and v:IsA("TextButton") then
						ButtonManager:SwitchColors(v,Color3.fromRGB(255, 199, 85),Color3.fromRGB(193, 150, 64),Color3.fromRGB(255, 215, 135))
					elseif v:IsA("TextButton") then
						ButtonManager:SwitchColors(v,Color3.fromRGB(106, 106, 106),Color3.fromRGB(83, 83, 83),Color3.fromRGB(138, 138, 138))
					end
				end
				
				if GuiService.SelectedObject ~= nil then
					if Section == "Crates" then
						--GuiService.SelectedObject = GameUI.ShopBack.List.Lister.List.Crates.InfoBack.ItemsB
					elseif Section == "CrateInfo" then
						--GuiService.SelectedObject = GameUI.ShopBack.List.Lister.List.CrateInfo.InfoBack.BuyB
					elseif Section == "Boosts" then
						--GuiService.SelectedObject = GameUI.ShopBack.List.Lister.List.Boosts.InfoBack.BuyB
					elseif Section == "Coins" then
						--GuiService.SelectedObject = GameUI.ShopBack.List.Lister.List.Coins.InfoBack.BuyB
					end
				end
				
			end
			
		end
		
	end)
	
	Binds.CrateSelector.Event:Connect(function(args)
		
		local Crate = args["Crate"]
		if Crate and Crate ~= GameUI.ClientVars.SelectedCrate.Value then
			
			local CrateInfo = Util:GetCrateInfo(Crate)
			if CrateInfo then
				
				GameUI.ClientVars.SelectedCrate.Value = Crate
				
				UIBoxManager:BoxText(GameUI.ShopBack.List.Lister.List.Crates.InfoBack.CoinBack.AmountBox,CrateInfo["Cost"])
				UIBoxManager:BoxVM(GameUI.ShopBack.List.Lister.List.Crates.InfoBack.Previewer.PrevBox,Crate,VMCam)
				UIBoxManager:BoxText(GameUI.ShopBack.List.Lister.List.Crates.InfoBack.TtlBox,string.upper(Crate))
				
			end
			
		end
		
	end)
	
	Binds.ViewCrateSkins.Event:Connect(function(args)
		
		local CrateInfo = Util:GetCrateInfo(GameUI.ClientVars.SelectedCrate.Value)
		if CrateInfo then
			
			Binds.ShopSection:Fire({Section = "CrateInfo"})

			GameUI.ShopBack.List.Lister.List.CrateInfo.ScrollerBack.Back.Scroller.xList:ClearAllChildren()
			UIBoxManager:BoxText(GameUI.ShopBack.List.Lister.List.CrateInfo.InfoBack.TtlBox,string.upper(GameUI.ClientVars.SelectedCrate.Value))
			UIBoxManager:BoxText(GameUI.ShopBack.List.Lister.List.CrateInfo.InfoBack.CoinBack.AmountBox,CrateInfo["Cost"])
			
			for i,v in pairs(GameUI.ShopBack.List.Lister.List.CrateInfo.InfoBack.Rarities:GetChildren()) do
				v.Text = ""
			end
			
			local LastHolder = GameUI.GuiTemplates.CrateInfoLister:Clone()
			LastHolder.Parent = GameUI.ShopBack.List.Lister.List.CrateInfo.ScrollerBack.Back.Scroller.xList
			
			local ButtonCount = 0
			local yOff = 0
			
			for i,v in pairs(CrateInfo["Rarities"]) do
				
				local TxtFind = GameUI.ShopBack.List.Lister.List.CrateInfo.InfoBack.Rarities:FindFirstChild(v)
				if TxtFind then
					
					local Difference = (CrateInfo["Skins"][v]["MaxR"] - CrateInfo["Skins"][v]["MinR"]) + 1
					
					local Percent = (Difference/CrateInfo["MaxRoll"])*100
					
					local FinalString = tostring(Percent)
					
					if Percent >= 100 or (Percent < 10 and Percent >= 1) then
						FinalString = string.sub(tostring(Percent),1,4)
					elseif Percent >= 10 or Percent < 1 then
						FinalString = string.sub(tostring(Percent),1,4)
					end
					
					TxtFind.Text = string.upper(v) .. " " .. FinalString .. "%"
					
				end
				
				for a,b in pairs(CrateInfo["Skins"][v]["Skins"]) do
					
					if ButtonCount >= 4 then
						
						ButtonCount = 0
						yOff += 1
						
						LastHolder = GameUI.GuiTemplates.CrateInfoLister:Clone()
						LastHolder.Parent = GameUI.ShopBack.List.Lister.List.CrateInfo.ScrollerBack.Back.Scroller.xList
						LastHolder.Position = UDim2.new(0,0,yOff,0)
						
					end
					
					ButtonCount += 1
					
					local xPos = 0
					
					if ButtonCount == 2 then
						xPos = 1/3
					elseif ButtonCount == 3 then
						xPos = 2/3
					elseif ButtonCount == 4 then
						xPos = 1
					end
					
					local InvB = GameUI.GuiTemplates.InvB:Clone()
					InvB.Bind.Value = GameUI.Bindables.Test
					
					InvB.ColorLight.RarityBar.Txt.Text = string.upper(v)
					InvB.ColorLight.RarityBar.Txt.Dark.Text = string.upper(v)
					InvB.ColorLight.RarityBar.ImageColor3 = Util:GetRarityColor(v)
					
					InvB.Position = UDim2.new(xPos,0,.5,0)
					
					local VMF = game.ReplicatedStorage.ViewportModels:FindFirstChild(b)
					if VMF then
						local VMC = VMF:Clone()
						VMC.Parent = InvB.ColorLight.VM
						InvB.ColorLight.VM.CurrentCamera = VMCam
					else
						local PartiFind = game.ReplicatedStorage.Cosmetics.Particles:FindFirstChild(b)
						if PartiFind then
							InvB.ColorLight.VM.Visible = false
							InvB.ColorLight.Img.Visible = true
							InvB.ColorLight.Img.Image = PartiFind.Texture
						end
					end
					
					InvB.Parent = LastHolder.Holder
					InvB.Visible = true
					
					ButtonManager:ButtonConnect(InvB,mse)
					
				end
				
			end
			
			if yOff <= 3 then
				GameUI.ShopBack.List.Lister.List.CrateInfo.ScrollerBack.Back.Scroller.CanvasSize = UDim2.new(0,0,0,0)
			else
				GameUI.ShopBack.List.Lister.List.CrateInfo.ScrollerBack.Back.Scroller.CanvasSize = UDim2.new(0,0,1 + (.25*(yOff - 3)),0)
			end
			
		end
		
	end)
	
	Binds.BuyCrate.Event:Connect(function(args)
		
		if GameUI.ClientVars.CanOpenCrate.Value == false then 
			MarketplaceService:PromptGamePassPurchase(GameUI.Parent.Parent.Parent,52331325)
			return 
		end
		
		if Util:HasPass("CrateCooldown") == false then
			GameUI.ClientVars.CanOpenCrate.Value = false
		end
		
		local Result = game.ReplicatedStorage.Remotes.BuyCase:InvokeServer(GameUI.ClientVars.SelectedCrate.Value)
		
		if Result == "Failed" then
			
			GameUI.ClientVars.CanOpenCrate.Value = true
			GameUI.Bindables.ShopSection:Fire({Section = "Coins"})
			
		end
		
	end)
	
	Binds.SelectGamepass.Event:Connect(function(args)
		
		local Gamepass = args["Gamepass"]
		if Gamepass then
			
			if GameUI.ClientVars.SelectedGamepass.Value ~= Gamepass then
				local PassInfo = GamepassInfo[Gamepass]
				if PassInfo then
					
					GameUI.ClientVars.SelectedGamepass.Value = Gamepass
					GameUI.ClientVars.SelectedGamepass.Id.Value = PassInfo["Id"]
					
					UIBoxManager:BoxText(GameUI.ShopBack.List.Lister.List.Boosts.InfoBack.TtlBox,string.upper(Gamepass))
					UIBoxManager:BoxText(GameUI.ShopBack.List.Lister.List.Boosts.InfoBack.InfoBox,PassInfo["Description"])
					UIBoxManager:BoxText(GameUI.ShopBack.List.Lister.List.Boosts.InfoBack.CoinBack.AmountBox,PassInfo["Cost"])
					
					for i,v in pairs(GameUI.ShopBack.List.Lister.List.Boosts.ScrollerBack.Back.Scroller.xList:GetChildren()) do
						for a,b in pairs(v.Holder:GetChildren()) do
							if b.Bind.Gamepass.Value ~= Gamepass then
								b.ColorLight.CheckBox.Check:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.3,true)
							else
								b.ColorLight.CheckBox.Check:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
							end
						end
					end
					
				end
			end
			
		end
		
	end)
	
	Binds.BuyGamepass.Event:Connect(function(args)
		
		MarketplaceService:PromptGamePassPurchase(GameUI.Parent.Parent.Parent,GameUI.ClientVars.SelectedGamepass.Id.Value)
		
	end)
	
	Binds.SelectCoins.Event:Connect(function(args)
		
		local Coins = args["Coins"]
		if Coins and GameUI.ClientVars.SelectedCoins.Value ~= Coins then
			local CoinInfo = DevProductInfo[Coins]
			if CoinInfo then
				
				GameUI.ClientVars.SelectedCoins.Value = Coins
				GameUI.ClientVars.SelectedCoins.Id.Value = CoinInfo["Id"]
				UIBoxManager:BoxVM(GameUI.ShopBack.List.Lister.List.Coins.InfoBack.Previewer.PrevBox,Coins,VMCam)
				UIBoxManager:BoxText(GameUI.ShopBack.List.Lister.List.Coins.InfoBack.RobuxBack.AmountBox,CoinInfo["Cost"])
				UIBoxManager:BoxText(GameUI.ShopBack.List.Lister.List.Coins.InfoBack.CoinBack.AmountBox,CoinInfo["Amount"])
				
			end
		end
		
	end)
	
	Binds.BuyCoins.Event:Connect(function()
		
		MarketplaceService:PromptProductPurchase(GameUI.Parent.Parent.Parent,GameUI.ClientVars.SelectedCoins.Id.Value)
		
	end)
	
	Binds.SkipToCoins.Event:Connect(function()
		
		if GameUI.ClientVars.ShopOpen.Value == false then
			GameUI.Bindables.ShopOpener:Fire({})
		end
		
		GameUI.Bindables.ShopSection:Fire({Section = "Coins"})
		
	end)
	
	Binds.CloseDaily.Event:Connect(function()
		
		if GameUI.ClientVars.DailyOpen.Value then
			GameUI.Sounds.CloseSound:Play()
			GameUI.DailyReward:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
		end
		
	end)
	
	Binds.BuyAnotherDaily.Event:Connect(function()
		
		local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(GameUI.Parent.Parent.Parent.Name)
		if Data then
			if Data.DailyReward["2ndBuy"].Value == false then
				
				MarketplaceService:PromptProductPurchase(GameUI.Parent.Parent.Parent, 1269793315)
				
			end
		end
		
	end)
	
	Binds.BuyDecks.Event:Connect(function()
		
		MarketplaceService:PromptGamePassPurchase(GameUI.Parent.Parent.Parent,49326056)
		
	end)
	
	Binds.Prestige.Event:Connect(function()
		
		local Result = game.ReplicatedStorage.Remotes.Prestige:InvokeServer()
		
		if Result == "Good" then
			
			GameUI.Sounds.JumpIn:Play()
			
		end
		
	end)
	
	Binds.RefreshCraft.Event:Connect(function()
		
		GameUI.MenuBack.List.Lister.List.Crafting.MyStuff.Back.Scroller.xList:ClearAllChildren()
		GameUI.MenuBack.List.Lister.List.Crafting.ToCraft.Back.Scroller.xList:ClearAllChildren()
		
		local TotalCount = 0
		local RequiredCount = 7
		
		if Util:HasPass("ReducedCrafting") then
			UIBoxManager:BoxText(GameUI.MenuBack.List.Lister.List.Crafting.Counter.MaxBox,"5")
			RequiredCount = 5
		end
		
		local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(GameUI.Parent.Parent.Parent.Name)
		if Data then
			
			local yOff = 0
			local ButtonCount = 0
			local LastHolder = GameUI.GuiTemplates.CraftHolder:Clone()
			LastHolder.Parent = GameUI.MenuBack.List.Lister.List.Crafting.MyStuff.Back.Scroller.xList
			
			local MyS = Data.Crafting.MyStuff:GetChildren()
			
			for i,v in pairs(MyS) do
				
				ButtonCount += 1
				
				local xPos = 0
				
				if ButtonCount == 2 then
					xPos = .5
				elseif ButtonCount == 3 then
					xPos = 1
				end
				
				local InB = GameUI.GuiTemplates.InvB:Clone()
				InB.Visible = true
				InB.Bind.Value = Binds.AddCraft
				InB.Bind.DecorName.Value = v.Name
				InB.ColorLight.Copies.Text = "x" .. v.Copies.Value
				InB.ColorLight.Copies.Dark.Text = "x" .. v.Copies.Value
				InB.Parent = LastHolder.Spacer
				InB.Position = UDim2.new(xPos,0,.5,0)
				
				InB.ColorLight.RarityBar.ImageColor3 = Util:GetRarityColor(v.Rarity.Value)
				InB.ColorLight.RarityBar.Txt.Text = string.upper(v.Rarity.Value)
				InB.ColorLight.RarityBar.Txt.Dark.Text = string.upper(v.Rarity.Value)
				
				local VMF = game.ReplicatedStorage.ViewportModels:FindFirstChild(v.Name)
				if VMF then
					local VMC = VMF:Clone()
					VMC.Parent = InB.ColorLight.VM
					InB.ColorLight.VM.CurrentCamera = self.VCam
				end
				
				local PartF = game.ReplicatedStorage.Cosmetics.Particles:FindFirstChild(v.Name)
				if PartF then
					InB.ColorLight.Img.Image = PartF.Texture
					InB.ColorLight.Img.Visible = true
				end
				
				if ButtonCount >= 3 and i ~= #MyS then
					yOff += 1
					LastHolder = GameUI.GuiTemplates.CraftHolder:Clone()
					LastHolder.Parent = GameUI.MenuBack.List.Lister.List.Crafting.MyStuff.Back.Scroller.xList
					LastHolder.Position = UDim2.new(0,0,yOff,0)
					ButtonCount = 0
				end
				
				ButtonManager:ButtonConnect(InB,mse)
				
			end
			
			if yOff <= 2 then
				GameUI.MenuBack.List.Lister.List.Crafting.MyStuff.Back.Scroller.CanvasSize = UDim2.new(0,0,0,0)
			else
				GameUI.MenuBack.List.Lister.List.Crafting.MyStuff.Back.Scroller.CanvasSize = UDim2.new(0,0,1 + ((1/3)*(yOff-2)),0)
			end
			
			ButtonCount = 0
			yOff = 0
			
			local LastHolder = GameUI.GuiTemplates.CraftHolder:Clone()
			LastHolder.Parent = GameUI.MenuBack.List.Lister.List.Crafting.ToCraft.Back.Scroller.xList
			
			local ToC = Data.Crafting.ToCraft:GetChildren()

			for i,v in pairs(ToC) do

				ButtonCount += 1

				local xPos = 0

				if ButtonCount == 2 then
					xPos = .5
				elseif ButtonCount == 3 then
					xPos = 1
				end
				
				TotalCount += v.Copies.Value

				local InB = GameUI.GuiTemplates.InvB:Clone()
				InB.Visible = true
				InB.Bind.Value = Binds.RemoveCraft
				InB.Bind.DecorName.Value = v.Name
				InB.ColorLight.Copies.Text = "x" .. v.Copies.Value
				InB.ColorLight.Copies.Dark.Text = "x" .. v.Copies.Value
				InB.Parent = LastHolder.Spacer
				InB.Position = UDim2.new(xPos,0,.5,0)

				InB.ColorLight.RarityBar.ImageColor3 = Util:GetRarityColor(v.Rarity.Value)
				InB.ColorLight.RarityBar.Txt.Text = string.upper(v.Rarity.Value)
				InB.ColorLight.RarityBar.Txt.Dark.Text = string.upper(v.Rarity.Value)

				local VMF = game.ReplicatedStorage.ViewportModels:FindFirstChild(v.Name)
				if VMF then
					local VMC = VMF:Clone()
					VMC.Parent = InB.ColorLight.VM
					InB.ColorLight.VM.CurrentCamera = self.VCam
				end

				local PartF = game.ReplicatedStorage.Cosmetics.Particles:FindFirstChild(v.Name)
				if PartF then
					InB.ColorLight.Img.Image = PartF.Texture
					InB.ColorLight.Img.Visible = true
				end

				if ButtonCount >= 3 and i ~= #ToC then
					yOff += 1
					LastHolder = GameUI.GuiTemplates.CraftHolder:Clone()
					LastHolder.Parent = GameUI.MenuBack.List.Lister.List.Crafting.ToCraft.Back.Scroller.xList
					LastHolder.Position = UDim2.new(0,0,yOff,0)
					ButtonCount = 0
				end

				ButtonManager:ButtonConnect(InB,mse)

			end
			
			if yOff <= 2 then
				GameUI.MenuBack.List.Lister.List.Crafting.ToCraft.Back.Scroller.CanvasSize = UDim2.new(0,0,0,0)
			else
				GameUI.MenuBack.List.Lister.List.Crafting.ToCraft.Back.Scroller.CanvasSize = UDim2.new(0,0,1 + ((1/3)*(yOff-2)),0)
			end
			
		end
		
		UIBoxManager:BoxText(GameUI.MenuBack.List.Lister.List.Crafting.Counter.CountBox,tostring(TotalCount))
		
		if TotalCount >= RequiredCount then
			GameUI.MenuBack.List.Lister.List.Crafting.CraftB:TweenPosition(UDim2.new(.5,0,1,0),"Out","Quad",.3,true)
		else
			GameUI.MenuBack.List.Lister.List.Crafting.CraftB:TweenPosition(UDim2.new(.5,0,1.14,0),"Out","Quad",.3,true)
		end
		
	end)
	
	Binds.AddCraft.Event:Connect(function(args)
		
		local ItemName = args["DecorName"]
		if ItemName then
			
			local Res = game.ReplicatedStorage.Remotes.CraftAdd:InvokeServer(ItemName)
			if Res == "Good" then
				Binds.RefreshCraft:Fire({})
			end
			
		end
		
	end)
	
	Binds.RemoveCraft.Event:Connect(function(args)

		local ItemName = args["DecorName"]
		if ItemName then

			local Res = game.ReplicatedStorage.Remotes.CraftRemove:InvokeServer(ItemName)
			if Res == "Good" then
				Binds.RefreshCraft:Fire({})
			end

		end

	end)
	
	Binds.Craft.Event:Connect(function()
		
		local Res = game.ReplicatedStorage.Remotes.Craft:InvokeServer()
		if Res == "Good" then
			GameUI.Sounds.JumpIn:Play()
			Binds.RefreshCraft:Fire({})
		end
		
	end)
	
	Binds.ReduceBuy.Event:Connect(function()
		
		MarketplaceService:PromptGamePassPurchase(GameUI.Parent.Parent.Parent,52330048)
		
	end)
	
	Binds.SendTrade.Event:Connect(function(args)
		
		local SendTo = args["PlrName"]
		if SendTo then
			
			game.ReplicatedStorage.Remotes.SendTrade:FireServer(SendTo)
			
		end
		
	end)
	
	Binds.DeclineTrade.Event:Connect(function(args)
		
		local PlayerName = args["PlayerName"]
		if PlayerName then
			
			game.ReplicatedStorage.Remotes.DeclineTrade:FireServer(PlayerName)
			
		end
		
	end)
	
	Binds.AcceptTrade.Event:Connect(function(args)
		
		local PlayerName = args["PlayerName"]
		if PlayerName then

			game.ReplicatedStorage.Remotes.AcceptTrade:FireServer(PlayerName)

		end
		
	end)
	
	Binds.AddTradeItem.Event:Connect(function(args)
		
		local ItemName = args["DecorName"]
		if ItemName then
			
			local Yield = game.ReplicatedStorage.Remotes.AddTradeItem:InvokeServer(ItemName)
			
		end
		
	end)
	
	Binds.RemoveTradeItem.Event:Connect(function(args)
		
		local SlotNum = args["DecorName"]
		if SlotNum then
			
			local Yield = game.ReplicatedStorage.Remotes.RemoveTradeItem:InvokeServer(SlotNum)
			
		end
		
	end)
	
	Binds.ConfirmTrade.Event:Connect(function()
		
		game.ReplicatedStorage.Remotes.ConfirmTrade:FireServer()
		
	end)
	
	Binds.FinalAcceptTrade.Event:Connect(function()
		
		game.ReplicatedStorage.Remotes.FinalAcceptTrade:FireServer()
		
	end)
	
	Binds.CancelTrade.Event:Connect(function()
		
		game.ReplicatedStorage.Remotes.CancelTrade:FireServer()
		
	end)
	
	Binds.QuickTradeView.Event:Connect(function()
		
		--print("Testing")
		
		--print(0)
		if GameUI.ClientVars.MenuOpen.Value == false then
			--print(1)
			Binds.MenuOpener:Fire({})
		end
		--print(2)
		--wait(1)
		Binds.MenuSection:Fire({Section = "TRADING",SectionPos = -2})
		Binds.TradeSection:Fire({Section = "Requests"})
		
	end)
	
	Binds.TradeSection.Event:Connect(function(args)
		
		local Section = args["Section"]
		if Section then
			
			if GameUI.ClientVars.TradeSection.Value == Section then return end
			
			GameUI.ClientVars.TradeSection.Value = Section
			
			GameUI.Sounds.TransitionSound:Play()
			
			local Pos = 0
			
			if Section == "Requests" then
				Pos = -1
			end
			
			for i,v in pairs(GameUI.MenuBack.List.Lister.List.Trading.TopButtons:GetChildren()) do
				
				if v.Name == Section .. "B" then
					ButtonManager:SwitchColors(v,Color3.fromRGB(255, 199, 85),Color3.fromRGB(193, 150, 64),Color3.fromRGB(255, 215, 135))
				elseif v:IsA("TextButton") then
					ButtonManager:SwitchColors(v,Color3.fromRGB(106, 106, 106),Color3.fromRGB(83, 83, 83),Color3.fromRGB(138, 138, 138))
				end
				
			end
			
			GameUI.MenuBack.List.Lister.List.Trading.Sections.Back.List:TweenPosition(UDim2.new(Pos,0,0,0),"Out","Quad",.3,true)
			
		end
		
	end)
	
	Binds.RefreshTradeUI.Event:Connect(function(TradeFolder)
		
		GameUI.TradingUI.P1.Value.ScrollBack.Inner.Back.Scroller.yList:ClearAllChildren()
		GameUI.TradingUI.P2.Value.ScrollBack.Inner.Back.Scroller.yList:ClearAllChildren()

		GameUI.TradingUI.InvBack.ScrollBack.Inner.Back.Scroller.xList:ClearAllChildren()
		
		local yOff = 0
		local ButtonCount = 0
		local LastHolder = nil
		
		local ConfirmCount = 0
		
		for i,v in pairs(TradeFolder:GetChildren()) do
			if v.Name ~= "Canceled" then
				
				if v.Name == GameUI.Parent.Parent.Parent.Name then
					
					if v.Confirmed.Value then
						ConfirmCount += 1
					end
					
					--You
					
					LastHolder = GameUI.GuiTemplates.TradeHolder:Clone()
					LastHolder.Parent = GameUI.TradingUI.InvBack.ScrollBack.Inner.Back.Scroller.xList
					
					yOff = 0
					ButtonCount = 0
					
					local Invs = v.Inventory:GetChildren()
					
					for a,b in pairs(Invs) do
						
						local Pos = 0
						
						ButtonCount += 1
						
						if ButtonCount == 2 then
							Pos = .5
						elseif ButtonCount == 3 then
							Pos = 1
						end
						
						local inB = GameUI.GuiTemplates.InvB:Clone()
						inB.Parent = LastHolder.Spacer
						inB.ColorLight.RarityBar.Txt.Text = string.upper(b.Rarity.Value)
						inB.ColorLight.RarityBar.Txt.Dark.Text = string.upper(b.Rarity.Value)
						inB.ColorLight.RarityBar.ImageColor3 = Util:GetRarityColor(b.Rarity.Value)
						inB.Position = UDim2.new(Pos,0,.5,0)
						inB.Visible = true
						
						local VMF = game.ReplicatedStorage.ViewportModels:FindFirstChild(b.Name)
						if VMF then
							local VMC = VMF:Clone()
							VMC.Parent = inB.ColorLight.VM
							inB.ColorLight.VM.CurrentCamera = VMCam
						else
							local Parti = game.ReplicatedStorage.Cosmetics.Particles:FindFirstChild(b.Name)
							if Parti then
								inB.ColorLight.VM.Visible = false
								inB.ColorLight.Img.Image = Parti.Texture
								inB.ColorLight.Img.Visible = true
							end
						end
						
						if b.Copies.Value > 1 then
							inB.ColorLight.Copies.Text = "x" .. b.Copies.Value
							inB.ColorLight.Copies.Dark.Text = "x" .. b.Copies.Value
						end
						
						inB.Bind.Value = Binds.AddTradeItem
						inB.Bind.DecorName.Value = b.Name
						
						ButtonManager:ButtonConnect(inB,mse)
						
						if ButtonCount >= 3 and a ~= #Invs then
							
							ButtonCount = 0
							yOff += 1
							
							LastHolder =  GameUI.GuiTemplates.TradeHolder:Clone()
							LastHolder.Parent = GameUI.TradingUI.InvBack.ScrollBack.Inner.Back.Scroller.xList
							LastHolder.Position = UDim2.new(0,0,yOff,0)
							
						end
						
					end
					
					if yOff <= 2 then
						GameUI.TradingUI.InvBack.ScrollBack.Inner.Back.Scroller.CanvasSize = UDim2.new(0,0,0,0)
					else
						GameUI.TradingUI.InvBack.ScrollBack.Inner.Back.Scroller.CanvasSize = UDim2.new(0,0,1 + ((1/3)*(yOff - 2)),0)
					end
					
					yOff = 0
					ButtonCount = 0
					
					local FrameFind = GameUI.TradingUI:FindFirstChild(v.Name)
					if FrameFind then
						
						if v.Confirmed.Value then
							FrameFind.ScrollBack.Inner.Back.StatusClip.Confirm:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
						else
							FrameFind.ScrollBack.Inner.Back.StatusClip.Confirm:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.3,true)
						end
						
						if v.Confirmed.Accepted.Value then
							FrameFind.ScrollBack.Inner.Back.StatusClip.Accept:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
						else
							FrameFind.ScrollBack.Inner.Back.StatusClip.Accept:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.3,true)
						end
						
						for a,b in pairs(v.Trading:GetChildren()) do
							
							ButtonCount += 1
							
							local inB = GameUI.GuiTemplates.TradingT:Clone()
							inB.Parent = FrameFind.ScrollBack.Inner.Back.Scroller.yList
							inB.InvB.ColorLight.RarityBar.Txt.Text = string.upper(b.Rarity.Value)
							inB.InvB.ColorLight.RarityBar.Txt.Dark.Text = string.upper(b.Rarity.Value)
							inB.InvB.ColorLight.RarityBar.ImageColor3 = Util:GetRarityColor(b.Rarity.Value)
							inB.Position = UDim2.new(a-1,0,0,0)
							inB.InvB.Bind.Value = Binds.RemoveTradeItem
							inB.InvB.Bind.DecorName.Value = b.Name
							inB.Visible = true
							
							if b.Copies.Value > 1 then
								inB.InvB.ColorLight.Copies.Text = "x" .. b.Copies.Value
								inB.InvB.ColorLight.Copies.Dark.Text = "x" .. b.Copies.Value
							end
							
							local VMF = game.ReplicatedStorage.ViewportModels:FindFirstChild(b.Name)
							if VMF then
								local VMC = VMF:Clone()
								VMC.Parent = inB.InvB.ColorLight.VM
								inB.InvB.ColorLight.VM.CurrentCamera = VMCam
							else
								local Parti = game.ReplicatedStorage.Cosmetics.Particles:FindFirstChild(b.Name)
								if Parti then
									inB.InvB.ColorLight.VM.Visible = false
									inB.InvB.ColorLight.Img.Image = Parti.Texture
									inB.InvB.ColorLight.Img.Visible = true
								end
							end
							
							ButtonManager:ButtonConnect(inB.InvB,mse)
							
						end
						
						if ButtonCount <= 4 then
							FrameFind.ScrollBack.Inner.Back.Scroller.CanvasSize = UDim2.new(0,0,0,0)
						else
							FrameFind.ScrollBack.Inner.Back.Scroller.CanvasSize = UDim2.new(1 + (.25*(ButtonCount - 4)),0,0,0)
						end
						
					end
					
				else
					
					--The Other person
					
					if v.Confirmed.Value then
						ConfirmCount += 1
					end
					
					yOff = 0
					ButtonCount = 0
					
					local FrameFind = GameUI.TradingUI:FindFirstChild(v.Name)
					if FrameFind then
						
						if v.Confirmed.Value then
							FrameFind.ScrollBack.Inner.Back.StatusClip.Confirm:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
						else
							FrameFind.ScrollBack.Inner.Back.StatusClip.Confirm:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.3,true)
						end

						if v.Confirmed.Accepted.Value then
							FrameFind.ScrollBack.Inner.Back.StatusClip.Accept:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
						else
							FrameFind.ScrollBack.Inner.Back.StatusClip.Accept:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.3,true)
						end

						for a,b in pairs(v.Trading:GetChildren()) do

							ButtonCount += 1

							local inB = GameUI.GuiTemplates.TradingT:Clone()
							inB.Parent = FrameFind.ScrollBack.Inner.Back.Scroller.yList
							inB.InvB.ColorLight.RarityBar.Txt.Text = string.upper(b.Rarity.Value)
							inB.InvB.ColorLight.RarityBar.Txt.Dark.Text = string.upper(b.Rarity.Value)
							inB.InvB.ColorLight.RarityBar.ImageColor3 = Util:GetRarityColor(b.Rarity.Value)
							inB.InvB.Bind.Value = Binds.Test
							inB.InvB.Bind.DecorName.Value = b.Name
							inB.Position = UDim2.new(a-1,0,0,0)
							inB.Visible = true

							if b.Copies.Value > 1 then
								inB.InvB.ColorLight.Copies.Text = "x" .. b.Copies.Value
								inB.InvB.ColorLight.Copies.Dark.Text = "x" .. b.Copies.Value
							end

							local VMF = game.ReplicatedStorage.ViewportModels:FindFirstChild(b.Name)
							if VMF then
								local VMC = VMF:Clone()
								VMC.Parent = inB.InvB.ColorLight.VM
								inB.InvB.ColorLight.VM.CurrentCamera = VMCam
							else
								local Parti = game.ReplicatedStorage.Cosmetics.Particles:FindFirstChild(b.Name)
								if Parti then
									inB.InvB.ColorLight.VM.Visible = false
									inB.InvB.ColorLight.Img.Image = Parti.Texture
									inB.InvB.ColorLight.Img.Visible = true
								end
							end

							ButtonManager:ButtonConnect(inB.InvB,mse)

						end

						if ButtonCount <= 4 then
							FrameFind.ScrollBack.Inner.Back.Scroller.CanvasSize = UDim2.new(0,0,0,0)
						else
							FrameFind.ScrollBack.Inner.Back.Scroller.CanvasSize = UDim2.new(1 + (.25*(ButtonCount - 4)),0,0,0)
						end

					end
					
					
				end
				
			end
		end
		
		if ConfirmCount >= 2 then
			
			GameUI.TradingUI.Confirms.ButtonClip.AcceptB:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
			GameUI.TradingUI.Confirms.ButtonClip.ConfrimB:TweenPosition(UDim2.new(0,0,-1,0),"Out","Quad",.3,true)
			
		else
			
			GameUI.TradingUI.Confirms.ButtonClip.AcceptB:TweenPosition(UDim2.new(0,0,1,0),"Out","Quad",.3,true)
			GameUI.TradingUI.Confirms.ButtonClip.ConfrimB:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
			
		end
		
	end)
	
	Binds.LeavePromptOpener.Event:Connect(function()
		
		GameUI.ClientVars.LeavePromptOpen.Value = not GameUI.ClientVars.LeavePromptOpen.Value
		
		if GameUI.ClientVars.LeavePromptOpen.Value then
			GameUI.Sounds.OpenSound:Play()
			if GameUI.ClientVars.IsMobile.Value == false then
				GameUI.LeavePrompt:TweenSize(UDim2.new(.4,0,.2,0),"Out","Quad",.3,true)
			else
				GameUI.LeavePrompt:TweenSize(UDim2.new(.4*1.75,0,.2*1.75,0),"Out","Quad",.3,true)
			end
		else
			GameUI.Sounds.CloseSound:Play()
			GameUI.LeavePrompt:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
		end
		
	end)
	
	Binds.ShutdownOpener.Event:Connect(function()
		
		GameUI.ClientVars.ShutdownOpen.Value = not GameUI.ClientVars.ShutdownOpen.Value
		
		if GameUI.ClientVars.ShutdownOpen.Value then
			GameUI.Shutdowner:TweenSize(UDim2.new(.5,0,.5,0),"Out","Quad",.3,true)
		else
			GameUI.Shutdowner:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
		end
		
	end)
	
	Binds.ShutdownSend.Event:Connect(function()
		
		game.ReplicatedStorage.Remotes.ShutdownSend:FireServer(tonumber(GameUI.Shutdowner.BackB.TimeBack.Input.Text),GameUI.Shutdowner.BackB.MessageBack.Input.Text)
		
	end)
	
end

return module