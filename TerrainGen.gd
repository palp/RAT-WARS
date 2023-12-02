extends Node2D

# Exported vars that you can slot prefab packedscenes into
@export var packedscene_terrain_horizontal := PackedScene
@export var packedscene_terrain_vertical := PackedScene
@export var packedscene_terrain_clutter := PackedScene

# these are gonna instantiate our packedscenes
var level_horizontal
var level_vertical
var level_clutter

# keep track of the current size of our level, so we know how far to move tiles later
var current_size : Vector2

# What types of things are active in this instance of TerrainGen?
@export var scroll_horizontal : bool
@export var scroll_vertical : bool
@export var enable_clutter : bool

# Most of our work is gonna be done via these arrays
var prefab_array_horizontal
var prefab_array_vertical
var clutter_array

# Called when the node enters the scene tree for the first time.
func _ready():
	# temporary variable because we need something to hold our scene when we load it
	var temp_scene
	if (scroll_horizontal):
		# First, load in the packedscene specified in the exported vars
		temp_scene = load(packedscene_terrain_horizontal.resource_path)
		# then, instantiate that scene
		level_horizontal = temp_scene.instantiate()
		#level_horizontal.visible = false
		
		# make sure that it stays on the same level because we don't want it drawing over the player
		add_sibling.call_deferred(level_horizontal) 
		# Load the children in the prefab into the array so we can use 'em
		prefab_array_horizontal = level_horizontal.get_children(true)
		
	
	# rinse and repeat for vertical tiles
	if (scroll_vertical):
		temp_scene = load(packedscene_terrain_vertical.resource_path)
		level_vertical = temp_scene.instantiate()
		#level_vertical.visible = false
		prefab_array_vertical = level_vertical.get_children(true)
	
	# rinse and repeat for clutter objects
	if (enable_clutter):
		temp_scene = load(packedscene_terrain_clutter.resource_path)
		level_clutter = temp_scene.instantiate()
		#level_clutter.visible = true
		clutter_array = level_clutter.get_children(true)
	
	# build out the initial prefabs into a level
	build_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# Iterate through all in-use scene arrays and start arranging them
func build_level():
	# which index of our array is the center, approximately?
	var center_node
	# temp position vector2 because these lines get long
	var temp_position
	
	if (scroll_horizontal):
		center_node = prefab_array_horizontal.size() / 2
		current_size = prefab_array_horizontal[center_node].get_used_rect().size
		# iterate through every prefab in the horizontal array
		for n in prefab_array_horizontal.size():
			# if the index of this prefab is greater than the center, move it to the right
			if (n > center_node):
				temp_position = prefab_array_horizontal[center_node].get_used_rect().size.x / 2 + prefab_array_horizontal[n].get_used_rect().size.x / 2
				prefab_array_horizontal[n].position.x += temp_position * prefab_array_horizontal[n].get_scale().x * 64
				current_size.x += prefab_array_horizontal[n].get_used_rect().size.x
			# and if the index of this prefab is less than the center, move it to the left
			elif (n < center_node):
				temp_position = prefab_array_horizontal[center_node].get_used_rect().size.x / 2 + prefab_array_horizontal[n].get_used_rect().size.x / 2
				prefab_array_horizontal[n].position.x -= temp_position * prefab_array_horizontal[n].get_scale().x * 64
				current_size.x += prefab_array_horizontal[n].get_used_rect().size.x
			
