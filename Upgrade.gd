extends PanelContainer
class_name Upgrade

@export var type : Global.UPGRADE_TYPES

var next_increase = 10

var tiers : Array[UpgradeTier]
var current_tier : int :
	set(new_value):
		if new_value < tiers.size():
			current_tier = new_value
			current_upgrade_tier = tiers[current_tier]
			update_buy_button()
		else:
			%Buy.disabled = true
			%"Fully Upgraded".show()
			%"Cost Text".hide()
			%Buy.hide()
			%"Next Upgrade".hide()
		
		update_ui()
		
		
var current_upgrade_tier : UpgradeTier

func _ready():
	%Type.text = Global.UPGRADE_TYPES.keys()[type]
	Global.money_changed.connect(_on_money_changed)
	
func _on_money_changed(new_value):
	update_buy_button()
	
	
func update_buy_button():
	if current_upgrade_tier and current_upgrade_tier.money_cost <= Global.money:
		%Buy.disabled = false
	else:
		%Buy.disabled = true


func _on_buy_button_up() -> void:
	Global.money -= current_upgrade_tier.money_cost
	Global.mods.apply_upgrade_tier(current_upgrade_tier)
	current_tier += 1
		
func update_ui():
	var upgrade_tier : UpgradeTier = tiers[current_tier]
	%"Next Upgrade".text = str("+", upgrade_tier.increase_amount)
	%Tiers.text = str(current_tier + 1, "/", tiers.size())
	%"Cost Text".text = str("Cost: $",upgrade_tier.money_cost)
	
	
