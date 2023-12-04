# GdUnit generated TestSuite
class_name attack_manager_test
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://Player/Attack/attack_manager.gd'


# Just a basic test of spawning for now
func test_process() -> void:
	var manager = auto_free(load(__source).new()) as attack_manager
	manager.attacker = mock(Player)
	manager.plug_base = mock(Node2D)
	manager.javelin_base = mock(Node2D)
	manager.attacker.hp = 100
	manager._process(100)
	assert_array(manager.get_children()).is_empty()
	manager.attacks['vinyl'].level = 1
	manager.attacks['vinyl'].base_ammo = 1
	manager._process(100)
	assert_array(manager.get_children()).is_not_empty()
