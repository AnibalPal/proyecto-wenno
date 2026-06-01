@tool
extends Area2D
class_name CameraChangeTrigger

@onready var camera_collision: CollisionShape2D = $CameraCollision
@onready var camera_icon: Sprite2D = $CameraIcon

func set_colors(color: Color) -> void:
	camera_icon.modulate = color
	camera_collision.debug_color = Color(color, 0.2)

func show_camera_icon() -> void:
	camera_icon.show()

func hide_camera_icon() -> void:
	camera_icon.hide()
