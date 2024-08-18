extends Label

func _ready() -> void:
	Global.money_changed.connect(_on_money_changed)
	_on_money_changed(Global.money)

func _on_money_changed(new_value):
	text = str("$", Global.money)
