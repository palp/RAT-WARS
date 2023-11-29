# GdUnit generated TestSuite
class_name AttackManagerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://old/AttackManager.gd'


# Just a basic test of spawning for now
func test_process() -> void:
	var attack_manager = auto_free(load(__source).new())
	attack_manager.player = mock(Player)
	attack_manager.player.health = 100
	attack_manager._process(100)
	assert_array(attack_manager.get_children()).is_not_null()
