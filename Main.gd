extends Node2D
class_name Main


@onready var upgrades: UpgradeScreen = $Upgrades

@export var cave_packed : PackedScene
@export var player_pakced : PackedScene
@onready var money: Label = %Money
var player : Player
@onready var cave: Cave = $Cave
@onready var ores: Node2D = %Ores


func _ready():
	Global.main = self
	start_run()
	

func start_run():
	
	cave.reset_cave()
	
	player = player_pakced.instantiate()
	player.global_position = Vector2(64, -384)
	add_child(player)
	$"Camera Pivot".player = player
	
	upgrades.on_run_started()
	upgrades.hide()
	
	
func end_run():
	
	$"Camera Pivot".player = null
	player.queue_free()
	
	upgrades.on_run_ended()
	upgrades.show()
	
	for ore : Ore in %Ores.get_children():
		ore.queue_free()
	
var duration = .5
@export var flaoting_text_packed : PackedScene
@export var text_color : Color = Color.WHITE


func create_text(text , pos, type : Global.TEXT_TYPES):
	var new_floating_text = flaoting_text_packed.instantiate().init(text, .5, pos, type)
	if type == Global.TEXT_TYPES.MONEY:
		$UI.call_deferred("add_child", new_floating_text) 
	else:
		call_deferred("add_child", new_floating_text) 
	
	
