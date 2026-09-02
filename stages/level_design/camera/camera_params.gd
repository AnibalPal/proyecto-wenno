@tool
extends Node2D
class_name CameraParams

@export var draw_guideline := true
@export var guideline_color := Color.RED
@export var guideline_width := 6

@export var line_color := Color.GREEN
@export var line_width := 3

@export var instant := false

@onready var top_left: Node2D = $TopLeft
@onready var bottom_right: Node2D = $BottomRight
@onready var camera_triggers: Node2D = $CameraTriggers

signal s_camera_params_changed(params: Dictionary, instant : bool)

func _ready() -> void:
	for camera_change_trigger: CameraChangeTrigger in camera_triggers.get_children():
		camera_change_trigger.area_entered.connect(_on_camera_change_trigger_area_entered)

func _draw() -> void:
	if(Engine.is_editor_hint()):
		# Draw project size guideline
		if(draw_guideline):
			var base_width = ProjectSettings.get_setting("display/window/size/viewport_width")
			var base_height = ProjectSettings.get_setting("display/window/size/viewport_height")
			var base_size = Vector2(base_width, base_height)
			var base_rect_viewport = Rect2(
				Vector2.ZERO,
				base_size
			)
			draw_rect(base_rect_viewport, guideline_color, false, guideline_width)
		
		# Draw camera bounds
		var rect_to_draw = Rect2(
			top_left.position, 
			bottom_right.position - top_left.position, 
		)
		draw_rect(rect_to_draw, line_color, false, line_width)

func _process(_delta: float) -> void:
	if(Engine.is_editor_hint()):
		for camera_change_trigger: CameraChangeTrigger in camera_triggers.get_children():
			camera_change_trigger.show_camera_icon()
			camera_change_trigger.set_colors(line_color)
		queue_redraw()
	else:
		for camera_change_trigger: CameraChangeTrigger in camera_triggers.get_children():
			camera_change_trigger.hide_camera_icon()

func get_bounds():
	return {
		"top": top_left.global_position.y,
		"right": bottom_right.global_position.x,
		"bottom": bottom_right.global_position.y,
		"left": top_left.global_position.x,
	}

func _on_camera_change_trigger_area_entered(_area: Area2D) -> void:
	s_camera_params_changed.emit(get_bounds(), instant)
