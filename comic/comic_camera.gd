extends Camera2D
class_name ComicCameraEffect

signal s_camera_effect_done

const CameraEffects = ComicCameraEffectData.CameraEffects

var shake_strength := 0.0
var shake_decay := 10.0
var current_offset : Vector2

func _process(delta: float) -> void:
	if(shake_strength > 0):
		shake_strength = lerp(shake_strength, -1.0, shake_decay * delta)
		offset = current_offset + Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
		if(shake_strength <= 0):
			s_camera_effect_done.emit()

func play_camera_effect(effect_data : ComicCameraEffectData) -> void:
	var params = effect_data.camera_effect_params
	var effect = effect_data.camera_effect
	match effect:
		CameraEffects.RESET:
			reset_camera_params()
			s_camera_effect_done.emit()
		CameraEffects.SET_POSITION:
			assert(params.has("x_offset") and params.has("y_offset"), "MISSING PARAMS FOR SET_POSITION CAMERA EFFECT")
			offset = Vector2(params["x_offset"], params["y_offset"])
			s_camera_effect_done.emit()
		CameraEffects.PANNING:
			assert(params.has("x_offset") and params.has("y_offset") and params.has("panning_speed"), "MISSING PARAMS FOR PANNING CAMERA EFFECT")			
			panning(Vector2(params["x_offset"], params["y_offset"]), params["panning_speed"])
		CameraEffects.CENTER:
			offset = Vector2.ZERO
			s_camera_effect_done.emit()
		CameraEffects.ZOOM:
			zoom = Vector2(params["zoom_intensity"], params["zoom_intensity"])
			s_camera_effect_done.emit()
		CameraEffects.SCREEN_SHAKE:
			start_shake(params["shake_strength"], params["shake_decay"])
		_:
			print("NO CAMERA EFFECT IMPLEMENTATION FOR THE EFFECT: " + str(effect))

func reset_camera_params() -> void:
	offset = Vector2.ZERO
	zoom = Vector2.ONE

func panning(offset_vec : Vector2, panning_speed : float) -> void:
	var panning_tween = get_tree().create_tween()
	panning_tween.tween_property(self, "offset", offset_vec, panning_speed)
	panning_tween.finished.connect(on_effect_done)

func start_shake(start_shake_strength := 10.0, new_shake_decay := 10.0) -> void:
	current_offset = offset
	shake_strength = start_shake_strength
	shake_decay = new_shake_decay

func on_effect_done() -> void:
	s_camera_effect_done.emit()
