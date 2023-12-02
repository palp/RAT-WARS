extends Area2D

var level = 1
var hp = 999
var damage = 5
var attack_size = 1.0
var slow = 0.1
var dot_duration = 0.1


var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var hitboxcollision = $HitBox/CollisionShape2D

signal remove_from_array(object)

func _ready():
	sprite.rotation = deg_to_rad(randf_range(0,360))
	match level:
		1:
			hp = 999
			damage = 5
			slow = 0.10
			attack_size = 1.0
			dot_duration = 2.0
		2:
			hp = 999
			damage = 7
			slow = 0.15
			attack_size = 1.2
			dot_duration = 3.0
		3:
			hp = 999
			damage = 10
			slow = 0.2
			attack_size = 1.5
			dot_duration = 4.0
		4:
			hp = 999
			damage = 15
			slow = 0.3
			dot_duration = 4.5
			
	sprite.scale = sprite.scale * attack_size
	collision.scale = collision.scale * attack_size

func _on_duration_timer_timeout():
	emit_signal("remove_from_array", self)
	queue_free()
