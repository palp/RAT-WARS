extends Node2D

# Exported vars that you can slot prefab packedscenes into
@export var packedscene_terrain_horizontal := PackedScene
@export var packedscene_terrain_vertical := PackedScene
@export var packedscene_terrain_clutter := PackedScene

# a reference to the player so we can keep track of where they are
@export var player := Node2D
var half_camera_viewport_size : int
var furthest_prefab

# these are gonna instantiate our packedscenes
var level_horizontal
var level_vertical
var level_clutter

# keep track of the current size of our level, so we know how far to move tiles later
var current_size : Vector2

# keep track of where "zero" is relative to where the prefabs are. Should always be the position of the middle prefab.
var current_zero : Vector2

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
	# grab the size of the camera viewport and chop it in half for later reference
	half_camera_viewport_size = get_viewport().size.x / 2
	
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
	if (scroll_horizontal):
		var prefab_to_move
		var closest_prefab
		if (player.position.x > 0.0 && player.position.x >= current_zero.x + (current_size.x / 2 - half_camera_viewport_size)):
			prefab_to_move = get_furthest_prefab()
			closest_prefab = get_closest_prefab()
			prefab_array_horizontal[prefab_to_move].position.x += prefab_array_horizontal[prefab_to_move].position.distance_to(prefab_array_horizontal[closest_prefab].position) + get_prefab_length(prefab_to_move)
			current_zero = prefab_array_horizontal[get_furthest_prefab()].position
			current_zero.x -= current_size.x / prefab_array_horizontal.size()
		elif (player.position.x < 0.0 && player.position.x <= current_zero.x - (current_size.x / 2 - half_camera_viewport_size)):
			prefab_to_move = get_furthest_prefab()
			closest_prefab = get_closest_prefab()
			prefab_array_horizontal[prefab_to_move].position.x -= prefab_array_horizontal[prefab_to_move].position.distance_to(prefab_array_horizontal[closest_prefab].position) + get_prefab_length(prefab_to_move)
			current_zero = prefab_array_horizontal[get_furthest_prefab()].position
			current_zero.x += current_size.x / prefab_array_horizontal.size()
	
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
				current_size.x += prefab_array_horizontal[n].get_used_rect().size.x * prefab_array_horizontal[n].get_scale().x * 64
			# and if the index of this prefab is less than the center, move it to the left
			elif (n < center_node):
				temp_position = prefab_array_horizontal[center_node].get_used_rect().size.x / 2 + prefab_array_horizontal[n].get_used_rect().size.x / 2
				prefab_array_horizontal[n].position.x -= temp_position * prefab_array_horizontal[n].get_scale().x * 64
				current_size.x += prefab_array_horizontal[n].get_used_rect().size.x * prefab_array_horizontal[n].get_scale().x * 64
		current_zero = prefab_array_horizontal[center_node].position

func get_furthest_prefab():
	var distance_array = []
	
	for n in prefab_array_horizontal.size():
		distance_array.append(player.position.distance_to(prefab_array_horizontal[n].position))
		
	return distance_array.find(distance_array.max())
	
func get_closest_prefab():
	var distance_array = []
	
	for n in prefab_array_horizontal.size():
		distance_array.append(player.position.distance_to(prefab_array_horizontal[n].position))
		
	return distance_array.find(distance_array.min())
	
func get_prefab_length(prefab_index : int):
	var prefab_length = prefab_array_horizontal[prefab_index].get_used_rect().size.x * prefab_array_horizontal[prefab_index].get_scale().x * 64
	return prefab_length
