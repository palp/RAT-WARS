extends Area2D

var level = 1
var damage = 5
var knockback_amount = 100

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var animationPlayer = $Sprite2D/AnimationPlayer
signal remove_from_array(object)

func _ready():
	animationPlayer.play("new_animation")
	match level:
		1: 
			damage = 10
			knockback_amount = 150
		2: 
			damage = 10
			knockback_amount = 150
		3:
			damage = 15
			knockback_amount = 150
		4:
			damage = 15
			knockback_amount = 150
	angle = player.position.direction_to(target)
	global_position = target	
	
