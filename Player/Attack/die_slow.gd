extends Area2D

var level = 1
var hp = 999
var speed = 150.0
var damage = 0
var attack_size = 1.0
var knockback_amount = 0

var target = Vector2.ZERO

@onready var angle = global_position.direction_to(target)

var puddle = preload("res://Player/Attack/die_slow_puddle.tscn")

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

signal remove_from_array(object)

func _physics_process(delta):	
	if angle.angle() >= 0:
		rotation += .08
	if angle.angle() < 0:
		rotation -= .08
	position += angle.normalized() * speed * delta


func _on_flight_duration_timer_timeout():	
	var puddle_attack = puddle.instantiate()
	puddle_attack.position = global_position
	puddle_attack.level = level
	puddle_attack.remove_from_array.connect(_on_remove_from_array)
	add_child(puddle_attack)
	sprite.hide()
	

func _on_remove_from_array(obj):
	if get_child_count() <= 1:
		emit_signal("remove_from_array", self)
		queue_free()
