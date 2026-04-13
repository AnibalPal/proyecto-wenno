@tool
extends Node2D
class_name CameraParams

@export var line_color := Color.GREEN
@export var line_width := 3

@onready var top_left: Node2D = $TopLeft
@onready var bottom_right: Node2D = $BottomRight
@onready var camera_icon: Sprite2D = $CameraChangeTrigger/CameraIcon
@onready var camera_collision: CollisionShape2D = $CameraChangeTrigger/CameraCollision
@onready var camera_change_trigger: Area2D = $CameraChangeTrigger

signal s_camera_params_changed(params: Dictionary)

func _draw() -> void:
	if(Engine.is_editor_hint()):
		var rect_to_draw = Rect2(
			top_left.position, 
			bottom_right.position - top_left.position, 
		)
		draw_rect(rect_to_draw, line_color, false, line_width)

func _process(_delta: float) -> void:
	if(Engine.is_editor_hint()):
		camera_icon.show()
		camera_icon.modulate = line_color
		camera_collision.debug_color = Color(line_color, 0.2)
		queue_redraw()
	else:
		camera_icon.hide()

func get_bounds():
	return {
		"top": top_left.global_position.y,
		"right": bottom_right.global_position.x,
		"bottom": bottom_right.global_position.y,
		"left": top_left.global_position.x,
	}

func _on_camera_change_trigger_area_entered(_area: Area2D) -> void:
	s_camera_params_changed.emit(get_bounds())
