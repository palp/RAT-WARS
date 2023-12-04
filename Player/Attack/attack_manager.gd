class_name attack_manager
extends Node

var vinyl = preload("res://Player/Attack/vinyl.tscn")
var stonefist = preload("res://Player/Attack/ice_spear.tscn")
var tornado = preload("res://Player/Attack/tornado.tscn")
var javelin = preload("res://Player/Attack/javelin.tscn")
var die_slow = preload("res://Player/Attack/die_slow.tscn")
var plug = preload("res://Player/Attack/buttplug.tscn")

var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0

@onready var attacker = owner
@onready var javelin_base = Node2D.new()
@onready var plug_base = Node2D.new()

class AttackType:
	func _init(scene_: PackedScene, attack_speed_: float, replenish_speed_: float):
		scene = scene_
		attack_speed = attack_speed_
		replenish_speed = replenish_speed_

	var scene: PackedScene
	var attack_speed: float
	var replenish_speed: float
	var ammo: float
	var base_ammo: float
	var max_ammo: float = 99
	var elapsed_since_attack: float
	var elapsed_since_replenish: float
	var level: int
	var instances: Array


var attacks = {
	"vinyl": AttackType.new(vinyl, 0.2, 3),
	"stonefist": AttackType.new(stonefist, 0.075, 1.5),
	"tornado": AttackType.new(tornado, 0.2, 3),
	"javelin": AttackType.new(javelin, 0.5, 0.5),
	"die_slow": AttackType.new(die_slow, 0.5, 4.0),
	"plug": AttackType.new(plug, 0.5, 4.0)
}


# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(javelin_base)
	add_child(plug_base)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not attacker:
		return
	if attacker.hp <= 0:
		return
	for attack_type in attacks.keys():
		if attack_type == "javelin":
			continue
		if attack_type == "plug":
			spawn_plug()
			continue
		var attack = attacks[attack_type]
		if attack.level <= 0:
			continue
		if attack.base_ammo > 0:
			attack.elapsed_since_replenish += delta
			if (
				attack.elapsed_since_replenish >= attack.replenish_speed
				and attack.ammo < attack.max_ammo
			):
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
			attack.elapsed_since_attack = 0


func spawn_javelin():
	var get_javelin_total = javelin_base.get_child_count()
	var calc_spawns = (attacks["javelin"].ammo + attacker.additional_attacks) - get_javelin_total
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

func spawn_plug():
	var get_plug_total = plug_base.get_child_count()
	var additional_spawns = (attacks["plug"].base_ammo + attacker.additional_attacks) - get_plug_total
	var increment_amount = floor(360 / (get_plug_total + additional_spawns))
	var current_deg = 0
	while additional_spawns > 0:
		current_deg = reset_angle(increment_amount)
		var plug_spawn = plug.instantiate()
		plug_spawn.angle_of_rotation = current_deg
		current_deg += increment_amount
		plug_base.add_child(plug_spawn)
		plug_spawn.update_plug()
		additional_spawns -= 1
	for i in plug_base.get_children():
		if i.has_method("update_plug"):
			i.update_plug()

func reset_angle(increment_amount):
	var current_deg = 0
	for i in plug_base.get_children():
		i.angle_of_rotation = current_deg
		current_deg += increment_amount
	return current_deg
