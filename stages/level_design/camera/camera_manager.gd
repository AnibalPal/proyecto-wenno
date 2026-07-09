extends Node
class_name CameraManager

@export var tween_duration := 2.0
var player_camera : Camera2D
@export var initial_params : CameraParams

var current_tween

func _ready() -> void:
	assert(initial_params, "ERROR: CameraManager - no inital camera params set")
	
	# Find the camera from the true player or the Debug player depending on if the
	# Chamber is being tested only for this stage or is the actual stage being played
	# TODO: Improve this
	player_camera = get_tree().root.get_node_or_null("YastayStage/Player/PlayerCamera")
	if(!player_camera):
		player_camera = get_node_or_null("../../DebugPlayer/PlayerCamera")
	assert(player_camera, "ERROR: CameraManager - no player camera set or found")
	
	for child in get_children():
		assert(child is CameraParams, "ERROR: CameraManager must have only CameraParam type childs")
		child.camera_triggers.owner.s_camera_params_changed.connect(on_player_camera_entered)
	var initial_camera_params = initial_params.get_bounds()
	player_camera.limit_top = initial_camera_params["top"]
	player_camera.limit_right = initial_camera_params["right"]
	player_camera.limit_bottom = initial_camera_params["bottom"]
	player_camera.limit_left = initial_camera_params["left"]

func reset_limits_to_current_view(camera_to_change: Camera2D, camera_params: Dictionary) -> void:
	var canvas_transform = get_viewport().get_canvas_transform()
	var viewport_rect = get_viewport().get_visible_rect()
	
	var top_left = canvas_transform.affine_inverse() * viewport_rect.position
	var bottom_right = canvas_transform.affine_inverse() * viewport_rect.end

	if(!is_equal_approx(camera_to_change.limit_top, camera_params["top"])):
		camera_to_change.limit_top = int(top_left.y)
	if(!is_equal_approx(camera_to_change.limit_right, camera_params["right"])):
		camera_to_change.limit_right = int(bottom_right.x)
	if(!is_equal_approx(camera_to_change.limit_bottom, camera_params["bottom"])):
		camera_to_change.limit_bottom = int(bottom_right.y)
	if(!is_equal_approx(camera_to_change.limit_left, camera_params["left"])):
		camera_to_change.limit_left = int(top_left.x)

func on_player_camera_entered(camera_params: Dictionary):	
	reset_limits_to_current_view(player_camera, camera_params)
	
	if(current_tween):
		current_tween.kill()
	current_tween = get_tree().create_tween()
	current_tween.parallel().tween_property(player_camera, "limit_top", camera_params["top"], tween_duration)
	current_tween.parallel().tween_property(player_camera, "limit_right", camera_params["right"], tween_duration)
	current_tween.parallel().tween_property(player_camera, "limit_bottom", camera_params["bottom"], tween_duration)
	current_tween.parallel().tween_property(player_camera, "limit_left", camera_params["left"], tween_duration)
