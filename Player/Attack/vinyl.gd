extends Area2D

var level = 1
var hp = 999
var speed = 150.0
var damage = 10
var attack_size = 1.0
var knockback_amount = 100

var target = Vector2.ZERO

var angle = Vector2.ZERO
var reset_pos = Vector2.ZERO

#var sprt = preload("res://assets/player/attacks/vinyl.png")

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var changeDirectionTimer = get_node("ChangeDirection")
@onready var resetPost = get_node("ResetPosTimer")

signal remove_from_array(object)


func _ready():
	angle = global_position.direction_to(target)
	match level:
		1:
			hp = 9999
			speed = 150.0
			damage = 10
			knockback_amount = 100
			attack_size = 1.0
		2:
			hp = 9999
			speed = 100.0
			damage = 15
			knockback_amount = 100
			attack_size = 1.0
		3:
			hp = 9999
			speed = 100.0
			damage = 20
			knockback_amount = 100
			attack_size = 1.0
		4:
			hp = 9999
			speed = 100.0
			damage = 25
			knockback_amount = 125
			attack_size = 1.0


func _physics_process(delta):
	if angle.angle() >= 0:
		rotation += .1
	if angle.angle() < 0:
		rotation -= .1
	position += angle.normalized() * speed * delta

func _on_flight_duration_timeout():
	if level < 8:
		queue_free()


func _on_change_direction_timeout():
	angle = angle.rotated(PI)
	angle = angle.normalized()
