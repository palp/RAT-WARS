extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knockback_amount = 100
var attack_size = 1.0
var angle_counter = 0

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var changeDirectionTimer = $ChangeDirectionTimer
@onready var player = get_tree().get_first_node_in_group("player")
signal remove_from_array(object)

func _ready():
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135)
	match level:
		1:
			hp = 5
			speed = 200
			damage = 3
			knockback_amount = 130
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 10
			speed = 250
			damage = 3
			knockback_amount = 140
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 15
			speed = 300
			damage = 5
			knockback_amount = 150
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			hp = 20
			speed = 350
			damage = 5
			knockback_amount = 160
			attack_size = 1.0 * (1 + player.spell_size)

	
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1)*attack_size,1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func _physics_process(delta):
	rotation += (.15 * (angle_counter + 1))
	position += angle*speed*delta

func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array",self)
		queue_free()


func _on_timer_timeout():
	emit_signal("remove_from_array",self)
	queue_free()


func _on_change_direction_timer_timeout():
	angle = angle.orthogonal()
	hp -= 1
	angle_counter += 1
	speed += (15 * angle_counter)
	knockback_amount += 15
	damage += 1
