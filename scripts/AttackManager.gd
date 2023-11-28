class_name AttackManager
extends Node

var vinyl = preload("res://vinyl.tscn")

class AttackType:
	func _init(scene_:PackedScene, attack_speed_:float, replenish_speed_:float, base_ammo_:int, max_ammo_:int, level_:int):
		scene = scene_
		attack_speed = attack_speed_
		level = level_
		replenish_speed = replenish_speed_
		base_ammo = base_ammo_
		max_ammo = max_ammo_
	var scene:PackedScene
	var attack_speed:float
	var replenish_speed:float
	var ammo:float
	var base_ammo:float
	var max_ammo:float
	var elapsed_since_attack:float
	var elapsed_since_replenish:float
	var level:int
	var instances:Array

var attacks = [AttackType.new(vinyl, 0.15, 3.0, 1, 10, 1)]
@onready var player = owner

# Called when the node enters the scene tree for the first time.
func _ready():	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not player:
		return
	if player.health <= 0:
		return
	for attack in attacks:
		attack.elapsed_since_replenish += delta
		if attack.elapsed_since_replenish >= attack.replenish_speed and attack.ammo < attack.max_ammo:
			attack.ammo += attack.base_ammo			
			attack.elapsed_since_replenish -= attack.replenish_speed
		attack.elapsed_since_attack += delta		
		if attack.elapsed_since_attack >= attack.attack_speed and attack.ammo > 0:
			var instance = attack.scene.instantiate()
			instance.position = player.global_position
			instance.level = attack.level
			instance.target = get_random_target()
			attack.instances.append(instance)
			add_child(instance)
			attack.ammo -= 1
			attack.elapsed_since_attack -= attack.attack_speed


func get_random_target():
	if not player:
		return Vector2.UP
	if player.nearby_enemies.size() > 0:
		return player.nearby_enemies.pick_random().global_position
	else:
		return Vector2.UP
