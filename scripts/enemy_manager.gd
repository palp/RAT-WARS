extends Timer

@export var initial_spawn_count = 10
@export var tick_spawn_count = 2
@export var spawn_near = 1000
@export var spawn_far = 2000

var enemy_basic = preload("res://enemy_basic.tscn")
var enemy_balloon = preload("res://balloon_rat.tscn")

class EnemyType:
	var scene : PackedScene
	var probability : float
	
	func _init(scene_, prob):
		scene = scene_
		probability = prob

# List of possible enemies to spawn and their relative probability
var enemies = [
	EnemyType.new(enemy_basic, 1),
	EnemyType.new(enemy_balloon, 0.3)
]

var prob_max = 0

@onready var player = get_tree().get_first_node_in_group("player")
var rng = RandomNumberGenerator.new()

func enemy_prob_comp(enemy, val):
	return enemy.probability < val

func pick_enemy():
	# In onready we modifify enemy probabilities to include the sum of
	# all the probabilities before them.
	# This allows this fast binary search logic to choose an enemy.
	# Commonly used strategy for this sort of picking.
	var val = rng.randf_range(0, prob_max)
	var index = enemies.bsearch_custom(val, enemy_prob_comp, true)
	# This shouldn't happen if I understand bsearch, but docs are fuzzy
	# So handling just in case to avoid crashes
	# If this message is seen try to fix logic above.
	if index >= enemies.size():
		print("unexpected enemies out-of-bounds!!!")
		index = enemies.size() - 1
		
	return enemies[index]

func spawn_enemies(count):
	for i in count:
		var enemy = pick_enemy().scene.instantiate()
		var spawn_angle = rng.randf_range(0, PI * 2)
		var spawn_dist = rng.randf_range(spawn_near, spawn_far)
		var spawn_offset = Vector2.from_angle(spawn_angle) * spawn_dist
		enemy.position = player.global_position + spawn_offset
		add_child(enemy)

# Called when the node enters the scene tree for the first time.
func _ready():
	for enemy in enemies:
		enemy.probability += prob_max
		prob_max = enemy.probability
	rng.seed = 0
	spawn_enemies(initial_spawn_count)
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_timeout():
	spawn_enemies(tick_spawn_count)
	
