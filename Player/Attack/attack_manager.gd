class_name attack_manager
extends Node

var vinyl = preload("res://Player/Attack/vinyl.tscn")
var icespear = preload("res://Player/Attack/ice_spear.tscn")
var tornado = preload("res://Player/Attack/tornado.tscn")
var javelin = preload("res://Player/Attack/javelin.tscn")

var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0

@onready var attacker = owner
@onready var javelin_base = Node2D.new()

class AttackType:
	func _init(scene_:PackedScene, attack_speed_:float, replenish_speed_:float):
		scene = scene_
		attack_speed = attack_speed_
		replenish_speed = replenish_speed_
	var scene:PackedScene
	var attack_speed:float
	var replenish_speed:float
	var ammo:float
	var base_ammo:float
	var max_ammo:float = 99
	var elapsed_since_attack:float
	var elapsed_since_replenish:float
	var level:int
	var instances:Array

var attacks = {
	"vinyl":AttackType.new(vinyl, 0.2, 3),
	"icespear":AttackType.new(icespear, 0.075, 1.5),
	"tornado":AttackType.new(tornado, 0.2, 3),
	"javelin":AttackType.new(javelin, 0.5, 0.5),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(javelin_base)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not attacker:
		return
	if attacker.hp <= 0:
		return
	for attack_type in attacks.keys():
		if attack_type == 'javelin':
			continue
		var attack = attacks[attack_type]
		if attack.level <= 0:
			continue
		if attack.base_ammo > 0:
			attack.elapsed_since_replenish += delta
			if attack.elapsed_since_replenish >= attack.replenish_speed and attack.ammo < attack.max_ammo:
				attack.ammo += attack.base_ammo + attacker.additional_attacks
				attack.elapsed_since_replenish -= attack.replenish_speed
		attack.elapsed_since_attack += delta
		var resolved_attack_speed = attack.attack_speed * (1 - attacker.spell_cooldown)
		if attack.elapsed_since_attack >= resolved_attack_speed and attack.ammo > 0:
			var instance = attack.scene.instantiate()
			instance.position = attacker.global_position
			instance.level = attack.level
			if attack_type == "tornado":
				instance.last_movement = attacker.last_movement
			else:
				instance.target = attacker.get_random_target()
			
			attack.instances.append(instance)
			add_child(instance)
			attack.ammo -= 1
			attack.elapsed_since_attack -= resolved_attack_speed


func spawn_javelin():
	var get_javelin_total = javelin_base.get_child_count()
	var calc_spawns = (attacks['javelin'].ammo + attacker.additional_attacks) - get_javelin_total
	while calc_spawns > 0:
		var javelin_spawn = javelin.instantiate()
		javelin_spawn.global_position = attacker.global_position
		javelin_base.add_child(javelin_spawn)
		calc_spawns -= 1
	#Upgrade Javelin
	var get_javelins = javelin_base.get_children()
	for i in get_javelins:
		if i.has_method("update_javelin"):
			i.update_javelin()
			
