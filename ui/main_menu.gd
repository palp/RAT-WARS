extends Control

@export var show_play_button = true
@export var show_main_menu_button = false

@onready var options_menu = get_node("%options_menu")
@onready var play_button = get_node("%play_button")
@onready var main_menu_button = get_node("%main_menu_button")

func _ready():
	play_button.visible = show_play_button
	main_menu_button.visible = show_main_menu_button

func _on_play_pressed():
	get_tree().change_scene_to_file("res://level_placeholder.tscn")

func _on_options_pressed():
	options_menu.visible = !options_menu.visible

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://demo.tscn")
	get_tree().paused = false
