extends CharacterBody3D

@export var speed := 5.0
@export var jump_velocity := 4.5
@export var mouse_sensitivity := 0.3
@export var rotation_speed := 10.0

@onready var camera_pivot = $CameraPivot
@onready var character_model = $Visuals
@onready var spring_arm = $CameraPivot/SpringArm3D


func _ready() -> void:
	# Capture the mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Prevent the spring arm from colliding with the player
	spring_arm.add_excluded_object(get_rid())


func _unhandled_input(event: InputEvent) -> void:
	# Rotate the camera using mouse movement
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			camera_pivot.rotation_degrees.y -= event.relative.x * mouse_sensitivity
			camera_pivot.rotation_degrees.x -= event.relative.y * mouse_sensitivity

			# Limit vertical camera rotation
			camera_pivot.rotation_degrees.x = clamp(
				camera_pivot.rotation_degrees.x, -60.0, 60.0
			)

	# Release or capture the mouse
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get movement input
	var input_dir = Input.get_vector(
		"move_left", "move_right",
		"move_forward", "move_backward"
	)

	# Calculate movement relative to the camera's horizontal rotation
	var direction = Vector3(input_dir.x, 0, input_dir.y)
	# moves the character in the direction the camera is facing horizontally.
	direction = direction.rotated(
		Vector3.UP, camera_pivot.rotation.y
	)

	if direction != Vector3.ZERO:
		# Move the player
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

		# Calculate the direction the character should face
		# atan2() allows us to calculate an angle from two components of a vector
		var target_angle = atan2(direction.x, direction.z)

		# Smoothly rotate the character model
		# We use clampf() to ensure that the interpolation weight passed to lerp_angle() stays between 0.0 and 1.0.
		character_model.rotation.y = lerp_angle(
			character_model.rotation.y,
			target_angle,
			clampf(rotation_speed * delta, 0.0, 1.0)
		)
	else:
		# Stop horizontal movement
		velocity.x = 0
		velocity.z = 0

	move_and_slide()
	
	# Handle collisions with other physics bodies
	handle_collisions()
			

# Checks for collisions with other physics bodies and pushes any RigidBody3D objects the player touches.
func handle_collisions() -> void:
	# get_slide_collision_count() returns the number of collisions detected during the current movement.
	for i in get_slide_collision_count():
		# Get collision information
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		# Check if the collided object is a RigidBody3D
		if collider is RigidBody3D:
			print("Player Collider hit: ",collider.name)
			
			# Get the direction to push the object
			var push_direction = -collision.get_normal()
			
			# Apply an impulse to push the object
			collider.apply_central_impulse(push_direction * 2.0)
