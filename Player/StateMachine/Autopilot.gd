extends PlayerState

func enter(_msg := {}) -> void:
	print_debug("entering autopilot")
	return

func physics_update(delta: float) -> void:
	player.velocity = get_autopilot_velocity(player.velocity.normalized(), player.enemy_close)
	player.move_and_slide()
	player.set_facing()

	if player.autopilot == false:
		state_machine.transition_to("Idle")


func get_autopilot_velocity(dir: Vector2, enemies: Array):

	if player.autopilot_bounds.size.y > 0:
		var distance_to_top = player.global_position.y - player.autopilot_bounds.position.y
		var distance_to_bottom = (player.autopilot_bounds.position.y + player.autopilot_bounds.size.y) - player.global_position.y
		if distance_to_top < 50:
			dir += Vector2(0, 1)
		elif distance_to_bottom < 50:
			dir += Vector2(0, -1)

	for enemy in enemies:
		var enemy_distance = enemy.global_position - player.global_position
		var enemy_distance_total = abs(enemy_distance.x) + abs(enemy_distance.y)
		var enemy_distance_threshold = 200
		if enemy.enemy_name == "small_rat":
			enemy_distance_threshold = 150
		elif enemy.enemy_name == "boss_verminator":
			enemy_distance_threshold = 250
		if enemy_distance_total < enemy_distance_threshold:
			var enemy_dir = enemy.global_position.direction_to(player.global_position)
			dir += enemy_dir * (enemy_distance_total / enemy_distance_threshold) * 0.5

	if randf() < 0.05:
		var random_factor = Vector2(randf_range(-0.5, 0.5), randf_range(-0.5, 0.5))
		dir += random_factor

	return dir.normalized() * player.movement_speed
