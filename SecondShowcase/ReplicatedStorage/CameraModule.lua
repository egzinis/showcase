--[[
  This is the script that implements the custom 3rd person camera
--]]

local camera_module = {}
camera_module.__index = camera_module

--services
local user_input = game:GetService("UserInputService")

function camera_module.new(player: Player)
	local self = setmetatable({}, camera_module)

	--main
	self.player = player
	self.camera = workspace.Camera
  self.mouse = player:GetMouse()

	self.character = player.Character or player.CharacterAdded:Wait()
	self.root_part = self.character:WaitForChild("HumanoidRootPart")	

	--rotation
	self.current_rotation = Vector2.new(0, 0)
	self.sensitivity = 0.2

	--settings
	self.offset = CFrame.new(4, 2, 4)
	self.speed  = .1

	return self
end

function camera_module:setup()
	self.camera.FieldOfView = 90
	self.camera.CameraType  = Enum.CameraType.Scriptable

	user_input.MouseBehavior = Enum.MouseBehavior.LockCenter
	user_input.MouseIcon = "http://www.roblox.com/asset/?id=14500233914"
end


function camera_module:camera_update(delta_time)
	local horizontal_angle = self.current_rotation.X
	local vertical_angle = math.clamp(self.current_rotation.Y, -80, 80)

	local rotation = CFrame.Angles(0, math.rad(horizontal_angle), 0) * CFrame.Angles(math.rad(vertical_angle), 0, 0)
	local target_pos = CFrame.new(self.root_part.Position) * rotation * self.offset
	
	self.camera.CFrame = self.camera.CFrame:Lerp(target_pos, self.speed)
end

function camera_module:mouse_update(input)
	local target_rot = self.current_rotation + Vector2.new(-input.Delta.X, -input.Delta.Y) * self.sensitivity
	self.current_rotation = target_rot
end

return camera_module
