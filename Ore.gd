extends RigidBody2D
class_name Ore


func _ready():
	#rotation_degrees = Global.rng.randi_range(0, 360)
	
	apply_impulse(Vector2.ONE.rotated(deg_to_rad(Global.rng.randi_range(0, 360))))


func on_pick_up():
	var money = Global.mods.ore_pickup_money_base * (1 + Global.mods.ore_money_scale)  * (1 + Global.mods.money_scale)
	AudioManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.ORE_PICK_UP)
	Global.money += money
	Global.main.create_text(str("$", snappedf(money, 0.01)), Global.get_node2d_viewport_position(self), Global.TEXT_TYPES.MONEY)
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
