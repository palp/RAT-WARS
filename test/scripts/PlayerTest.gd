# GdUnit generated TestSuite
class_name PlayerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scripts/Player.gd'


func test_get_autopilot_velocity_no_enemies() -> void:
	var player = load(__source).new()
	auto_free(player)
	var velocity = player.get_autopilot_velocity(Vector2(0,0), Array())
	assert_vector2(velocity).is_not_equal(Vector2(0,0))	
	
func test_get_autopilot_velocity_one_enemy() -> void:
	var player = load(__source).new()
	auto_free(player)
	var enemies = Array()
	var enemy_1 = Node2D.new()
	auto_free(enemy_1)
	enemy_1.global_position = Vector2(0.1,0.1)
	enemies.append(enemy_1)
	var velocity = player.get_autopilot_velocity(Vector2(0,0), enemies)	
	assert_vector2(velocity).is_less(Vector2(0,0))
