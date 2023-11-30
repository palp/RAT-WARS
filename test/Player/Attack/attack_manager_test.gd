# GdUnit generated TestSuite
class_name attack_manager_test
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://Player/Attack/attack_manager.gd'


# Just a basic test of spawning for now
func test_process() -> void:
	var attack_manager = auto_free(load(__source).new()) as attack_manager
	attack_manager.attacker = mock(Player)
	attack_manager.attacker.hp = 100
	attack_manager._process(100)
	assert_array(attack_manager.get_children()).is_empty()
	attack_manager.attacks['vinyl'].level = 1
	attack_manager.attacks['vinyl'].base_ammo = 1
	attack_manager._process(100)
	assert_array(attack_manager.get_children()).is_not_empty()
