extends Node
class_name Mods

var gravity = 1000
var gravity_fall_scale = 2.0


var horizontal_movement_speed_base = 100
var horizontal_movement_energy_cost_per_second = 1.0

#1
var damage_base = 1.0
var damage_scale = 0.0
var health_scale = 0.0
var velocity_to_damage_scale = 0.0

var bounce_speed = -500
var bounce_energy_cost = 1.0

var ore_money_scale = 0.0
var ore_pickup_money_base = .25
var ore_dropped = 1

var money_scale = 0.0

var jet_pack_speed = 0
var jet_pack_cost_per_second_base = 1.0

var money_per_hit_scale = 0.0
var money_per_break_scale = 0.0


var down_trust_speed = 0.0

#4.2
var energy_base = 4.2



func apply_upgrade_tier(upgrade_tier : UpgradeTier):
	match upgrade_tier.type:
		Global.UPGRADE_TYPES.DAMAGE_BASE:
			damage_base += upgrade_tier.increase_amount
		Global.UPGRADE_TYPES.ENERGY_BASE:
			energy_base += upgrade_tier.increase_amount
		Global.UPGRADE_TYPES.MOVEMENT_SPEED_BASE:
			horizontal_movement_speed_base += upgrade_tier.increase_amount
		Global.UPGRADE_TYPES.MONEY_ON_HIT_SCALE:
			money_per_hit_scale += upgrade_tier.increase_amount
		Global.UPGRADE_TYPES.MONEY_ON_BREAK_SCALE:
			money_per_break_scale += upgrade_tier.increase_amount
		Global.UPGRADE_TYPES.JETPACK_SPEED:
			jet_pack_speed += upgrade_tier.increase_amount
		Global.UPGRADE_TYPES.VELOCITY_TO_DAMAGE_SCALE:
			velocity_to_damage_scale += upgrade_tier.increase_amount
		Global.UPGRADE_TYPES.DAMAGE_SCALE:
			damage_scale += upgrade_tier.increase_amount
		Global.UPGRADE_TYPES.HEALTH_SCALE:
			health_scale += upgrade_tier.increase_amount
		Global.UPGRADE_TYPES.DOWN_THRUST_SPEED:
			down_trust_speed += upgrade_tier.increase_amount
		Global.UPGRADE_TYPES.ORE_DROPPED:
			ore_dropped += upgrade_tier.increase_amount
		Global.UPGRADE_TYPES.ORE_MONEY_BASE:
			ore_pickup_money_base += upgrade_tier.increase_amount
		Global.UPGRADE_TYPES.ORE_MONEY_SCALE:
			ore_money_scale += upgrade_tier.increase_amount
		Global.UPGRADE_TYPES.MONEY_SCALE:
			money_scale += upgrade_tier.increase_amount
