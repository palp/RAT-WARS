extends Node2D


@export var spawns: Array[Spawn_info] = []
@export var spawn_area: Rect2 = Rect2(0,0,0,0)
@export var track_vertical = false
@export var track_horizontal = false

@onready var player = get_tree().get_first_node_in_group("player")

@export var time = 0

signal changetime(time)
signal enemy_spawned(enemy_type)

func spawn_enemies():
	var enemy_spawns = spawns
	if track_vertical:
		spawn_area.position.y = player.global_position.y
	if track_horizontal:
		spawn_area.position.x = player.global_position.x	

	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_enemy = i.enemy
				var counter = 0
				while  counter < i.enemy_num:
					var random_position = get_random_position()
					var enemy_spawn = new_enemy.instantiate()
					enemy_spawn.global_position = random_position
					enemy_spawn.top_level = true					
					add_sibling.call_deferred(enemy_spawn)
					emit_signal("enemy_spawned",enemy_spawn)
					counter += 1
	

func _ready():
	connect("enemy_spawned",Callable(player,"_on_enemy_spawned"))
	spawn_enemies()
	connect("changetime",Callable(player,"change_time"))
	

func _on_timer_timeout():
	time += 1
	spawn_enemies()
	emit_signal("changetime",time)

func get_random_position():
	var vpr = get_viewport_rect().size * randf_range(1.1,1.4)			
	
	var top_left:Vector2
	var top_right:Vector2
	var bottom_left:Vector2
	var bottom_right:Vector2
	
	
	var left:float
	var right:float
	var top:float
	var bottom:float
	
	if spawn_area.get_area() == 0:
		top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
		top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
		bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
		bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)		
	else:
		left = spawn_area.position.x
		right = spawn_area.end.x
		top = spawn_area.position.y
		bottom = spawn_area.end.y
		if track_horizontal:
			left = player.global_position.x - spawn_area.size.x/2
			right = player.global_position.x + spawn_area.size.x/2
		if track_vertical:
			top = player.global_position.y - spawn_area.size.y/2
			bottom = player.global_position.y + spawn_area.size.y/2
		top_left = Vector2(left, top)
		top_right = Vector2(right, top)
		bottom_left = Vector2(left, bottom)
		bottom_right = Vector2(right, bottom)
	
	
	var pos_side = ["up","down","right","left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
	
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y,spawn_pos2.y)
	return Vector2(x_spawn,y_spawn)
