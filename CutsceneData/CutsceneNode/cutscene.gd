extends Node

enum CutsceneState{begin, transition_to_black, transition_to_screen, transition_frame, text_printing, fade_to_black, idle, end}

# TODO connnect to something up the hierary. 
signal cutscene_finished()

# @onready var animation_control: AnimationPlayer = $AnimationPlayer
# @onready var control_node = $Control
@export var scene_title: String
# @export var music_format: String
@export var text_speed = 0.02
@export var frame_transition_speed: float = 1.2
@onready var text_node: RichTextLabel = get_node("Text")
@onready var indicator_next: AnimatedSprite2D = get_node("ButtonNext/AnimatedSprite2D")
@onready var cutscene_frame: Sprite2D = get_node("CutsceneFrame")
@onready var screen_fade_in_out: Node2D = get_node("ScreenFadeInAndOut")
@onready var animationPlayer: AnimationPlayer = get_node("AnimationPlayer")
@onready var music_stream: AudioStreamPlayer = get_node("AudioStreamPlayer")
@onready var indicator_skip: Sprite2D = get_node("ButtonSkip/Sprite")
var skip_visible: bool
var string_index: int
var img_index: int
var text_array = []
var img_array = []
@onready var slide_image: Sprite2D = get_node("SlideImage")
@onready var ignore_player_input: bool = true

# TODO There needs to be a way to provide an instances cutscene node with
# The title of a requested cutscene
# string cutscene_name
# a method called from up the hierarchy

var current_scene_state: CutsceneState

# Called when the node enters the scene tree for the first time.
func _ready():
	text_node.text = ""
	string_index = 0
	img_index = 0
	indicator_next.visible = false
	skip_visible = false
	current_scene_state = CutsceneState.begin	
	Log.info(scene_title)
	launch_scene()
	Log.info("Cutscene node ready")
	pass 

func launch_scene():
	scene_title.to_lower()
	img_array = get_slides_array(scene_title)
	text_array = get_scene_text(scene_title)
	get_music(scene_title)
	test_text_array(text_array)
	test_img_array(img_array)
	music_stream.play()
	text_processing(text_array[string_index])
	pass
func test_text_array(array):
	for s in array:
		Log.info(s)
		pass
	pass
func test_img_array(array: Array):
	for n in array.size():
		Log.info(array[n].resource_name)
		Log.info(array[n].resource_path)
		pass
	pass
	# * NODE SETUP

# * This section is all about loadign the cutscene text_node from json file
# Returns a .json file path based on a cutsceen name as a string
func get_text_file(scene_name) -> String:
	return "res://CutsceneData/Json/" + scene_name + ".json"

# Retuns a string array 
# Note, this is not the safest code. There may be issues in the future.
func get_text_array(json_file_path) -> Array:
	# Create a reference to the json file on user's device
	var json_file = FileAccess.open(json_file_path, FileAccess.READ)
	# Get the json as continuous string
	var json_contents = json_file.get_as_text()
	# Then use JSON.parse_string() to get an array of strings
	return JSON.parse_string(json_contents)

# Loads a correct set of string for (RichTextLable)Text object
func get_scene_text(cutscene_name) -> Array:
	var text_file = get_text_file(cutscene_name)
	return get_text_array(text_file)

# * Loading Images into the declared array
# Loads a correct set of slides for (Sprite2D)SlideImage object
func get_slides_array(cutscene_name) -> Array:
	var cutscene_slides_path = "res://CutsceneData/Slides/"+cutscene_name
	var image_array = []
	# Open the pics directory for provided cutscene name and prepare them
	# by appending the array
	var img_dir = DirAccess.open(cutscene_slides_path)
	# Begin listing all files in the directory
	img_dir.list_dir_begin()
	while true:
		var file_name = img_dir.get_next()		
		if file_name == "":
			break
		elif !file_name.begins_with(".") and file_name.ends_with(".import"):
			image_array.append(load(cutscene_slides_path + "/" + file_name.replace(".import", "")))
	img_dir.list_dir_end()
	return image_array

# * Load Music
func get_music(cutscene_name: String):
	music_stream.stream = load("res://CutsceneData/Music/" + cutscene_name +".ogg")
	pass

# This is meant to be called from inside the script/self
func show_next_slide(next_slide: Resource):
	Log.info("show next slide")
	slide_image.texture = next_slide
	pass
		
		# * SIGNAL PROCESSING

	#// ? Why are there funcitions in this section, that start both with "_on..." and "on"?
	#// "_on" are subscribed to events from other nodes.
	#// "on" are not, but they have their functionality tied to "_on" functions.

# * From Slide Image Node
func _on_slide_changed():
	Log.info("_on_slide_changed")
	match current_scene_state:
		CutsceneState.transition_to_screen:
			current_scene_state = CutsceneState.transition_frame
			cutscene_frame.frame = 0
			screen_fade_in_out.fadeToScreen()
			pass

# * From screen_fade_in_and_out
func _on_transition_in_progress(in_progress: bool):
	Log.info("_on_transition_in_progress recived notification")
	match in_progress:
		true:
			# current_scene_state = CutsceneState.transition_to_black
			# if tru
			pass
		false:
			# if false
			
			on_screen_transition_finished()
			
# Called when fade out animation is finished
func on_screen_transition_finished():
	Log.info("scene state: " + str(current_scene_state))
	match current_scene_state:
		CutsceneState.transition_to_screen, CutsceneState.transition_frame:
			ignore_player_input = false
			current_scene_state = CutsceneState.transition_frame
			var tween = create_tween()			
			tween.tween_interval(frame_transition_speed)
			tween.tween_property(cutscene_frame, "frame", 7, frame_transition_speed)
			# tween.tween_interval(frame_transition_speed)
			tween.tween_callback(on_cutscene_frame_up) 
			# show cutscene frame
		CutsceneState.transition_to_black:
			text_node.visible_characters = 0
			img_index = img_index + 1
			current_scene_state = CutsceneState.transition_to_screen
			show_next_slide(img_array[img_index])
			pass
		CutsceneState.text_printing:
			pass
		CutsceneState.fade_to_black:
			slide_image.visible = false
			screen_fade_in_out.hide_visual()
			text_processing(text_array[string_index])
			pass
		CutsceneState.end:
			Log.info("Queue free cutscene")
			queue_free()
			pass

# * From CutscenFrame
func on_cutscene_frame_up():
	text_processing(text_array[string_index])
	# begin printing text_node
	pass

		# * Processing text_node extracted from the .json file
# * Check the current string in the array fo commandz
func text_processing(string_from_array):
	string_index = string_index + 1
	Log.info("current string index: " + str(string_index))
	match string_from_array:
		"ENDSCENE":
			current_scene_state = CutsceneState.end
			screen_fade_in_out.fadeToBlack()
		"SHOWSLIDE":
			text_command_showslide()
		"FADETOBLACK":
			current_scene_state = CutsceneState.fade_to_black
			animationPlayer.play("music_fade_out")
			screen_fade_in_out.fadeToBlack("type_1", 0.5)
		_:
			# default case is a block of text_node that is to be printed out
			ignore_player_input = false
			print_text(string_from_array)

# Called if a string says "SHOWSLIDE"
func text_command_showslide():
	match current_scene_state:
		CutsceneState.begin:
			current_scene_state = CutsceneState.transition_to_screen
			string_index =+ 1
			show_next_slide(img_array[img_index])
			# $ScreenFadeInAndOut.fadeToScreen()
		CutsceneState.idle:
			current_scene_state = CutsceneState.transition_to_black
			ignore_player_input = true
			screen_fade_in_out.fadeToBlack()
			pass
			
func print_text(string):
	current_scene_state = CutsceneState.text_printing
	text_node.visible_characters = 0
	text_node.text = string
	text_node.get_node("TextSpeedTimer").wait_time = text_speed
	text_node.get_node("TextSpeedTimer").start()
	pass

# Called from the text_node speed timer after each character is printed
# If all characters are printed, switch state and stop ignoring input
func _on_text_speed_timer_timeout():
	if text_node.visible_characters < len(text_node.text):
		text_node.visible_characters += 1
		text_node.get_node("TextSpeedTimer").start()
	else:
		indicator_next.play("default")
		indicator_next.visible = true
		ignore_player_input = false
		current_scene_state = CutsceneState.idle
		pass

func print_whole_text(string):
	text_node.get_node("TextSpeedTimer").stop()
	text_node.text = string
	text_node.visible_characters = string.length()
	indicator_next.play("default")
	indicator_next.visible = true
	current_scene_state = CutsceneState.idle
	pass

		# * Music Processing
		# ??

		# * Processing player's input
# Input from "Next" button in the lower right corner
func _input_next_button(event: InputEvent):
	if ignore_player_input:
		return
	if event is InputEventMouseButton and event.is_pressed():
		if current_scene_state == CutsceneState.text_printing:
			text_node.get_node("TextSpeedTimer").stop()
			print_whole_text(text_node.text)
		elif current_scene_state == CutsceneState.idle:
			indicator_next.visible = false
			text_processing(text_array[string_index])
			pass

# Input form "Skip" button in the upper right corner 
func _input_skip_button(event: InputEvent):
	if ignore_player_input:
		return
	if !skip_visible:
		show_skip()
	else:
		if event is InputEventMouseButton and event.is_pressed():
			ignore_player_input = true
			current_scene_state = CutsceneState.end
			screen_fade_in_out.fadeToBlack()
	# current_scene_state = CutsceneState.end
	# Queue_free this bitch
	pass

func show_skip():
	match skip_visible:
		true:
			var tween = get_tree().create_tween()
			tween.tween_property(indicator_skip, "position", Vector2(indicator_skip.position.x, -122), 0.1)
			tween.tween_interval(0.2)
			tween.tween_property(self,"skip_visible",false, 0)
			pass
		false:
			skip_visible = true
			var tween = get_tree().create_tween()
			tween.tween_property(indicator_skip, "position", Vector2(indicator_skip.position.x, 24), 0.25)
			tween.tween_interval(0.25)
			tween.tween_callback(get_node("ButtonSkip/ButtonSkipHideTimer").start.bind(2))
			pass
# On json file contents
# i decided i'm going to use special commands embeded as strings to instruct node to show 
# next slide or do some stuff by having it look at
# a next string in text_array. 
# ? Writing a JSON file https://youtu.be/GzPvN5wsp7Y?si=FsdQJkgZum61_ScA&t=243
