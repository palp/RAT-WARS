extends Area2D

@export var lifetime = 0.5

@onready var remaining_life = lifetime
@onready var is_new = true

func _physics_process(delta):
	# Only hit on the first frame
	if not is_new:
		return
	is_new = false
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if "hit" in body:
			body.hit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	remaining_life -= delta
	var alpha = remaining_life / lifetime
	
	var sprite = get_node("Sprite2D")
	sprite.set_self_modulate(Color(1, 1, 1, alpha))	
	
	if remaining_life == 0:
		queue_free()
