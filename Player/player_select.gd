extends Node2D

@onready var jake = get_node("%JakeSprite")
@onready var john = get_node("%JohnSprite")
@onready var beej = get_node("%BeejSprite")

# Called when the node enters the scene tree for the first time.
func _ready():
	jake.texture = Unlocks.player_characters['jake'].get_current_skin().texture
	john.texture = Unlocks.player_characters['john'].get_current_skin().texture
	beej.texture = Unlocks.player_characters['beej'].get_current_skin().texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_select_character(extra_arg_0):
	Unlocks.select_character(extra_arg_0)
	get_tree().change_scene_to_file("res://level_placeholder.tscn")
