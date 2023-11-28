extends CharacterBody2D

enum Behavior { BASIC, BALLOON }

@export var behavior = Behavior.BASIC
@export var speed = 100
@export var explode_dist = 140
@onready var player = get_tree().get_first_node_in_group("player")

var explode_dist_sq = explode_dist * explode_dist

const Utility = preload("res://scripts/utility.gd")
var balloon_explosion = preload("res://balloon_explosion.tscn")

@onready var sprite = get_node("Sprite2D")


func hit():
	sprite.set_self_modulate(Color(1, 1, 1, 0))
	queue_free()


func balloon():
	var dist_sq = global_position.distance_squared_to(player.global_position)
	if dist_sq < explode_dist_sq:
		# Explode
		var explosion = balloon_explosion.instantiate()
		explosion.position += global_position
		add_sibling(explosion)

		hit()

	# TODO: Check whether we collided with weapon or player
	#for i in get_slide_collision_count():
	#	var collision = get_slide_collision(i)
	#	print("I collided with ", collision.get_collider().damage)


func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
	Utility.set_facing(self)

	if behavior == Behavior.BALLOON:
		balloon()
