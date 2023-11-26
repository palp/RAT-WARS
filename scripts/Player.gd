extends CharacterBody2D

@export var speed = 200

func _physics_process(delta):
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = dir.normalized() * speed
	
	move_and_slide()
