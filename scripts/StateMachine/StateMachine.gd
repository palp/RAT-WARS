# Generic state machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
class_name StateMachine
extends Node

# Emitted when transitioning to a new state.
signal transitioned(state_name)

# Path to the initial active state. We export it to be able to pick the initial state in the inspector.
@export var initial_state := NodePath()

# The current active state. At the start of the game, we get the `initial_state`.
@onready var state: State = get_node(initial_state)


func _ready() -> void:
	if owner != null:
		await owner.ready
	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		child.state_machine = self
	if state != null:
		state.enter()


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	if state != null:
		state.handle_input(event)


func _process(delta: float) -> void:
	if state != null:
		state.update(delta)


func _physics_process(delta: float) -> void:
	if state != null:
		state.physics_update(delta)


# This function calls the current state's exit() function, then changes the active state,
# and calls its enter function.
# It optionally takes a `msg` dictionary to pass to the next state's enter() function.
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	# Safety check
	if not has_node(target_state_name):
		return

	if state != null:
		state.exit()
		
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
	print_debug(target_state_name)
