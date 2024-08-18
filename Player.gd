extends CharacterBody2D
class_name Player

@export var is_active = true


var energy : float :
	set(new_value):
		if is_active:
			energy = new_value
			Global.energy_changed.emit(energy)
			
			if energy <= 0:
				Global.main.end_run()
		

func _ready():
	energy = Global.mods.energy_base


func _physics_process(delta: float) -> void:
	var old_velocity = velocity
	if velocity.y < 0:
		velocity.y += Global.mods.gravity * delta
	else:
		velocity.y += Global.mods.gravity * delta * Global.mods.gravity_fall_scale
	
	var direction := Input.get_axis("move_left", "move_right")
	
	#if direction != 0:
		#energy -= Global.mods.horizontal_movement_energy_cost_per_second * delta
	
	handle_horizontal_velocity(direction, delta)

	var sideways_test_collision : KinematicCollision2D = move_and_collide(Vector2(velocity.x, 0) * delta, true)	
	if sideways_test_collision:
		if velocity.y < 0:
			velocity.y = 0
		if sideways_test_collision.get_collider() is Block:
			var block : Block =  sideways_test_collision.get_collider()
			var damage = get_damage(old_velocity.x)
			block.take_damage(damage)
			energy -= block.block_data.energy_per_hit_cost
				
		velocity.x *= -1
		
		create_y_impact_tween()
		
	
	if Input.is_action_pressed("jet_pack"):
		velocity.y = Global.mods.jet_pack_speed
		#energy -= Global.mods.jet_pack_cost_per_second * delta
	else:
		var test_collision : KinematicCollision2D = move_and_collide(Vector2(0, velocity.y) * delta, true)	

		if test_collision:
			if test_collision.get_collider() is Block:
				var block : Block =  test_collision.get_collider()
				var damage = get_damage(old_velocity.y)
				block.take_damage(damage)
				energy -= block.block_data.energy_per_hit_cost
				
			create_x_impact_tween()
			velocity.y = Global.mods.bounce_speed

	move_and_slide()
	


func get_damage(y_velocity):
	var damage = 0
	
	damage += Global.mods.damage_base
	damage += y_velocity/Global.velocity_normilization_factor * Global.mods.velocity_to_damage_scale
	
	return damage

var acceleration_ratio = .8
var deceleration_ratio =.5
var turn_speed_ratio = 1.0


func handle_horizontal_velocity(input_x_direction, delta):
	var desired_speed = input_x_direction * Global.mods.horizontal_movement_speed_base
	
	var acceleration = acceleration_ratio * Global.mods.horizontal_movement_speed_base 
	var deceleration = deceleration_ratio * Global.mods.horizontal_movement_speed_base
	var turn_speed = turn_speed_ratio * Global.mods.horizontal_movement_speed_base

	var max_speed_change = 0
	
	if input_x_direction != 0:
		if sign(input_x_direction) != sign(velocity.x):
			max_speed_change = turn_speed * delta
		else:
			max_speed_change = acceleration * delta
			
	else:
		max_speed_change = deceleration * delta

	velocity.x = move_toward(velocity.x, desired_speed, max_speed_change)
	

var y_scale_tween : Tween
func create_y_impact_tween():
	if y_scale_tween:
		y_scale_tween.kill()
	
	y_scale_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	%Art.scale.y = .9
	#y_scale_tween.tween_property(%"Art", "scale:y", .9, .05)
	y_scale_tween.tween_property(%"Art", "scale:y", 1.05, .05)
	y_scale_tween.tween_property(%"Art", "scale:y", 1, .05)
	
	
var x_scale_tween : Tween
func create_x_impact_tween():
	if x_scale_tween:
		x_scale_tween.kill()
	
	x_scale_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	#x_scale_tween.tween_property(%"Art", "scale:x", .9, .05)
	%Art.scale.x = .9
	x_scale_tween.tween_property(%"Art", "scale:x", 1.05, .05)
	x_scale_tween.tween_property(%"Art", "scale:x", 1, .05)
	
	
