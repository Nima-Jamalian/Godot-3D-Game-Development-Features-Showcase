extends RigidBody3D

# Enable Contact Monitor in the Inspector
# Set Max Contacts Reported to 1 or higher

# Called when this body collides with another physics body
func _on_body_entered(body: Node) -> void:
	# Print the name of the object we collided with
	print("Collided with:", body.name)

	# Check if the collided object is named "Capsul"
	if body.name == "Capsul":
		# Remove the object from the scene
		body.queue_free()
