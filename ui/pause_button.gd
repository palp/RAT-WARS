extends Button

@onready var pause_menu = get_node("%pause_menu")

func _pressed():
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused
