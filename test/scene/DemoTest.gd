class_name DemoSceneTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")
const __source = "res://World/launch.tscn"

func before_test():
	# Ensure opening cutscene does not play
	UserSettings.config.set_value("cutscene", "opening_played", true)

func test_attract_mode() -> void:
	var runner := scene_runner(__source)
	var player = runner.find_child("Player")
	var position = player.global_position
	player.autopilot = true
	await runner.simulate_frames(120)	
	assert_vector(player.global_position).is_not_equal(position)


func process_key_press(runner, key, frames = 60):
	runner.simulate_key_press(key)
	await runner.simulate_frames(frames)
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
