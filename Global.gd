extends Node


var main : Main
var mods : Mods

var rng : RandomNumberGenerator
var hex_util : HexUtil


var velocity_normilization_factor = 100

var money = 0 :
	set(new_value):
		money = new_value
		money_changed.emit(money)
		

signal energy_changed(new_value)
signal money_changed(new_value)

enum UPGRADE_TYPES {
	DAMAGE_BASE, 
	ENERGY_BASE, 
	MOVEMENT_SPEED_BASE,
	MONEY_ON_HIT_SCALE,
	MONEY_ON_BREAK_SCALE,
	JETPACK_SPEED,
	VELOCITY_TO_DAMAGE_SCALE
	}
	
var percent_based_upgrades = [
	UPGRADE_TYPES.MONEY_ON_HIT_SCALE,
	UPGRADE_TYPES.MONEY_ON_BREAK_SCALE,
	UPGRADE_TYPES.VELOCITY_TO_DAMAGE_SCALE
]


var speed_based_upgrades = [
	UPGRADE_TYPES.MOVEMENT_SPEED_BASE,
	UPGRADE_TYPES.JETPACK_SPEED
]
enum BLOCK_TYPES {GRASS_DIRT, DIRT, GRAVEL_DIRT, GRAVEL_STONE, STONE, DEEP_STONE, OBSIDIAN, RAINBOW}


func _ready():
	mods = Mods.new()
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	hex_util = HexUtil.new(Vector2(96, 96))


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
