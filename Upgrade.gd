extends Control
class_name Upgrade

@export var type : Global.UPGRADE_TYPES

var next_increase = 10
var cell : Vector2

signal upgrade_tier_purchased(cell)

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

var is_locked :
	set(new_value):
		is_locked = new_value
		
		if is_locked:
			%Locked.show()
			
			%Tiers.hide()
			%Type.hide()
			%"Next Upgrade".hide()
			%Buy.hide()
			%"Cost Text".hide()
			
			
		else:
			%Locked.hide()
			
			%Tiers.show()
			%Type.show()
			%"Next Upgrade".show()
			%Buy.show()
			%"Cost Text".show()
			

	

func _ready():
	%Type.text = tr(Global.UPGRADE_TYPES.keys()[type])
	Global.money_changed.connect(_on_money_changed)
	
func _on_money_changed(new_value):
	update_buy_button()
	
	
func update_buy_button():
	if current_upgrade_tier and current_upgrade_tier.money_cost <= Global.money:
		%Buy.disabled = false
		modulate.v = 1.0
		z_index = 1
		if is_locked:
			is_locked = false
	else:
		z_index = 0
		modulate.v = .5
		%Buy.disabled = true


func _on_buy_button_up() -> void:
	Global.money -= current_upgrade_tier.money_cost
	Global.mods.apply_upgrade_tier(current_upgrade_tier)
	current_tier += 1
	
	upgrade_tier_purchased.emit(cell)
		
func update_ui():
	var upgrade_tier : UpgradeTier = tiers[current_tier]
	
	if type in Global.percent_based_upgrades:
		%"Next Upgrade".text = str("+", upgrade_tier.increase_amount * 100.0, "%")
	elif type in Global.speed_based_upgrades:
		%"Next Upgrade".text = str("+", upgrade_tier.increase_amount / Global.velocity_normilization_factor, " m/s")
	else:
		%"Next Upgrade".text = str("+", upgrade_tier.increase_amount)
	
	
	
	%Tiers.text = str(current_tier + 1, "/", tiers.size())
	%"Cost Text".text = str("$",upgrade_tier.money_cost)
	
	
