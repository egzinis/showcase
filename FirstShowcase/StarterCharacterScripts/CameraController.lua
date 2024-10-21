local user_input = game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local camera = workspace.Camera

local root_part = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

--setup
user_input.MouseIcon = "http://www.roblox.com/asset/?id=14500233914"
player.CameraMode    = Enum.CameraMode.LockFirstPerson

--camera settings
camera.FieldOfView = 120

game:GetService("RunService").RenderStepped:Connect(function()
	local amplitude = root_part.CFrame.LookVector:Dot(root_part.Velocity)
	local ct = tick()
	
	if humanoid.MoveDirection.Magnitude > 0 then
		local bobble_x = math.cos(ct * 10) * (amplitude / 42)
		local bobble = Vector3.new(bobble_x, 0, 0)
		
		--main
		humanoid.CameraOffset = humanoid.CameraOffset:lerp(bobble, 0.25)
		return
	end

  --reset to default
	humanoid.CameraOffset = humanoid.CameraOffset * 0.75
end)
