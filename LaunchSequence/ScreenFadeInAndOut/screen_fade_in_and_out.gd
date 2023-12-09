extends Node2D

signal transition_in_progress(boolean)

@onready var player: AnimationPlayer = $AnimationPlayer
@onready var anim_type = "type_1"
@onready var in_progress: bool = false

func fadeToBlack(_animation_name = "type_1"):
	player.play(_animation_name)
	pass

func fadeToScreen(_animation_name = "type_1"):
	player.play_backwards(_animation_name)
	pass

func _ready():
	# fadeToScreen(anim_type)
	pass

func _on_animation_finished(anim_name:StringName):
	in_progress = false
	emit_signal("transition_in_progress", in_progress)
	pass # Replace with function body.

func _on_animation_started(anim_name:StringName):
	in_progress = true
	emit_signal("transition_in_progress", in_progress)
	pass # Replace with function body.
