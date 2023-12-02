extends Button

@onready var pause_menu = get_node("%pause_menu")
@onready var player = get_tree().get_first_node_in_group("player")

func _pressed():
	if player != null and not player.disable_pausing:
		get_tree().paused = !get_tree().paused
		pause_menu.visible = get_tree().paused

func _on_mouse_entered():	
	if player != null and not player.disable_pausing:
		player.disable_pathing_input = true
	
func _on_mouse_exited():
	if player != null and not Rect2(Vector2(), size).has_point(get_local_mouse_position()) and not player.disable_pausing:
		player.disable_pathing_input = false


func _on_player_playerdeath():
	visible = false
