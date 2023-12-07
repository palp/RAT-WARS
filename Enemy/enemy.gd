extends CharacterBody2D
class_name EnemyBase


@export var movement_speed = 20.0
@export var hp = 10
@export var knockback_recovery = 3.5
@export var experience = 1
@export var enemy_damage = 1
@export var trigger_victory = false
@export var enemy_name = "rat"
@export var attack_anim_distance = 0.0
@export var attack_slide_velocity = 0.0
@export var attack_slide_start = 0.0
@export var attack_slide_stop = 0.0
var knockback = Vector2.ZERO
var slow_percent = 0.0
var tick_damage = 0

@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var sprite = $Sprite2D
@onready var anim = get_node("AnimationPlayer")
@onready var snd_hit = $snd_hit
@onready var hitBox = $HitBox
@onready var disableTimer = $HurtBox/DisableTimer
@onready var dotTimer = $HurtBox/DOTTimer
@onready var HealthBarBoss1 = get_node("%HealthBarBoss1")
@onready var maxhp = hp

@export var death_anim = preload("res://Enemy/explosion.tscn")
var exp_gem = preload("res://Objects/experience_gem.tscn")

var is_attacking = false
var is_attack_sliding = false
var attack_slide_wait

signal remove_from_array(object)


func _ready():
	anim.play("walk")
	anim.connect("animation_finished", _on_animation_finished)
	hitBox.damage = enemy_damage

func _on_animation_finished(animation_name):
	anim.play("walk")
	
	is_attacking = false

func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	
	if not is_attacking:
		if dotTimer.time_left > 0:
			velocity = direction*movement_speed*slow_percent
			hp -= tick_damage
		else: 
			velocity = direction*movement_speed
		velocity += knockback
		move_and_slide()
				
		if attack_anim_distance > 0:
			var distance = global_position.distance_to(player.global_position)
			if distance < attack_anim_distance:
				anim.play("attack")
				is_attacking = true
				if attack_slide_velocity > 0 and attack_slide_start > 0:
					attack_slide_wait = attack_slide_start
	elif not is_attack_sliding:
		if attack_slide_wait > 0:
			attack_slide_wait -= _delta
			if attack_slide_wait <= 0:
				velocity = direction*attack_slide_velocity
				is_attack_sliding = true
				move_and_slide()
				attack_slide_wait = attack_slide_stop
	else:
		if attack_slide_wait > 0:
			attack_slide_wait -= _delta
			if attack_slide_wait <= 0:
				is_attack_sliding = false
				velocity = Vector2(0,0)
		move_and_slide()
			
				
	if direction.x > 0.1:
		sprite.flip_h = false
	elif direction.x < -0.1:
		sprite.flip_h = true
	
func death():
	emit_signal("remove_from_array",self)	
	if player != null:
		if player.kills == null:
			player.kills = {}
		player.player_kill_counter += 1
		if not player.kills.has(enemy_name):
			player.kills[enemy_name] = 1
		else:
			player.kills[enemy_name] += 1		

	var enemy_death = death_anim.instantiate()
	if trigger_victory:
		enemy_death.connect("tree_exited", player.victory)
	enemy_death.scale = sprite.scale
	enemy_death.global_position = global_position
	get_parent().call_deferred("add_child",enemy_death)
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred("add_child",new_gem)	
	queue_free()

func _on_hurt_box_hurt(damage, angle, knockback_amount):
	hurt_show()
	hp -= damage
	knockback = angle * knockback_amount
	if trigger_victory:
		HealthBarBoss1.max_value = maxhp
		HealthBarBoss1.value = hp
	if hp <= 0:
		$AnimationPlayer.play("death")
	else:
		snd_hit.play()


func _on_hurt_box_dot(damage, duration, slow):
	dotTimer.wait_time = duration
	tick_damage = damage
	slow_percent = (1.0 - slow)
	dotTimer.start()
	if hp <= 0:
		$AnimationPlayer.play("death")
	else:
		snd_hit.play
		
# Red flash effect on enemy taking damage
# The resources is at res://shaders/enemy_hurt_meterial.tres, uses enemy_hurt.gdshader
# To set up
# Go to [enemy_node_name]/Sprite2D
# In "Inspector" window, under "CanvasItem" props
# "Material" -> "Quick Load" -> "enemy_hurt_meterial.tres"
func hurt_show():
	var tween = get_tree().create_tween();
	tween.tween_callback(sprite.material.set_shader_parameter.bind("hurt_flash",1))
	tween.tween_interval(disableTimer.wait_time)
	tween.tween_callback(sprite.material.set_shader_parameter.bind("hurt_flash",0))
	pass
