--X_Z

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local GameUI = script.Parent.Parent

local PopperTI = TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut)

local module = {}

function module:ConPopper(Con,Type,Content,DelayT,Color)
	
	if DelayT ~= nil then
		wait(DelayT)
	end
	
	if Type == "Text" then
		local TxtC = Con.PicF.Thumb.Poppers.TextPopper:Clone()
		TxtC.Name = "TxtC"
		TxtC.Text = Content
		TxtC.Visible = true
		TxtC.Parent = Con.PicF.Thumb.Poppers
		
		local TextTween = TweenService:Create(TxtC,PopperTI,{TextTransparency = 1,Size = UDim2.new(1,0,1,0)})
		TextTween:Play()
		
		game.Debris:AddItem(TxtC,1.2)
		game.Debris:AddItem(TextTween,1.2)
	else
		local ImgC = Con.PicF.Thumb.Poppers.ImagePopper:Clone()
		ImgC.Name = "ImgC"
		ImgC.Image = "rbxassetid://" .. Content
		ImgC.Visible = true
		ImgC.Parent = Con.PicF.Thumb.Poppers
		
		if Color ~= nil then
			ImgC.ImageColor3 = Color
		end
		
		local ImageTween = TweenService:Create(ImgC,PopperTI,{ImageTransparency = 1,Size = UDim2.new(1,0,1,0)})
		ImageTween:Play()
		
		game.Debris:AddItem(ImgC,1.2)
		game.Debris:AddItem(ImageTween,1.2)
	end
	
	local CircleC = Con.PicF.CirclePopper:Clone()
	CircleC.Name = "CircC"
	CircleC.Visible = true
	CircleC.Parent = Con.PicF
	
	if Color ~= nil then
		CircleC.ImageColor3 = Color
	end
	
	local CircleTween = TweenService:Create(CircleC,PopperTI,{ImageTransparency = 1,Size = UDim2.new(1.6,0,1.6,0)})
	CircleTween:Play()
	
	game.Debris:AddItem(CircleC,1.2)
	game.Debris:AddItem(CircleTween,1.2)
end

function module:TrackCon(Frame)
	
	local TrackConnection = nil
	
	local RotFrame = Frame.PicF.Rotter
	local MyFrame = Frame
	local MainFrame = Frame.Parent
	local Screen = Frame.Parent.Parent.AbsoluteSize

	local Offset = 15

	local Camera = game.Workspace.CurrentCamera
	local Object = Frame.Data.TrackObject
	
	local function CountUI()
		Frame.PicF.CircleDark.InfoHider.Count.Text = "x" .. #Frame.Data.PlayerTrack.Value.Cards:GetChildren()
		Frame.PicF.CircleDark.InfoHider.Count.Size = UDim2.new(1,0,1,0)
		Frame.PicF.CircleDark.InfoHider.Count:TweenSize(UDim2.new(1,0,.8,0),"Out","Quad",.5,true)
	end
	
	local AddCon,RemCon = nil,nil
	
	AddCon = Frame.Data.PlayerTrack.Value.Cards.ChildAdded:Connect(function()
		if Frame == nil or Frame.Parent == nil or not Frame:IsDescendantOf(script.Parent.Parent.Parent.Parent.RealGame) then
			AddCon:Disconnect()
			return
		end
		CountUI()
	end)
	
	RemCon = Frame.Data.PlayerTrack.Value.Cards.ChildRemoved:Connect(function()
		if Frame == nil or Frame.Parent == nil or not Frame:IsDescendantOf(script.Parent.Parent.Parent.Parent.RealGame) then
			RemCon:Disconnect()
			return
		end
		CountUI()
	end)
	
	TrackConnection = RunService.RenderStepped:Connect(function()
		--print(11)
		if Object.Value == nil or Object.Value.Parent == nil or not Object.Value:IsDescendantOf(game.Workspace) or Frame == nil or Frame.Parent == nil or not Frame:IsDescendantOf(script.Parent.Parent.Parent.Parent.RealGame) then
			Frame:Destroy()
			TrackConnection:Disconnect()
			return
		end
		
		local Pos,IsVisible = Camera:WorldToScreenPoint(Object.Value.Position)
		local Rot = Camera.CFrame:Inverse()*Object.Value.CFrame

		local FrameABS = MyFrame.AbsoluteSize

		local MarkerPositionX = Pos.X
		local MarkerPositionY = Pos.Y

		local xMin = (FrameABS.X/2) + Offset
		local yMin = (FrameABS.Y/2) + Offset

		local xMax = MainFrame.AbsoluteSize.X - ((FrameABS.X/2) + Offset)
		local yMax = MainFrame.AbsoluteSize.Y - ((FrameABS.Y/2) + Offset)

		MarkerPositionX = math.clamp(Pos.X,xMin,xMax)
		MarkerPositionY = math.clamp(Pos.Y,yMin,yMax)

		if not IsVisible then

			if MarkerPositionX ~= xMin and MarkerPositionX ~= xMax and MarkerPositionY ~= yMin and MarkerPositionY ~= yMax then

				local xMinD = math.abs(xMin - MarkerPositionX)
				local xMaxD = math.abs(xMax - MarkerPositionX)
				local yMinD = math.abs(yMin - MarkerPositionY)
				local yMaxD = math.abs(yMax - MarkerPositionY)

				if xMinD < xMaxD and xMinD < yMinD and xMinD < yMaxD then
					MarkerPositionX = xMin
				elseif xMaxD < xMinD and xMaxD < yMinD and xMaxD < yMaxD then
					MarkerPositionX = xMax
				elseif yMinD < xMinD and yMinD < xMaxD and yMinD < yMaxD then
					MarkerPositionY = yMin
				elseif yMaxD < xMinD and yMaxD < xMaxD and yMaxD < yMinD then
					MarkerPositionY = yMax
				end

			end

		end

		local BarDist = math.abs(MarkerPositionX - xMax)

		if BarDist <= (MyFrame.AbsoluteSize.X + MyFrame.PicF.CircleDark.InfoHider.AbsoluteSize.X) then
			MyFrame.PicF.CircleDark.InfoHider.Position = UDim2.new(-1,0,0,0)
			MyFrame.PicF.CircleDark.InfoHider.CardIcon.Position = UDim2.new(.03,0,.5,0)
			MyFrame.PicF.CircleDark.InfoHider.Count.Position = UDim2.new(.33,0,.48,0)
		else
			MyFrame.PicF.CircleDark.InfoHider.Position = UDim2.new(.5,0,0,0)
			MyFrame.PicF.CircleDark.InfoHider.CardIcon.Position = UDim2.new(.31,0,.5,0)
			MyFrame.PicF.CircleDark.InfoHider.Count.Position = UDim2.new(.61,0,.48,0)
		end

		RotFrame.Parent.Parent.Position = UDim2.new(0,MarkerPositionX,0,MarkerPositionY - math.abs(Frame.AbsolutePosition.Y - Frame.PicF.AbsolutePosition.Y))

		RotFrame.Rotation = -90 + math.deg(math.atan2(Rot.Z,Rot.X))
		RotFrame.Visible = not IsVisible
		
	end)
	
end

function module:Init(ScreenFrame)
	
	ScreenFrame.ChildAdded:Connect(function(Child)
		
		if GameUI.ClientVars.IsMobile.Value then
			Child.Size = UDim2.new(.15,0,.15,0)
		end
		
		self:TrackCon(Child)
	end)
	
end

return module