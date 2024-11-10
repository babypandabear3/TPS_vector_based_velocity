extends CharacterBody3D

const MAX_SPEED = 10.0
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var h_velocity := Vector3.ZERO
var v_velocity := Vector3.ZERO
var impulse := Vector3.ZERO
var last_major_direction  := Vector3.FORWARD
var acc := 0.1
var deacc := 0.9
var impulse_deacc := 55.0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("exit_game"):
		get_tree().quit()
		
	h_velocity = velocity.slide(Vector3.UP)
	v_velocity = velocity.project(Vector3.UP)
	
	# Add the gravity.
	if not is_on_floor():
		v_velocity += Vector3.UP * get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		v_velocity = Vector3.UP * JUMP_VELOCITY

	if impulse.is_zero_approx() and Input.is_action_just_pressed("dash"):
		impulse = last_major_direction * 5.0
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		h_velocity += direction * SPEED * acc
		h_velocity = h_velocity.limit_length(MAX_SPEED) #SPEED LIMIT
	else:
		h_velocity *= deacc
		
	velocity = h_velocity + v_velocity + impulse
	
	impulse *= impulse_deacc * delta

	if h_velocity.length() > 0.5:
		last_major_direction = h_velocity.normalized()
	
	move_and_slide()
