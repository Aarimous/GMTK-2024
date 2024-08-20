extends Node2D
class_name Cave


@export var ore_noise : FastNoiseLite

#@onready var tile_map_layer: TileMapLayer = %TileMapLayer
#@export var tile_dissolve_shader_material : ShaderMaterial


@export var block_packed : PackedScene

var block_datas = {}

var damaged_tiles = {}


func _ready() -> void:
	load_block_datas()
	var current_y = 0 
	
	#return
	for block_data : BlockData in block_datas.values():
		for block_layer in range(block_data.layer_size):
			for x in range(-4, 5):
				var cell =  Vector2(x,current_y)
				var new_block : Block = block_packed.instantiate()
				new_block.cell = cell 
				%Blocks.add_child(new_block)
				new_block.block_data = block_data
				new_block.global_position = cell * 128 + Vector2(64, 0)
			current_y += 1
		
	#for y in range(0, 100):
		#for x in range(-4, 5):
			#var new_block : Block = block_packed.instantiate()
			#block_data = block_data
			#add_child(new_block)
			#new_block.global_position = Vector2(x,y) * 128 + Vector2(64, 0)
			

func reset_cave():

	ore_noise.seed = Global.rng.randi()
	
	for block in %Blocks.get_children():
		block.reset()
 
		if block.cell.y != 0:
			if abs(ore_noise.get_noise_2dv(block.cell)) >= .40:
				block.has_ore = true
			else:
				block.has_ore = false
		
		
func load_block_datas():
	var json_data = Global.load_json_data_from_path("res://Data/GMTK 2024 BLOCK DATA - Sheet1.json")
	if json_data != null:
		for i in range(0, json_data.size()):
			parse_upgrade_teir_from_json(i, json_data[str(i)])


func parse_upgrade_teir_from_json(id, json_data : Dictionary):
	var new_block_data = BlockData.new()
	
	new_block_data.type = Global.BLOCK_TYPES.get(json_data["BLOCK_TYPE"])
	new_block_data.health = float(json_data["HEALTH"])
	new_block_data.layer_size = float(json_data["LAYER_SIZE"])
	new_block_data.energy_per_hit_cost = float(json_data["ENERGY_PER_HIT_COST"])
	new_block_data.money_per_hit = float(json_data["MONEY_PER_HIT"])
	new_block_data.money_on_break = float(json_data["MONEY_ON_BREAK"])

	block_datas[new_block_data.type] = new_block_data

#BLOCK_TYPE	HEALTH	SPAWN_DEPTH	ENERGY_PER_HIT_COST	MONEY_PER_HIT	MONEY_ON_BREAK
#func damage_tile_by_RID(rid : RID, damage_amount):
	#var cell = tile_map_layer.get_coords_for_body_rid(rid)
	#if cell != null:
		#return damage_tile_at_cell(cell, damage_amount)
#
#
#func damage_tile_at_cell(cell : Vector2i, damage_amount):
	#var tile_data : TileData = tile_map_layer.get_cell_tile_data(cell)
	#if tile_data != null:
		#var tile_max_health = tile_data.get_custom_data("tile_health")
		#var current_tile_health = tile_max_health if !damaged_tiles.has(cell) else damaged_tiles[cell]
		#var new_health = max(0, current_tile_health - damage_amount)
		#
		#if new_health <= 0:
			#var money_gain = tile_data.get_custom_data("money")
			#Global.money += money_gain
			#
			#clear_cell(cell)
		#else:
			#damaged_tiles[cell] = new_health
			#if tile_data.material == null:
				#tile_data.material = tile_dissolve_shader_material
			#tile_data.material.set_shader_parameter("dissolve_value", float(new_health)/float(tile_max_health) )
#
			#
			#
	#
#
#
#func clear_cell(cell):
	#damaged_tiles.erase(cell)
	#tile_map_layer.erase_cell(cell)
