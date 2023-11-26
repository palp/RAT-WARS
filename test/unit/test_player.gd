extends GutTest


class TestMovement:
	extends GutTest

	var PlayerObj = load("res://scripts/Player.gd")
	var EnemyObj = load("res://scripts/enemy_basic.gd")
	var _obj = null

	func before_each():
		_obj = PlayerObj.new()
		_obj.add_to_group('player')
	
	func test_autopilot_no_enemies():
		_obj.autopilot = true
		add_child_autofree(_obj)
		var position = _obj.global_position
		# May take many frames for random walk to occur
		gut.simulate(_obj, 100, .1)
		assert_ne(position, _obj.global_position)
	
	# This test won't hold up as we add more logic, it's just a demo
	func test_autopilot_one_enemy():
		_obj.autopilot = true
		add_child_autofree(_obj)
		var enemy = EnemyObj.new()
		enemy.add_to_group('enemy')
		_obj.add_child(enemy)
		var position = _obj.global_position
		var enemy_position = enemy.global_position
		var distance = position - enemy_position		
		gut.simulate(_obj, 60, .1)
		assert_ne(position, _obj.global_position)
		# Check against the old position since enemies move
		var new_distance = _obj.global_position - enemy_position
		assert_gt(abs(new_distance), distance)
	
	func test_no_autopilot():
		_obj.autopilot = false
		add_child_autofree(_obj)
		var position = _obj.global_position
		gut.simulate(_obj, 100, .1)
		assert_eq(position, _obj.global_position)
