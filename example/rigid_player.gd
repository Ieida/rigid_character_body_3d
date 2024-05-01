extends RigidCharacterBody3D

func _ready():
	super._ready()
	#region Input Actions
	InputMap.add_action("move_left")
	InputMap.add_action("move_right")
	InputMap.add_action("move_forward")
	InputMap.add_action("move_backward")
	InputMap.add_action("jump")
	InputMap.add_action("run")
	var e = InputEventKey.new()
	e.key_label = KEY_A
	InputMap.action_add_event("move_left", e)
	e = InputEventKey.new()
	e.key_label = KEY_D
	InputMap.action_add_event("move_right", e)
	e = InputEventKey.new()
	e.key_label = KEY_W
	InputMap.action_add_event("move_forward", e)
	e = InputEventKey.new()
	e.key_label = KEY_S
	InputMap.action_add_event("move_backward", e)
	e = InputEventKey.new()
	e.key_label = KEY_SPACE
	InputMap.action_add_event("jump", e)
	e = InputEventKey.new()
	e.key_label = KEY_SHIFT
	InputMap.action_add_event("run", e)
	#endregion
	
	# Capture mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func process_character_input():
	input_direction = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	jump_input = Input.is_action_just_pressed("jump")
	run_input = Input.is_action_just_pressed("run")
