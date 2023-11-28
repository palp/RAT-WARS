extends PlayerState

func enter(_msg := {}) -> void:
	return

func physics_update(delta: float) -> void:
	player.velocity = get_input_velocity()
	
	if(player.velocity == Vector2.ZERO):
		state_machine.transition_to("Idle")
	
func get_input_velocity():
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	return dir.normalized() * player.speed
