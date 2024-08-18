extends Node2D
class_name Main


@onready var upgrades: UpgradeScreen = $Upgrades

@export var cave_packed : PackedScene
@export var player_pakced : PackedScene

var player : Player
@onready var cave: Cave = $Cave


func _ready():
	Global.main = self
	start_run()
	

func start_run():
	
	#cave = cave_packed.instantiate()
	#add_child(cave)
	
	cave.reset_cave()
	
	player = player_pakced.instantiate()
	player.global_position = Vector2(64, -384)
	add_child(player)
	$"Camera Pivot".player = player
	upgrades.hide()
	
	
	
	
func end_run():
	upgrades.on_run_ended()
	$"Camera Pivot".player = null
	player.queue_free()
	#cave.queue_free()
	
	upgrades.show()
	
