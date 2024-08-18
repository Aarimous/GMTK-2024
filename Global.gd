extends Node


var main : Main
var mods : Mods


var velocity_normilization_factor = 100

var money = 0 :
	set(new_value):
		money = new_value
		money_changed.emit(money)
		

signal energy_changed(new_value)
signal money_changed(new_value)

enum UPGRADE_TYPES {DAMAGE_BASE, ENERGY_BASE, MOVEMENT_SPEED_BASE}


func _ready():
	mods = Mods.new()


func load_json_data_from_path(path : String):
	var file_string = FileAccess.get_file_as_string(path)
	var json_data
	if file_string != null:
		json_data = JSON.parse_string(file_string)
		
	else:
		push_warning("load_json_data_from_path failed get_file_as_string for path: ", path)
	
	if json_data == null:
		push_error("load_json_data_from_path failed to parse file data to JSON for ", path)
	
	return json_data
