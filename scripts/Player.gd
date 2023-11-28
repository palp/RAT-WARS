class_name Player
extends CharacterBody2D

@export var base_health = 100
@export var damage_per_hit = 10
@export var invincibility_frames = 20

var health = base_health
var invincibility = 0

@export var speed = 200
@export var autopilot = true

const Utility = preload("res://scripts/utility.gd")


func _physics_process(delta):
	if health <= 0:
		return

	move_and_slide()
	Utility.set_facing(self)
	var sprite = get_node("Sprite2D")
	if invincibility > 0:
		invincibility -= 1
		if invincibility % 3 == 0 and invincibility > 0:
			sprite.set_self_modulate(Color(1, 1, 1, 0))
		else:
			sprite.set_self_modulate(Color(1, 1, 1, 1))
		return

	if get_slide_collision_count() > 0:
		invincibility = invincibility_frames
		health -= damage_per_hit
		var alpha = 1
		if health <= 0:
			alpha = 0
		sprite.set_self_modulate(Color(1, 0, 0, alpha))

	#for i in get_slide_collision_count():
	#	var collision = get_slide_collision(i)
	#	print("I collided with ", collision.get_collider().damage)

#func get_input_velocity():
#	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
#	return dir.normalized() * speed
