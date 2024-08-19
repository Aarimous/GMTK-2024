extends CharacterBody2D
class_name Player

@export var is_active = true

var is_momementum_active = false
var momementum_damage

#energy == health 
var energy : float :
	set(new_value):
		if is_active:
			#var diff = energy - new_value
			#if diff > 0:
			#	Global.main.create_text(str(snappedf(diff, 0.1)), Global.get_node2d_viewport_position(self), Global.TEXT_TYPES.DAMAGE)
			energy = new_value
			Global.energy_changed.emit(energy)
			
			if energy <= 0:
				Global.main.end_run()
		

func _ready():
	energy = Global.mods.energy_base * (1 + Global.mods.health_scale)


func _physics_process(delta: float) -> void:
	
	
	var has_delt_damage = false
	var has_played_wall_audio = false
	var particles_check = Global.mods.horizontal_movement_speed_base/Global.velocity_normilization_factor * 8
	
	var old_velocity = velocity
	if velocity.y < 0:
		velocity.y += Global.mods.gravity * delta
	else:
		velocity.y += Global.mods.gravity * delta * Global.mods.gravity_fall_scale
	
	var direction := Input.get_axis("move_left", "move_right")
	
	#if direction != 0:
		#%"Particle Pivot".rotation_degrees = -180 if direction == 1 else 0
		##if %CPUParticles2D.emitting == false:
			##%CPUParticles2D.amount = Global.mods.horizontal_movement_speed_base/Global.velocity_normilization_factor * 8
			##%CPUParticles2D.emitting = true
			
	#else:
		#%CPUParticles2D.emitting = false
		#energy -= Global.mods.horizontal_movement_energy_cost_per_second * delta
	
	handle_horizontal_velocity(direction, delta)

	var sideways_test_collision : KinematicCollision2D = move_and_collide(Vector2(velocity.x, 0) * delta, true)	
	if sideways_test_collision:
		if velocity.y < 0:
			velocity.y = 0
		var collider = sideways_test_collision.get_collider()
		if collider and collider is Block:
			var block : Block =  sideways_test_collision.get_collider()
			var damage = get_damage(old_velocity.x)
			has_delt_damage = true
			block.take_damage(damage, sideways_test_collision.get_position())
			energy -= block.block_data.energy_per_hit_cost
		elif collider and has_played_wall_audio == false:
			AudioManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.ON_WALL_HIT)
			has_played_wall_audio = true
		velocity.x *= -1
		create_x_impact_tween()
		create_eye_impact_tween()
		
	
	if Global.mods.down_trust_speed > 0.0:
		if Input.is_action_pressed("move_down"):
			%"Outside Outline".modulate = Color.DARK_RED
			is_momementum_active = true
			if velocity.y > 0:
				velocity.y += Global.mods.down_trust_speed * delta
			#$"Thurst Parts".emitting = true
		else:
			%"Outside Outline".modulate = Color.WHITE
			is_momementum_active = false
			#$"Thurst Parts".emitting = false
		
		
	#if Input.is_action_pressed("jet_pack"):
		#velocity.y = Global.mods.jet_pack_speed
		##energy -= Global.mods.jet_pack_cost_per_second * delta
	#else:
	var test_collision : KinematicCollision2D = move_and_collide(Vector2(0, velocity.y) * delta, true)	

	if test_collision:
		var collider = test_collision.get_collider()
		if collider and collider is Block:
			if has_delt_damage == false:
				var block : Block =  test_collision.get_collider()
				
				var damage = get_damage(old_velocity.y)
				
				if is_momementum_active:
					if momementum_damage == null:
						momementum_damage = damage
					else:
						damage = momementum_damage
				
				#var damage_overkill = damage - block.health
				
			
				if momementum_damage != null:
					momementum_damage -= block.health
				
				block.take_damage(damage, test_collision.get_position())
				
				if is_momementum_active:
					energy -= block.block_data.energy_per_hit_cost * 2.0
				else:
					energy -= block.block_data.energy_per_hit_cost
				
			if is_momementum_active == false or (is_momementum_active and momementum_damage != null and momementum_damage <= 0) or is_active == false:
				momementum_damage = null
				velocity.y = Global.mods.bounce_speed
				
		elif collider:
			
			velocity.y = Global.mods.bounce_speed
			
			if has_played_wall_audio == false:
				AudioManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.ON_WALL_HIT)
				has_played_wall_audio = true
			
			
		create_y_impact_tween()
		create_eye_impact_tween()
		


	
	move_and_slide()
	


func get_damage(y_velocity):
	var damage = 0
	
	damage += Global.mods.damage_base
	damage += y_velocity/Global.velocity_normilization_factor * Global.mods.velocity_to_damage_scale
	
	damage *= (1 + Global.mods.damage_scale)
	
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
	
	y_scale_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	%Art.scale = Vector2(1.15, .8)
	%Art.position.y = 50
	
	
	#y_scale_tween.tween_property(%"Art", "scale:y", .9, .05)
	y_scale_tween.tween_property(%"Art", "scale", Vector2(.85,1.15), .15)
	y_scale_tween.parallel().tween_property(%"Art", "position:y", 0, .15)
	y_scale_tween.tween_property(%"Art", "scale", Vector2.ONE, .15)
	
	
var x_scale_tween : Tween
func create_x_impact_tween():
	if x_scale_tween:
		x_scale_tween.kill()
	
	x_scale_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	#x_scale_tween.tween_property(%"Art", "scale:x", .9, .05)
	%Art.scale.x = .8
	#%Art.position.x = 
	x_scale_tween.tween_property(%"Art", "scale:x", 1.05, .2)
	x_scale_tween.tween_property(%"Art", "scale:x", 1, .05)
	
	
var tween_eyes : Tween
func create_eye_impact_tween():
	if tween_eyes:
		tween_eyes.kill()
	tween_eyes = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tween_eyes.tween_method(
	  func(value): 
		%"Eye Pivot".material.set_shader_parameter("crop_top", value)
		%"Eye Pivot".material.set_shader_parameter("crop_bottom", value),
		  0.0,  # Start value
		  1.0,  # End value
		  .075  # Duration
		).set_ease(Tween.EASE_OUT)
		
	#tween_eyes.chain().tween_method(
	  #func(value): 
		#%"Eye Pivot".material.set_shader_parameter("crop_top", value)
		#%"Eye Pivot".material.set_shader_parameter("crop_bottom", value),
		  #1.0,  # Start value
		  #0.67,  # End value
		  #.1  # Duration
		#).set_ease(Tween.EASE_OUT)
		#
	#tween_eyes.chain().tween_method(
	  #func(value): 
		#%"Eye Pivot".material.set_shader_parameter("crop_top", value)
		#%"Eye Pivot".material.set_shader_parameter("crop_bottom", value),
		  #.67,  # Start value
		  #1.0,  # End value
		  #.1  # Duration
		#).set_ease(Tween.EASE_OUT)
		
	tween_eyes.chain().tween_method(
	  func(value): 
		%"Eye Pivot".material.set_shader_parameter("crop_top", value)
		%"Eye Pivot".material.set_shader_parameter("crop_bottom", value),
		  1.0,  # Start value
		  0.0,  # End value
		  .15  # Duration
		).set_ease(Tween.EASE_IN)

		


func _on_loot_range_body_entered(body: Node2D) -> void:
	if body is Ore:
		body.on_pick_up()
