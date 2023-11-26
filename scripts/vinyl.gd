extends Area2D

var level = 1
var hp = 999
var speed = 150.0
var damage = 10
var knockback = 100
var attack_size = 1.0

var target = Vector2.ZERO
var target_array = []

var angle = Vector2.ZERO
var reset_pos = Vector2.ZERO

var sprt = preload("res://assets/player/attacks/vinyl.png")

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var changeDirectionTimer = get_node("ChangeDirection")
@onready var resetPost = get_node("ResetPosTimer")

signal remove_from_array(object)

func _ready():
	update_vinyl()
	
func update_vinyl():
	level = player.vinyl_level
