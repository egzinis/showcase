local movement_module = require(game:GetService("ReplicatedStorage").Modules.MovementModule).new(
	game:GetService("Players").LocalPlayer
)

--setup
movement_module:setup()

game:GetService("RunService").RenderStepped:Connect(function(delta_time)
	movement_module:update(delta_time)
	movement_module:cap_speed()
	
	--fixes
	movement_module:fix_crumbs()
	
	--set
	movement_module.humanoid.WalkSpeed = movement_module.speed
end)
