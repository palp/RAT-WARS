extends PlayerState

func enter(_msg := {}) -> void:
	return

func physics_update(delta: float) -> void:
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	player.velocity = dir.normalized() * player.speed
