extends Area2D


@export var damage = 1
@onready var collision = $CollisionShape2D
@onready var disableTimer = $disableHitBoxTimer

func temp_disable():
	collision.call_deferred("set_disabled", true)
	disableTimer.start()
	


func _on_disable_hit_box_timer_timeout():
	collision.call_deferred("set_disabled", false)
