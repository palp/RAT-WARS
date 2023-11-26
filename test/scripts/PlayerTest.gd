# GdUnit generated TestSuite
class_name PlayerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scripts/Player.gd'


func test_get_autopilot_velocity() -> void:
	var player = load(__source).new()	
	var velocity = player.get_autopilot_velocity(Vector2(0,0), Array())
	assert_vector2(velocity).is_equal(Vector2(0,0))
	auto_free(player)
