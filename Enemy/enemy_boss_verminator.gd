extends EnemyBase

func _physics_process(delta):
	var distance = global_position.distance_to(player.global_position)
	if distance < 100 and anim.current_animation == "walk":
		anim.play("attack")
	elif anim.current_animation == "attack":
		anim.play("walk")
	
