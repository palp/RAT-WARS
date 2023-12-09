# GdUnit generated TestSuite
class_name AutopilotTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")
# TestSuite generated from
const __source = "res://Player/StateMachine/Autopilot.gd"

var autopilot


func before_test():
	autopilot = auto_free(load(__source).new())
	autopilot.player = mock(Player, CALL_REAL_FUNC)

func test_get_autopilot_velocity_one_enemy() -> void:
	var enemies = Array()
	var enemy_1 = mock(EnemyBase)
	enemy_1.name = "small_rat"
	auto_free(enemy_1)
	enemy_1.global_position = Vector2(0, 0.1)
	enemies.append(enemy_1)
	var velocity = autopilot.get_autopilot_velocity(Vector2(0, 0), enemies)
	assert_float(velocity.y).is_less(0)
