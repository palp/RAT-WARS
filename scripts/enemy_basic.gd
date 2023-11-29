extends CharacterBody2D

enum Behavior { BASIC, BALLOON }

@export var behavior = Behavior.BASIC
@export var health = 40
@export var speed = 100
@export var knockback_recovery = 3.5
var knockback = Vector2.ZERO
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

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	velocity += knockback
	move_and_slide()
	Utility.set_facing(self)

	if behavior == Behavior.BALLOON:
		balloon()


func _on_hurt_box_hurt(damage, angle, knockback_amount):
	health -= damage
	knockback = angle * knockback_amount
	if health <= 0:
		queue_free()
	
