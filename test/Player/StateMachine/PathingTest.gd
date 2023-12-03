# GdUnit generated TestSuite
class_name PathingTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")
# TestSuite generated from
const __source = "res://Player/StateMachine/Pathing.gd"


func test_physics_update() -> void:
	var pathing = auto_free(load(__source).new())
	pathing.player = mock(Player)
	pathing.state_machine = mock(StateMachine)
	pathing.player.position = Vector2.ZERO

	# Distance greater than 10 triggers movement
	pathing.target = Vector2(20.0, 20.0)
	pathing.physics_update(0.1)
	assert_vector(pathing.player.velocity).is_not_equal(Vector2.ZERO)

	# Distance less than 10 means no movement, return to idle
	pathing.target = pathing.player.position
	pathing.physics_update(0.1)
	assert_vector(pathing.player.velocity).is_equal(Vector2.ZERO)
	verify(pathing.state_machine, 1).transition_to("Idle")

	# Movement input interrupts pathing
	pathing.target = Vector2(100.0, 100.0)
	do_return(true).on(pathing.player).check_movement_input()
	pathing.physics_update(0.1)
	assert_vector(pathing.player.velocity).is_not_equal(Vector2.ZERO)
	verify(pathing.state_machine, 1).transition_to("Moving")
	do_return(false).on(pathing.player).check_movement_input()

	# Mouse clicks change path
	pathing.target = Vector2.ZERO
	do_return(true).on(pathing.player).check_pathing_input()
	do_return(Vector2(100.0, 0)).on(pathing.player).get_pathing_target()
	pathing.physics_update(0.1)
	assert_vector(pathing.player.velocity).is_not_equal(Vector2.ZERO)
	assert_vector(pathing.target).is_equal(Vector2(100.0, 0))
	verify(pathing.player, 1).get_pathing_target()
	do_return(false).on(pathing.player).check_pathing_input()
