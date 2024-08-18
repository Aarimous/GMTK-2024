extends Node2D
class_name Block

var type : Global.BLOCK_TYPES:
	set(new_value):
		type = new_value
		set_type_stuff()

@export var grass_dirt_texture : Texture2D
@export var dirt_texture : Texture2D
@export var gravel_texture : Texture2D
@export var gravel_stone_texture : Texture2D
@export var stone_texture : Texture2D
@export var deep_stone_texture : Texture2D


@export var depths : Array[int]

var block_data : BlockData :
	set(new_value):
		block_data = new_value
		type = block_data.type
		max_health = block_data.health
		health = block_data.health

var max_health = 5.0
var health :
	set(new_value):
		health = new_value
		if health <= 0:
			$CollisionShape2D.disabled = true
			%Sprite.hide()
			%Sprite2.hide()
		material.set_shader_parameter("sensitivity", 1 - health/max_health)

func _ready() -> void:
	material.set_shader_parameter("seed_x", Global.rng.randi_range(-1000, 1000))
	material.set_shader_parameter("seed_y", Global.rng.randi_range(-1000, 1000))
	
	
func take_damage(amount):	
	health -= amount

	if health > 0:
		Global.money += ( block_data.money_per_hit * (1 + Global.mods.money_per_hit_scale) ) 
	else:
		Global.money += ( block_data.money_on_break * (1 + Global.mods.money_per_break_scale) )
	
func reset():
	health = max_health
	$CollisionShape2D.disabled = false
	%Sprite.show()
	%Sprite2.show()

			
func set_type_stuff():
	match type:
		Global.BLOCK_TYPES.GRASS_DIRT:
			%Sprite.texture = grass_dirt_texture
			%Sprite2.texture = grass_dirt_texture
		Global.BLOCK_TYPES.DIRT:
			%Sprite.texture = dirt_texture
			%Sprite2.texture = dirt_texture
		Global.BLOCK_TYPES.GRAVEL_DIRT:
			%Sprite.texture = gravel_texture
			%Sprite2.texture = gravel_texture
		Global.BLOCK_TYPES.GRAVEL_STONE:
			%Sprite.texture = gravel_stone_texture
			%Sprite2.texture = gravel_stone_texture
		Global.BLOCK_TYPES.STONE:
			%Sprite.texture = stone_texture
			%Sprite2.texture = stone_texture
		Global.BLOCK_TYPES.DEEP_STONE:
			%Sprite.texture = deep_stone_texture
			%Sprite2.texture = deep_stone_texture
