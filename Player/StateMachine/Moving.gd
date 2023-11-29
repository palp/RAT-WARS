extends PlayerState


func enter(_msg := {}) -> void:
	return


func physics_update(delta: float) -> void:
	player.velocity = get_input_velocity()

	if player.velocity == Vector2.ZERO:
		state_machine.transition_to("Idle")
	else:
		player.move_and_slide()
		player.set_facing()


func get_input_velocity():
	var dir = player.get_movement_vector()
	return dir.normalized() * player.movement_speed
