extends Node2D
class_name Cave

@onready var tile_map_layer: TileMapLayer = %TileMapLayer

var damaged_tiles = {}


func damage_tile_by_RID(rid : RID, damage_amount):
	var cell = tile_map_layer.get_coords_for_body_rid(rid)
	if cell != null:
		return damage_tile_at_cell(cell, damage_amount)


func damage_tile_at_cell(cell : Vector2i, damage_amount):
	var tile_data : TileData = tile_map_layer.get_cell_tile_data(cell)
	if tile_data != null:
		var current_tile_health = tile_data.get_custom_data("tile_health") if !damaged_tiles.has(cell) else damaged_tiles[cell]
		var new_health = max(0, current_tile_health - damage_amount)
		
		if new_health <= 0:
			var money_gain = tile_data.get_custom_data("money")
			Global.money += money_gain
			
			clear_cell(cell)
		else:
			damaged_tiles[cell] = new_health


func clear_cell(cell):
	damaged_tiles.erase(cell)
	tile_map_layer.erase_cell(cell)
