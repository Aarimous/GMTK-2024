extends Marker2D

@export var player: Player


func _physics_process(delta: float) -> void:
	if player:
		global_position.y = player.global_position.y
