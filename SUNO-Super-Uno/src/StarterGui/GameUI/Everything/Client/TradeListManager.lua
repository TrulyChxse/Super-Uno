--X_Z

local GameUI = script.Parent.Parent

script.Parent:WaitForChild("ButtonManager")

local ButtonManager = require(script.Parent.ButtonManager)

local module = {}

function module:RefreshPlrList(Mouse)
	
	for i,v in pairs(GameUI.MenuBack.List.Lister.List.Trading.Sections.Back.List.Players.Scroller.xList:GetChildren()) do
		local CorreP = game.Players:FindFirstChild(v.Name)
		if CorreP == nil then
			v:Destroy()
		end
	end
	
	for i,v in pairs(game.Players:GetChildren()) do
		local CorreP = GameUI.MenuBack.List.Lister.List.Trading.Sections.Back.List.Players.Scroller.xList:FindFirstChild(v.Name)
		if CorreP == nil and v.Name ~= GameUI.Parent.Parent.Parent.Name then
			
			local NewLister = GameUI.GuiTemplates.TradeListTemp:Clone()
			NewLister.Name = v.Name
			NewLister.Spacer.User.Text = v.Name
			NewLister.Spacer.User.Dark.Text = v.Name
			NewLister.Spacer.TradeB.Bind.PlrName.Value = v.Name
			NewLister.Spacer.InvB.Bind.PlrName.Value = v.Name
			NewLister.Parent = GameUI.MenuBack.List.Lister.List.Trading.Sections.Back.List.Players.Scroller.xList
			NewLister.Visible = true
			
			ButtonManager:ButtonConnect(NewLister.Spacer.TradeB,Mouse)
			ButtonManager:ButtonConnect(NewLister.Spacer.InvB,Mouse)
			
		end
	end
	
	local FFs = GameUI.MenuBack.List.Lister.List.Trading.Sections.Back.List.Players.Scroller.xList:GetChildren()
	
	for i,v in pairs(FFs) do
		v:TweenPosition(UDim2.new(0,0,i-1,0),"Out","Quad",.3,true)
	end
	
	if #FFs <= 5 then
		GameUI.MenuBack.List.Lister.List.Trading.Sections.Back.List.Players.Scroller.CanvasSize = UDim2.new(0,0,0,0)
	else
		GameUI.MenuBack.List.Lister.List.Trading.Sections.Back.List.Players.Scroller.CanvasSize = UDim2.new(0,0,1 + (.2*(#FFs-5)),0)
	end
	
end

function module:RefreshRequestList(Mouse)
	
	local Data = game.ReplicatedStorage.PlayerData:FindFirstChild(GameUI.Parent.Parent.Parent.Name)
	if Data then
		
		for i,v in pairs(GameUI.MenuBack.List.Lister.List.Trading.Sections.Back.List.Requests.Scroller.xList:GetChildren()) do
			local CorreP = Data.TradeRequests:FindFirstChild(v.Name)
			if CorreP == nil then
				v:Destroy()
			end
		end

		for i,v in pairs(Data.TradeRequests:GetChildren()) do
			local CorreP = GameUI.MenuBack.List.Lister.List.Trading.Sections.Back.List.Requests.Scroller.xList:FindFirstChild(v.Name)
			if CorreP == nil and v.Name ~= GameUI.Parent.Parent.Parent.Name then

				local NewLister = GameUI.GuiTemplates.RequestListTemp:Clone()
				NewLister.Name = v.Name
				NewLister.Spacer.User.Text = v.Name
				NewLister.Spacer.User.Dark.Text = v.Name
				NewLister.Spacer.ConfirmB.Bind.PlayerName.Value = v.Name
				NewLister.Spacer.CancelB.Bind.PlayerName.Value = v.Name
				NewLister.Parent = GameUI.MenuBack.List.Lister.List.Trading.Sections.Back.List.Requests.Scroller.xList
				NewLister.Visible = true

				ButtonManager:ButtonConnect(NewLister.Spacer.ConfirmB,Mouse)
				ButtonManager:ButtonConnect(NewLister.Spacer.CancelB,Mouse)

			end
		end

		local FFs = GameUI.MenuBack.List.Lister.List.Trading.Sections.Back.List.Requests.Scroller.xList:GetChildren()

		for i,v in pairs(FFs) do
			v:TweenPosition(UDim2.new(0,0,i-1,0),"Out","Quad",.3,true)
		end

		if #FFs <= 5 then
			GameUI.MenuBack.List.Lister.List.Trading.Sections.Back.List.Requests.Scroller.CanvasSize = UDim2.new(0,0,0,0)
		else
			GameUI.MenuBack.List.Lister.List.Trading.Sections.Back.List.Requests.Scroller.CanvasSize = UDim2.new(0,0,1 + (.2*(#FFs-5)),0)
		end
		
	end
	
end

return module