local movement_module = {}
movement_module.__index = movement_module

function movement_module.new(player)
	local self = setmetatable({}, movement_module)
	
	self.player = player
	
	--main
	self.character = player.Character or player.CharacterAdded:Wait()
	self.root_part = self.character:WaitForChild("HumanoidRootPart")
	self.humanoid  = self.character:WaitForChild("Humanoid")
	
	--settings
	self.speed = 0
	self.max_speed = 32
	self.acceleration = 16
	
	return self
end

function movement_module:setup()
	--main
	self.humanoid.WalkSpeed = 16

  --add fixes (not yet implemented)
end

function movement_module:update(delta_time)
	if self.humanoid.MoveDirection.Magnitude <= 0 then
		self.speed = 16
		
		return
	end
	
	--main
	self.speed += self.acceleration * delta_time
end

function movement_module:cap_speed()
	if self.speed < self.max_speed then
		return
	end
	
	--main
	self.speed = self.max_speed
end

--reset player velocity to absolute 0 if not moving
function movement_module:fix_crumbs()
	if self.root_part.Velocity.Magnitude > 0.5 then
		return
	end
	
	self.root_part.Velocity = Vector3.zero
end

function movement_module:slide()
	
end

return movement_module
