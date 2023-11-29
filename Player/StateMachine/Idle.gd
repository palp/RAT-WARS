extends PlayerState


func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO


func update(delta: float) -> void:
	if player.autopilot == true:
		state_machine.transition_to("Autopilot")

	elif player.check_movement_input():
		state_machine.transition_to("Moving")
	elif player.check_pathing_input():
		state_machine.transition_to("Pathing", {"target": player.get_pathing_target()})
	# conditional for if we've leveled up goes here
