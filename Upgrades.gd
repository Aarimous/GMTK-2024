extends CanvasLayer
class_name UpgradeScreen


var upgrade_dict = {}



func _ready():
	for upgrade in %Upgrades.get_children():
		if upgrade is Upgrade:
			upgrade_dict[upgrade.type] = upgrade
			
	load_upgrades_data()
	
	for upgrade in %Upgrades.get_children():
		if upgrade is Upgrade:
			upgrade.current_tier = 0
		
		
func load_upgrades_data():
	var json_data = Global.load_json_data_from_path("res://Data/GMTK 2024 UPGRADES - Sheet1.json")
	if json_data != null:
		for i in range(0, json_data.size()):
			parse_upgrade_teir_from_json(i, json_data[str(i)])


func parse_upgrade_teir_from_json(id, json_data : Dictionary):
	#print(id, " : ", json_data)
	
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
		


func _on_start_new_run_button_up() -> void:
	Global.main.start_run()
