extends Area3D


## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

# Called when a physics body enters the Area3D.
# Use this function to detect objects entering the area and respond to them.
# The body parameter represents the physics body that entered the Area3D.
func _on_body_entered(body: Node3D) -> void:
	# Print the name of the body that entered the Area3D.
	# This is useful for checking which object triggered the signal.
	print("Body entered:  ", body.name)
	
	# Check the body by its node name.
	# If the body's name is "GreenBall2", remove it from the scene.
	if body.name == "GreenBall2":
		# queue_free() queues the node for deletion.
		body.queue_free()
	
	# Check whether the body belongs to a specific group.
	# Groups allow you to identify objects without relying on their node names.
	if body.is_in_group("red_balls"):
		# Remove the body if it belongs to the "red_balls" group.
		body.queue_free()
	
	# Check the body by its node type.
	# This condition is true if the body is a CharacterBody3D.
	if body is CharacterBody3D:
		# Find the MeshInstance3D node inside the body.
		var mesh = body.get_node("MeshInstance3D")
		
		# Get the active material assigned to surface 0 of the mesh.
		var material = mesh.get_active_material(0)
		
		# Change the material's colour to blue.
		material.albedo_color = Color.BLUE
	pass # Replace with function body.


# Called when a physics body exits the Area3D.
# Use this function to respond when an object leaves the area.
# The body parameter represents the physics body that entered the Area3D.
func _on_body_exited(body: Node3D) -> void:
	# Check whether the body leaving the Area3D is a CharacterBody3D.
	if body is CharacterBody3D:
		# Find the MeshInstance3D child node.
		var mesh = body.get_node("MeshInstance3D")
		
		# Get the active material assigned to the mesh's first surface (index 0).
		var material = mesh.get_active_material(0)
		
		# Change the material's albedo colour back to white.
		# This restores the character's original colour when it leaves the Area3D.
		material.albedo_color = Color.WHITE
	pass # Replace with function body.
