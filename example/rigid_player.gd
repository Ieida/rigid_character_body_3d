#Copyright 2024 David Krstevski
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the “Software”), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is furnished
#to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
#CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


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
