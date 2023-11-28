# GdUnit generated TestSuite
class_name AutopilotTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")
# TestSuite generated from
const __source = "res://scripts/StateMachine/Autopilot.gd"

var autopilot


func before_test():
	autopilot = auto_free(load(__source).new())
	autopilot.player = mock(Player, CALL_REAL_FUNC)


func test_get_autopilot_velocity_no_enemies() -> void:
	var velocity = autopilot.get_autopilot_velocity(Vector2(0, 0), Array())
	assert_vector2(velocity).is_not_equal(Vector2(0, 0))


func test_get_autopilot_velocity_one_enemy() -> void:
	var enemies = Array()
	var enemy_1 = Node2D.new()
	auto_free(enemy_1)
	enemy_1.global_position = Vector2(0, 0.1)
	enemies.append(enemy_1)
	var velocity = autopilot.get_autopilot_velocity(Vector2(0, 0), enemies)
	assert_float(velocity.y).is_less(0)
