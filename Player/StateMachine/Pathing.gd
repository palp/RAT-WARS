extends PlayerState

var target: Vector2


func enter(_msg := {}) -> void:
	target = _msg.target
	return


func physics_update(delta: float) -> void:
	if player.check_pathing_input():
		target = player.get_pathing_target()
	player.velocity = player.position.direction_to(target).normalized() * player.movement_speed
	if player.position.distance_to(target) > 10:
		player.move_and_slide()
	else:
		player.velocity = Vector2.ZERO

	player.set_facing(player)

	if player.check_movement_input():
		state_machine.transition_to("Moving")
	elif player.velocity == Vector2.ZERO:
		state_machine.transition_to("Idle")
