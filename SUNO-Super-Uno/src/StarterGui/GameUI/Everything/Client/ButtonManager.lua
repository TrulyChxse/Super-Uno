--ChuckXZ

local GameUI = script.Parent.Parent

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")

local TI = TweenInfo.new(.15,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut)
local TI2 = TweenInfo.new(2,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut)

local xz_UDim2 = UDim2.new

local circleEffectSpeed = 1

local Mowz = nil

local module = {}

function module:circleEffect(frame, speed, m)
	local circle = Instance.new("ImageLabel")
	circle.BackgroundTransparency = 1
	circle.Image = "rbxassetid://897335728"
	circle.ZIndex = 99
	circle.ImageTransparency = 0.9
	local absFramePos = frame.AbsolutePosition
	local posX = m.X - absFramePos.X
	local posY = m.Y - absFramePos.Y
	local circlePos = xz_UDim2(0, posX, 0, posY)
	circle.Position = circlePos
	circle.Size = xz_UDim2(0,0,0,0)
	circle.Parent = frame.Circles
	circle:TweenSizeAndPosition(xz_UDim2(0, 1000, 0, 1000), circlePos - xz_UDim2(0, 500, 0, 500), "Out", "Linear", circleEffectSpeed,true)
	
	local Tween = TweenService:Create(circle,TI2,{ImageTransparency = 1})
	Tween:Play()
	
	game.Debris:AddItem(Tween,circleEffectSpeed)
	game.Debris:AddItem(circle,circleEffectSpeed)
	
end

function module:notOnFrame(frame,m) --Credit to Repotted
	local isOffFrame = false
	if m.X < frame.AbsolutePosition.X or m.X > frame.AbsolutePosition.X + frame.AbsoluteSize.X or m.Y < frame.AbsolutePosition.Y or m.Y > frame.AbsolutePosition.Y + frame.AbsoluteSize.Y or (frame.Parent == nil) then
		isOffFrame = true
	end
	return isOffFrame
end

--Basically is the base for the buttons' color effects and click effects as well as binding to the bindables
function module:ButtonConnect(Button,Mouse,UseDown)
	
	local Mouz = Mouse
	if Mouz == nil then
		Mouz = Mowz
	else
		Mowz = Mouse
	end
	
	local MouseInfo = Button:FindFirstChild("MouseInfo")
	if MouseInfo then
		
		local MouseDown = false
		local MouseDown2 = false
		local MouseOver = false
		local MouseOver2 = false
		
		local Selected = false
		
		MouseInfo.NewCol.Changed:Connect(function()
			if MouseOver then
				
				local Tween = TweenService:Create(Button.ColorLight,TI,{ImageColor3 = MouseInfo.NewCol.Value})
				Tween:Play()
				game.Debris:AddItem(Tween,.16)
				
			end
		end)
		
		Button.SelectionLost:Connect(function()
			Selected = false
		end)
		
		Button.SelectionGained:Connect(function()
			
			Selected = true
			
			if MouseOver2 then return end

			MouseOver2 = true
			
			if GamepadService.GamepadCursorEnabled then
				GuiService.SelectedObject = Button
			end

			GameUI.Sounds.Hov:Play()

			local HovBind = Button:FindFirstChild("HoverBind")
			if HovBind then
				if HovBind.Value then
					local hovArgs = {}
					for i,v in pairs(HovBind:GetChildren()) do
						hovArgs[v.Name] = v.Value
					end
					--print("Init")
					HovBind.Value:Fire(hovArgs)
				end
			end

			local Tween = TweenService:Create(Button.ColorLight,TI,{ImageColor3 = MouseInfo.NewCol.Value})
			Tween:Play()
			spawn(function()
				wait(.16)
				Tween:Destroy()
			end)

			local NeedsToBeOff = false

			repeat

				if Selected == false then
					NeedsToBeOff = true
				end

				if not Button:IsDescendantOf(GameUI.Parent.Parent) then
					NeedsToBeOff = true
				end

				RunService.RenderStepped:wait()
			until NeedsToBeOff
			
			--print(3)
			local uHovBind = Button:FindFirstChild("UnHovBind")
			if uHovBind then
				if HovBind.Value then
					local uhovArgs = {}
					for i,v in pairs(uHovBind:GetChildren()) do
						uhovArgs[v.Name] = v.Value
					end
					--print("Enit")
					uHovBind.Value:Fire(uhovArgs)
				end
			end

			MouseOver2 = false

			if Button:FindFirstChild("ColorLight") then
				Button.ColorLight:TweenPosition(xz_UDim2(.5,0,MouseInfo.LightUpY.Value,0),"Out","Quad",.1,true)
				local Tween = TweenService:Create(Button.ColorLight,TI,{ImageColor3 = MouseInfo.OrigCol.Value})
				Tween:Play()
				spawn(function()
					wait(.16)
					Tween:Destroy()
				end)
			end
			
			if MouseDown then
				GameUI.Sounds.Cancel:Play()
			end

			MouseDown = false
			
		end)
		
		Button.MouseEnter:Connect(function()
			
			if MouseOver then return end
			
			MouseOver = true
			Selected = true
			
			if GamepadService.GamepadCursorEnabled then
				GuiService.SelectedObject = Button
			end
			
			GameUI.Sounds.Hov:Play()
			
			local HovBind = Button:FindFirstChild("HoverBind")
			if HovBind then
				if HovBind.Value then
					local hovArgs = {}
					for i,v in pairs(HovBind:GetChildren()) do
						hovArgs[v.Name] = v.Value
					end
					--print("Init")
					HovBind.Value:Fire(hovArgs)
				end
			end
			
			local Tween = TweenService:Create(Button.ColorLight,TI,{ImageColor3 = MouseInfo.NewCol.Value})
			Tween:Play()
			spawn(function()
				wait(.16)
				Tween:Destroy()
			end)
			
			local NeedsToBeOff = false
			
			repeat
				
				if GamepadService.GamepadCursorEnabled then
					if Selected == false then
						--print(1)
						NeedsToBeOff = true
					end
				else
					if self:notOnFrame(Button,Mouz) then
						NeedsToBeOff = true
					end
				end
				
				if not Button:IsDescendantOf(GameUI.Parent.Parent) then
					NeedsToBeOff = true
				end
				
				RunService.RenderStepped:wait()
			until NeedsToBeOff
			--print(3)
			local uHovBind = Button:FindFirstChild("UnHovBind")
			if uHovBind then
				if HovBind.Value then
					local uhovArgs = {}
					for i,v in pairs(uHovBind:GetChildren()) do
						uhovArgs[v.Name] = v.Value
					end
					--print("Enit")
					uHovBind.Value:Fire(uhovArgs)
				end
			end
			
			MouseOver = false
			
			if Button:FindFirstChild("ColorLight") then
				Button.ColorLight:TweenPosition(xz_UDim2(.5,0,MouseInfo.LightUpY.Value,0),"Out","Quad",.1,true)
				local Tween = TweenService:Create(Button.ColorLight,TI,{ImageColor3 = MouseInfo.OrigCol.Value})
				Tween:Play()
				spawn(function()
					wait(.16)
					Tween:Destroy()
				end)
			end
			
			--Button.ColorLight:TweenPosition(xz_UDim2(.5,0,MouseInfo.LightUpY.Value,0),"Out","Quad",.1,true)
			if MouseDown then
				--Button.ColorLight:TweenPosition(xz_UDim2(.5,0,MouseInfo.LightUpY.Value,0),"Out","Quad",.1,true)
				GameUI.Sounds.Cancel:Play()
			end

			MouseDown = false
			
		end)

		Button.MouseLeave:Connect(function()
			
			--[[if not MouseOver then return end
			
			if GuiService.SelectedObject == Button then
				GuiService.SelectedObject = nil
			end
			
			MouseOver = false
			
			if Button:FindFirstChild("ColorLight") then
				local Tween = TweenService:Create(Button.ColorLight,TI,{ImageColor3 = MouseInfo.OrigCol.Value})
				Tween:Play()
				spawn(function()
					wait(.16)
					Tween:Destroy()
				end)
			end
			
			if MouseDown then
				GameUI.Sounds.Cancel:Play()
				if Button:FindFirstChild("Ligher") then
					Button.Lighter:TweenPosition(xz_UDim2(.5,0,MouseInfo.LightUpY.Value,0),"Out","Quad",.1,true)
				end
			end
			
			MouseDown = false]]

		end)

		Button.MouseButton1Down:Connect(function()
			--print(1)
			local Bind = Button:FindFirstChild("Bind")
			if Bind and Bind.Value ~= nil then
				GameUI.Sounds.Down:Play()
				Button.ColorLight:TweenPosition(xz_UDim2(.5,0,MouseInfo.LightDownY.Value,0),"Out","Quad",.1,true)
			end
			MouseDown = true
			
			if UseDown then
				local Bind = Button:FindFirstChild("Bind")
				if Bind and Bind.Value ~= nil then
					--print(22)
					GameUI.Sounds.Click:Play()
					local Args = {}
					for i,v in pairs(Bind:GetChildren()) do
						Args[v.Name] = v.Value
					end
					Bind.Value:Fire(Args)
				end
			end
			
		end)

		Button.MouseButton1Click:Connect(function()
			--print(11)
			Button.ColorLight:TweenPosition(xz_UDim2(.5,0,MouseInfo.LightUpY.Value,0),"Out","Quad",.1,true)
			MouseDown = false
			
			if UseDown == nil then
				local Bind = Button:FindFirstChild("Bind")
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
				
				local Circles = Button:FindFirstChild("Circles")
				if Circles then
					--self:circleEffect(Button,.5,Mouse)
				end
			end
		end)
		
	end
	
end

function module:SwitchColors(Button,NewLightColor,NewDarkColor,NewNewColor)
	
	local LightTween = TweenService:Create(Button.ColorLight,TI,{ImageColor3 = NewLightColor})
	local DarkTween = TweenService:Create(Button.ColorDark,TI,{ImageColor3 = NewDarkColor})
	
	if Button.MouseInfo.NewCol.Value ~= NewNewColor then
		LightTween:Play()
	end
	
	DarkTween:Play()
	
	spawn(function()
		wait(.16)
		LightTween:Destroy()
		DarkTween:Destroy()
	end)
	
	Button.MouseInfo.NewCol.Value = NewNewColor
	Button.MouseInfo.OrigCol.Value = NewLightColor
	
end

return module