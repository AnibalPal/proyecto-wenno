extends Camera2D
class_name ComicCameraEffect

signal s_camera_effect_done

const CameraEffects = ComicCameraEffectData.CameraEffects

func play_camera_effect(effect : CameraEffects, params := {}) -> void:
	match effect:
		CameraEffects.SET_POSITION:
			assert(params.has("x_offset") and params.has("y_offset"), "MISSING PARAMS FOR SET_POSITION CAMERA EFFECT")
			global_position += Vector2(params["x_offset"], params["y_offset"])
			s_camera_effect_done.emit()
		CameraEffects.PANNING:
			assert(params.has("x_offset") and params.has("y_offset") and params.has("panning_speed"), "MISSING PARAMS FOR PANNING CAMERA EFFECT")			
			panning(Vector2(params["x_offset"], params["y_offset"]), params["panning_speed"])
		CameraEffects.CENTER:
			global_position = get_viewport_rect().size / 2
			s_camera_effect_done.emit()
		CameraEffects.ZOOM:
			print("TODO ZOOM EFFECT")
		_:
			print("NO CAMERA EFFECT IMPLEMENTATION FOR THE EFFECT: " + str(effect))

func panning(offset_vec : Vector2, panning_speed : float) -> void:
	var panning_tween = get_tree().create_tween()
	panning_tween.tween_property(self, "global_position", global_position + offset_vec, panning_speed)
	panning_tween.finished.connect(on_panning_done)

func on_panning_done() -> void:
	s_camera_effect_done.emit()
