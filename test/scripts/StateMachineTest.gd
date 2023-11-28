class_name StateMachineTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")
const __source = "res://scripts/StateMachine/StateMachine.gd"
const __stateSource = "res://scripts/StateMachine/State.gd"


func test_ready():
	var state_machine = load(__source).new()
	var stateObj = load(__stateSource)
	auto_free(state_machine)
	var state = auto_free(stateObj.new())
	state.name = "state1"
	state_machine.add_child(state)
	state_machine.initial_state = NodePath("state1")
	state_machine._ready()
	assert_object(state_machine.state).is_not_null().is_same(state)
	assert_object(state.state_machine).is_not_null().is_same(state_machine)


func test_transition_to():
	var state_machine := monitor_signals(load(__source).new())
	var stateObj = load(__stateSource)
	var state1 = auto_free(stateObj.new())
	var state2 = auto_free(stateObj.new())
	state1.name = "state1"
	state2.name = "state2"
	state_machine.add_child(state1)
	state_machine.add_child(state2)
	state_machine.initial_state = NodePath("state1")
	state_machine._ready()
	assert_object(state_machine.state).is_not_same(state2)
	state_machine.transition_to("state2")
	await assert_signal(state_machine).is_emitted("transitioned", ["state2"])
	assert_object(state_machine.state).is_same(state2)
	assert_object(state_machine.state).is_not_same(state1)
	state_machine.transition_to("state1")
	await assert_signal(state_machine).is_emitted("transitioned", ["state1"])
	assert_object(state_machine.state).is_same(state1)
	state_machine.transition_to("invalid_state")
	await assert_signal(state_machine).is_not_emitted("transitioned")
	assert_object(state_machine.state).is_same(state1)
