--X_Z

script.Parent:WaitForChild("ButtonManager")
script.Parent:WaitForChild("Util")

local GameUI = script.Parent.Parent

local ButtonManager = require(script.Parent.ButtonManager)
local Util = require(script.Parent.Util)

local module = {}

function module:RefreshLabel(Player,pData,FrameClone)
	
	for i,v in pairs(FrameClone.Icons:GetChildren()) do
		if v:IsA("ImageLabel") then
			v:Destroy()
			FrameClone.Icons.Prestige.Position = UDim2.new(1,0,.5,0)
		end
	end
	
	if pData.LevelData.Prestige.Value > 0 then
		FrameClone.Icons.Prestige.Text = "[" .. Util:intToRoman(pData.LevelData.Prestige.Value) .. "]"
		FrameClone.Icons.Prestige.Dark.Text = "[" .. Util:intToRoman(pData.LevelData.Prestige.Value) .. "]"
	end

	local IconOff = 1.18

	if pData.GamePasses.VIP.Value then

		IconOff -= .24

		FrameClone.Icons.Prestige.Position = FrameClone.Icons.Prestige.Position - UDim2.new(.24,0,0,0)

		local IconClone = GameUI.GuiTemplates.IconTemp:Clone()
		IconClone.Visible = true
		IconClone.Image = "rbxassetid://8204933382"
		IconClone.Dark.Image = "rbxassetid://8204933382"
		IconClone.Parent = FrameClone.Icons
		IconClone.Position = UDim2.new(IconOff,0,.5,0)

		FrameClone.MainB.Button.ColorLight.Txt.TextColor3 = Color3.fromRGB(255, 255, 127)

	end

	if Player.UserId == 23441688 or Player.UserId == 65659402 or Player.UserId == 62357898 then

		IconOff -= .24

		FrameClone.Icons.Prestige.Position = FrameClone.Icons.Prestige.Position - UDim2.new(.24,0,0,0)

		local IconClone = GameUI.GuiTemplates.IconTemp:Clone()
		IconClone.Visible = true
		IconClone.Image = "rbxassetid://9662444923"
		IconClone.Dark.Image = "rbxassetid://9662444923"
		IconClone.Parent = FrameClone.Icons
		IconClone.Position = UDim2.new(IconOff,0,.5,0)

		FrameClone.MainB.Button.ColorLight.Txt.TextColor3 = Color3.fromRGB(0, 255, 127)

	end

	if GameUI.Parent.Parent.Parent:IsFriendsWith(Player.UserId) then

		IconOff -= .24

		FrameClone.Icons.Prestige.Position = FrameClone.Icons.Prestige.Position - UDim2.new(.24,0,0,0)

		local IconClone = GameUI.GuiTemplates.IconTemp:Clone()
		IconClone.Visible = true
		IconClone.Image = "rbxassetid://9724394303"
		IconClone.Dark.Image = "rbxassetid://9724394303"
		IconClone.Parent = FrameClone.Icons
		IconClone.Position = UDim2.new(IconOff,0,.5,0)

	end
	
end

function module:AddLeaderboardFrame(Player,Mouse)
	
	local FrameClone = GameUI.GuiTemplates.PlrListHolder:Clone()
	FrameClone.Name = Player.Name
	FrameClone.MainB.Button.Bind.PlrName.Value = Player.Name
	FrameClone.MainB.Button.ColorLight.Txt.Text = Player.DisplayName
	FrameClone.MainB.Button.ColorLight.Txt.TxtDark.Text = Player.DisplayName
	FrameClone.Visible = true
	FrameClone.Parent = GameUI.LeaderboardFrame.Backer.Back.Scroller.xList
	
	ButtonManager:ButtonConnect(FrameClone.MainB.Button,Mouse)
	
	spawn(function()
		
		local pData = game.ReplicatedStorage.PlayerData:WaitForChild(Player.Name)
		pData:WaitForChild("Loaded")

		if pData then

			local Nos = false

			repeat

				if pData and pData.Parent and pData.Parent ~= nil then

				else
					Nos = true
					break
				end

				wait(.1)
			until pData.Loaded.Value

			if Nos then
				return
			end

			self:RefreshLabel(Player,pData,FrameClone)

		end
		
	end)
	
end

function module:RefreshLeaderboard(Mouse)
	
	for i,v in pairs(GameUI.LeaderboardFrame.Backer.Back.Scroller.xList:GetChildren()) do
		
		local PlayerFind = game.Players:FindFirstChild(v.Name)
		if PlayerFind == nil then
			v:Destroy()
		end
		
	end
	
	for i,v in pairs(game.Players:GetChildren()) do
		
		local FrameFind = GameUI.LeaderboardFrame.Backer.Back.Scroller.xList:FindFirstChild(v.Name)
		if FrameFind == nil then
			self:AddLeaderboardFrame(v)
		end
		
	end
	
	local Frames = GameUI.LeaderboardFrame.Backer.Back.Scroller.xList:GetChildren()
	
	for i,v in pairs(Frames) do
		v:TweenPosition(UDim2.new(0,0,i-1,0),"Out","Quad",.3,true)
	end
	
	if #Frames <= 7 then
		GameUI.LeaderboardFrame.Backer.Back.Scroller.CanvasSize = UDim2.new(0,0,0,0)
	else
		GameUI.LeaderboardFrame.Backer.Back.Scroller.CanvasSize = UDim2.new(0,0,1 + ((1/7)*(#Frames-7)),0)
	end
	
end

return module