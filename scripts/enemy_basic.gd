extends CharacterBody2D

@export var speed = 100
@onready var player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
