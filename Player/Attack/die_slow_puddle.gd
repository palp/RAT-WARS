extends Area2D

var level = 1
var hp = 999
var speed = 0
var damage = 2
var attack_size = 1.0
var knockback_amount = 0

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

signal remove_from_array(object)

func _ready():
	print_debug("Puddle ready, position " + str(position))

func _on_duration_timer_timeout():
	emit_signal("remove_from_array", self)
	queue_free()
