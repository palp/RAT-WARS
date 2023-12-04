extends Area2D

var level = 1
var hp = 1
var damage = 5
var knockback_amount = 100
var attack_size = 1.0
var radius = 100
var angle_of_rotation = 0
var dec_rad = 0
var inc_rad = 1
var max_radius
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	update_plug()

func update_plug():
	if not player.attackManager.attacks.has('plug'):
		return
	level = player.attackManager.attacks['plug'].level
	match level:
		1:
			hp = 9999
			damage = 4
			knockback_amount = 150
			attack_size = 1.0 * (1 + player.spell_size)
			max_radius = 115
		2:
			hp = 9999
			damage = 5
			knockback_amount = 200
			attack_size = 1.0 * (1 + player.spell_size)
			max_radius = 130
		3:
			hp = 9999
			damage = 5
			knockback_amount = 250
			attack_size = 1.0 * (1 + player.spell_size)
			max_radius = 145
		4:
			hp = 9999
			damage = 7
			knockback_amount = 300
			attack_size = 1.0 * (1 + player.spell_size)
			max_radius = 175
			
	scale = Vector2(1.0,1.0) * attack_size


func _physics_process(delta):
	angle_of_rotation += (max_radius - 100) / 15
	if inc_rad and radius < max_radius:
		radius += 1
	if inc_rad and radius >= max_radius:
		inc_rad = 0
		dec_rad = 1
	if dec_rad and radius > 100:
		radius -= 2
	if dec_rad and radius <= 100:
		inc_rad = 1
		dec_rad = 0
	position = player.position + Vector2(cos(deg_to_rad(angle_of_rotation)), sin(deg_to_rad(angle_of_rotation))) * radius
	look_at(player.position)
	rotation += (deg_to_rad(270))
	angle = Vector2.from_angle(deg_to_rad(angle_of_rotation))

