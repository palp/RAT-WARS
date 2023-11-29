extends PlayerState


func enter(_msg := {}) -> void:
	print_debug("entering autopilot")
	return


func physics_update(delta: float) -> void:
	#var enemies = get_tree().get_nodes_in_group("enemy")
	player.velocity = get_autopilot_velocity(player.velocity.normalized(), player.enemy_close)
	player.move_and_slide()
	player.set_facing()

	if player.autopilot == false:
		state_machine.transition_to("Idle")


func get_autopilot_velocity(dir: Vector2, enemies: Array):
	for enemy in enemies:
		var enemy_distance = enemy.global_position - player.global_position
		var enemy_distance_total = abs(enemy_distance.x) + abs(enemy_distance.y)
		if enemy_distance_total < 100:
			var enemy_dir = enemy.global_position.direction_to(player.global_position)
			dir += enemy_dir * 0.5

	if dir == Vector2(0, 0) or randf() < 0.05:
		var random_factor = Vector2(randf_range(-0.5, 0.5), randf_range(-0.5, 0.5))
		dir += random_factor

	return dir.normalized() * player.movement_speed
