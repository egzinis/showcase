--[[
  As of right now this script is only for the inverse kinematics, but there is more functionality that
  is unfinished that I couldn't add here
--]]

local misc_module = {}
misc_module.__index = misc_module

--events
local look_event = game:GetService("ReplicatedStorage").Events.LookEvent

function misc_module.new(player)
	local self = setmetatable({}, misc_module)
	
	self.player = player
	self.camera = workspace.Camera
	
	self.character = self.player.Character or self.player.CharacterAdded:Wait()
	self.root_part = self.character:WaitForChild("HumanoidRootPart")
	
	self.look_part = nil
	
	return self
end

function misc_module:setup()
	self.look_part = Instance.new("Part", self.character)
	self.look_part.Name         = "LookPart"
	self.look_part.Anchored     = true
	self.look_part.Transparency = 1
	
	--only for video showcase will delete after
	self.look_part.Transparency = 0
	self.look_part.Color = Color3.new(1, 0, 1)
	self.look_part.Material = Enum.Material.Neon
	self.look_part.Size = Vector3.new(2, 2, 2)
end

function misc_module:look_update()
	local look_direction = self.camera.CFrame.LookVector
	local camera_position = self.camera.CFrame.Position
	
	look_event:FireServer(camera_position + look_direction * 15)
end

function misc_module:spawn_ik()
	self.ik_controller = Instance.new("IKControl", self.character)
	
	--setup
	self.ik_controller.EndEffector = self.character.Head
	self.ik_controller.ChainRoot   = self.character.LowerTorso
	self.ik_controller.Target      = self.look_part
	self.ik_controller.Type        = Enum.IKControlType.LookAt
	self.ik_controller.Weight      = 0.7
	self.ik_controller.SmoothTime  = 0.1
end

return misc_module
