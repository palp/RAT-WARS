extends Node2D

signal transition_in_progress(boolean)

@onready var player: AnimationPlayer = $AnimationPlayer
@onready var anim_type = "type_1"
@onready var in_progress: bool = false

func fadeToBlack(_animation_name = "type_1"):
	player.play(_animation_name)
	pass

func hide_visual():
	$Sprite2D.frame = 0
	pass

func fadeToScreen(_animation_name = "type_1"):
	player.play_backwards(_animation_name)
	pass

func _ready():
	$Sprite2D.frame = 8
	pass

func _on_animation_finished(_anim_name:StringName):
	in_progress = false
	emit_signal("transition_in_progress", in_progress)
	pass # Replace with function body.

func _on_animation_started(_anim_name:StringName):
	in_progress = true
	emit_signal("transition_in_progress", in_progress)
	pass # Replace with function body.
