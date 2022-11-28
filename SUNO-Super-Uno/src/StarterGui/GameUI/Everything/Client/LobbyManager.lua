--X_Z

script.Parent:WaitForChild("UIBoxManager")
script.Parent:WaitForChild("ButtonManager")
script.Parent:WaitForChild("NotificationManager")

local BM = require(script.Parent.UIBoxManager)
local ButM = require(script.Parent.ButtonManager)
local Notif = require(script.Parent.NotificationManager)

local GameUI = script.Parent.Parent

local GuiService = game:GetService("GuiService")

local module = {}

local Mouse = nil
local Play3r = nil

function module:SetMouse(Moos,Plr)
	Mouse = Moos
	Play3r = Plr
end

function module:CreateLabel(Lobby,Frame,NumTween)
	
	local LobF = GameUI.GuiTemplates.ListTemp:Clone()
	LobF.Name = Lobby.Name
	LobF.Parent = Frame
	
	LobF.HostTxt.Text = Lobby.Settings.Host.Value
	LobF.HostTxt.Dark.Text = Lobby.Settings.Host.Value
	
	LobF.PlrBoxes.MaxPlrs.Text = Lobby.Settings.MaxPlrs.Value
	LobF.PlrBoxes.MaxPlrs.Dark.Text = Lobby.Settings.MaxPlrs.Value
	
	LobF.JoinB.Bind.Type.Value = Lobby.Parent.Name
	LobF.JoinB.Bind.LobbyName.Value = Lobby.Name
	
	BM:BoxText(LobF.PlrBoxes.PlrsBox,tostring(#Lobby.Players:GetChildren()))
	
	if Lobby.Settings.CodeLocked.Value == false then
		LobF.Lock.Visible = false
	else
		LobF.Lock.Visible = true
	end
	
	LobF.Visible = true
	LobF:TweenPosition(UDim2.new(0,0,1.1*(NumTween-1),0),"Out","Quad",.3,true)
	
	ButM:ButtonConnect(LobF.JoinB,Mouse)
	
	local PlrCountCon1,PlrCountCon2 = nil,nil
	
	PlrCountCon1 = Lobby.Players.ChildAdded:Connect(function(Child)
		BM:BoxText(LobF.PlrBoxes.PlrsBox,tostring(#Lobby.Players:GetChildren()))
		
		if GameUI.ClientVars.CurrentLobby.Value and GameUI.ClientVars.CurrentLobby.Value.Parent ~= nil and GameUI.ClientVars.CurrentLobby.Value.Name == Lobby.Name then
			GameUI.Bindables.ViewPlrUpdate:Fire({Lobby = GameUI.ClientVars.CurrentLobby.Value})
			
			Notif:CreateLabel("Good",Child.Name .. "<br>has joined</br><br>the lobby</br>")
			
			if #GameUI.ClientVars.CurrentLobby.Value.Players:GetChildren() >= 2 and GameUI.ClientVars.CurrentLobby.Value.Settings.Host.Value == Play3r.Name then
				GameUI.Viewer.StartB:TweenSize(UDim2.new(.8,0,.12,0),"Out","Quad",.3,true)
			else
				GameUI.Viewer.StartB:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
			end
		end
	end)
	
	PlrCountCon2 = Lobby.Players.ChildRemoved:Connect(function(Child)
		
		BM:BoxText(LobF.PlrBoxes.PlrsBox,tostring(#Lobby.Players:GetChildren()))
		
		if GameUI.ClientVars.CurrentLobby.Value and GameUI.ClientVars.CurrentLobby.Value.Parent ~= nil and GameUI.ClientVars.CurrentLobby.Value.Name == Lobby.Name then
			GameUI.Bindables.ViewPlrUpdate:Fire({Lobby = GameUI.ClientVars.CurrentLobby.Value})
			
			Notif:CreateLabel("Bad",Child.Name .. "<br>has left</br><br>the lobby</br>")
			
			if #GameUI.ClientVars.CurrentLobby.Value.Players:GetChildren() >= 2 and GameUI.ClientVars.CurrentLobby.Value.Settings.Host.Value == Play3r.Name then
				GameUI.Viewer.StartB:TweenSize(UDim2.new(.8,0,.12,0),"Out","Quad",.3,true)
			else
				GameUI.Viewer.StartB:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.3,true)
			end
		end
		
		if Child and Child.Parent and Child.Parent ~= nil and Child.Name == Play3r.Name then
			GameUI.ClientVars.CurrentLobby.Value = nil
			GameUI.Bindables.ViewOpener:Fire({Action = "Close"})
		end
		
		if Child.Name == GameUI.Parent.Parent.Name then
			GameUI.ClientVars.CurrentLobby.Value = nil

			GameUI.Bindables.ViewOpener:Fire({Action = "Close"})
			return
		end
		
	end)
	
	Lobby.Changed:Connect(function(Val)
		if Val == "Parent" and Lobby.Parent == nil then
			
			GameUI.Sounds.CloseSound:Play()
			
			spawn(function()
				if GameUI.ClientVars.CurrentLobby.Value and Lobby.Name == GameUI.ClientVars.CurrentLobby.Value.Name then
					GameUI.Bindables.ViewOpener:Fire({Action = "Close"})
				end
			end)
			
			if PlrCountCon1 then PlrCountCon1:Disconnect() end
			if PlrCountCon2 then PlrCountCon2:Disconnect() end
			
		end
	end)
	
end

function module:RefreshLobby(Type)
	local Folder = game.ReplicatedStorage.Lobbies:FindFirstChild(Type)
	local LobbFrame = GameUI.Browser.List.Back.Lister.List:FindFirstChild(Type)
	if Folder and LobbFrame then
		
		for i,v in pairs(LobbFrame.List:GetChildren()) do
			local CorreF = Folder:FindFirstChild(v.Name)
			if CorreF then
				--
			else
				v:Destroy()
			end
		end
		
		local Lobz = Folder:GetChildren()
		
		local LobbButton = GameUI.Browser.TopBack:FindFirstChild(Type .. "B")
		if LobbButton then
			BM:BoxText(LobbButton.ColorLight.CountBack.AmountBox,tostring(#Lobz))
			
			if #Lobz <= 0 then
				LobbButton.ColorLight.CountBack:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.1,true)
			else
				LobbButton.ColorLight.CountBack:TweenSize(UDim2.new(1,0,.7,0),"Out","Quad",.1,true)
			end
		end
		
		if #Lobz <= 7 then
			LobbFrame.CanvasSize = UDim2.new(0,0,1,0)
		else
			LobbFrame.CanvasSize = UDim2.new(0,0,1 + ((#Lobz - 7)*.1425),0)
		end
		
		for i,v in pairs(Lobz) do
			local Corre = LobbFrame.List:FindFirstChild(v.Name)
			if Corre then
				Corre:TweenPosition(UDim2.new(0,0,1.1*(i-1),0),"Out","Quad",.3,true)
			else
				self:CreateLabel(v,LobbFrame.List,i)
			end
		end
		
		local LastJoinB = nil
		
		local FindL = GameUI.Browser.List.Back.Lister.List:FindFirstChild(Type)
		if FindL then
			local Lobbies = FindL.List:GetChildren()

			if #Lobbies == 0 then

				GameUI.Browser.List.CreateB.NextSelectionDown = GameUI.Browser.List.CreateB
				GameUI.Browser.List.CreateB.NextSelectionUp = GameUI.Browser.List.CreateB

			else

				for i,v in pairs(Lobbies) do

					if i == 1 then
						v.JoinB.NextSelectionUp = GameUI.Browser.List.CreateB
						if GameUI.ClientVars.LobbySection.Value == Type then
							GameUI.Browser.List.CreateB.NextSelectionDown = v.JoinB
						end
					end
					
					if LastJoinB ~= nil then
						LastJoinB.NextSelectionDown = v.JoinB
						v.JoinB.NextSelectionUp = LastJoinB
					end

					if i == #Lobbies then
						v.JoinB.NextSelectionDown = GameUI.Browser.List.CreateB
						if GameUI.ClientVars.LobbySection.Value == Type then
							GameUI.Browser.List.CreateB.NextSelectionUp = v.JoinB
						end
					end
					
					LastJoinB = v.JoinB

				end

			end

		end

		if GuiService.SelectedObject ~= nil then
			if not GuiService.SelectedObject:IsDescendantOf(GameUI.Browser.List) then
				GuiService.SelectedObject = GameUI.Browser.List.CreateB
			end
		end
		
		local LobbyCount = 0
		
		LobbyCount += #game.ReplicatedStorage.Lobbies.Classic:GetChildren()
		LobbyCount += #game.ReplicatedStorage.Lobbies.Super:GetChildren()
		LobbyCount += #game.ReplicatedStorage.Lobbies.Custom:GetChildren()
		
		BM:BoxText(GameUI.PlayB.LobbyCount.AmountBox,tostring(LobbyCount))
		BM:BoxText(GameUI.MobileButtons.PlayB.LobbyCount.AmountBox,tostring(LobbyCount))
		
		if LobbyCount > 0 then
			GameUI.MobileButtons.PlayB.LobbyCount:TweenSize(UDim2.new(1,0,1,0),"Out","Quad",.1,true)
			GameUI.PlayB.LobbyCount:TweenSize(UDim2.new(1,0,1,0),"Out","Quad",.1,true)
		else
			GameUI.MobileButtons.PlayB.LobbyCount:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.1,true)
			GameUI.PlayB.LobbyCount:TweenSize(UDim2.new(0,0,0,0),"Out","Quad",.1,true)
		end
		
	end
end

return module