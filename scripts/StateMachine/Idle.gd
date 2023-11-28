extends PlayerState

func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	
func update(delta:float) -> void:
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left"):
		state_machine.transition_to("Moving")
	# conditional for if we've leveled up goes here
