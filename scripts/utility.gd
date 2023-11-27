extends Node

# Required velocity to flip. Prevents any rapid flipping
# that may happen for AI
const FACING_EPSILON = 0.1

static func set_facing(obj):
	# Setting scale doesn't work so we do this slightly
	# more complicsted logic.
	var sprite = obj.get_node("Sprite2D")
	var base_scale = abs(obj.scale.x)
	var new_flip = false
	if obj.velocity.x < -FACING_EPSILON:
		new_flip = true
	elif obj.velocity.x > FACING_EPSILON:
		new_flip = false
	else:
		# Just keep previous flip value
		return
		
	# Also flip offset if needed
	if new_flip != sprite.is_flipped_h():
		sprite.set_flip_h(new_flip)
		sprite.offset.x = -sprite.offset.x
		
		
