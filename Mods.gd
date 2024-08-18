extends Node
class_name Mods

var gravity = 1000
var gravity_fall_scale = 2.0


var horizontal_movement_speed_base = 100
var horizontal_movement_energy_cost_per_second = 1.0

var damage_base = 1.0
var velocity_to_damage_scale = 0.0

var bounce_speed = -500
var bounce_energy_cost = 1.0

var jet_pack_speed = -100
var jet_pack_cost_per_second = 1.0


#6
var energy_base = 6



func apply_upgrade_tier(upgrade_tier : UpgradeTier):
	match upgrade_tier.type:
		Global.UPGRADE_TYPES.DAMAGE_BASE:
			damage_base += upgrade_tier.increase_amount
		Global.UPGRADE_TYPES.ENERGY_BASE:
			energy_base += upgrade_tier.increase_amount
		Global.UPGRADE_TYPES.MOVEMENT_SPEED_BASE:
			horizontal_movement_speed_base += upgrade_tier.increase_amount
