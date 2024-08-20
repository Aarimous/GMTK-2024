extends Node2D
class_name Block

var type : Global.BLOCK_TYPES:
	set(new_value):
		type = new_value
		set_type_stuff()

@export var grass_dirt_texture : Texture2D
@export var grass_dirt_color : Color
@export var dirt_texture : Texture2D
@export var dirt_color : Color
@export var gravel_texture : Texture2D
@export var gravel_color : Color
@export var gravel_stone_texture : Texture2D
@export var gravel_stone_color : Color
@export var stone_texture : Texture2D
@export var stone_color : Color
@export var deep_stone_texture : Texture2D
@export var deep_stone_color : Color
@export var obsidain_texture : Texture2D
@export var obsidain_color : Color


@export var ore_packed : PackedScene


#@export var depths : Array[int]

var block_data : BlockData :
	set(new_value):
		block_data = new_value
		type = block_data.type
		max_health = block_data.health
		health = block_data.health
		
var has_ore = false :
	set(new_value):
		has_ore = new_value
		%Ore.visible = has_ore
	
var max_health = 5.0
var cell : Vector2
var health :
	set(new_value):
		health = new_value
		if health <= 0:
			$CPUParticles2D.emitting = true
			$CollisionShape2D.disabled = true
			%Sprite.hide()
			%Sprite2.hide()
			%Ore.hide()
			
			if has_ore:
				for i in range(Global.mods.ore_dropped):
					var new_ore = ore_packed.instantiate()
					new_ore.global_position = global_position + Vector2(Global.rng.randi_range(-32, 32), Global.rng.randi_range(-32, 32))
					
					Global.main.ores.add_child(new_ore)
			
		material.set_shader_parameter("sensitivity", 1 - health/max_health)

func _ready() -> void:
	material.set_shader_parameter("seed_x", Global.rng.randi_range(-1000, 1000))
	material.set_shader_parameter("seed_y", Global.rng.randi_range(-1000, 1000))
	
	
func take_damage(amount, pos):	
	health -= amount
	
	#Global.main.create_text(str(int(amount)), global_position, Global.TEXT_TYPES.DAMAGE)

	if health > 0:
		#Global.main.camera_2d.shake(.2, 70, 5)
		AudioManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.ON_BLOCK_HIT)
		var money_gained = ( block_data.money_per_hit * (1 + Global.mods.money_per_hit_scale) * (1 + Global.mods.money_scale)) 
		#if has_ore :
			#money_gained *= 1 + Global.mods.ore_money_scale
		Global.money += money_gained
		Global.main.create_text(str("$", snappedf(money_gained, 0.01)), Global.get_node2d_viewport_position(self) + to_local(pos), Global.TEXT_TYPES.MONEY)
	else:
		
		Global.main.camera_2d.shake(.2, 100, 5)
		AudioManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.ON_BLOCK_BREAK)
		var money_gained = ( block_data.money_on_break * (1 + Global.mods.money_per_break_scale) * (1 + Global.mods.money_scale) )
		if has_ore :
			AudioManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.GLASS_BREAK)
			#money_gained *= 1 + Global.mods.ore_money_scale
		Global.money += money_gained
		Global.main.create_text(str("$", snappedf(money_gained, 0.01)), Global.get_node2d_viewport_position(self) + to_local(pos), Global.TEXT_TYPES.MONEY)
		
func reset():
	health = max_health
	$CollisionShape2D.disabled = false
	%Sprite.show()
	%Sprite2.show()
	has_ore = false
	%Ore.hide()
			
func set_type_stuff():
	match type:
		Global.BLOCK_TYPES.GRASS_DIRT:
			%Sprite.texture = grass_dirt_texture
			%Sprite2.texture = grass_dirt_texture
			$CPUParticles2D.modulate = grass_dirt_color
		Global.BLOCK_TYPES.DIRT:
			%Sprite.texture = dirt_texture
			%Sprite2.texture = dirt_texture
			$CPUParticles2D.modulate = dirt_color
		Global.BLOCK_TYPES.GRAVEL_DIRT:
			%Sprite.texture = gravel_texture
			%Sprite2.texture = gravel_texture
			$CPUParticles2D.modulate = gravel_color
		Global.BLOCK_TYPES.GRAVEL_STONE:
			%Sprite.texture = gravel_stone_texture
			%Sprite2.texture = gravel_stone_texture
			$CPUParticles2D.modulate = gravel_stone_color
		Global.BLOCK_TYPES.STONE:
			%Sprite.texture = stone_texture
			%Sprite2.texture = stone_texture
			$CPUParticles2D.modulate = stone_color
		Global.BLOCK_TYPES.DEEP_STONE:
			%Sprite.texture = deep_stone_texture
			%Sprite2.texture = deep_stone_texture
			$CPUParticles2D.modulate = deep_stone_color
		Global.BLOCK_TYPES.OBSIDIAN:
			%Sprite.texture = obsidain_texture
			%Sprite2.texture = obsidain_texture
			$CPUParticles2D.modulate = obsidain_color
