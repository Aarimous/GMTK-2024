extends CanvasLayer
class_name UpgradeScreen


var upgrade_dict = {}
@export var upgrade_packed : PackedScene

var upgrades = [
	Global.UPGRADE_TYPES.DAMAGE_BASE, 
	Global.UPGRADE_TYPES.MOVEMENT_SPEED_BASE,
	Global.UPGRADE_TYPES.ENERGY_BASE, 
	Global.UPGRADE_TYPES.MONEY_ON_BREAK_SCALE,
	Global.UPGRADE_TYPES.ORE_DROPPED,
	Global.UPGRADE_TYPES.VELOCITY_TO_DAMAGE_SCALE,
	Global.UPGRADE_TYPES.MONEY_ON_HIT_SCALE,
	Global.UPGRADE_TYPES.ORE_MONEY_SCALE,
	Global.UPGRADE_TYPES.HEALTH_SCALE,
	Global.UPGRADE_TYPES.DOWN_THRUST_SPEED,
	Global.UPGRADE_TYPES.ORE_MONEY_BASE,
	Global.UPGRADE_TYPES.DAMAGE_SCALE,
	Global.UPGRADE_TYPES.MONEY_SCALE,
	
	
]

#var cell_to_upgrades = {}

var upgrade_cells = [
	Vector2(0,0), 
	Vector2(1,0), 
	Vector2(0,1), 
	Vector2(-1,1), 
	Vector2(-1,0), 
	Vector2(0,-1), 
	Vector2(1,-1),
	Vector2(-2,0),
	Vector2(1,1),
	Vector2(2,0),
	Vector2(-2,1),
	Vector2(-1,-1),
	Vector2(2,-1),
	] 


func _on_upgrade_tier_purchased(cell):
	pass
	#for neb_cell in Global.hex_util.neighbors_vectors:
		#if cell_to_upgrades.has(cell + neb_cell):
			#cell_to_upgrades[cell + neb_cell].is_locked = false


func _ready():
	on_run_ended()
	#for upgrade in %Upgrades.get_children():
		#if upgrade is Upgrade:
			#upgrade_dict[upgrade.type] = upgrade
			#
	
	#
	#for upgrade in %Upgrades.get_children():
		#if upgrade is Upgrade:
			#upgrade.current_tier = 0
	#
	
	for index in range(upgrades.size()):
		var new_upgrade : Upgrade = upgrade_packed.instantiate()
		new_upgrade.type = upgrades[index]
		%Upgrades.add_child(new_upgrade)
		
		if index == 0:
			new_upgrade.is_locked = false
		else:
			new_upgrade.is_locked = true
		
		var cell = upgrade_cells[index]
		new_upgrade.cell = cell
		new_upgrade.position = Global.hex_util.cell_to_pointy_pixel(cell) - new_upgrade.size/2.0
		#cell_to_upgrades[cell] = new_upgrade
		upgrade_dict[new_upgrade.type] = new_upgrade
		
		new_upgrade.upgrade_tier_purchased.connect(_on_upgrade_tier_purchased)
	
	load_upgrades_data()
	
	for upgrade in %Upgrades.get_children():
		if upgrade is Upgrade:
			upgrade.current_tier = 0
	
	
		
func load_upgrades_data():
	var json_data = Global.load_json_data_from_path("res://Data/GMTK 2024 UPGRADES - Sheet1.json")
	if json_data != null:
		for i in range(0, json_data.size()):
			parse_upgrade_teir_from_json(i, json_data[str(i)])
			

func on_run_ended():
	$Player.set_physics_process(true)
	$Player.position = %"Player Position".position
	
func on_run_started():
	$Player.set_physics_process(false)
	



func parse_upgrade_teir_from_json(id, json_data : Dictionary):
	print(id, " : ", json_data)
	#print("json_data ", )
	var upgrade_tier = UpgradeTier.new()
	
	upgrade_tier.type = Global.UPGRADE_TYPES.get(json_data["UPGRADE_TYPE"])
	upgrade_tier.tier = int(json_data["TIER"])
	upgrade_tier.money_cost = int(json_data["MONEY_COST"])
	upgrade_tier.increase_amount = float(json_data["INCREASE_VALUE"])
	
	if upgrade_dict.has(upgrade_tier.type):
		var upgrade : Upgrade = upgrade_dict[upgrade_tier.type]
		upgrade.tiers.append(upgrade_tier)
		
	else:
		push_warning("Yo: parse_upgrade_teir_from_json failed to find the upgrade for ", upgrade_tier)
		


func _on_play_button_up() -> void:
	Global.main.start_run()
