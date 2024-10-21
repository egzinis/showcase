local camera_module = require(game:GetService("ReplicatedStorage").Modules.CameraModule).new(
	game:GetService("Players").LocalPlayer
)
local misc_module = require(game:GetService("ReplicatedStorage").Modules.MiscModule).new(
	game:GetService("Players").LocalPlayer
)

--setup
local input_service = game:GetService("UserInputService")
camera_module:setup()

game:GetService("RunService").RenderStepped:Connect(function(delta_time)
	--main
	camera_module:camera_update(delta_time)
	
	--fixes
	if input_service.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
		--player esc might cause the mouse to unlock or reset icon
		input_service.MouseBehavior = Enum.MouseBehavior.LockCenter
	end
end)

input_service.InputChanged:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseMovement then
		return
	end
	
	camera_module:mouse_update(input)
	misc_module:look_update()
end)
