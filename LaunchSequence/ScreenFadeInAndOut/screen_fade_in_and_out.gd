extends Node2D

@onready var player = $AnimationPlayer

func fadeToBlack(_animation_name = "type_1"):
	player.play(_animation_name)
	pass

func fadeToScreen(_animation_name):
	player.play_backwards(_animation_name)
	pass