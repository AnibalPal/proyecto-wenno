@tool
@icon("res://assets/icons/built_in/CameraAttributesPractical.svg")
extends ComicEffectData
class_name ComicCameraEffectData

enum CameraEffects {
	RESET,
	SET_POSITION,
	PANNING,
	CENTER,
	ZOOM,
	SCREEN_SHAKE
}

@export var camera_effect := CameraEffects.SET_POSITION:
	set(value):
		match value:
			CameraEffects.SET_POSITION:
				camera_effect_params = {
					"x_offset": 0.0,
					"y_offset": 0.0
				}
			CameraEffects.PANNING:
				camera_effect_params = {
					"x_offset": 0.0,
					"y_offset": 0.0,
					"panning_speed": 1.0
				}
			CameraEffects.ZOOM:
				camera_effect_params = {
					"zoom_intensity": 1.0
				}
			CameraEffects.SCREEN_SHAKE:
				camera_effect_params = {
					"shake_strength": 10.0,
					"shake_decay": 10.0
				}
			_:
				camera_effect_params = {}
		camera_effect = value
		
@export var camera_effect_params := {}
