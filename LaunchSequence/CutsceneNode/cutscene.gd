extends Node

@onready var animation_control = $AnimationPlayer
@onready var text = $RichTextLabel
@onready var control_node = $Control
@export var scene_dialog_path = ""
@export var text_speed = 0.05
var dialog 

# Called when the node enters the scene tree for the first time.
func _ready():
	text.get_node("Timer")
	pass 

# TODO https://www.youtube.com/watch?v=GzPvN5wsp7Y&t=185s
# FIX outdated 👆

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func input_next(_args):
	pass

func input_skipv(_args):
	pass

func method(_args):
	pass