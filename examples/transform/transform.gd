extends Node3D

func _ready() -> void:
	# Set the sphere's position
	%Sphere.position = Vector3(-8, 1, -7)

	# Set the cube's rotation in degrees
	%Cube.rotation_degrees = Vector3(45, 90, 0)

	# Increase the capsule's scale
	%Capsul.scale = Vector3(2, 2, 2)


func _process(delta: float) -> void:
	# Move the sphere along the X axis over time
	%Sphere.position.x += 1 * delta
