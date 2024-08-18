extends ProgressBar

var max_width = 1900
func _ready():
	Global.energy_changed.connect(_on_energy_changed)
	
	max_value = Global.mods.energy_base
	value = max_value


func _on_energy_changed(new_value):
	
	#size.x = min(custom_minimum_size.x + Global.mods.energy_base, max_width)
	
	max_value = Global.mods.energy_base
	%"Energy Amount".text = str(snappedf(new_value, 0.1))
	value = new_value
