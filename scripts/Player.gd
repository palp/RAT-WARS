extends CharacterBody2D

const SPEED = 8000

func _physics_process(delta):
	velocity.x = 0
	velocity.y = 0
	
	velocity.x = Input.get_axis("ui_left", "ui_right")
	velocity.y = Input.get_axis("ui_up", "ui_down")
	
	velocity = velocity.normalized() * delta * SPEED
	
	move_and_slide()
