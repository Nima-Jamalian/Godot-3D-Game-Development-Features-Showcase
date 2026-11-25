extends Node3D

@export var rotation_speed: float = 2.0
@export var float_speed: float = 2.0
@export var float_height: float = 0.1
var start_position: Vector3

func _ready():
	start_position = position
	
func _process(delta):
	# Rotate continuously
	rotate_y(rotation_speed * delta)
	
	# Move up and down
	position.y = start_position.y + sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_height
	
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("Coin Collected!");
		get_parent().get_node("AudioStreamPlayer").play()
		queue_free()
