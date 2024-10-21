--[[
    For devteam, this module script is responsible for tilting the torso, fixing animations, making the player character blocky.
    I made everything in the local script and put players into a table rather than using remote events to increase performance, that's
    why this script even though will be used locally will still be seen by other players
--]]

local misc_module = {}
misc_module.__index = misc_module

function misc_module.new(player)
	local self = setmetatable({}, misc_module)
	
	self.player = player

	--main
	self.character = player.Character or player.CharacterAdded:Wait()
	self.root_part = self.character:WaitForChild("HumanoidRootPart")
	self.humanoid  = self.character:WaitForChild("Humanoid")
	
	--settings
	self.default = self.root_part.RootJoint.C0
	
	--torso
	self.player_table = {}
	
	return self
end

function misc_module:fix_animations()
	self.character.Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=98153773932736"
	--self.character.Animate.jump.JumpAnim.AnimationId = ""
	
	--104879656486194 landing id
end

function misc_module:fix_sounds()
	if not self.set then
		self.root_part.Running.SoundId = "rbxassetid://174960816"
		self.root_part.Jumping.SoundId = "rbxassetid://2428506580"
		
		self.root_part.Running.PlaybackSpeed = 1
		self.set = true
	end
	
	--run loop
	self.root_part.Running.PlaybackSpeed = self.humanoid.WalkSpeed/26
end

--player character reset to blocky appearance
function misc_module:blocky()
	self.player.CharacterAppearanceLoaded:Wait()
	local description = self.humanoid:GetAppliedDescription()
	
	--main
	description.LeftArm = 0
	description.LeftLeg = 0
	
	description.RightArm = 0
	description.RightLeg = 0
	
	description.Head  = 0
	description.Torso = 0
	
	self.humanoid:ApplyDescription(description)
end

--[[
  these 2 functions (show arms, show legs) even though are similar were split into 2 parts due to me
  wanting to add functionality which I have not yet implemented
--]]
function misc_module:show_arms()
	local arm_parts = {"Left Arm", "Right Arm"}
	
	for i, v in ipairs(self.character:GetChildren()) do
		if not table.find(arm_parts, v.Name) then
			continue
		end
		
		v.LocalTransparencyModifier = 0
	end
end

function misc_module:show_legs()
	local leg_parts = {"Left Leg", "Right Leg"}

	for i, v in ipairs(self.character:GetChildren()) do
		if not table.find(leg_parts, v.Name) then
			continue
		end

		v.LocalTransparencyModifier = 0
	end
end

--add each player to a table, fixes performance, no need to call remote event each frame 
function misc_module:update_table()
	for _, player in ipairs(game:GetService("Players"):GetChildren()) do
		--main
		if table.find(self.player_table, player) then
			continue
		end
		
		table.insert(self.player_table, player)
	end
	
	for i, player in ipairs(self.player_table) do
		local character = player.Character
		
		--guard clauses
		if not character then
			table.remove(self.player_table, i)
			
			return
		end
		
		if not character:FindFirstChild("Humanoid") then
			table.remove(self.player_table, i)
			
			return
		end
		
		if not character:FindFirstChild("HumanoidRootPart") then
			table.remove(self.player_table, i)
			
			return
		end
	end
end

--tilting the player torso
function misc_module:tilt()
	for _, player in ipairs(self.player_table)  do
		local character = player.Character
		local root_part = character.HumanoidRootPart
		
		--main
		local wish_dir = root_part.CFrame:VectorToObjectSpace(root_part.AssemblyLinearVelocity)
		local target_z = self.default * CFrame.Angles(0, 0, math.rad(-wish_dir.X * 2))
		local target_x = self.default * CFrame.Angles(0, math.rad(-wish_dir.X * 0.7), 0)

		root_part.RootJoint.C0 = root_part.RootJoint.C0:Lerp(target_z, 0.1)
		root_part.RootJoint.C0 = root_part.RootJoint.C0:Lerp(target_x, 0.1)
	end
end

return misc_module
