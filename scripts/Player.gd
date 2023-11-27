extends CharacterBody2D

@export var base_health = 100
@export var damage_per_hit = 10
@export var invincibility_frames = 20

var health = base_health
var invincibility = 0

@export var speed = 200
@export var autopilot = true

# Weapon/Attack variables
var vinyl = preload("res://vinyl.tscn")
@onready var VinylTimer = get_node("%VinylTimer")
@onready var VinylAttackTimer = get_node("%VinylAttackTimer")

# Vinyl Specific
var vinyl_ammo = 0
var vinyl_base_ammo = 1
var vinyl_attack_speed = 3
var vinyl_level = 1

# Enemies detected
var enemy_close = []

const Utility = preload("res://scripts/utility.gd")

func _ready():
	attack()

func _physics_process(delta):
	if health <= 0:
		return

	if autopilot:
		var enemies = get_tree().get_nodes_in_group("enemy")
		var dir = velocity.normalized()
		velocity = get_autopilot_velocity(dir, enemies)
	else:
		velocity = get_input_velocity()
	
	move_and_slide()
	Utility.set_facing(self)
	var sprite = get_node("Sprite2D")
	if invincibility > 0:
		invincibility -= 1				
		if invincibility % 3 == 0 and invincibility > 0:
			sprite.set_self_modulate(Color(1, 1, 1, 0))		
		else:
			sprite.set_self_modulate(Color(1, 1, 1, 1))
		return
	
	if get_slide_collision_count() > 0:
		invincibility = invincibility_frames
		health -= damage_per_hit
		var alpha = 1
		if health <= 0:
			alpha = 0
		sprite.set_self_modulate(Color(1, 0, 0, alpha))

	#for i in get_slide_collision_count():
	#	var collision = get_slide_collision(i)
	#	print("I collided with ", collision.get_collider().damage)

func get_autopilot_velocity(dir: Vector2, enemies: Array):
	for enemy in enemies:
		var enemy_distance = enemy.global_position - global_position
		var enemy_distance_total = abs(enemy_distance.x) + abs(enemy_distance.y)
		if enemy_distance_total < 100:
			var enemy_dir = enemy.global_position.direction_to(global_position)
			dir += enemy_dir * 0.5

	if dir == Vector2(0, 0) or randf() < 0.05:
		var random_factor = Vector2(randf_range(-0.5, 0.5), randf_range(-0.5, 0.5))
		dir += random_factor

	return dir.normalized() * speed


func get_input_velocity():
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	return dir.normalized() * speed

func attack():
	if vinyl_level > 0:
		VinylTimer.wait_time = vinyl_attack_speed
		if VinylTimer.is_stopped():
			VinylTimer.start()


func _on_vinyl_timer_timeout():
	vinyl_ammo += vinyl_base_ammo
	VinylAttackTimer.start()


func _on_vinyl_attack_timer_timeout():
	if vinyl_ammo > 0:
		var vinyl_attack = vinyl.instantiate()
		vinyl_attack.position = position
		vinyl_attack.level = vinyl_level
		vinyl_attack.target = get_random_target()
		add_child(vinyl_attack)
		vinyl_ammo -= 1
		if vinyl_ammo > 0:
			VinylAttackTimer.start()
		else:
			VinylAttackTimer.stop()
		
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP


func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
