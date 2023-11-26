extends Timer

@export var initial_spawn_count = 10
@export var tick_spawn_count = 2
@export var spawn_near = 1000
@export var spawn_far = 2000

var enemy_basic = preload("res://enemy_basic.tscn")

@onready var player = get_tree().get_first_node_in_group("player")
var rng = RandomNumberGenerator.new()

func spawn_enemies(count):
	for i in count:
		var enemy = enemy_basic.instantiate()
		var spawn_angle = rng.randf_range(0, PI * 2)
		var spawn_dist = rng.randf_range(spawn_near, spawn_far)
		var spawn_offset = Vector2.from_angle(spawn_angle) * spawn_dist
		enemy.position = player.global_position + spawn_offset
		add_child(enemy)

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.seed = 0
	spawn_enemies(initial_spawn_count)
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_timeout():
	spawn_enemies(tick_spawn_count)
	
