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


extends RigidBody3D
class_name RigidCharacterBody3D


## The node used as orientation reference.
## If this node will be used for the player, this
## variable should be set to the player's camera.
## If it is null, the current node will be
## used as orientation reference.
@export var orientation_node: Node3D:
	get:
		if not orientation_node: return self
		return orientation_node
## World space gravity vector.
@export var gravity: Vector3 = Vector3(0, -9.8, 0)
## The force used to jump with.
@export var jump_force: float = 5.0
## The force used to walk with.
@export var walk_force: float = 15
## The force used to run with.
@export var run_force: float = 20
## The force used for moving around when in the air.
@export var air_force: float = 5
## The amount of uniform drag this body experiences. This scales with the velocity
@export var drag_force: float = 0.1
## The density of the fluid the body is moving in. By default it's set to the density of air.
@export var fluid_density: float = 1.293


var is_on_floor: bool
var floor_normal: Vector3 = Vector3.UP
var is_on_wall: bool
var wall_normal: Vector3 = Vector3.RIGHT
var is_on_ceiling: bool
var ceiling_normal: Vector3 = Vector3.DOWN
var is_running: bool
var input_direction: Vector2
var jump_input: bool
var run_input: bool


func _ready():
	# Set up body
	axis_lock_angular_x = true
	axis_lock_angular_y = true
	axis_lock_angular_z = true
	contact_monitor = true
	max_contacts_reported = 16
	continuous_cd = true
	
	# Capture mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	_process_state()
	
	process_character_input()
	
	apply_movement(delta)
	
	# Add gravity
	apply_central_impulse(gravity * delta)
	
	apply_drag(delta)
	
	reset_input()


func _process_state():
	var s = PhysicsServer3D.body_get_direct_state(get_rid())
	var cc = s.get_contact_count()
	if cc == 0:
		is_on_floor = false
		is_on_wall = false
		is_on_ceiling = false
	for ci in cc:
		var n = s.get_contact_local_normal(ci)
		var d = n.dot(Vector3.UP)
		
		is_on_floor = d >= 0.5
		if is_on_floor:
			floor_normal = n
		else:
			floor_normal = global_basis.y
		
		is_on_wall = d < 0.5 and d > -0.5
		if is_on_wall:
			wall_normal = n
		
		is_on_ceiling = d <= -0.5
		if is_on_ceiling:
			ceiling_normal = n


func apply_drag(delta: float):
	var v = linear_velocity.length()
	var v2 = linear_velocity.length_squared()
	var cd = 2.0 * drag_force * fluid_density * v
	var fd = 1.0/2.0 * fluid_density * v2 * cd
	var drag = -linear_velocity.normalized() * fd
	drag = drag.limit_length(linear_velocity.length())
	apply_central_impulse(drag * delta)


func apply_movement(delta: float):
	if Input.is_action_just_pressed("jump"):
		if is_on_floor:
			apply_central_impulse(floor_normal * jump_force)
		elif is_on_wall:
			var new_norma = (wall_normal + global_basis.y).normalized()
			apply_central_impulse(new_norma * jump_force)
	if Input.is_action_just_pressed("run") and is_on_floor:
		is_running = true
	
	var forward = floor_normal.cross(orientation_node.global_basis.x)
	var right = forward.cross(floor_normal)
	var dir = ((forward * input_direction.y) + (right * input_direction.x)).normalized()
	if dir:
		var move_forc = air_force if not is_on_floor else run_force if is_running else walk_force
		apply_central_impulse(dir * move_forc * delta)
	elif is_running:
		is_running = false


func process_character_input():
	pass


func reset_input():
	input_direction = Vector2.ZERO
	jump_input = false
	run_input = false
