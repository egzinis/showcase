local misc_module = require(game:GetService("ReplicatedStorage").Modules.MiscModule).new(
	game:GetService("Players").LocalPlayer
)

--setup
misc_module:fix_animations()

misc_module.character["Left Arm"]:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
	--mai
	misc_module:show_arms()
	misc_module:show_legs()
end)

game:GetService("RunService").RenderStepped:Connect(function(delta_time)
	--main
	misc_module:update_table()
	misc_module:fix_sounds()
	
	--misc
	misc_module:tilt()
end)
