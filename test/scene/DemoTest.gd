class_name DemoSceneTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

const __source = 'res://demo.tscn'

func test_attract_mode() -> void:
	var runner := scene_runner(__source)	
	var player = runner.find_child("Player")
	var position = player.global_position
	player.autopilot = true
	await runner.simulate_frames(60)
	assert_vector2(player.global_position).is_not_equal(position)

func process_key_press(runner, key):
	runner.simulate_key_press(key)
	await await_idle_frame()
	runner.simulate_key_release(key)
	await await_idle_frame()
	
func test_input_mode() -> void:
	var runner := scene_runner(__source)
	var player = runner.find_child("Player")
	var position = player.global_position
	player.autopilot = false
	await process_key_press(runner, KEY_DOWN)
	assert_float(player.position.y).is_greater(position.y)	
	position = player.position
	
	await process_key_press(runner, KEY_UP)
	assert_float(player.position.y).is_less(position.y)	
	position = player.position
	
	await process_key_press(runner, KEY_LEFT)
	assert_float(player.position.x).is_less(position.x)
	position = player.position
	
	await process_key_press(runner, KEY_RIGHT)
	assert_float(player.position.x).is_greater(position.x)
