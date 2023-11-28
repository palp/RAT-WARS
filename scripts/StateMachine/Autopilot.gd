extends PlayerState


func enter(_msg := {}) -> void:
	return


func physics_update(delta: float) -> void:
	if player.autopilot == false:
		state_machine.transition_to("Idle")
