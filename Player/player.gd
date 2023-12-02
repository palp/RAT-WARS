class_name Player
extends CharacterBody2D

@export var autopilot = true
var disable_pathing_input = false

@export var movement_speed = 40.0
@export var maxhp = 80
var hp = maxhp
var last_movement = Vector2.UP
var time = 0

var experience = 0
var experience_level = 1
var collected_experience = 0
var score = 0

#Characters
var skins = {
	"john": preload("res://assets/player/character/john/john_placeholder.png"),	
	"john_plugsuit": preload("res://assets/player/character/john/john_plugsuit.png"),
	"jake": preload("res://assets/player/character/jake/jake.png"),
	"beej": preload("res://assets/player/character/beej/beej.png"),
}

var available_skins = [
	"john",
	"jake",
	"beej",
]

var current_skin = "john"


#AttackManager
@onready var attackManager = get_node("%AttackManager") as attack_manager

#UPGRADES
var collected_upgrades = []
var upgrade_options = []
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0

#Javelin
var javelin_ammo = 0
var javelin_level = 0

#Enemy Related
var enemy_close = []

@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")

#GUI
@onready var expBar = get_node("%ExperienceBar")
@onready var lblLevel = get_node("%lbl_level")
@onready var levelPanel = get_node("%LevelUp")
@onready var upgradeOptions = get_node("%UpgradeOptions")
@onready var itemOptions = preload("res://Utility/item_option.tscn")
@onready var sndLevelUp = get_node("%snd_levelup")
@onready var healthBar = get_node("%HealthBar")
@onready var lblTimer = get_node("%lblTimer")
@onready var collectedWeapons = get_node("%CollectedWeapons")
@onready var collectedUpgrades = get_node("%CollectedUpgrades")
@onready var itemContainer = preload("res://Player/GUI/item_container.tscn")

@onready var deathPanel = get_node("%DeathPanel")
@onready var lblResult = get_node("%lbl_Result")
@onready var sndVictory = get_node("%snd_victory")
@onready var sndLose = get_node("%snd_lose")

@onready var victoryPanel = get_node("%VictoryPanel")
@onready var victoryPanelSound = get_node("%VictoryPanelSound")
@onready var scoreSubmitName = get_node("%score_submit_name")
@onready var leaderboard = get_node("%leaderboard") as Leaderboard
@onready var playAgainButton = get_node("%play_again_button")

#Game session
@onready var sessionUpdateTimer = get_node("%SessionUpdateTimer") as Timer
var game_session = {}

#Signal
signal playerdeath


# These could be abstracted to an input manager
func check_movement_input():
	return (
		Input.is_action_just_pressed("ui_up")
		or Input.is_action_just_pressed("ui_down")
		or Input.is_action_just_pressed("ui_right")
		or Input.is_action_just_pressed("ui_left")
	)


const FACING_EPSILON = 0.1


func set_facing():
	# Setting scale doesn't work so we do this slightly
	# more complicsted logic.
	var new_flip = false
	if velocity.x < -FACING_EPSILON:
		new_flip = true
	elif velocity.x > FACING_EPSILON:
		new_flip = false
	else:
		# Just keep previous flip value
		return

	# Also flip offset if needed
	if new_flip != sprite.is_flipped_h():
		sprite.set_flip_h(new_flip)
		sprite.offset.x = -sprite.offset.x


func check_pathing_input():
	return not disable_pathing_input and Input.is_action_pressed("click")


func get_movement_vector():
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")


func get_pathing_target():
	return get_global_mouse_position()


func _ready():
	upgrade_character("dieslow1")
	set_expbar(experience, calculate_experiencecap())
	_on_hurt_box_hurt(0, 0, 0)
	for content in Unlocks.unlocked_content:
		_on_content_unlocked(content)
	Unlocks.content_unlocked.connect(_on_content_unlocked)
	current_skin = available_skins.pick_random()
	get_node(NodePath("Sprite2D")).texture = skins[current_skin]

	if not autopilot:
		game_session = await Server.create_game_session()
		sessionUpdateTimer.start(45)


func _on_content_unlocked(content):
	if content == "plugsuit":
		current_skin = "john_plugsuit"
		get_node(NodePath("Sprite2D")).texture = skins[current_skin]


func _physics_process(delta):
	pass


func _on_hurt_box_hurt(damage, _angle, _knockback):
	hp -= clamp(damage - armor, 1.0, 999.0)
	healthBar.max_value = maxhp
	healthBar.value = hp
	if hp <= 0:
		death()

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


func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calculate_experience(gem_exp)


func calculate_experience(gem_exp):
	var exp_required = calculate_experiencecap()
	collected_experience += gem_exp
	score += collected_experience
	if experience + collected_experience >= exp_required:  #level up
		collected_experience -= exp_required - experience
		experience_level += 1
		experience = 0
		exp_required = calculate_experiencecap()
		levelup()
	else:
		experience += collected_experience
		collected_experience = 0

	set_expbar(experience, exp_required)


func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level * 5
	elif experience_level < 40:
		exp_cap + 95 * (experience_level - 19) * 8
	else:
		exp_cap = 255 + (experience_level - 39) * 12

	return exp_cap


func set_expbar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value


func levelup():
	sndLevelUp.play()
	lblLevel.text = str("Level: ", experience_level)
	if autopilot:
		upgrade_character(get_random_item())
		return
	var tween = levelPanel.create_tween()
	(
		tween
		. tween_property(levelPanel, "position", Vector2(568, 200), 0.8)
		. set_trans(Tween.TRANS_QUINT)
		. set_ease(Tween.EASE_IN)
	)
	tween.play()
	levelPanel.visible = true
	var options = 0
	var optionsmax = 3
	while options < optionsmax:
		var option_choice = itemOptions.instantiate()
		option_choice.item = get_random_item()
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused = true


func upgrade_character(upgrade):
	match upgrade:
		"icespear1":
			attackManager.attacks["icespear"].level = 1
			attackManager.attacks["icespear"].base_ammo += 1
		"icespear2":
			attackManager.attacks["icespear"].level = 2
			attackManager.attacks["icespear"].base_ammo += 1
		"icespear3":
			attackManager.attacks["icespear"].level = 3
		"icespear4":
			attackManager.attacks["icespear"].level = 4
			attackManager.attacks["icespear"].baseammo += 2
		"tornado1":
			attackManager.attacks["tornado"].level = 1
			attackManager.attacks["tornado"].base_ammo += 1
		"tornado2":
			attackManager.attacks["tornado"].level = 2
			attackManager.attacks["tornado"].base_ammo += 1
		"tornado3":
			attackManager.attacks["tornado"].level = 3
			attackManager.attacks["tornado"].attack_speed -= 0.5
		"tornado4":
			attackManager.attacks["tornado"].level = 4
			attackManager.attacks["tornado"].base_ammo += 1
		"vinyl1":
			attackManager.attacks["vinyl"].level = 1
			attackManager.attacks["vinyl"].base_ammo += 1
		"vinyl2":
			attackManager.attacks["vinyl"].level = 2
			attackManager.attacks["vinyl"].base_ammo += 1
		"vinyl3":
			attackManager.attacks["vinyl"].level = 3
			attackManager.attacks["vinyl"].attack_speed -= 0.5
		"vinyl4":
			attackManager.attacks["vinyl"].level = 4
			attackManager.attacks["vinyl"].base_ammo += 1
		"javelin1":
			attackManager.attacks["javelin"].level = 1
			attackManager.attacks["javelin"].ammo = 1
		"javelin2":
			attackManager.attacks["javelin"].level = 2
		"javelin3":
			attackManager.attacks["javelin"].level = 3
		"javelin4":
			attackManager.attacks["javelin"].level = 4
		"dieslow1":
			attackManager.attacks["die_slow"].level = 1
			attackManager.attacks["die_slow"].base_ammo += 1
		"dieslow2":
			attackManager.attacks["die_slow"].level = 2
			attackManager.attacks["die_slow"].base_ammo += 1
		"dieslow3":
			attackManager.attacks["die_slow"].level = 3
			attackManager.attacks["die_slow"].base_ammo += 1
		"dieslow4":
			attackManager.attacks["die_slow"].level = 4
			attackManager.attacks["die_slow"].base_ammo += 1
		"armor1", "armor2", "armor3", "armor4":
			armor += 1
		"speed1", "speed2", "speed3", "speed4":
			movement_speed += 20.0
		"tome1", "tome2", "tome3", "tome4":
			spell_size += 0.10
		"scroll1", "scroll2", "scroll3", "scroll4":
			spell_cooldown += 0.05
		"ring1", "ring2":
			additional_attacks += 1
		"food":
			hp += 20
			hp = clamp(hp, 0, maxhp)
	adjust_gui_collection(upgrade)
	if attackManager.attacks["javelin"].level > 0:
		attackManager.spawn_javelin()
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	levelPanel.visible = false
	levelPanel.position = Vector2(800, 50)
	get_tree().paused = false
	calculate_experience(0)


func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades:  #Find already collected upgrades
			pass
		elif i in upgrade_options:  #If the upgrade is already an option
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item":  #Don't pick food
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0:  #Check for PreRequisites
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					to_add = false
			if to_add:
				dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrade_options.append(randomitem)
		return randomitem
	else:
		return null


func change_time(argtime = 0):
	time = argtime
	var get_m = int(time / 60.0)
	var get_s = time % 60
	if get_m < 10:
		get_m = str(0, get_m)
	if get_s < 10:
		get_s = str(0, get_s)
	lblTimer.text = str(get_m, ":", get_s)


func adjust_gui_collection(upgrade):
	var get_upgraded_displayname = UpgradeDb.UPGRADES[upgrade]["displayname"]
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"]
	if get_type != "item":
		var get_collected_displaynames = []
		for i in collected_upgrades:
			get_collected_displaynames.append(UpgradeDb.UPGRADES[i]["displayname"])
		if not get_upgraded_displayname in get_collected_displaynames:
			var new_item = itemContainer.instantiate()
			new_item.upgrade = upgrade
			match get_type:
				"weapon":
					collectedWeapons.add_child(new_item)
				"upgrade":
					collectedUpgrades.add_child(new_item)


func death():
	if autopilot:		
		emit_signal("playerdeath")
		get_tree().reload_current_scene()
		return	
	emit_signal("playerdeath")
	get_tree().paused = true

	if time >= 30:
		var name = choose_name()
		scoreSubmitName.text = name
		victoryPanel.visible = true
		var tween = victoryPanel.create_tween()
		(
			tween
			. tween_property(victoryPanel, "position", Vector2(220, 50), 3.0)
			. set_trans(Tween.TRANS_QUINT)
			. set_ease(Tween.EASE_OUT)
		)
		tween.play()
		victoryPanelSound.play()
	else:
		deathPanel.visible = true
		lblResult.text = "You Lose"
		var tween = deathPanel.create_tween()
		(
			tween
			. tween_property(deathPanel, "position", Vector2(220, 50), 3.0)
			. set_trans(Tween.TRANS_QUINT)
			. set_ease(Tween.EASE_OUT)
		)
		tween.play()
		sndLose.play()

func choose_name():
	var name = "HEALTH fan"
	if current_skin == "john" or current_skin == "john_plugsuit":
		name = "Johnny"
	elif current_skin == "beej":
		name = "Beej"
	elif current_skin == "jake":
		name = "Jake"
	return name	

func _on_btn_menu_click_end():
	get_tree().paused = false
	var _level = get_tree().change_scene_to_file("res://TitleScreen/menu.tscn")


func _on_session_update_timer_timeout():
	if game_session.has("id"):
		game_session = await Server.update_game_session(score)


func _on_btn_submit_score_click_end():
	victoryPanel.visible = false
	if game_session.has("id"):
		var name = scoreSubmitName.text
		if name.length() < 2:
			name = choose_name()
		var leaderboard_scores = await Server.submit_game_session(score, name)
		leaderboard.display(leaderboard_scores)
	leaderboard.visible = true
	playAgainButton.visible = true


func _on_play_again_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
