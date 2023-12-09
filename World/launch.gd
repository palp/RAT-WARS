extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready():	
	
	var player_gui = player.get_node(NodePath("GUILayer"))
	player_gui.visible = false	
	while player.experience_level < 10:
		player.calculate_experience(player.calculate_experiencecap())	
	
	if not UserSettings.config.get_value("cutscene", "opening_played", false):
		get_node("%main_menu").play_cutscene("opening")
		UserSettings.config.set_value("cutscene", "opening_played", true)
		UserSettings.save_config()
	var label_title = get_node("%label_title") as Label	
	label_title.modulate = Color.DARK_RED
	var title_tween = label_title.create_tween()
	title_tween.tween_property(label_title, "modulate", Color(0,0,0,0), 8)	
	title_tween.play()
