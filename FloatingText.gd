extends Control

var duration
var start_position

@export var money_color : Color
@export var damage_color : Color
var type


func init(_text : String, _duration : float, _parent_global_pos : Vector2, _type : Global.TEXT_TYPES):
	$Label.text = _text
	type = _type
	duration = _duration
	start_position = _parent_global_pos
	
	match type:
		Global.TEXT_TYPES.MONEY:
				$Label.add_theme_color_override("font_color", money_color)
		Global.TEXT_TYPES.DAMAGE:
				$Label.add_theme_color_override("font_color", damage_color)
	

	return self
	
func _ready():
	match type:
		Global.TEXT_TYPES.MONEY:
			handle_money()
		Global.TEXT_TYPES.DAMAGE:
			handle_damage()
	
	
	
func handle_money():

	global_position = start_position
	
	var target_post = Global.main.money.global_position + Vector2(0, Global.main.money.size.y) + $Label.size/2.0
	var target_post2 = Global.main.money.global_position + Vector2($Label.size.x/2.0, Global.main.money.size.y/2.0)
	
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position:y", position.y - 16, duration)
	tween.parallel().tween_property(self, "scale", Vector2.ONE, duration/2).from(Vector2(.5,.5))
	tween.tween_property(self, "position", target_post, duration/2)
	tween.tween_interval(duration/2)
	tween.tween_property(self, "position", target_post2, duration/3)
	tween.parallel().tween_property(self, "scale", Vector2(.5,.5), duration/3)
	#tween.parallel().tween_property(self, "modulate:a", 0, duration/2)
	tween.tween_callback(queue_free)


func handle_damage():
	global_position = start_position

	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	#tween.tween_property(self, "position:x", position.x + 16, duration/2)
	tween.tween_property(self, "scale", Vector2.ONE, duration/2).from(Vector2(.5,.5))
	tween.tween_interval(duration/2)
	#tween.tween_property(self, "position", position + Vector2(100, -128), duration/2)
	#tween.tween_property(self, "position:y", position.y + -128 + -16, duration)
	
	tween.tween_callback(queue_free)
