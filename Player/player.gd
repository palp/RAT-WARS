class_name Player
extends CharacterBody2D

@export var autopilot = true
var disable_pathing_input = false
var disable_pausing = false
var disable_upgrades = false

@export var movement_speed = 40.0
@export var maxhp = 80
var hp = maxhp
var last_movement = Vector2.UP
var time = 0


var experience = 0
var experience_level = 1
var collected_experience = 0
var score = 0

# Credits loop
var credits_loop = false
@onready var credits_loop_video = preload("res://Video/big_rat_loop.ogv")

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

#Enemy Related
var enemy_close = []

@onready var sprite = $Sprite2D

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

@onready var winVideoPanel = get_node("%WinVideoPanel")
@onready var videoWin = get_node("%video_win")
@onready var winScoreForm = get_node("%WinScoreForm")
@onready var winScoreLabel = get_node("%WinScoreLabel")
@onready var scoreSubmitName = get_node("%score_submit_name")
@onready var leaderboard = get_node("%leaderboard")
@onready var loseVideoPanel = get_node("%LoseVideoPanel")
@onready var videoLose = get_node("%video_lose")
@onready var videoCredits = get_node("%video_credits")
@onready var leaderboardControl = get_node("%LeaderboardControl")

#Game session
@onready var sessionUpdateTimer = get_node("%SessionUpdateTimer") as Timer
var game_session = {}

#Signal
signal playerdeath
signal playervictory

# These could be abstracted to an input manager
func check_movement_input():
	return (
		Input.is_action_just_pressed("up")
		or Input.is_action_just_pressed("down")
		or Input.is_action_just_pressed("right")
		or Input.is_action_just_pressed("left")
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
	return Input.get_vector("left", "right", "up", "down")


func get_pathing_target():
	print_debug(get_global_mouse_position())
	return get_global_mouse_position()


func _ready():
	disable_pausing = false
	disable_pathing_input = false
	disable_upgrades = false
	upgrade_character("plug1")
	set_expbar(experience, calculate_experiencecap())
	_on_hurt_box_hurt(0, 0, 0)
	for content in Unlocks.unlocked_content:
		_on_content_unlocked(content)
	Unlocks.content_unlocked.connect(_on_content_unlocked)		
	update_player_character()

	if not autopilot:
		game_session = await Server.create_game_session()
		sessionUpdateTimer.start(45)	
		
	

func update_player_character():
	if autopilot:
		Unlocks.select_character(Unlocks.player_characters.keys().pick_random())
	get_node(NodePath("Sprite2D")).texture = Unlocks.get_player_character().get_current_skin().texture

func _on_content_unlocked(content):
	if content == "plugsuit":
		Unlocks.select_character("john")
		Unlocks.player_characters["john"].skins["plugsuit"].unlocked = true
		Unlocks.player_characters["john"].set_current_skin("plugsuit")
		update_player_character()


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
		exp_cap = 95 * (experience_level - 19) * 8
	else:
		exp_cap = 255 + (experience_level - 39) * 12

	return exp_cap


func set_expbar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value

func _input(event):
	# cheats for testing in debug mode
	if OS.is_debug_build():
		if event.is_action_pressed("ui_copy"):
			victory()
		if event.is_action_pressed("ui_cut"):
			death()
		if event.is_action_pressed("ui_paste"):
			upgrade_character(get_random_item())
		if event.is_action_pressed("ui_undo"):
			calculate_experience(calculate_experiencecap())
	if disable_upgrades and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.is_pressed():
		disable_upgrades = false

func levelup():	
	sndLevelUp.play()
	lblLevel.text = str("Level: ", experience_level)
	if autopilot:
		upgrade_character(get_random_item())
		return
	disable_pathing_input = true
	disable_pausing = true
	if Input.is_action_pressed("click"):
		disable_upgrades = true
	var tween = levelPanel.create_tween()
	(
		tween
		. tween_property(levelPanel, "position", Vector2(568, 200), 1.2)
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
		"plug1":
			attackManager.attacks["plug"].level = 1
			attackManager.attacks["plug"].base_ammo += 3
		"plug2":
			attackManager.attacks["plug"].level = 2
			attackManager.attacks["plug"].base_ammo += 1
		"plug3":
			attackManager.attacks["plug"].level = 3
			attackManager.attacks["plug"].base_ammo += 1
		"plug4":
			attackManager.attacks["plug"].level = 4
			attackManager.attacks["plug"].base_ammo += 1
		"stonefist1":
			attackManager.attacks["stonefist"].level = 1
			attackManager.attacks["stonefist"].base_ammo += 1
		"stonefist2":
			attackManager.attacks["stonefist"].level = 2
			attackManager.attacks["stonefist"].base_ammo += 1
		"stonefist3":
			attackManager.attacks["stonefist"].level = 3
		"stonefist4":
			attackManager.attacks["stonefist"].level = 4
			attackManager.attacks["stonefist"].base_ammo += 2
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
	disable_pathing_input = false
	disable_pausing = false
	levelPanel.visible = false
	levelPanel.position = Vector2(568, 1200)
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
	if upgrade == null:
		return
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

	disable_pausing = true
	disable_pathing_input = true
	disable_upgrades = true	
	loseVideoPanel.visible = true
	videoLose.visible = true
	videoLose.play()
		
func victory():	
	if autopilot:
		get_tree().reload_current_scene()
		return
	emit_signal("playervictory")
	var name = choose_name()
	get_tree().paused = true
	disable_pausing = true
	disable_pathing_input = true
	disable_upgrades = true
	scoreSubmitName.text = name
	winScoreLabel.text = str(score)
	winScoreForm.visible = false
	winVideoPanel.visible = true
	videoWin.visible = true	
	videoWin.play()
	
func choose_name():
	var name = "HEALTH fan"
	if Unlocks.selected_character == "john":
		name = "Johnny"
	elif Unlocks.selected_character == "beej":
		name = "Beej"
	elif Unlocks.selected_character == "jake":
		name = "Jake"
	return name

func _on_session_update_timer_timeout():
	if game_session.has("id"):
		game_session = await Server.update_game_session(score)


func _on_btn_submit_score_click_end():
	winScoreForm.visible = false
	videoCredits.visible = true
	videoCredits.play()
	if game_session.has("id"):
		var name = scoreSubmitName.text
		if name.length() < 2:
			name = choose_name()
		var leaderboard_scores = await Server.submit_game_session(score, name)
		if leaderboard_scores:
			leaderboard.display(leaderboard_scores)
	show_leaderboard()
		
func show_leaderboard():
	print_debug("now showing leaderboard")
	leaderboardControl.visible = true

func _on_play_again_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_video_lose_finished():
	videoLose.visible = false
	get_node("%video_lose_bg").play()
	get_node("%video_lose_bg_loop").visible = false
	get_node("%video_lose_bg").visible = true

func _on_give_up_button_pressed():
	get_tree().change_scene_to_file("res://demo.tscn")

func _on_video_win_finished():
	winScoreForm.visible = true
	videoWin.visible = false

func _on_video_lose_bg_finished():	
	var bg_loop = get_node("%video_lose_bg_loop")	
	bg_loop.play()
	bg_loop.visible = true
	get_node("%video_lose_bg").visible = false


func _on_video_lose_bg_loop_finished():
	get_node("%video_lose_bg_loop").play()


func _on_video_credits_finished():
	if not credits_loop:
		credits_loop = true
		var credits_node = get_node("%video_credits")
		credits_node.stream = credits_loop_video
		credits_node.loop = true
		credits_node.play()
