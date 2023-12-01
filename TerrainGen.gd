extends Node2D

@export var packedscene_terrain_horizontal := PackedScene
@export var packedscene_terrain_vertical := PackedScene
@export var packedscene_terrain_clutter := PackedScene
@onready var level_horizontal = load(packedscene_terrain_horizontal.resource_path).get_local_scene()
@onready var level_vertical = load(packedscene_terrain_vertical.resource_path).get_local_scene()
@onready var level_clutter = load(packedscene_terrain_clutter.resource_path).get_local_scene()

@export var scroll_horizontal : bool
@export var scroll_vertical : bool
@export var enable_clutter : bool

var prefab_array_horizontal
var prefab_array_vertical
var clutter_array

# Called when the node enters the scene tree for the first time.
func _ready():
	if (scroll_horizontal):
		level_horizontal.Instantiate()
		level_horizontal.visible = false
		prefab_array_horizontal = level_horizontal.get_children(true)
		
	
	if (scroll_vertical):
		level_vertical.Instantiate()
		level_vertical.visible = false
		prefab_array_vertical = level_vertical.get_children(true)
	
	if (enable_clutter):
		level_clutter.Instantiate()
		level_clutter.visible = true
		clutter_array = level_clutter.get_children(true)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
