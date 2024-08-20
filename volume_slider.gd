extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = .25

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		0, 
		linear_to_db(value * 2)
	)
