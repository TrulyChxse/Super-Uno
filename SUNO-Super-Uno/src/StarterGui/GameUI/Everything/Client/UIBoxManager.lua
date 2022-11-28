--X_Z

local module = {}

function module:BoxText(Box,NewText,Overrides)
	
	local OldTxt
	
	local Settings = Box:FindFirstChild("BoxSet")
	if Settings then
		
		local StartPos = UDim2.new(Settings.StartPos.X.Value,0,Settings.StartPos.Y.Value,0)
		local EndPos = UDim2.new(Settings.EndPos.X.Value,0,Settings.EndPos.Y.Value,0)
		local CompletePos = UDim2.new(Settings.CompletePos.X.Value,0,Settings.CompletePos.Y.Value,0)
		local Time = Settings.Time.Value
		
		for i,v in pairs(Box:GetChildren()) do
			if v.Name == "Txt" then
				OldTxt = v.Text
				v.Name = "Old"
				v:TweenPosition(EndPos,"Out","Quad",Time*.5,true)
				game.Debris:AddItem(v,Time+.01)
			end
		end
		
		--if OldTxt ~= NewText then
		local NewTxt = Box.Cloner:Clone()
		NewTxt.Text = NewText
		
		local Dark = NewTxt:FindFirstChild("Dark")
		if Dark then
			Dark.Text = NewText
		end
		
		NewTxt.Position = StartPos
		NewTxt.Name = "Txt"
		NewTxt.Parent = Box
		NewTxt:TweenPosition(CompletePos,"Out","Quad",Time,true)
		
		--end
		
	end
	
end

function module:BoxImage(Box,ImageId,Overrides)
	
	local FullImg = "rbxassetid://" .. ImageId
	
	if string.len(tostring(ImageId)) > 20 then
		FullImg = ImageId
	end

	local OldTxt

	local Settings = Box:FindFirstChild("BoxSet")
	if Settings then

		local StartPos = UDim2.new(Settings.StartPos.X.Value,0,Settings.StartPos.Y.Value,0)
		local EndPos = UDim2.new(Settings.EndPos.X.Value,0,Settings.EndPos.Y.Value,0)
		local CompletePos = UDim2.new(Settings.CompletePos.X.Value,0,Settings.CompletePos.Y.Value,0)
		local Time = Settings.Time.Value

		for i,v in pairs(Box:GetChildren()) do
			if v.Name == "Img" then
				--OldTxt = v.Text
				v.Name = "Old"
				v:TweenPosition(EndPos,"Out","Quad",Time*.5,true)
				game.Debris:AddItem(v,Time+.01)
			end
		end

		--if OldTxt ~= NewText then
		local NewTxt = Box.Cloner:Clone()
		NewTxt.Image = FullImg
		NewTxt.Position = StartPos
		NewTxt.Name = "Img"
		NewTxt.Parent = Box
		NewTxt:TweenPosition(CompletePos,"Out","Quad",Time,true)
		
		local Dark = NewTxt:FindFirstChild("Dark")
		if Dark then
			NewTxt.Dark.Image = FullImg
		end
		--end

	end

end

function module:BoxVM(Box,ModelName,Camera)
	
	local Settings = Box:FindFirstChild("BoxSet")
	if Settings then

		local StartPos = UDim2.new(Settings.StartPos.X.Value,0,Settings.StartPos.Y.Value,0)
		local EndPos = UDim2.new(Settings.EndPos.X.Value,0,Settings.EndPos.Y.Value,0)
		local CompletePos = UDim2.new(Settings.CompletePos.X.Value,0,Settings.CompletePos.Y.Value,0)
		local Time = Settings.Time.Value

		for i,v in pairs(Box:GetChildren()) do
			if v.Name == "VM" then
				--OldTxt = v.Text
				v.Name = "Old"
				v:TweenPosition(EndPos,"Out","Quad",Time*.5,true)
				game.Debris:AddItem(v,Time+.01)
			end
		end

		--if OldTxt ~= NewText then
		local NewTxt = Box.Cloner:Clone()
		NewTxt.Position = StartPos
		NewTxt.Name = "VM"
		NewTxt.Parent = Box
		NewTxt:TweenPosition(CompletePos,"Out","Quad",Time,true)
		NewTxt.CurrentCamera = Camera
		
		local ModelFind = game.ReplicatedStorage.ViewportModels:FindFirstChild(ModelName)
		if ModelFind then
			local ModelClone = ModelFind:Clone()
			ModelClone.Parent = NewTxt
		end

		--end

	end
	
end

return module