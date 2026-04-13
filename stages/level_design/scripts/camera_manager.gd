extends Node
class_name CameraManager

@export var player_camera : Camera2D

func _ready() -> void:
	assert(player_camera, "ERROR: CameraManager - no player camera set")
	for child in get_children():
		assert(child is CameraParams, "ERROR: CameraManager must have only CameraParam type childs")
		child.camera_change_trigger.owner.s_camera_params_changed.connect(on_player_camera_entered)

func on_player_camera_entered(camera_params: Dictionary):
	#player_camera.limit_top = camera_params["top"]
	#player_camera.limit_right = camera_params["right"]
	#player_camera.limit_bottom = camera_params["bottom"]
	#player_camera.limit_left = camera_params["left"]
	
	# TEST IDEA: set the camera limits to the current camera bounds, then tween
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(player_camera, "limit_top", camera_params["top"], 2.0)
	tween.parallel().tween_property(player_camera, "limit_right", camera_params["right"], 2.0)
	tween.parallel().tween_property(player_camera, "limit_bottom", camera_params["bottom"], 2.0)
	tween.parallel().tween_property(player_camera, "limit_left", camera_params["left"], 2.0)
